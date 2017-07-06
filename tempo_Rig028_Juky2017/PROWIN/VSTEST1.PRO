// VSTEST1.PRO - Simple protocol with VideoSYNC (DDX) for moving a cursor.
// Copyright 1997 Sheldon Hoffman.  All rights reserved.
//
// This protocol requires that you define DDX_BASE and DDX_SIZE
// in your KERNEL configuration and use a version of the kernel that
// includes the DIO module.

declare constant XMAX = 1000;           // Screen X coordinates [0..XMAX]
declare constant YMAX = 1000;           // Screen Y coordinates [0..YMAX]

// We assume that the device connected to analog inputs 1 (X) and 2 (Y)
// have the following ranges.  In practice, these values are determined
// through a calibration of the input device.  Here, since we assume the
// mouse is being used, it's range is +/-2048 in both X and Y.
// To calibrate a linear joystick that has orthogonal X and Y axes,
// for example, put the joystick in the upper left corner of the work
// space and read off the X and Y values from the SHOW A display.  These
// are the minimum X,Y values of the joystick.  Then move the joystick
// to the lower left corner of the workspace and read off the X,Y values.
// These would be the maximum X and Y values.

declare constant AXMAX = 2047;          // Minimum X value
declare constant AXMIN = -2048;         // Maximum X value
declare constant AYMAX = 2047;          // Maxmum Y value
declare constant AYMIN = -2048;         // Minimum Y value

// Location of target in virtual screen coordinates

declare bX = 400, bY = 200, bXsize = 100, bYsize = 100;

process MAIN enabled
    {
//    dsendf("vi 16; od *\n");            // This may not be necessary
//    wait 3000;                          // Wait for VideoSYNC to change video modes
    dsendf("vc 0,%d,0,%d\n", XMAX, YMAX);
    dsendf("cl\n");

    // Set up the color look up table so that when the cursor sprite
    // moves over the background rectangle, it remains white.  
    // Define color 1 to be the cursor and color 2, 4, ... to be target
    // colors.  For each target, when the cursor moves over it, the
    // resulting color is one more than the target color (1 XOR c = c+1,
    // for c=2,4,...).  So we set the odd colors to the save RGB as the
    // cursor.  The result is that the cursor doesn't change colors when
    // it moves over a target.  To get the effect of the cursor adopting
    // the color of the target as it passes over (under) it, set the odd
    // color indexes to the same color as the even color index before it.

                                        // Define the color map
    dsendf("cm 1,255,255,255\n");       // Color 1=cursor
    dsendf("cm 2,255,0,0\n");           // Color 2=target1
    dsendf("cm 3,255,255,255\n");       // Color 3=target1 ^ cursor

                                        // Draw background target(s)
    dsendf("co 2\n");
    dsendf("rf %d,%d,%d,%d\n", bX, bY, bX+bXsize, bY+bYsize);

                                        // Create cursor(s)
    dsendf("oc 0,2; of 0; oi 0,1; ow 0,10,20; os 0\n");

    spawn WATCH_EYE;
    spawn WATCH_BUTTONS;

    while (1)
        {
        while (!inside_target) 
            nexttick;                   // Wait till he moves inside
        print("Moved inside target");
        trigger 1;                      // Collect data

        while (inside_target) 
            nexttick;                   // Wait till he leaves target
        wait    1000;
        }
    }

process WATCH_EYE
    {
    while (1)
        {
        // RETRIEVE ANALOG INPUT VALUES FROM INPUT DEVICE (i.e., joystick)

        ax = atable(1);
        ay = atable(2);

        // MAP ANALOG COORDINATES TO VIRTUAL SCREEN COORDINATES

        x = (XMAX * (ax - AXMIN)) / (AXMAX - AXMIN);
        y = (YMAX * (ay - AYMIN)) / (AYMAX - AYMIN);

        // IF THE POSITION HAS CHANGED, TELL MOVE THE SPRITE

        if (x != oldx || y != oldy)
            {
            dsendf("om 0,%d,%d\n", x, y);
            oldx = x;
            oldy = y;
            }

        // CHECK TO SEE IF THE CURSOR IS WITHIN THE TARGET.

        if (x > bX && x < bX+bXsize && y > bY && y < bY+bYsize)
            inside_target = 1;
        else
            inside_target = 0;

        nexttick;
        }
    }

process WATCH_BUTTONS
    {
    while (1)
        {
        buttons = mouGetButtons();
        if (buttons & 1)
            {
            dsend("o? *");
            while (mouGetButtons() & 1)
                nexttick;
            }
        nexttick;
        }
    }
