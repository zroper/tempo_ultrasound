// VIO.PRO - Test VIO routines (for KCV KERNEL)

#include    object.pro

HIDE VIDEO = 261;
XMAX = 0;
YMAX = 0;
HIDE NRGB = 0;

pause = 10;
xjump = 1;
yjump = 3;

x1 = 0, y1 = 0;                         // cursor1 position and size
size1 = 2;
x2 = XMAX/3, y2 = YMAX/3;               // cursor2 position and size
size2 = 3;

HIDE c1 = 9;                            // cursor1 color
HIDE c2 = 12;                           // cursor2 color
HIDE o1, o2;
hide n, i;

hide sunX = 350, sunY = 250, sunColor = 3;

process MAIN enabled
    {
    //vio_vi(video);
    while (vio_get_used()) nexttick;    // Wait for completion
    nrgb = vio_get_nrgb() - 1;
    xmax = vio_get_xmax();
    ymax = vio_get_ymax();

    vio_ca();

    spawn CLEAR;

    vio_co(13);
    vio_rf(10,10,200,200);

    vio_co(15);
    vio_ru(0,0,XMAX-1,YMAX-1);

    vio_co(3);
    vio_mv(20,45);
    vio_dr(300,200);

    vio_co(15);
    vio_eu(sunX, sunY + 10, 240, 35);

    vio_co(sunColor);
    vio_ef(sunX, sunY, 40, 40);

    oSetGraph(gLEFT, aTITLE, "Left Hand Position");
    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX);
    o1 = oCreate(tBOX, gLEFT, 20, 20);

    oSetGraph(gRIGHT, aTITLE, "Right Hand Position");
    oSetGraph(gRIGHT, aRANGE, 0, XMAX, 0, YMAX);
    o2 = oCreate(tCROSS, gRIGHT, 20, 20);

    while (vio_get_used()) nexttick;    // Wait for completion
    printf("Mode=%d Res=(%d,%d), %d colors (rgb=0-%d)",
        vio_get_video(), xmax, ymax, vio_get_ncolors(), nrgb);
    printf(", %d pages\n", vio_get_npages());

    vio_dl(3);                              // XOR drawing
    vio_co(c1);
    vio_rf(x1, y1, x1+size1, y1+size1);     // Draw first cursor

    vio_co(c2);
    vio_rf(x2, y2, x2+size2, y2+size2);     // Draw second cursor
    vio_dl(0);                              // REPLACE drawing
    while (vio_get_used()) nexttick;        // Wait for completion

    spawn CURSOR1;
    //spawn CURSOR2;
    }

process CURSOR1
    {
    spawn CRASH1;
    while (1)
        {
        vio_dl(3);                      // XOR drawing
        vio_co(c1);
        vio_rf(x1, y1, x1+size1, y1+size1);     // Erase cursor
        x1 = abs(x1 + yjump) % XMAX;
        y1 = abs(y1 + xjump) % YMAX;
        vio_rf(x1, y1, x1+size1, y1+size1);
        n = vio_dl(0);                  // REPLACE drawing
        if (nmax < n) nmax = n;

        oMove(o1, x1, y1);
        if (pause > 0)
            wait    pause;
        else
            nexttick;
        }
    }

process CURSOR2
    {
    spawn CRASH2;
    while (1)
        {
        vio_dl(3);                      // XOR drawing
        vio_co(c2);
        vio_rf(x2, y2, x2+size2, y2+size2);     // Erase cursor
        x2 = (x2 + xjump) % XMAX;
        y2 = (y2 + yjump) % YMAX;
        vio_rf(x2, y2, x2+size2, y2+size2);
        n = vio_dl(0);                  // REPLACE drawing
        if (nmax < n) nmax = n;

        oMove(o2, x2, y2);
        if (pause > 0)
            wait    pause;
        else
            nexttick;
        }
    }

process CRASH1
    {
    while (1)
        {
        d1 = (x1 - sunX) * (x1 - sunX) + (y1 - sunY) * (y1 - sunY);
        if (d1 < 40*40)
            {
            vio_cm(sunColor, nrgb, nrgb, nrgb);
            sound(200);
            wait    500;
            sound(0);
            vio_cm(sunColor, nrgb, 0, 0);
            }
        nexttick;
        }
    }

process CRASH2 
    {
    while (1)
        {
        d2 = (x2 - sunX) * (x2 - sunX) + (y2 - sunY) * (y2 - sunY);
        if (d2 < 60*60)
            {
            vio_cm(sunColor, nrgb, nrgb, 0);
            sound(400);
            wait    1000;
            sound(0);
            vio_cm(sunColor, nrgb, 0, nrgb);
            }
        nexttick;
        }
    }

process CLEAR
    {
    vio_cl();
    }
