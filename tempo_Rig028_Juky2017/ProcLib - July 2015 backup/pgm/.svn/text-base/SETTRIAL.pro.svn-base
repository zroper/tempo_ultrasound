//-----------------------------------------------------------------------------------
// process SETTRIAL();
// Calculates all variables needed to run each task. See DEFAULT.pro and ALL_VARS.pro for an explanation of the global input variables
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
// 11-2011: Integrated choice countermanding task into ALL_PROS.pro. -pgm

#include C:/TEMPO/ProcLib/pgm/STAIR.pro						// staircases the SSD based on the last stop trial outcome
#include C:/TEMPO/ProcLib/pgm/STAIRDSC.pro					// staircases the discriminatory difficulty based on the last stop trial outcome
//#include C:/TEMPO/ProcLib/pgm/VWMParam.pro					//select setsize samediff stimuli, and locations for each vwm trial



declare hide int targIndex;								// OUTPUT: next trial target
declare hide int distIndex;								// for 2AFC tasks
declare hide int distIndex1, distIndex2, distIndex3; 	// up to 3 distractors (for reverse masking task)								
declare hide int highBetIndex, lowBetIndex;				// OUTPUT: next trial target
declare hide int signalColor;							// next signal targColor (could be either stop or ignore)
declare hide int ssd;									// SSD on next stop or ignore trial
declare hide int preTargHoldtime;						// next trial time between fixation and target onset
declare hide int postTargHoldtime;						// next trial time between target onset and cue to respond
declare hide int preBetHoldtime;						// next trial time between bet fixation and bet targets onset
declare hide int preProHoldtime;						// next trial time between proFixation and mask onset
declare hide int proportionIndex; 						// determined below to set the choice targColor proportion to use on this trial
declare hide int nDiscriminate;
declare float 	targ1CheckerProp;
declare int		targ1 = 0;
declare int		targ2 = 1;


//for VWM!
declare int acceptCondFlag = 0;
declare int acceptColorFlag = 0;
declare int acceptLocFlag = 0;

declare int condIndex = 0;
declare int colorIndex = 0;
declare int locIndex = 0;
declare int nColorsArray[8];
declare int nLocsArray[8];
declare int setsize;
declare int samediff; //vwm
declare int testColor;
declare int color_counter = 0;
declare int loc_counter = 0;



 

declare SETTRIAL();							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals


process SETTRIAL()							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
{

declare hide int 		decideSSD;
declare hide float 		per_jitter, jitter, randomProp, holdtimeDiff, soa_diff;
declare int 			iLevel;
declare int 			acceptTargetFlag, acceptPropFlag;
declare int 			ampArrayIndex;						// the random index to use choosing an amplitude on this trial
declare int 			useMiddleStimFlag;				// Used to balance trial types, so the 50% discriminatory stim doesn't get used more than other discrim levels 
declare int 			agreeFlag;				// flag to make sure randomly chosen go/no-go cue targColor proportion agrees with trial type (go or nogo)
declare int				randomPct;
declare float			randomProp;
declare int 			i;



// -----------------------------------------------------------------------------------------------
// Select current holdtime

holdtimeDiff = holdtimeMax - holdtimeMin;
randomProp 			= (random(1001))/1000.0;
if (expoJitterFlag)
	{		
	per_jitter 		= exp(-1.0*(randomProp/0.25));	
	}
else
	{
	per_jitter 			= randomProp;
	}
jitter 			= holdtimeDiff * per_jitter;
preTargHoldtime 	= round(holdtimeMin + jitter);






// --------------------------------------------------------------------------------
// FIXATION TASK
// --------------------------------------------------------------------------------
if (state == stateFIX)
	{
	fixAngle 	= angleArray[targIndex]; 													// THESE USER DEFINED GLOBALS ARE ARRAYS SO 
	fixAmp 		= ampArray[targIndex];												// THEY CANNOT BE PASSED INTO PROCESSES
	}
	
	
	

// --------------------------------------------------------------------------------
// VISUALLY GUIDED, DELAYED, AND MEMORY GUIDED SACCADE TASK
// --------------------------------------------------------------------------------
if (state == stateVIS ||
	state == stateDEL ||
	state == stateMEM)
	{
	// -----------------------------------------------------------------------------------------------
	// 1) Pick a target
	acceptTargetFlag = 0;
	targAmp 		= ampDefault;
	while (acceptTargetFlag == 0)
		{
		targIndex = random(nTarg);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
		if (nTrialArray[targIndex] < nTrialPerTarget)
			{
			acceptTargetFlag = 1;
			targAngle = angleArray[targIndex];
			}
			nexttick;
		}
	

				

	// -----------------------------------------------------------------------------------------------
	// 5) Select current soa (same logic as above)
	
	soa_diff = soaMax - soaMin;
	randomProp 			= (random(1001))/1000.0;
		if (expoJitterFlag_soa)
			{
			per_jitter 		= exp(-1.0*(randomProp/.25));	
			}
		else
			{
			per_jitter 	= randomProp;				// random number 0-100 (percentages)
			}
		jitter 			= soa_diff * per_jitter;
		soa 		= round(soaMin + jitter);
		// }
	}






	
	
	
	
	
	
	
	
	
	
	
	
// --------------------------------------------------------------------------------
// AMPLITUDE TASK
// --------------------------------------------------------------------------------
if (state == stateAMP)		// user wants to run the choice countermanding task
	{
	// -----------------------------------------------------------------------------------------------
	// Pick an amplitude and default the targIndex to 0 (the first one in the list.

	targIndex = 0;
	acceptTargetFlag = 0;
	while (acceptTargetFlag == 0)
		{
		ampArrayIndex = random(8);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
		if (nTrialArray[ampArrayIndex] < nTrialPerTarget)
			{
			acceptTargetFlag = 1;
			trialAmp = ampArray[ampArrayIndex];
			fixAngle = 		angleArray[targIndex] + 180;  // For the amplitude task, the fixation is 1/2 the amplitude from
			fixAmp = 		trialAmp/2;				// the center of the screen, 180 degrees from the target.
			targAngle = 	angleArray[targIndex];
			targAmp = 		trialAmp/2;
			}
		}
					
	}	




	
	
	
	
	
	
	
	
	
	
	
	
	


// --------------------------------------------------------------------------------
// SIMPLE COUNTERMANDING TASK
// --------------------------------------------------------------------------------
if (state == stateCMD)		// user wants to run the countermanding task
	{
	// -----------------------------------------------------------------------------------------------
	// Pick a target

	// targIndex = random(nTarg);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
	randomProp 			= (random(1001))/1000.0;
	if (randomProp <= targetRightRate)
		{
		targIndex = 0;						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
		}
	else
		{
		targIndex = 1;
		}
	targAngle = angleArray[targIndex];
	targAmp 		= ampDefault;
	// targAmp already set as default
	
	
	// -----------------------------------------------------------------------------------------------
	// If randomly varying the eccentricity of the target, choose that
	
	if (!randomAmpFlag)
		{
		targAmp = ampDefault;
		}
	else if (randomAmpFlag)
		{
		ampIndex = random(4);
		targAmp = ampArray[ampIndex];
		}
		
	
	// -----------------------------------------------------------------------------------------------
	// Pick a trial type
															// Pick a number and then assess user defined weights to see what type of trial will be presented.
	randomPct 			= (random(10001))/100.0;

	if (randomPct <= goPct)						// If we are on the left of the number line...
		{
		trialType = goTrial;									// ...its a go trial.
		}
	else if (randomPct > goPct 
			&& randomPct <= goPct + stopPct)	// If we are in the middle of the number line...
		{
		trialType = stopTrial;								// ...it is a stop trial, and...
		signalColor = stopColor;							// ...the signal targColor will reflect this fact.
		}
	else													// Else we must be on the right of the number line.
		{													// NOTE: based on user input, ignore trials may not... 
		trialType  = ignoreTrial;								// ...exist and the number line may not have anything... 
		signalColor = ignoreColor;						// ...to the right of stopPcts.  (Same holds for...
		}													// ...stop trials above.
		
	if (Classic)											// We are emulating the old stop signal task
		{
		signalColor = fixColor;							// the stop signal is just the fixation point coming back on.
		}
	
	
	// -----------------------------------------------------------------------------------------------
	// Select current SSD
	if (staircase)
		{
		if (!randomAmpFlag)
			{
			spawnwait STAIR(nSSD);
			ssd = ssdArray[decideIndex];			
			}
		else if (randomAmpFlag)
			{
			decideIndex      = decideSSDArray[ampIndex];  // assign the SSD index from the last trial at this discrim level (then update it below)
			lastOutcome = lastStopArray[ampIndex];   // staircasing stop trials independently within each discriminatory level: see REWARDS.pro for when lastStopArray gets updated
			spawnwait STAIR(nSSD);
			ssd = ssdArray[decideIndex];			
			decideSSDArray[ampIndex] = decideIndex;      // update decideSSDArray with the new SSD index within the current proportionIndex
			}
		}
	else
		{
		decideIndex	= random(nSSD);						// get random index
		ssd			= ssdArray[decideIndex]; 				// THIS GLOBAL IS AN ARRAY SO IT CANNOT BE PASSED
		}
		
	}








// --------------------------------------------------------------------------------
// CHOICE COUNTERMANDING TASK
// --------------------------------------------------------------------------------
if (state == stateCCM)		// user wants to run the choice countermanding task
	{
	// -----------------------------------------------------------------------------------------------
	// Pick a choice trial type
		
	acceptTargetFlag = 0;
	while (acceptTargetFlag == 0)
		{
		// Choose a  proportion to use on the current trial, based on assigned trial rates per discrimination level
		randomProp 			= (random(1001))/1000.0;
		// proportionIndex = random(nDiscriminate);
		proportionIndex = 0;
		acceptPropFlag = 0;
		while (acceptPropFlag == 0)
			{
			if (randomProp <= trialRateBound[proportionIndex])
				acceptPropFlag = 1;
			else if (randomProp > trialRateBound[proportionIndex])
				proportionIndex = proportionIndex + 1;
			}
		psyIndex 		= proportionIndex;	  // for upd8_psy.pro
		targ1CheckerProp = targ1PropArray[proportionIndex];
		psyValue 		= targ1CheckerProp;	  // for upd8_psy.pro
		randomProp 			= (random(1001))/1000.0;
		if (targ1CheckerProp == 0.5 &&
			randomProp < fiftyPercentRate)   // Using randoProp random variable to determine whether to run a 50% checker trial
			{
			acceptTargetFlag = 1;
			targIndex = random(nTarg);
			}
		else if (targ1CheckerProp < 0.5 && 
				randomProp > targetRightRate)
			{
			acceptTargetFlag = 1;
			targIndex = targ2;
			}
		else if (targ1CheckerProp > 0.5 && 
				randomProp <= targetRightRate)
			{
			acceptTargetFlag = 1;
			targIndex = targ1;
			}
		}
		
	
	distIndex   = abs(targIndex - 1);						// If target is 0, disttactor is 1, vise versa
	if (random(nTarg) > 1)									// If we're using 4 possible targets, choose one of the sets here
		{
		targIndex = targIndex + 2;
		distIndex = distIndex + 2;
		}
	targAngle 	= angleArray[targIndex];
	distAngle 	= angleArray[distIndex];
	targAmp 	= ampArray[targIndex];
	distAmp 	= ampArray[distIndex];
	
	// Want the checker stimulus in the upper region and 90 degrees from target and distractor
	if (targIndex == 0 | targIndex == 2)
		{
		checkerAngle = targAngle + 90;
		}
	else
		{
		checkerAngle = targAngle - 90;
		}
		
	// If checkerboard serves as a target, figure out whether checkerboard appears at target or distractor location
	// Also set targSize of target and distractor to be equal to targSize of checkerboard
	if (checkerIsTarg == 1)
		{
		targSize 		= iSquareSizePixels * nCheckerColumn / Deg2Pix_Y;
		decideCheckerAngle 			= (random(1001))/1000.0;
		if (decideCheckerAngle < checkerTargRate)   // Using decideTargIndex random variable to determine whether checkerboard appears at target or distractor location
			{			
			checkerTarg = targIndex;
			}
		else
			{
			checkerTarg = distIndex;
			}
		checkerAngle 		= angleArray[checkerTarg];
		}

	
	// -----------------------------------------------------------------------------------------------
	// 2) Pick a go/stop trial type
															// Pick a number and then assess user defined weights to see what type of trial will be presented.
	randomPct 			= (random(10001))/100.0;
															// Think of the if statement below as a number line with user defined divisions (weights).
	if (randomPct <= goPct)						// If we are on the left of the number line...
		{
		trialType = goTrial;									// ...its a go trial.
		}
	else if (randomPct > goPct 
			&& randomPct <= goPct + stopPct)	// If we are in the middle of the number line...
		{
		trialType  = stopTrial;								// ...it is a stop trial, and...
		signalColor = stopColor;							// ...the signal targColor will reflect this fact.
		}
	else													// Else we must be on the right of the number line.
		{													// NOTE: based on user input, ignore trials may not... 
		trialType  = ignoreTrial;								// ...exist and the number line may not have anything... 
		signalColor = ignoreColor;						// ...to the right of stopPcts.  (Same holds for...
		}													// ...stop trials above.
		
	if (Classic)											// We are emulating the old stop signal task
		{
		signalColor = fixColor;							// the stop signal is just the fixation point coming back on.
		}
	
	// -----------------------------------------------------------------------------------------------
	// 5) Select current SSD
	if (trialType == stopTrial | trialType == ignoreTrial)
		{
		if (staircase)
			{
			decideIndex      = decideSSDArray[proportionIndex];  // assign the SSD index from the last trial at this discrim level (then update it below)
			lastOutcome = lastStopArray[proportionIndex];   // staircasing stop trials independently within each discriminatory level: see REWARDS.pro for when lastStopArray gets updated
			spawnwait STAIR(nSSD);
			ssd = ssdArray[decideIndex];			
			decideSSDArray[proportionIndex] = decideIndex;      // update decideSSDArray with the new SSD index within the current proportionIndex
			}
		else
			{
			decideIndex	= random(nSSD);						// get random index
			ssd	= ssdArray[decideIndex]; 				// THIS GLOBAL IS AN ARRAY SO IT CANNOT BE PASSED
			}
		}
	
		
		
	// -----------------------------------------------------------------------------------------------
	// Select current holdtime after target presentation
	
	randomProp 	= (random(1001))/1000.0;				
	if (expoJitterFlag)
		{		
		per_jitter 		= exp(-1.0*(randomProp/.25));	
		}
	else
		{
		per_jitter 	= randomProp;				// random number 0-100 (percentages)
		}
	jitter 			= holdtimeDiff * per_jitter;
	postTargHoldtime 	= round(holdtimeMin + jitter);
	
	
	
	
	// -----------------------------------------------------------------------------------------------
	//  Select current delay (soa) if you want there to be a delay between checkerboard onset and response cue
	if (ccmDelayFlag)
		{
		soa_diff = soaMax - soaMin;
		randomProp 			= (random(1001))/1000.0;
			if (expoJitterFlag_soa)
				{
				per_jitter 		= exp(-1.0*(randomProp/.25));	
				}
			else
				{
				per_jitter 	= randomProp;				// random number 0-100 (percentages)
				}
			jitter 			= soa_diff * per_jitter;
			soa 		= round(soaMin + jitter);
		}
	else
		{
		soa 	 = 0;
		}
		
		
		
	}	// End Choice Countermanding Section








	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

// --------------------------------------------------------------------------------
// GO/NO-GO TASK
// --------------------------------------------------------------------------------
if (state == stateGNG)		// user wants to run the choice countermanding task
	{
	// -----------------------------------------------------------------------------------------------
	// 1) Pick a target

	// targIndex = random(nTarg);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
		randomProp 	= (random(1001))/1000.0;				
	if (randomProp <= targetRightRate)
		{
		targIndex = 0;						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
		}
	else
		{
		targIndex = 1;
		}
	targAngle = angleArray[targIndex];
	targAmp 		= ampDefault;
	

		
	
	// -----------------------------------------------------------------------------------------------
	// 2) Pick a trial type
															// Pick a number and then assess user defined weights to see what type of trial will be presented.
	randomPct 			= (random(10001))/100.0;
															// Think of the if statement below as a number line with user defined divisions (weights).
	if (randomPct <= goPct)						// If we are on the left of the number line...
		{
		trialType = goTrial;									// ...its a go trial.
		}
	else if (randomPct > goPct 
			&& randomPct <= goPct + nogoPct)	// If we are in the middle of the number line...
		{
		trialType  = nogoTrial;								// ...it is a nogo trial, and...
		// signalColor = nogoColor;							// ...the signal targColor will reflect this fact.
		}
			
	
	
	// -----------------------------------------------------------------------------------------------
	// 3) Pick a go/no-go discrimination level

	if (staircase)
		{
		spawnwait STAIR_DSC();
		}
	else
		{
		// Choose a random proportion to use on the current trial, making sure it agrees with trialType
		agreeFlag = 0;
		while (agreeFlag == 0)
			{		
			useMiddleStimFlag = random(2);
			proportionIndex = random(nDiscriminate);
			psyIndex = proportionIndex;   // for upd8_psy.pro
			goCheckerProp = goPropArray[proportionIndex];
			psyValue = goCheckerProp;	  // for upd8_psy.pro
			if (trialType == goTrial && goCheckerProp > .5)
				{
				agreeFlag = 1;
				}
			else if (trialType == nogoTrial && goCheckerProp < .5)
				{
				agreeFlag = 1;
				}
			else if (goCheckerProp == .5 && useMiddleStimFlag)
				{
				agreeFlag = 1;
				}
			}
		}
		
	

	// printf("Go Square Proportion: %.2d\n", goCheckerProp);



		
		
	// -----------------------------------------------------------------------------------------------
	// 6) Select current holdtime after cue presentation
	
	randomProp 	= (random(1001))/1000.0;				
	if (expoJitterFlag)
		{		
		per_jitter 		= exp(-1.0*(randomProp/.25));	
		}
	else
		{
		per_jitter 	= randomProp;				// random number 0-100 (percentages)
		}
	jitter 			= holdtimeDiff * per_jitter;
	postTargHoldtime 	= round(holdtimeMin + jitter);
	}




	
	
	
	
	
	
	
	
	
	





// --------------------------------------------------------------------------------------------------------
// METACOGNITION TASKS (REVERSE MASKING AND BETS)
// --------------------------------------------------------------------------------------------------------
if (state == stateMCM)		
	{
	// -----------------------------------------------------------------------------------------------
	// Set trial type: use a random percentage and determine which trial type distribution it falls in
	randomPct 			= (random(10001))/100.0;
	if (randomPct < maskPct)
		{
		trialType = tMaskTrial;
		}
	else if (randomPct >= maskPct && 
			randomPct < (maskPct + BetPct))
		{
		trialType = tBetTrial;
		targWinSize = 0;
		// If it's a bet-only trial, need to assign a random mask decision outcome so bet targets get values
		randomProp 			= (random(1001))/1000.0;
		if (randomProp <= fakeCorrectRate)
			{
			maskOutcome = saccTarg;
			}
		else
			{
			maskOutcome = saccDist;
			}		
		}	
	else if (randomPct >= (maskPct + BetPct) && 
			randomPct <= (maskPct + BetPct + retroPct))
		{
		trialType = tRetroTrial;
		}	
	else if (randomPct > maskPct + BetPct + retroPct) 
		{
		trialType = tProTrial;
		}	


	
	// -----------------------------------------------------------------------------------------------
	// Set target location (where one mask target will appear)
	targAmp 		= ampDefault;
	i = 0;
	while (i < nTarg)
		{
		maskAmpArray[i] = targAmp;
		i = i + 1;
		}
	

	if (trialType != tBetTrial)
		{
		randomProp 	= (random(1001))/1000.0;
		// If there are 2 possible target locations, probabilistically assign target to one hemifield and low bet to the other
		// If there are 4 possible target locations, need to consider that more than one target is in each hemifield (see below)
		if (nTarg == 2)
			{
			if (randomProp <= targetRightRate)	
				{
				targIndex = 0;
				}
			else
				{
				targIndex = 1;
				}
			}
		else if (nTarg == 4)
			{
			if (randomProp <= targetRightRate)	
				{
				targIndex = random(2);
				}
			else
				{
				targIndex = random(2) + 2;
				}
			}
		targAngle = maskAngleArray[targIndex];


		// -----------------------------------------------------------------------------------------------
		// Set distractor locations (where the other mask targets will appear)
		if (nTarg == 2)
			{
			distIndex1 = abs(targIndex - 2);
			}
		else if (nTarg == 4)    // This is not elegant- should change this to an array-based method of assigning distractor indices
			{
			if (targIndex == 0)
				{
				distIndex1 = 1;
				distIndex2 = 2;
				distIndex3 = 3;
				}
			else if (targIndex == 1)
				{
				distIndex1 = 0;
				distIndex2 = 2;
				distIndex3 = 3;
				}
			else if (targIndex == 2)
				{
				distIndex1 = 0;
				distIndex2 = 1;
				distIndex3 = 3;
				}
			else if (targIndex == 3)
				{
				distIndex1 = 0;
				distIndex2 = 1;
				distIndex3 = 2;
				}
			}
		}	 // if (trialType != tBetTrial)								 
	
	// -----------------------------------------------------------------------------------------------
	// Set bet target locations
	
	if (trialType != tMaskTrial)
		{
		randomProp 	= (random(1001))/1000.0;
		// If there are 2 possible target locations, probabilistically assign high bet to one hemifield and low bet to the other
		// If there are 4 possible target locations, need to consider that more than one target is in each hemifield (see below)
		if (nTarg == 2)
			{
			if (randomProp <= highBetRightRate)	
				{
				highBetIndex = 0;
				}
			else
				{
				highBetIndex = 1;
				}
			lowBetIndex = abs(highBetIndex - 2);
			}
		else if (nTarg == 4)
			{
			if (randomProp <= highBetRightRate)	
				{
				highBetIndex = random(2);
				lowBetIndex = highBetIndex + 2;
				}
			else
				{
				highBetIndex = random(2) + 2;
				lowBetIndex = highBetIndex - 2;
				}
			}
		highBetAmp		= targAmp;
		lowBetAmp	 	= targAmp;
		highBetAngle = maskAngleArray[highBetIndex];
		lowBetAngle = maskAngleArray[lowBetIndex];

		// -----------------------------------------------------------------------------------------------
		// Select bet-fixation hold time
		
			randomProp 	= (random(1001))/1000.0;				
			if (expoJitterFlag)
				{		
				per_jitter 		= exp(-1.0*(randomProp/.25));	
				}
			else
				{
				per_jitter 	= randomProp;				// random number 0-100 (percentages)
				}
			jitter 			= holdtimeDiff * per_jitter;
			preBetHoldtime 	= round(holdtimeMin + jitter);
		} //if (trialType != tMaskTrial)
										 

	
	// -----------------------------------------------------------------------------------------------
	// Set SOA
	if (trialType != tBetTrial)
		{
		if (staircase)
			{
			decideIndex      = decideSOAArray[targIndex];  // assign the SOA index from the last trial at this discrim level (then update it below)
			lastOutcome = lastMaskArray[targIndex];   // staircasing soa independently within each target position: see REWARDS.pro for when lastMaskArray gets updated
			spawnwait STAIR(nSOA);
			decideSOAArray[targIndex] = decideIndex;      // update decideSSDArray with the new SSD index within the current proportionIndex
			}
		else
			{
			decideIndex	= random(nSOA);						// get random index
			}
		soa	= soaArray[decideIndex]; 				// THIS GLOBAL IS AN ARRAY SO IT CANNOT BE PASSED

		
	// -----------------------------------------------------------------------------------------------
	// Select holdtime after cue presentation
	
		randomProp 	= (random(1001))/1000.0;				
		if (expoJitterFlag)
			{		
			per_jitter 		= exp(-1.0*(randomProp/.25));	
			}
		else
			{
			per_jitter 	= randomProp;				// random number 0-100 (percentages)
			}
		jitter 			= holdtimeDiff * per_jitter;
		postTargHoldtime 	= round(holdtimeMin + jitter);


	// -----------------------------------------------------------------------------------------------
	// Select prospective trial (2nd mask appearence) hold time
		
		if (trialType == tProTrial)
			{
			randomProp 	= (random(1001))/1000.0;				
			if (expoJitterFlag)
				{		
				per_jitter 		= exp(-1.0*(randomProp/.25));	
				}
			else
				{
				per_jitter 	= randomProp;				// random number 0-100 (percentages)
				}
			jitter 			= holdtimeDiff * per_jitter;
			preProHoldtime 	= round(holdtimeMin + jitter);
			}
				
		} // if (trialType != tBetTrial)
		
		
		
	} // if (state == stateMCM)		


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// --------------------------------------------------------------------------------
// VWMtask
// --------------------------------------------------------------------------------
if (state == stateVWM)
	{
	// -----------------------------------------------------------------------------------------------
	// 1) Pick a target
	
	
	acceptTargetFlag = 0;
	targAmp 		= ampDefault*.75;//ampDefault;
	acceptCondFlag = 0;
	
	acceptLocFlag = 0;
	while (acceptTargetFlag == 0)
		{
		//condition selection
		while (acceptCondFlag == 0)
			{
			condIndex = random(12);
			if(condCounterArray[condIndex]<nTrialsArray[condIndex])
				{
				
				acceptCondFlag = 1;
				
				setsize = setSizeArray[condIndex];
				samediff = sameDiffArray[condIndex];

				}
			}
		//color selection
		color_counter =0; 
		//initialize the nColorsArray
		nColorsArray[0] = 0;
		nColorsArray[1] = 0;
		nColorsArray[2] = 0;
		nColorsArray[3] = 0;
		nColorsArray[4] = 0;
		nColorsArray[5] = 0;
		nColorsArray[6] = 0;
		nColorsArray[7] = 0;
		while (color_counter <5) // upto set size 4 due to color similarity
			{
			acceptColorFlag = 0;
			while (acceptColorFlag == 0)
				{
				colorIndex = random(5);
				if(nColorsArray[colorIndex]<1)
					{
					acceptColorFlag = 1;
					nColorsArray[colorIndex]=1;
					}
				}
			if (color_counter<setsize)		
				{
				ColorArray[color_counter]=247-colorIndex;
				}
			else if (color_counter == 5) //set the diff color
				{
				ColorArray[color_counter]=247-colorIndex;
				}
			else //set it to the background color
				{
				ColorArray[color_counter]=blackColor;//background black!
				}
			
			
			color_counter = color_counter+1;
			}
			
		// lorr = random(2);
		// if (lorr == 0)
			// {
		
			// ColorArray[0] = 244;
			// ColorArray[1] = 245;
			// ColorArray[2] = blackColor;
			// ColorArray[3] = blackColor;
			// ColorArray[4] = blackColor;
			// ColorArray[5] = blackColor;
			// }
		// if (lorr == 1)
			// {
			// ColorArray[0] = 245;
			// ColorArray[1] = 244;
			// ColorArray[2] = blackColor;
			// ColorArray[3] = blackColor;
			// ColorArray[4] = blackColor;
			// ColorArray[5] = -blackColor;
			
			// }
			
			
		//Loc selection
		loc_counter =0; 
		//initialize the nLocsArray
		nLocsArray[0] = 0;
		nLocsArray[1] = 0;
		nLocsArray[2] = 0;
		nLocsArray[3] = 0;
		nLocsArray[4] = 0;
		nLocsArray[5] = 0;
		nLocsArray[6] = 0;
		nLocsArray[7] = 0;
		
		while (loc_counter <6)
			{
			acceptLocFlag = 0;
			while (acceptLocFlag == 0)
				{
				locIndex = random(8);
				if(nLocsArray[locIndex]<1)
					{
					acceptLocFlag = 1;
					nLocsArray[locIndex]=1;
					
					}
				
				}
			LocArray[loc_counter]=vwmAngleArray[locIndex];
			loc_counter = loc_counter+1;
					
			
			}
		// lorr = random(2);
		// if (lorr == 0)
			// {
				// LocArray[0] = 0;
				// LocArray[1] = 180;
				// LocArray[2] = 45;
				// LocArray[3] = 90;
				// LocArray[4] = 135;
				// LocArray[5] = -45;
			// lorr = random(2);
			// if (lorr == 0)
				// {
				// LocArray[0] = 180;
				// LocArray[1] = 0;
				// LocArray[2] = 45;
				// LocArray[3] = 90;
				// LocArray[4] = 135;
				// LocArray[5] = -45;
				// }
			// if (lorr == 1)
				// {
				// LocArray[0] = 180;
				// LocArray[1] = 0;
				// LocArray[2] = 45;
				// LocArray[3] = 90;
				// LocArray[4] = 135;
				// LocArray[5] = -45;
				// }
			
			// }
		// if (lorr == 1)
			// {
			// LocArray[0] = 180;
			// LocArray[1] = 0;
			// LocArray[2] = 45;
			// LocArray[3] = 90;
			// LocArray[4] = 135;
			// LocArray[5] = -45;
			
			// }

		
		
			
		if (samediff == 1) //same
			{
			testColor = ColorArray[0];
			targAngle = LocArray[0];
			testAmp = targAmp;
				
			}
		else if (samediff == 2) //diff
			{
			testColor = ColorArray[6];
			targAngle = 0;
			testAmp = fixAmp;
			}

		

		acceptTargetFlag = 1;
		printf("Color = %d\n",ColorArray[0]);
		printf("Loc = %d\n",LocArray[0]);
		printf("targAngle = %d\n",targAngle);
		
		//printf("Color = %d\n",ColorArray[2]);
		//printf("Color = %d\n",ColorArray[3]);
		//printf("Color = %d\n",ColorArray[4]);
		//printf("Color = %d\n",ColorArray[5]);
		//printf("Color = %d\n",ColorArray[6]);
		} //if state = VWMstate

	}

}

