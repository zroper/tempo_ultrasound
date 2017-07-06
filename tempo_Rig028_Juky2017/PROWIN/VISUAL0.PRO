    // VISUAL0.PRO - Demonstration protocol for animated graphics
    // Each object moves in 2D according to analog input values.

    #include    OBJECT.PRO

    process Main enabled
        {
        oSetGraph(gLEFT, aRANGE, -2047, 2047, -2047, 2047);
        o1 = oCreate(tCROSS, gLEFT,   100, 100);

        oSetGraph(gRIGHT, aRANGE, -2047, 2047, -2047, 2047);
        o2 = oCreate(tBOX,   gRIGHT,  100, 100);

        while (1)
            {
            oMove(o1, atable(1), atable(2)); // Analog channels 1 & 2
            oMove(o2, atable(3), atable(4)); // Analog channels 3 & 4
            wait    50;
            }
        }
