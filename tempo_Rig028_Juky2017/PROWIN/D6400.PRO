// D6400.PRO - Test various hardware parts on the CIO-DAS-6400

// Declare process names

DECLARE MAIN(), ANALOGIN(), ANALOGOUT(), TTLOUT(), TTLIN();

process MAIN enabled
    {
    spawn TTLOUT;
    spawn TTLIN;
    spawn ANALOGOUT;
    spawn ANALOGIN;
    }

process ANALOGIN
    {
    while (1)
        {
        ain1pin2 = atable(1);
        ain2pin4 = atable(2);
        ain3pin6 = atable(3);
        ain4pin8 = atable(4);
        ain5pin10 = atable(5);
        ain6pin12 = atable(6);
        ain7pin14 = atable(7);
        ain8pin16 = atable(8);
        nexttick;
        }
    }

process ANALOGOUT
    {
    declare dir0 = 1, dir1 = -1;

    aout0pin35 = -2047;
    aout1pin37 = 2047;

    while (1)
        {
        aout0pin35 = aout0pin35 + dir0;
        if (aout0pin35 < -2047)
            {
            dir0 = 1;
            aout0pin35 = aout0pin35 + dir0;
            }
        else if (aout0pin35 > 2047)
            {
            dir0 = -1;
            aout0pin35 = aout0pin35 + dir0;
            }
        mio_ao_set(0, aout0pin35);

        aout1pin37 = aout1pin37 + dir1;
        if (aout1pin37 < -2047)
            {
            dir1 = 1;
            aout1pin37 = aout1pin37 + dir1;
            }
        else if (aout1pin37 > 2047)
            {
            dir1 = -1;
            aout1pin37 = aout1pin37 + dir1;
            }
        mio_ao_set(1, aout1pin37);

        nexttick;
        }
    }

process TTLOUT              // Toggle ttl outs at 1 Hz
    {
    ttlOUT0pin85 = 1;
    ttlOUT0pin86 = 0;
    ttlOUT0pin87 = 1;
    ttlOUT0pin88 = 0;
    ttlOUT0pin95 = 1;
    ttlOUT0pin96 = 0;
    ttlOUT0pin97 = 1;
    ttlOUT0pin98 = 0;

    while (1)
        {
        ttlOUT0pin85 = 1 - ttlOUT0pin85;
        ttlOUT0pin86 = 1 - ttlOUT0pin86;
        ttlOUT0pin87 = 1 - ttlOUT0pin87;
        ttlOUT0pin88 = 1 - ttlOUT0pin88;
        ttlOUT0pin95 = 1 - ttlOUT0pin95;
        ttlOUT0pin96 = 1 - ttlOUT0pin96;
        ttlOUT0pin97 = 1 - ttlOUT0pin97;
        ttlOUT0pin98 = 1 - ttlOUT0pin98;
        mio_dig_set(0, ttlOUT0pin85);
        mio_dig_set(0, ttlOUT0pin86);
        mio_dig_set(0, ttlOUT0pin87);
        mio_dig_set(0, ttlOUT0pin88);
        mio_dig_set(0, ttlOUT0pin95);
        mio_dig_set(0, ttlOUT0pin96);
        mio_dig_set(0, ttlOUT0pin97);
        mio_dig_set(0, ttlOUT0pin98);
        wait 1000;
        }
    }

process TTLIN                           // Load TTLins every process cycle
    {
    while (1)
        {
        ttlIN0pin42 = mio_dig_get(0);
        ttlIN1pin43 = mio_dig_get(1);
        ttlIN2pin40 = mio_dig_get(2);
        ttlIN3pin44 = mio_dig_get(3);
        ttlIN4pin45 = mio_dig_get(4);
        ttlIN5pin46 = mio_dig_get(5);
        ttlIN6pin93 = mio_dig_get(6);
        ttlIN7pin94 = mio_dig_get(7);
        nexttick;
        }
    }
