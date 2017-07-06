/*  SEQUENCE.PRO - Sequence Task
**
**  In this task, the subject is presented with a matrix of targets.
**  A sequence of targets is flashed and the subject must make
**  sacades to each target in the order of the sequence.
**
**
**
*/
#pragma declare=1                       // Force variables to be declared

DECLARE constant XMAX = 1024, YMAX = 768;   // Video coordinate limits

DECLARE constant NX = 5, NY = 5;        // # of Targets in target matrix
DECLARE constant NTARGETS = NX * NY;    // # of Targets

DECLARE constant MAXTRIALS = 10;        // # of trials in a run
DECLARE constant MAXRUNS = 0;
DECLARE nTrials, nRuns;                 // Current trial number [0..NTRIALS)

DECLARE tx[NX * NY], ty[NX * NY];       // (x,y) target position
DECLARE txsize = XMAX / 20,
        tysize = YMAX / 20;             // Target size

DECLARE seq[NTARGETS];                  // Sequence of targets
DECLARE nSeq;                           // # of elements [0..NTARGETS)

DECLARE InterTrialTime = 1000;          // Time (ms) between trials

DECLARE SuccessCount = 0;               // # of successes
DECLARE failed;                         // 0=success, otherwise failure

DECLARE constant RED = 12, BLACK = 0, GREEN = 10;

DECLARE MAIN(), INIT(), RUN(), SAVE(), DrawTarget(t), FillTarget(t, c);
DECLARE OneTrial(), GetTrialParameters();

//----------------------------------------------------------------------
process MAIN enabled
    {
    spawn INIT;
    waitforprocess INIT;                // Wait for initialization to complete

    nRuns = 1;
    while (!MAXRUNS || nRuns < MAXRUNS)
        {
        spawn RUN;
        waitforprocess RUN;             // Wait for RUN to complete

        spawn SAVE;
        waitforprocess SAVE;            // Save all data

        nRuns = nRuns + 1;
        nexttick;
        }
    }

//----------------------------------------------------------------------
process INIT
    {
    DECLARE x, y, t;

    send("CA");                             // Reset video
    wait 2000;                              // Wait for reset
    send("cl");                             // Clear screen
    sendf("vc 0,%d,0,%d\n", XMAX, YMAX);    // Set video coordinates

    x = 0;
    while (x < NX)                          // Initialize target position
        {
        y = 0;
        while (y < NY)
            {
            t = x * NX + y;                 // Target number [0..NTARGETS)
            tx[t] = ((x+1) * XMAX) / (NX + 2);
            ty[t] = ((y+1) * YMAX) / (NY + 2);
            y = y + 1;
            }
        x = x + 1;
        nexttick;
        }

    t = 0;
    while (t < NTARGETS)
        {
        spawn DrawTarget(t);
        t = t + 1;
        nexttick;
        }
    }

//----------------------------------------------------------------------
// A RUN is a number of successful trials.
// After the trials are collected, the data is automatically saved

process RUN
    {
    printf("Starting Run %d\n", nRuns);
    nTrials = 0;
    while (nTrials < MAXTRIALS)
        {
        nTrials = nTrials + 1;
        spawn GetTrialParameters;
        waitforprocess GetTrialParameters;

        spawn OneTrial;
        waitforprocess OneTrial;

        wait InterTrialTime;
        }
    }


//----------------------------------------------------------------------
process GetTrialParameters
    {
    DECLARE     t;

    nSeq = 0;
    printf("Trial %d Sequence ", nTrials);
    while (nSeq < 3)
        {
        t = random(NTARGETS);
        seq[nSeq] = t;                  // Select 1-5 targets
        nSeq = nSeq + 1;
        printf(" %d", t);
        }
    printf("\n");
    }

//----------------------------------------------------------------------
process OneTrial
    {
    DECLARE     s;                      // Sequence number [0..nSeq)

    // DISPLAY TARGETS

    printf("Starting Trial %d.%d\n", nRuns, nTrials);

    failed = 0;                         // No failure so far
    trigger 1;                          // Start of trial
    s = 0;
    while (s < nSeq)
        {
        spawn FillTarget(seq[s], RED);
        s = s + 1;
        wait 500;
        }

    wait 1000;

    s = 0;
    while (s < nSeq)
        {
        spawn FillTarget(seq[s], BLACK);
        s = s + 1;
        }

    if (!failed)                        // Was the trial successful?
        {
        harvest 1;                      // Yes, force data accumulation
        harvest 2;                      // Yes, force data accumulation
        SuccessCount = SuccessCount + 1;// Count successes
        }
    else
        {                               // Trial failed
        cancel_set(1);                  // Cancel trigger with request to set cancel bit
        nexttick;                       // ..wait one process cycle
        cancel_clr(1);                  // then request to clear cancel bit
        }
    }

//----------------------------------------------------------------------
process SAVE
    {
    printf("SAVE - Saving data..\n");
    while (GetPendingDBTriggers())
        nexttick;                       // Wait for all triggers
    system("DOSX del seq.htb");
    systemf("HSAVE * seq\n");
    system("HZERO *");
    while (system())
        nexttick;
    printf("SAVE - Saving complete.\n");
    }

//----------------------------------------------------------------------
process DrawTarget(t)
    {
    send("co 15");
    sendf("ru %d,%d,%d,%d\n", tx[t], ty[t], tx[t] + txsize, ty[t] + tysize);
    }

//----------------------------------------------------------------------
process FillTarget(t, c)
    {
    sendf("co %d\n", c);
    sendf("rf %d,%d,%d,%d\n", tx[t] + 1, ty[t] + 1, tx[t] + txsize - 1, ty[t] + tysize - 1);
    }
