//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																												//
//																												//
//                                                        Countermanding task.	DECEMBER 2004													//
//																												//
//                                           Created by pierre_pouget@vanderbilt.edu  & erik.emeric@vanderbilt.edu							//
//																												//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// TEMPO SUBFUNCTIONS NEEDED ///////////////////////////
#pragma declare = 1                     					 	 // Require declarations of all variables
#include object.pro                   						 // Required when using object graphs
#include DIO.pro
//////////////////////////////////////// settings in dialog box
declare time_stim_test;
declare maya;
declare Perf_SSD_1;
declare Perf_SSD_2;
declare Perf_SSD_3;
declare Perf_SSD_4;
declare Perf_SSD_5;
declare Total_SSD_1;
declare Total_SSD_2;
declare Total_SSD_3;
declare Total_SSD_4;
declare Total_SSD_5;
declare Canc_SSD_1;
declare Canc_SSD_2;
declare Canc_SSD_3;
declare Canc_SSD_4;
declare Canc_SSD_5;
declare Abort_SSD_1;
declare Abort_SSD_2;
declare Abort_SSD_3;
declare Abort_SSD_4;
declare Abort_SSD_5;
declare SSD_1;
declare SSD_2;
declare SSD_3;
declare SSD_4;
declare SSD_5;
declare  int SSD_refresh;
declare mean_latency;
declare int rand_ssd;
declare MultElectrodeStimFlag =0; // RandStimCh only active if MultMultElectrodeStimFlag set to 1;
declare RandStimCh; // when using 2 electrode this random number determines which channel stimulation is delivered to

declare MaxTimeToFixate; 

declare MONKEY=1;
declare WRITE_PARAMS_FLAG = 0;

declare float Distance; // DISTANCE FROM EACH MONK'S EYE TO MONITOR. user defined in main_f.pro
declare float S_dist; 	// distance from fixation to target in cm
declare DEBUG;
declare AUTOMONKEY;

declare Fix_H = 190;                                // Size of box in which eye can be and be said to fixate target.
declare Fix_V = 190;
declare Volt_Fix_H_1;                          // Voltage value for Fixation Window
declare Volt_Fix_V_1;
declare Volt_Fix_H_2;                          // Voltage value for Fixation Window
declare Volt_Fix_V_2;
declare Sign_Volt_Fix_H_1;
declare Sign_Volt_Fix_H_2;
declare Sign_Volt_Fix_V_1;
declare Sign_Volt_Fix_V_2;
//MWL
declare Volt_Fix_H_1real;
declare Volt_Fix_V_1real;
declare Volt_Fix_H_2real;
declare Volt_Fix_V_2real;

//MWL

declare Targ_H = 210;	                             // Size of box in which eye can be and be said to fixate center.
declare Targ_V = 210;
declare int Volt_Targ_H_1;						 // Voltage value for the Target window
declare int Volt_Targ_V_1;
declare int Volt_Targ_H_2;						 // Voltage value for the Target window
declare int Volt_Targ_V_2;
//MWL
declare int Volt_Targ_H_1real;						 // Voltage value for the Target window
declare int Volt_Targ_V_1real;
declare int Volt_Targ_H_2real;						 // Voltage value for the Target window
declare int Volt_Targ_V_2real;
//MWL

declare XGAIN =  35;
declare YGAIN = -35;
declare V_OFFSET ;
declare H_OFFSET;
declare XMAX=1280;  										 // Variables for size of animation graph windows.
declare YMAX=1024;  										 // Variables for size of animation graph windows.

declare XMAX_SCREEN=1280;  										 // Variables for size of animation graph windows.
declare YMAX_SCREEN=1024;  										 // Variables for size of animation graph windows.
declare Vrefresh = 16.6667;

///////////// PENETRATION INFO /////////////////
declare GridEdge=31;
declare Dura=22;
declare Nchs=4;
declare Depth;

declare Impedance1=27;
declare ML1=-2;
declare AP1=3;

declare Impedance2=29;
declare ML2=-2;
declare AP2=4;

declare Impedance3=40;
declare ML3=-1;
declare AP3=4;

declare Impedance4=28;
declare ML4=-1;
declare AP4=3;

/////////////////////////// GENERAL DECLARATION

declare int nASETS;				// Current setting for ASETS =0 for real analog, =1 for mouse input
declare READY_S=0;
declare SOUND_FLAG=0;        /// Creat sound  start and stimulation
declare toto=0;	    		 // Variable for debugging
declare step=0;

////////////////////////// PROTOCOL DECLARATION

declare Task=1;                       // Countermanding
declare TEST_VIDEO=0;				  // Check if the screen is on
declare oF, oF1, oE, oE1, oB1, oB1x;		   //	Animation object variables.

/////////////////////////////// EVENT RELATIVE OT EYES LOCATION

declare In_Fixation_Window = 0;									 // Tracks whether eye position is in fixation square.
declare In_Target = 0;											 // Tracks whether the eye is in the target box.	   //500
declare failed = 0;												 // Monitors whether trial has failed.
declare fix_control=1; 											 // Controlling whether monkey needs to fix before trial; default=0; fix_conto=1 no fix needed
declare in_init_fixation_window;								 	// Tracks whether the eye is in the initial fixation area.
declare ERR_OK = 0;											 // Sets variable Failed to 0 at beginning.
declare ERR_LEAVE_FIX = 1;									 // Error: left fixation too quickly.
declare ERR_NO_FIXHOLD = 2;//this is not anywhere else in protocol	 // Error: did not hold fixation long enough.
declare ERR_TAR_TOOLATE = 3;								 // Error: did not acquire target quickly enough.
declare ERR_NO_HOLDTAR = 4;									 // Error: did not hold target (targ or fixation) long enough.
declare ERR_NOFIX_STOPTRIAL = 5;							 // Error: made a saccade in a stop-signal trial.
declare ERR_TIME_SAC=6;
declare correctmarker = 0;										 // Marks whether the trial was a success for WRITE_PARAMS().
declare float TrialCount, SuccessCount;		 					 // Trial record variables.
declare float NoStopSuccessCounter = 0;							 // Counter for no-stop trial successes.
declare float NoStopAbortCounter = 0; 							 // Counter for no-stop fixation aborts MWL
declare float StopSuccessCounter = 0;							// Counter for stop signal trial successes.
declare float StopAbortCounter = 0;								// Counter for stop fixation aborts MWL
declare float StopCounter; 										 //	Counter for stop trials.
declare float NoStopCounter;									 // Counter for no-stop trials.
declare	signal_respond_marker = 0;								 // Marks whether trial failed because it was a signal-respond trial.

//////////////////////// TIME ON THE CLOCK////////////////////
declare end_fix_presentationT;		// Marks the time on the clock when the fixation box will disappear.
declare end_fix_targ_maxT =600;		// Marks the time on the clock by which the subject must have saccaded from fix to target.
declare stop_signal_startT;		// Marks the time "Clock" when the stop signal was presented.
declare end;				// Marks time on clock when holding time for target or fixating time in stop-signal trials ends.
declare start_time;			// Stores the time at which a trial begins.
declare float sac_latency;		// Records latency of saccade to target.
///////////////////////////// COUNTERMANDING VARIABLES
declare int nSSD;				// number of SOA intervalls			min, min*kStep .... max
declare int nTrials = 10;		// Number of different trials in a cycle.
declare int BlockTrialNum = 0;  	// Counter of Trials in a block
declare int TotalTrial = 0;
declare int STOP_FRACTION_STEP_FLAG = 0;
declare int nnStop;
declare int nTypes;
declare int nStop;
declare int nPOS_zero;
declare int nPOS_others;
declare int nZAP_NOGO;		// Number of NOGO trials with  Stimualtion
declare int nISNOTNOGO;		// Number of GO Trials with Stimulation; control for stim on nogo trials
declare int nNOGO;
declare int tfraction = 50;           // fraction of trials with target @ pos 0 (1== max) (2 == 50%)
declare int NOGO_RATIO =40;	 // Fraction of nogo trial
declare int ZAP_RATIO =0;
declare int ISNOTNOGO_RATIO = 0;
declare ISNOTNOGO_RATIO_Dial = ISNOTNOGO_RATIO;
declare floor_ct;    // Will count how many times the monk makes errors at the lowest SSD and will altert the user when it is above chance.
////////////////////////////// PERFORMANCE DIALOG BOX
/*
declare int NB_Success_SSD1
declare int NB_Success_SSD2
declare int NB_Success_SSD3
declare int NB_Success_SSD4
declare int NB_Success_SSD5
declare int NB_Error_SSD1
declare int NB_Error_SSD2
declare int NB_Error_SSD3
declare int NB_Error_SSD4
declare int NB_Error_SSD5
*/
////// ARRAYS DECLARATION
declare i = 0;					  // Trial Array index (which side of axis target is presented on ).
declare j = 0;					 // Type Array index (whether it's a stop or no-stop trial).
declare s = 0;					 // Stop Array index (stop-signal delay in stop trials).
declare Stimu[2000];
declare trials[2000];			 // Trial Array (which side of axis target is presented on ).
declare types[2000];			 // Type Array (whether it's a stop or no-stop trial).
declare stop[2000];			 // Stop Array (stop-signal delay in stop trials).
declare STOP_success[200];
declare STOP_abort[200];
declare SSD_array[200];
declare STOP_noncanc[200];
declare inhib_fct[200];
////////////////////////////////////////////////
declare tfraction_Dial=tfraction;
declare NOGO_RATIO_Dial = NOGO_RATIO;
declare SSD_Step=60;									// SOA steps
declare SSD_min=0;										// SOA min
declare SSD_max=420;  									// SOA max
declare int RandomStep;									// to increase the variability of the ssds staircasing can step up or down 1-3 ssds
declare fix_targ_maxT;					// Maximum RT for moving from fixation window to target window.
declare ZAP_RATIO_Dial=ZAP_RATIO;
declare staircase=1;						// Staircase for SSD =0 by default (no staircase)
declare staircaseSSD1 = SSD_min+SSD_step*4;			// MODIFIED 1-15-2008 EEE  ADDED staircaseSSD to increase/decrease the SSD for on the current trial
declare SOUND_S = 0;						// Flag wether use of acoustic stop signal (0=no 1= yes)
declare ISNOT_NOGO = 0;					// Flag wether the current trial is not a nogo trial 0 by default (for electrical stim parameter)
declare TRIG_CHANGE = 0;					// Flag wether trigger is changed of color	0=no by default
declare REWARD_RATIO = 100;				// Fraction of rewarded trial ( 09/21/2004 =1 Loop need to be added
declare BIG_REWARD_RATIO = 0;				// Fraction of trials where reward and punishment are multiplied by 3
declare BIG_REWARD_NO_CUE_RATIO=0;		// Fraction of big reward trials with no cue trials where reward and punishment are multiplied by 3
declare frac_large_juice_no_cue =0;
declare BIG_REWARD = 0;						// Triple reward/punishment flag for Infos_
declare BIG_REWARD_FLAG = 0;				// Triple reward/punishment flag for TEMPO turns the manipulation on or off
declare frac_no_reward = 5;                               	 // % of no reward trial (which should be rewarded
declare frac_extra_reward =5;
declare frac_mult_reward =50;
declare feedback = 0;                                             //  flag whether to give feedback about errorby turning off the target
declare Bell=1;                                                   	// postive 2ndary reinforcer
declare REWARD_SIZE=35;				 // Amount of time to give juice.
declare REWARD_MULTIPLIER =3;
declare int realRewardSize;
declare SOUND_REWARD=0;                              	// Acoustic reinforcement
declare Block=0;
declare tot_others;
declare ind_others;
declare neg_2reinforcement=0;				// negative second reinforcer  = no sound  !!! Note: that this only occurs on noncancelled trials when this flag ==1
declare PAUSE_REWARD=0;				// delay between correct or incorrect and juice
declare DR1=0;  							// boolean flag where only one target is rewarded during that block
declare DR1_frac_no_reward = 0;			// % of trials that are rewarded at a given target location on a given block
declare DR1_current_reward_target = 1; // location of currently unrewarded target
declare LastTrialOutcome=0;		// 0 if the last trial was correct, 1 if error
declare LastTrialTargetLoc =1;         //
/////////////////////////////////////////////////////
declare FIXED_JITTER=0;					// JITTER is Linear (random(value) + or -)
declare EXPO_JITTER=1;					// JITTER is "expo" number (right part of normal distribution + constant
///////////////////////////// FRACTION JITTER IF LINEAR
declare int frac_fix_jitter=40;	 			// fixation
declare int frac_stop_t_jitter=0;			// hold on fixation after stop signal
declare int frac_hold_jitter=0;				// hold on target after Go trial
declare float expo_1;
declare float expo_2;
declare float expo_3;						 // Turn on animation.
declare int expo_jitter_fixation;
declare int expo_jitter_target;
declare int expo_jitter_stop;
declare arrHoldTimes [296];
///////////////////////////// HOLD Time
declare initfix_minT = 300;  					// Initial fixation requirement time.
declare end_initfix_minT;	 				// Marks the time on the clock during which the eye must be in the initial fix area (time() + initfix_minT).
declare fix_t= 200; 				                // Presentation time of fixation point.
declare fix_jitter= 40;
declare hold_fixation_time;
declare stop_fix_t = SSD_max*3;	 		// Minimum time to fixate center after stop signal is presented.
declare stop_fix_t_jitter;
declare stop_fix_time;
declare holdtime = 600;						// Time to hold target in no signal trial.
declare NegToneTime;
declare holdtime_jitter;
declare hold_target_time;
declare step_lat;
declare trial_start;
declare step_wind;
declare step_targ;
declare Tpos_0_bias = 0;                               	// Stop fraction bias toward one specific location
declare BIAIS_RATIO = 50;
//////////////////////////////////////////////////////////////////
declare constant waitAutoMonkey = 520;
declare inter_trial = 200;  					// Intertrial interval variables.
declare initfix_punishtime = 200;	  		 	// Amount of wait time for punishment if initial fixation not maintained.
declare signal_respond_punishT =1500; 		// Wait time if trial failed due to signal-respond.
declare Sacc_time=600;
declare Saccade_time;						// this is not used anywhere els in this protocol !!!!!!!!!!
declare Saccadic_time;						// this is not used anywhere els in this protocol !!!!!!!!!!
declare GO_DELAY=0;						// this is not used anywhere els in this protocol !!!!!!!!!!	it was used but commented out
declare EOT_delay=800;                     // delay after end of trial to have room for psacdet. modified 051606
declare time_EOT;
// Time between fixation off and target on // 0 in coutnermanding
//////////////////////// STIMULI CONFIGURATION ///////////////////
declare float width;											 // Width of squares TARGET.
declare float width_Deg, S_width, width_y;	 					// MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
declare float fix_width_Deg, fix_width , fix_S_width, fix_width_y;
declare npos = 2;											 	// Number of stimulus position
declare tpos = 0;                                            						// angle relative to right==0 for the target location
declare ang = 0;												// Angles it the angle in degrees from horizontal axis going clockwise.
declare ang_2=45;                                                						// In Case of 4 target locations Angles between the two first targets in degrees from H clock between the TARGET location
declare ang_3=45;	  											// In Case of 6 target locations Angles between the two seconds targets targets in degrees from H clock between the TARGET location
declare int eccen_Deg = 10;										// Eccentricity in degrees // MODIFIED: 09-12-2007 EEE DISTANCE FROM EACH MONK'S EYE TO MONITOR IS USED TO DETERMINE REAL VISUAL DEGREES
declare eccen = 350;
declare eccen_1 = 310;    										//first pair of targets	   // Eccentricity defines visual angle between center and target.
declare eccen_2 = 310;    										//second pair of targets
declare eccen_3 = 310;	  										//third pair of targets
											 				// Eccentricity defines visual angle between center and target.
