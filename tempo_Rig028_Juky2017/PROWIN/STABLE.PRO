/* STABLE.PRO - Example of retina stabilization using dim task
-----------------------------------------------------------------------------

The STABLE.PRO protocol perform a dim task using the calibration
matrix MATRIX.PRO (produced by EYECAL.PRO).  It runs a dim task,
displaying a stimulus that is stabilized to eye movements relative to
a central fixation point.

The dim task consists of presenting a bright fixation point when
a bar is pressed.  After a short delay, the point dims for a period
of time then goes out.  A success is defined as a bar release during
the dim period; a failure is a bar release at any other time.

Trial statistics (rewards, too_early, too_late) are also accumulated and
displayed as the experiment progresses.

The calibration matrix is used to map analog values (eye coil
coordinates) to screen coordinates.  A stimulus, stabilized to eye
position, is flashed relative to the fixation point.  Databases are
collected in phase with stimulus on and off conditions.

CONNECTIONS

This protocol assumes a bar (switch) is connected to the MIO card
(see definition of the BAR variable) and the eye coils are connected
to MIO analog input channels 1 (x) and 2 (y).  The video is run
in EGA mode (640 x 350).

TESTING PROTOCOL

You can test this protocol without the MIO card switch by changing
the definition of bar to bar=0x1 before loading the protocol and
setting or clearing STATUS bit 1 from TEMPO's command line.  For
example, the F1 key is defined to toggle the bar bit using
TEMPO's KEY command:
    
    KEY F1 = status = status ^ bar {cr}

Two processes are included for test purposes.  Process HAND simulates
bar presses and releases by setting and clearing the bar status bit,
normally connected to a TTL input.  Process EYE simulates eye
movement converting analog (analog_x, analog_y) inputs to video
coordinates (eye_x, eye_y).  The EYE documents what changes are
needed when actual eye coils are connected to analog input.

A DEBUG variable is used to toggle debugging code.  Set DEBUG to 1
when testing the protocol and set DEBUG to 0 for a real experiment.

DATABASES 

We collect four databases containing averaged eye movements and two
containing averaged spikes.  With acquisition SPEED=500 Hz, 250
points in each database means the snapshots taken are for a period of
1/2 second (see STABLE.CFG for configuration settings.)  Database 1
collects averaged eye movements while the stimulus is on. Database 2
collects averaged eye movements while the stimulus is off.  Database
3 collects two spike channels while the stimulus is on and database 4
collects averaged spikes while the stimulus is off.  Data is
collected only when the stimulus is flashed (i.e., during the bright
time).  The protocol triggers databases with tags 1 or 2 depending
whether the stimulus is on or off.


    DB  Tag Stimulus  Type    Data Collected
    --  --- --------  ----    --------------
    1   1   ON        SUM     Averaged eye x,y    
    2   2   OFF       SUM     Averaged eye x,y    
    3   1   ON        USUM    Averaged spikes     
    4   2   OFF       USUM    Averaged spikes     

-----------------------------------------------------------------------------
*/
#include    OBJECT.PRO              /* Real-time Object definitions         */
#include    EYECALM.PRO             /* Current calibration matrix values    */

    DEBUG       = 1;                /* =1 for testing, =0 for live run      */

    trials      = 0;                /* Total number of trials               */
    too_early   = 0;                /* Bar released During BRIGHT           */
    rewards     = 0;                /* Bar released during DIM              */
    too_late    = 0;                /* Bar released after DIM goes to OFF   */

HIDE HEX bar        = 0x0;          /* Status bit of bar defined by INIT    */
HIDE     badtime    = 250;          /* Timeout after mistake                */
HIDE     goodtime   = 250;          /* Timeout after success                */
HIDE     OFF        = 0;            /* Fixation point is OFF                */
HIDE     BRIGHT     = 1;            /* Fixation point is BRIGHT             */
HIDE     DIM        = 2;            /* Fixation point is DIM                */
         fp_state   = OFF;          /* State of fixation point              */

HIDE    XMAX        = 640 - 1;      /* Maximum X video coordinate           */
HIDE    YMAX        = 350 - 1;      /* Maximum Y video coordinate           */

