/* DIM.PRO - Dim Task (unstabilized stimulus)                               */
// The settmr instruction is used here to show how processes can be
// suspended during a public wait.

    trials      = 0;                /* Total number of trials               */
    too_early   = 0;                /* Bar released During BRIGHT           */
    rewards     = 0;                /* Bar released during DIM              */
    too_late    = 0;                /* Bar released after DIM goes to OFF   */

// We must declare process names

DECLARE main(), handle_bar(), fixate(), abort(), reward(), init();
DECLARE unstabilized_stimulus(), fp_off(), fp_bright();
DECLARE fp_dim(), monkey();

PROCESS main ENABLED
    {
    spawn     init;
    spawn     handle_bar;
    }

HIDE HEX bar_bit    = 0x00000001;   /* Status bit changed by monkey process */
HIDE     timer1     = 1;            /* Fixation timer                       */
HIDE     outtime    = 1000;         /* Length of timeout after an error     */
HIDE     OFF        = 0;            /* Fixation point is OFF                */
HIDE     BRIGHT     = 1;            /* Fixation point is BRIGHT             */
HIDE     DIM        = 2;            /* Fixation point is DIM                */
         fp_state   = OFF;          /* State of fixation point              */

        fp_x        = 300;          /* Locus of fixation point */
        fp_y        = 175;

        stim_x      = fp_x + 100;   /* Locus of stimulus */
        stim_y      = fp_y - 100;    

PROCESS handle_bar
    {
    while (1)
        {
        wson    bar_bit;
        spawn   fixate;
        wsof    bar_bit;
        if (fp_state != DIM)
            {
            suspend FIXATE;
            spawn  abort;
            }
        else    
            {
            suspend FIXATE;
            spawn  fp_off;
            spawn  reward;
            }
        }
    }

HIDE    avgwait    = 3000;              /* Mean bright time              */
HIDE    dim_time   = 400;               /* Length of time fixation point is dim */
HIDE    bright_minimum = 500;           /* Minimum length of bright time */

// Sequence though the visual presentation.
PROCESS fixate
    {
    trials = trials + 1;
    print("Beginning trial ", trials);

    spawn     fp_bright;
    bright_time = poisson(avgwait) + bright_minimum;
    wait      bright_time;

    spawn     fp_dim;
    wait      dim_time;

    spawn     abort;
    }

PROCESS abort
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
    spawn     fp_off;
    }

HIDE reward_time = 1000;                /* Length of time to give reward    */

PROCESS reward
    {
    rewards = rewards + 1;
    wait    reward_time;                /* Leave reward on for second       */
    print(" Reward.");
    }

PROCESS init
    {
    wait 500;
    send("VI 16; CL");
    wait 500;
    }

HIDE    stim_on_time    = 500;
HIDE    stim_off_time   = 500;
HIDE    stim_pause_time = 500;

/* UNSTABILIZED_STIMULUS - Display stimulus, without retinal stabilization,
 * while the fixation point is bright.  stim_x and stim_y determine the
 * location of the stimulus.
 */
PROCESS unstabilized_stimulus
    {
    while (1)
        {
        wait    stim_pause_time;        /* give monkey time to fixate       */
        while (fp_state == BRIGHT)
            {
            send("CO 4; RF ", stim_x, stim_y, stim_x + 100, stim_y + 100);
            trigger     1;
            wait        stim_on_time;

            send("CO 0; RF ", stim_x, stim_y, stim_x + 100, stim_y + 100);
            trigger     2;
            wait        stim_off_time;
            }
        while (fp_state != BRIGHT)      /* Wait for bright                  */
            nexttick;
        }
    }

PROCESS fp_bright
    {
    send("CO 15; RF ", fp_x, fp_y, fp_x + 4, fp_y + 4);
    fp_state = BRIGHT;
    }

PROCESS fp_dim
    {
    send("CO  7; RF ", fp_x, fp_y, fp_x + 4, fp_y + 4);
    fp_state = DIM;
    }

PROCESS fp_off
    {
    send("CO  0; RF ", fp_x, fp_y, fp_x + 4, fp_y + 4);
    fp_state = OFF;
    }

/* Process MONKEY simulates bar presses.
 */
HIDE avgflicker = 7000;

PROCESS monkey ENABLED                  /* Used to simulate TTL             */
    {
    random(avgflicker);
    nexttick;
    while (1)
        {
        wait    random(avgflicker);
        status_set(bar_bit);            /* Set status bit for bar press     */
        wait    random(avgflicker);
        status_clr(bar_bit);            /* Clear bit for bar release        */
        }
    }
