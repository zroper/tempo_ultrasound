// Global variables common to all tasks and some that are task-specific



declare hide int stateNoTask 	= 0;	// state 0 is 
declare hide int stateFIX = 1;	// gaze fixation task
declare hide int stateVIS = 2;	// visually guided saccade task
declare hide int stateAMP = 3;	// amplitude saccade task
declare hide int stateDEL = 4;	// delay saccade task
declare hide int stateMEM = 5;	// mem guided sacc
declare hide int stateCMD = 6;	// countermanding
declare hide int stateCCM = 7;	// choice countermanding
declare hide int stateGNG = 8;	// go/no-go saccade task
declare hide int stateMCM = 9;	// metacognition with masking decision task
declare hide int stateVWM = 10;	// metacognition with masking decision task


// Code all possible outcomes (for all tasks!)
declare hide int  trialOutcome, maskOutcome, betOutcome;
declare hide int  noFix			= 1;		// never attained fixation
declare hide int  brokeFix		= 2;		// attained and then lost fixation before target presentation
declare hide int  goIncorrect	= 3;		// never made saccade on a go trial (cmanding)
declare hide int  nogoCorrect	= 4;		// successfully canceled trial (cmanding)
declare hide int  saccOut		= 5;		// made an inaccurate saccade out of the target box
declare hide int  brokeTarg		= 6;		// didn't hold fixation at the target for long enough
declare hide int  goTarg		= 7;		// correct saccade on a go trial (cmanding)
declare hide int  nogoTarg		= 8;		// error noncanceled trial 
declare hide int  saccEarly		= 9;		// made a saccade before fixation offset
declare hide int  noSacc		= 10;		// didn't make a saccade after cued to do so (mem guided, reverse masking)
declare hide int  saccTarg		= 11;		// correct saccade (vis, del, mem, metacog)
declare hide int  bodyMove		= 12;		// error body movement (for training stillness)	
declare hide int  goDist		= 13;	// (choice countermanding): made a saccade to distractor on a go trial (=error)
declare hide int  nogoDist		= 14;	// (choice countermanding): made a saccade to distractor on a stop trial (=error)
declare hide int  checkerAbort	= 15;	// (choice countermanding): made a saccade to the checker stimulus (=abort)
declare hide int  brokeDist 	= 16;	// (choice countermanding): made a saccade to the checker stimulus (=abort)
declare hide int  saccDist		= 17;		// metacog masks
declare hide int  betAbort		= 18;		// metacog masks
declare hide int  brokeBet		= 19;		// metacog masks: did not hold bet target post-saccade fixation
declare hide int  highBet		= 20;		// metacog masks: did not hold bet target post-saccade fixation
declare hide int  lowBet		= 21;		// metacog masks: did not hold bet target post-saccade fixation
declare hide int  targHighBet	= 22;
declare hide int  distHighBet 	= 23;
declare hide int  targLowBet 	= 24;
declare hide int  distLowBet    = 25;

//VWM
declare hide int  hitCorSac     = 26;   //VWM correct identification of the test location (Hit&Correct localization)
declare hide int  hitIncSac     = 27;	//VWM misidentification of the test location (Hit & Incorrect localization)
declare hide int  cr            = 28;   //VWM correct rejection of the test item (CR)
declare hide int  miss          = 29;   //VWM failure of target recognition (Miss)
declare hide int  fa		    = 30;   //VWM false alarm (FA)
declare hide int  miscError     = 31;   //VWM eye went somewhere irrelevant...


//  Flags for keeping track of trial types	
declare hide int  goTrial 		= 0;			// 
declare hide int  stopTrial 	= 1;		// 
declare hide int  ignoreTrial 	= 2;			// 
declare hide int  nogoTrial 	= 3;			// 
declare hide int  tMaskTrial    = 4; 	// trial types for metacog suite of tasks
declare hide int  tBetTrial     = 5;
declare hide int  tRetroTrial   = 6;
declare hide int  tProTrial     = 7;



	
declare int		loadDefault = 1;			// a flag that determines whether DEFAULT.pro gets loaded when a protocol is loaded.
declare int		nTrial;
declare int		nTrialComplete;
declare int		Block_number;
declare int		nTrialArray[8];		// Keeps track of number of trials completed at each location
declare int 	nTrialPerTarget; 			// Gets set to stop the task after so nTrialPerTarget trials at each target
declare int		nTrialRemain; 				// Counts down to zero to end the task
declare int 	trialType;
declare int 	nObject;         // used to keep track of graph objects, so they can easily be destroyed in a while loop after exiting a task
	
