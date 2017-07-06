// DDX2.PRO - Show VideoSYNC (DDX) moving two cursors, one is the mouse.
// Copyright 1994 Sheldon Hoffman.  All rights reserved.
//
// This protocol requires that you define DDX_BASE and DDX_SIZE
// in your KERNEL configuration and use a version of the kernel that
// includes the DIO module.
//
// The second cursor is implemented with WORDPLAY macros using the
// XOR drawing mode.  If, before you start the protocol, you set mouse=0,
// both cursors will be implemented as WORDPLAY macros and the mouse
// won't be used.
// The size (size1, size2) of WORDPLAY's "cursors" must be adjusted
// before starting the protocol, if desired.
// You can change the speed of either cursor at any time by setting
// x1jump, y1jump or x2jump, y2jump.

#include    object.pro

constant XMAX = 1024 - 1;
constant YMAX = 768 - 1;
pause = 25;
ddxout, maxddxout;

x1jump = 1; y1jump = 1;                 // # of pixes to move cursor 1
x2jump = 2; y2jump = 3;                 // # of pixes to move cursor 2
size1 = 5;
size2 = 7;
mouse = 0;

process MAIN enabled
    {
    //dsend("vi 261");                  // Set WORDPLAY's video mode
    dsend("vc", 0, XMAX, 0, YMAX);
    dsend("co 15");
    spawn   CLEAR;                      // Clear screen
    if (mouse)
        {
        dsendf("dm c1($1,$2);VW;MM $1,$2;em\n", size1, size1, size1, size1);
        print("Cursor 1 is the MOUSE");
        }
    else
        {
        dsendf("dm c1($1,$2);co 15;dl 3;vw;rf c1x,c1y,c1x+%d,c1y+%d;sv c1x=$1;sv c1y=$2;rf c1x,c1y,c1x+%d,c1y+%d;dl 0;em\n",
            size1, size1, size1, size1);
        print("Cursor 1 is a WORDPLAY macro");
        }
    dsendf("dm c2($1,$2);co 13;dl 3;vw;rf c2x,c2y,c2x+%d,c2y+%d;sv c2x=$1;sv c2y=$2;rf c2x,c2y,c2x+%d,c2y+%d;dl 0;em\n",
        size2, size2, size2, size2);

    print("Adjust speed by changing x1jump, y1jump or x2jump, y2jump");

    // Draw rest of screen

    dsend("co 14;rf 100,100,200,200");
    dsend("co 3;rf 20,20,40,40");
    dsend("co 5;ef 500,550,50,90");
    dsend("co 4;rf 20,520,40,640");

    // Draw first cursor

    if (mouse) dsend("MS");
    else       dsendf("co 15;dl 3;rf c1x,c1y,c1x+%d,c1y+%d;dl 0\n", size1, size1);

    dsendf("co 13;dl 3;rf c2x,c2y,c2x+%d,c2y+%d;dl 0\n", size2, size2);

    wait    500;
    spawn   CURSOR1;
    spawn   CURSOR2;
    spawn   DATA;
    }

process CURSOR1
    {   
    DECLARE HIDE  o, x, y;

    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX);
    o = oCreate(tBOX, gLEFT, 10, 10);
    y = YMAX / 2;
    x = XMAX / 2;
    while (1)
        {
        x = (x + x1jump) % (XMAX - 10);
        y = (y + y1jump) % (YMAX - 10);
        oMove(o, x, y);
        ddxout = dsendf("xm c1(%d,%d)\r\n", x, y);   // move cursor1
        if (maxddxout < ddxout) maxddxout = ddxout;
        wait    pause;
        }
    }

process CURSOR2
    {
    DECLARE HIDE  o, x, y;

    oSetGraph(gRIGHT, aRANGE, 0, XMAX, 0, YMAX);
    o = oCreate(tBOX, gRIGHT, 10, 10);
    y = YMAX / 4;
    x = XMAX / 4;
    while (1)
        {
        x = (x + x2jump) % (XMAX - 10);
        y = (y + y2jump) % (YMAX - 10);
        oMove(o, x, y);
        ddxout = dsendf("xm c2(%d,%d)\r\n", x, y);   // move cursor2
        if (maxddxout < ddxout) maxddxout = ddxout;
        wait    pause;
        }
    }

process DATA
    {HIDE count = 0;
    while (1)
        {
        wait    1700;
        trigger 1;
        count = count+1;
        if (count > htb_sweeps(1))
            {
            count = 0;
            system("hzero *");
            while (system())
                nexttick;
            }
        }
    }

process CLEAR
    {
    dsend("cl\n");
    }
