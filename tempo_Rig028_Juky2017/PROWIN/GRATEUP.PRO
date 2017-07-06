// GRATEUP.PRO - Produce horizontal grating and pan vertically

waittime = 40;                          // # ticks per PAN (must be <= 30hz)
jump = 1;
bars = 16;                              // Should divide 350 evenly

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
    SPAWN   colors;
    }

HIDE ycurrent = 0;
HIDE pans = 0;

PROCESS gen_display
    {
    ycurrent = 0;
    sendf("  PA 0 %d\n", ycurrent);
    WHILE (1)
        {
        ycurrent = ycurrent + jump;
        IF (ycurrent < 0)           ycurrent = ycurrent + ymax;
        ELSE IF (ycurrent >= ymax)  ycurrent = ycurrent - ymax;

        sendf("  PA 0 %d\n", ycurrent);
        pans = pans + 1;
        wait        WAITTIME;
        }
    }

PROCESS gen_data
    {
    WHILE (1) { WAIT    1000;  TRIGGER 1;  TRIGGER 2; }
    }

HIDE xmax = 640, ymax = 350;        // Video dimensions
HIDE x, y, bx, by;                  // Temp variables
HIDE color;                         // Color index
HIDE xsize, ysize;                  // Size of box

PROCESS draw_board
    {
    status_clr(board_defined);      // Status bit indicated board is defined

    IF (bars < 1)        bars = 1;
    IF (bars > ymax / 2) bars = ymax / 2;

    send("RW 0 0; VP 0; CL");

    ysize = ymax / bars;            // Size of a box
    y = 0; color = 0;
    WHILE (y < bars)                // Do first verical pages
        {
        by = y * ysize + 350;
        sendf("CO %d; RF %d %d %d %d\n", color, 0, by, xmax, by + ysize);
        WAIT    100;
        y = y + 1;
        color = (color + 1) & 0xF;  // 0..15
        }

    y = 0; color = 0;
    WHILE (y < bars)                // Do second verical pages
        {
        by = y * ysize;
        sendf("CO %d; RF %d %d %d %d\n", color, 0, by, xmax, by + ysize);
        WAIT    100;
        y = y + 1;
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