declare int 	trl_running;  			// This variable makes the while loop work in each XXXTRIAL.pro file
declare int		success = 1;
declare int		failure = 0;
declare int		noChange = 2;


//----------------------------------------------------------------------------------------------------------------
// Trial type distributions (must sum to 100)
declare float	goPct;				// percentage of go trials
declare float	NogoPct;			// percentage of no-go trials
declare float	stopPct;			// percentage of stop trials
declare float	ignorePct;			// percentage of ignore trials

declare float	Bonus_weight;			// percentage of time that the subject is wrong but gets rewarded anyway.
declare float	Dealer_wins_weight;		// percentage of time that the subject is right but gets punished anyway.

declare float	BigR_weight;			// weights for random changes of reward targSize
declare float	MedR_weight;			// weights for random changes of reward targSize
declare float	SmlR_weight;			// weights for random changes of reward targSize
declare float	SmlP_weight;			// weights for random changes of punsiment targSize
declare float	MedP_weight;			// weights for random changes of punsiment targSize
declare float	BigP_weight;			// weights for random changes of punsiment targSize



//----------------------------------------------------------------------------------------------------------------
// Stimulus properties

// photodiode properties
declare hide float 	pdAmp;										
declare hide float	pdAngle;										
declare hide float 	opposite;										
declare hide float	adjacent;										
declare hide int   	open        = 0;		// used to draw squares either filled or open center								
declare hide int   	fill        = 1;										


declare float 	fixSize, fixAngle, fixAmp;        											
declare float 	targSize, targAngle, targAmp;        											
declare float 	distAngle, distAmp; 

declare int		Classic;				// emulates the old stop signal task
declare int		targColorArray[10,3];		// targColor of each target individually (see critique above)
declare int		stopColorArray[3];		// need to make this more finely adjustable for luminance matching
declare int		ignoreColorArray[3];	// need to make this more finely adjustable for luminance matching
declare int		fixColorArray[3];		// need to make this more finely adjustable for luminance matching
declare int		maskColorArray[3];		// need to make this more finely adjustable for luminance matching
declare int		highBetColorArray[3];		// need to make this more finely adjustable for luminance matching
declare int		lowBetColorArray[3];		// need to make this more finely adjustable for luminance matching
declare int		betFixColorArray[3];		// need to make this more finely adjustable for luminance matching
declare int		proFixColorArray[3];		// need to make this more finely adjustable for luminance matching
declare int   	targColor;								
declare int   	nogoColor;								
declare int 	fixColor 	= 255;				// used to send to VIDEOSYNC
declare int 	stopColor 	= 254;				// used to send to VIDEOSYNC
declare int 	ignoreColor 	= 253;				// used to send to VIDEOSYNC
declare int 	maskColor 	= 252;				// used to send to VIDEOSYNC
declare int 	highBetColor 	= 251;				// used to send to VIDEOSYNC
declare int 	lowBetColor 	= 250;				// used to send to VIDEOSYNC
declare int		betFixColor		= 249;
declare int		proFixColor 	= 248;
//VWM
declare int     redColor     = 247;
declare int     greenColor   = 246;
declare int     blueColor    = 245;
declare int     magentaColor = 244;
declare int     cyanColor    = 243;
declare int     yellowColor  = 242;
declare int     brownColor   = 241;
declare int     whiteColor   = 240;
declare int 	blackColor   = 239;//background
//

declare int		nTarg;					// number of target positions (need to calculate this based on user input)
declare float	sizeArray[9];			// targSize of each target individually (degrees)
declare float	angleArray[9];			// angle of each target individually (degrees)
declare float	ampDefault;	// distance of each target from center of screen individually (degrees)
declare float	ampArray[9];	// distance of each target from center of screen individually (degrees)

declare int		Set_Tones;				// sets up the tones to either high or low based on user input
declare int		Success_Tone_bigR;		// positive secondary reinforcer in Hz (large reward)
declare int		Success_Tone_medR;		// positive secondary reinforcer in Hz (medium reward)
declare int		Success_Tone_smlR;		// positive secondary reinforcer in Hz (small reward)		
declare int		Failure_Tone_smlP;		// negative secondary reinforcer in Hz (short timeout)
declare int		Failure_Tone_medP;		// negative secondary reinforcer in Hz (medium timeout)
declare int		Failure_Tone_bigP;		// negative secondary reinforcer in Hz (long timeout)
declare float	TargetSizeConversion; 	// For automatically setting the target targSize based on its eccentricity from fixation
declare int		AutoTargetSizeFlag;		// Sometimes want to set the target targSize automatically, sometimes themselves- this will allow option.
declare int		targDuration;			// For memory-guided saccades, sets the number of refreshes the target stays on before turing off