declare TarH, TarV;											// Target horizonatal and vert location for VideoSync.
declare float Anisop_Y = 1.23; 									// MODIFIED: 05-24-07 EEE ADDED RATIO OF HOR VS VERT SCREEN DISTORTION Y = 1.23*y, WHERE y IS THE VALUE OF Y IF THE SCREEN WAS SQUARE
declare col_tar = 2;											// VideoSync variable for the color of the target.
declare col_fix = 16;
declare LumR=0;
declare LumG=20;
declare LumB=0;
declare x, y, ax, ay, fixx, fixy,bxc,byc,axc,ayc;						//	Coordinates for determining eye position.
///////////////////////////////// STIMULATION VARIABLES
declare STIM_MARKER=2; 					//event used as the refernence for stim: 1 for fixation 2 SSD 3 REWARD
declare STIM_OFFSET=2;					//MWL 6/12/06 changed from 52 to 0
declare STOPZAP=0;
declare STIM_FLAG=0;
declare time_trials_start;
declare time_target_on;
declare time_stop_signal;
declare time_reward;
declare endRewardTime;

// MOUTH MOVEMENT DETECTION VARIABLES
declare int STATUS = 0;
declare int STILL = 0;
declare int NOT_STILL = 1;
declare float mouth;
/////////////////////////////////////// PROCESSES DECLARATION ///////////////////////////////////
declare MAIN();
declare INITIALIZE();
declare STIM();
declare DRAW_STIM();
declare ANIMATION();
declare WATCHEYE();
declare WATCHMOUTH() ;
declare TRIAL_LOOP();
declare TRIAL();
declare START_SOUND();
declare WRONG();
declare SUCCESS();
declare CLEAR();
declare END_TRIAL();
declare REWARD();
declare REWARD_SOUND();
declare WRITE_PARAMS();
declare MARKER();
declare MARKER_2();
declare INIT_FIX_CORRECTOR();
declare INIT_FIXATION_CHECK();
declare CLEAN_UP();
declare WRITE_PARAMS_TEMPO();
declare ELECT_STIM();
declare SOUND_ON_REWARD();
declare EXTRA_REWARD();
//declare WATCH_TIME();
declare CLEAR_B();
declare ACCOUSTIC_STOP();
declare CAL_FIX();
declare SOUND_NEG_REWARD();
declare FIXATION_CORRECT(); // MODIFIED 01-17-08 EEE ADDED PROCESS "FIXATION_CORRECT" TO ACCOUNT FOR DRIFT OF INITIAL EYE POSITION ACROSS TRIALS
declare WaitForVideoSYNC();
declare KERNEL_HISTOGRAM();
declare ALERT_USER();

////////////////////////	DECLARATIONS FOR SEQUENCES OF TRIALS	/////////////////////////////
declare seq_flag = 0;
declare sequential_shuffle();	   				// pierre 06/13/06
declare seq_flag = 0;
declare Seq_x[2000];		   				// pierre 06/13/06
declare Types_seq[2000];	   				// pierre 06/13/06
declare ssd[2000];							//MWL 6/15/06  array to hold SSD, doesn't have to be this big, but doens't hurt
//////////////////////////////////////////////// ADJUST OFFSET //////////////////////////////
declare eFix_H=0;
declare eFIX_V=0;
//////////////////////////////////////// PLEXON COMUNICATION ////////////////////////////////
declare int value;
declare int get = 0, put = 0;               				// get and put indexes into xmit[]
declare int constant nXMIT = 100;            			// Size of xmit[]
declare int xmit[nXMIT];						// Transmit array to Remote system
declare int constant nEventsPerProcessCycle = 10;    	// Max # of events sent per process cycle
declare int eventCode;							//=3255;
declare int usec = 150;
declare int REMOTE_TTL=1;
declare HEX dio_a,dio_b, dio_c;
//declare queueEvent(),
declare xmitEvents();
declare SendTTLToRemoteSystem (int value);
declare Delay(int uSeconds);
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process MAIN: Controls all the other processes and is the only process enabled when the protocol is started. //
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#include main_f.pro
//////////////////////////////////////////////////////////////////////////////////////////////
// Process INITIALIZE                                                                           						//
// This process intializes the animation and VideoSync objects and zeroes out the data from the 	//
// previous trial.  It is spawned by process MAIN.										//
//////////////////////////////////////////////////////////////////////////////////////////////
#include calf_f.pro
#include init_f.pro
 //////////////////////////////////////////////////////////////////////////////////////////////////
 // Process WATCHEYE																	//
 // This process continuously monitors the eye position and registers whether the position is within the	 //
 // fixation window.  It does not monitor how *long* the eye is at a certain location, only where it is.	 //
 // This process is spawned by process MAIN. 												//
 //////////////////////////////////////////////////////////////////////////////////////////////////
