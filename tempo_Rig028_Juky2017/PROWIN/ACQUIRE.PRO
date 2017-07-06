/* ACQUIRE.PRO - Example showing one way to acquire and hold a target.
**
** SYNOPSIS
**  When a bar is pressed, a target is displayed and the subject must
**  make a saccade (or hand movement) into the target within a limited
**  period of time.  The subject must remain within the target for a
**  period of time once the target is acquired.  If the subject is
**  successful, a high pitch tone is sounded.  A low tone is sounded
**  if the subject fails.
**
**  The structure of this protocol is extensible to more complex tasks
**  quite easily.  It provides an excellent example of how to organize
**  a protocol in terms of how to break functionality into various
**  processes.  It also illustrates a general structure for handling
**  errors (subject's failure to perform the task correctly) and how
**  a protocol can recover gracefully.
**
**  We trigger analog and spike databases aligned on the moment of entry
**  into the target.  Databases are harvested at the end of the hold period
**  provided the subject is within the target.  Otherwise, they are
**  cancelled.  It is important that the database period + extension
**  exceeds the target hold time. The trigger must mature after the hold
**  period is over in order to allow us to cancel the trigger request
**  when the subject fails to hold the target.
**
**  This task uses WORDPLAY to display the target.  We create a virtual
**  coordinate system on the WORDPLAY monitor and work with coordinates
**  in that domain.  To use VideoSYNC instead of WORDPLAY, simply change
**  all "send(..." to "dsend(..." and all "sendf(..." to "dsendf(...".
**
**  We also use TEMPO's real-time object graphs to display both the target
**  and the subject's current position.  TEMPO's SHOW M display lets you
**  see the target position and the subject's position.
**
**  The subject's X,Y eye position is assumed to be in the first two
**  analog input channels.  The bar is assumed to be connected to a
**  TTL that is mapped to a status bit (see BAR below).  Note that in
**  a live experiment, the analog channels may be mapped to eye coils
**  or a manipulandum.
**
** TESTING
**  Use KDEMO for development and testing.  The mouse is connected to
**  analog input channels 1 and 2 and the left and right mouse buttons 
**  are connected to bits in the status word.
**
** ANALOG CALIBRATION
**  For simplicity, we assume the full analog range of values corresponds
**  to the full video range and that the analog X,Y are linear.
**
** DIALOGS
**  Dialogs are available for this protocol.  Type DIALOG ACQUIRE at the
**  TEMPO command line.  Alternatively, the F1 key macro brings up the
**  dialogs.
**
** EDIT HISTORY
**  04 Aug 95 sh    Initial edit
**  28 Sep 95 sh    Add DIALOGs for the protocol
**  01 Sep 98 sh    Add DEBUG (=1 to use mouse values instead of analog inputs)
**  27 Dec 99 sh    Fix bug: WATCH_EYE: perform test for isinside every process
**                  cycle because either eye position or target can change!
**  15 Jun 01 sh    Declare processes
**  05 Jul 01 sh    Clear message window with system("cls") before each trial
**  09 Jan 06 sh    In process JUICE, divide juice_time by 6, not by 5
**                  Thanks to Dr Eiji Hoshi at Tamagawa University for this correction.
**  28 Sep 07 sh    In process TRIAL, the wait 5000 logically belongs after the if (!failed)
**                  test.  Thanks to Dr Ryuichi Matsuzaki at Kansai Medical University
**                  for pointing this out.
**                  The isInside global variable must be reset if either x,y or
**                  the target position (bx,by) or target size (xsize, ysize) change.
**                  Add process CheckIsInside() then call it in various places to insure
**                  isInside is up to date at all times.
**  30 Sep 07 sh    Process BUSYLOOP needed to define busy variable
*/
#pragma declare = 1                     // Require declarations of all variables
#include object.pro                     // Required when using object graphs

declare DEBUG = 0;                      // =0 for real analog, =1 for mouse input
declare AUTOMONKEY = 0;                 // =1 for automatic monkey

// serial.PRO for tempo KMT 8.0 Set 17
// Version 0.02
HIDE VERSION = 0, REVISION = 02; // 3/30/98
HIDE PRIMARY_DATABASES = 32;


declare hide constant XMAX  = 640;     // Video virtual coordinates
declare hide constant YMAX  = 400;

