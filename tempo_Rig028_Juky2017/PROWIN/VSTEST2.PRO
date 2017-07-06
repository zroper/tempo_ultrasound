// DSEND1.PRO - Simple protocol with VideoSYNC (DDX) for moving a cursor.
// Copyright 1994 Sheldon Hoffman.  All rights reserved.
//
// This protocol requires that you define DDX_BASE and DDX_SIZE
// in your KERNEL configuration and use a version of the kernel that
// includes the DIO module.

declare XMAX = 640;
declare YMAX = 350;

process MAIN enabled
    {
    cnt = dsend("cl; co 15; rf 10,10,100,100");
    if (maxcnt < cnt) maxcnt = cnt;
    }

process DDX enabled
    {
    while (1)
        {
        cnt = dsendf("co %d;rf %d,%d,%d,%d\n", x % 16, x, y, x+10, y+10);
        if (maxcnt < cnt) maxcnt = cnt;
        x = (x + 3) % XMAX;
        y = (y + 5) % YMAX;
        wait    20;
        }
    }
