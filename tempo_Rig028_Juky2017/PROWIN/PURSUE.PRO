// PURSUE.PRO - Test algorithms for drawing multiple, overlapping sprites
//
// SYNOPSIS
//  Two sprites are created.  The white one (target) is controlled by
//  the protocol.  The red one (cursor) is controlled by the subject
//  (i.e., mouse on server).  You should be able to chase the white sprite on
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
//  06Oct97 sh  Initial edit
//  07Oct97 jb  Variable control over sprite size on init
//              Object Display on mono screen    
//  08Sep04 sh  Clean up code, add dialog and documentation
//              Add pragma declare = 1

#pragma declare = 1                     // Strict compiler checking

#include object.pro                     // Animated Graph definitions

declare constant XMAX = 1023;           // Virtual dimensions of VS Screen
declare constant YMAX = 767;

declare UpdateRate = 10;                // ms between target updates

declare tsize=50;                       // Sprite 0 size (WHITE) (Protocol controlled)
declare csize=20;                       // Sprite 1 size (RED) (Subject Controlled via mouse)


int oTarget, oCursor;

// Declare all processes
declare MAIN(), GO(), STP(), SPRITE_TARGET(), SPRITE_CURSOR(), CLEAR(), DUMP(); 

//-----------------------------------------------------------------------
process MAIN() enabled
    {
    dsend("CL");                        // Clear screen
    dsend("OD *");                      // Destroy all sprites

    dsendf("VC 0,%d,0,%d\n", XMAX, YMAX);   // Set VS's virtual coordinates
    oSetGraph(gLeft, aRANGE, 0, XMAX, 0, YMAX); // Set Animated Graph virt. coord
    
    dsend("CM 1,255,0,0");              // Set color map: Red
    dsend("CM 2,255,255,255");          // Set color map: White
    dsend("CM 3,255,0,0");              // Set color map: Red when they overlap
    
    // Draw some things on the screen to show how sprites with XOR
    // drawing interact with other drawn objects when they overlap.
    
    dsend("MV 200,200");                // Set current location
    dsend("CO 2");                      // Set current drawing color (this will be white)
    dsend("TX Server mouse moves red sprite."); // Display text
    dsend("EF 300,300,25,50");          // Draw filled ellipse
    
    dsend("CO 1");                      // Set current drawing color
    dsend("RF 500, 410, 650, 550");     // Draw filled rectangle
    
    //dsend("CO 5");                    // Set current drawing color
    //dsend("RF 200,200,400,400");      // Draw filled rectangle

    // CREATE SPRITE 1 Is the RED
    
    dsend("OC1,5");                     // Create Sprite 1 is RED
    dsendf("OW1,%d,%d\n", csize,csize); // Set size
    dsend("OI1,1");                     // Set color
    dsend("OF1");                       // Set filled
    dsend("OL1,3");                     // Set sprite drawing logic to XOR
    dsend("OS1");                       // Show sprite 1

    oCursor = oCreate(tBOX, gLEFT, cSize, cSize);   // Create animated object
    
    // CREATE SPRITE 0 Is the WHITE 
    
    dsend("OC0,5");                     // Sprite 0 is WHITE
    dsendf("OW0,%d,%d\n", tsize,tsize); // Set size
    dsend("OI0,2");                     // Set color
    dsend("OF0");                       // Set unfilled
    dsend("OL0,3");                     // Set sprite drawing logic to XOR
    dsend("OS0");                       // Don't show

    oTarget = oCreate(tBOX, gLEFT, tsize, tsize);   // Created animiated object
    

    print("Sprites initialized.");
    system("dialog Main");              // Display main dialog
    }

//-----------------------------------------------------------------------
// Spawned by GO button in MAIN dialog

process GO()                            // Start moving the sprites
    {
    spawn SPRITE_TARGET;
    spawn SPRITE_CURSOR;
    print("Sprites running..");
    }

//-----------------------------------------------------------------------
// Spawned by STOP button in MAIN dialog
// (We can't use the keyword "STOP" as its name!)

process STP()                           // Stop the sprites
    {
    suspend SPRITE_TARGET;
    suspend SPRITE_CURSOR;
    print("Sprites stopped..");
    }

//-----------------------------------------------------------------------
// Do the work of moving a sprite around the screen

process SPRITE_TARGET()                 // Bounce sprite 0 around the screen
    {
    int     oldtx, oldty;
    int     tx, ty;
    int     xdir, ydir;

    tx = 0;
    ty = YMAX / 2;
    xdir = -1;
    ydir = -1;
    while (1)
        {
        if (oldtx != tx || oldty != tx)
            {
            dsendf("OM 0,%d,%d\n", tx, ty); // Move sprite 0
            oMove(oTarget, tx, ty);         // Also in Animaged Graphs
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


//-----------------------------------------------------------------------
// Do the work of moving a sprite as controlled by the server mouse

process SPRITE_CURSOR()     // Track subject's movement and
    {                       // .. update cursor (red sprite) position
    int     oldcx, oldcy;
    int     cx, cy;
    
    cx = 0;
    cy = 0;
    print("Move mouse to control red cursor");
    while (1)
        {
        cx = XMAX * (MouGetX() + 2048) / 4096;
        cy = YMAX * (MouGetY() + 2048) / 4096;
        if (oldcx != cx || oldcy != cy)
            {
            dsendf("OM 1,%d,%d\n", cx, cy);     // Move sprite 1
            oMove(oCursor, cx, cy);             // Move associated Animated Object
            oldcx = cx;
            oldcy = cy;
            }
        wait UpdateRate;
        }
    }


//-----------------------------------------------------------------------
// Clear the VideoSYNC screen

process CLEAR()                     // Clear screen
    {
    dsend("OH*");                   // Hide sprites
    dsend("CL");                    // Clear screen
    dsend("OS*");                   // Show sprites
    print("Screen cleared..");
    }


//-----------------------------------------------------------------------
// Display debug diagnostic information

process DUMP()                      // Display timing data
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
