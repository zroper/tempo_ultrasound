page = 0;               /* Video page we write to */
box = 5;
waittime=40;            /* # of milliseconds between updates 1000/40=minimum*/

// We must declare process names

DECLARE MAIN(), PAGE0(), PAGE1();

process main enabled
    {
    send("RW 1 1");
    send("CL");
    send("RW 0 0");
    send("CL");
    send("VP 0");
    x = 101;
    y = 3;
    dx = 1;
    dy = 2;
    while (1)
        {
        x = x + dx;
        y = y + dy;
        if (x > 600 || x < 0)
            {
            dx = - dx;
            x = x + dx;
            }
        if (y > 300 || y < 0)
            {
            dy = - dy;
            y = y + dy;
            }

        if (page) xeq page0;
        else      xeq page1;
        page = 1 - page;

//        nexttick;
        wait    waittime;
        }
    }

/* PAGE0 - clear previous box, draw new box, set visual page */
process page0
    {
    send("RW ", 0, 0);
    send("CO 0");
    send("RF ", x0, y0, x0 + box, y0 + box);      /* Erase */
    x0 = x;
    y0 = y;
    send("CO 11");
    send("RF ", x0, y0, x0 + box, y0 + box);      /* Draw */
    send("VP 0");
    }

/* PAGE1 - clear previous box, draw new box, set visual page */
process page1
    {
    send("RW ", 1, 1);
    send("CO 0");
    send("RF ", x1, y1, x1 + box, y1 + box);      /* Erase */
    x1 = x;
    y1 = y;
    send("CO 11");
    send("RF ", x1, y1, x1 + box, y1 + box);      /* Draw */
    send("VP 1");
    }