//----------------------------------------------------------------------------------------------------------------
// Amplitude task
declare float	trialAmp;			// The eccentricity of a trial in the amplitude task


//----------------------------------------------------------------------------------------------------------------
// Countermanding globals
declare int		ssd;
declare int		decideSSD = -1; 					// Set as a flag initially to alert the task that it's the first SSD of the session
declare int		decideIndex = -1; 					// Set as a flag initially to alert the task that it's the first SSD of the session
declare int		nIndex; 					// Set as a flag initially to alert the task that it's the first SSD of the session
declare int 	lastOutcome = 1;				// Global output used to staircase SSD
declare int 	randomAmpFlag;				// 0 if want same target eccentricity every trial, 1 if want it to vary across trials
declare int 	ampIndex;					//
declare int 	nTrialAmpSSD[4, 20], nSaccAmpSSD[4, 20];

//----------------------------------------------------------------------------------------------------------------
// Discriminatory (checkered) Stimulus properties 
declare int 	nCheckerColumn, nCheckerRow, nSquare;
declare float 	checkerAmp;
declare float 	checkerAngle;
declare float 	decideCheckerAngle;
declare int 	checkerTarg;
declare float 	iSquareSizePixels;
declare int 	nDiscriminate;					// number of possible discriminatory levels
declare float	maxDiscriminate;				// highest proportion of targColor 1 possible
declare float	minDiscriminate;				// lowest proportion of targColor 1 possible
declare float 	targetRightRate;  // Varied from .5 to bias one of the targets to appear more than the other
declare float 	fiftyPercentRate;  // For choice countermanding and go/no-go, used to determine how often to present trials with 50% coherence (even checker targColor proportions) RELATIVE TO THE OTHER PROPORTION TRIALS
									// For 7 levels of signal strength, fiftyPercentRate = 4/7 gives equal probability w.r.t other signal strengths, so use 4/7 as the factor


//----------------------------------------------------------------------------------------------------------------
// Choice countermanding 
declare float 	targ1PropArray[10];	  				// Checkered Stimulus properties
declare float 	trialDist[10], trialRate[10], trialRateBound[10];	  				// Trial distribution for the targ1PropArray, can be used to determine how often each trial is offered (trialRate)
declare int 	Targ2SquareColor[3], Targ1SquareColor[3];   // Checkered Stimulus properties
declare int 	checkerboardArray[100];  					// Checkered Stimulus properties
declare int 	nTrialPsySSD[15,15], nSaccPsySSD[15,15], nTarg1PsySSD[15,15];	// arrays to tally trial types 
declare int 	lastStopArray[15], decideSSDArray[15];   	// used to staircase SSDs indpendently in each discriminatory proportion
declare float 	targ1ExtraPct, targ2ExtraPct;
declare int 	checkerIsTarg;
declare float   checkerTargRate;
declare int 	distIndex;
declare int 	ccmDelayFlag;	 // logical used to determine whether to impose a delay (1) or not (0) before the cue to respond


//----------------------------------------------------------------------------------------------------------------
// psychometric function variables
declare float 	psyValue;			// The value of the discrimatory level (one of the values in the discriminatory stimulus array
declare int 	psyIndex;			// The index in the disciminatory stimulus array
declare int hide nTarg1Respond[10]; // To keep track of how many target 1 responses monkey makes


//----------------------------------------------------------------------------------------------------------------
// Go/No-go variables (go/no-go task)
declare float 	goPropArray[10];
declare float	goCheckerProp;
declare int 	NoGoSquareColor[3], GoSquareColor[3];
declare int 	proportionIndex;
declare int 	nPsy[10];
declare int 	nPsyRespond[10];

//----------------------------------------------------------------------------------------------------------------
declare float	fixWinSize;			// size of fixation window (degrees)
declare float	targWinSize;			// size of target window (degrees)
declare float	chkrWinSize;			// size of checker stimulus window (degrees) for choice countermanding
declare float	betWinSize;			// size of checker stimulus window (degrees) for choice countermanding


