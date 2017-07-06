/* EYECAL.PRO - Eye coil calibration using dim task
-----------------------------------------------------------------------------

This protocol serves as an example for how to calibrate eye coils.
This is essentially the process of determining experimentally the
mapping of analog coordinates to video coordinates.

The result of this protocol is calibration matrix which is used
to map eye coil values (analog coordinates) to screen coordinates. 
The matrix is written to the EYECALM.PRO file as four numbers,
A11, A12, A21, A22.  Other protocols can then #include this file
to use the current calibration settings (see the STABLE.PRO
example.)

The dim task consists of presenting a bright fixation point when
a bar is pressed.  After a short delay, the point dims for a period
of time then goes out.  A success is defined as a bar release during
the dim period; a failure is a bar release at any other time.

In this protocol, analog (eye) pairs (x,y) are accumulated at four
fixation points (north, south east and west) on the screen.  Once
collected, these are averaged and the calibration matrix is computed.

Trial statistics (rewards, too_early, too_late) are also accumulated and
displayed as the experiment progresses.

CONNECTIONS

This protocol assumes a bar (switch) is connected to the MIO card
(see definition of the BAR variable) and the eye coils are connected
to MIO analog input channels 1 (x) and 2 (y).  The video is run
in EGA mode (640 x 350).

TESTING

You can test this protocol without the MIO card switch by changing
the definition of bar to bar=0x1 before loading the protocol and
setting or clearing STATUS bit 1 from TEMPO's command line.  For
example, the F1 key is defined to toggle the bar bit using
TEMPO's KEY command:
    
    KEY F1 = status = status ^ bar {cr}

Two processes are included for test purposes.  Process HAND simulates
bar presses and releases by setting and clearing the bar status bit,
normally connected to a TTL input.  Process EYE simulates eye
movement setting ax and ay to eye coil coordinates.  The EYE
documents what changes are needed when actual eye coils are connected
to analog input.

A DEBUG variable is used to toggle debugging code.  Set DEBUG to 1
when testing the protocol and set DEBUG to 0 for a real experiment.

-----------------------------------------------------------------------------
*/

    DEBUG       = 1;                /* =1 for testing, =0 for live run      */

    trials      = 0;                /* Total number of trials               */
    too_early   = 0;                /* Bar released During BRIGHT           */
    rewards     = 0;                /* Bar released during DIM              */
    too_late    = 0;                /* Bar released after DIM goes to OFF   */

// CAL_TRIALS defines the number of cycles through the 4 fixation points
// this task will run before calculating the calibration matrix.

HIDE    CAL_TRIALS  = 1;

HIDE HEX bar        = 0x0;          /* Status bit of bar defined by INIT    */
HIDE     badtime    = 1000;         /* Timeout after mistake                */
HIDE     goodtime   = 1000;         /* Timeout after success                */
HIDE     OFF        = 0;            /* Fixation point is OFF                */
HIDE     BRIGHT     = 1;            /* Fixation point is BRIGHT             */
HIDE     DIM        = 2;            /* Fixation point is DIM                */
         fp_state   = OFF;          /* State of fixation point              */

HIDE    FP_SIZE     = 4;            /* Size of fixation point in pixels     */
HIDE    FP_XCENTER  = 300;          /* Center of screen fixation point      */
HIDE    FP_YCENTER  = 175;
HIDE    fp_x, fp_y;                 /* Current location of fixation point   */

HIDE    FP_DELTA    = 150;          /* Distance from center to fp           */
HIDE    FP_XNORTH   = FP_XCENTER;   /* NORTH, SOUTH, EAST, WEST fp          */
HIDE    FP_YNORTH   = FP_YCENTER - FP_DELTA;
HIDE    FP_XSOUTH   = FP_XCENTER;
HIDE    FP_YSOUTH   = FP_YCENTER + FP_DELTA;
HIDE    FP_XEAST    = FP_XCENTER + FP_DELTA;
HIDE    FP_YEAST    = FP_YCENTER;
HIDE    FP_XWEST    = FP_XCENTER - FP_DELTA;
HIDE    FP_YWEST    = FP_YCENTER;

