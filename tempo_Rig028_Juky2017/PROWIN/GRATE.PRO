// GRATE.PRO - Produce vertical grating and move horizontally with pan

waittime = 50;                          // # ticks per PAN (must be <= 30hz)
jump = -1;
bars = 32;                              // Must divide 640 evenly!

HIDE board_defined = 1;                 // Status bit indicating board is defined

PROCESS main ENABLED
    {
    WAIT    500;
    //SEND("VI 16");
    WAIT    3000;
    SUSPEND gen_display;
    SUSPEND gen_data;
    SPAWN   draw_board;
    WSON    board_defined;              // Wait for board to be defined
    SPAWN   COLORS;
    }

HIDE xcurrent = 0;
HIDE pans = 0;

PROCESS gen_display
    {
    xcurrent = 0;
    sendf("  PA %d 0\n", xcurrent);
    WHILE (1)
        {
        xcurrent = xcurrent + jump;
        IF (xcurrent < 0)
            xcurrent = xcurrent + xmax;
        ELSE IF (xcurrent >= xmax)
            xcurrent = xcurrent - xmax;

        sendf("  PA %d 0\n", xcurrent);
        pans = pans + 1;
        WAIT    waittime;
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

HIDE xmax = 640, ymax = 350;        // Video dimensions
HIDE x, y, bx, by;                  // Temp variables
HIDE color;                         // Color index
HIDE xsize, ysize;                  // Size of box

PROCESS draw_board
    {
    status_clr(board_defined);      // Status bit indicated board is defined

    IF (bars < 1)                   // Verify hchecks, vchecks are ok
        bars = 1;
    IF (bars > xmax / 2)
        bars = xmax / 2;

    IF (xmax % bars)
        printf("Warning! Bars (=%d) must evenly divide %d.\n", bars, xmax);

    xsize = xmax / bars;            // Size of a box

    send("RW 0 0; VP 0; CL");

    x = 0;
    color = 0;
    WHILE (x < bars)
        {
        bx = x * xsize;
        sendf("CO %d; RF %d %d %d %d\n", color, bx, 0, bx + xsize, ymax);
        WAIT    100;
        x = x + 1;
        color = (color + 1) & 0xF;  // 0..15
        }

    WAIT    2000;
    status_set(board_defined);      // Status bit indicated board is defined
    }

PROCESS clear   {  send("RW 1 1; CL; RW 0 0; CL");  }

PROCESS gray
    {
    SUSPEND gen_display;  SUSPEND gen_data; wait 300;
    send("CM  0 0 0 0");  send("CM  1 0 0 0");  send("CM  2 0 0 0");  send("CM  3 0 0 0");
    send("CM  4 1 1 1");  send("CM  5 1 1 1");  send("CM  6 1 1 1");  send("CM  7 1 1 1");
    send("CM  8 2 2 2");  send("CM  9 2 2 2");  send("CM 10 2 2 2");  send("CM 11 2 2 2");
    send("CM 12 3 3 3");  send("CM 13 3 3 3");  send("CM 14 3 3 3");  send("CM 15 3 3 3");
    wait 300; RESUME gen_display;   RESUME gen_data;
    }

PROCESS colors
    {
    SUSPEND gen_display;  SUSPEND gen_data; wait 300;
    send("CM  0 0 0 0");  send("CM  1 0 0 2");  send("CM  2 0 2 0");  send("CM  3 0 2 2");
    send("CM  4 2 0 0");  send("CM  5 2 0 2");  send("CM  6 2 2 0");  send("CM  7 2 2 2");
    send("CM  8 1 1 1");  send("CM  9 1 1 3");  send("CM 10 1 3 1");  send("CM 11 1 3 3");
    send("CM 12 3 1 1");  send("CM 13 3 1 3");  send("CM 14 3 3 1");  send("CM 15 3 3 3");
    wait 300; RESUME gen_display;   RESUME gen_data;
    }

PROCESS black
    {
    SUSPEND gen_display;  SUSPEND gen_data; wait 300;
    send("CM  0 0 0 0");  send("CM  1 0 0 0");  send("CM  2 0 0 0");  send("CM  3 0 0 0");
    send("CM  4 0 0 0");  send("CM  5 0 0 0");  send("CM  6 0 0 0");  send("CM  7 0 0 0");
    send("CM  8 0 0 0");  send("CM  9 0 0 0");  send("CM 10 0 0 0");  send("CM 11 0 0 0");
    send("CM 12 0 0 0");  send("CM 13 0 0 0");  send("CM 14 0 0 0");  send("CM 15 0 0 0");
    wait 300; RESUME gen_display;   RESUME gen_data;
    }
