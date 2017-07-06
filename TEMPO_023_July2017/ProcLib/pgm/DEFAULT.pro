// This sets all of the user defined global variables.
// It is needed because of the loop structure which allows multiple tasks to run 
// from the same protocol.  If multiple protocols use the same variables, we may 
// run into problems if we don't specifically reset them at the beginning of each
// task change.
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011
// 11-2011: Integrated choice countermanding task. -pgm
// 11-2011: Integrated visually guided saccade task. -pgm
// 11-2011: Integrated amplitude saccade task. -pgm

declare DEFAULT();

process DEFAULT()
{



declare int i;
declare hide int r_, g_, b_;		
r_ = 0; g_ = 1; b_ = 2;	


// Once DEFAULT is run, don't run it again unless loadDefault gets set back to 1;
loadDefault = 0;
//----------------------------------------------------------------------------------------------------------------
// Task-specific rewards:
if (state == stateFIX ||
	state == stateVIS ||
	state == stateAMP)
	{
	baseRewardDuration = 40;
	}
else if (state == stateMEM)
	{
	baseRewardDuration = 55;
	}
else if (state == stateDEL)
	{
	baseRewardDuration = 55;
	}
else if (state == stateCMD)
	{
	baseRewardDuration = 60;
	}
else if (state == stateCCM)
	{
	baseRewardDuration = 70;
	}
else if (state == stateGNG)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
	{
	baseRewardDuration = 70;
	}
else if (state == stateMCM)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
	{
	baseRewardDuration = 60;
	}


//----------------------------------------------------------------------------------------------------------------
// Trial type distributions (MUST SUM TO 100)
if (state == stateCMD)
	{
	goPct				= 65.0;
	stopPct				= 35.0;
	ignorePct			= 0;
	}
else if (state == stateCCM)
	{
	goPct				= 57.0;
	stopPct				= 43;
	ignorePct			= 0;
	}
else if (state == stateGNG)
	{
	goPct				= 50.0;
	NogoPct				= 50.0;
	}

Bonus_weight			= 0.0;	// percentage of time that the subject is wrong but gets rewarded anyway.
Dealer_wins_weight		= 0.0;	// percentage of time that the subject is right but gets punished anyway.

BigR_weight				= 33.33;// weights for random changes of reward targSize
MedR_weight				= 33.34;// weights for random changes of reward targSize
SmlR_weight				= 33.33;// weights for random changes of reward targSize
SmlP_weight				= 33.33;// weights for random changes of punsiment targSize
MedP_weight				= 33.34;// weights for random changes of punsiment targSize
BigP_weight				= 33.33;// weights for random changes of punsiment targSize



//----------------------------------------------------------------------------------------------------------------
// Stimulus properties
// White iso luminant value is 35,33,27;
// Red iso luminant value is is 63,0,0;
// Green iso luminant value is 0,36,0;
// Blue iso luminant value is 0,0,59;
Classic					= 0;

stopColorArray[r_]		= 45;	
stopColorArray[g_]		= 45;	
stopColorArray[b_]		= 0;	

ignoreColorArray[r_]	= 0;	
ignoreColorArray[g_]	= 36;	
ignoreColorArray[b_]	= 0;	
				
fixColorArray[r_]		= 35;	
fixColorArray[g_]		= 33;	
fixColorArray[b_]		= 27;	

								
// targColorArray[0,r_]		= 35;	// targColor of each target individually
// targColorArray[0,g_]		= 33;	// targColor of each target individually
// targColorArray[0,b_]		= 27;	// targColor of each target individually
				
// targColorArray[1,r_]		= 35;
// targColorArray[1,g_]		= 33;
// targColorArray[1,b_]		= 27;
				
// targColorArray[2,r_]		= 35;
// targColorArray[2,g_]		= 33;
// targColorArray[2,b_]		= 27;
						
// targColorArray[3,r_]		= 35;
// targColorArray[3,g_]		= 33;
// targColorArray[3,b_]		= 27;
				
// targColorArray[4,r_]		= 35;
// targColorArray[4,g_]		= 33;
// targColorArray[4,b_]		= 27;
						
// targColorArray[5,r_]		= 35;
// targColorArray[5,g_]		= 33;
// targColorArray[5,b_]		= 27;
						
// targColorArray[6,r_]		= 35;
// targColorArray[6,g_]		= 33;
// targColorArray[6,b_]		= 27;
						
// targColorArray[7,r_]		= 35;
// targColorArray[7,g_]		= 33;
// targColorArray[7,b_]		= 27;

			
targColorArray[0,r_]		= 40;	// targColor of each target individually
targColorArray[0,g_]		= 40;	// targColor of each target individually
targColorArray[0,b_]		= 40;	// targColor of each target individually
				
targColorArray[1,r_]		= 40;
targColorArray[1,g_]		= 40;
targColorArray[1,b_]		= 40;
				
targColorArray[2,r_]		= 40;
targColorArray[2,g_]		= 40;
targColorArray[2,b_]		= 40;
						
targColorArray[3,r_]		= 40;
targColorArray[3,g_]		= 40;
targColorArray[3,b_]		= 40;
				
targColorArray[4,r_]		= 40;
targColorArray[4,g_]		= 40;
targColorArray[4,b_]		= 40;
						
targColorArray[5,r_]		= 40;
targColorArray[5,g_]		= 40;
targColorArray[5,b_]		= 40;
						
targColorArray[6,r_]		= 40;
targColorArray[6,g_]		= 40;
targColorArray[6,b_]		= 40;
						
targColorArray[7,r_]		= 40;
targColorArray[7,g_]		= 40;
targColorArray[7,b_]		= 40;

sizeArray[0]			= 0.7;	// targSize of each target individually (degrees)
sizeArray[1]			= 0.7;
sizeArray[2]			= 0;
sizeArray[3]			= 0;
sizeArray[4]			= 0;
sizeArray[5]			= 0;
sizeArray[6]			= 0;
sizeArray[7]			= 0;

angleArray[0]			= 0;	// angle of each target individually (degrees)
angleArray[1]			= 180;
angleArray[2]			= 90;
angleArray[3]			= 135;
angleArray[4]			= 180;
angleArray[5]			= -135;
angleArray[6]			= -90;
angleArray[7]			= -45;

ampDefault		= 13;
ampArray[0]	= ampDefault;	// distance of each target from center of screen individually (degrees)
ampArray[1]	= ampDefault;
ampArray[2]	= ampDefault;
ampArray[3]	= ampDefault;
ampArray[4]	= ampDefault;
ampArray[5]	= ampDefault;
ampArray[6]	= ampDefault;
ampArray[7]	= ampDefault;

fixSize			= .5;	// targSize of the fixatoin point (degrees)	
fixAmp			= 0;
fixAngle 		= 0;

Set_tones = 1;

Success_Tone_bigR		= 800;	// positive secondary reinforcer in Hz (large reward)
Success_Tone_medR		= 1600;	// positive secondary reinforcer in Hz (medium reward)
Success_Tone_smlR		= 3200;	// positive secondary reinforcer in Hz (small reward)		
Failure_Tone_smlP		= 100;	// negative secondary reinforcer in Hz (short timeout)
Failure_Tone_medP		= 200;	// negative secondary reinforcer in Hz (medium timeout)
Failure_Tone_bigP		= 400;	// negative secondary reinforcer in Hz (long timeout)	
toneChoiceSuccess		= 3200;
toneChoiceFailure		= 800;
toneStopSuccess			= 1600;
toneStopFailure			= 200;
toneAbort 				= 1000;
toneTargHigh 			= 3800;
toneTargLow 			= 2600;
toneDistHigh 			= 200;
toneDistLow 			= 1400;



nTrialPerTarget 		= 20;
nTrialRemain 			= 6000; // initialize this to a really high number for protocols that don't depend on trial numbers (it gets reset for protocols that do)

nTrialArray[0] 			= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
nTrialArray[1] 			= 0;
nTrialArray[2] 			= 0;
nTrialArray[3] 			= 0;
nTrialArray[4] 			= 0;
nTrialArray[5] 			= 0;
nTrialArray[6] 			= 0;
nTrialArray[7] 			= 0;

//----------------------------------------------------------------------------------------------------------------
// May want target targSize to depend on its eccentricity. Create a flag for that condition and a conversion factor
AutoTargetSizeFlag		= 0;	// Default is for the user to set the target targSize.
TargetSizeConversion 	= 0.1;	// 1 degree target targSize per 10 degrees eccentricity

//----------------------------------------------------------------------------------------------------------------
// Eye related variables
fixWinSize			= 4.0;	// targSize of fixation window (degrees)
targWinSize			= 10;	// targSize of target window (degrees)
// chkrWinSize			= 3.2; //round(iSquareSizePixels * nCheckerColumn / Deg2Pix_X);	// targSize of checkered stimulus window (degrees)
chkrWinSize			= 2.5; //round(iSquareSizePixels * nCheckerColumn / Deg2Pix_X);	// targSize of checkered stimulus window (degrees)
betWinSize 		= round(targWinSize * .9);


//----------------------------------------------------------------------------------------------------------------
// Task timing paramaters (all times in ms unless otherwise specified)
allowFixTime			= 2500;	// subject has this long to acquire fixation before a new trial is initiated
expoJitterFlag			= 1;	// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
expoJitterFlag_soa		= 0;	// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
holdtimeMin				= 500;  // minimum time after fixation before target presentation
holdtimeMax				= 1500; // maximum time after fixation before target presentation
soa 					= 0;    // reset this every time protocols get loaded so it's zero for protocols that don't use it
soaMin					= 1150; //500	// minimum time between target onset and fixation offset (mem guided only)
soaMax					= 1350;	//1200 // maximum time between target onset and fixation offset (mem guided only)
saccTimeMax				= 1000;	// subject has this long to saccade to the target
saccDurationMax			= 75;	// once the eyes leave fixation they must be in the target before this time is up
targHoldtime			= 400; 	// after saccade subject must hold fixation at target for this long
Staircase				= 1;	// do we select the next SSD based on a staircasing algorithm?


holdStopDuration		= 1000; //round(saccTimeMax * .8);	// subject must hold fixation for this long on a stop trial to be deemed canceled
toneDuration			= 150;	// how long should the error and success tones be presented?
rewardDelay				= 500;	// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
basePunishDuration		= 1100;	// medium time out for messing up (monkeys care less for this one)
Max_move_ct				= 5;	// for training to be still with a motion detector
Bmove_tout				= 1000;	// for training to be still with a motion detector
TrainingStill			= 0;	// Indicates that we are using motion detector to train the monk to be still
Canc_alert				= 0;	// Alert operator that the monk has canceled a trial (during training)
fixedTrialDuration		= 0;	// 1 for fixed trial length, 0 for fixed inter trial intervals




	//--------------------------------------------------------------------------------------------------------------------
// Fixation task
if (state == stateFIX)
	{
	loadDefault				= 1;    // set load default back to 1 for the other tasks
	nTarg				= 9;	// number of target positions (this is calculated below based on user input)

	targColorArray[0,r_]		= 35;	// targColor of each target individually
	targColorArray[0,g_]		= 33;	// targColor of each target individually
	targColorArray[0,b_]		= 27;	// targColor of each target individually
							  
	targColorArray[1,r_]		= 35;
	targColorArray[1,g_]		= 33;
	targColorArray[1,b_]		= 27;
							  
	targColorArray[2,r_]		= 35;
	targColorArray[2,g_]		= 33;
	targColorArray[2,b_]		= 27;
							  
	targColorArray[3,r_]		= 35;
	targColorArray[3,g_]		= 33;
	targColorArray[3,b_]		= 27;
							  
	targColorArray[4,r_]		= 35;
	targColorArray[4,g_]		= 33;
	targColorArray[4,b_]		= 27;
							  
	targColorArray[5,r_]		= 35;
	targColorArray[5,g_]		= 33;
	targColorArray[5,b_]		= 27;
							  
	targColorArray[6,r_]		= 35;
	targColorArray[6,g_]		= 33;
	targColorArray[6,b_]		= 27;
							  
	targColorArray[7,r_]		= 35;
	targColorArray[7,g_]		= 33;
	targColorArray[7,b_]		= 27;
	
	targColorArray[8,r_]		= 35;
	targColorArray[8,g_]		= 33;
	targColorArray[8,b_]		= 27;
	
	sizeArray[0]			= 0.5;	// targSize of each target individually (degrees)
	sizeArray[1]			= 0.5;
	sizeArray[2]			= 0.5;
	sizeArray[3]			= 0.5;
	sizeArray[4]			= 0.5;
	sizeArray[5]			= 0.5;
	sizeArray[6]			= 0.5;
	sizeArray[7]			= 0.5;
	sizeArray[8]			= 0.5;
	
	angleArray[0]			= 0;	// angle of each target individually (degrees)
	angleArray[1]			= 90;
	angleArray[2]			= -90;
	angleArray[3]			= 180;
	angleArray[4]			= 0;
	angleArray[5]			= 135;
	angleArray[6]			= 45;
	angleArray[7]			= -135;
	angleArray[8]			= -45;
	
	ampArray[0]	= 0.0;	// distance of each target from center of screen individually (degrees)
	ampArray[1]	= 11.0;
	ampArray[2]	= 11.0;
	ampArray[3]	= 11.0;
	ampArray[4]	= 11.0;
	ampArray[5]	= 15.6;
	ampArray[6]	= 15.6;
	ampArray[7]	= 15.6;
	ampArray[8]	= 15.6;
	
	fixWinSize			= 2.5;	// targSize of fixation window (degrees)
	targWinSize			= 0.0;	// targSize of target window (degrees)
	
	allowFixTime		= 1200;	// subject has this long to acquire fixation (or target fixation protocol) before a new trial is initiated
	saccTimeMax		= 800;	// subject has this long to saccade to the target
	targHoldtime			= 600; 	// after saccade subject must hold fixation at target for this long
	
	}




// AMPLITUDE TASK
if (state == stateAmp)
	{
	ampArray[0]		= 2.5; // amplitude of saccades to make during amplitude task
	ampArray[1]		= 5.0; 
	ampArray[2]		= 7.5; 
	ampArray[3]		= 10.0; 
	ampArray[4]		= 12.5; 
	ampArray[5]		= 15.0; 
	ampArray[6]		= 20.0; 
	ampArray[7]		= 25.0; 
	}












if (state == stateVIS ||
	state == stateAMP ||
	state == stateMEM ||
	state == stateCCM ||
	state == stateGNG ||
	state == stateMCM ||
	state == stateDEL)
	{
	fixedTrialDuration 	= 0;
	}
// else
	// {
	// fixedTrialDuration 	= 1;
	// }
trialDuration			= 2200; 	// fixed at this value (only works if fixedTrialDuration == 1) must figure out max time for this variable and include it in comments
interTrialDuration			= 1050;	// how long between trials (only works if fixedTrialDuration == 0)





// MEMORY/VISUAL/DELAYED SACCADE TASK SPECIFIC----------------------------------------------------------------------------
if (state == stateVIS)
	{	
	
	sizeArray[0]			= .5;	// targSize of each target individually (degrees)
	sizeArray[1]			= .5;
	sizeArray[2]			= .5;
	sizeArray[3]			= .5;
	sizeArray[4]			= .5;
	sizeArray[5]			= .5;
	sizeArray[6]			= .5;
	sizeArray[7]			= .5;
	
	angleArray[0]			= 0;	// angle of each target individually (degrees)
	angleArray[1]			= 45;
	angleArray[2]			= 90;
	angleArray[3]			= 135;
	angleArray[4]			= 180;
	angleArray[5]			= -135;
	angleArray[6]			= -90;
	angleArray[7]			= -45;
	
	}
	


// SIMPLE COUNTERMANDING TASK SPECIFIC----------------------------------------------------------------------------
if (state == stateCMD)
	{
	interTrialDuration			= 800;	// how long between trials (only works if fixedTrialDuration == 0)
	targHoldtime				= 400;
	
	targetRightRate = .5;
	
	ssdArray[0]				= 3;	// needs to be in vertical retrace units
	ssdArray[1]				= 6;
	ssdArray[2]				= 9;
	ssdArray[3]				= 12;
	ssdArray[4]				= 15;
	ssdArray[5]				= 18;
	ssdArray[6]				= 21;
	ssdArray[7]				= 24;
	ssdArray[8]				= 27;
	ssdArray[9]				= 30;
	ssdArray[10]			= 33;
	ssdArray[11]			= 36;
	
	
	ampArray[0]	= 5;	// If varying the eccentricity of the targets
	ampArray[1]	= 10;   // If want more eccentricities, add them here and increase the random number generator in SETTRIAL.pro
	ampArray[2]	= 15;
	ampArray[3]	= 20;
	
	lastStopArray[0]  		= success;   // initialize to "success", will staircase SSD based on these array data
	lastStopArray[1]  		= success;
	lastStopArray[2]  		= success;
	lastStopArray[3]  		= success;

	decideSSDArray[0] 		= -1;  // initialize to -1 (see decideSSD variable)
	decideSSDArray[1] 		= -1; 
	decideSSDArray[2] 		= -1; 
	decideSSDArray[3] 		= -1; 
	}






//----------------------------------------------------------------------------------------------------------------
// CHOICE_CM (choice countermanding) task

if (state == stateCCM)
	{
	holdtimeMin				= 500;  // minimum time after fixation before target presentation
	holdtimeMax				= 1200; // maximum time after fixation before target presentation

	nCheckerColumn = 10;
	nCheckerRow = nCheckerColumn;
	nSquare = nCheckerColumn * nCheckerRow;
	if (checkerIsTarg == 0)
		{
		checkerAmp = 4;
		checkerAngle = 90;
		}
	else if (checkerIsTarg == 1)
		{
		checkerAmp = ampDefault;
		checkerAngle 		= angleArray[0]; 
		checkerTargRate 	= .5;
		chkrWinSize 		= 0;
		}
		
	iSquareSizePixels = 2;
	targetRightRate = .5;
	fiftyPercentRate = .5; // How often to run 50% checkered stimulus RELATIVE TO ITS ALREADY RANDOM CHANCE AMONG THE OTHER TRIAL PROPORTIONS
	targ1ExtraPct = 0;  // Percent of theb base reward time to add for the right target
	targ2ExtraPct = 0; // and for the left target

	ssdArray[0]				= 6;	// needs to be in vertical retrace units
	ssdArray[1]				= 9;
	ssdArray[2]				= 12;
	ssdArray[3]				= 15;
	ssdArray[4]				= 18;
	ssdArray[5]				= 21;
	ssdArray[6]				= 24;
	ssdArray[7]				= 27;
	ssdArray[8]				= 30;
	ssdArray[9]				= 33;
	ssdArray[10]			= 0;
	ssdArray[11]			= 0;


	targ1PropArray[0] = .41;
	targ1PropArray[1] = .45;
	targ1PropArray[2] = .48;
	targ1PropArray[3] = .50;
	targ1PropArray[4] = .52;
	targ1PropArray[5] = 0.55;
	targ1PropArray[6] = 0.59;
	targ1PropArray[7] = 0.0;
	targ1PropArray[8] = 0.0;
	targ1PropArray[9] = 0.0;
	
	// targ1PropArray[0] = 0.35;
	// targ1PropArray[1] = 0.42;
	// targ1PropArray[2] = 0.47;
	// targ1PropArray[3] = 0.5;
	// targ1PropArray[4] = 0.53;
	// targ1PropArray[5] = 0.58;
	// targ1PropArray[6] = 0.65;
	// targ1PropArray[7] = 0.0;
	// targ1PropArray[8] = 0.0;
	// targ1PropArray[9] = 0.0;

	// targ1PropArray[0] = 0.0;
	// targ1PropArray[1] = 1.0;
	// targ1PropArray[2] = 0.0;
	// targ1PropArray[3] = 0.0;
	// targ1PropArray[4] = 0.0;
	// targ1PropArray[5] = 0.0;
	// targ1PropArray[6] = 0.0;
	// targ1PropArray[7] = 0.0;
	// targ1PropArray[8] = 0.0;
	// targ1PropArray[9] = 0.0;


	
	trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
	trialDist[1] = 1.0;
	trialDist[2] = 1.0;
	trialDist[3] = 1.0;
	trialDist[4] = 1.0;
	trialDist[5] = 1.0;
	trialDist[6] = 1.0;
	trialDist[7] = 0.0;
	trialDist[8] = 0.0;
	trialDist[9] = 0.0;
	

	// Red is Right
	// Targ1SquareColor[r_]		= 54;	
	// Targ1SquareColor[g_]		= 0;	
	// Targ1SquareColor[b_]		= 54;	
	
	// Targ2SquareColor[r_]	= 0;	
	// Targ2SquareColor[g_]	= 30;	
	// Targ2SquareColor[b_]	= 30;	

	// Blue is Right
	Targ1SquareColor[r_]		= 0;	
	Targ1SquareColor[g_]		= 30;	
	Targ1SquareColor[b_]		= 30;	
	
	Targ2SquareColor[r_]	= 54;	
	Targ2SquareColor[g_]	= 0;	
	Targ2SquareColor[b_]	= 54;	


	
	lastStopArray[0]  		= success;   // initialize to "success"
	lastStopArray[1]  		= success;
	lastStopArray[2]  		= success;
	lastStopArray[3]  		= success;
	lastStopArray[4]  		= success;
	lastStopArray[5]  		= success;
	lastStopArray[6]  		= success;
	lastStopArray[7]  		= success;
	lastStopArray[8]  		= success;
	lastStopArray[9]  		= success;
	
	decideSSDArray[0] 		= -1;  // initialize to -1 (see decideSSD variable)
	decideSSDArray[1] 		= -1; 
	decideSSDArray[2] 		= -1; 
	decideSSDArray[3] 		= -1; 
	decideSSDArray[4] 		= -1; 
	decideSSDArray[5] 		= -1; 
	decideSSDArray[6] 		= -1; 
	decideSSDArray[7] 		= -1; 
	decideSSDArray[8] 		= -1; 
	decideSSDArray[9] 		= -1; 

	soaMin					= 400; //500	// minimum time between checker onset and fixation offset (delay version)
	soaMax					= 1400;	//1200 // maximum time 

	}




// GO NO-GO SACCADE TASK SPECIFIC----------------------------------------------------------------------------
if (state == stateGNG)
	{
	staircase = 0;
	nCheckerColumn = 10;
	nCheckerRow = 10;
	nSquare = nCheckerColumn * nCheckerRow;
	checkerAmp = 0;
	checkerAngle = 90;	
	iSquareSizePixels = 1;
	
	targetRightRate = .5;
	fiftyPercentRate = .5; // How often to run 50% checkered stimulus RELATIVE TO ITS ALREADY RANDOM CHANCE AMONG THE OTHER TRIAL PROPORTIONS

	//----------------------------------------------------------------------------------------------------------------
	// Checkered stimulus properties for GONOGO.pro (go/no-go) task

	 // goPropArray[0] = 0;
	 // goPropArray[1] = 1;
	 // goPropArray[2] = 0;
	 // goPropArray[3] = 0;
	 // goPropArray[4] = 0;
	 // goPropArray[5] = 0;
	 // goPropArray[6] = 0;
	 // goPropArray[7] = 0;
	 // goPropArray[8] = 0.0;
	 // goPropArray[9] = 0.0;
	goPropArray[0] = 0.15;
	goPropArray[1] = 0.35;
	goPropArray[2] = 0.45;
	goPropArray[3] = 0.50;
	goPropArray[4] = 0.55;
	goPropArray[5] = 0.65;
	goPropArray[6] = 0.85;
	goPropArray[7] = 0.0;
	goPropArray[8] = 0.0;
	goPropArray[9] = 0.0;

	
	GoSquareColor[r_]		= 0;	
	GoSquareColor[g_]		= 55;	
	GoSquareColor[b_]		= 0;	
	
	NoGoSquareColor[r_]	= 72;	
	NoGoSquareColor[g_]	= 42;	
	NoGoSquareColor[b_]	= 0;	
	}







// METACOG SACCADE TASKS SPECIFIC----------------------------------------------------------------------------
if (state == stateMCM)
	{
	fixWinSize			= 4.0;	// targSize of fixation window (degrees)
	targWinSize			= 10;	// targSize of target window (degrees)

	// Trial type distributions (may want to mix up the proportions of eachtrial type)
	maskPct 			= 25;
	betPct				= 0;
	retroPct			= 75;
	proPct 				= 0;
	
	
	highBetRightRate 	= .5;				// proportion of trials when high bet target appears in right hemifield
	targetRightRate 	= .5;				// proportion of trials when high bet target appears in right hemifield
	fakeCorrectRate		= .5;
	
	maskAngleArray[0]	= -30;
	maskAngleArray[1]	= 30;
	maskAngleArray[2]	= 150;
	maskAngleArray[3]	= -150;

	maskAmpArray[0]	= ampDefault;
	maskAmpArray[1]	= ampDefault;
	maskAmpArray[2]	= ampDefault;
	maskAmpArray[3]	= ampDefault;

	maskSize 			= 1.5;
	betSize				= 1.5;
	targSize 			= .5;
	
	
	i = 0;
	while (i < 9)
		{
		// targColorArray[i, r_] = 8;			
		// targColorArray[i, g_] = 0;
		// targColorArray[i, b_] = 2;
		targColorArray[i, r_] = 12;			
		targColorArray[i, g_] = 0;
		targColorArray[i, b_] = 3;
		targColorArray[i, r_] = 9;			
		targColorArray[i, g_] = 0;
		targColorArray[i, b_] = 3;
		i = i + 1;
		}	

	maskColorArray[r_] = 40;			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	maskColorArray[g_] = 40;
	maskColorArray[b_] = 40;

	highBetColorArray[r_] = 50;			// Need to make these isoluminant
	highBetColorArray[g_] = 0;
	highBetColorArray[b_] = 0;

	lowBetColorArray[r_] = 0;		// Need to make these isoluminant
	lowBetColorArray[g_] = 0;
	lowBetColorArray[b_] = 100;

	betFixColorArray[r_] = 0;		// Need to make these isoluminant
	betFixColorArray[g_] = 40;
	betFixColorArray[b_] = 40;

	proFixColorArray[r_] = 40;		// Need to make these isoluminant
	proFixColorArray[g_] = 40;
	proFixColorArray[b_] = 0;

	staircase = 1;
	// soaArray[0]				= 1;	// in screen refresh units
	// soaArray[1]				= 2;
	// soaArray[2]				= 3;
	// soaArray[3]				= 4;
	// soaArray[4]				= 5;
	// soaArray[5]				= 6;
	// soaArray[6]				= 7;
	// soaArray[7]				= 8;
	// soaArray[8]				= 9;
	// soaArray[9]				= 10;
	soaArray[0]				= 3;	// in screen refresh units
	soaArray[1]				= 5;
	soaArray[2]				= 7;
	soaArray[3]				= 9;
	soaArray[4]				= 11;
	soaArray[5]				= 13;
	soaArray[6]				= 15;
	soaArray[7]				= 17;
	soaArray[8]				= 19;
	soaArray[9]				= 21;
	}
	






	
	
	
	
	
	
	

	
	
	
	
	
// ************************************************************************************
// ************************************************************************************
// BROCA
// ************************************************************************************
// ************************************************************************************
if(monkey == broca)
	{		
	
	// GENERAL ACROSS ALL TASKS---------------------------------------------------------------------------------------
	// distance from center of subjects eyeball to screen
	if(room == 28)
		{
		subjDist	= 475.0; 				
		}
	else if (room == 29)
		{
		subjDist	= 465.0;
		}
	// else if (room == 23)
		// {
		// }
		
	Set_tones = 1;
	
	// fixWinSize			= 4;
	// targWinSize			= 6;	
	
	// allowFixTime		= 1000;
	// saccTimeMax		= 1200;
	basePunishDuration		= 1100;
	
	// Task-specific rewards:
	if (state == stateFIX ||
		state == stateVIS ||
		state == stateAMP)
		{
		baseRewardDuration = 30;
		}
	else if (state == stateMEM)
		{
		baseRewardDuration = 40;
		}
	else if (state == stateDEL)
		{
		baseRewardDuration = 40;
		}
	else if (state == stateCMD)
		{
		baseRewardDuration = 50;
		}
	else if (state == stateCCM)
		{
		baseRewardDuration = 75;
		}
	else if (state == stateGNG)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
		{
		baseRewardDuration = 50;
		}
	else if (state == stateMCM)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
		{
		baseRewardDuration = 60;
		}

	
// MEMORY/VISUAL/DELAYED SACCADE TASK SPECIFIC----------------------------------------------------------------------------
if (state == stateMEM ||
	state == stateDEL)
	{	
	targDuration 			= 10;    // number of screen refreshes to wait before turning target off in memory-guided saccade task
	soaMin = 500;//500
	soaMax = 1500;//2000
	
	// sizeArray[0]			= .5;	// targSize of each target individually (degrees)
	// sizeArray[1]			= .5;
	// sizeArray[2]			= .5;
	// sizeArray[3]			= .5;
	// sizeArray[4]			= .5;
	// sizeArray[5]			= .5;
	// sizeArray[6]			= .5;
	// sizeArray[7]			= .5;
	
	// angleArray[0]			= 0;	// angle of each target individually (degrees)
	// angleArray[1]			= 45;
	// angleArray[2]			= 90;
	// angleArray[3]			= 135;
	// angleArray[4]			= 180;
	// angleArray[5]			= -135;
	// angleArray[6]			= -90;
	// angleArray[7]			= -45;
	
	
	sizeArray[0]			= .5;	// targSize of each target individually (degrees)
	sizeArray[1]			= .5;
	angleArray[0]			= 0;	// angle of each target individually (degrees)
	angleArray[1]			= 180;

	}
	//----------------------------------------------------------------------------------------------------------------
	// Trial type distributions (MUST SUM TO 100)
	if (state == stateCMD)
		{
		goPct				= 65.0;
		stopPct				= 35.0;
		ignorePct			= 0;
		}
	else if (state == stateCCM)
		{
		goPct				= 58.0;
		stopPct				= 42;
		// goPct				= 100;
		// stopPct				= 0;
		ignorePct			= 0;
		}
	else if (state == stateGNG)
		{
		goPct				= 50.0;
		NogoPct				= 50.0;
		}
	
	// STOP SIGNAL TASK SPECIFIC--------------------------------------------------------------------------------------
	if (state == stateCMD)
		{
		// goPct				= 25.0;
		// stopPct				= 50.0;
		// ignorePct			= 25.0;
		
		// stopColorArray[r_]		= 0;	
		// stopColorArray[g_]		= 36;	
		// stopColorArray[b_]		= 0;					
				
		// ignoreColorArray[r_]	= 63;	
		// ignoreColorArray[g_]	= 0;	
		// ignoreColorArray[b_]	= 0;
		
		ssdArray[0]				= 3;	// needs to be in vertical retrace units
		ssdArray[1]				= 6;
		ssdArray[2]				= 9;
		ssdArray[3]				= 12;
		ssdArray[4]				= 20;
		ssdArray[5]				= 23;
		ssdArray[6]				= 26;
		ssdArray[7]				= 29;
		ssdArray[8]				= 32;
		ssdArray[9]				= 35;
		ssdArray[10]			= 38;
		ssdArray[11]			= 41;
		}
		
		
	// MEMORY GUIDED SACCADE TASK SPECIFIC----------------------------------------------------------------------------
	// if (state == stateMEM)
		// {			
		// }
	
	// CHOICE COUNTERMANDING TASK SPECIFIC----------------------------------------------------------------------------
	if (state == stateCCM)
		{
		targetRightRate = .5;
		fiftyPercentRate = .8 * 4 / 7; // How often to run 50% checkered stimulus RELATIVE TO ITS ALREADY RANDOM CHANCE AMONG THE OTHER TRIAL PROPORTIONS
		targ1ExtraPct = 0;  // Percent of theb base reward time to add for the right target
		targ2ExtraPct = 0; // and for the left target
		checkerIsTarg = 0;
		basePunishDuration		= 1200;
		
		// ssdArray[0]				= 3;	// needs to be in vertical retrace units
		// ssdArray[1]				= 7;
		// ssdArray[2]				= 11;
		// ssdArray[3]				= 15;
		// ssdArray[4]				= 19;
		// ssdArray[5]				= 23;
		// ssdArray[6]				= 27;
		// ssdArray[7]				= 31;
		// ssdArray[8]				= 35;
		// ssdArray[9]				= 39;
		// ssdArray[10]			= 43;
		// ssdArray[11]			= 47;
		
		// ssdArray[0]				= 4;	// needs to be in vertical retrace units
		// ssdArray[1]				= 12;
		// ssdArray[2]				= 20;
		// ssdArray[3]				= 28;
		// ssdArray[4]				= 36;
		// ssdArray[5]				= 44;
		// ssdArray[6]				= 52;
		// ssdArray[7]				= 60;
		// ssdArray[8]				= 61;
		// ssdArray[9]				= 62;
		// ssdArray[10]			= 63;
		// ssdArray[11]			= 64;

		ssdArray[0]				= 7;	// needs to be in vertical retrace units
		ssdArray[1]				= 17;
		ssdArray[2]				= 27;
		ssdArray[3]				= 37;
		ssdArray[4]				= 47;
		ssdArray[5]				= 57;
		ssdArray[6]				= 0;
		ssdArray[7]				= 0;
		ssdArray[8]				= 0;
		ssdArray[9]				= 0;
		ssdArray[10]			= 0;
		ssdArray[11]			= 0;



		


		// targ1PropArray[0] = .43;
		// targ1PropArray[1] = .45;
		// targ1PropArray[2] = .47;
		// targ1PropArray[3] = .53;
		// targ1PropArray[4] = .55;
		// targ1PropArray[5] = .57;
		// targ1PropArray[6] = 0.0;
		// targ1PropArray[7] = 0.0;
		// targ1PropArray[8] = 0.0;
		// targ1PropArray[9] = 0.0;

		// targ1PropArray[0] = .35;
		// targ1PropArray[1] = .42;
		// targ1PropArray[2] = .47;
		// targ1PropArray[3] = .53;
		// targ1PropArray[4] = .58;
		// targ1PropArray[5] = .65;
		// targ1PropArray[6] = 0.0;
		// targ1PropArray[7] = 0.0;
		// targ1PropArray[8] = 0.0;
		// targ1PropArray[9] = 0.0;

		targ1PropArray[0] = .42;
		targ1PropArray[1] = .47;
		targ1PropArray[2] = .53;
		targ1PropArray[3] = .58;
		targ1PropArray[4] = 0.0;
		targ1PropArray[5] = 0.0;
		targ1PropArray[6] = 0.0;
		targ1PropArray[7] = 0.0;
		targ1PropArray[8] = 0.0;
		targ1PropArray[9] = 0.0;

		
		// trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		// trialDist[1] = 1.0;
		// trialDist[2] = 1.0;
		// trialDist[3] = 1.0;
		// trialDist[4] = 1.0;
		// trialDist[5] = 1.0;
		// trialDist[6] = 0.0;
		// trialDist[7] = 0.0;
		// trialDist[8] = 0.0;
		// trialDist[9] = 0.0;

		trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		trialDist[1] = 1.0;
		trialDist[2] = 1.0;
		trialDist[3] = 1.0;
		trialDist[4] = 0.0;
		trialDist[5] = 0.0;
		trialDist[6] = 0.0;
		trialDist[7] = 0.0;
		trialDist[8] = 0.0;
		trialDist[9] = 0.0;
		
		// trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		// trialDist[1] = 1.0;
		// trialDist[2] = 0;
		// trialDist[3] = 0;
		// trialDist[4] = 0;
		// trialDist[5] = 0;
		// trialDist[6] = 0.0;
		// trialDist[7] = 0.0;
		// trialDist[8] = 0.0;
		// trialDist[9] = 0.0;

	// Red is Right
		Targ1SquareColor[r_]		= 54;	// Isoluminant cyan/magenta at 30 cd/m^2  (29.7 to be more precise)
		Targ1SquareColor[g_]		= 0;	
		Targ1SquareColor[b_]		= 54;	
		
		Targ2SquareColor[r_]	= 0;	
		Targ2SquareColor[g_]	= 31;	
		Targ2SquareColor[b_]	= 31;	


		// Red is Right
		// Targ1SquareColor[r_]		= 20;	// Isoluminant cyan/magenta at 12 cd/m^2 
		// Targ1SquareColor[g_]		= 0;	
		// Targ1SquareColor[b_]		= 20;	
		
		// Targ2SquareColor[r_]	= 0;	
		// Targ2SquareColor[g_]	= 12;	
		// Targ2SquareColor[b_]	= 12;	

		// Red is Right: Further reduce discriminability by reducing pure cynan/magenta composition of each checker:
		// red goes 19 - 0, green goes 0 - 12, blue goes 12 to 12... assume 20 steps from min to max
		// isoluminant at 13 cd/m^2
		// Targ1SquareColor[r_]		= 20;	// full red
		// Targ1SquareColor[g_]		= 8;	// green * 13steps / 20 = 7.8
		// Targ1SquareColor[b_]		= 12;	// full blue 
		
		// Targ2SquareColor[r_]	= 7;	// red * 7steps / 20 = 6.7
		// Targ2SquareColor[g_]	= 12;	// full green 
		// Targ2SquareColor[b_]	= 12;	// full blue
		
		soaMin = 400;
		soaMax = 1000;
		
		}

	}   // BROCA Section
	
	
	
	
	
		
	
	
	
	
	
// ************************************************************************************
// ************************************************************************************
// CAJAL
// ************************************************************************************
// ************************************************************************************
if(monkey == cajal)
	{		
	
	fixwinsize =4;
	
	// allowFixTime		= 1000;
	// saccTimeMax		= 1200;
holdtimeMin				= 500;  // minimum time after fixation before target presentation
holdtimeMax				= 1500; // maximum time after fixation before target presentation
	basePunishDuration		= 1100;
	
	// Task-specific rewards:
	if (state == stateFIX ||
		state == stateVIS ||
		state == stateAMP)
		{
		baseRewardDuration = 40;
		}
	else if (state == stateMEM)
		{
		baseRewardDuration = 55;
		}
	else if (state == stateDEL)
		{
		baseRewardDuration = 55;
		}
	else if (state == stateCMD)
		{
		baseRewardDuration = 80;
		}
	else if (state == stateCCM)
		{
		baseRewardDuration = 100;
		}
	else if (state == stateGNG)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
		{
		baseRewardDuration = 80;
		}
	else if (state == stateMCM)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
		{
		baseRewardDuration = 80;
		}

	

	// MEMORY/VISUAL/DELAYED SACCADE TASK SPECIFIC----------------------------------------------------------------------------
	if (state == stateMEM ||
		state == stateDEL)
		{	
		targDuration 			= 10;    // number of screen refreshes to wait before turning target off in memory-guided saccade task
		soaMin = 500;//500
		soaMax = 1500;//2000
		
		sizeArray[0]			= .5;	// targSize of each target individually (degrees)
		sizeArray[1]			= .5;
		sizeArray[2]			= .5;
		sizeArray[3]			= .5;
		sizeArray[4]			= .5;
		sizeArray[5]			= .5;
		sizeArray[6]			= .5;
		sizeArray[7]			= .5;
		
		angleArray[0]			= 0;	// angle of each target individually (degrees)
		angleArray[1]			= 45;
		angleArray[2]			= 90;
		angleArray[3]			= 135;
		angleArray[4]			= 180;
		angleArray[5]			= -135;
		angleArray[6]			= -90;
		angleArray[7]			= -45;
		
		// sizeArray[0]			= .5;	// targSize of each target individually (degrees)
		// sizeArray[1]			= .5;
		// angleArray[0]			= 0;	// angle of each target individually (degrees)
		// angleArray[1]			= 180;

		}
		

	if (state == stateMEM)
		{
		targwinSize = 9;
		}

		
		
		
	// CHOICE COUNTERMANDING TASK SPECIFIC----------------------------------------------------------------------------
	if (state == stateCCM)
		{
		checkerAmp = 4;

		targetRightRate = .5;
		fiftyPercentRate = .8 * 4 / 7; // How often to run 50% checkered stimulus RELATIVE TO ITS ALREADY RANDOM CHANCE AMONG THE OTHER TRIAL PROPORTIONS
		targ1ExtraPct = 0;  // Percent of theb base reward time to add for the right target
		targ2ExtraPct = 0; // and for the left target
		checkerIsTarg = 0;
		basePunishDuration		= 700;
		
		// ssdArray[0]				= 3;	// needs to be in vertical retrace units
		// ssdArray[1]				= 7;
		// ssdArray[2]				= 11;
		// ssdArray[3]				= 15;
		// ssdArray[4]				= 19;
		// ssdArray[5]				= 23;
		// ssdArray[6]				= 27;
		// ssdArray[7]				= 31;
		// ssdArray[8]				= 35;
		// ssdArray[9]				= 39;
		// ssdArray[10]			= 43;
		// ssdArray[11]			= 47;
		

		ssdArray[0]				= 7;	// needs to be in vertical retrace units
		ssdArray[1]				= 17;
		ssdArray[2]				= 27;
		ssdArray[3]				= 37;
		ssdArray[4]				= 47;
		ssdArray[5]				= 0;
		ssdArray[6]				= 0;
		ssdArray[7]				= 0;
		ssdArray[8]				= 0;
		ssdArray[9]				= 0;
		ssdArray[10]			= 0;
		ssdArray[11]			= 0;


		// targ1PropArray[0] = 0.40;
		// targ1PropArray[1] = .43;
		// targ1PropArray[2] = .47;
		// targ1PropArray[3] = .53;
		// targ1PropArray[4] = 0.57;
		// targ1PropArray[5] = 0.60;
		// targ1PropArray[6] = 0.0;
		// targ1PropArray[7] = 0.0;
		// targ1PropArray[8] = 0.0;
		// targ1PropArray[9] = 0.0;

		// targ1PropArray[0] = 0.1;
		// targ1PropArray[1] = .3;
		// targ1PropArray[2] = .7;
		// targ1PropArray[3] = .9;
		// targ1PropArray[4] = 0.0;
		// targ1PropArray[5] = 0.0;
		// targ1PropArray[6] = 0.0;
		// targ1PropArray[7] = 0.0;
		// targ1PropArray[8] = 0.0;
		// targ1PropArray[9] = 0.0;

		targ1PropArray[0] = 0.1;
		targ1PropArray[1] = .9;
		targ1PropArray[2] = 0;
		targ1PropArray[3] = 0;
		targ1PropArray[4] = 0.0;
		targ1PropArray[5] = 0.0;
		targ1PropArray[6] = 0.0;
		targ1PropArray[7] = 0.0;
		targ1PropArray[8] = 0.0;
		targ1PropArray[9] = 0.0;

		
		// trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		// trialDist[1] = 1.2;
		// trialDist[2] = 1.4;
		// trialDist[3] = 1.4;
		// trialDist[4] = 1.2;
		// trialDist[5] = 1.0;
		// trialDist[6] = 0.0;
		// trialDist[7] = 0.0;
		// trialDist[8] = 0.0;
		// trialDist[9] = 0.0;

		// trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		// trialDist[1] = 1.2;
		// trialDist[2] = 1.2;
		// trialDist[3] = 1.0;
		// trialDist[4] = 0.0;
		// trialDist[5] = 0.0;
		// trialDist[6] = 0.0;
		// trialDist[7] = 0.0;
		// trialDist[8] = 0.0;
		// trialDist[9] = 0.0;

		trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		trialDist[1] = 1.0;
		trialDist[2] = 0;
		trialDist[3] = 0;
		trialDist[4] = 0.0;
		trialDist[5] = 0.0;
		trialDist[6] = 0.0;
		trialDist[7] = 0.0;
		trialDist[8] = 0.0;
		trialDist[9] = 0.0;


		
		// Right is for Right target		
		Targ1SquareColor[r_]	= 43;	
		Targ1SquareColor[g_]	= 18;	
		Targ1SquareColor[b_]	= 27;	

		Targ2SquareColor[r_]		= 11;
		Targ2SquareColor[g_]		= 18;	
		Targ2SquareColor[b_]		= 18;	

		soaMin = 400;
		soaMax = 1000;

		}

		
	// Task-specific rewards:
	if (state == stateVWM)
		{
		
		allowFixTime = 3000;
		fixwinsize = 5;
		targwinsize = 8;
		baseRewardDuration = 100;
		nTrialPerTarget 		= 20;
		nTrialRemain 			= 6000; // initialize this to a really high number for protocols that don't depend on trial numbers (it gets reset for protocols that do)

		//setsize setup
		setSizeArray[0] 			= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[1] 			= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[2] 			= 2;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[3] 			= 2;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[4] 			= 3;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[5] 			= 3;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[6] 			= 4;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[7] 			= 4;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[8] 			= 5;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[9] 			= 5;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[10] 			= 6;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[11] 			= 6;   // These get reset to zero each time so new tasks start at zero trials per location.

		//samediff set up!
		sameDiffArray[0] 				= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		sameDiffArray[1] 				= 2;
		sameDiffArray[2] 				= 1;
		sameDiffArray[3] 				= 2;
		sameDiffArray[4] 				= 1;
		sameDiffArray[5] 				= 2;
		sameDiffArray[6] 				= 1;
		sameDiffArray[7] 				= 2;
		sameDiffArray[8] 				= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		sameDiffArray[9] 				= 2;
		sameDiffArray[10] 			= 1;
		sameDiffArray[11] 			= 2;		
		
		
		//counter set up!
		nTrialsArray[0] 				= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		nTrialsArray[1] 				= 0;
		nTrialsArray[2] 				= 0;
		nTrialsArray[3] 				= 0;
		nTrialsArray[4] 				= 0;
		nTrialsArray[5] 				= 0;
		nTrialsArray[6] 				= 0;
		nTrialsArray[7] 				= 0;
		nTrialsArray[8] 				= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		nTrialsArray[9] 				= 0;
		nTrialsArray[10] 			= 0;
		nTrialsArray[11] 			= 0;	
		//COLOR set up! [r,g,bl,m,w,cy,br,yl,bk]
		vwmColorArray[0,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[0,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[0,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[1,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[1,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[1,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[2,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[2,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[2,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[3,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[3,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[3,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[4,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[4,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[4,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[5,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[5,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[5,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[6,r_] 		= 42;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[6,g_] 		= 21;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[6,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[7,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[7,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
	    vwmColorArray[7,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[8,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[8,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
	    vwmColorArray[8,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmAngleArray[0]			= 225.0;//45.0	// 0// angle of each target individually (degrees)
		vwmAngleArray[1]			= 315.0;//135.0   //45
		vwmAngleArray[2]			= 225.0;   //90
		vwmAngleArray[3]			= 315.0;  //135
		// vwmAngleArray[4]			= 0;  //180
		// vwmAngleArray[5]			= 0; //-135
		// vwmAngleArray[6]			= 0;  //-90
		// vwmAngleArray[7]			= 0;  //-45
		
		//original 8locs
		// vwmAngleArray[0]			= 22.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 112.5;   //90
		// vwmAngleArray[3]			= 157.5;  //135
		// vwmAngleArray[4]			= -157.5;  //180
		// vwmAngleArray[5]			= -112.5; //-135
		// vwmAngleArray[6]			= -67.5;  //-90
		// vwmAngleArray[7]			= -22.5;  //-45
		
		// vwmAngleArray[0]			= 67.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 67.5;   //90
		// vwmAngleArray[3]			= 67.5;  //135
		// vwmAngleArray[4]			= 67.5;  //180
		// vwmAngleArray[5]			= 22.5; //-135
		// vwmAngleArray[6]			= 67.5;  //-90
		// vwmAngleArray[7]			= 157.5;  //-45
		
		// vwmAngleArray[0]			= 22.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 67.5;   //90
		// vwmAngleArray[3]			= 67.5;  //135
		// vwmAngleArray[4]			= -157.5;  //180
		// vwmAngleArray[5]			= -112.5; //-135
		// vwmAngleArray[6]			= -112.5;  //-90
		// vwmAngleArray[7]			= -112.5;  //-45
		
		// vwmAngleArray[0]			= 67.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 67.5;   //90
		// vwmAngleArray[3]			= 67.5;  //135
		// vwmAngleArray[4]			= -112.5;  //180
		// vwmAngleArray[5]			= -112.5; //-135
		// vwmAngleArray[6]			= -112.5;  //-90
		// vwmAngleArray[7]			= -112.5;  //-45
		
		// vwmAngleArray[0]			= 90;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 90;   //45
		// vwmAngleArray[2]			= 90;   //90
		// vwmAngleArray[3]			= 90;  //135
		// vwmAngleArray[4]			= 90;  //180
		// vwmAngleArray[5]			= 90; //-135
		// vwmAngleArray[6]			= 90;  //-90
		// vwmAngleArray[7]			= 90;  //-45
		
		// vwmAngleArray[0]			= 0;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 45;   //45
		// vwmAngleArray[2]			= 90;   //90
		// vwmAngleArray[3]			= 135;  //135
		// vwmAngleArray[4]			= 180;  //180
		// vwmAngleArray[5]			= -135; //-135
		// vwmAngleArray[6]			= -90;  //-90
		// vwmAngleArray[7]			= -45;  //-45
		
		//for removing rightward bias...
		// vwmAngleArray[0]			= 90;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 45;   //45
		// vwmAngleArray[2]			= 0;   //90
		// vwmAngleArray[3]			= -45;  //135
		// vwmAngleArray[4]			= -90;  //180
		// vwmAngleArray[5]			= -45; //-135
		// vwmAngleArray[6]			= 0;  //-90
		// vwmAngleArray[7]			= 45;  //-45
	
		
		}
		}
// ************************************************************************************
// ************************************************************************************
// EULER
// ************************************************************************************
// ************************************************************************************
if(monkey == euler)
	{		
	
	fixwinsize =4;
	
	// allowFixTime		= 1000;
	// saccTimeMax		= 1200;
holdtimeMin				= 500;  // minimum time after fixation before target presentation
holdtimeMax				= 1500; // maximum time after fixation before target presentation
	basePunishDuration		= 1100;
	
	// Task-specific rewards:
	if (state == stateFIX ||
		state == stateVIS ||
		state == stateAMP)
		{
		baseRewardDuration = 40;
		}
	else if (state == stateMEM)
		{
		baseRewardDuration = 55;
		}
	else if (state == stateDEL)
		{
		baseRewardDuration = 55;
		}
	else if (state == stateCMD)
		{
		baseRewardDuration = 80;
		}
	else if (state == stateCCM)
		{
		baseRewardDuration = 100;
		}
	else if (state == stateGNG)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
		{
		baseRewardDuration = 80;
		}
	else if (state == stateMCM)    // monkey can complete these trials quicker, so they should earn less reward per trial (than countermanding or choice countermanding)
		{
		baseRewardDuration = 80;
		}

	

	// MEMORY/VISUAL/DELAYED SACCADE TASK SPECIFIC----------------------------------------------------------------------------
	if (state == stateMEM ||
		state == stateDEL)
		{	
		targDuration 			= 10;    // number of screen refreshes to wait before turning target off in memory-guided saccade task
		soaMin = 3000;//500
		soaMax = 4000;//2000
		
		sizeArray[0]			= .5;	// targSize of each target individually (degrees)
		sizeArray[1]			= .5;
		sizeArray[2]			= .5;
		sizeArray[3]			= .5;
		sizeArray[4]			= .5;
		sizeArray[5]			= .5;
		sizeArray[6]			= .5;
		sizeArray[7]			= .5;
		
		angleArray[0]			= 0;	// angle of each target individually (degrees)
		angleArray[1]			= 45;
		angleArray[2]			= 90;
		angleArray[3]			= 135;
		angleArray[4]			= 180;
		angleArray[5]			= -135;
		angleArray[6]			= -90;
		angleArray[7]			= -45;
		
		// sizeArray[0]			= .5;	// targSize of each target individually (degrees)
		// sizeArray[1]			= .5;
		// angleArray[0]			= 0;	// angle of each target individually (degrees)
		// angleArray[1]			= 180;

		}
		

	if (state == stateMEM)
		{
		targwinSize = 9;
		}

		
		
		
	// CHOICE COUNTERMANDING TASK SPECIFIC----------------------------------------------------------------------------
	if (state == stateCCM)
		{
		checkerAmp = 0; //6;
		chkrWinSize			= 0; //2.5; //round(iSquareSizePixels * nCheckerColumn / Deg2Pix_X);	// targSize of checkered stimulus window (degrees)

		stopPct				= 0;
		goPct				= 100 - stopPct;

	targetRightRate = .5;
		fiftyPercentRate = .8 * 4 / 7; // How often to run 50% checkered stimulus RELATIVE TO ITS ALREADY RANDOM CHANCE AMONG THE OTHER TRIAL PROPORTIONS
		targ1ExtraPct = 0;  // Percent of theb base reward time to add for the right target
		targ2ExtraPct = 0; // and for the left target
		checkerIsTarg = 0;
		basePunishDuration		= 700;
		
		// ssdArray[0]				= 3;	// needs to be in vertical retrace units
		// ssdArray[1]				= 7;
		// ssdArray[2]				= 11;
		// ssdArray[3]				= 15;
		// ssdArray[4]				= 19;
		// ssdArray[5]				= 23;
		// ssdArray[6]				= 27;
		// ssdArray[7]				= 31;
		// ssdArray[8]				= 35;
		// ssdArray[9]				= 39;
		// ssdArray[10]			= 43;
		// ssdArray[11]			= 47;
		

		ssdArray[0]				= 7;	// needs to be in vertical retrace units
		ssdArray[1]				= 17;
		ssdArray[2]				= 27;
		ssdArray[3]				= 37;
		ssdArray[4]				= 47;
		ssdArray[5]				= 0;
		ssdArray[6]				= 0;
		ssdArray[7]				= 0;
		ssdArray[8]				= 0;
		ssdArray[9]				= 0;
		ssdArray[10]			= 0;
		ssdArray[11]			= 0;


		// targ1PropArray[0] = 0.40;
		// targ1PropArray[1] = .43;
		// targ1PropArray[2] = .47;
		// targ1PropArray[3] = .53;
		// targ1PropArray[4] = 0.57;
		// targ1PropArray[5] = 0.60;
		// targ1PropArray[6] = 0.0;
		// targ1PropArray[7] = 0.0;
		// targ1PropArray[8] = 0.0;
		// targ1PropArray[9] = 0.0;

		// targ1PropArray[0] = 0.1;
		// targ1PropArray[1] = .3;
		// targ1PropArray[2] = .42;
		// targ1PropArray[3] = .58;
		// targ1PropArray[4] = 0.7;
		// targ1PropArray[5] = 0.9;
		// targ1PropArray[6] = 0.0;
		// targ1PropArray[7] = 0.0;
		// targ1PropArray[8] = 0.0;
		// targ1PropArray[9] = 0.0;

		targ1PropArray[0] = 0.0;
		targ1PropArray[1] = 1.0;
		targ1PropArray[2] = 0;
		targ1PropArray[3] = 0;
		targ1PropArray[4] = 0.0;
		targ1PropArray[5] = 0.0;
		targ1PropArray[6] = 0.0;
		targ1PropArray[7] = 0.0;
		targ1PropArray[8] = 0.0;
		targ1PropArray[9] = 0.0;

		
		// trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		// trialDist[1] = 1.2;
		// trialDist[2] = 1.4;
		// trialDist[3] = 1.4;
		// trialDist[4] = 1.2;
		// trialDist[5] = 1.0;
		// trialDist[6] = 0.0;
		// trialDist[7] = 0.0;
		// trialDist[8] = 0.0;
		// trialDist[9] = 0.0;

		// trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		// trialDist[1] = 1.2;
		// trialDist[2] = 1.2;
		// trialDist[3] = 1.0;
		// trialDist[4] = 0.0;
		// trialDist[5] = 0.0;
		// trialDist[6] = 0.0;
		// trialDist[7] = 0.0;
		// trialDist[8] = 0.0;
		// trialDist[9] = 0.0;

		trialDist[0] = 1.0; 	// Set these values relative to 1.0 to determine the relative rate of each trial type
		trialDist[1] = 1.0;
		trialDist[2] = 0.0;
		trialDist[3] = 0.0;
		trialDist[4] = 0.0;
		trialDist[5] = 0.0;
		trialDist[6] = 0.0;
		trialDist[7] = 0.0;
		trialDist[8] = 0.0;
		trialDist[9] = 0.0;


		
		// Blue is for Right target		
		Targ1SquareColor[r_]	= 11;	
		Targ1SquareColor[g_]	= 18;	
		Targ1SquareColor[b_]	= 18;	

		Targ2SquareColor[r_]		= 45;
		Targ2SquareColor[g_]		= 18;	
		Targ2SquareColor[b_]		= 27;	
		
		Targ1SquareColor[r_]	= 16.5;	
		Targ1SquareColor[g_]	= 27;	
		Targ1SquareColor[b_]	= 27;	

		Targ2SquareColor[r_]		= 67.5;
		Targ2SquareColor[g_]		= 27;	
		Targ2SquareColor[b_]		= 40.5;	


		// Targ1SquareColor[r_]	= 18;	
		// Targ1SquareColor[g_]	= 20;	
		// Targ1SquareColor[b_]	= 20;	

		// Targ2SquareColor[r_]		= 80;
		// Targ2SquareColor[g_]		= 28;	
		// Targ2SquareColor[b_]		= 40;	

		soaMin = 400;
		soaMax = 1000;

		}

		
	// Task-specific rewards:
	if (state == stateVWM)
		{
		
		allowFixTime = 3000;
		fixwinsize = 5;
		targwinsize = 6.5;
		baseRewardDuration = 80;
		testDuration = 600;
		testRefresh = 70; //70
		testHoldDuration = 1000;//400 1000
		nTrialPerTarget 		= 20;
		nTrialRemain 			= 6000; // initialize this to a really high number for protocols that don't depend on trial numbers (it gets reset for protocols that do)

		//setsize setup
		setSizeArray[0] 			= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[1] 			= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[2] 			= 2;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[3] 			= 2;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[4] 			= 3;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[5] 			= 3;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[6] 			= 4;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[7] 			= 4;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[8] 			= 5;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[9] 			= 5;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[10] 			= 6;   // These get reset to zero each time so new tasks start at zero trials per location.
		setSizeArray[11] 			= 6;   // These get reset to zero each time so new tasks start at zero trials per location.

		//samediff set up!
		sameDiffArray[0] 				= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		sameDiffArray[1] 				= 2;
		sameDiffArray[2] 				= 1;
		sameDiffArray[3] 				= 2;
		sameDiffArray[4] 				= 1;
		sameDiffArray[5] 				= 2;
		sameDiffArray[6] 				= 1;
		sameDiffArray[7] 				= 2;
		sameDiffArray[8] 				= 1;   // These get reset to zero each time so new tasks start at zero trials per location.
		sameDiffArray[9] 				= 2;
		sameDiffArray[10] 			= 1;
		sameDiffArray[11] 			= 2;		
		
		
		//counter set up!
		nTrialsArray[0] 				= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		nTrialsArray[1] 				= 0;
		nTrialsArray[2] 				= 0;
		nTrialsArray[3] 				= 0;
		nTrialsArray[4] 				= 0;
		nTrialsArray[5] 				= 0;
		nTrialsArray[6] 				= 0;
		nTrialsArray[7] 				= 0;
		nTrialsArray[8] 				= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		nTrialsArray[9] 				= 0;
		nTrialsArray[10] 			= 0;
		nTrialsArray[11] 			= 0;	
		//COLOR set up! [r,g,bl,m,w,cy,br,yl,bk]
		vwmColorArray[0,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[0,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[0,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[1,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[1,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[1,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[2,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[2,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[2,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[3,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[3,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[3,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[4,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[4,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[4,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[5,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[5,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[5,b_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[6,r_] 		= 42;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[6,g_] 		= 21;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[6,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[7,r_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[7,g_] 		= 63;   // These get reset to zero each time so new tasks start at zero trials per location.
	    vwmColorArray[7,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		
		vwmColorArray[8,r_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
		vwmColorArray[8,g_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.
	    vwmColorArray[8,b_] 		= 0;   // These get reset to zero each time so new tasks start at zero trials per location.

		vwmAngleArray[0]			= 45.0;	//45.0 0// angle of each target individually (degrees)
		vwmAngleArray[1]			= 135.0;   //135.0 45
		vwmAngleArray[2]			= 225.0;   //225.0 90
		vwmAngleArray[3]			= 315.0;  //315.0 135
		
		//vwmAngleArray[0]			= 225.0;	//45.0 0// angle of each target individually (degrees)
		//vwmAngleArray[1]			= 315.0;   //135.0 45
		//vwmAngleArray[2]			= 225.0;   //225.0 90
		//vwmAngleArray[3]			= 315.0;  //315.0 135
		// vwmAngleArray[4]			= 0;  //180
		// vwmAngleArray[5]			= 0; //-135
		// vwmAngleArray[6]			= 0;  //-90
		// vwmAngleArray[7]			= 0;  //-45
		
		//original 8locs
		// vwmAngleArray[0]			= 22.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 112.5;   //90
		// vwmAngleArray[3]			= 157.5;  //135
		// vwmAngleArray[4]			= -157.5;  //180
		// vwmAngleArray[5]			= -112.5; //-135
		// vwmAngleArray[6]			= -67.5;  //-90
		// vwmAngleArray[7]			= -22.5;  //-45
		
		// vwmAngleArray[0]			= 67.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 67.5;   //90
		// vwmAngleArray[3]			= 67.5;  //135
		// vwmAngleArray[4]			= 67.5;  //180
		// vwmAngleArray[5]			= 22.5; //-135
		// vwmAngleArray[6]			= 67.5;  //-90
		// vwmAngleArray[7]			= 157.5;  //-45
		
		// vwmAngleArray[0]			= 22.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 67.5;   //90
		// vwmAngleArray[3]			= 67.5;  //135
		// vwmAngleArray[4]			= -157.5;  //180
		// vwmAngleArray[5]			= -112.5; //-135
		// vwmAngleArray[6]			= -112.5;  //-90
		// vwmAngleArray[7]			= -112.5;  //-45
		
		// vwmAngleArray[0]			= 67.5;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 67.5;   //45
		// vwmAngleArray[2]			= 67.5;   //90
		// vwmAngleArray[3]			= 67.5;  //135
		// vwmAngleArray[4]			= -112.5;  //180
		// vwmAngleArray[5]			= -112.5; //-135
		// vwmAngleArray[6]			= -112.5;  //-90
		// vwmAngleArray[7]			= -112.5;  //-45
		
		// vwmAngleArray[0]			= 90;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 90;   //45
		// vwmAngleArray[2]			= 90;   //90
		// vwmAngleArray[3]			= 90;  //135
		// vwmAngleArray[4]			= 90;  //180
		// vwmAngleArray[5]			= 90; //-135
		// vwmAngleArray[6]			= 90;  //-90
		// vwmAngleArray[7]			= 90;  //-45
		
		// vwmAngleArray[0]			= 0;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 45;   //45
		// vwmAngleArray[2]			= 90;   //90
		// vwmAngleArray[3]			= 135;  //135
		// vwmAngleArray[4]			= 180;  //180
		// vwmAngleArray[5]			= -135; //-135
		// vwmAngleArray[6]			= -90;  //-90
		// vwmAngleArray[7]			= -45;  //-45
		
		//for removing rightward bias...
		// vwmAngleArray[0]			= 90;	// 0// angle of each target individually (degrees)
		// vwmAngleArray[1]			= 45;   //45
		// vwmAngleArray[2]			= 0;   //90
		// vwmAngleArray[3]			= -45;  //135
		// vwmAngleArray[4]			= -90;  //180
		// vwmAngleArray[5]			= -45; //-135
		// vwmAngleArray[6]			= 0;  //-90
		// vwmAngleArray[7]			= 45;  //-45
	
		
		}
		}
	}
	
	


	