declare hide TrialCount = 0;            // # of trials run
declare hide SuccessCount = 0;          // # of successful trials

declare hide xsize          = 100;      // Size of target (in virt. coord)
declare hide ysize          = 100;

declare acquire_time        = 1500;     // Time to acquire target (ms)
declare hold_time           = 1000;     // Time to hold target (ms)
declare hide juice_time     = 300;      // Duration of reward (ms)

declare failed;                         // Error code
declare hide constant ERR_OK     = 0;   //  Task performed successfully
declare hide constant ERR_ACQUIRE= 1;   //  Failed to acquire target
declare hide constant ERR_HOLD   = 2;   //  Failed to hold target

// DECLARE MISC. VARIABLES

declare hide constant hex BAR = 0x10000000; // MIO TTL0 bit in status register
declare hide oB, oE;                    // Eye and Box objects (left graph)
declare hide oB1, oE1;                  // Eye and Box objects (right graph)
declare hide bx, by;                    // Upper left corner of target
declare hide ax, ay;                    // Current eye position (analog values)
declare x, y;                           // Current eye position (video coordinates)
declare isinside;                       // =1 iff subject is inside target

// DECLARE PROCESS NAMES

declare MAIN(), INIT(), TRIAL_LOOP(), WATCHEYE(), SETUP(), TRIAL(), JUICE(), FAILURE(), BOXON(), BOXOFF();
declare CheckIsInside();

//----------------------------------------------------------------------
// MAIN - Protocol starts here.

process MAIN() enabled
    {
    spawn INIT;                         // Initialize protocol
    waitforprocess INIT;                // Wait for INIT to finish

    spawn WATCHEYE;                     // Monitor the eye position
    print("Press F1 for HELP and other TEMPO dialogs.");
    spawn TRIAL_LOOP;                   // Start the trials
    
    system("dialog main");              // Pop up main dialog
    }

//----------------------------------------------------------------------
// INIT - Initialize protocol
process INIT
    {
    //system("SHOW M");                 // Automatically enters dialogs
    //system("DIALOG ACQUIRE");

    dsend("cl");                         // Clear WORDPLAY screen
    dsendf("vc 0,%d,0,%d\n", XMAX, YMAX);    // WORDPLAY virtual coordinates

    // SETUP UP TARGET & EYE OBJECTS IN LEFT GRAPH

    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX); // Object graph virt. coord
    oB = oCreate(tBOX, gLEFT, xsize, ysize);    // Create TARGET object
    oSetAttribute(oB, aINVISIBLE);              // Not visible yet

    oE = oCreate(txCross, gLEFT, 20, 20);       // Create EYE object
    oSetAttribute(oE, aVISIBLE);                // It's always visible

    dsendf("oc 1,3\n");                          // Cross hair for "eye"
    dsendf("ow 1,20,20\n");                      // width & height
    dsendf("oi 1,13\n");                         // color
    dsendf("os 1\n");                            // make visible

    // SETUP UP TARGET & EYE OBJECTS IN RIGHT GRAPH

    oSetGraph(gRIGHT, aRANGE, 0, XMAX, 0, YMAX);// Object graph virt. coord
    oB1 = oCreate(tBOX, gRIGHT, xsize, ysize);  // Create TARGET object
    oSetAttribute(oB1, aINVISIBLE);             // Not visible yet

    oE1 = oCreate(txCross, gRIGHT, 20, 20);     // Create EYE object
    oSetAttribute(oE1, aINVISIBLE);             // Visible only during a trial
    oSetAttribute(oE1, aREPLACE);               // Draw trace on right graph

    TrialCount = 0;                             // Zero out statistics
    SuccessCount = 0;
    }

//----------------------------------------------------------------------
// TRIAL_LOOP - This is the main experiment loop.

