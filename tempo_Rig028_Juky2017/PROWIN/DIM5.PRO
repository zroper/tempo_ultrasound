// DIM5.PRO - Basic DIM task (with unstabilized stimulus).
// In this protocol, we illustrate how to
//
//      Organize a nontrivial protocol
//      Parameterize protocol by using variables instead of constants
//      Monitor bar presses and releases
//      Start and stop processes
//      Sequence through visual stimuli
//      Administer rewards and failures
//      Trigger databases
//      Keep trial statistics
//      Use processes to aid in testing
//      Define and use WORDPLAY macros
//
// The dim task consists of presenting a bright fixation point when
// a bar is pressed.  After a short delay, the point dims for a period
// of time then goes out.  A success is defined as a bar release during
// the dim period; a failure is a bar release at any other time.

    trials      = 0;                /* Total number of trials               */
    too_early   = 0;                /* Bar released During BRIGHT           */
    rewards     = 0;                /* Bar released during DIM              */
    too_late    = 0;                /* Bar released after DIM goes to OFF   */

HIDE HEX bar_bit    = 0x00000001;   /* Status bit changed by monkey process */
HIDE     timer1     = 1;            /* Fixation timer                       */
HIDE     outtime    = 1000;         /* Length of timeout after an error (ms)*/
HIDE     OFF        = 0;            /* Fixation point is OFF                */
HIDE     BRIGHT     = 1;            /* Fixation point is BRIGHT             */
HIDE     DIM        = 2;            /* Fixation point is DIM                */
         fp_state   = OFF;          /* State of fixation point              */

//------------------------------------------------------------------------
// MAIN - Initialize protocol and start trials.
process MAIN enabled
    {
    spawn     INIT;
    spawn     HANDLE_BAR;
    }

//------------------------------------------------------------------------
// INIT - Initialize protocol.  Clear WORDPLAY's screen and
//  define WORDPLAY macros we will use in this protocol.
process INIT
    {
    send("CL");
    send("DM BRIGHT;  CO 15; RF 315 170 325 180; EM");
    send("DM DIM;     CO  7; RF 315 170 325 180; EM");
    send("DM OFF;     CO  0; RF 315 170 325 180; EM");
    send("DM STIM_ON; CO  4; RF 400 100 500 200; EM");
    send("DM STIMOFF; CO  0; RF 400 100 500 200; EM");
    send("DM REWARD_ON; MV 290 155; CO 15; TX Very Good!; EM");
    send("DM REWARDOFF; MV 290 155; CO  0; TX Very Good!; EM");
    }

//------------------------------------------------------------------------
// HANDLE_BAR - Monitor bar press and release to control the trial.
process HANDLE_BAR
    {
    while (1)
        {
        wson    bar_bit;
        spawn   FIXATE;
        wsof    bar_bit;
        if (fp_state != DIM)
            {
            suspend FIXATE;
            spawn  ABORT;
            }
        else    
            {
            suspend FIXATE;
            spawn  FP_OFF;
            spawn  REWARD;
            }
        }
    }

//------------------------------------------------------------------------
// FIXATE - Sequence through the visual presentation.

HIDE avgwait        = 3000;             /* Mean bright time (ms)            */
HIDE dim_time       = 400;              /* Duration fixation point is dim   */
HIDE bright_minimum = 500;              /* Minimum length of bright time    */

process FIXATE
    {
    trials = trials + 1;
    print("Beginning trial..");

    spawn   FP_BRIGHT;
    bright_time = poisson(avgwait) + bright_minimum;
    wait bright_time;

    spawn   FP_DIM;
    wait dim_time;

    spawn   ABORT;
    }

//------------------------------------------------------------------------
// ABORT - Cancel trial and update statistics.

process ABORT
    {
    if (fp_state == BRIGHT)
        {
        too_early = too_early + 1;      /* Premature release                */
        print(" Too Early.");
        }
    else if (fp_state == OFF)
        {
        too_late = too_late + 1;        /* Released too late                */
        print(" Too Late.");
        }
    spawn FP_OFF;
    }

//------------------------------------------------------------------------
// REWARD - Give subject reward and update statistics.

HIDE reward_time = 1000;                /* Duration of reward (ms)          */

process REWARD
    {
    rewards = rewards + 1;
    send("XM REWARD_ON");
    wait    reward_time;
    send("XM REWARDOFF");
    print(" Reward.");
    }

//------------------------------------------------------------------------
// MONKEY - Simulate bar presses (for testing only)

HIDE avgflicker = 7000;

process MONKEY enabled                  /* Used to simulate TTL             */
    {
    print("Simuluating MONKEY bar presses..");
    wait random(avgflicker);
    nexttick;                           /* Guarantee at least one cycle     */
    while (1)
        {
        wait    random(avgflicker);
        status_set(bar_bit);            /* Set status bit for bar press     */
        wait    random(avgflicker);
        status_clr(bar_bit);            /* Clear bit for bar release        */
        }
    }

//------------------------------------------------------------------------
// FP_BRIGHT - Display bright fixation point.
process FP_BRIGHT
    {
    send("XM BRIGHT");
    fp_state = BRIGHT;
    }

//------------------------------------------------------------------------
// FP_DIM - Display dim fixation point.
process FP_DIM
    {
    send("XM DIM");
    fp_state = DIM;
    }

//------------------------------------------------------------------------
// FP_OFF - Turn off fixation point.
process FP_OFF
    {
    send("XM OFF");
    fp_state = OFF;
    }

//------------------------------------------------------------------------
// STIMULUS - Flash stimulus off and on while fixation point is bright.

HIDE    stim_on_time    = 500;
HIDE    stim_off_time   = 500;
HIDE    stim_pause_time = 500;

process STIMULUS enabled
    {
    while (1)
        {
        wait    stim_pause_time;        /* give monkey time to fixate       */
        while (fp_state == BRIGHT)
            {
            spawn   STIMULUS_ON;
            wait    stim_on_time;

            spawn   STIMULUS_OFF;
            wait    stim_off_time;
            }
        send("XM STIMOFF");             /* Just turn off stimulus           */

        while (fp_state != BRIGHT)      /* Wait for fp to be bright         */
            nexttick;
        }
    }

//------------------------------------------------------------------------
// STIMULUS_ON - Display stimulus and trigger a database.

process STIMULUS_ON
    {
    trigger     1;                      /* Request histogram                */
    send("XM STIM_ON");
    }

//------------------------------------------------------------------------
// STIMULUS_OFF - Turn off stimulus and trigger a different database.

process STIMULUS_OFF
    {
    trigger     2;                      /* Request histogram                */
    send("XM STIMOFF");
    }
