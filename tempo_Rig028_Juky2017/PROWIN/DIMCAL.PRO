/* DIMCAL.PRO - Dim Task with retinal stabilization.
-----------------------------------------------------------------------------
This protocol contains two phases: calibration and running.  Calibration
produces a stabilization matrix which is used to map eye coil coordinates
to screen coordinates.  The running phase uses the stabilization matrix
and runs a simple dim task displaying a stimulus stabilized to the eye
relative to a central fixation point.

PHASE 1: During calibration, average eye positions for four fixation points
(north, south east and west) are accumulated.  Once collected, these are
averaged and a stabilization matrix is computed and phase 2 begins.

PHASE 2: Using the stabilization matrix, a central fixation point is used
for the dim task.  A stimulus stabilized to the eye is flashed relative to
the fixation point.  Databases are collected in phase with stimulus on and
off conditions.

Trial statistics (rewards, too_early, too_late) are also accumulated and
displayed as the experiment progresses.

Two processes are included for test purposes.  Process HAND simulates bar
presses and releases by setting and clearing the bar status bit, normally
connected to a TTL input.  Process EYE simulates eye movement setting
eye_x and eye_y to eye coil coordinates.  Code is included in EYE illustrates
what changes are needed when actual eye coils are connected to analog input.

Connect bar to TTL 1; eye coils to analog 1 and 2 (x, y).

28 Jul 92 sh    Fixed calculation of stabilization matrix from north-south
                to south-north.
-----------------------------------------------------------------------------
*/
#pragma declare=1                   /* Require declarations                 */

    trials      = 0;                /* Total number of trials               */
    too_early   = 0;                /* Bar released During BRIGHT           */
    rewards     = 0;                /* Bar released during DIM              */
    too_late    = 0;                /* Bar released after DIM goes to OFF   */

HIDE HEX bar        = 0x20000000;   /* Status bit set iff bar press         */
HIDE     badtime    = 1000;         /* Timeout after mistake                */
HIDE     goodtime   = 1000;         /* Timeout after success                */
HIDE     OFF        = 0;            /* Fixation point is OFF                */
HIDE     BRIGHT     = 1;            /* Fixation point is BRIGHT             */
HIDE     DIM        = 2;            /* Fixation point is DIM                */
         fp_state   = OFF;          /* State of fixation point              */

HIDE    XMAX        = 640 - 1;      /* Maximum X video coordinate           */
HIDE    YMAX        = 350 - 1;      /* Maximum Y video coordinate           */

HIDE    FP_XCENTER  = XMAX / 2;     /* Center of screen fixation point      */
HIDE    FP_YCENTER  = YMAX / 2;

HIDE    FP_DELTA    = 150;          /* Distance from center to fp           */
HIDE    FP_XNORTH   = FP_XCENTER;   /* NORTH, SOUTH, EAST, WEST fp          */
HIDE    FP_YNORTH   = FP_YCENTER - FP_DELTA;
HIDE    FP_XSOUTH   = FP_XCENTER;
HIDE    FP_YSOUTH   = FP_YCENTER + FP_DELTA;
HIDE    FP_XEAST    = FP_XCENTER + FP_DELTA;
HIDE    FP_YEAST    = FP_YCENTER;
HIDE    FP_XWEST    = FP_XCENTER - FP_DELTA;
HIDE    FP_YWEST    = FP_YCENTER;

HIDE    CAL_TRIALS  = 1;                /* Number of calibration trials     */

HIDE    stim_dx     = 50;               /* Stimulus relative to fp          */
HIDE    stim_dy     = -75;

HIDE    x_north, y_north, x_south,      /* Temp values                      */
        y_south, x_east, y_east,
        x_west, y_west,
        stim_x, stim_y,                 /* Location of stimulus             */
        stim_x_old, stim_y_old,
        dx1, dy1, dx2, dy2,
        a11, a12, a21, a22;             /* Stabilization matrix             */
        
int calibrating;                        /* =1 iff we are calibrating        */

HIDE    fp_x, fp_y;                     /* Fixation point location          */

HIDE    bright_time;                    /* Duration for bright stimulus     */

