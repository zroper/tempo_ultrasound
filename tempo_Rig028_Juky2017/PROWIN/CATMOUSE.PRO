// CATMOUSE.PRO - Protocol to demonstrate VideoSYNC sprites
//
// The mouse is a sprite that occasionally jumps around the screen; the
// mouse is in only one place at a time (i.e. XOR drawing).
//
// The cat is another sprite moves in small increments towards the mouse
// and it leaves tracks of where its been (i.e. REPLACE drawing).
//
// The cat tracker is another sprite thatperiodically marks the cat's
// position as it chases the mouse.  It is drawn with XOR.
//

#include object.pro

HIDE XMAX = 640;
HIDE YMAX = 350;

DECLARE catx, caty;

// We must declare process names

DECLARE MAIN(), INIT(), CAT(), MOUSE(), COLLECT();
DECLARE CAT_TRACKER();

jump = 3;                               // # of pixels cursor moves by

process MAIN enabled
    {
    while (1)
        {
        spawn INIT;
        wait 60000;                     // Run for 1 minute
        suspend CAT;
        suspend MOUSE;
        suspend CAT_TRACKER;
        system("HZERO *");
        }
    }

process INIT 
    {
    done = 0;
    send("CA");
    sendf("VC 0,%d,0,%d;\n", XMAX, YMAX);

    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX);
    oSetGraph(gRIGHT, aRANGE, 0, XMAX, 0, YMAX);

    oSetGraph(gLEFT, aTITLE, "Current");
    oSetGraph(gRIGHT, aTITLE, "History");

    if (oCat)    oDestroy(oCat);
    if (oMouse)  oDestroy(oMouse);
    if (oCat1)   oDestroy(oCat1);
    if (oMouse1) oDestroy(oMouse1);

    oSetGraph(gLEFT, aCLEAR);
    oSetGraph(gRIGHT, aCLEAR);

    oCat = oCreate(tCROSS, gLEFT, 15, 15);
    oMouse = oCreate(tBOX, gLEFT, 20, 20);
    oCat1 = oCreate(tPoint, gRIGHT);
    oMouse1 = oCreate(tBOX, gRIGHT, 20, 20);
    oSetAttribute(oCat1, aREPLACE);
    oSetAttribute(oMouse1, aREPLACE);

    oSetAttribute(oMouse, aFILLED);

    wait 2000;

    spawn CAT;
    spawn MOUSE;
    spawn CAT_TRACKER;
    done = 0;
    }

process CAT
    {
    send("OC 0,2");                         // Create Cat, sprite 0 (a point)
    send("OW 0,4,4");                       // a little fellar
    send("OI 0,15");                        // white
    send("OS 0");                           // show

    while (1)
        {
        if (abs(mousex - catx) >= jump)
            catx = catx + jump * sign(mousex - catx);

        if (abs(mousey - caty) >= jump)
            caty = caty + jump * sign(mousey - caty);

        sendf("OM 0,%d,%d\n", catx, caty);
        oMove(oCat, catx, caty);
        oMove(oCat1, catx, caty);

        wait    50;
        }
    }

process CAT_TRACKER
    {
    DECLARE HIDE old_catx, old_caty;

    send("OC 1,2");                         // Create Cat tracker, sprite 1
    send("OF 1");                           // filled
    send("OW 1,8,8");                       // a little wider
    send("OI 1,14");                        // yellow
    send("OS 1");                           // show

    while (1)
        {
        sendf("OM 1,%d,%d\n", old_catx, old_caty);
        old_catx = catx;
        old_caty = caty;
        wait    250;
        }
    }

process MOUSE
    {
    send("OC 2,2");                         // Create Mouse, sprite 2
    send("OF 2");                           // filled..
    send("OW 2,_xmax/50,_ymax/50");         // ..and fat (more tasty)
    send("OI 2,13");                        // light magenta
    send("OS 2");                           // show

    while (1)
        {
        wait random(5000);
        mousex = random(XMAX);
        mousey = random(YMAX);
        color = (mousex * mousey) & 0xF;

        if (!color) color = 1 + random(14);

        sendf("OM 2,%d,%d\n", mousex, mousey);
        oMove(oMouse, mousex, mousey);
        oMove(oMouse1, mousex, mousey);
        }
    }

process COLLECT enabled
    {
    while (1)
        {
        if (catx - mousex < 10 && caty-mousey < 10)
            {
            trigger 1;
            wait 1300;
            trigger 2;
            wait 900;
            }
        nexttick;
        }
    }
