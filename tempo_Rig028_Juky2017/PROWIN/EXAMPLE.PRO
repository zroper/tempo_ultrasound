// EXAMPLE.PRO - Displays a box on WORDPLAY's screen and detects when eye
// enters box.  The box is displayed when bar is pressed.
// Simple experiment animation is also demonstrated.  The following points
// are demonstrated by this protocol (and it's configuration file).
//
//      How to communicate with WORDPLAY/VideoSYNC to draw on its screen.
//      How to read analog values and map them to video coordinates.
//      How to respond to subject pressing a bar.
//      How to trigger a data collection aligned on subject initiated event.
//      How to collect data before the trigger.
//      How to synchronously collect analog and spike data.
//      How to collect real-time averaged analog data.
//      How to use simple animation to display eye/stimulus position.
//      How to loop over multiple trials.
//      How messages are displayed in TEMPO's message box.
//      How WORDPLAY/Animation virtual coordinates are used.
//      How global variables may be used by several processes.
//      How to spawn/suspend another process.
//      How to use user-defined events to construct response-time histogram.
//      How inter-trial time is controlled.
//      How to randomize trials.

#include object.pro                                 // Define Animated constants

color = 15;                                         // Default color of box
bx = 100;                                           // Default location of box
by = 100;

XMAX=1000;                                          // Virtual video coordinates
YMAX=1000;

hex BAR = 0x10000000;                               // Status bit associated with BAR

//------------------------------------------------------------------------
process MAIN enabled
    {
    sendf("cl\n");                                  // Clear WORDPLAY's screen and
    sendf("vc 0,%d,0,%d\n", XMAX, YMAX);            // ..Set virtual coordinates
    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX);     // Set animation coordinates

    oB = oCreate(tBOX, gLEFT, 100, 100);            // Created animated box
    oSetAttribute(oB, aINVISIBLE);                  // ..and hide it

    oI = oCreate(tCROSS, gLEFT, 10, 10);            // Create animated eye

    print("Use SHOW M to see animation.  Press bar to start.");

    spawn   WATCH_EYE;                              // Start monitoring eye position

    while (1)
        {
        wson    BAR;                                // Wait for button press

        bx = random(XMAX - 100);                    // Place box randomly
        by = random(YMAX - 100);    

        spawn   TARGET_ON;                          // Turn box on
        spawn   ENTER;                              // Watch for entry
        wait    1000;                               // Time limit
        spawn   TARGET_OFF;                         // Turn box off
        suspend ENTER;                              // Stop watching for entry
        wait    1000;                               // Intertrial time
        }
    }

//------------------------------------------------------------------------
process ENTER                                       // Count times box is entered
    {
    while (1)
        {
        while (inside) nexttick;                    // wait till out of box
        while (!inside) nexttick;                   // wait till enters box
        trigger 1;                                  // Collect data upon entering box
        etable_set(1, 1);                           // Mark moment of entry
        print("Entered box");
        }
    }

//------------------------------------------------------------------------
process WATCH_EYE
    {
    while (1)
        {
        ax = atable(1);                             // Get analog eye position
        ay = atable(2);
        ix = (XMAX * (ax + 2048)) / 4096;           // Map to video coordinates
        iy = (YMAX * (ay + 2048)) / 4096;

        oMove(oI, ix, iy);                          // Move eye to new position

        if (ix > bx && ix < bx+100 && iy > by && iy < by+100)
            inside = 1;                             // Eye is inside box
        else
            inside = 0;                             // Eye is not inside box

        nexttick;
        }
    }

//------------------------------------------------------------------------
process TARGET_ON
    {
    sendf("co %d\n", color);                            // Set color
    sendf("rf %d,%d,%d,%d\n", bx, by, bx+100, by+100);  // ..draw box
    oMove(oB, bx + 100/2, by + 100/2);                  // Position animated box
    oSetAttribute(oB, aVISIBLE);                        // ..and show it
    trigger 2;                                          // Start event collection
    }

//------------------------------------------------------------------------
process TARGET_OFF
    {
    sendf("co 0\n");                                    // Color is black
    sendf("rf %d,%d,%d,%d\n", bx, by, bx+100, by+100);  // Draw black box
    oSetAttribute(oB, aINVISIBLE);                      // Hide animated box
    }