HIDE    eye_x, eye_y;                   /* Eye position                     */

HIDE    stim_is_on;                     /* =1 iff stimulus is displayed     */
        
// Declare process names

DECLARE MAIN(), INIT(), MONITOR_BAR(), FIXATE(), ABORT(), REWARD();
DECLARE FP_BRIGHT(), FP_DIM(), FP_OFF(), STABILIZE();
DECLARE STABILIZED_STIMULUS();


/*--------------------------------------------------------------------------*/
process MAIN enabled
    {
    xeq     INIT;                       /* Initialize protocol              */
    xeq     MONITOR_BAR;                /* Act based on bar press/releases  */
    }

process INIT
    {
    calibrating = 1;                    /* Start calibration                */
    fp_x        = FP_XNORTH;            /* Initial fp                       */
    fp_y        = FP_YNORTH;    
    send("CL");                         /* Clear screen                     */
    }

/*--------------------------------------------------------------------------*/
process MONITOR_BAR
    {
    while (1)
        {
        wson    bar;                    /* Wait for bar press               */
        xeq     FIXATE;                 /* Start fp sequence                */
        wsof    bar;                    /* Wait for bar release             */

        if (fp_state != DIM)            /* Determine result                 */
            {
            suspend FIXATE;
            xeq     ABORT;
            wait    badtime;
            }
        else    
            {
            suspend FIXATE;
            xeq     REWARD;
            wait    goodtime;
            }
        }
    }

/*--------------------------------------------------------------------------*/
HIDE    avg_bright  = 2000;             /* Mean bright time (in ms)         */
HIDE    avg_dim     = 3000;             /* Time fixation point is dim       */
HIDE    min_bright  = 1000;             /* Minimum length of bright time    */

process FIXATE                          /* Display fixation point BRIGHT,   */
    {                                   /* wait a period of time, change to */
    trials = trials + 1;                /* DIM, wait a period of time then  */
                                        /* turn it off.                     */
    xeq     FP_BRIGHT;                  
    bright_time = poisson(avg_bright) + min_bright;
    wait    bright_time;

    xeq     FP_DIM;
    wait    avg_dim;

    xeq     ABORT;
    }

/*--------------------------------------------------------------------------*/
process ABORT
    {
    if (fp_state == BRIGHT)
        {
        too_early = too_early + 1;
        print("Trial ", trials, "- Too early.");
        }
    else if (fp_state == OFF)
        {
        too_late = too_late + 1;
        print("Trial ", trials, "- Too late.");
        }
    xeq     FP_OFF;                     /* Turn off fixation point          */
    }

/*--------------------------------------------------------------------------*/
HIDE reward_time = 1000;                /* Length of time to give reward    */
HIDE locus;                             /* 0=north, 1=east, etc.            */
HIDE det;                               /* Stabilization matrix determinate */

process REWARD
    {
    xeq     FP_OFF;                     /* Turn off fixation point          */
    rewards = rewards + 1;
    print("Trial ", trials, "- Correct response.");
    
    if (calibrating)
        {
        locus = rewards % 4;
        if (locus == 0)
            {
            x_west = x_west + eye_x;    fp_x = FP_XNORTH;
            y_west = y_west + eye_y;    fp_y = FP_YNORTH;
            }
        else if (locus == 1)
            {
            x_north = x_north + eye_x;  fp_x = FP_XEAST;
            y_north = y_north + eye_y;  fp_y = FP_YEAST;
            }
        else if (locus == 2)
            {
            x_east = x_east + eye_x;    fp_x = FP_XSOUTH;
            y_east = y_east + eye_y;    fp_y = FP_YSOUTH;
            }
        else
            {
            x_south = x_south + eye_x;  fp_x = FP_XWEST;
            y_south = y_south + eye_y;  fp_y = FP_YWEST;
            }

        if (rewards >= CAL_TRIALS * 4)  /* Is calibration complete ?        */
            {
            print("Calibration is complete.");
            fp_x = FP_XCENTER;
            fp_y = FP_YCENTER;

            /* CALCULATE STABILIZATION MATRIX */
    
            dx1 = (x_east - x_west)   / CAL_TRIALS;
            dy1 = (y_east - y_west)   / CAL_TRIALS;
            dx2 = (x_south - x_north) / CAL_TRIALS; /* Changed from n-s */
            dy2 = (y_south - y_north) / CAL_TRIALS; /* Changed from n-s */
            det = dx1 * dy2 - dx2 * dy1;
            if (!det)
                {
                print("Calibration failed.");
                halt;
                }
            a11 =  (2 * FP_DELTA * 1000 * dy2) / det;
            a12 = -(2 * FP_DELTA * 1000 * dx2) / det;
            a21 =  (2 * FP_DELTA * 1000 * dy1) / det;
            a22 = -(2 * FP_DELTA * 1000 * dx1) / det;

            calibrating = 0;            /* Calibration complete */
            xeq STABILIZED_STIMULUS;    /* Start stabilized stimulus */
            }                
        }
    }

