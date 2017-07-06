/*  STREAM.PRO - Stream data to disk
** This protocol shows one way to continuously stream spike & analog
** data to disk.
**
** Also see RECORDER.PRO
*/

#include object.pro

stream_1 = 1;                           // TAG for first APP/EAP/UAP database
stream_2 = 2;                           // TAG for second database
                                        // Make sure the TAGs == the db number
write_db = 0;                           // This is the database to write

declare x[10];
constant cx = 1234;
speakerHz = 0;
declare LoopCount = 0;

declare constant XMAX=2000, YMAX=2000;  // Range of video
declare constant XSIZE = XMAX / 30;
declare constant YSIZE = YMAX / 30;
declare frozen = 0;                     // =1 to pause movement
declare xTarget, yTarget;               // Current position of target

declare WindowX = XSIZE * 4;
declare WindowY = YSIZE * 4;

process MAIN enabled
    {
    print();                            // Erase screen
    printf("How well can you track a moving object?\n");
    printf("Point mouse between + and O\n");
    printf("Click LEFT mouse to start tracking\n");
    printf("RIGHT mouse down pauses movement\n");
    printf("Stops when you are off target too much.\n");
    while (1)
        {
        trigger 1;
        trigger 2;
        wait    random(1000) + 4000;
        }
    }

process WRITER
    {
    HIDE    waits;

    waits = 0;
    while (getPendingDBTriggers(write_db))
        {
        waits = waits + 1;              // Count # of cycles we must wait
        nexttick;                       // Wait for pending triggers to be accumulated
        }

    //systemf("HSAVE %d; HSAVE %d\n", write_db, write_db + 2);
    systemf("HZERO %d; HZERO %d; FLUSH\n", write_db, write_db + 2);
    //printf("Zeroing %d and %d\n", write_db, write_db + 2);
    //writef("stream.txt Zeroing %d and %d\n", write_db, write_db + 2);
    }

process LOOPER enabled
    {
    declare hex yylocal, xlocal, ylocal;
    declare x = 1;

    while (1)
        {
        w = w + 1;
        ylocal = ylocal + 1;
        x = x + 1;
        LoopCount = LoopCount + 1;
        nexttick;
        }
    }

process ANIMATED enabled
    {
    declare hide x, y, offset;
    declare oTop, oBottom, oTrace;

    oSetGraph(gLEFT, aCLEAR);
    oSetGraph(gRIGHT, aCLEAR);
    oSetGraph(gLEFT, aTITLE, "Eye relative to target");
    oSetGraph(gRIGHT, aTITLE, "History of Eye Position");
    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX);
    oSetGraph(gRIGHT, aRANGE, 0, XMAX, 0, YMAX);

    oTop = oCreate(tCROSS, gLEFT, XSIZE, YSIZE);
    oSetAttribute(oTop, aFILLED);
    oSetAttribute(oTop, aXOR);
    oSetAttribute(oTop, aVISIBLE);

    oBottom = oCreate(tBOX, gLEFT, XSIZE, YSIZE);
    oSetAttribute(oBottom, aUNFILLED);
    oSetAttribute(oBottom, aXOR);
    oSetAttribute(oBottom, aVISIBLE);

    oTrace = oCreate(tBOX, gRIGHT, WindowX, WindowY);
    //oSetAttribute(oTrace, aFILLED);
    oSetAttribute(oTrace, aREPLACE);
    oSetAttribute(oTrace, aVISIBLE);

    x1 = 0; y1 = WindowY;
    while (1)
        {
        if (!frozen)
            {
            offset = y1 + WindowY / 2;
            if (offset < 0)
                offset = offset + YMAX;
            offset = offset % YMAX;

            oMove(oTop, x1, y1);
            oMove(oBottom, x1, offset);

            xTarget = x1;
            yTarget = (y1 + offset) / 2;
            oMove(oTrace, xTarget, yTarget);

            x1 = (x1 + 3 + (XSIZE/2 - random(XSIZE)));
            if (x1 < 0)
                x1 = x1 + XMAX;
            x1 = x1 % XMAX;

            y1 = (y1 + 2 + (YSIZE/2 - random(YSIZE)));
            if (y1 < 0)
            y1 = y1 + YMAX;
            y1 = y1 % YMAX;
            }

        wait 50;
        }
    }

process EVENT_EMIT enabled
    {
    while (1)
        {
        wait 10 + random(70);
        event_set(1, random(5) + 1);
        wait 10 + random(50);
        event_set(2, random(7) + 1);
        }
    }


process JUICE
    {
    declare i;

    i = 500;
    while (i < 1000)
        {
        sound(i);
        wait 50;
        sound(0);
        wait 50;
        i = i + 50;
        }
    }

process HAND enabled
    {
    declare oHand, oTrace;          // hand2 is a trace of where hand has been
    declare ax, ay, hx, hy;
    declare button;                 // bit0=LEFT, bit1=RIGHT mouse button state

    oTrace = oCreate(tBOX, gRIGHT, XSIZE, YSIZE);
    oSetAttribute(oTrace, aREPLACE);
    oSetAttribute(oTrace, aVISIBLE);

    oHand = oCreate(txCROSS, gLEFT, XSIZE*2, YSIZE*2);

    while (1)
        {
        ax = atable(1);
        ay = atable(2);
        hx = (ax + 2048) * XMAX / 4096;
        hy = (ay + 2048) * YMAX / 4096;
        oMove(oHand, hx, hy);
        oMove(oTrace, hx, hy);

        if (button != mouGetButtons())          // Did mouse buttons change?
            {
            button = mouGetButtons();           // Update our state
            if (button & 1)                     // is LEFT mouse button down?
                oSetGraph(gRIGHT, aCLEAR);      // Clear display with LEFT down

            frozen = button & 2;                // Freeze movement when RIGHT DOWN
            }

        // Check for correctness

        if (!Frozen)
            {
            dx = abs(hx - xTarget);
            dy = abs(hy - yTarget);
            if (dx > WindowX / 2 || dy > WindowY / 2)
                {
                sound (100);
                wait 50;
                sound (0);
                wait 50;

                sound (100);
                wait 50;
                sound (0);
                wait 50;

                sound (100);
                wait 50;
                sound (0);
                wait 50;

                oSetGraph(gRIGHT, aCLEAR);      // Clear display with LEFT down
                Frozen = 1;             // Freeze display
                }
            }

        nexttick;
        }
    }
