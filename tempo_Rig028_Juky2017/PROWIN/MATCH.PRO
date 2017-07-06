/* MATCH.PRO - MATCH TO SAMPLE TASK.
;
; BASIC TASK
;   The monkey is presented with two stimuli and must decide whether
;   they are identical.  If they are the same, the monkey must maintain
;   the bar press until the fp goes out.  If they are different, the
;   monkey must release the bar during the response period.
;
;   Also, the monkey must continue fixating throughout the task.  If
;   the monkey strays outside a window around the fp, a failure results.
;
;   Display fp
;   wait appx 500ms                 (wait1)
;   display sample stimulus
;   wait appx 500ms                 (wait2)
;   erase sample
;   wait appx 500ms                 (wait3)
;   display test stimulus
;   wait appx 500ms                 (wait4)
;   erase test stimulus
;   wait for monkey response (appx 1000ms response period)   (wait5)
;   erase fp
;   if response==correct, give juice.  Otherwise, ring bell
;   wait inter-trial time 500ms     (wait6)
;
; ASSUMPTIONS
;   analog channels 1,2 = eye coil x,y
;   spike channels 1-4 are collected
;   mio ttl 1 in = bar
;   mio ttl 1 out = juice
;   mio ttl 2 out = bell
;
; EDIT HISTORY
;   11 Sep 93 sh    Initial edit
;   12 Jul 94 sh    Add inter-trial wait time (wait6)
;                   Increase allowable response time (wait5)
;                   When samples match, display + object.  Otherwise show x.
;   27 Feb 95 sh    In process, FP_ON emit event EVT_FP_ON
*/
         DEBUG = 1;                     // =1 for debug code.

HIDE HEX BAR_TTL    = 0x10000000;       // MIO TTL INPUT FROM BAR
HIDE     BELL_TTL   = 1;                // MIO TTL OUTPUT TO BELL
HIDE     JUICE_TTL  = 2;                // MIO TTL OUTPUT TO JUICE

#include match1.pro                     // Our special events
#include object.pro                     // OBJECT definitions

HIDE wait1 = 500;                       // Between FP ON and SAMPLE ON
HIDE wait2 = 500;                       // Between SAMPLE ON and SAMPLE OFF
HIDE wait3 = 500;                       // Between SAMPLE OFF and TEST ON
HIDE wait4 = 500;                       // Between TEST OFF and TEST OFF
HIDE wait5 = 1000;                      // Between TEST OFF and FP OFF
HIDE wait6 = 500;                       // Inter-trail time

HIDE xmax = 640, ymax = 350;            // Video dimensions

HIDE    FP_IS_ON        = 1;            // Various states of visual stimuli
HIDE    SAMPLE_IS_ON    = 2;
HIDE    SAMPLE_IS_OFF   = 3;
HIDE    TEST_IS_ON      = 4;
HIDE    TEST_IS_OFF     = 5;
HIDE    FP_IS_OFF       = 0;

     state = FP_IS_OFF;                 // Current state of stimulus

HIDE fpsize = 10;                       // Size of fixation point
HIDE fpx = xmax / 2 - fpsize / 2;       // upper left corner of fp
HIDE fpy = ymax / 2 - fpsize / 2;
        
HIDE coilsize = 100;                    // Size of coil window around fp
HIDE coilulx = fpx - coilsize / 2;      // Upper left x of coil window
HIDE coiluly = fpy - coilsize / 2;      // Upper left y ..
HIDE coillrx = fpx + coilsize / 2;      // Lower right x of coil window
HIDE coillry = fpy + coilsize / 2;      // Lower right y ..

HIDE C11 = 1;
HIDE C12 = 0;
HIDE C21 = 0;
HIDE C22 = 1;

HIDE samplex    = fpx + 200;
HIDE sampley    = fpy;
HIDE samplesize = 100;

HIDE testx      = samplex;
HIDE testy      = sampley;
HIDE testsize   = samplesize;

     test_color;                        // SAMPLE and TEST stimuli parameters
     sample_color;