#include watch_f.pro
#include mouth_f.pro
////////////////////////////////////////////////////////////////////////////////
// Process Write_PARAMS FOR TEMPO									//
// This process writes the parameters of a certain trial to the event channels.	//
// It is spawned by process END_TRIAL.									//
////////////////////////////////////////////////////////////////////////////////
#include infos.pro
////////////////////////////////////////////////////////////////////////////////
// Process SEND_PARAMS FOR PLEXON									//
// This process writes the parameters of a certain trial to the event channels.	//
// It is spawned by process END_TRIAL.									//
////////////////////////////////////////////////////////////////////////////////
#include infop_f.pro
//////////////////////////////////////////////////////////////////////////////
// Process MARKER												//
//																//
// A light sensitive diode (LSD) is connected to counter channel 5.  It		//
// is positioned on the VideoSYNC monitor.  Periodically, the protocol will		//
// display/hide a box causing the LSD to emit a pulse which is picked up		//
// on counter channel 5.  This pulse is used to identify when the VideoSYNC	//
// stimulus is actually displayed to the subject.							//
//																//
// This process runs until the LSD emits a pulse.  An event code is emitted	//
// to event channel 1 and the process terminates.						//
//																//
// INPUT														//
//      event														//
//      CounterChannel5 connected to LSD								//
// OUTPUT														//
//      EventChannel1[0] receives the value "event + index" where "index"		//
//      is 0..ASETS-1, indicating the time the LSD pulse was detected.		//
//      This 														//
///////////////////////////////////////////////////////////////////////////
#include mark_f.pro
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process STIM																				//
// This process sends macro definitions to VideoSync every trial.  It is really only needed if there are       		//
// different types of trials.  Since there is only the fixation trial in this experiment, it is not necessary, 		//
// but it is placed here in case other types of trials are included later.  It is spawned by process MAIN and  	//
// by process TRIAL.     																		//
///////////////////////////////////////////////////////////////////////////////////////////////////////////
process STIM()
{
	int x_1;
	int x_2;
	int x_3;
	int rand_t1;
	int rand_t2;
	int rand_t3;
	int iii;
	int rand_biais_pos_0;
	int rand_tfrac;
	int rand_pos;
	int rand_stop_go;
	//declare int rand_ssd;
	int rand_zap;
	int rand_isnotnogo;
	int knpos;
	int rand_big_reward;
	float float_frac_fix_jitter;
	float float_frac_hold_jitter;
	float float_frac_stop_jitter;
	
	
	rand_big_reward =random(100)+1;
	if(rand_big_reward <= BIG_REWARD_RATIO)
	{
		print("Large Reward Trial");
		BIG_REWARD = 1;
	}
	else
	{
		frac_large_juice_no_cue=random(100)+1;
		if(frac_large_juice_no_cue<= BIG_REWARD_NO_CUE_RATIO)
		{
			print("Large Reward Trial: NO CUE");
			BIG_REWARD = 2;
		}
		else
		{
			print("Small  Reward Trial");
			BIG_REWARD = 0;
		}
		
	}
	
	// modified 03-02-08 EE
	// changed it so that i don't have to shuffle trials to make changes to fraction settings (stop ratio etc)
	nSSD = ((SSD_max-SSD_min)/SSD_Step)+1;				
	NOGO_RATIO = NOGO_RATIO_Dial; ZAP_RATIO = ZAP_RATIO_Dial; 
	ISNOTNOGO_RATIO = ISNOTNOGO_RATIO_Dial;
	if (npos ==2)
	{
		//tfraction_Dial = 50;
		tfraction=tfraction_Dial;
	}
	else if  (npos ==4)
	{
		tfraction_Dial = 25;
	}
	else if  (npos == 6)
	{
		tfraction_Dial = 17;
	}
	tfraction=tfraction_Dial; 

	if (Tpos_0_bias==0)
	{
		///////// TARGET POSITION /////////
		rand_tfrac = 1 + random(100);
		print("Target ", trials[i]);
		if (DR1==1 && LastTrialOutcome==1) // Repeat target location if the last trial was an error
		{
			trials[i] = LastTrialTargetLoc;
			print("1DR RepeatTarget",trials[i]);	
		}
		else
		{
			if (rand_tfrac <= tfraction)
			{
				trials[i]=1;	// Target 1
			}
			
			if (rand_tfrac > tfraction)
			{
				if (npos==2)
				{
					trials[i]=2;   // Target 2
				}
				if (npos>2)
				{
					rand_pos=1 + random(npos-1);	//random(n) generates random # from 0 to n-1
					trials[i]=rand_pos + 1;
				}
			}
			print("Random Target",trials[i]);
			LastTrialTargetLoc = trials[i];
		}		
		
		//////////// TRIAL TYPE, NOSTOP OR STOP //////////////
		if (seq_flag==1)
		{
			types[j]=Types_seq[j];
		}
		else
		{
			rand_stop_go = 1 + random(100);
			if (rand_stop_go <= NOGO_RATIO)
			{
				types[j]=2; // NOGO TRIALS
			}
			else
			{
				types[j]=1;	// GO TRIAL
				Stimu[s]=0;
			}
		}

		if (types[j]==2)
		{
			STOPZAP = 0;
			Stimu[s]=3; //regular nogo trial
			rand_zap=1 + random(100);
			rand_isnotnogo=1 + random(100);
			if (rand_zap<=ZAP_RATIO)
			{
				Stimu[s]=2; //nogo with electric stim
				RandStimCh = 1 + random(100);
				STOPZAP = STIM_OFFSET;
				print("STOPZAP = STIM_OFFSET");
				print(STIM_OFFSET);
				
				if (rand_isnotnogo<=ISNOTNOGO_RATIO)
				{
					Stimu[s]=1;  // go trial with electric stim when stop signal would have been presented
					RandStimCh = 1 + random(100);
					STOPZAP = STIM_OFFSET;// redundant EEE (i did this)
					print("STOPZAP = STIM_OFFSET on isnotnogo");
					print(STIM_OFFSET);
				}
			}
		
		}
	}  /// Unbiais Stop Fraction condition
	//////////////////////////////////////////////////
	if (Tpos_0_bias==1)
	{
		print("Stop Fraction biais toward a specific target location \n");
		rand_stop_go=1 + random(100);
		rand_biais_pos_0=1 + random(100);
		if (rand_stop_go<=NOGO_RATIO)
		{
			types[j]=2; // NOGO TRIALS
			if(rand_biais_pos_0<=BIAIS_RATIO)
			{
				trials[i]=1;	// Target 1
			}
			else
			{
				trials[i]=2;	// Target 2
			}
		}
		else
		{
			types[j]=1;	// GO TRIAL
			if(rand_biais_pos_0<=(100-BIAIS_RATIO))
			{
				trials[i]=1;	// Target 1
			}
			else
			{
				trials[i]=2;	// Target 2
			}
		}
		if (types[j]==2)
		{
			Stimu[s]=3; //regular nogo trial
			rand_zap=1 + random(100);
			rand_isnotnogo=1 + random(100);
			if (rand_zap<=ZAP_RATIO)
			{
				Stimu[s]=2; //nogo with electric stim
			}
			if (rand_isnotnogo<ISNOTNOGO_RATIO)
			{
				Stimu[s]=1;  // go trial with electric stim when stop signal would have been presented
			}
		}
	}//biased Stop Fraction condition
	////////////////// STOP SIGNAL DELAY /////////////////////
	ssd[0]=SSD_min;
	iii=2;
	while (iii <= nSSD)
	{
		ssd[iii-1]=SSD_min + (SSD_Step*(iii-1));
		iii = iii + 1;
	}
	rand_ssd=random(nSSD);

	if (staircase==0) // MODIFIED: 01-15-08 EEE  Staircase Procedure Implemented
	{
		stop[s]=ssd[rand_ssd];
	}
	else if (staircase==1)
	{
		if (Stimu[s] >1 ) // if normal Stop Signal trial
		{	// start the staircase out at the shortest ssd
			stop[s]=staircaseSSD1;	 // MODIFIED: 01-15-087 EEE
		}
	}
	// stop[s]=ssd[rand_ssd];
	SSD_1 = ssd[0];
	SSD_2 = ssd[1];
	SSD_3 = ssd[2];
	SSD_4 = ssd[3];
	SSD_5 = ssd[4];
	//count total # of trials at each ssd
	SSD_array[rand_ssd] = SSD_array[rand_ssd] + 1;
	///////////////////////////////////////////////////
	//			FIXATION AND FIX TARGET HOLD
	/////////////////////////////////////////////////////
	if(frac_fix_jitter==0)
	{
		fix_jitter=0;
	}
	if(frac_fix_jitter>0)
	{
		float_frac_fix_jitter=fix_t*(frac_fix_jitter/100.0);
		fix_jitter=random(float_frac_fix_jitter);	// modified 011106 was 	fix_t/frac_fix_jitter
		rand_t1=1 + random(100);
		if(rand_t1<50)	// "                "
		{
			fix_jitter=-fix_jitter;
		}
	}
	//////////////////////////////////
	if(EXPO_JITTER==1)
	{
	/*
		x_1=random(1000);
		expo_1=(x_1/1000.0)+((x_1/1000.0*x_1/1000.0)/(2*1))+((x_1/1000.0*x_1/1000.0*x_1/1000.0)/(3*2*1))+((x_1/1000.0*x_1/1000.0*x_1/1000.0*x_1/1000.0)/(4*3*2*1))+((x_1/1000.0*x_1/1000.0*x_1/1000.0*x_1/1000.0*x_1/1000.0)/(5*4*3*2*1));
		float_frac_fix_jitter=(frac_fix_jitter/100.0)*fix_t *expo_1*2.0;
		expo_jitter_fixation=float_frac_fix_jitter;
	*/
		x_1=random(295);
		expo_jitter_fixation = arrHoldTimes[x_1];
		hold_fixation_time = fix_t + expo_jitter_fixation;	
	}
	
	if(FIXED_JITTER==1)
	{
		hold_fixation_time = fix_t	+ fix_jitter;
	}
	///////////////////////////////
	// 	 TARGET  HOLDTIME
	///////////////////////////////
	if(frac_hold_jitter==0)
	{
		holdtime_jitter=0;
	}
	if(frac_hold_jitter>0)
	{
		float_frac_hold_jitter=holdtime*(frac_hold_jitter/100.0);
		holdtime_jitter=random(float_frac_hold_jitter);
		rand_t2=1+random(100);
		if(rand_t2<50)	// "                "
		{
			holdtime_jitter=-holdtime_jitter;
		}
	}
	//////////////////////////////////////////////////////////
	/*
	if(EXPO_JITTER==1)
	{
		x_2=random(1000);
		expo_2=(x_2/1000.0)+((x_2/1000.0*x_2/1000.0)/(2*1))+((x_2/1000.0*x_2/1000.0*x_2/1000.0)/(3*2*1))+((x_2/1000.0*x_2/1000.0*x_2/1000.0*x_2/1000.0)/(4*3*2*1))+((x_2/1000.0*x_2/1000.0*x_2/1000.0*x_2/1000.0*x_2/1000.0)/(5*4*3*2*1));
		float_frac_hold_jitter=(frac_hold_jitter/100.0)*expo_2*2.0;
		expo_jitter_target=float_frac_hold_jitter;
		hold_target_time=holdtime + expo_jitter_target;
	}
	
	if(FIXED_JITTER==1)
	{
	*/
		hold_target_time=holdtime + holdtime_jitter;
	//}
	
	//////////////////////////////////////////////////////////
	/////////////////  FIXATION HOLDTIME AFTER NOGO TRIAL
	//////////////////////////////////////////////////////////
	if(frac_stop_t_jitter==0)
	{
		stop_fix_t_jitter=0;
	}
	if(frac_stop_t_jitter>0)
	{
		float_frac_stop_jitter=stop_fix_t*(frac_stop_t_jitter/100.0);
		stop_fix_t_jitter=random(float_frac_stop_jitter);
		rand_t3=1+random(100);
		if(rand_t3<50)	// "                "
		{
			stop_fix_t_jitter=-stop_fix_t_jitter;
		}
	}
	///////////////////////////////////////////////////////////
	/*
	if(EXPO_JITTER==1)
	{
		x_3=random(1000);
		expo_3=(x_3/1000.0)+((x_3/1000.0*x_3/1000.0)/(2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0)/(3*2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0)/(4*3*2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0)/(5*4*3*2*1));
		float_frac_stop_jitter=(frac_stop_t_jitter/100.0)*expo_3*2.0;
		expo_jitter_stop=float_frac_stop_jitter;
		stop_fix_time= stop_fix_t + expo_jitter_stop;
	}
	
	if(FIXED_JITTER==1)
	{
	*/
		stop_fix_time= stop_fix_t + stop_fix_t_jitter;
	//}
	// stimulus distance from fixation point in cm
	S_dist = Distance * sin(eccen_Deg)/cos(eccen_Deg);
	eccen = S_dist / 0.0362;
	eccen = eccen * 1.2992; //swapped monitor out and this is approximate scaling factor (cheap I know but this code has had it)
	//////////////////////////////////////////////////////////////////
	// MODIFIED 05-25-07 EEE								//
	//		TARGET SIZE NOW SCALES WITH ECCENTRICITY,  	//
	//		0.3 DEG ACROSS AT 4 DEG ECCEN			   		//
	//		1.0 DEG ACROSS AT 10 DEG ECCEN			   		//
	//		width target = eccen*0.1617 - 14.048;	   			//
	//		width_Deg = 0.1167 * eccen_Deg - 0.1667;   			//
	//		width = Distance * tan(width_Deg/57.2958); 			//
	//////////////////////////////////////////////////////////////////
	if (eccen_Deg >= 4)
	{
		width_Deg = 0.1167 * eccen_Deg - 0.1667;
		S_width = Distance * sin(width_Deg)/cos(width_Deg);	// width = 0.1617*eccen-9;//14.048;   // width target = eccen*0.1617 - 14.048;
		width = S_width / 0.0362;
		width_y = width*Anisop_Y; // MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
	}
	else
	{
		width_Deg = 0.3;
		S_width = Distance * sin (width_Deg) / cos (width_Deg);	// width = 0.1617*eccen-9;//14.048;   // width target = eccen*0.1617 - 14.048;
		width = S_width / 0.0362; //width = 7;
		width_y = width*Anisop_Y; // MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
	}
	////////////////////////////////
	// DEFINE VDOSYNC OBJECTS
	/*	moved this to process INIT()
	fix_width_Deg = 0.3;
	fix_S_width = Distance * sin(fix_width_Deg)/ cos(fix_width_Deg);
	fix_width = fix_S_width / 0.0362;
	fix_width_y = fix_width*Anisop_Y;
	
	dsend("sv fix_width= ", fix_width);
	dsend("sv fix_width_y = ", fix_width_y);
	dsend("dm fix($1, $2, $3)");				// Fixation filled rectangle.
	dsend("rf $1-fix_width/2, $2-fix_width_y/2, $1 + fix_width/2, $2+fix_width_y/2");			// This is the rectangle the monkey must
	dsendf("co $3;");							// fixate for a specified amount of time.
	dsend("em");
	*/

	dsend("sv width= ", width);			// Define width (squares' width & length) for vdosync
	dsend("sv width_y =",width_y); 		// MODIFIED: 01-17-2008 EEE MADE TARGETS SQUARE.
	dsend("dm target($1, $2, $3)");		// Target square.
	dsend("rf $1-width/2, $2 - width_y/2, $1+width/2, $2 + width_y/2");// MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
	dsendf("co $3;");
	dsend("em");

	dsend("dm targmarker($1, $2, $3)");  	// One square for photodiode (MARKER process).
	dsend("rf $1-9, $2-11, $1+9, $2+7");	//75
	dsendf("co $3;");
	dsend("em");
	
	////////////////////////////////////////////////////////////////////////////////
	// MODIFIED:01-17-08 EEE											//
	//	ADDED RATIO OF HOR VS VERT SCREEN DISTORTION				//
	//	Y = 1.23*y, WHERE y IS THE VALUE OF Y IF THE SCREEN WAS SQUARE	//
	////////////////////////////////////////////////////////////////////////////////
	//////////////////////////// CASE TWO STIMULI  Right or left 0 or 180deg ////////////////////////////////
	if (npos==2)
	{
		if (trials[i] == 1)										     // Specifies on which side of the axis the target will appear.
		{
			TarH = cos(ang+tpos - 180)*eccen;
			TarV = -sin(ang+tpos - 180)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 2)
		{
			TarH = cos(ang+tpos)*eccen;
			TarV = -sin(ang+tpos)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
	} //end npos==2
	//////////////////////////// CASE FOUR STIMULI   Cross 0 90 180 270 ////////////////////////////////
	if (npos==4)
	{
		if (trials[i] == 1)										     // Specifies on which side of the axis the target will appear.
		{
			TarH = cos(ang)*eccen;
			TarV = -sin(ang)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 2)
		{
			TarH = cos(ang+ang_2)*eccen;
			TarV = -sin(ang+ang_2)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 3)
		{
			TarH = cos(ang - 180)*eccen;   //// oposite to 1
			TarV = -sin(ang - 180)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 4)
		{
			TarH = cos(ang+ang_2 - 180)*eccen;	  //// oposite to 2
			TarV = -sin(ang+ang_2 - 180)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
	} // end of 4 stimuli
	//////////////////////////// CASE SIX STIMULI   Cross 0 90 180 270 ////////////////////////////////
	if (npos==6)
	{
		if (trials[i] == 1)										     // Specifies on which side of the axis the target will appear.
		{
			TarH = cos(ang+tpos)*eccen;
			TarV = -sin(ang+tpos)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 2)
		{
			TarH = cos(ang+tpos+ang_2)*eccen;
			TarV = -sin(ang+tpos+ang_2)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 3)
		{
			TarH = cos(ang+tpos+ang_2+ang_3)*eccen;
			TarV = -sin(ang+tpos+ang_2+ang_3)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}

		else if (trials[i] == 4)
		{
			TarH = cos(ang+tpos - 180)*eccen;   //// oposite to 1
			TarV = -sin(ang+tpos - 180)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 5)
		{
			TarH = cos(ang+tpos+ang_2 - 180)*eccen;	  //// oposite to 2
			TarV = -sin(ang+tpos+ang_2 - 180)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
		else if (trials[i] == 6)
		{
			TarH = cos(ang+tpos+ang_2+ang_3 - 180)*eccen;	  //// oposite to 2
			TarV = -sin(ang+tpos+ang_2+ang_3 - 180)*eccen* Anisop_Y;// MODIFIED:01-17-08 EEE
		}
	} // end of 6 stimuli
	//////////////////////////////////////////////////////////////////////////////
	if (types[j] == 1)	 // Specifies whether it will be a stop signal/ no stop signal trial.
	{
		print("Go Trial \n");
	}
	else if (types[j] == 2)
	{
		if(Stimu[s]==3)
		{
			print("NOGo Trial \n");
			printf("SSD=%dms\n",stop[s]);
		}
		if(Stimu[s]==2)
		{
			print("Zap NOGo Trial \n");
			printf("SSD=%dms\n",stop[s]);
		}
		if(Stimu[s]==1)
		{
			print("ISNOTNOGo Trial \n");
		}
	}
	else if (types[j] == 0)
	{
		printf("ERROR ");
	}
	if (trials[i]== 0)
	{
		printf("ERROR 0");
	}
	dsend("sv TarH= ", TarH);		// Assign var 'TarH' into vdosync var 'TarH'.
	dsend("sv TarV= ", TarV);
	dsend("sv col_tar= ", col_tar);	 // Assign var 'col_tar' (target_color) into vdosync var 'col_tar'.
}
/////////////////////////////////////////////////////////////////////////////////////////////
// Process DRAW_STIM 																	   //
// This process draws the fixation squares on the screen.  It is spawned by process TRIAL. //
/////////////////////////////////////////////////////////////////////////////////////////////
process DRAW_STIM()
{
	spawn ANIMATION;
	time_stop_signal = time()  + 30000000; // did this because the stim was being presented with the target
	MaxTimeToFixate = time() +30000000;
	//////////FIXATION ON//////////	
	
	if (BIG_REWARD==1)
	{
		dsendf("co 10;");		// 10 = green.
	}
	else
	{
		dsendf("co 7;");		// 15 = white.
	}
	dsend("xm fix(0, 0, 7)");
	spawn SendTTLToRemoteSystem(2301);
	
	if (fix_control == 1)
	{		
		// get current time 
		// last time to fixate = current time + max time to fixate;
		MaxTimeToFixate = time() + 5000;		
		while (!In_Fixation_Window && time()< MaxTimeToFixate) // && time() < last time to fixate
			nexttick;	
			// if fixating
			if (In_Fixation_Window)
			{
				spawn SendTTLToRemoteSystem(2660);
				spawn FIXATION_CORRECT;
				//print("zero eye");
			}		
		// else end the current trial 
	}	
	wait(hold_fixation_time);	// Wait a fix_t + random amount of time.	
	
	//////////FIXATION OFF//////////
	//wait(GO_DELAY)                                        /// 0 in countermanding

	// TARGET ON
	if (failed == 0) //but only if he didn't leave fix early
	{
		spawn SendTTLToRemoteSystem(2651);		
		dsend("VW");
		dsend("WM 1");
		spawn MARKER;
		
		//next 3 lines display target
		//can set luminance with Lum
		//dsendf("cm %d,%d,%d,%d;",col_tar,Lum,Lum,Lum);
		//dsendf("co %d;",col_tar);
		//dsend("xm target(TarH, TarV, col_tar)");
		// next line resets color table in needed
		// dsend("cm *");
		// next 3 lines also display target
		// no option to change luminance
		
		dsendf("co col_tar;");
		dsend("xm target(TarH, TarV, col_tar)");
		dsend("co 15;"); // set color to white, prepare to turn on after VW
		dsend("xm targmarker(-615,485,0)"); //dsend("xm targmarker(-640,510,0)");
		
		dsend("VW");
		spawn SendTTLToRemoteSystem(2300);
		
		//next 3 lines effectively turn off fix point...cover it with black
		if (stop[s]>40)
		{
			dsendf("co 0;");
			dsend("xm fix(0, 0, 0)");
			dsendf("co 0;");
			dsend("xm targmarker(-615,485,0)");
		}
		// event_set(1,0,2651);									 // Event Code for Tempo data base.
		// nexttick;

		//  trigger 1;
		// NOT REALLY USED... COULD BE COMPARED with TARGET_ON of photodiode response
	}

	//  photodiode on the screen  looks for light to indicate presentation of target.
	if(types[j] == 2)
	{
		/// increment the number of Stop tRials not very usefull but Erik is interested by this variable
		//if(Stimu[s]==1 || Stimu[s]==2 || Stimu[s]==3)
		//{
			SSD_refresh=(stop[s]/Vrefresh)-1;
			dsendf("VW %d \n",SSD_refresh);
			spawn SendTTLToRemoteSystem(2653);

			//if(Stimu[s]==2 || Stimu[s]==3) //MWL 6/12/06 commented this line and added below
			// if(Stimu[s]==1 || Stimu[s]==2 || Stimu[s]==3)
			//{
				//SSD_array[rand_ssd]= SSD_array[rand_ssd]+1;
				if(SOUND_S==0)
				{
					//This MAKEs IT SO THAT IF EARLY NONCANCELLED STOP SIGNAL IS NEVER PRESENTED
					while ( time() < time_stop_signal - Vrefresh)
						nexttick;
					//present STOP SIGNAL (fix spot)
					if (failed == 0 ||feedback ==0) //but only if didn't leave fix early
					{
						if (Stimu[s]>1)//(Stimu[s]==2 || Stimu[s]==3)//MWL 6/12/06 added this line
						{
							spawn MARKER_2;
							dsend("WM 1");
							dsendf("co 7;");			   // then present the fixation spot again.
							dsend("xm fix(0,0,7)");
							
							dsend("co 15;");			  // set color to white, prepare to turn on after VW
							dsend("xm targmarker(-615,484,0)");
							dsend("VW");
							dsendf("co 0;");
							dsend("xm targmarker(-615,484,0)");	
						}
					}
				}
				if(SOUND_S==1)
				{
					wait(stop[s]);
					spawn ACCOUSTIC_STOP();
				}

				// event_set(1,0,2653);									 // Event Code for Tempo data base.
				// nexttick;
				// MODIFIED MAY 31, 2006 BY ERIK EMERIC
				//If the current trial is an ISNOTNOGO OR ZAP_NOGO
				if(Stimu[s]==1) //|| Stimu[s]==2)
				{
					if(STIM_MARKER==2)
					{
						while (time() < time_stop_signal + STIM_OFFSET)
							nexttick;
						if(!failed)
						{
							/* print("uStim spawned ",time());*/
							spawn ELECT_STIM;
							time_stop_signal = time_stop_signal + 30000000;
						}
					}
				}
			//}
	//	}	 /// end loop Stim[]
	} /// end of loop types[]=2 NOGO TRial
	
	if (failed>0  && feedback == 1)
	{
		
		dsend("cl");
		printf("         \n");
		printf("         \n");
		printf("         \n");
	}
	
	while ( time()< end + PAUSE_REWARD || failed == 0 )
		nexttick;
		
		if (feedback == 1)
	{
	print("XXXXXXXXXXXXXX");		
	dsend("cl");
	printf("         \n");
	printf("         \n");
	printf("         \n");
	}

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process ANIMATION																					  //
// This process is used to clear and reset the objects in the left graph.  The objects in the right graph //
// always remain because the eye cross does not create a trace, and, thus, does not need clearing.		  //
// In the original ACQUIRE protocol, the targets and distractors are all erased and recreated also.		  //
// It is spawned by DRAW_STIM.																			  //
////////////////////////////////////////////////////////////////////////////////////////////////////////////

process ANIMATION()
{
	if(TrialCount>1)
	{
		oSetAttribute(oF1, aINVISIBLE);      // Make invisible.
		oSetAttribute(oB1, aINVISIBLE);
		oSetAttribute(oB1x, aINVISIBLE);
		
		oDestroy(oF1);					// Destroy objects in the previous trial.
		oDestroy(oB1);
		oDestroy(oB1x);
	}
	
	oSetGraph(gLeft, aCLEAR);					// Clear graph.
	oB1 = oCreate(tBOX, gLeft, Targ_H, Targ_V);  	// Create TARGET object
	oB1x = oCreate(tCross, gLeft, 60, 60);		// a + cross for target
	oF1 = oCreate(tBOX, gLeft, Fix_H, Fix_V);  	 // Create fixation object
	oSetAttribute(oF1, aVISIBLE);
	oSetAttribute(oF, aVISIBLE);             		 // Make visible.
	oMove(oB1, TarH, TarV);					// Move target box.
	oMove(oB1x, TarH, TarV);
}
//////////////////////////////////////////////////////////////////////////////////////////////////
// Process TRIAL_LOOP 																			//
// This process loops indefinitely, starting a trial each time.  It is spawned by process MAIN.	//
//////////////////////////////////////////////////////////////////////////////////////////////////
process TRIAL_LOOP()
{
	int rand_extra_reward;
	
	while (1)                           						 // Loop Ntrials * NBlocks
	{
		step=0;
		TEST_VIDEO=0;
		trial_start=0;
		
		// Beginning of the Trial BOB
		spawn SendTTLToRemoteSystem(1666);
		
		if (AUTOMONKEY)
		{
			// waitAutoMonkey = 100 + random(100);
			printf("Automonkey will press bar in %d ms\n", waitAutoMonkey);
			wait waitAutoMonkey;
			system("cls");
			while (system()) nexttick;  // Wait for CLS to complete
			In_Fixation_Window=1;
			spawn START_SOUND;
			TrialCount = TrialCount + 1;
			printf("Starting Trial %d\n", TrialCount);
			printf("Trial [count] %d\n", i);
			spawn TRIAL;										 // Spawn the current trial.
			waitforprocess TRIAL;
		}
		else
		{
			spawn INIT_FIXATION_CHECK;								 // Is eye near fixation?
			waitforprocess INIT_FIXATION_CHECK;
			
			if ((In_Fixation_Window == 1 && In_init_fixation_window == 1) ||fix_control)
			{	// FIXATE
				if (fix_control == 0)
				{
					spawn SendTTLToRemoteSystem(2660);
				}
				
				// event_set(1,0,2660);									 // Event Code for Tempo data base.
				// nexttick;
				
				//MWL start counter for each trial type
				if(types[j]==1)
				{
					NoStopCounter = NoStopCounter+1; //# of no stop trials begun
				}
				else if(types[j]==2 || types[j]==3)
				{
					SSD_array[rand_ssd] = SSD_array[rand_ssd] + 1;// # of stop trials begun at each SSD
				}
				
				if(SOUND_FLAG==1)
				{
					spawn START_SOUND;
				}
				
				TrialCount = TrialCount + 1;  BlockTrialNum = BlockTrialNum + 1;
				printf("Block #: %d, Trial #: %d\n", Block,TrialCount);
				printf("Trial Number: %d\n", TrialCount);
				//printf("TOTAL Trials = %d\n", nTrials);
				// printf("Block Number: %d\n", Block);
				spawn TRIAL;										 // Spawn the current trial.
				waitforprocess TRIAL;
			}
		}
		rand_extra_reward = 1 + random(100);
		if(rand_extra_reward < frac_extra_reward)
		{
			wait(inter_trial/2);
			spawn EXTRA_REWARD;
			waitforprocess EXTRA_REWARD;
			wait(inter_trial/2);
		}
		else
		{
			wait(inter_trial);   										 // Intertrial time.
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process TRIAL																						   //
// This process starts the actual trial.  It draws the stimuli and records whether the trial was a success //
// or a failure.  It is spawned by process TRIAL_LOOP.													   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
process TRIAL()
{
	declare stop_trial_loop;	// Trigger databases with Tag 1.
	trigger 1;			// Trigger databases with Tag 1.

	stop_trial_loop=0;
	step_wind=0;
	step_targ=0;
	step_lat=0;
		
	spawn STIM;		//select stimulus and interval parameters
	waitforprocess STIM;
	//spawn WATCH_TIME;  //check eye position
	spawn DRAW_STIM;   //draw stimuli on screen
	failed = ERR_OK;                // Assume success - ERR_OK = 0
	if (fix_control == 1)
	{		
		while (!In_Fixation_Window && time()< MaxTimeToFixate)		
			nexttick;
	}			
	start_time = time();            // Note current time.

	end_fix_presentationT = start_time + hold_fixation_time + 12; //  added 12 ms for ASL delay Amount of time that fixation square is presented.
	while (time() < end_fix_presentationT && In_Fixation_Window) // Start counting time to fixate and make sure
		nexttick;										 	     // monkey stays in window for amount of time
									     // that the fixation point is on the screen.
	
	if(!In_Fixation_Window && time() < end_fix_presentationT)
	{
		failed = ERR_LEAVE_FIX;
		LastTrialOutcome=1;
		if (types[j] == 1)
		{
			NoStopAbortCounter = NoStopAbortCounter + 1; //MWL  counter for fix-aborted no stop trials
		}
		else if (types[j] == 2)
		{
			if(Stimu[s]==2 || Stimu[s]==3)
			{
				STOP_abort[rand_ssd]=STOP_abort[rand_ssd]+1;// # of fix-aborted stop trials at each SSD
			}
		}	
		
		/// Faillure the monkey does not fixate long enough
		spawn SendTTLToRemoteSystem(2750);

		spawn WRONG;
		//print("wrong in TRIAL");
		waitforprocess WRONG;
	}
	// Stage 2: Did the monkey fixate the target?
	if(!failed)
	{
		trial_start=1;
		if(types[j] == 1 || Stimu[s]==1)										 // If a no-stop trial...
		{
			end_fix_targ_maxT = time() + (fix_targ_maxT + 12);			 // add 12ms for ASL delay Fix_targ_maxT == 400.
			while(!In_Target && time() < end_fix_targ_maxT)				 	 // Wait for subject to saccade to target.
				nexttick;
			if(In_Target)										 // If the subject saccaded to the target on time.
			{
				printf("Correct saccade trial\n"); 		 // Latency=current time- end of fixation square.
				/// Correct saccade the monkey makes a sacade in a GO trial
				spawn SendTTLToRemoteSystem(2751);
				end = time() + hold_target_time + 12;		// add 12ms for ASL delay Holdtime = 400 ms
				while(time() < end && In_Target)		// Wait for subject to hold target.
				nexttick;
			}
			else if(!In_Target)					 // Else if they didn't saccade to target on time...
			{
				failed = ERR_TAR_TOOLATE;
				LastTrialOutcome=1;
				print("Failed to saccade to target on time!\n");			
				correctmarker=0;
				/// Failled to make a saccade on time in a GO trial
				spawn SendTTLToRemoteSystem(2752);	
				//print("wrong in TRIAL TO LATE");
				spawn WRONG;
				waitforprocess WRONG;
			}
		}
		else if(In_Fixation_Window && types[j] == 2)			 // Else if this is a stop trial...
		{			
			if(Stimu[s]==2 || Stimu[s]==3) // and it is a stimulated stop or regular stop trial
				{
				stop_signal_startT = time() + stop[s]+ Vrefresh;					    // add 12ms for ASL delay Find out how long to wait...
				while(time() < stop_signal_startT && In_Fixation_Window) // And make sure that they fixate for that amount of time.
					nexttick;
				if(!In_Fixation_Window && time() < stop_signal_startT)	 // If they didn't fixate for that long, stop trial.
				{
					failed = ERR_NOFIX_STOPTRIAL; signal_respond_marker = 1;
					LastTrialOutcome=1;
					STOP_noncanc[rand_ssd]= STOP_noncanc[rand_ssd]+1;//MWL counter noncanceled at each SSD
					print("Early Noncancelled \n");
					correctmarker=0;
					/// ERROR The monkey made a saccade in a NOGO trial
					spawn SendTTLToRemoteSystem(2753);
					
					if(feedback==1) /////////////////////////// feedback turn off the target if the monkey makes a saccade in nogo trials
					{
						//dsendf("co 0;");
						//dsend("xm target(TarH, TarV, col_tar)");
						//dsendf("co 15;");                              ////////////////////turnoff the target
						dsend("cl");
					}
					
					//print("wrong in TRIAL STOP TRIAL");
					spawn WRONG;
					waitforprocess WRONG;
				}
				else if(In_Fixation_Window)							 // But if they did fixate for that long...
				{
				end = time() + stop_fix_time;       					 // Holdtime = 400 ms
				while(time() < end && In_Fixation_Window)		 // Wait for subject to hold fixation.
				nexttick;
				}
			}
		}
		if (!In_Target && time() < end)    						 // Did subject hold target? - no.
		{														 // Process WATCHEYE will set In_Target = 1 if types = 2 and eye is in fixation.
			if (types[j] == 1)
			{
				printf("Abort fix target"); //printf("Error: unable to fixate target for: %d ms...\n", holdtime);
				failed = ERR_NO_HOLDTAR;// Process WATCHEYE will set In_Target = 1 if types = 2 and eye is in fixation.
				LastTrialOutcome=1;
				correctmarker=0;// TO DO: ABORTTARGETFIX COUNTER
				spawn SendTTLToRemoteSystem(2754);
				nexttick;
			}
			else if (types[j] == 2)
			{
				failed = ERR_NOFIX_STOPTRIAL; signal_respond_marker = 1;
				LastTrialOutcome=1;
				printf("Noncancelled Trial\n");
				if(feedback==1) //feedback turn off the target
				{
				 	//dsendf("co 0;");//15
					//dsend("xm target(TarH, TarV, col_tar)");
					//dsendf("co 0;");//turnoff the target
					dsend ("cl");
				}
				//printf("Accuracy: %d, %d, %6.3d %%\n", SuccessCount, TrialCount, (SuccessCount/TrialCount)*100);
				correctmarker=0;
				/// ERROR The monkey made a saccade in a GO trial But was unabled to Hold the TARGET
				spawn SendTTLToRemoteSystem(2754);
				// event_set(1,0,2754);									 // Event Code for Tempo data base.
				//nexttick;
			}
			//print("wrong in TRIAL AFTER NONCANCELLED");
			spawn WRONG;
			waitforprocess WRONG;
		}

	}
	if (!failed)                        						 // Was the trial successful?
	{
		////////////////////////////
		SuccessCount = SuccessCount + 1;						 // Count successes.
		correctmarker = 1;
		if(types[j] == 1)
		{
			//NoStopCounter = NoStopCounter + 1;
			NoStopSuccessCounter = NoStopSuccessCounter + 1;
		}
		else if (types[j] == 2)
		{
			if(Stimu[s]==2 || Stimu[s]==3)
			{
				StopCounter = StopCounter + 1; //number of stop trials
				StopSuccessCounter = StopSuccessCounter + 1;//number of successful stop trials
				STOP_success[rand_ssd]=STOP_success[rand_ssd]+1;// # of successful stop trials at this SSD
				// inhib_fct[rand_ssd]=100-(STOP_success[rand_ssd]*100/SSD_array[rand_ssd]);//prob noncanc at this SSD
				inhib_fct[rand_ssd]=100-(STOP_success[rand_ssd]*100/(SSD_array[rand_ssd] - STOP_abort[rand_ssd]));
				//printf("STOP_success = %d,%\n", STOP_success[rand_ssd]);
				//printf("SSD_array = %d,%\n", SSD_array[rand_ssd]);
				//printf("STOP_abort = %d,%\n", STOP_abort[rand_ssd]);
				//printf("STOP_noncanc = %d,%\n", STOP_noncanc[rand_ssd]);
				//following must be in multiple places so perf. dialog is updated after all trials
				Perf_SSD_1=inhib_fct[0];
				Perf_SSD_2=inhib_fct[1];
				Perf_SSD_3=inhib_fct[2];
				Perf_SSD_4=inhib_fct[3];
				Perf_SSD_5=inhib_fct[4];
				Total_SSD_1=SSD_array[0];
				Total_SSD_2=SSD_array[1];
				Total_SSD_3=SSD_array[2];
				Total_SSD_4=SSD_array[3];
				Total_SSD_5=SSD_array[4];
				Abort_SSD_1=STOP_abort[0];
				Abort_SSD_2=STOP_abort[1];
				Abort_SSD_3=STOP_abort[2];
				Abort_SSD_4=STOP_abort[3];
				Abort_SSD_5=STOP_abort[4];
				Canc_SSD_1=STOP_success[0];
				Canc_SSD_2=STOP_success[1];
				Canc_SSD_3=STOP_success[2];
				Canc_SSD_4=STOP_success[3];
				Canc_SSD_5=STOP_success[4];
				nexttick;
			}
		}
		print("Successful trial.");
		//dsend("cl");
		LastTrialOutcome=0;
		spawn SUCCESS;
		waitforprocess SUCCESS;
	}
	spawn CLEAR();
}
///////////////////////////////////////////////////////////////////////////////////////////
process ACCOUSTIC_STOP()
{
	sound(500);
	wait(160);
	sound(0);
}
///////////////////////////////////////////////////////////////////////////////////////////
// Process START_SOUND																	 //
// This process creates a sound in the testing room indicating the beginning of a trial. //
// It is spawned by process TRIAL_LOOP.													 //
///////////////////////////////////////////////////////////////////////////////////////////
process START_SOUND()
{
     /// debugging
   	if (types[j] == 1)
		{
			sound(300);
			wait 200;
			sound(0);
		}
		else if (types[j] == 2)
		{
			sound (1000);
			wait 200;
			sound(0);
		}

    mio_fout(6000);												 // Speakers in testing room.
	//sound(300);
   wait 200;                									 // Wait a period of time (ms).
  	mio_fout(0);
   //	sound(0);
}
///////////////////////////////////////////////////////////////////////////
// Process WRONG														 //
// This process is spawned by process TRIAL when the trial is a failure. //
///////////////////////////////////////////////////////////////////////////
process WRONG()
{
 //print ("WRONG");
 //print("first");
 //print(signal_respond_marker);
 //print(failed);

	spawn SendTTLToRemoteSystem(2620);			   	  // WRONG

	if(stop[s] == SSD_min && failed == ERR_NOFIX_STOPTRIAL) //dont know if stop[s] is right
		{
		floor_ct = floor_ct + 1;
		}
	else if(stop[s] != SSD_min)
		{
		floor_ct = 0;
		}
		
	if(floor_ct > 2)
		{
		spawn ALERT_USER; //sound a low bell on the server to alert the user that poor behavioral data is being collected
		}
		
	// MODIFIED 01-17-2008 EEE Negative FB only given on noncancelled trials
	if (neg_2reinforcement==1  &&  failed == ERR_NOFIX_STOPTRIAL  ) // && feedback
	{
	/*	NegToneTime  = time()+holdtime;
		while( time() < NegToneTime)
		nexttick;
		*/
		spawn SOUND_NEG_REWARD;
	}
	//print("2nd");
	//print(signal_respond_marker);
	//print(failed);
 
	// MODIFIED 01-15-08  EEE decrease SSD by SSD_Step if the current stopsignal trial is incorrect will not decrease SSD if SSD is already SSD_min
	if (staircase==1 && types[j] == 2 && failed == ERR_NOFIX_STOPTRIAL && stop[s]> SSD_min)
	{
		if (Stimu[s] >1)
		{	// decrease SSD by SSD_Step
			// we want to make this more variable 
			// random number between 1 and 3
			 RandomStep = random(2)+1;
			// if the current SSD minus the steps in ssd does not go below the maxSSD
			if (staircaseSSD1 - (SSD_Step*RandomStep)>=SSD_min)
			{
				// decrease current SSD by the ssd_step * random #
				staircaseSSD1 = staircaseSSD1- (SSD_Step*RandomStep);
				//staircaseSSD1 = staircaseSSD1- SSD_Step; // MODIFIED: 01-15-08  EEE Stair Case procedure: stop[s] = stop[s]-SSD_Step;
			}
			else
			{
					//current SSD = minSSD
					staircaseSSD1 =SSD_min;
			}
		}
		//spawn END_TRIAL;
		//waitforprocess END_TRIAL;
	}
	//print("3rd");
	//print(signal_respond_marker);
	//print(failed);
	if (signal_respond_marker == 1 && failed == ERR_NOFIX_STOPTRIAL)
	{	// only punish monkey for noncancelled saccades
		print ("Punishment");
		if (BIG_REWARD)
		{
			wait(signal_respond_punishT*3);
		}
		else
		{
			wait(signal_respond_punishT);
		}
		spawn END_TRIAL;
		waitforprocess END_TRIAL;
		signal_respond_marker = 0;		
	}
	else
	{
		spawn END_TRIAL;
		waitforprocess END_TRIAL;
	}
}

///////////////////////////////////////////////////////////////////////////
// Process ALERT_USER													 //
// This process is spawned by process WRONG above when the monkey has hit// 
//floor performance for longer than chance when the trial is a success.  //
///////////////////////////////////////////////////////////////////////////
process ALERT_USER()
	{
	sound(50);
	wait 1000;
	sound(0);
	}
	
///////////////////////////////////////////////////////////////////////////
// Process SUCCESS														 //
// This process is spawned by process TRIAL when the trial is a success. //
///////////////////////////////////////////////////////////////////////////

process SUCCESS()
{
	int rand_reward;

	trial_start=0;
	
	if(Stimu[s]==3) //This doesn't include stimulated trials
		{
		floor_ct   = 0; // This is the counter that will beep when the monkey is performing at floor level.  It resets when the monkey is correct.
		}
		
	spawn SendTTLToRemoteSystem(2600);	   //// CORRECT_TRIAL

	// event_set(1,0,2600);									 // Event Code for Tempo data base.
	// nexttick;

	//if(types[j] == 2) // if the current trial is a stop signal trial
	//{
	//	printf("P(Non-Canceled) for SSD(%dms)=%d %%\n", ((SSD_refresh+1)*16),inhib_fct[rand_ssd]); //SSD_refresh +1 because the SSD is presented on the next refresh
	//}
/*	
	if(types[j] == 1)
	{
		// CORRECT GO Trial the monkey made a saccade and was abled to Hold the TARGET
		spawn SendTTLToRemoteSystem(2755);
		// event_set(1,0,2755);									 // Event Code for Tempo data base.
		// nexttick;
	}
*/
	if (types[j] == 2)
	{
		/// CORRECT NOGO Trial the monkey did not make a saccade and was abled to Hold the Fixation point
		spawn SendTTLToRemoteSystem(2756);
		// MODIFIED: 01-15-08 EEE  Staircase procedure
		if (staircase==1 && stop[s]< SSD_max) // will not increase SSD if SSD is already SSD_max
	   	{
			if (Stimu[s] >1 )
			{	//  increment SSD by  SSD_Step
				// we want to make this more variable 
				// random number between 1 and 3
				RandomStep = random(2)+1;
				// if the current SSD plus the steps in ssd does not exceed the maxSSD
				if (staircaseSSD1 + (SSD_Step*RandomStep) <= SSD_max)
				{
					// increase current SSD by the ssd_step * random #
					staircaseSSD1 = staircaseSSD1 + (SSD_Step*RandomStep);
					//staircaseSSD1 = staircaseSSD1 + SSD_Step;// MODIFIED: 1-02-07 EEE Stair Case procedure
				}
				else
				{
					staircaseSSD1= SSD_max;
				}
			}
		}
		// event_set(1,0,2756);									 // Event Code for Tempo data base.
		// nexttick;
	}


	rand_reward=random(100)+1;
	if(rand_reward <= REWARD_RATIO)
	{
		if(SOUND_REWARD==0)
		{
			if(Bell==1)
			{
				if (types[j] == 1 && sac_latency<150)
				{
					// print("No tone");
					print("For now tone");
					spawn SOUND_ON_REWARD;					
				}
				else
				{
					spawn SOUND_ON_REWARD;
				}
				//waitforprocess SOUND_ON_REWARD;
			}
			if(random(100)+1 >= frac_no_reward)
			{
				wait(PAUSE_REWARD);
				if (types[j] == 1 && sac_latency<150)
				{
					//print("RT too fast no reward ");
					print("RT for now reward ");
					if (DR1)
					{
						if (DR1_current_reward_target == trials[i])// && random(100)+1 <= DR1_frac_no_reward
						{
							printf("Target %d  REWARDED", trials[i]);							
							spawn REWARD;
						}
					}
					else
					{
					 	spawn REWARD;
					}
				}
				else
				{
					if (DR1)
					{
						if (DR1_current_reward_target == trials[i])// && random(100)+1 <= DR1_frac_no_reward
						{
							printf("Target %d  REWARDED", trials[i]);
							spawn REWARD;
						}						
					}
					else
					{
					 	spawn REWARD;
					}
				}
				//waitforprocess REWARD;
			}
			spawn END_TRIAL;
			waitforprocess END_TRIAL;
		}
		else if (SOUND_REWARD==1)
		{
			spawn REWARD_SOUND;
			waitforprocess REWARD_SOUND;
			spawn END_TRIAL;
			waitforprocess END_TRIAL;
		}
	}
	else if (rand_reward > REWARD_RATIO)
	{
		spawn END_TRIAL;
		waitforprocess END_TRIAL;
	}
}
////////////////////////////////////////////////////////////////////////////////
// Process CLEAR															  //
// This process clears the screen and registers how long it took to clear it. //
// It is spawned by processes WRONG and SUCCESS.							  //
////////////////////////////////////////////////////////////////////////////////
process CLEAR()
{
	declare time1, time2;

	time1 = time();
  	dsend("cl");
  	time2 = time()-time1;
	printf("         \n");
	printf("         \n");
	printf("         \n");
  	READY_S=1;
}

process CLEAR_B()
{
   //	declare time1, time2;
   //	time1 = time();
  	dsend("cl");
   //	time2 = time()-time1;
   //	printf("         \n");
   //	printf("         \n");
   //	printf("         \n");
}
///////////////////////////////////////////////////////////////
// Process REWARD											  //
// This process gives juice and a reward sound to the monkey. //
// It is spawned by process SUCCESS.						  //
////////////////////////////////////////////////////////////////
process REWARD()
{
	int temp_rand_mult;
	// Correct_ the monkey received Juice reward
	spawn SendTTLToRemoteSystem(2727);
	temp_rand_mult =random(100)+1;
	if ( BIG_REWARD)
	{	
		//7 Size of the reward
		realRewardSize = REWARD_SIZE * REWARD_MULTIPLIER;
		spawn SendTTLToRemoteSystem(realRewardSize);
	}
	else
	{
		//7 Size of the reward
		spawn SendTTLToRemoteSystem(REWARD_SIZE );
		realRewardSize = REWARD_SIZE;
	}

	mio_dig_set(9,1);		// Turn on TTL to juice solenoid
	if (BIG_REWARD)
	{	
		wait(realRewardSize);
	}
	else
	{
		wait(REWARD_SIZE);
	}
	mio_dig_set(9,0);		// Turn off TTL to juice solenoid
	nexttick;
	
	endRewardTime = time ();
	if(STIM_MARKER==3 && Stimu[s]<3 )
	{
		while (time() < endRewardTime + STIM_OFFSET)
			nexttick;
		if(!failed)
		{
			spawn ELECT_STIM;
			endRewardTime = endRewardTime + 200000;
		}
	}
	
}
/////////////////////////////////////////////////////////////////////////////////////////
//   Process EXTRA_REWARD													//
// //////////////////////////////////////////////////////////////////////////////////////
process EXTRA_REWARD()
{
	spawn SendTTLToRemoteSystem(2777);
	//7 Size of the reward
	spawn SendTTLToRemoteSystem(REWARD_SIZE);
	// Turn on TTL to juice solenoid
	// event_set(1,0,2777);									 // Event Code for Tempo data base.
	// nexttick;
	// event_set(1,0,REWARD_SIZE);									 // Event Code for Tempo data base.
	//nexttick;
	
	//    sound(800);
	mio_dig_set(9,1); // Turn off TTL to juice solenoid
	wait(REWARD_SIZE);
	mio_dig_set(9,0); // Turn off TTL to juice solenoid
	//  sound(0);
	nexttick;
}
///////////////////////////////////////
//   Process SOUND_ON REWARD	//
///////////////////////////////////////
process SOUND_ON_REWARD()
{
	spawn SendTTLToRemoteSystem(2778);
	//	sound(800);
	//	wait 200;
	//	sound(0);
	mio_fout(6000);												 // Speakers in testing room.
	wait(100);                									 // Wait a period of time (ms).
	mio_fout(0);
}
////////////////////////////////////////////////////
//   Process NEGATIVE SECOND REINFORCEMENT //
////////////////////////////////////////////////////
process SOUND_NEG_REWARD()
{
	spawn SendTTLToRemoteSystem(2779);
	//	sound(800);
	//	wait 200;
	//	sound(0);
	mio_fout(2000);												 // Speakers in testing room.
	wait(100);                									 // Wait a period of time (ms).
	mio_fout(0);
}
////////////////////////////////////////////////////////////////////////////////
// Process END_TRIAL														  //
// This process registers the end of a trial. 								  //
// It is spawned by processes WRONG and SUCCESS.							  //
////////////////////////////////////////////////////////////////////////////////
process END_TRIAL()
{
	trial_start=0;
	spawn CLEAR();
	if(types[j]==2 && Stimu[s]==1)
	{
		ISNOT_NOGO=1; //// just used for the write parameter
	}
	time_EOT = time();
	while (time()<time_EOT+EOT_delay)
	nexttick;
	//wait(EOT_delay);
	
	// event_set(1,0,1667);   	 // Tell the event channel that a trial began.
	// nexttick;
	
	// END of the Trial EOB
	spawn SendTTLToRemoteSystem(1667);

	suspend MARKER;		   // added 051606 to close the photodiode loop if the target is not presented
	suspend MARKER_2;	   // added 051606 to close the photodiode loop if the Stop signal is not presented
	
	WRITE_PARAMS_FLAG = 1;
	spawn WRITE_PARAMS;
	waitforprocess WRITE_PARAMS;
	WRITE_PARAMS_FLAG=0;
	ISNOT_NOGO=0; // reset the current value not very elegant but....
	
	if (types[j] == 2)
	{
		s = s + 1;
		if (s>nSTop-1)
		{
			s=0;
		}
	}
	
	if (DR1 && LastTrialOutcome)
	{
		print("REPEAT TARGET LOC: j");
	}
	else
	{
		j = j + 1;
	}
	
	if (j>nTrials-1)
	{
		j=0;
	}
	
	if (DR1 && LastTrialOutcome)
	{
		print("REPEAT TARGET LOC: i");
	}
	else
	{
		i = i + 1;
	}
	
	if (i>nTrials-1)
	{
		i=0;
		Block=Block+1;
		BlockTrialNum=0;
		nexttick;
		signal_respond_marker = 0;
		if (STOP_FRACTION_STEP_FLAG)
		{
			if (NOGO_RATIO == 30)
			{
				NOGO_RATIO_Dial = 60;
				print ("Switch to 60% stop");
			}
			else if (NOGO_RATIO == 60)
			{
				NOGO_RATIO_Dial = 30;
				print ("Switch to 30% stop");
			}
		}
		if (DR1)
		{
		   	if(DR1_current_reward_target ==1)
			{
				DR1_current_reward_target=2;
				print("Switch to only Target 2 Rewarded");
			}
			else if (DR1_current_reward_target==2)
			{
				DR1_current_reward_target=1;
				print("Switch to only Target 1 Rewarded");
			}
		   	
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////
// Process REWARD_SOUND												//
// This process creates a sound in the testing room indicating a successful trial. 		 //
// It is spawned by process REWARD.											 //
/////////////////////////////////////////////////////////////////////////////////////

process REWARD_SOUND()
{
	mio_fout(6000);	 // Speakers in testing room.on
	wait(100);
	mio_fout(0);		// Speakers in testing room.off
}
/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
process sequential_shuffle()
{
	
	
	// Sequences
	int NS1S1= 1;
	int NS3S1= 2;
	int NS5S1= 3;
	int S1NS1= 4;
	int S3NS1= 5;
	int S5NS1= 6;
	
	//%Multiplier
	int Mult1= 10;
	int Mult2= 40;
	int Mult3= 20;
	int Mult4= 10;
	int Mult5= 40;
	int Mult6= 20;
	
	int j;
	int i;
	int i_x;
	int h;
	int curSeq;
	int curMult;
	int shuffled_x;
	int temp_x;
	int kk;
	
	int SeqLength;
	int nNS;
	int nS;
	int ct;
	int i_tt;
	
	ct=0;
	j=-1;
	i=1;
	
	//MWL added 7/3/06 below to get header for countermanding
	spawn SendTTLToRemoteSystem(1501);	//code to send to plexon to indicate countermanding
	
	// event_set(1,0,1501);
	// nexttick;
	
	print("test 1");
	//% initialize array
	while (i<=6)
	{
		h=1;
		if (i==1)
		{
			curSeq = NS1S1;
			curMult = Mult1;
		}
		else if(i==2)
		{
			curSeq =NS3S1;
			curMult = Mult2;
		}
		else if (i==3)
		{
			curSeq =NS5S1;
			curMult = Mult3;
		}
		else if (i==4)
		{
			curSeq =S1NS1;
			curMult = Mult4;
		}
		else if (i==5)
		{
			curSeq =S3NS1;
			curMult = Mult5;
		}
		else if (i==6)
		{
			curSeq =S5NS1;
			curMult = Mult6;
		} // end loop if
		i=i+1;
		
		while (h<=curMult)
		{
			j=j+1;
			Seq_x[j] = curSeq;
			h=h+1;
		}
	} // end while loop
	printf("loop[i]: %d\n", i_x);
	//% Shuffle
	i=1;
	while (i<=j)
	{
		//        printf("loop[i]: %d\n", i);
		shuffled_x = random(j);
		//%store random new location data in temp
		temp_x = Seq_x[shuffled_x];
		//%store i location in random new location
		Seq_x[shuffled_x] = Seq_x[i];
		//% store random new location in i location
		Seq_x[i] = temp_x;
		i=i+1;
	}	
	//%trial counter
	//ct= 1;
	print("Shuffled test 2");
	//% Seq
	nexttick;
		j=i-1;
	    i=0;
	    i_tt=0;

	   while (i<=j)
	   {
		// % determine the sequence to add
		if (Seq_x[i] ==1)
		{
			SeqLength = 2;        nNS=1;        nS =1;
		}
		else if (Seq_x[i] ==2)
		{
			SeqLength = 4;        nNS=3;        nS =1;
		}
		else if (Seq_x[i] ==3)
		{
			SeqLength = 6;        nNS=5;        nS =1;
		}
		else if (Seq_x[i] ==4)
		{
			SeqLength = 2;        nS =1;        nNS=1;
		}
		else if (Seq_x[i] ==5)
		{
			SeqLength = 4;        nS =3;        nNS=1;
		}
		else if (Seq_x[i] ==6)
		{
			SeqLength = 6;        nS =5;        nNS=1;
		}
		if (Seq_x[i]==1 | Seq_x[i]==2 | Seq_x[i]==3)
		 {
			kk=1;
			while (kk<=nNS)
			{
				Types_seq[ct] = 1;
				ct=ct+1;
				kk=kk+1;
			}	
			kk=1;
			while (kk<=nS)
			{
				Types_seq[ct] = 2;
				ct=ct+1;
				kk=kk+1;
			}
		 }	
		if (Seq_x[i]==4 | Seq_x[i]==5 | Seq_x[i]==6)
		 {
			kk=1;
			while(kk<=nS)
			{
				Types_seq[ct] = 2;
				ct=ct+1;
				kk=kk+1;
			}			
			kk=1;
			while (kk<=nNS)
			{
				Types_seq[ct] = 1;
				ct=ct+1;
				kk=kk+1;
			}
		 }	
		i=i+1;
		i_tt=i;
		nexttick;
		nTrials = ct;
		// nTrials and ct are used in process STIM to choose trial type (GO or NOGO)
		// when seq_flag ==1
	}//end while j loop Type
}	 // end seq_process

/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
process CLEAN_UP()
{
	READY_S=0;
	
	spawn CLEAR;
	waitforprocess CLEAR;
	
	spawn END_TRIAL;
	waitforprocess END_TRIAL;
	
	dsend("cl");
	print("-------------------------------------------\n");
	print("-------------------------------------------\n");
	print("########### STOP THE CURRENT TRIAL ########\n");
	print("-------------------------------------------\n");
	print("################ RESHUFFLING! #############\n");
	print("-------------------------------------------\n");
	print("-------------------------------------------\n");
	// Clear graph.
	
	if(TrialCount>1)
	{
		oSetAttribute(oF1, aINVISIBLE);            				 	 // Make invisible.
		oSetAttribute(oB1, aINVISIBLE);
		oSetAttribute(oB1x, aINVISIBLE);
	}
	
	oDestroy(oF);
	
	oSetGraph(gLeft, aCLEAR);
	
	spawn INITIALIZE;			 							 	 // Initialize animation and VideoSync objects.
	waitforprocess INITIALIZE;
	
	if(TrialCount>1)
	{
		oDestroy(oF1);					 							 // Destroy objects in the previous trial.
		oDestroy(oB1);
		oDestroy(oB1x);
	}
	//spawn WATCHEYE;			 								 	 // Monitor the eye coordinates.	
	//spawn TRIAL_LOOP;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
///                                       PROCESS WATCH TIME
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
process WATCH_TIME()
{
	int time_start;
	time_trials_start=time();
	//                        Predictive time Marker
	// marker 1 /     time_target_on = time_trials_start + hold_fixation_time;
	//MWL 6/12/06 commented out 2 lines below
	/// marker 2 /     time_stop_signal = time_trials_start + hold_fixation_time + rand_ssd;
	
	/// marker 3 /     time_reward = time_stop_signal	+ stop_fix_time;					//// 12/21 success for nogo trials
	
	
	if(types[j]==2)
	{
		if(Stimu[s]==1 || Stimu[s]==2)
		{
			if(STIM_MARKER==1)
			{
				while (time() < time_target_on + STIM_OFFSET)
				nexttick;
				if(!failed)
				{
					spawn ELECT_STIM;
					print("Stimulation time 1");
				}
			}
		}
	} // end types[j]=2	
}*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
///                                       PROCESS ELECTRIC STIM (send TTL to the pulsar)
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
process ELECT_STIM()
{
	print("uStim");
	spawn SendTTLToRemoteSystem(666);	//////// event code Stimulation on
	
	
	if (MultElectrodeStimFlag)
	{
		if (RandStimCh <50 )
		{
			spawn SendTTLToRemoteSystem(1);		 
			mio_dig_set(10,0);
			wait(2);
			mio_dig_set(10,1);
			sound(2000);
			wait(24);
			sound(0);
		}
		else
		{
			spawn SendTTLToRemoteSystem(2);
			mio_dig_set(11,0);
			wait(2);
			mio_dig_set(11,1);
			sound(3000);
			wait(24);
			sound(0);
		}
	}
	else
	{
		spawn SendTTLToRemoteSystem(1);
		mio_dig_set(10,0);
		wait(2);
		mio_dig_set(10,1);		
	}
	
	
	if(SOUND_FLAG==1)
	{
		sound(2000);
		wait(24);
		sound(0);
	}
	nexttick;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
///                                       PROCESS INIT_FIXATION_CHECK
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
process INIT_FIXATION_CHECK()
{	
	if(TrialCount>0 && step<1)
	{		
		oSetAttribute (oB1, aINVISIBLE);
		oSetGraph (gLeft, aCLEAR);		
		oSetAttribute (oB1x, aINVISIBLE);
		step=step+1;
	}	
	if (!fix_control )
	{	
		end_initfix_minT = time() + initfix_minT;
		while (time() < end_initfix_minT && In_Fixation_Window==0) /// && In_Fixation_Window==0	added 12/07/2005
			nexttick;
	}
	
	if (!In_Fixation_Window)
	{
		failed = ERR_LEAVE_FIX;
		in_init_fixation_window=fix_control;	 				 // If fix_control == 1, no init fixation needed
		// LastTrialOutcome=1;		
		if (fix_control == 0)
		{
			dsendf("co 7;");
			dsend("xm fix(0,0,7)");
			wait(initfix_punishtime);
			nexttick;
			
			spawn INIT_FIX_CORRECTOR;
			waitforprocess INIT_FIX_CORRECTOR;
			print("No initial fixation!");
		}
		else if (fix_control == 1)	// We don't need initial fixation.  Suspend the fixation corrector.
		{
			//print("fix control");
			in_init_fixation_window = 1;
			suspend INIT_FIX_CORRECTOR;
			suspend INIT_FIXATION_CHECK;
			print("No initial fixation needed.");			
		}
	}
	else
	{
		in_init_fixation_window = 1;		    // We don't need initial fixation.  Suspend the fixation corrector.
		spawn FIXATION_CORRECT; // MODIFIED 05-29-07 EEE... ADDED PROCESS "FIXATION_CORRECT" TO ACCOUNT FOR DRIFT OF INITIAL EYE POSITION ACROSS TRIALS
		suspend INIT_FIX_CORRECTOR;
		suspend INIT_FIXATION_CHECK; // added 12/07/2005
	}
}
/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
process INIT_FIX_CORRECTOR()
{
	int time_melanie;

	while(in_init_fixation_window == 0 && In_Fixation_Window==0)  /// && In_Fixation_Window==0	added 12/07/2005)
	{
		time_melanie = time() +  5000; //300;

		dsendf("co 7;");
		dsend("xm fix(0,0,3)");
		while (time() < time_melanie && In_Fixation_Window==0) /// && In_Fixation_Window==0	added 10/07/2005
		{
			nexttick;
		}
		//MWL
		//dsendf("co 0;");	   //this makes fix black...effectively turns off fix point
		//dsend("xm fix(0,0,3)");
		//wait(100);
		//nexttick;
		
		spawn INIT_FIXATION_CHECK;
		wait(initfix_punishtime);
	}

	if(in_init_fixation_window==1 || In_Fixation_Window==1)	   /// || In_Fixation_Window==1	added 12/07/2005)
	{
		suspend INIT_FIX_CORRECTOR;
		suspend INIT_FIXATION_CHECK;
	}
	nexttick;
}
/////////////////////////////////////////////////////////////////////////////////////
// MODIFIED 05-29-07 EEE
//		ADDED PROCESS "FIXATION_CORRECT" TO ACCOUNT FOR DRIFT OF INITIAL EYE POSITION
//		ACROSS TRIALS
// 		CHANGED SAMPLE TIME TO 2OO CYCLES
/////////////////////////////////////////////////////////////////////////////////////
process FIXATION_CORRECT()
{
	int fix_pos_H; //DECLARE ARRAY FOR FIX_POS_X & FIX_POS_y
	int fix_pos_V;
	int CT;	//DECLARE COUNTER (CT)
	float offset_x, offset_y; //DECLARE OFFSET_X OFFSET_Y

	CT=0;
	fix_pos_H=0; fix_pos_V=0;
	offset_x =0; offset_y =0;

	//WHILE IN FIXATION & CT <25
	while (In_Fixation_Window & CT<200)
	{
		fix_pos_H = fix_pos_H + atable(1); // ADD CURRENT EYE_POS_X TO FIX_POS_X
		fix_pos_V = fix_pos_V + (-atable(2));// ADD CURRENT EYE_POS_Y TO FIX_POS_Y
		CT = CT+1;// INCREMENT CT
		nexttick;//NEXTTICK
	}
	// GET AVERAGE EYE_X & AVERAGE EYE_Y
	if (CT==200)
	{
		offset_x = fix_pos_H /CT;
		offset_y = fix_pos_V /CT;
		H_OFFSET = -offset_x; // ZERO EYE POS USING AVERAGE EYE_X & AVERAGE EYE_Y
		V_OFFSET = -offset_y;
		spawn SendTTLToRemoteSystem(2302);
		nexttick;
	}
	else
	{
		CT=0;
		fix_pos_H=0;
		fix_pos_v=0;
	}
}// SUPPOSE EYE DRIFTS OUSIDE FIX WINDOW????


process KERNEL_HISTOGRAM
{
    declare Half_Kernel[88]= {1,1,2,3,4,4,5,5,5,6,6,6,6,7,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
    declare Kernel_Time[88];
    int ii;
    int jj;
    int ct;
    int kk;
    int reps;
    
    ii=0; ct=0;    
    while (ii<=870)
    {
    	Kernel_Time [ct] = ii; 
	ii =ii+10;
	ct=ct+1;
    }
  
    	ii=0; jj=0; ct=0; reps=0;
    	// initialize array
	while (ii<=87)
	{
        	reps = Half_Kernel[ii];	
        	while (jj<=reps-1)
		{			
            		arrHoldTimes[ct]= Kernel_Time[ii];
            		jj = jj+1;
            		ct=ct+1;
	    	}
		jj=0;
        	ii=ii+1;
		nexttick;
	}
}




//-----------------------------------------------------------------------
// PROCESS WaitForVideoSYNC - Wait for all commands to be executed by VideoSYNC.
//
//  The protocol uses WaitForVideoSYNC() like this:
//
//      dsend() or dsendf() ...         // Send one or more commands to VideoSYNC
//      spawnwait WaitForVideoSYNC;     // Wait for all commands to complete
//      ...
//      // At this point, all commands were executed by VideoSYNC.
//      
// We utilize the new (as of 24Jun03) RDX TTL feature where there are two TTL
// bits in each direction (VideoSYNC to server and server to VideoSYNC) that
// are now supported by the TEMPO server as well as VideoSYNC.  The two
// features we use are:
//
//      o VideoSYNC's SO command (which sets VideoSYNC's RDX TTL outputs)
//      o PCL's rdxGetTTLIN() and rdxSetTTLIN() functions, which get and
///       set the TEMPO server's RDX TTL outputs.
//
// In particular, we use the RDX TTL bits from VideoSYNC to the TEMPO server
// to have VideoSYNC tell us when it is finished executing all previously
// sent (via dsend/dsendf) commands.  We to this by telling VideoSYNC to set
// its RDX TTL output bits (by sending the SO VideoSYNC command) to a new value
// each time the WaitForVideoSYNC process is spawned.  We then watch the
// incoming RDX TTL bits until we see the value we expect.
//
// There are two enhancements that could be made to this process, which are left
// to the reader to implement.
//
// 1. Use only one TTL bit instead of 2.  This frees up one bit from VideoSYNC
//    to the TEMPO server for other uses by the protocol.
//
// 2. Add a timeout (in ms) argument that causes WaitForVideoSYNC to return
//    after so many milliseconds.  WaitForVideoSYNC would also set a global
//    variable indicating whether the wait was successful or, if no, what the
//    reason was.  Possible status codes are:
//
//          0. Success.  VideoSYNC executed the commands within the requested
//             timeframe.
//          1. timeout waiting for our transmit buffer to empty.  This
//             error indicates that VideoSYNC (or the RDX reader isn't
//             running)
//          2. timeout waiting for VideoSYNC to finish executing commands.
//             This indicates that either VideoSYNC is too slow to execute
//             the commands in the requested time or that the RDX receiver
//             hasn't implemented the SO command.

process WaitForVideoSYNC()
{
    int     newBits;                    // =0,1,2,3
    
    // WAIT FOR ALL PREVIOUS COMMAND TO GET SENT
    // This insures that we are in sync up to this point.
    
    while (dsend()) nexttick;
    
    // Now read the current TTL setting and advance by 1.
    // We are using both of RDX's TTL bits from VideoSYNC
    // to us.  But this is not necessary.  We could just
    // use one of the bits, leaving the other free for
    // other uses.

    newBits = (rdxGetTTLIN() + 1) % 4;  // Advance one MOD 4
    
    // Tell VideoSYNC to increment the sequence count
    // .. by setting its local OOB bits on the RDX link
    // We assume we are the only process sending the SO command.
    // If SO is sent by any other process, it will mess us up
    // and cause us to wait, possibly indefinitely, for our bits.
    
    dsendf("SO%d\n", newBits);

    // WAIT FOR VIDEOSYNC TO ACTUALLY EXECUTE THE SO COMMAND ABOVE.
    // When it does, it will set its "local" bits to newBits.
    // We will see that change here when we get the "remote" bits.

    while (rdxGetTTLIN() != newBits)    // Wait for the bits we expect
        nexttick;
	
	spawn SendTTLToRemoteSystem(999);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
///                                       PROCESS SENDING STROBE TO PLEXON
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
process SendTTLToRemoteSystem(int value)
{
	dioSetMode(REMOTE_TTL, PORTA|PORTB|PORTC);
	
	dioSetA(REMOTE_TTL, (value & 0xFF ));
	dioSetB(REMOTE_TTL, ((value / 256) & 0x7F) | 0x80); // load & strobe
	dioSetC(REMOTE_TTL, 0x01);
	
	spawn delay(200);
	waitforprocess Delay;
	
	dioSetA(REMOTE_TTL, (0x0 & 0xFF));
	dioSetB(REMOTE_TTL, (0x0 & 0x7F));
	dioSetC(REMOTE_TTL, 0x00);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
process Delay(int uSeconds)
{
	int start, duration;
	int ticks;
	
	ticks = uSeconds * 1.193180;     // Convert uSec to 1193180 Hz ticks
	start = timeus();
	duration = 0;
	while (duration < ticks)
	{
		duration = (timeus() - start) & 0xFFFF;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------
// Process xmitEvents() runs in the background and sends up to 5 event codes
// per process cycle to the remote system, drawing them from the xmit[] array.
// This process should be the last process in your protocol so that any
// preceeding process that adds an event code to the xmit[] will do so
// before xmitEvents() runs.

process xmitEvents() enabled        // This could also be spawned in your init() process
{
	int         ki;                  // # of codes sent this process cycle
	
	
	while (1)                           // We loop indefinitely..
	{
		ki = 0;
		while (ki < nEventsPerProcessCycle && get != put)    // Up to nEventsPerProcessCycle are sent..
		{
			spawn SendTTLToRemoteSystem(xmit[get]);  //toto // Send next code to Plexon
			waitforprocess SendTTLToRemoteSystem;     // Prudent but not necessary
			get = (get + 1) % nXMIT;            // Advance to next event code xmit[]
			ki = ki + 1;                          // Count one more code transmitted
		}
		nexttick;                       // ..Wait one process cycle
	}
}
///////////////////////////////////////////// C'EST FINI ///////////////////////////////////////////////////////////
/////////////////////////////////////////////DE JAM DONE/////////////////////////////////////////////