//----------------------------------------------------------------------------------------------------------------
// Task timing/reward/punishments paramaters (all times in ms unless otherwise specified)
declare int 	trialStartTime;
declare int		allowFixTime;		// subject has this long to acquire fixation before a new trial is initiated
declare int		expoJitterFlag;			// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int		expoJitterFlag_SOA;		// defines if exponential holdtime is used for fixation offset in mem guided sacc task
declare int		holdtimeMin;			// minimum time after fixation before target presentation
declare int		holdtimeMax;			// maximum time after fixation before target presentation
declare int		soaMin;				// minimum time from target onset to fixation offset (mem guided only)
declare int		soaMax;				// maximum time from target onset to fixation offset (mem guided only)
declare int 	soa;				// next trial time between target onset and fixation offset
declare int		saccTimeMax;		// subject has this long to saccade to the target
declare int		saccDurationMax;		// once the eyes leave fixation they must be in the target before this time is up
declare int		targHoldtime;			// after saccade subject must hold fixation at target for this long
declare int		nSSD;					// number of stop signal delays (need to calculate this myself)
declare int		ssdMax;				// longest SSD
declare int		ssdMin;				// shortest SSD
declare int		Staircase;				// do we select the next SSD based on a staircasing algorithm?
declare float	ssdArray[12];			// needs to be in refresh rate units
declare int		holdStopDuration;				// subject must hold fixation for this long on a stop trial to be deemed canceled
declare int		toneDuration;			// how long should the error and success tones be presented?
declare int		rewardDelay;			// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int		baseRewardDuration;		// how long will the juice solonoid remain open (monkeys are very interested in this varaible)
declare int		basePunishDuration;		// time out for messing up
declare int 	rewardDuration;			//GLOBAL OUTPUT FOR INFOS.pro will be set by END_TRL.pro
declare int 	punishDuration;				//GLOBAL OUTPUT FOR INFOS.pro will be set by END_TRL.pro
declare int 	toneChoiceSuccess;				//
declare int 	toneChoiceFailure;				//
declare int 	toneStopSuccess;				//
declare int 	toneStopFailure;				//
declare int 	toneAbort;				//
declare int 	toneTargHigh, toneTargLow, toneDistHigh, toneDistLow;				//
declare int		Bmove_tout;				// additive timeout imposed for each body movement
declare int		Move_ct;				// Output lets us know how many times the body has moved.
declare int		Max_move_ct;			// Setting maximum move_ct so monkey doesn't self-punish to eternity
declare int		TrainingStill;			// Indicates that we are using motion detector to train the monk to be still
declare int		Canc_alert;				// Alert operator that the monk has canceled a trial (during training)
declare int		fixedTrialDuration;		// 1 for fixed trial length, 0 for fixied inter trial intervals
declare int		trialDuration;			// fixed at this value (only works if fixedTrialDuration == 1) must figure out max time for this variable and include it in comments
declare int		interTrialDuration;			// how long between trials (only works if fixedTrialDuration == 0)




//----------------------------------------------------------------------------------------------------------------
// Metacognition with masking
declare float maskAmpArray[4], maskAngleArray[4], betAmpArray[2], betAngleArray[2];  // locations of targets, masks, bets
declare float maskSize, betSize;
declare int maskPct, betPct, retroPct, proPct;  		// percentage of each metacog trial type-- sum must add to 100
declare int nBet = 2; 										// number of bet targets
declare float highBetAngle, lowBetAngle, acceptBetAngle;
declare float highBetAmp, lowBetAmp;
declare float targetRightRate, highBetRightRate;
declare int soaArray[10];
declare int nSOA, decideSOA;
declare int lastMaskOutcome;							// used to staircase the soa if we want to
declare int lastMaskArray[4], decideSOAArray[4];		// for staircasing SOA at each target location
declare float fakeCorrectRate;



//----------------------------------------------------------------------------------------------------------------
// Metacognition with masking
declare int stimDuration = 2;

//----------------------------------------------------------------------------------------------------------------
// VWM task
declare int setSizeArray[12]; //define the setsize value for each condition
declare int sameDiffArray[12];// define the same or diff for each condition
declare int nTrialsArray[12];// define the number of trials for each condition
declare int condCounterArray[12];//keep track of the number of trials run for each condition

declare int vwmColorArray[9,3];
declare float vwmAngleArray[4];//original had 8

//for trial setup
//declare float LocArray[4];//original had 6
declare float LocArray[4];//original had 6
declare int ColorArray[7]; //refers to the color pallette

declare int memRefresh = 70; //mem duration has to be determined by the number of refresh cycle, 10 = 167 msec for 60hz monitor
declare int retDuration = 2000;
declare int fixDuration = 1000;
declare int saccadeInitiationDuration = 1000;
declare int testDuration = 600;
declare int testRefresh = 70; //70
declare int testHoldDuration = 1000;//400 1000
declare int nTrialsperCond = 20;
declare float testAmp = 0.0; //defines the amplitude of the test stimulus
declare int lorr = 0;

//performance monitoring
declare int vwm_performance[24];//first 4 corr_sac, next 4 inc_sac, next4 broke_targ, last 4 broke_fix
//declare int inc_sac[4];
//declare int broke_targ[4];
//declare int broke_fix[4];





