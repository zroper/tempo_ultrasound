/* LEARN.PRO - Demonstration training protocol.

A trial begins when the monkey presses a bar.  A cue is displayed for a
short period of time.  To succeed, the monkey must look at the box within
a limited period of time.  

If successful, data is collected into three databases: spikes, analogs and
events.  On failures, we don't collect data but we could by simply
triggering another database tag.

Event codes are stored in event channel #1 corresponding to bar press and
release.

Analog channels 1 & 2 are connected to eye coils.  For demonstration,
these values are set by the mouse position.  

The bar switch is normally connected to an MIO TTL input but for
demonstration, we simply use the left mouse button.

Note: KDEMO KERNEL is required for using the mouse with this protocol.
      WORDPLAY/sound is required
*/

#include object.pro                 // Definitions for animated windows

     bar = 0;                       // State of Bar (0=released, 1=pressed)
hide E_BAR_PRESS = 1;               // Event code when bar is pressed
hide E_BAR_RELEASE = 2;             // Event code when bar is released

hide XMAX = 1000, YMAX = 1000;      // Dimensions of virtual screen
hide boxXsize = 100, boxX = 100;    // Size and location of FP
hide boxYsize = 100, boxY = 100;
hide boxColor = 15;                 // Color of box

hide oEYE, oFP, ntrials;            // Hide unimportant variables
hide color_of_box, timeout;
hide aX, aY, eyeX, eyeY;

//-----------------------------------------------------------------------
process MAIN enabled
    {   
    //send("vi 261");                 // Clear all WORDPLAY parameters
    //wait    4000;                   // Wait for WORDPLAY to reset
    sendf("cl; vc 0,%d,0,%d\n", XMAX, YMAX);

    system("show m");
    oSETGRAPH(gLEFT, aRANGE, 0, XMAX, 0, YMAX);   // screen coordinates
    oEYE = oCREATE(txCROSS, gLEFT, 10, 10);
    oFP = oCREATE(tBOX, gLEFT, boxXsize, boxYsize);
    oSETATTRIBUTE(oFP, aINVISIBLE);         // FP is initially hidden

    spawn WATCH_BAR;
    spawn WATCH_EYE;
    while (ntrials < 1000)
        {
        ntrials = ntrials + 1;

        trial_type = 1;                     // Select a trial type
        color_of_box = 15;                  // draw white box

        if (successes >= 3)                 // Reduce box size when
            {                               // when monkey learns task
            if (boxXsize > 20)
                {
                boxXsize = boxXsize / 2;
                boxYsize = boxYsize / 2;
                }
            successes = 0;
            failures = 0;
            }

        if (failures >= 4)                  // Increase box size when
            {                               // when monkey fails too much
            if (boxXsize < 200)
                {
                boxXsize = boxXsize * 2;
                boxYsize = boxYsize * 2;
                }
            successes = 0;
            failures = 0;
            }

        boxX = random(XMAX - boxXsize);     // Position it somewhere
        boxY = random(YMAX - boxYsize);     // on the screen

        print("Trial", ntrials, "Waiting for bar press (left button)");
        while (!bar) nexttick;              // Wait for bar press
        print();                            // Clear message area

        spawn box_on;                       // Turn FP on
        wait  250;                          // Allow monkey to reach FP

        // Wait for timeout or for monkey to look at box

        timeout = time() + 1000;            // FP on time
        while (time() < timeout && !looking_at_fp)
            nexttick;                       // Wait for one OR the other

        if (looking_at_fp)                  // Check to see if monkey
            {                               // ..was looking at box
            successes = successes + 1;
            failures = 0;
            print("Success", successes);    // Report successes
            spawn JUICE;
            trigger trial_type;             // Collect data
            wait 500;                       // Leave it on for awhile
            spawn box_off;                  // Erase FP
            }
        else
            {
            successes = 0;
            failures = failures + 1;
            spawn BUZZER;
            print("Failure", failures);     // Report failures
            spawn box_off;                  // Erase FP
            }

        wait 300;                           // Intertrial time

        print("Trial", ntrials, "Waiting for bar release");
        while (bar) nexttick;               // Wait for bar release
        print();                            // Clear message area
        }        
    }

//-----------------------------------------------------------------------
process box_on
    {
    send("co", boxColor);                   // Set draw color
    send("rf", boxX, boxY,
          boxX + boxXsize, boxY + boxYsize);// Draw box

    oSETATTRIBUTE(oFP, aSIZE, boxXsize, boxYsize);   // Set box size
    oMove(oFP, boxX + boxXsize/2, boxY + boxYsize/2);// Set position
    oSETATTRIBUTE(oFP, aVISIBLE);                    // Make visible
    }

//-----------------------------------------------------------------------
process box_off
    {
    send("cl");                             // Clear screen
    oSETATTRIBUTE(oFP, aINVISIBLE);         // Hide box object
    }

//-----------------------------------------------------------------------
process WATCH_BAR
    {
    while (1)
        {
        while ((mouGetButtons() & 1) == 0)
            nexttick;

        event_set(1, 0, E_BAR_PRESS);       // Bar has been pressed
        bar = 1;

        while ((mouGetButtons() & 1) == 1)
            nexttick;

        event_set(1, 0, E_BAR_RELEASE);     // Bar has been released
        bar = 0;
        }
    }

//-----------------------------------------------------------------------
process WATCH_EYE
    {
    oSETATTRIBUTE(oEYE, aVISIBLE);
    while (1)
        {
        aX = atable(1);                     // Retrieve current eye position
        aY = atable(2);                     // ..as analog values.
        eyeX = XMAX * (aX - -2047) / 4098;  // Map analog to video coordinates
        eyeY = YMAX * (aY - -2047) / 4098;

        oMOVE(oEYE, eyeX, eyeY);            // Move eyeball

        if (eyeX > boxX && eyeX < boxX+boxXsize &&
            eyeY > boxY && eyeY < boxY+boxYsize)
                looking_at_fp = 1;
        else
                looking_at_fp = 0;

        nexttick;                           // Sleep one process cycle
        }
    }

//-----------------------------------------------------------------------
process JUICE
    {
    sound(500);
    wait 200;
    sound(0);
    }

//-----------------------------------------------------------------------
process BUZZER
    {
    sound(100);
    wait 200;
    sound(0);
    }
