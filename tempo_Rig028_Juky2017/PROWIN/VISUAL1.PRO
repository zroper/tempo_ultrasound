/* VISUAL1.PRO - Demonstration test protocol for Visual TEMPO.
 * Test program for Visual TEMPO's real-time display, SHOW M.
 * This protocol simply displays lots of objects, each doing its own thing.
 * Input data is based on analog input channels 1-8.
 */

#include    object.pro                  // Object definitions

process main enabled
    {
    xrange = 50;
    yrange = 50;
    oSetGraph(gLEFT,  aRange, xrange, -xrange, yrange, -yrange);
    oSetGraph(gLEFT,  aTitle, "Left eye cue on target");
    oSetGraph(gRIGHT, aRange, -xrange, xrange, yrange, -yrange);
    oSetGraph(gRIGHT, aTitle, "Right eye inside coil window");

    oEye0 = oCreate(tPOINT, gLEFT);
    oSetAttribute(oEye0, aReplace);
    oBox0 = oCreate(tBOX, gLEFT, 5, 5);
    oSetAttribute(oBox0, aFilled);

    oEye1 = oCreate(tPOINT, gRIGHT);
    oSetAttribute(oEye1, aReplace);
    oBox1 = oCreate(tBOX, gRIGHT, 3, 3);
    oSetAttribute(oBox1, aReplace);

    spawn Visual;
    }

process Visual
    {
    while (1)
        {
        oMove(oEye0, atable(1), atable(2));
        oMove(oEye1, atable(2), atable(3));
        oMove(oBox0, atable(4), atable(5));
        oMove(oBox1, -atable(5), -atable(2));
        wait    100;
        }
    }

process CollectData enabled
    {
    while (1)
        {
        wait    2000;
        trigger 1;
        }
    }

process Fixate enabled
    {
    oFixate0 = oCreate(tCROSS, gLEFT, 13, 13);
    oFixate1 = oCreate(tCROSS, gRIGHT, 10, 10);
    oFixate2 = oCreate(tXCROSS, gLEFT, 25, 25);
    oFixate3 = oCreate(tXCROSS, gRIGHT, 20, 20);
    while (1)
        {
        wait    random(1000);
        oMove(oFixate0, atable(1), atable(3));
        wait    random(2000);
        oMove(oFixate1, atable(3), atable(1));
        wait    random(3000);
        oMove(oFixate2, atable(2), atable(5));
        wait    random(1000);
        oMove(oFixate3, atable(3), atable(4));
        }
    }

process Hider enabled
    {
    while (1)
        {
        wait    random(1000);
        oSetAttribute(oFixate0, aInvisible);
        wait    random(2000);
        oSetAttribute(oFixate1, aInvisible);
        wait    random(3000);
        oSetAttribute(oFixate2, aInvisible);
        wait    random(1000);
        oSetAttribute(oFixate3, aInvisible);

        wait    random(1000);
        oSetAttribute(oFixate0, aVisible);
        wait    random(2000);
        oSetAttribute(oFixate1, aVisible);
        wait    random(3000);
        oSetAttribute(oFixate2, aVisible);
        wait    random(1000);
        oSetAttribute(oFixate3, aVisible);
        }
    }
