/* MIOTEST.PRO - Calibration protocol for testing MIO card.
 *
 *  This little test protocol helps you verify that various functions of
 *  the MIO card are working properly.  (See your MIO reference manual for
 *  exact pin settings.)  It also illustrates using multiple processes
 *  for various activities.
 *
 *  Here, we test
 *
 *      o The analog inputs (first 4 channels)  (pins 3,5,7,9)
 *      o The 2 analog outputs                  (pins 20,21)
 *      o The 4 TTL outputs                     (pins 25,27,29,31)
 *      o The 4 TTL inputs                      (pins 26,28,30,32)
 *
 *  Two analog input graphs are displayed showing values from analog
 *  input channels 1-4.  The top (SUM) graph shows the analog channels
 *  averaged and the bottom (APP) displays the raw signal epoch-by-epoch.
 *  Connect a wave form generator to analog input channels 1-4 and you
 *  should see the waveform in the graph.
 *
 *  The MIO's 4 TTL inputs are loaded into variables and displayed in
 *  TEMPO's "SHOW S" display.  Connect switches to the MIO's TTL inputs 
 *  and you should see the 4 TTL input variables change.  Note that these
 *  inputs are automatically loaded into the 4 high bits of TEMPO's
 *  STATUS word (displayed at the top of TEMPO's screen) so you should
 *  see the STATUS change as well.
 *
 *  The MIO's TTL 4 outputs toggle ON and OFF - you can see this if you
 *  hook up a scope to the MIO's 4 TTL out ports.  Note that on some cards
 *  the TTL values may float (change at random) if nothing is connected
 *  to them.
 *
 *  Every second, the two MIO analog outputs are set to the current
 *  value of the MIO analog input channels (1 & 2).  You can scope
 *  the MIO's two analog outputs to see that they change according
 *  to the MIO's analog inputs.
 *
 *  If you are using the DAS-1200/1400/1600, there are only 3 TTL inputs
 *  so you should comment out the line marked DAS1600 below:
 */
HIDE TTLOUT1     = 0;                   // 4 TTL output ports
HIDE TTLOUT2     = 1;
HIDE TTLOUT3     = 2;
HIDE TTLOUT4     = 3;

HIDE TTLIN1      = 0;                   // 4 TTL input ports
HIDE TTLIN2      = 1;
HIDE TTLIN3      = 2;
HIDE TTLIN4      = 3;

HIDE AOUT1       = 0;
HIDE AOUT2       = 1;

process MAIN enabled                    // "enabled" means this process starts
    {                                   // running as soon as it is loaded.
    count = 0;
    all_done = 0;                       // flag indicating test is complete

    spawn TTL_INPUTS;
    spawn ANALOG_OUTPUTS;    
    spawn TTL_OUTPUTS;

    while (count < 5)                   // Loop 5 times
        {
        count = count + 1;
        system("hzero *");              // Zero out all data
        wait    1000;                   // Give it time to clear

        while (htb_sweep(1) < htb_sweeps(1))
            {
            trigger 1;
            wait    1000;               // 1 sec
            }

        print("Trial ", count * htb_sweeps(1));
        wait    1000;                   // Wait for display of final collection
        }

    all_done = 1;

    printf("Test is complete.\n");
    }

process TTL_OUTPUTS
    {
    ttloutputs = 0;                        // 0=off, 1=on
    while (!all_done)
        {
        ttloutputs = 1 - ttloutputs;       // flip: 0->1, 1->0
        mio_dig_set(TTLOUT1, ttloutputs);
        mio_dig_set(TTLOUT2, ttloutputs);
        mio_dig_set(TTLOUT3, ttloutputs);
        mio_dig_set(TTLOUT4, ttloutputs);
        wait    1000;
        }    

    ttloutputs = 0;                         // Leave them cleared
    mio_dig_set(TTLOUT1, ttloutputs);
    mio_dig_set(TTLOUT2, ttloutputs);
    mio_dig_set(TTLOUT3, ttloutputs);
    mio_dig_set(TTLOUT4, ttloutputs);
    }

process TTL_INPUTS
    {
    while (!all_done)
        {
        ttlinput1 = mio_dig_get(TTLIN1);
        ttlinput2 = mio_dig_get(TTLIN2);
        ttlinput3 = mio_dig_get(TTLIN3);
//        ttlinput4 = mio_dig_get(TTLIN4);    // Comment out for DAS1600
        nexttick;
        }    
    }

process ANALOG_OUTPUTS
    {
    while (!all_done)
        {
        analogout1 = atable(1);         // Get analog input channel 1
        analogout2 = atable(2);
        mio_ao_set(AOUT1, analogout1);
        mio_ao_set(AOUT2, analogout2);
        nexttick;
        }

    analogout1 = 0;                     // Reset them to 0
    analogout2 = 0;
    mio_ao_set(AOUT1, analogout1);
    mio_ao_set(AOUT2, analogout2);
    }
