process main enabled
    {
    send("CL");
    x = 101;
    y = 3;
    dx = 1;
    dy = 2;
    while (1)
        {
        send("CO 0");
        send("RF ", x, y, x + 10, y + 10);      /* Erase */
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

        send("CO 11");
        send("RF ", x, y, x + 10, y + 10);      /* Draw */
        nexttick;
        }
    }