process TRIAL_LOOP
    {
    int     waitAutoMonkey;
    
    while (1)                           // Loop indefinitely..
        {
        if (AUTOMONKEY)
            {
            waitAutoMonkey = 1000 + random(8000);
            printf("Automonkey will press bar in %d ms\n", waitAutoMonkey);
            wait waitAutoMonkey;
            system("cls");
            while (system()) nexttick;  // Wait for CLS to complete
            }
        else if (DEBUG)
            {
            print("Waiting for left mouse button...");
            while (!(mouGetButtons() & 0x1))
                nexttick;               // Wait for left button down
            }
        else
            {
            print("Waiting for BAR press...");
            wson    BAR;                // Wait for real STATUS bit to go on
            }
            
        TrialCount = TrialCount + 1;    // Count one more trial
        printf("Starting trial %d..\n", trialCount);
        
        spawn SETUP;                    // Determine trial parameters
        waitforprocess SETUP;           // Wait for SETUP to finish
            
        spawn TRIAL;                    // Sequence through the trial
        waitforprocess TRIAL;           // Wait for TRIAL to finish

        if (!failed)
            {
            printf("Trial %d SUCCESSFUL\n", trialCount);
            spawn JUICE;                // Subject performed task successfully
            }
        else
            {
            printf("Trial %d FAILED\n", trialCount);
            spawn FAILURE;              // Subject failed task.
            }

        // END OF TRIAL.  INSERT AN INTERTRIAL WAIT TIME HERE, IF DESIRED.

        nexttick;                       // Guarantee one wait.
        }
    }

//----------------------------------------------------------------------
// SETUP - Define trial parameters

process SETUP
    {
    bx = random(XMAX - xsize);          // X position of target
    by = random(YMAX - ysize);          // Y position of target
    
    spawnwait CheckIsInside();          // Update isInside
    }

//----------------------------------------------------------------------
// TRIAL - Sequence through the task one step at a time.
// If at any point the subject fails, the task fails and the "failed"
// flag is set to a number indicating the type of error.  The remainder
// of the task is aborted.

process TRIAL
    {
    declare hide end;                   // end point in time.
    declare start_time;

    oSetGraph(gRIGHT, aCLEAR);          // Clear history in right graph
    oSetAttribute(oE1, aVISIBLE);       // Visible only during a trial
    failed = ERR_OK;                    // Assume success
    start_time = time();                // Note current time
    trigger 1;                          // Request data collection at stimulus onset

    spawnwait CheckIsInside();          // Update isInside

    spawn BOXON;                        // Turn on target

    if (!failed)                        // As long as we haven't failed..
        {
        end = time() + acquire_time;    // Mark end point in time
        while (time() < end && !isinside)// Wait for subject..
            nexttick;                   // ..to acquire target
        if (!isinside)                  // Is subject inside target?
            failed = ERR_ACQUIRE;       // No, failed to acquire box in time.
        }
        
    if (!failed)                        // As long as we haven't failed..
        {
        trigger 2;                      // Request data collection at target entry
        event_set(1,1);                 // Mark this as latency
        printf("Latency %d ms\n", time() - start_time);

        end = time() + hold_time;       // Mark end point in time
        while (time() < end && isinside)// Wait for subject..
            nexttick;                   // ..to hold target
        if (!isinside)                  // Did subject hold target?
            {
            failed = ERR_HOLD;          // No, note the reason for failure.
            }
        }

    wait 5000;                          // Delay 5 seconds
    
    spawn BOXOFF;                       // Turn the target off

    // AT THIS POINT, YOU CAN ADD MORE LOGIC TO MAKE THE TASK MORE COMPLEX.
    // FOR INSTANCE, YOU CAN HAVE A SECOND TARGET AND REQUIRE THE SUBJECT
    // TO SACCADE TO IT.  THE STRUCTURE OF THIS WOULD MIRROR WHAT WE'VE DONE
    // ABOVE.

    oSetAttribute(oE1, aINVISIBLE);     // Visible only during a trial

    if (!failed)                        // Was the trial successful?
        {
        harvest 1;                      // Yes, force data accumulation
        harvest 2;                      // Yes, force data accumulation
        SuccessCount = SuccessCount + 1;// Count successes
        }
    else
        {                               // Trial failed
        cancel_set(1);                  // Cancel trigger with request to set cancel bit
        nexttick;                       // ..wait one process cycle
        cancel_clr(1);                  // then request to clear cancel bit
        }
    }

//----------------------------------------------------------------------
// WATCHEYE - This process monitors eye (hand) position.  It is started
// by MAIN and runs every process cycle so it is important to minimize
// the computations done here.  WATCHEYE does the following:
//  1. updates ax, ay as the current analog values for X,Y position
//  2. maps ax,ay to x,y in our video (virtual) coordinate system
//  3. set isinside=1 if and only if x,y is inside the target
//  4. moves the EYE object to the new x,y position

