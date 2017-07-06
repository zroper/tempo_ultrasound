// HOPEN.PRO - Example of using HOPEN
//
// This example compares different methods for creating databases.
// In particular, it compares creating a database in the .CFG (or .PCF
// file for TEMPO/win) with the HOPEN command which is used to create
// databases from within your protocol.
//
// For these examples, we assume SPEED=1000 (i.e., acquisition rate is
// 1000 Hz).
//
// Suppose you want to create a database in your protocol as follows.
//
//  100 bins of data, are collected.  Each bin has binwidth of .01.
//  The total duration is 1 second.  The first data point represents
//  the moment in time 100 ms prior to the trigger.
//
//          -100ms.......0...........................890ms
//                       |
//                       ^trigger
//
// When using HEDIT followed by CSAVE, the CFG file looks like:
//
//  SPEED=1000              1000 Hz acquisition
//  H1.FUNC=XSUM            =type 6
//  H.TPB=10                10/1000 = .01 sec binwidth
//  H.OFFSET=100            100/1000 = .1 sec offset (prior to trigger)
//  H.PERIOD=1000           1000/1000 = 1 sec duration
//  H.FIRST_CHANNEL=2       Channels 2,3 and 4
//  H.CHANNELS=3
//  H.SWEEPS=20             20 epochs
//  H.TAG=1
//
// For TEMPO/Win users, the .PCF file contains:
//      
//      SPEED 1000
//      HOPEN  1,6,1,2,3,20,100,10,0,9,0x0
//
// The following are the 11 parameters to the HOPEN command.
// To create the same database dynamically in your protocol, use the
// following HOPEN command.

int db;     // [1..DATABASES]      Database number
int type;   // [0..7]              Type of database
            //     0                   Analog averge 8 bit (SUM)
            //     1                   Analog append 8 bit (APP)
            //     2                   Counter average 16 bit (USUM)
            //     3                   Counter append 16 bit (UAPP)
            //     4                   Event average 16 bit (ESUM)
            //     5                   Event append 16 bit (EAPP)
            //     6                   Analog average 12/16 bit (XSUM)
            //     7                   Analog average 12/16 bit (XAPP)
int tag;    // [0..65535]          Database tag
int fchan;  // [1..n]              First channel
int nchan;  // [1..]               Number of channels
int nsweeps;// [1..]               Number of sweeps
int period; // [1..]               Period (units of analog acquisition rate)
int offset; // [1..]               Offset (units of analog acquisition rate)
int extent; // [1..]               Extension (units of analog acquisition rate)
int tpb;    // [0..n]              TPB (# of ring buffer bins per db bin)
int cancel; // [0..]               Cancel override

// This example creates DB 2 which should have the same parameters as
// DB 1.  DB 1 is created when the protocol configuration file (.CFG or
// .PCF) is loaded with CLOAD.

process MAIN enabled
    {
    db = 2;                         // Use database 2 (1 is used by CFG file)

    if (htb_handle(db))             // Does DB already exist?
        {
        systemf("HZERO %d\n", db);      // Zero data
        systemf("HREMOVE %d\n", db);    // Remove it if it exists
        }

    type = 6;                       // XSUM
    tag = 1;                        // database TAG
    fchan = 2;                      // first analog channel to collect
    nchan = 3;                      // # of channels to collect
    nsweeps = 20;                   // # of epochs to collect
    period = 100;                   // duration of an epoch in (TPB+1)/SPEED second units
    offset = 10;                    // trigger offset in (TPB+1)/SPEED second units
    extent = 0;                     // extension in (TPB+1)/SPEED second units

    // Note that the TPB in the CFG file is 1-based while
    // the TPB in the HOPEN is 0-based.  Thus  h1.tpb=10 in the CF
    // file refers to 10/1000 = .01 second binwidth while we specify
    // TPB=9 here because it is 0-based in the HOPEN command.
    //
    // The DB binwidth = (tpb+1)/speed.
    // In our example, = (9+1)/1000 = .01 sec or 10 ms per DB bin

    tpb = 9;                        // = 10ms DB binwidth, 0-based number
    cancel = 0x0;                   // 32 bit cancel override

    // The HOPEN command is formed from several calls to systemf().
    // because PCL only supports up to 6 arguments to a function,
    // we have to build the command by calling systemf() three times.
    // On the final call, we end with '\n' which causes the string
    // we've built to be sent to TEMPO to be executed.  The command
    // we build is:
    //
    //      HOPEN  2,6,1,2,3,20,100,10,0,9,0

    systemf("HOPEN %d,%d,%d,%d,%d,", db, type, tag, fchan, nchan);
    systemf("%d,%d,%d,%d,%d,", nsweeps, period, offset, extent, tpb);
    systemf("%d\n", cancel);

    while (system())
        nexttick;           // Wait for database to be created

    print("Done.");         // Use SHOW H to see that DB 1 properties == DB 2
    }
