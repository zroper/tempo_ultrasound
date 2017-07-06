/* VSPURSUE.PRO - A sample smooth pursuit task using VideoSYNC's sprites.
**
**  This protocol demonstrates the use of VideoSYNC's sprites for
**  creating tasks that require moving an object on VideoSYNC's screen.
**
**  Here, when the bar is pressed, a central sprite appears and moves
**  to one of 8 locations on the screen.  The speed and trajectory are
**  controlled by sending position information to VideoSYNC.
**
*/

constant XMAX = 1024;              // Virtual screen coordinates
constant YMAX = 768;

// DX,DY arrays define direction (sign) for each direction.
// The velocity is a multiplier of these jumps.

hide constant dx_jump[8] = { 0, 1, 1, 1, 0,-1,-1,-1};
hide constant dy_jump[8] = {-1,-1, 0, 1, 1, 1, 0,-1};

velocity = 1;                           // Jump Multiplier
constant size = 20;                     // Size of sprite
dw = 10;                                // # ms between updates

hide done;                              // Process done flag
hide constant border = 100;             // Border to stop on

// ------------------------------------------------------------------
process PURSUE enabled
    {
    spawn init;
    while (!done) nexttick;             // Wait for init to finish

    while (1)
        {
        wait    2000;                   // Use wson BAR to wait for bar press
        //direction = random(8);          // 0..7
        direction = (direction + 1) % 8;
        color = random(6) + 9;          // Randomize colors for fun
        spawn moveit;                   // Move sprite
        while (!done) nexttick;         // Wait for completion
        }
    }

// ------------------------------------------------------------------
// INIT - Initialize protocol and visual stimulus computer
process init
    {
    done = 0;
    printf("Initializing Visual Stimulus Computer\n");
    dsendf("ca; vc 0,%d,0,%d\n", XMAX, YMAX);
    wait    4000;

    dsendf("oc 0,2\n");                  // Create sprite
    dsendf("ow 0,%d,%d\n", size, size);  // Define height, width
    dsendf("oi 0, 15\n");                // Define color
    dsendf("of 0");                      // Use filled sprite
    printf("Ready\n");
    done = 1;
    }

// ------------------------------------------------------------------
// MOVEIT - Move sprite across screen
process moveit
    {
    done = 0;
    x = (XMAX-size) / 2;                // Initial sprite position
    y = (YMAX-size) / 2;                // ..is in center of screen

    dx = dx_jump[direction];
    dy = dy_jump[direction];

    dsendf("OM 0,%d,%d\n", x, y);        // Move sprite
    dsendf("OI 0,%d\n", color);          // Change color
    dsendf("OS 0\n");                    // Show sprite
    while (x > BORDER && x < XMAX-BORDER && y > BORDER && y < YMAX-BORDER)
        {
        wait    dw;                     // # ms to wait between updates
        dsendf("OM 0,%d,%d\n", x, y);    // Move sprite
        x = x + velocity * dx;
        y = y + velocity * dy;
        }

    dsend("OH 0");                       // Hide sprite
    done = 1;
    }

// ------------------------------------------------------------------
// Spawn this process to display sprite information
process INFO
    {
    dsend("O? 0");
    }
