/* VSMACRO.PRO - Example of VideoSYNC/WORDPLAY macros for smooth pursuit
**
**  This protocol uses VideoSYNC macros to move a sprite
**  along a trajectory.  Once defined, the protocol can start the
**  macro causing the sprite to move.
**
**  This example is programmed for VideoSYNC.  To use with WORDPLAY,
**  simpley change all "dsend" to "send".
**
**  The INIT procedure, called by MAIN, creates the sprite and defines
**  a number of macros controls the sprite's movement.  To use them, the
**  protocol sets two VideoSYNC variables, dir and dt, and executes the
**  GO macro.  The dir variable defines the direction (0=up, 1=upleft, ...)
**  and the dt variable defines the rate of movement (in vertical retraces).
**
**  The GO macro calls one of eight macros depending on the direction.
**  Each of the eight macros (UP, UPLEFT, etc.) sets dx and dy variables
**  and calls the MOVE macro.  The MOVE macro puts the sprite in the center
**  of the screen, makes it visible, and loops calling the MOVE1 macro
**  until the sprite hits the edge of the screen.  When the sprite reaches
**  the edge, it is hidden.  The MOVE1 macro waits dt vertical retraces,
**  changes the x and y position based on dx and dy and updates the sprite
**  position.
*/
hide done = 0;                          // Process done flag
hide constant XMAX = 1000;              // Virtual screen coordinates
hide constant YMAX = 1000;

process MAIN enabled
    {
    spawn   INIT;
    while (!done) nexttick;             // Wait for completion

    while (1)
        {
        dir = random(8);                // Select direction
        dt = 1;                         // Define the speed
        printf("DIR=%d, DT=%d\n", dir, dt);
        dsendf("sv dir=%d\n", dir);  // Tell VideoSYNC the direction
        dsendf("sv dt=%d\n", dt);    // Tell VideoSYNC the speed
        dsendf("xm GO()\n");         // Start the movement
        wait    10000;                 // Wait for completion
        }
    }

process INIT
    {
    done = 0;

    printf();
    printf("Initializing..\n");
    dsend("ca");                     // Clear all settings
    dsendf("vc 0,%d,0,%d\n", XMAX, YMAX);
    wait    3000;

    dsendf("sv xmax=%d\n", XMAX);    // Define VideoSYNC variables
    dsendf("sv ymax=%d\n", YMAX);    // ..for screen limits


    // CREATE THE SPRITE TO BE MOVED.  BEFORE CALLING THE 'GO' MACRO,
    // THE PROTOCOL CAN CHANGE THE SPRITE'S ATTRIBUTES

    dsend("oc 0,1");                 // A box
    dsend("ow 0,20,20");             // width
    dsend("of 0");                   // filled
    dsend("oi 0,15");                // white

    // DEFINE VIDEOSYNC VARIABLES

    dsend("sv dir=0");               // Default direction
    dsend("sv dt=10");               // Default speed (in vertical retraces)

    // THE GO MACRO SELECTS A MACRO TO CALL BASED ON THE DIRECTION.
    // AFTER THE PROTOCOL SETS dir AND dt, IT EXECUTES THE GO MACRO
    // TO MOVE THE SPRITE

    dsend("dm GO()");
    dsend("if (dir==0) xm UP()");
    dsend("if (dir==1) xm UPRIGHT()");
    dsend("if (dir==2) xm RIGHT()");
    dsend("if (dir==3) xm DOWNRIGHT()");
    dsend("if (dir==4) xm DOWN()");
    dsend("if (dir==5) xm DOWNLEFT()");
    dsend("if (dir==6) xm LEFT()");
    dsend("if (dir==7) xm UPLEFT()");
    dsend("em");

    // DEFINE MACROS SPECIFIC TO EACH DIRECTION. dx and dy are set
    // depending on the direction and the MOVE macro is called

    dsend("dm UP();       sv dx= 0; sv dy=-1; XM move(); EM");
    dsend("dm UPRIGHT();  sv dx= 1; sv dy=-1; XM move(); EM");
    dsend("dm RIGHT();    sv dx= 1; sv dy= 0; XM move(); EM");
    dsend("dm DOWNRIGHT();sv dx= 1; sv dy= 1; XM move(); EM");
    dsend("dm DOWN();     sv dx= 0; sv dy= 1; XM move(); EM");
    dsend("dm DOWNLEFT(); sv dx=-1; sv dy= 1; XM move(); EM");
    dsend("dm LEFT();     sv dx=-1; sv dy= 0; XM move(); EM");
    dsend("dm UPLEFT();   sv dx=-1; sv dy=-1; XM move(); EM");

    // THE MOVE MACRO CONTROLS THE MOVEMENT OF THE SPRITE.

    dsend("dm MOVE()");
    dsend("sv x = xmax / 2");        // Start sprite at center of screen
    dsend("sv y = ymax / 2");
    dsend("om 0,x,y");               // Move the sprite to center of screen
    dsend("os 0");                   // Display the sprite and
                                        // ..Loop until sprite hits edge of screen
    dsend("wh (x > 0 && x < xmax && y > 0 && y < ymax) XM MOVE1()");
    //dsend("oh 0");                   // Hide sprite
    dsend("em");

    // THE MOVE1 MACRO WAITS THE PROPER AMOUNT OF TIME THEN MOVES THE SPRITE

    dsend("dm MOVE1()");
    dsend("sv i=dt");
    dsend("wh (i > 0) XM WAIT");
    dsend("sv x = x + 4*dx");        // Update sprite X position
    dsend("sv y = y + 4*dy");        // Update sprite Y position
    dsend("om 0,x,y");               // Move sprite
    dsend("em");

    // THE WAIT MACRO WAITS AN AMOUNT OF TIME BASED ON dt

    dsend("dm WAIT()");
    dsend("wt 1");
    dsend("sv i=i-1");
    dsend("em");

    wait    2000;                   // Wait for VideoSYNC to digest this!

    done = 1;
    }
