/* FIELDMAP.PRO - VideoSYNC commands for doing receptive field mapping.
**
** This protocol illustrates
**
**      1. Using LS to control the line style
**      2. Defining arbitrary sprites with OV
**      3. Using PF and PU to draw arbitrary filled/unfilled polygons
**
** An unusual sprite is created.  Its position is controlled by 
** moving the mouse.  Other objects are drawn on the screen to illustrate
** the transparency behavior of black in sprites.
*/

constant XMAX = 1024;                   // Virtual coordinates
constant YMAX = 768;                    // ..for VideoSync

hex style = 0xFFFF;                     // Line style
thickness = 20;                         // Line thickness

// THIS process draws lines based on Style and Thickness.
// Set these values when spawn MAIN from the TEMPO command line
// to see the effect of different lines and thicknesses.

process MAIN enabled
    {
    DECLARE mx, my, x, y, oldx, oldy;

    dsendf("ca\n");
    wait    500;
    dsendf("vc 0,%d,0,%d\n", XMAX, YMAX);

    // Create a complex image in video ram at (0,0) to (75,75)
    // that we will use as the sprite

    dsend("co 12");                     // red
    dsend("ls 0xFFFF,1");
    dsend("pf 0,0,75,0,35,75,20,75,0,0");

    dsendf("co 15\n");                  // white
    dsendf("mv 0,0\n");
    dsendf("ls %d,%d\n", style, thickness);
    dsend("dr 150,150");

    dsend("co 0");                      // black
    dsend("mv 2,2");
    dsend("tx Pascal");

    dsend("co 10");                     // green
    dsend("pf 40,50,60,40,60,60,50,50");

    dsend("co 0");                     // black
    dsend("pf 10,50,30,40,30,60,20,50");

    dsend("OC 0,2");                    // Create rectangular sprite
    dsend("OW 0,75,75");                // Set size
    dsend("OV 0,0,0");                  // Load sprite from video ram

    // NOW THAT THE SPRITE IS DEFINED, DRAW SOME OTHER STUFF
    // ON THE SCREEN TO SHOW HOW BLACK IN SPRITES ALLOWS YOU
    // TO SEE WHAT'S BEHIND IT AS THE SPRITE PASSES OVER AN OBJECT.

    dsend("cl");

    dsend("co 15");
    dsend("rf 50,50,150,150");

    dsend("co 11");
    dsend("ef 400,340,150,50");

    dsend("co 10");
    dsend("ls 0xFFFF,1");
    dsend("pu 100,500,300,400,300,600,200,500,100,500");
    dsend("co 9");
    dsend("pf 20,100,60,80,60,120,40,100,20,100");

    dsend("mv 90,450");
    dsend("co 15; tx Arbitrary filled/unfilled polygons");

    dsend("mv 400,20");
    dsend("tx Note black in sprites shows background");
    dsend("mv 400,40");
    dsend("tx Also note the Line style used to draw thick white line in sprite");

    dsend("OS 0");

    // NOW LET THE USER MOVE THE SPRITE WITH THE MOUSE.

    while (1)
        {
        mx = mouGetX();
        my = mouGetY();
        x = (mx + 2048) * XMAX / 4096;
        y = (my + 2048) * YMAX / 4096;
        if (x != oldx || y != oldy)
            {
            oldx = x;
            oldy = y;
            dsendf("om 0,%d,%d\n", x, y);
            }
        nexttick;
        }
    }
