// CCQTEMPO.PRO - Test TEMPO triggering COBALT databases.
//
// TEMPO's debug kernel executes mio_ao_set(0,1000) on every interrupt.
// We clear it here.  This is the "data" that COBALT collects.
// The pulse is too short for TEMPO to collect at 1 Khz but
// COBALT sees it and the "spike" should be synchronous with the
// moment of the trigger.

// 21Apr05 If you are using PCI-DAS1602 boards on both COBALT and
// TEMPO, connect AOUT0 on TEMPO (pci-das1602 pin 36) to Analog input
// channel 3 (see CCQCOBALT.PCF, pci-das1602 pin 6).  This causes
// COBALT's channel 3 to receive the analog output pulse from TEMPO's
// AOUT0.  Note: setCobaltTest() is an undocumented function that
// is only used to verify synchronization between TEMPO and COBALT.
//
// 09Aug06 The duration of the TTL pulse that TEMPO produces on a
// 330Mhz Pentium II processor can be as short as 50-70 uSec. If your
// COBALT server is collecting data at SPEED=100000, this means that
// about 5-7 samples will have the higher pulse values. It also means
// that if your COBALT system is set to collect data at a slower rate
// (ie SPEED=5000), aliasing may occur and the COBALT system may
// occasionally miss the short duration pulse that TEMPO is producing.
// So the data you get with the slower acquisition rate may appear to
// have missing pulses in it. This is because the slower acquisition
// rate is too slow to catch every pulse (it violates Nyquest's
// sampling law which says that you must sample at a rate atleast twice
// the maximum frequency of a phenomena you are observing in order to
// catch every occurence of that phenomena.

#include    cobalt.pro                  // COBALT declarations

int     nCobalt = COBALT1;              // Cobalt system to monitor [0..NCOBALTS)
int     tempoTick;                      // Time use for COBALT synchronization
int     pauseDataCollection = 0;        // Dialog sets to 1 to pause collection

declare AOCLEAR();                      // Clears AOUT0 every process cycle
declare DATABASE1();                    // Triggers DBs with tag 1
declare DATABASE2();                    // Triggers DBs with tag 2
declare WaitForCobaltDB(int nCobalt, int nDb); // Waits for COBALT DB to accumulate


//-------------------------------------------------------------
process MAIN
{
// Enable AOUT0, set Process Cycle TSC to TSC when AOUT0 is set

setCobaltTest(3);                       // Enable debugging mode
spawn AOCLEAR();                        // Reset AOUT0 every process cycle

wait 5000;                              // Wait enough time to collect some data

spawn DATABASE1();                      // Start recording
spawn DATABASE2();                      // Start recording
}



//-------------------------------------------------------------
// Clear Analog output 0 every process cycle.
// Analog output 0 is set to +5v at the beginning of every process cycle
// when setCobaltTest(3) is called (this sets the kernel in a diagnostic
// mode and is generally not done in normal protocols).

process AOCLEAR()
{
while (1)
    {
    mio_ao_set(0,0);                    // TEMPO's debug kernel sets to 1000 each interrupt
    tempoTick = tempoCobaltTick();      // Time Used for COBALT synchronization
    nexttick;
    }
}



//-------------------------------------------------------------
// Trigger database tag 1

process DATABASE1()
{
    int     nDb = 1;
    int     tag;
    int     nMaxEpochs;
    
tag = 1;                                // Trigger TAG for this database
nMaxEpochs = 20;                        // Max number of epochs to collect

while (1)
    {
    if (pauseDataCollection)
        {
        printf("DATABASE1 - Pausing data collection..\n");
        while (pauseDataCollection)
            nexttick;
        printf("DATABASE1 - Resuming data collection..\n");
        }
    
    wait    3000;                       // Delay for a few seconds
    trigger tag;                        // Trigger data collection

    wait    150;                        // Delay less than 250 ms
                                        // (so DB 1 shows zeros after this point)
    harvest tag;                        // Accumulate database now
    
    
    if (htb_sweep(nDb) == nMaxEpochs)
        {
        // Zero out COBALT and TEMPO DB
        
        systemf("remote quiet hzero %d\n", nDb);    // COBALT
        systemf("hzero %d\n", nDb);     // TEMPO
        
        while(systemf()) nexttick;      // Wait for DBs to zero
        }
    }

}



