/* GROW.PRO Tests changing box, x, + size changes
 */
#include    object.pro

size = 100;
count = 0;
jump = 1000;

process MAIN enabled
    {
    size = 10;
    direction = 10;
    oSetGraph(gLEFT,  aRANGE, -1000, 1000, -1000, 1000);
    oSetGraph(gRIGHT, aRANGE, -1000, 1000, -1000, 1000);

    lbox   = oCreate(tBOX,    gLEFT, size, size);
    lcross = oCreate(tCROSS,  gLEFT, size, size);
    lplus  = oCreate(tXCROSS, gLEFT, size, size);

    rbox   = oCreate(tBOX,    gRIGHT, size, size);
    rcross = oCreate(tCROSS,  gRIGHT, size, size);
    rplus  = oCreate(tXCROSS, gRIGHT, size, size);

    oSetAttribute(rbox,   aREPLACE);
    oSetAttribute(rcross, aREPLACE);
    oSetAttribute(rplus,  aREPLACE);

    while (size > 0)
        {
        if ((size % 50) == 0)
            printf("Size=%d\n", size);

        oSetAttribute(lbox,   aSIZE, size, size);
        oSetAttribute(lcross, aSIZE, size, size);
        oSetAttribute(lplus,  aSIZE, size, size);

        oSetAttribute(rbox,   aSIZE, size, size);
        oSetAttribute(rcross, aSIZE, size, size);
        oSetAttribute(rplus,  aSIZE, size, size);

        x = random(jump) - jump / 2; y = random(jump) - jump / 2;
        oMove(lbox, x, y);
        oMove(rbox, x, y);
    
        x = random(jump) - jump / 2; y = random(jump) - jump / 2;
        oMove(lcross, x, y);
        oMove(rcross, x, y);

        x = random(jump) - jump / 2; y = random(jump) - jump / 2;
        oMove(lplus, x, y);
        oMove(rplus, x, y);

        wait    500;

        if (size >= 300)
            direction = -10;

        size = size + direction;
        }

    oSetAttribute(lbox,   aINVISIBLE);
    oSetAttribute(lcross, aINVISIBLE);
    oSetAttribute(lplus,  aINVISIBLE);

    oSetAttribute(rbox,   aINVISIBLE);
    oSetAttribute(rcross, aINVISIBLE);
    oSetAttribute(rplus,  aINVISIBLE);

    wait    1000;

    oDestroy(lbox);
    oDestroy(lcross);
    oDestroy(lplus);

    oDestroy(rbox);
    oDestroy(rcross);
    oDestroy(rplus);

    print("All done.");
    }