HIDE    stim_dx     = 50;               /* Stimulus relative to fp          */
HIDE    stim_dy     = -75;

HIDE    x_north, y_north, x_south,      /* Temp values                      */
        y_south, x_east, y_east,
        x_west, y_west,
        stim_x, stim_y,                 /* Location of stimulus             */
        stim_x_old, stim_y_old,
        dx1, dy1, dx2, dy2;

HIDE    a11, a12, a21, a22;             /* CALIBRATION MATRIX               */
HIDE    ax, ay;                         /* Latest analog coordinates        */

/*--------------------------------------------------------------------------*/
// MAIN - After performing initialization, 

process MAIN enabled
    {
    xeq     INIT;                       /* Initialize protocol              */
    xeq     MONITOR_BAR;                /* Act based on bar press/releases  */
    }

/*--------------------------------------------------------------------------*/
// INIT - Initializes certain variables at the beginning of the experiment.

process INIT
    {
    fp_x        = FP_XNORTH;            /* Initial fp                       */
    fp_y        = FP_YNORTH;    
    send("VI 1; CA");                   /* Reset WORDPLAY to EGA            */
    if (DEBUG)
        {
        bar = 0x1;
        printf("Use F1 to toggle BAR; For success, release BAR when fp_state is %d.\n", DIM);
        }
    else
        {
        bar = 0x10000000;               /* Use MIO ttl input # 1            */
        print("Connect MIO TTL input # 1 to BAR");
        }
    }

/*--------------------------------------------------------------------------*/
// MONITOR_BAR - Starts and stops the trial based on bar presses

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
// FIXATE - Sequences through the visual task.

HIDE    avg_bright  = 2000;             /* Mean bright time (in ms)         */
HIDE    avg_dim     = 3000;             /* Time fixation point is dim       */
HIDE    min_bright  = 1000;             /* Minimum length of bright time    */

process FIXATE                          /* Display fixation point BRIGHT,   */
    {                                   /* wait a period of time, change to */
    trials = trials + 1;                /* DIM, wait a period of time then  */
                                        /* turn it off.                     */
    xeq     FP_BRIGHT;                  
    wait    poisson(avg_bright) + min_bright;

    xeq     FP_DIM;
    wait    avg_dim;

    xeq     ABORT;
    }

/*--------------------------------------------------------------------------*/
// ABORT - Terminates a trial.

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
// REWARD - Accumulates analog values at each fp.  At end of experiment,
//          it calculates the calibration matrix and writes it out.

HIDE reward_time = 1000;                /* Length of time to give reward    */
HIDE locus;                             /* 0=north, 1=east, etc.            */
HIDE det;                               /* Stabilization matrix determinate */