process WATCHEYE
    {
    declare hide oldx, oldy;            // Last eye position
    declare bxc, byc, axc, ayc;

    while (1)                           // Loop indefinitely..
        {
        if (AUTOMONKEY)
            {                           // Fabricate "fake" position automatically
                                        // in analog values
            bxc = bx + xsize/2;         // Target center in video coord
            byc = by + ysize/2;
            axc = (bxc * 4096)/XMAX - 2048; // Target center in analog coord
            ayc = (byc * 4096)/YMAX - 2048; // Target center in analog coord
            
            ax = ax + (axc - ax) / 50; // Go part way to target from previous loc
            ay = ay + (ayc - ay) / 50; // Go part way to target from previous loc
            
            ax = ax + 25 - random(50);
            ay = ay + 25 - random(50);
            }
        else if (DEBUG)                 // Which kind of input should we use?
            {
            ax = mouGetX();             // Get manual "fake" position from Mouse
            ay = mouGetY();
            }
        else
            {
            ax = atable(1);             // Get actual analog values
            ay = atable(2);
            }
            
        // At this point, the protocol doesn't know (or care) where
        // the data in ax,ay came from.  It uses it as if it were
        // actual eye position data from an eye coil.  If DEBUG is
        // 0, the data is retrieved from the analog card. If DEBUG is
        // not zero (eg, 1), the data is retrieved from the server mouse.
        // You can set DEBUG=0 or DEBUG=1 from TEMPO's command line
        // while the protocol is running.

        x = (XMAX * (ax + 2048)) / 4096;// Map to video coordinates
        y = (YMAX * (ay + 2048)) / 4096;
        
        if (x != oldx || y != oldy)     // If position has changed..
            {
            oMove(oE, x, y);            // ..Update eye object
            oMove(oE1, x, y);           // ..Update eye object
            dsendf("om 1,%d,%d\n", x, y); // .. Move sprite

            oldx = x;                   // This is the new position
            oldy = y;
            
            spawnwait   CheckIsInside(); // x,y changed; update isinside
            }
            
        nexttick;                       // Wait one process cycle
        }
    }
    
    

//----------------------------------------------------------------------
// CHECKISINSIDE - Updates the isInside global variable.
// This must be called whenever the target position (bx, by, xsize
// or ysize) changes or when the x,y changes.
//
// IN
//      No args
//      x, y                    Mouse/eye position
//      bx, by, xsize, ysize    target position and size
//
// OUT
//      isInside

process CheckIsInside()
{
// CHECK TO SEE IF THE CURRENT POSITION IS INSIDE THE TARGET.
// WE DO THIS EVERY PROCESS CYCLE BECAUSE EITHER THE CURRENT
// EYE POSITION OR THE TARGET CAN CHANGE LOCATION.  THIS
// INSURES THAT THE isinside VARIABLE IS UP TO DATE FOR EVERY
// PROCESS CYCLE.

if (x >= bx && x <= bx + xsize && y >= by && y <= by + ysize)
    {
    //if (!isinside)
    //    print("Entered target..");
    isinside = 1;               // Subject is inside target
    }
else
    isinside = 0;               // Subject is not inside target
}
    

//----------------------------------------------------------------------
// BOXON - Turn target on.

process BOXON
    {
    //printf("BOXON (bx,by) = (%d,%d)  (x,y) = (%d,%d)\n", bx, by, x, y);
    dsend("oh 1");                           // Hide "eye" sprite
    dsend("co 15");                          // Set color to WHITE
    dsendf("ru %d,%d,%d,%d\n", bx, by, bx + xsize, by + ysize);  // Rectangle filled

    oMove(oB, bx + xsize/2, by + ysize/2);  // Move target
    oSetAttribute(oB, aSIZE, xsize, ysize); // Reset target size
    oSetAttribute(oB, aVISIBLE);            // Make it visible

    oMove(oB1, bx + xsize/2, by + ysize/2); // Move target
    oSetAttribute(oB1, aSIZE, xsize, ysize);// Reset target size
    oSetAttribute(oB1, aVISIBLE);           // Make it visible
    dsend("os 1");                           // Show "eye" sprite
    }

//----------------------------------------------------------------------
// BOXOFF - Turn target off.