HIDE oFP, oSAMPLE, oCOIL, oTEST, oEYE;  // Objects displayed in left graph

process MAIN enabled
    {
    if (DEBUG) BAR_TTL = 0x1;           // Redefine BAR to avoid MIO TTL conflict
    spawn   INIT;
    spawn   BAR_MONITOR;
    }

process BAR_MONITOR
    {
    while (1)
        {
        if (DEBUG) 
            {
            print("If stimuli are the same, hold bar until FP goes out.");
            print("Otherwise, release bar before FP goes out.");
            print("Waiting for bar press (or F8) ...");
            }
        wson    BAR_TTL;
        spawn   SELECT_TRIAL;           // Defines trial parameters
        print();                        // Clear messages on TEMPO's screen
        etable_set(1, EVT_BAR_PRESS);
        spawn   VISUAL;
        if (DEBUG) print("Waiting for bar release (or F8) ..");
        wsof    BAR_TTL;
        etable_set(1, EVT_BAR_RELEASE);
                
        print();                        // Clear messages on TEMPO's screen
        if (test_color == sample_color)
            {
            if (state == TEST_IS_OFF) 
                spawn FAIL; 
            else
                spawn SUCCESS;
            }
        else
            {
            if (state == TEST_IS_OFF)
                spawn SUCCESS;
            else
                spawn FAIL;
            }

        wait    wait6;                  // Inter-trial time
        }
    }

process SELECT_TRIAL
    {
    // The trial is a "match" when test_color == sample_color

    test_color = random(4) + 1;
    sample_color = random(4) + 1;

    if (test_color == sample_color)
        oTEST = oTESTsame;
    else
        oTEST = oTESTdiff;
    }

process INIT
    {
    send("CL");
    oSetGraph(gLEFT, aTITLE, "Monkey's eyes");
    oSetGraph(gLEFT, aRANGE, 0, xmax - 1, 0, ymax - 1);

    oFP = oCreate(tCROSS, gLEFT, fpsize, fpsize);
    oSetAttribute(oFP, aINVISIBLE);

    oSAMPLE = oCreate(tBOX, gLEFT, samplesize, samplesize);
    oSetAttribute(oSAMPLE, aINVISIBLE);

    oTESTdiff = oCreate(tXCROSS, gLEFT, testsize, testsize);
    oSetAttribute(oTESTdiff, aINVISIBLE);
    oSetAttribute(oTESTdiff, aFILLED);

    oTESTsame = oCreate(tCROSS, gLEFT, testsize, testsize);
    oSetAttribute(oTESTsame, aINVISIBLE);
    oSetAttribute(oTESTsame, aFILLED);

    oEYE = oCreate(tXCROSS, gLEFT, 4, 4);

    oCOIL = oCreate(tBOX, gLEFT, coilsize, coilsize);
    oSetAttribute(oCOIL, aINVISIBLE);
    }

process VISUAL
    {
    spawn FP_ON;
    spawn WATCH_EYES;
    cancel_clr(1);
    trigger 1;                          // Start data collection
    wait wait1;                         // Between FP ON and SAMPLE ON

    spawn SAMPLE_ON;
    wait wait2;                         // Between SAMPLE ON and SAMPLE OFF

    spawn SAMPLE_OFF;
    wait wait3;                         // Between SAMPLE OFF and TEST ON

    spawn TEST_ON;
    wait wait4;                         // Between TEST OFF and TEST OFF

    spawn TEST_OFF;
    wait wait5;                         // Between TEST OFF and FP OFF

    spawn FP_OFF;
    suspend WATCH_EYES;
    oSetAttribute(oCOIL, aINVISIBLE);
    }

HIDE cx, cy;