process REWARD
    {
    xeq     FP_OFF;                     /* Turn off fixation point          */
    rewards = rewards + 1;
    print("Trial ", trials, "- Correct response.");

    locus = rewards % 4;
    if (locus == 0)
        {
        x_west = x_west + ax;    fp_x = FP_XNORTH;
        y_west = y_west + ay;    fp_y = FP_YNORTH;
        }
    else if (locus == 1)
        {
        x_north = x_north + ax;  fp_x = FP_XEAST;
        y_north = y_north + ay;  fp_y = FP_YEAST;
        }
    else if (locus == 2)
        {
        x_east = x_east + ax;    fp_x = FP_XSOUTH;
        y_east = y_east + ay;    fp_y = FP_YSOUTH;
        }
    else
        {
        x_south = x_south + ax;  fp_x = FP_XWEST;
        y_south = y_south + ay;  fp_y = FP_YWEST;
        }

    if (rewards >= CAL_TRIALS * 4)  /* Is calibration complete ?        */
        {
        print();                        /* Clear message area */
        print("Calibration is complete.");
        fp_x = FP_XCENTER;
        fp_y = FP_YCENTER;

        /* CALCULATE CALIBRATION MATRIX.
         * WE DO THIS IN 1/1000ths SINCE PCL DOESN'T (YET) SUPPORT
         * FRACTIONS.  NOTE THAT CALIBRATION CAN FAIL IF THE ANALOG
         * INPUTS (EAST == WEST) OR (SOUTH == NORTH).
         */
    
        dx1 = (x_east - x_west)   / CAL_TRIALS;
        dy1 = (y_east - y_west)   / CAL_TRIALS;
        dx2 = (x_south - x_north) / CAL_TRIALS; /* Changed from n-s */
        dy2 = (y_south - y_north) / CAL_TRIALS; /* Changed from n-s */
        det = dx1 * dy2 - dx2 * dy1;
        if (!det)
            {
            print("Calibration failed due to improper analog input values.");
            HALT;
            }
        a11 =  (2 * FP_DELTA * 1000 * dy2) / det;
        a12 = -(2 * FP_DELTA * 1000 * dx2) / det;
        a21 =  (2 * FP_DELTA * 1000 * dy1) / det;
        a22 = -(2 * FP_DELTA * 1000 * dx1) / det;

        // WRITE OUT CALIBRATION MATRIX TO EYECALM.PRO
        // THE system FUNCTION QUEUES A COMMAND FOR TEMPO.
        // TEMPO'S dosx COMMAND EXECUTES A DOS COMMAND.
        // TEMPO'S write COMMAND WRITES TO A FILE.

        system("dosx if exist EYECALM.PRO copy EYECALM.PRO EYECALM.BAK");
        system("dosx if exist EYECALM.PRO del EYECALM.PRO");
        systemf("write EYECALM.PRO /* CALIBRATION %d/%d/%d BY EYECAL.PRO */\\n\n", day(), month(), year());
        systemf("write EYECALM.PRO HIDE A11 = %d\\;\\n\n", a11);
        systemf("write EYECALM.PRO HIDE A12 = %d\\;\\n\n", a12);
        systemf("write EYECALM.PRO HIDE A21 = %d\\;\\n\n", a21);
        systemf("write EYECALM.PRO HIDE A22 = %d\\;\\n\n", a22);

        print("Results written to EYECALM.PRO");
        HALT;
        }                
    }

/*--------------------------------------------------------------------------*/
// FP_BRIGHT makes the fixation point bright and updates fp_state.
process FP_BRIGHT
    {
    send("CO 15; RF ", fp_x, fp_y, fp_x + fp_size, fp_y + fp_size);
    fp_state = BRIGHT;
    }

// FP_DIM makes the fixation point dim and updates fp_state.
process FP_DIM
    {
    send("CO  7; RF ", fp_x, fp_y, fp_x + fp_size, fp_y + fp_size);
    fp_state = DIM;
    }

// FP_OFF turns off the fixation point and updates fp_state.
process FP_OFF
    {
    send("CO  0; RF ", fp_x, fp_y, fp_x + fp_size, fp_y + fp_size);
    fp_state = OFF;
    }

/*--------------------------------------------------------------------------*/
// EYE sets ax and ay every process cycle.

process EYE enabled                     /* Fetch eye coil coordinates       */
    {
    while (1)
        {
        if (DEBUG)
            {
            ax = fp_x + normal(20);  /* For testing                      */
            ay = fp_y + normal(20);  /* ..simulate eye movement          */
            wait poisson(1000);
            }
        else
            {
            ax = atable(1);          /* When eye coils are connected     */
            ay = atable(2);          /* ..to analog input 1 and 2        */
            }
        nexttick;                       /* Force atleast one wait           */
        }
    }

/*--------------------------------------------------------------------------*/
// HAND - Provides fake bar presses when DEBUG is set to 1.
// You must spawn this task from TEMPO's command line to fake out bar presses.
// For example, type the TEMPO command: SPAWN HAND

process HAND                            /* Simulate bar presses             */
    {                                   /* (for testing only)               */
    wait 5000;                          /* 5 seconds                        */
    while (1)
        {
        wait random(3000);              /* rest a moment                    */
        status_set(bar);                /* Press the bar                    */
        wait random(2 * (avg_bright + min_bright));
        wait press_time;
        status_clr(bar);                /* Release the bar                  */
        }
    }