HIDE    FP_XCENTER  = XMAX / 2;     /* Center of screen fixation point      */
HIDE    FP_YCENTER  = YMAX / 2;
HIDE    FP_SIZE     = 15;           /* Size of fixation point in pixels     */
HIDE    fp_x, fp_y;                 /* Current position of fixation point   */

HIDE    STIM_DX     = 50;           /* Position of stimulus relative to fp  */
HIDE    STIM_DY     = -75;
HIDE    STIM_SIZE   = 40;           /* Size of stimulus in pixels           */

        stim_x, stim_y;             /* Location of stimulus                 */
HIDE    stim_x_old, stim_y_old;

/*--------------------------------------------------------------------------*/
// MAIN - After performing initialization, 

process MAIN enabled
    {
    xeq     INIT;                       /* Initialize protocol              */
    xeq     MONITOR_BAR;                /* Act based on bar press/releases  */
    }

/*--------------------------------------------------------------------------*/
// INIT - Initializes certain variables at the beginning of the experiment.

HIDE    oEye, oFPBright, oFPDim, oStim;

process INIT
    {
    fp_x        = FP_XCENTER;           /* Initial fp                       */
    fp_y        = FP_YCENTER;    
    dsend("VI 16; CA; CL");              /* Reset WORDPLAY to EGA mode       */
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
    print("SHOW M displays experiment");
    
    /* DEFINE OBJECT GRAPH PARAMETERS AND CREATE OBJECTS */

    oSetGraph(gLEFT, aTITLE, "Retina Stabilization Task");
    oSetGraph(gLEFT, aRANGE, 0, XMAX, 0, YMAX);

    oEye = oCreate(tCROSS, gLEFT, 20, 20);

    oFPBright = oCreate(tBOX, gLEFT, FP_SIZE, FP_SIZE);
                oSetAttribute(oFPBright, aINVISIBLE);
                oSetAttribute(oFPBright, aFILLED);

    oFPDim = oCreate(tBOX, gLEFT, FP_SIZE, FP_SIZE);
             oSetAttribute(oFPDim, aINVISIBLE);
             oSetAttribute(oFPDim, aUNFILLED);

    oStim = oCreate(tBOX, gLEFT, STIM_SIZE, STIM_SIZE);
            oSetAttribute(oStim, aINVISIBLE);
            oSetAttribute(oStim, aUNFILLED);

    print("Use TEMPO's SHOW M display to watch eye movements.");
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
    bright_time = poisson(avg_bright) + min_bright;
    wait    bright_time;

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
// REWARD - Counts successful trials.

HIDE reward_time = 1000;                /* Length of time to give reward    */
HIDE locus;                             /* 0=north, 1=east, etc.            */
HIDE det;                               /* Stabilization matrix determinate */

process REWARD
    {
    xeq     FP_OFF;                     /* Turn off fixation point          */
    rewards = rewards + 1;
    print("Trial ", trials, "- Correct response.");
    }

/*--------------------------------------------------------------------------*/
// STABILIZED_STIMULUS - Controls when the stabilized box is displayed.

HIDE    stim_on_time    = 500;          /* Stimulus is flashed on and off   */
HIDE    stim_off_time   = 500;
HIDE    stim_pause_time = 500;
HIDE    stim_is_on;

process STABILIZED_STIMULUS enabled
    {
    xeq     STABILIZE;                  /* Stabilize stimulus when on       */
    while (1)
        {
        wait    stim_pause_time;        /* Give monkey time to fixate       */
        while (fp_state == BRIGHT)
            {
            trigger     1;              /* Collect data when stimulus is on */
            stim_is_on = 1;             /* Turn stimulus on                 */
            wait        stim_on_time;

            stim_is_on = 0;             /* Turn stimulus off                */
            trigger     2;              /* Collect data when stimulus is off*/
            wait        stim_off_time;
            }
        while (fp_state != BRIGHT)      /* Wait for bright                  */
            nexttick;
        }
    }

/*--------------------------------------------------------------------------*/
// STABILIZE - Displays a large box at a point relative to the
//  fixation point and stabilized to a the eye position;  As the
//  monkey moves his eyes, this box will always appear at the
//  same location on the retina.

process STABILIZE
    {
    while (1)
        {
        oSetAttribute(oStim, aVISIBLE);

        while (stim_is_on)
            {
            stim_x = eye_x + STIM_DX;
            stim_y = eye_y + STIM_DY;
            oMove(oStim, stim_x, stim_y);

            /* REDRAW STIMULUS ONLY IF POSITION CHANGES */

            if (stim_x_old != stim_x && stim_y_old != stim_y)
                {
                /* ERASE STIMULUS */
                dsend("CO 0; RF ", stim_x_old, stim_y_old, stim_x_old + STIM_SIZE, stim_y_old + STIM_SIZE);

                /* DRAW STIMULUS */
                dsend("CO 4; RF ", stim_x, stim_y, stim_x + STIM_SIZE, stim_y + STIM_SIZE);

                stim_x_old = stim_x;
                stim_y_old = stim_y;
                }

            wait    20;                 /* Refresh rate of video */
            }

        /* STIMULUS WAS TURNED OFF - ERASE IT */

        oSetAttribute(oStim, aINVISIBLE);
        dsend("CO 0; RF ", stim_x_old, stim_y_old, stim_x_old + STIM_SIZE, stim_y_old + STIM_SIZE);

        while (!stim_is_on)
            nexttick;                   /* WAIT FOR IT TO GO ON AGAIN */
        }
    }

/*--------------------------------------------------------------------------*/
// FP_BRIGHT makes the fixation point bright and updates fp_state.
process FP_BRIGHT
    {
    dsend("CO 15; RF ", fp_x, fp_y, fp_x + FP_SIZE, fp_y + FP_SIZE);
    fp_state = BRIGHT;
    oMove(oFPBright, fp_x, fp_y);
    oSetAttribute(oFPBright, aVISIBLE);
    }

// FP_DIM makes the fixation point dim and updates fp_state.
process FP_DIM
    {
    dsend("CO  7; RF ", fp_x, fp_y, fp_x + FP_SIZE, fp_y + FP_SIZE);
    fp_state = DIM;
    oSetAttribute(oFPBright, aINVISIBLE);
    oMove(oFPDim, fp_x, fp_y);
    oSetAttribute(oFPDim, aVISIBLE);
    }

// FP_OFF turns off the fixation point and updates fp_state.
process FP_OFF
    {
    dsend("CO  0; RF ", fp_x, fp_y, fp_x + FP_SIZE, fp_y + FP_SIZE);
    fp_state = OFF;
    oSetAttribute(oFPBright, aINVISIBLE);
    oSetAttribute(oFPDim, aINVISIBLE);
    }

/*--------------------------------------------------------------------------*/
// EYE Updates eye_x and eye_y to current eye position every process cycle.
// eye_x and eye_y are in video coordinates.

HIDE ax, ay;                            /* Eye position in analog coordinates*/

process EYE enabled                     /* Fetch eye coil coordinates       */
    {
    while (1)
        {
        if (DEBUG)
            {
            wait poisson(700);
            eye_x = fp_x + normal(40);  /* For testing                      */
            eye_y = fp_y + normal(40);  /* ..simulate eye movement          */
            }
        else
            {
            ax = atable(1);             /* When eye coils are connected     */
            ay = atable(2);             /* ..to analog input 1 and 2        */

            // CONVERT FROM ANALOG COORDINATES TO VIDEO COORDINATES
            // USING THE CALIBRATION MATRIX.

            eye_x = (ax * a11 + ay * a12) / 1000 + XMAX / 2 ;
            eye_y = (ax * a21 + ay * a22) / 1000 + YMAX / 2 ;
            }

        oMove(oEye, eye_x, eye_y);      /* Position eye on OBJECT graph     */
        nexttick;                       /* Force atleast one wait           */
        }
    }

/*--------------------------------------------------------------------------*/
// HAND - Provides fake bar presses when DEBUG is set to 1.
// You must spawn this task from TEMPO's command line to fake out bar presses.
// For example, type the TEMPO command: SPAWN HAND

HIDE press_time;
process HAND enabled                    /* Simulate bar presses             */
    {                                   /* (for testing only)               */
    wait 5000;                          /* 5 seconds                        */
    while (1)
        {
        wait random(3000);              /* rest a moment                    */
        status_set(bar);                /* Press the bar                    */
        press_time = random(2 * (avg_bright + min_bright));
        wait press_time;
        status_clr(bar);                /* Release the bar                  */
        }
    }
