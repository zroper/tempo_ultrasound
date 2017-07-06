// GRATE.PRO - Produce vertical grating and move horizontally with pan
// 25Sep05 This protocol is obsoleted by RDXTTL.PRO.
// It is obsoleted in two ways by RDXTTL.PRO:
//
//      1. it uses the old WORDPLAY over the serial line
//          VideoSYNC uses the faster RDX link.
//
//      2. The RDXTTL mechanism improves on the older serial line
//          method for synchronizing with the vertical retrace on
//          the stimulus computer.

jump = -1;
bars = 32;                              // Must divide 640 evenly!

hide board_defined = 1;                 // Status bit indicating board is defined

process main ENABLED
    {
    print("This protocol pans WORDPLAY by synchronizing with WORDPLAY's monitor.");
    print("We each PAN command we send WORDPLAY, we also tell WORDPLAY to let us");
    print("know when it is done.  When we get this signal, we send another PAN.");

    suspend gen_display;
    suspend gen_data;

    spawn   draw_board;
    wson    board_defined;              // Wait for board to be defined

    spawn   colors;
    spawn   gen_data;
    }

process gen_data
    {
    while (1)
        {
        wait    2300;
        trigger 1;
        trigger 2;
        }
    }

hide xmax = 640, ymax = 350;        // Video dimensions
hide x, y, bx, by;                  // Temp variables
hide color;                         // Color index
hide xsize, ysize;                  // Size of box

process draw_board
    {
    status_clr(board_defined);      // Status bit indicated board is defined

    wait    500;
    send("VI 16");
    wait    3000;

    if (bars < 1)                   // Verify hchecks, vchecks are ok
        bars = 1;
    if (bars > xmax / 2)
        bars = xmax / 2;

    if (xmax % bars)
        {
        printf("Warning! Bars (=%d) must evenly divide %d.\n", bars, xmax);
        }
    xsize = xmax / bars;            // Size of a box

    wait    100;

    send("RW 0 0; VP 0; CL");

    x = 0;
    color = 0;
    while (x < bars)
        {
        bx = x * xsize;
        sendf("CO %d; RF %d %d %d %d\n", color, bx, 0, bx + xsize, ymax);
        wait    100;
        x = x + 1;
        color = (color + 1) & 0xF;  // 0..15
        }

    wait    2000;
    status_set(board_defined);      // Status bit indicated board is defined
    }

process clear
    {
    send("RW 1 1; CL; RW 0 0; CL");
    }

process colors
    {
    suspend gen_display;
    wait    300;
    send("CM  0 0 0 2");
    send("CM  1 0 2 0");
    send("CM  2 2 0 0");
    send("CM  3 0 3 0");
    send("CM  4 3 1 1");
    send("CM  5 1 3 1");
    send("CM  6 1 0 3");
    send("CM  7 1 1 2");
    send("CM  8 2 2 1");
    send("CM  9 2 3 0");
    send("CM 10 2 2 2");
    send("CM 11 3 0 2");
    send("CM 12 2 1 3");
    send("CM 13 0 2 3");
    send("CM 14 2 3 3");
    send("CM 15 3 2 0");
    wait    300;
    spawn gen_display;
    }

hide pans_sent, pans_rcvd, loops;       // # of pans send, received
hide xcurrent;

process gen_display
    {
    com_autocancel(0);                  // Disable autocancel
    com_flush();                        // Start with a clear slate
    xcurrent = 0;
    sendf("PA %d 0;SN x\n", xcurrent);
    pans_sent = 1;
    pans_rcvd = 0;
    loops = 0;

    while (1)
        {
        c = com_count();
        if (c > 0)
            {
            if (max_c < c)
                max_c = c;
            
            pans_rcvd = pans_rcvd + c;
            com_flush();

            xcurrent = xcurrent + jump;
            if (xcurrent < 0)
                xcurrent = xcurrent + xmax;
            else if (xcurrent >= xmax)
                xcurrent = xcurrent - xmax;

            sendf("PA %d 0;SN x\n", xcurrent);
            pans_sent = pans_sent + 1;
            }
        nexttick;
        loops = loops + 1;
        }
    }