process WATCH_EYES
    {
    coilulx = fpx - coilsize / 2;      // Upper left x of coil window
    coiluly = fpy - coilsize / 2;      // Upper left y ..
    coillrx = fpx + coilsize / 2;      // Lower right x of coil window
    coillry = fpy + coilsize / 2;      // Lower right y ..
    oMove(oCOIL, fpx, fpy);
    oSetAttribute(oCOIL, aVISIBLE);
    while (1)
        {
        if (DEBUG)
            {
            cx = random(coilsize) + fpx - coilsize / 2;
            cy = random(coilsize) + fpy - coilsize / 2;
            }
        else
            {
            cx = atable(1) + 128;         // Fetch MIO analog channel 1
            cy = atable(2) + 128;         // Fetch MIO analog channel 1
            }

        // Convert from coil values (-128..127) to video coordinates
        // (0..xmax-1, 0..ymax-1);

        eye_x = cx * C11 + cy * C12;
        eye_y = cx * C21 + cy * C22;

        oMove(oEYE, eye_x, eye_y);

        if (eye_x < coilulx || eye_x > coillrx ||
            eye_y < coiluly || eye_y > coillry)
            {
            print("SUBJECT MOVED OUTSIDE OF COIL WINDOW");
            //printf(" X %d outside %d..%d", eye_x, coilulx, coillrx);
            //printf(" Y %d outside %d..%d\n", eye_y, coiluly, coillry);
            spawn   FAIL;
            }

        nexttick;                       // WAIT ONE PROCESS CYCLE
        }
    }

process FAIL
    {
    cancel_set(1);

    suspend WATCH_EYES;
    oSetAttribute(oCOIL, aINVISIBLE);

    suspend VISUAL;
    spawn   TEST_OFF;
    spawn   SAMPLE_OFF;
    spawn   FP_OFF;
    spawn   RING_BELL;
    bad = bad + 1;

    printf("FAILED\n");
    }

process SUCCESS
    {
    spawn GIVE_JUICE;
    good = good + 1;

    printf("SUCCESS\n");
    }

process FP_ON
    {
    send("CO 15; RF ", fpx, fpy, fpx + fpsize, fpy + fpsize);
    state = FP_IS_ON;
    etable_set(1, EVT_FP_ON);
    oMove(oFP, fpx, fpy);
    oSetAttribute(oFP, aVISIBLE);
    }

process FP_OFF
    {
    send("CO 0; RF ", fpx, fpy, fpx + fpsize, fpy + fpsize);
    state = FP_IS_OFF;
    etable_set(1, EVT_FP_OFF);
    oSetAttribute(oFP, aINVISIBLE);
    }

process SAMPLE_ON
    {
    send("CO ", sample_color);
    send("RF ", samplex, sampley, samplex + samplesize, sampley + samplesize);
    state = SAMPLE_IS_ON;
    etable_set(1, EVT_SAMPLE_ON);
    oMove(oSAMPLE, samplex, sampley);
    oSetAttribute(oSAMPLE, aVISIBLE);
    }

process SAMPLE_OFF
    {
    send("CO 0");
    send("RF ", samplex, sampley, samplex + samplesize, sampley + samplesize);
    state = SAMPLE_IS_OFF;
    etable_set(1, EVT_SAMPLE_OFF);
    oSetAttribute(oSAMPLE, aINVISIBLE);
    }

process TEST_ON
    {
    send("CO ", test_color);
    send("RF ", testx, testy, testx + testsize, testy + testsize);
    state = TEST_IS_ON;
    etable_set(1, EVT_TEST_ON);
    oMove(oTEST, testx, testy);
    oSetAttribute(oTEST, aVISIBLE);
    }

process TEST_OFF
    {
    send("CO 0");
    send("RF ", testx, testy, testx + testsize, testy + testsize);
    state = TEST_IS_OFF;
    etable_set(1, EVT_TEST_OFF);
    oSetAttribute(oTEST, aINVISIBLE);
    }

process RING_BELL
    {
    mio_dig_set(BELL_TTL, 1);
    if (DEBUG) sound(200);
    wait    1000;
    mio_dig_set(BELL_TTL, 0);
    if (DEBUG) sound(0);
    }

process GIVE_JUICE
    {
    mio_dig_set(JUICE_TTL, 1);
    if (DEBUG) sound(1000);
    wait    500;
    mio_dig_set(JUICE_TTL, 0);
    if (DEBUG) sound(0);
    }
