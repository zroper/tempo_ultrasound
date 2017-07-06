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
*/
#pragma declare = 1                     // Require declarations of all variables
#include object.pro                     // Required when using object graphs

declare DEBUG = 1;                      // =0 for real analog, =1 for mouse input

// serial.PRO for tempo KMT 8.0 Set 17
// Version 0.02
HIDE VERSION = 0, REVISION = 02; // 3/30/98
HIDE PRIMARY_DATABASES = 32;


declare hide constant XMAX  = 1024;     // Video virtual coordinates
declare hide constant YMAX  = 768;

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

//----------------------------------------------------------------------
// MAIN - Protocol starts here.

process MAIN enabled
    {
    spawn INIT;                         // Initialize protocol
    waitforprocess INIT;                // Wait for INIT to finish

    spawn WATCHEYE;                     // Monitor the eye position
    print("Press F1 for HELP and other TEMPO dialogs.");
    spawn TRIAL_LOOP;                   // Start the trials
    }

//----------------------------------------------------------------------
// INIT - Initialize protocol
process INIT
    {
    //system("SHOW M");                 // Automatically enters dialogs
    //system("DIALOG ACQUIRE");

    send("cl");                         // Clear WORDPLAY screen
    sendf("vc 0,%d,0,%d\n", XMAX, YMAX);    // WORDPLAY virtual coordinates

    // SETUP UP TARGET & EYE OBJECTS IN LEFT GRAPH

    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX); // Object graph virt. coord
    oB = oCreate(tBOX, gLEFT, xsize, ysize);    // Create TARGET object
    oSetAttribute(oB, aINVISIBLE);              // Not visible yet

    oE = oCreate(txCross, gLEFT, 20, 20);       // Create EYE object
    oSetAttribute(oE, aVISIBLE);                // It's always visible

    sendf("oc 1,3\n");                          // Cross hair for "eye"
    sendf("ow 1,20,20\n");                      // width & height
    sendf("oi 1,13\n");                         // color
    sendf("os 1\n");                            // make visible

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
    while (1)                           // Loop indefinitely..
        {
        spawn SETUP;                    // Determine trial parameters

        print("Waiting for bar...");
        if (DEBUG)
            {
            while (!(mouGetButtons() & 0x1))
                nexttick;               // Wait for left button down
            }
        else
            wson    BAR;                // Wait for real STATUS bit to go on

        spawn TRIAL;                    // Sequence through the trial
        waitforprocess TRIAL;           // Wait for TRIAL to finish

        if (!failed)
            spawn JUICE;                // Subject performed task successfully
        else
            spawn FAILURE;              // Subject failed task.

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

    TrialCount = TrialCount + 1;
    oSetGraph(gRIGHT, aCLEAR);          // Clear history in right graph
    oSetAttribute(oE1, aVISIBLE);       // Visible only during a trial
    failed = ERR_OK;                    // Assume success
    start_time = time();                // Note current time
    trigger 1;                          // Request data collection at stimulus onset

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

    while (1)                           // Loop indefinitely..
        {
        if (DEBUG)                      // Which kind of input should we use?
            {
            ax = mouGetX();             // Get "fake" position from Mouse
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
            sendf("om 1,%d,%d\n", x, y); // .. Move sprite

            oldx = x;                   // This is the new position
            oldy = y;
            }
            
        // CHECK TO SEE IF THE CURRENT POSITION IS INSIDE THE TARGET.
        // WE DO THIS EVERY PROCESS CYCLE BECAUSE EITHER THE CURRENT
        // EYE POSITION OR THE TARGET CAN CHANGE LOCATION.  THIS
        // INSURES THAT THE isinside VARIABLE IS UP TO DATE FOR EVERY
        // PROCESS CYCLE.

        if (x >= bx && x <= bx + xsize && y >= by && y <= by + ysize)
            {
            if (!isinside) print("Entered target..");
            isinside = 1;               // Subject is inside target
            }
        else
            isinside = 0;               // Subject is not inside target

        nexttick;                       // Wait one process cycle
        }
    }

//----------------------------------------------------------------------
// BOXON - Turn target on.

process BOXON
    {
    send("oh 1");                           // Hide "eye" sprite
    send("co 15");                          // Set color to WHITE
    sendf("ru %d,%d,%d,%d\n", bx, by, bx + xsize, by + ysize);  // Rectangle filled

    oMove(oB, bx + xsize/2, by + ysize/2);  // Move target
    oSetAttribute(oB, aSIZE, xsize, ysize); // Reset target size
    oSetAttribute(oB, aVISIBLE);            // Make it visible

    oMove(oB1, bx + xsize/2, by + ysize/2); // Move target
    oSetAttribute(oB1, aSIZE, xsize, ysize);// Reset target size
    oSetAttribute(oB1, aVISIBLE);           // Make it visible
    send("os 1");                           // Show "eye" sprite
    }

//----------------------------------------------------------------------
// BOXOFF - Turn target off.

process BOXOFF
    {
    send("oh 1");                       // Hide "eye" sprite
    send("co 0");                       // Set color to BLACK
    sendf("ru %d,%d,%d,%d\n", bx, by, bx + xsize, by + ysize);
    oSetAttribute(oB, aINVISIBLE);      // Hide BOX object
    oSetAttribute(oB1, aINVISIBLE);     // Hide BOX object
    send("os 1");                       // Show "eye" sprite
    }

//----------------------------------------------------------------------
// JUICE - Turn on TTL for a period of time.  Also sound tone.

process JUICE
    {
    mio_dig_set(1, 1);                  // Turn on TTL to juice solenoid
    sound(500);                         // Also sound high pitched tone

    wait juice_time / 5;                // Wait a period of time (ms)
    sound(0);
    wait juice_time / 5;                // Wait a period of time (ms)

    sound(500);                         // Also sound high pitched tone
    wait juice_time / 5;                // Wait a period of time (ms)
    sound(0);
    wait juice_time / 5;                // Wait a period of time (ms)

    sound(500);                         // Also sound high pitched tone
    wait juice_time / 5;                // Wait a period of time (ms)

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

process BUSYLOOP                        // Dummy process to show
    {                                   // what the kernel does when a process
    x = 0;
    while (x < 500)                     // takes too long to execute
        {
        x = x + 1;
        // Note there is no wait statement in this while loop
        }
    }