//-------------------------------------------------------------
// Trigger database tag 2

process DATABASE2()
{
    int     nDb = 2;
    int     tag;
    int     nMaxEpochs;
    
tag = 2;                                // Trigger TAG for this database
nMaxEpochs = 10;                        // Max number of epochs to collect

while (1)
    {
    if (pauseDataCollection)
        {
        printf("DATABASE2 - Pausing data collection..\n");
        while (pauseDataCollection)
            nexttick;
        printf("DATABASE2 - Resuming data collection..\n");
        }
    
    wait    5000;                       // Delay for a few seconds
    trigger tag;                        // Trigger data collection
    
    // We don't harvest this one.  Rather, we let TEMPO and COBALT
    // accumulate them once all their data is available.
    
    
    //printf("Triggered COBALT %d nDB %d (cobaltDBnEpochs[]=%d\n",
    //    nCobalt, nDb, cobaltDBnEpochs[nCobalt, nDb-1]);
    
    if (cobaltDBnEpochs[nCobalt, nDb-1] >= nMaxEpochs)
        {
        // Wait for COBALT to process all triggers
        
        printf("DATABASE2: Waiting for COBALT to process all triggers ..\n");
        
        spawnwait WaitForCobaltDB(nCobalt, nDb-1);
        
        // Now save & zero Database
        
        // Debug statement
        //printf("COBALT %d DB %d has %d epochs\n",
        //    nCobalt,
        //    nDb,
        //    cobaltDBnEpochs[nCobalt, nDb]);

        printf("DATABASE2: Zeroing databases..\n");
        
        systemf("remote quiet hzero %d\n", nDb);   // Zero COBALT's DB  
        systemf("hzero %d\n", nDb);                // Zero TEMPO's DB
        
        while (systemf()) nexttick;                // Wait for completion

        printf("DATABASE2: Databases have been zeroed..\n");
        }
    }
}



// -----------------------------------------------------------------------
// WaitForCobaltDB - Wait for all triggers for a COBALT database to mature
// (accumulate or be cancelled).
//
// IN
//      nCobalt         Cobalt Client System Number [0,1,..,NCOBALTS)
//                      NOTE: nCobalt is 0-based
//      nDb             Cobalt Database on COBALT client [0,1,..,NCOBALTDBS)
//                      NOTE: nDb is 0-based
//
// OUT
//      The WaitForCobaltDB() process returns when the COBALT system has processed
//      all triggers for specified database up to the time the WaitForCobaltDB()
//      process was spawned.

process WaitForCobaltDB(int nCobalt, int nDb)
{
    int     currentTick;                // Current TEMPO tick time
    
// Wait for COBALT to process all triggers up to this point in time

currentTick = tempoCobaltTick();        // Time Used for COBALT synchronization

printf("WaitForCobaltDB waiting for DB %d cobaltTick[%d]=%d < %d..\n",
    nDb+1, nCobalt, 
    cobaltTick[nCobalt],
    currentTick);

while (cobaltTick[nCobalt] <= currentTick)
    nexttick;
    
// Wait for COBALT to process all triggers for this db

printf("WaitForCobaltDB waiting for DB %d cobaltDBnPending[%d,%d]..\n", nDb+1, nDb, nCobalt);

while (cobaltDBnPending[nCobalt, nDb])
    nexttick;
    
printf("WaitForCobaltDB completed wait for COBALT %d DB %d\n",
    nCobalt, nDb+1);
printf("  CobaltTime=%d  TempoTime=%d\n", cobaltTick[nCobalt], tempoCobaltTick());
}

