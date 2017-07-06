/* CIOTEST.PRO - Test CIO-DAS08 functions for KCD KERNEL
** Copyright 1994 Sheldon Hoffman.  All rights reserved.
**
** (This is for users with a CIO-DAS8 compatible card.)
** This protocol exercises various capabilities of the DAS8 card.
**
**  mio_dig_get()       3 TTL inputs
**  mio_dig_set()       4 TTL outputs
**  atable()            8 analog inputs
**  tio_fout()          High speed pulse output (counter 2 OUT)
*/
#include CIO.PRO

fout_n  = CIO_FOUT / 100;               // 4Mhz count down rate for counter 2
fout_on = 1;                            // Counter 2 OUT 1=on, 0=off

// Collect 8 analog input channels into a database

process ANALOG_IN enabled
    {
    while (1)
        {
        if (htb_sweep(1) == htb_sweeps(1))
            system("hzero *");          // Trash DB when its full

        wait    1000;
        trigger 1;
        }
    }

// Flip 4 TTL outputs off and on.

process MIO_OUT enabled
    {
    pinout7 = 0;
    pinout8 = 1;
    pinout9 = 0;
    pinout10 = 1;
    while (1)
        {
        wait    50;
        pinout7 = 1 - pinout7;
        pinout8 = 1 - pinout8;
        pinout9 = 1 - pinout9;
        pinout10 = 1 - pinout10;
        mio_dig_set(0, pinout7);
        mio_dig_set(1, pinout8);
        mio_dig_set(2, pinout9);
        mio_dig_set(3, pinout10);
        }
    }

// Exercise counter 2 on CIO-DAS8 as a frequency pulse generater.

process FOUT enabled
    {
    tio_fout(0, fout_n, fout_on);       // Pin 6 is COUNTER 2 OUT
    }
