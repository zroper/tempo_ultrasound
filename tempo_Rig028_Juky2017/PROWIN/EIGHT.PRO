// EIGHT.PRO - Demonstration protocol with 8 targets.
// 
// Requires:  WORDPLA5 (640x350x16)
//            analog 1,2 <- eye X,Y
//
// Virtual Coordinates: 0,0 is in center

#include object.pro

declare hide XMAX = 1000;               // Virtual screen +/- dimensions
declare hide YMAX = 1000;

// Index array from 1..8; cueX[0]

cueX[9] = {0,       0,  XMAX/3, XMAX/2, XMAX/3,      0, -XMAX/3, -XMAX/2, -XMAX/3};
cueY[9] = {0, -YMAX/2, -YMAX/3,      0, YMAX/3, YMAX/2,  YMAX/3,       0, -YMAX/3};
cueSize = 10;

BAR = 1;                               // Bar bit in STATUS register

process MAIN enabled
    {
    spawn INIT;
    while (!initdone) nexttick;
    spawn FP_ON;
    cue = 1;
    while (cue <= 8)
        {
        spawn CUE_ON;
        wait 50;
        spawn CUE_OFF;
        wait 50;
        cue = cue + 1;
        }
    spawn FP_OFF;
    spawn RUNTRIAL;
    }

process INIT
    {
    initdone = 0;
    print();
    print("Initializing visual stimuli");
    sendf("CL; CA; VC %d,%d,%d,%d\n", -XMAX, XMAX, -YMAX, YMAX);
    wait 1000;
    // Draw cues & central FP in different colors and set color map
    // so they are invisible.

    sendf("CO 9;\n");
    sendf("RF %d,%d,%d,%d\n", -cueSize, -cueSize, cueSize, cueSize);
    wait 50;
    sendf("CM 9,0,0,0\n");

    i = 1;
    while (i <= 8)
        {
        sendf("CO %d;\n", i);
        sendf("RF %d,%d,%d,%d\n", cueX[i], cueY[i], cueX[i]+cueSize, cueY[i]+cueSize);
        wait 50;
        sendf("CM %d,0,0,0\n", i);
        i = i + 1;
        }

    initdone = 1;
    }

process RUNTRIAL
    {
    trial = 1;
    while (1)
        {
        cue = random(8) + 1;
        print();
        printf("Trial %d Cue %d ready.  Waiting for bar press..\n", trial, cue);
        wson BAR;                       // Wait for bar press to start trial

        trigger cue;                    // Collect data for this cue
        spawn FP_ON;
        wait 500;
        spawn FP_OFF;
        spawn CUE_ON;
        wait 1000;
        spawn CUE_OFF;

        //wsof BAR;
        wait 100;                      // Intertrial time
        trial = trial + 1;
        }
    }

process CUE_ON
    {
    sendf("CM %d,255,0,0\n", cue);
    }

process CUE_OFF
    {
    sendf("CM %d,0,0,0\n", cue);
    }

process FP_ON
    {
    send("CM 9,0,255,0");
    }

process FP_OFF
    {
    send("CM 9,0,0,0");
    }

process MONITOR_BAR enabled
    {
    while (1)
        {
        if (mouGetButtons() & 1)
            status_set(BAR);
        else
            status_clr(BAR);

        nexttick;
        }
    }

process CHECK_TARGET enabled
    {
    while (1)
        {
        if (x > Tulx && y > Tuly && x < Tlrx && y < Tlry)
            on_target = 1;
        else
            on_target = 0;
        nexttick;
        }
    }
