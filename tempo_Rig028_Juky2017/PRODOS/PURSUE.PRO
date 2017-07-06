// PURSUE.PRO - Test algorithms for drawing multiple, overlapping sprites
//
// SYNOPSIS
//  Two sprites are created.  The white one (target) is controlled by
//  the protocol.  The red one (cursor) is controlled by the subject
//  (i.e., mouse).  You should be able to chase the white sprite on
//  the screen.  Where they overlap, the red cursor should appear on
//  top of the white one.
//
//  The target sprite should bounce off the sides of the screen.  There
//  should be no flicker when either sprite is moving.  If the movement
//  appears to be jumpy, try squinting or looking at the sprites out
//  of the corner of your eye to see that the jumpiness is just an
//  artifact.  You might also try staring at the center of the screen
//  while the sprites move to see that they are, in fact, moving
//  smoothly.
//
// METHODS
//  We use XOR sprite drawing combined with a careful setup of the
//  color map table to effect the desired appearances of the sprites
//  when they overlap.
//
// USAGE
//  F1=Display initial dialog
//
// VideoSYNC Configuration file:
//  SPRITES=2
//  VIDEO=261
//
// EDIT HISTORY
//  06 Oct 97 sh    Initial edit
//  07 Oct 97 jb    Variable control over sprite size on init
//                  Object Display on mono screen    

declare constant XMAX = 1023;
declare constant YMAX = 767;

declare UpdateRate = 10;                // ms between target updates
declare sprites = 0;                    // 1=sprites, 0=draw
declare tsize=50;
declare csize=25;

#include object.pro

HIDE oTarget, oCursor;

process MAIN enabled
    {
    dsend("CL");
    dsend("OD *");

    dsendf("VC 0,%d,0,%d\n", XMAX, YMAX);
    oSetGraph(gLeft, aRANGE, 0, XMAX, 0, YMAX);

    dsend("CM 1,255,0,0");      // Red
    dsend("CM 2,255,255,255");  // White
    dsend("CM 3,255,0,0");      // Red when they overlap

    //dsend("CO 5");
    //dsend("RF 200,200,400,400");

    dsend("OC1,5");             // Sprite 1 is red cursor
    dsendf("OW1,%d,%d\n", csize,csize);
    dsend("OI1,1");
    dsend("OF1");
    dsend("OL1,3");             // Set sprite drawing logic to XOR
    dsend("OS1");

    oCursor = oCreate(tBOX, gLEFT, cSize, cSize);

    dsend("OC0,5");             // Sprite 0 is white target
    dsendf("OW0,%d,%d\n", tsize,tsize);
    dsend("OI0,2");
    dsend("OF0");
    dsend("OL0,3");             // Set sprite drawing logic to XOR
    dsend("OS0");

    oTarget = oCreate(tBOX, gLEFT, tsize, tsize);

    print("Sprites initialized.  Press F1 for menu.");
    }

process GO                      // Start moving the sprites
    {
    spawn SPRITE_TARGET;
    spawn SPRITE_CURSOR;
    print("Sprites running..");
    }

process STP                     // Stop the sprites
    {
    suspend SPRITE_TARGET;
    suspend SPRITE_CURSOR;
    print("Sprites stopped..");
    }

process SPRITE_TARGET           // Bounce the target around
    {
    hide    oldtx, oldty;

    tx = 0;
    ty = YMAX / 2;
    xdir = -1;
    ydir = -1;
    while (1)
        {
        if (oldtx != tx || oldty != tx)
            {
            dsendf("OM0,%d,%d\n", tx, ty);
            oMove(oTarget, tx, ty);
            oldtx = tx;
            oldty = ty;
            }

        if (tx <= 0 || tx >= XMAX)
            xdir = -xdir;
        tx = tx + xdir;

        if (ty <= 0 || ty >= YMAX)
            ydir = -ydir;
        ty = ty + ydir;

        wait UpdateRate;
        }
    }

process SPRITE_CURSOR       // Track subject's movement and
    {                       // .. update cursor (red sprite) position
    hide    oldcx, oldcy;
    cx = 0;
    cy = 0;
    print("Move mouse to control red cursor");
    while (1)
        {
        cx = XMAX * (MouGetX() + 2048) / 4096;
        cy = YMAX * (MouGetY() + 2048) / 4096;
        if (oldcx != cx || oldcy != cy)
            {
            dsendf("OM1,%d,%d\n", cx, cy);
            oMove(oCursor, cx, cy);
            oldcx = cx;
            oldcy = cy;
            }
        wait UpdateRate;
        }
    }

process CLEAR                       // Clear screen
    {
    dsend("OH*");
    dsend("CL");
    dsend("OS*");
    print("Screen cleared..");
    }

process DUMP                        // Display timing data
    {
    hide i;

    i = 0;                          // Hide & Show a bunch of times
    while (i < 20)                  // ..so we can measure timing
        {
        dsend("OH1");               // Hide and show to measure time
        dsend("OS1");
        dsend("OH0");               // Hide and show to measure time
        dsend("OS0");
        i = i + 1;
        }

    dsend("OH*");
    dsend("O?*");
    dsend("OS*");
    print("Timing information displayed on VideoSYNC screen..");
    }
