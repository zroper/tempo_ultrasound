// CHECKER.PRO - Alternating checkerboard using page flipping

fliptime = 100;                         // amount of time per flip in ms
xchecks = 10;                           // # of horizontal checks
ychecks =  8;                           // # of vertical checks
red1 = 3, green1 = 0, blue1 = 0;        // RGB gun settings for color1
red2 = 0, green2 = 3, blue2 = 0;        // RGB gun settings for color2

HIDE board_defined = 1;                 // Status bit indicating board is defined

// We must declare process names

DECLARE MAIN(), GEN_DISPLAY(), GEN_DATA(), DEFINE_MACROS(), SET_PAGE0();
DECLARE SET_PAGE1(), DRAW_BOARD(), CLEAR_SCREEN(), MAP_COLORS(), S();

PROCESS main ENABLED
    {
    wait    500;                        // Let the line quiet down
    send("VI 16");                      // Initialize video
    wait    3000;                       // Give monitor a chance to reset
    SUSPEND gen_display;
    SUSPEND gen_data;
    SPAWN   define_macros;
    SPAWN   draw_board;
    WSON    board_defined;              // WAIT for board to be defined
    SPAWN   set_page0;
    SPAWN   gen_display;
    SPAWN   gen_data;
    }

PROCESS gen_display
    {
    WHILE (1)
        {
        WAIT    fliptime;
        SPAWN   set_page1;
        WAIT    fliptime;
        SPAWN   set_page0;
        }
    }

PROCESS gen_data
    {
    WHILE (1)
        {
        WAIT    1000;
        TRIGGER 1;
        TRIGGER 2;
        }
    }

PROCESS define_macros
    {
    send("DM C1;");
    send("   ");
    send("VP 0;");
    send("   ");
    send("EM;");
    send("   ");

    send("DM C2;");
    send("VP 1;");
    send("EM;");
    }

PROCESS set_page0    { send("XM C1"); }

PROCESS set_page1    { send("XM C2"); }

HIDE xmax = 639, ymax = 349;        // Video dimensions
HIDE x, y, bx, by;                  // Temp variables
HIDE color1 = 1, color2 = 2;        // Color indexes for checks
HIDE xsize, ysize;                  // Size of box

PROCESS draw_board
    {
    spawn   clear_screen;
    wait    200;

    status_clr(board_defined);      // Status bit indicated board is defined

    IF (xchecks < 1)                // Verify hchecks, vchecks are ok
        xchecks = 1;
    IF (xchecks > xmax / 2)
        xchecks = xmax / 2;
    IF (ychecks < 1)
        ychecks = 1;
    IF (ychecks > ymax / 2)
        ychecks = ymax / 2;

    xsize = xmax / xchecks;         // Size of a box
    ysize = ymax / ychecks;

    SPAWN   map_colors;
    wait    200;

    send("RW 1 1; CL; RW 0 0; CL"); // Clear both video pages

    // PAGE 0

    send("CO", color1);             // Background colored1
    send("RF", 0, 0, xsize * xchecks - 1, ysize * ychecks - 1);
    send("CO", color2);             // Foreground colored2

    y = 0;
    WHILE (y < ychecks)
        {
        x = y & 1;                  // 1 or 0
        WHILE (x < xchecks)
            {
            bx = x * xsize;
            by = y * ysize;
            sendf("RF %d %d %d %d\n", bx, by, bx + xsize, by + ysize);
            x = x + 2;
            WAIT    70;
            }
        y = y + 1;
        }

    // PAGE 1

    send("RW 1 1; VP 1");
    send("CO", color1);
    send("RF", 0, 0, xsize * xchecks - 1, ysize * ychecks - 1);
    
    send("CO", color2);             // Foreground colored2

    y = 0;
    WHILE (y < ychecks)
        {
        x = 1 - (y & 1);            // 0 or 1
        WHILE (x < xchecks)
            {      
            bx = x * xsize;
            by = y * ysize;
            sendf("RF %d %d %d %d\n", bx, by, bx + xsize, by + ysize);
            x = x + 2;
            WAIT    70;
            }
        y = y + 1;
        }
    send("RW 0 0; VP 0");
    WAIT    2000;
    status_set(board_defined);      // Status bit indicated board is defined
    }

PROCESS clear_screen    { send("RW 1 1; CL; RW 0 0; CL");  }

PROCESS map_colors
    {
    send("CM", color1, red1, green1, blue1);    // Set RGB values for color1
    send("CM", color2, red2, green2, blue2);    // Set RGB values for color2
    }

PROCESS s
    {
    send("SM C1");
    send("SM C2");
    }