process BOXOFF
    {
    dsend("oh 1");                       // Hide "eye" sprite
    dsend("co 0");                       // Set color to BLACK
    dsendf("ru %d,%d,%d,%d\n", bx, by, bx + xsize, by + ysize);
    oSetAttribute(oB, aINVISIBLE);      // Hide BOX object
    oSetAttribute(oB1, aINVISIBLE);     // Hide BOX object
    dsend("os 1");                       // Show "eye" sprite
    }

//----------------------------------------------------------------------
// JUICE - Turn on TTL for a period of time.  Also sound tone.
// The TTL that is toggled by mio_dig_set(1, 1) is on the digital
// outputs of the analog board.
// For the PCI-DAS1602, the particular TTL line is based on the
// DAS_DIGITALIN setting.  See the kernel CFG for details.
// 
// For the PCI-DAS1602, the following TTLs are defined based
// on the DAS_DIGITALIN parameter in the kernel CFG file:
// 
//      DAS_DIGITALIN    Inputs             Outputs
//      -------------    -----------------  -------------------
//      0                none               A0-A7, B0-B7, C0-C7
//      8                A0-A7              B0-B7, C0-C7
//      16               A0-A7,B0-B7        C0-C7
//      20               A0-A7,B0-B7,C0-C3  C4-C7
//      24               A0-A7,B0-B7,C0-C7  none
//
// If DAS_DIGITALIN=8 (default), the TTL bit for the juice solenoid
// is B1 (pin 60).  It is not B0 (pin 59) because the mio_dig_set()
// function's first argument (line number) starts at 0, not 1.

process JUICE
    {
    mio_dig_set(1, 1);                  // Turn on TTL to juice solenoid
    sound(500);                         // Also sound high pitched tone

    wait juice_time / 6;                // Wait a period of time (ms)
    sound(0);
    wait juice_time / 6;                // Wait a period of time (ms)

    sound(500);                         // Also sound high pitched tone
    wait juice_time / 6;                // Wait a period of time (ms)

    sound(0);
    wait juice_time / 6;                // Wait a period of time (ms)

    sound(500);                         // Also sound high pitched tone
    wait juice_time / 6;                // Wait a period of time (ms)

    sound(0);
    
    sound(500);                         // Also sound high pitched tone
    wait juice_time / 6;                // Wait a period of time (ms)

    sound(0);
    
    mio_dig_set(1, 0);                  // Turn off TTL to juice solenoid
    }

//----------------------------------------------------------------------
// FAILURE - Sound low tone and print message based on type of failure.

process FAILURE
    {
    if (failed == ERR_ACQUIRE)      printf("Failed to acquire target within %d ms.\n", acquire_time);
    else if (failed == ERR_HOLD)    printf("Failed to hold target for %d ms.\n", hold_time);

    sound(100);
    wait juice_time * 3;                // Wait longer than success time
    sound(0);
    }

//----------------------------------------------------------------------
// BUSYLOOP - loop indefinitely
//
// The BUSYLOOP process is here as an example of a process that
// attempts to loop indefinitely.  It has no particular relevance to
// the ACQUIRE task.
// 
// If you spawn BUSYLOOP, you will find that the kernel will
// automatically suspend BUSYLOOP after a period of time. It is here to
// illustrate what happens if a process tries to do more than what is
// possible within a single process cycle and to show that this does
// not "crash" TEMPO.

process BUSYLOOP                        // Dummy process to show
    {                                   // what the kernel does when a process
    int     busy;
    
    busy = 0;
    while (busy < 500)                  // takes too long to execute
        {
        busy = busy + 1;
        // Note there is no wait statement in this while loop
        }
    }


//----------------------------------------------------------------------
// saveVSScreen - Saves a copy of the VideoSYNC screen to a PCX file on the VS computer
// The PCX file names are 0.pcx, 1.pcx, 2.pcx, ..., and are stored in the RAM drive
// on the VideoSYNC computer.
// This process is spawned from a dialog button.

process saveVSscreen()
{
    int         nPCX = 0;               // Next #.PCX to use
    
dsendf("IS 0,0,%d,%d,%d.pcx\n", XMAX, YMAX, nPCX);      // Store PCX file in RAM drive
//dsendf("IS 0,0,%d,%d,A:%d.pcx\n", XMAX, YMAX, nPCX);  // Store PCX file in A: drive

printf("saveVSscreen - Saved %d.PCX\n", nPCX);

nPCX = nPCX + 1;                        // Advance to next PCX filename
}
