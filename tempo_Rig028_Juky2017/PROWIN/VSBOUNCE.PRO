/* VSBOUNCE.PRO - Example of the bounce program using VideoSYNC
**  This protocol requires the VideoSYNC program.  It moves a "sprite"
**  around the screen.  It shows:
**
**      1. How to send commands to VideoSYNC (dsendf)
**      2. How to create a VideoSYNC sprite
**      3. How to move a sprite and control other sprite attributes
**
**  Requirements:
**    o A version of the KERNEL with the DIO module.
**    o The DDX0_MODE and DDX0_SIZE parameters set in the
**      KERNEL configuration file.
**    o Mouse driver loaded and MOUSE=yes specified in your KERNEL
**      configuration file.
**    o The DDX (parallel) cable is installed and working (refer to
**          the DDX program in your VideoSYNC documentation.)
**
**    o SPRITES=1 or more in your VideoSYNC configuration file.
**    o VideoSYNC video mode is set to desired resolution (you can
**      either change VideoSYNC's configuration file or send the VI
**      command from the protocol here.)
**
** NOTES
**
**  This protocol illustrates several ways to get input for controlling
**  the moving sprite's (x,y) position:
**
**      1. By having the protocol generate them (i.e., pursuit tasks)
**      2. By using analog input channels and mapping them to
**         video coordinates.  With KDEMO, you can load mouse coordinates
**         into analog channels 1 & 2 by adding MOUSE=yes and MOUSE2ANALOG=yes
**         in your KERNEL configuration file (i.e., subject controlled as a
**         pointing device).
**      3. By using the mouse on the TEMPO computer (i.e., researcher
**         controlled for receptive field mapping).
**
**  By default, the protocol uses method #3 but the other methods are
**  shown in comments.
**
**  Note that in (2), mapping analog values to video requires calibration.
**  Here, we simply assume that the maximum and minimum analog values
**  (+2047, -2048) correspond to the maximum and minimum video values.
**  
**  Note that when the mouse is used, its values range from 2047 to -2048.
*/

hide constant XMAX = 1000;                  // Virtual coordinate system
hide constant YMAX = 1000;

method = 3;                                 // Set to 1, 2 or 3 (see above)

x = 101;                                    // Current (x,y) location
y = 3;

dx = 2;                                     // # of X pixels to move
dy = 1;                                     // # of Y pixels to move

dw = 10;                                    // # milliseconds between updates

size = 20;                                  // size of object (in virtual coord)

hide constant axmin = -2048;                // minimum analog for x
hide constant axmax = 2047;                 // maximum analog for x
hide constant aymin = -2048;                // minimum analog for y
hide constant aymax = 2047;                 // maximum analog for y

process main enabled
    {
    hide declare old_x, old_y;              // Previous (x,y) position

//  dsendf("VI 261\n");                  // Set VideoSYNC video resolution
//  wait    4000;                           // Wait for hardware reset

    dsendf("CA\n");                      // Reset parameters
    print("Initializing VideoSYNC..");
    wait    2000;                       // Wait for software reset

    dsendf("VC 0,%d,0,%d\n", XMAX, YMAX);// Set virtual coordinates
    dsendf("OC 0,1\n");                  // Create rectangular sprite 0
    dsendf("OW 0,%d,%d\n", size, size);  // Set width and height
    dsendf("OS 0\n");                    // Show on screen

    printf("Running method %d..Movement controlled by ", method);
    if (method == 1)        printf("protocol.\n");
    else if (method == 2)   printf("analog inputs.\n");
    else                    printf("TEMPO's mouse.\n");

    while (1)
        {
        if (method == 1)
            {
            // METHOD #1: SPRITE POSITION DETERMINED BY PROTOCOL
            x = x + dx;
            y = y + dy;
            if (x > XMAX - 20 || x < 0)      // "bounce" off sides
                {
                dx = - dx;
                x = x + dx;
                }
            if (y > YMAX - 20 || y < 0)      // "bounce off top/bottom
                {
                dy = - dy;
                y = y + dy;
                }
            }
        else if (method == 2)
            {
            // METHOD #2: MAP ANALOG INPUT CHANNELS TO VIDEO COORDINATES
            ax = atable(1);                  // Get analog channel #1
            ay = atable(2);                  // Get analog channel #2

            //     MAP ANALOG TO VIDEO. SEE DIMCAL.PRO AND EYECAL.PRO
            //     FOR ANOTHER WAY TO DETERMINE AND PERFORM THE MAPPING.
            x = (XMAX * (ax - axmin)) / (axmax - axmin);
            y = (YMAX * (ay - aymin)) / (aymax - aymin);
            }
        else
            {
            // METHOD #3: TEMPO MOUSE CONTROLS POSITION
            ax = mouGetX();
            ay = mouGetY();
            x = (XMAX * (ax - -2048)) / 4096;
            y = (YMAX * (ay - -2048)) / 4096;
            }
            
        // UPDATE SPRITE POSITION ONLY IF IT HAS CHANGED

        if (x != old_x || y != old_y)
            {
            dsendf("OM 0,%d,%d\n", x, y);
            old_x = x;
            old_y = y;
            }

        // THERE'S NEVER A NEED TO UPDATE FASTER THAN VERTICAL RETRACE

        wait    dw;
        }
    }