/*--------------------------------------------------------------------------*/
HIDE    stim_on_time    = 500;          /* Stimulus is flashed on and off   */
HIDE    stim_off_time   = 500;
HIDE    stim_pause_time = 500;

process STABILIZED_STIMULUS
    {
    xeq     STABILIZE;                  /* Stabilize stimulus when on       */
    while (1)
        {
        wait    stim_pause_time;        /* Give monkey time to fixate       */
        while (fp_state == BRIGHT)
            {
            trigger     1;              /* Collect data                     */
            stim_is_on = 1;             /* Turn stimulus on                 */
            wait        stim_on_time;

            stim_is_on = 0;             /* Turn stimulus off                */
            trigger     2;              /* Collect data                     */
            wait        stim_off_time;
            }
        while (fp_state != BRIGHT)      /* Wait for bright                  */
            nexttick;
        }
    }

process STABILIZE
    {
    while (1)
        {
        while (stim_is_on)
            {
            stim_x = (eye_x * a11 + eye_y * a12) / 1000  + stim_dx;
            stim_y = (eye_x * a21 + eye_y * a22) / 1000  + stim_dy;
            if (stim_x_old != stim_x && stim_y_old != stim_y)
                {
                send("CO 0; RF ", stim_x_old, stim_y_old, stim_x_old + 20, stim_y_old + 20);
                send("CO 4; RF ", stim_x, stim_y, stim_x + 20, stim_y + 20);
                stim_x_old = stim_x;
                stim_y_old = stim_y;
                }
            wait    20;
            }
        send("CO 0; RF ", stim_x_old, stim_y_old, stim_x_old + 20, stim_y_old + 20);
        while (!stim_is_on)
            nexttick;
        }
    }

/*--------------------------------------------------------------------------*/
process FP_BRIGHT
    {
    send("CO 15; RF ", fp_x, fp_y, fp_x + 4, fp_y + 4);
    fp_state = BRIGHT;
    }

process FP_DIM
    {
    send("CO  7; RF ", fp_x, fp_y, fp_x + 4, fp_y + 4);
    fp_state = DIM;
    }

process FP_OFF
    {
    send("CO  0; RF ", fp_x, fp_y, fp_x + 4, fp_y + 4);
    fp_state = OFF;
    }

/*--------------------------------------------------------------------------*/
process EYE enabled                     /* Fetch eye coil coordinates       */
    {
    while (1)
        {
/*      eye_x = atable(1);              /* When eye coils are connected     */
 *      eye_y = atable(2);              /* ..to analog input 1 and 2        */
 */
        eye_x = fp_x + normal(20);      /* For testing                      */
        eye_y = fp_y + normal(20);      /* ..simulate eye movement          */
        wait    poisson(1000);
        nexttick;                       /* Force atleast one wait           */
        }
    }

/*--------------------------------------------------------------------------*/
HIDE press_time;
process HAND enabled                    /* Simulate bar presses             */
    {                                   /* (for testing only)               */
    wait    5000;
    while (1)
        {
        wait    random(3000);           /* rest a moment                    */
        status_set(bar);                /* Press the bar                    */
        press_time = random(2 * (avg_bright + min_bright));
        wait    press_time;
        status_clr(bar);                /* Release the bar                  */
        }
    }
