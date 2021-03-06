//-------------------------------------------------------------------------------------------------------
// This Code combines END_TRL, SUCCESS, FAILURE, and ABORT, to allow a higher degree of freedom for 
// rewards. That is, one may want to give variable amounts of reward for various outcomes.


#include C:/TEMPO/ProcLib/pgm/JUICE.pro


declare REWARDS();

process REWARDS()
{	

declare					  now;			
declare hide int trl_end_time, tone_time, tone_type, noFix_punish, abort_punish;	
declare hide float play_the_odds;					// see if subject will randomly be rewarded or punished on this trial and by how much
declare float rewardRandomIncrease, rewardMaxIncreasePercent;
declare int rewards_start_time;


//	play_the_odds = random(10001)/100.0;				// choose medium small or large outcome
//	if (play_the_odds <= SmlR_weight)					// the number line is divided by the weights the user chooses
//		{
//		rewardDuration = baseRewardDuration / 2;			//GLOBAL for use in INFOS.pro
//		toneSuccess = Success_Tone_smlR;				//GLOBAL for use in INFOS.pro
//		}
//	else if(play_the_odds > SmlR_weight &&
//			play_the_odds < SmlR_weight + MedR_weight)
//		{
//		rewardDuration = baseRewardDuration;				//GLOBAL for use in INFOS.pro
//		toneSuccess = Success_Tone_medR;               //GLOBAL for use in INFOS.pro
//		}
//	else
//		{
//		rewardDuration = baseRewardDuration * 2;			//GLOBAL for use in INFOS.pro
//		toneSuccess = Success_Tone_bigR;               //GLOBAL for use in INFOS.pro
//		}
//	
//	
//	if (play_the_odds <= SmlP_weight)					// choose medium small or large outcome	
//		{                                               // the number line is divided by the weights the user chooses
//		punishDuration = basePunishDuration / 2;				//GLOBAL for use in INFOS.pro
//		toneFailure = Failure_Tone_smlP;               //GLOBAL for use in INFOS.pro
//		}
//	else if(play_the_odds > SmlP_weight &&
//			play_the_odds < SmlP_weight + MedP_weight)
//		{
//		punishDuration = basePunishDuration;					//GLOBAL for use in INFOS.pro
//		toneFailure = Failure_Tone_medP;               //GLOBAL for use in INFOS.pro
//		}
//	else
//		{
//		punishDuration = basePunishDuration * 2;				//GLOBAL for use in INFOS.pro
//		toneFailure = Failure_Tone_bigP;               //GLOBAL for use in INFOS.pro
//		}
//	
//	play_the_odds = random(10001)/100.0;				// probability of an outcome reversal

rewards_start_time = time();
rewardMaxIncreasePercent = 70;
rewardRandomIncrease = round(baseRewardDuration * random(rewardMaxIncreasePercent) / 100);
rewardDuration = baseRewardDuration + rewardRandomIncrease;
punishDuration = 0;




// 	SOME REWARDS/PUNISHMENTS ARE GENERAL TO ALL OR MULTIPLE TASKS: DO THOSE FIRST, THEN SPECIFIC TASKS BELOW
//----------------------------------------------------------------------------------------------------
//   Never attained fixation trial
if (	trialOutcome == noFix) 						// If the subject failed to initiate the trial properly...
	{
	punishDuration = round(basePunishDuration * 3);
	rewardDuration = 0;
	}

	
if (state == stateVIS ||
	state == stateMEM ||
	state == stateDEL ||
	state == stateAMP ||
	state == stateVWM)
	{
	//----------------------------------------------------------------------------------------------------
	//   Aborted trial-- broke central fixation or moved
	if (	trialOutcome == brokeFix 			||			// If the subject failed to initiate the trial properly...
			trialOutcome == noSacc			||
			trialOutcome == saccOut			||
			trialOutcome == saccEarly			||
			trialOutcome == brokeTarg			||
			trialOutcome == bodyMove)
		{
		Event_fifo[Set_event] = Abort_;				// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue...
		punishDuration = round(basePunishDuration / 1.5);
		rewardDuration = 0;
		}


	//----------------------------------------------------------------------------------------------------
	//    Correct trial

	else if (	trialOutcome == saccTarg	||
				play_the_odds < Bonus_weight)			// ...or if the trial is chosen as a surprise rewarded trial...
		{
		
		spawn TONE(toneChoiceSuccess,toneDuration);				// give the secondary reinforcer tone
		tone_time = time();									// record the time

		Event_fifo[Set_event] = Tone_;						// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...

		Event_fifo[Set_event] = Reward_tone;				// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...



		nTrialComplete = nTrialComplete + 1;
		nTrialArray[targIndex] = nTrialArray[targIndex] + 1;
		nTrialRemain = nTrialRemain - 1;
		}
	}









// 		SIMPLE COUNTERMANDING
//-----------------------------------------------------------------------------------------------------
if (state == stateCMD)
	{
	if (trialOutcome == brokeFix)
		{
		punishDuration = basePunishDuration * 2;
		rewardDuration = 0;
		}
	//    Correct trial
	if (	trialOutcome == goTarg 	||			// If the subject got the trial right...
				trialOutcome == nogoCorrect)			// ...or if the trial is chosen as a surprise rewarded trial...
		{
		if (trialOutcome == goTarg)
			spawn TONE(toneChoiceSuccess,toneDuration);				// give the secondary reinforcer tone
		else if (trialOutcome == nogoCorrect)
			spawn TONE(toneStopSuccess,toneDuration);				// give the secondary reinforcer tone
		
		
		tone_time = time();									// record the time
	
		Event_fifo[Set_event] = Tone_;						// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
		Event_fifo[Set_event] = Reward_tone;				// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
	
	
		nTrialComplete = nTrialComplete + 1;
		nTrialArray[targIndex] = nTrialArray[targIndex] + 1;
		nTrialRemain = nTrialRemain - 1;
		}
		
	//----------------------------------------------------------------------------------------------------
	//    Error trial
	else if (	trialOutcome == nogoTarg 	||			// If the subject got the trial ...
				trialOutcome == brokeTarg)		// 
		{
		if (trialOutcome == nogoTarg)
			spawn TONE(toneStopFailure,toneDuration);				// give the secondary reinforcer tone
		else if (trialOutcome == brokeTarg)
			spawn TONE(toneAbort,toneDuration);				// give the secondary reinforcer tone
		
		tone_time = time();											// record the time
		punishDuration = basePunishDuration;
		rewardDuration = 0;
	
		Event_fifo[Set_event] = Tone_;								// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
	
		Event_fifo[Set_event] = Error_tone;							// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
		}
	else if (	trialOutcome	== goIncorrect)						// 
		{
		printf("goIncorrect \n");
		spawn TONE(toneAbort,toneDuration);						// present negative tone
		tone_time = time();											// record the time
		punishDuration = basePunishDuration * 1.5;	
		rewardDuration = 0;
	
		Event_fifo[Set_event] = Tone_;								// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
	
		Event_fifo[Set_event] = Error_tone;							// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
		}
		
	// Extra reward for a given target (on top of rewardRandomIncrease)
	if (trialOutcome == goTarg	&&
		targIndex == 0)							// if correct to the right target
		{
		rewardDuration = round(rewardDuration * (1 + targ1ExtraPct / 100));
		}
	else if (trialOutcome == goTarg	&&
		targIndex == 1)							// if correct to the left target
		{
		rewardDuration = round(rewardDuration * (1 + targ2ExtraPct / 100));
		}
	if (trialType == nogoTarg)					// noncanceled stop is  still a "complete" trial
		{
		nTrialComplete = nTrialComplete + 1;
		}

	}




// 		CHOICE COUNTERMANDING
//-----------------------------------------------------------------------------------------------------
if (state == stateCCM)
	{
	if (trialOutcome == brokeFix)
		{
		punishDuration = basePunishDuration * 2;
		rewardDuration = 0;
		}
	//    Correct Go Trial
	if (	trialOutcome == goTarg )			// ...or if the trial is chosen as a surprise rewarded trial...
		{
		spawn TONE(toneChoiceSuccess,toneDuration);				// give the secondary reinforcer tone
		
		tone_time = time();									// record the time
	
		Event_fifo[Set_event] = Tone_;						// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
		Event_fifo[Set_event] = Reward_tone;				// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
	
		nTrialComplete = nTrialComplete + 1;
		nTrialArray[targIndex] = nTrialArray[targIndex] + 1;
		nTrialRemain = nTrialRemain - 1;
		}
	// Canceled Stop Trial
	if (	trialOutcome == nogoCorrect)			// ...or if the trial is chosen as a surprise rewarded trial...
		{
		spawn TONE(toneStopSuccess,toneDuration);				// give the secondary reinforcer tone
		
		rewardDuration = round(rewardDuration * 1.3);   // give 'em a little extra for stopping to help them slow down
		tone_time = time();									// record the time
	
		Event_fifo[Set_event] = Tone_;						// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
		Event_fifo[Set_event] = Reward_tone;				// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
	
		nTrialComplete = nTrialComplete + 1;
		nTrialArray[targIndex] = nTrialArray[targIndex] + 1;
		nTrialRemain = nTrialRemain - 1;
		}
		
	//----------------------------------------------------------------------------------------------------
	//    Noncanceled stop trial
	else if (	trialOutcome == nogoTarg	||
				trialOutcome == nogoDist)		// ...or if the trial is chosen as a surprise punished trial...
		{
		spawn TONE(toneStopFailure,toneDuration);							// present negative tone
		tone_time = time();									// record the time
		punishDuration = basePunishDuration * 1.2;
		
		if (trialOutcome == nogoTarg)
			rewardDuration = round(rewardDuration / 3);
		else if (trialOutcome == nogoDist)
			rewardDuration = 0;

		
		Event_fifo[Set_event] = Tone_;									// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
		Event_fifo[Set_event] = Error_tone;								// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...

		nTrialComplete = nTrialComplete + 1;
		}
	//    Timed-out go trial
	else if (	trialOutcome	== goIncorrect)		// ...or if the trial is chosen as a surprise punished trial...
		{
		printf("goIncorrect \n");
		spawn TONE(toneAbort,toneDuration);							// present negative tone
		tone_time = time();									// record the time
		punishDuration = basePunishDuration * 3;
		rewardDuration = 0;
	
		Event_fifo[Set_event] = Tone_;									// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
		Event_fifo[Set_event] = Error_tone;								// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
		}
	//    Go to distractor
	// Might want to some reward/punish for making the wrong choice but successfully responding on no-stop trial
	else if (trialOutcome == goDist)
		{
		punishDuration = round(basePunishDuration * 3);
		rewardDuration = 0;
		
		tone_time = time();									// record the time
		spawn TONE(toneChoiceFailure,toneDuration);							// present negative tone


		nTrialComplete = nTrialComplete + 1;
	
		Event_fifo[Set_event] = Tone_;									// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
		Event_fifo[Set_event] = Error_tone;								// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
		}
	//----------------------------------------------------------------------------------------------------
	//    Aborted trial-- broke target fixation
	else if (trialOutcome == brokeTarg  || trialOutcome == brokeDist)
		{
		rewardDuration = 0;
		Event_fifo[Set_event] = Abort_;				// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue...
		spawn TONE(200,300);	 
		punishDuration = round(basePunishDuration * 1.5);  // for choice countermanding, want it to be worse than making a wrong choice
		if (trialType == stopTrial && trialOutcome == brokeTarg)
			{
			punishDuration = basePunishDuration;  // for choice countermanding, can't help not stopping 50% of the time (so don't over-punish)
			rewardDuration = round(rewardDuration / 2); // give a bit of reward for at least making a correct choice
			nTrialComplete = nTrialComplete + 1;
			}
		}

		
	// Extra reward for a given target (on top of rewardRandomIncrease)
	if (trialOutcome == goTarg	&&
		(targIndex == 0 || targIndex == 2))							// if correct to the right target
		{
		rewardDuration = round(rewardDuration * (1 + targ1ExtraPct / 100));
		}
	else if (trialOutcome == goTarg	&&
		(targIndex == 1 || targIndex == 3))							// if correct to the left target
		{
		rewardDuration = round(rewardDuration * (1 + targ2ExtraPct / 100));
		}
	// Extra reward for successful stop trial
	if (trialOutcome == nogoCorrect)
		{
		rewardDuration = rewardDuration + 0;
		}

	if (trialOutcome == checkerAbort  || trialOutcome == saccOut)
		{
		punishDuration = round(basePunishDuration * 3);
		rewardDuration = 0;
		}
	}





// 		GO NO-GO TASK
//-----------------------------------------------------------------------------------------------------
if (state == stateGNG)
	{
	//    Correct trial
	if (	trialOutcome == goTarg 	||			// If the subject got the trial right...
				trialOutcome == nogoCorrect)			// ...or if the trial is chosen as a surprise rewarded trial...
		{
		if (trialOutcome == goTarg)
			spawn TONE(toneChoiceSuccess,toneDuration);				// give the secondary reinforcer tone
		else if (trialOutcome == nogoCorrect)
			spawn TONE(toneStopSuccess,toneDuration);				// give the secondary reinforcer tone
		tone_time = time();									// record the time
	
		Event_fifo[Set_event] = Tone_;						// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
		Event_fifo[Set_event] = Reward_tone;				// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...
	
	
	
		nTrialComplete = nTrialComplete + 1;
		nTrialArray[targIndex] = nTrialArray[targIndex] + 1;
		nTrialRemain = nTrialRemain - 1;
		}
	//----------------------------------------------------------------------------------------------------
	//    Error trial
	else if (	trialOutcome == nogoTarg)		// 
		{
		spawn TONE(toneStopFailure,toneDuration);						// present negative tone
		tone_time = time();											// record the time
		punishDuration = basePunishDuration;
		rewardDuration = 0;
	
		Event_fifo[Set_event] = Tone_;								// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
	
		Event_fifo[Set_event] = Error_tone;							// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
		}
	else if (	trialOutcome	== goIncorrect)		// ...or if the trial is chosen as a surprise punished trial...
		{
		printf("goIncorrect \n");
		spawn TONE(toneAbort,toneDuration);							// present negative tone
		tone_time = time();									// record the time
		punishDuration = basePunishDuration * 1.5;
		rewardDuration = 0;
	
		Event_fifo[Set_event] = Tone_;									// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
		Event_fifo[Set_event] = Error_tone;								// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
		}
	if (trialOutcome == nogoCorrect)
		{
		rewardDuration = rewardDuration + 0;
		}
	if (trialType == nogoTarg)					// noncanceled stop is  still a "complete" trial
		{
		nTrialComplete = nTrialComplete + 1;
		}

	}






// 		METACOG SUITE
//-----------------------------------------------------------------------------------------------------
if (state == stateMCM)
	{
	if (trialOutcome == brokeFix ||
		trialOutcome == saccOut)
		{
		spawn TONE(toneAbort,toneDuration*2);							// present negative tone
		punishDuration = round(basePunishDuration*2);
		rewardDuration = 0;
		}
	if (trialOutcome == saccTarg)			// Mask-only version
		{
		rewardDuration = round(rewardDuration);
		
		spawn TONE(toneChoiceSuccess,toneDuration);							// present negative tone
		tone_time = time();									// record the time
		}
	else if (trialOutcome == saccDist)			// Mask-only version
		{
		rewardDuration = 0;
		punishDuration = round(basePunishDuration * 1.2);
		spawn TONE(toneChoiceFailure,toneDuration);							// present negative tone
		tone_time = time();									// record the time
		}
	else if (trialOutcome == brokeTarg || trialOutcome == brokeDist)			// Mask-only version
		{
		rewardDuration = 0;
		punishDuration = round(basePunishDuration);			
		spawn TONE(toneAbort,toneDuration*2);							// present negative tone
		}
	if (trialType != tMaskTrial)  // For reverse-masking-only trials, reward like you would for a visually-guided saccade, e.g. (so skip this section)
		{
		if (trialOutcome == targHighBet)
			{
			rewardDuration = round(rewardDuration * 2);
			spawn TONE(toneTargHigh,toneDuration);							// present negative tone
			tone_time = time();									// record the time
			}
		else if (trialOutcome == targLowBet)
			{
			rewardDuration = round(rewardDuration * 1.5);
			spawn TONE(toneTargLow,toneDuration);							// present negative tone
			tone_time = time();									// record the time
			}
		else if (trialOutcome == distHighBet)
			{
			rewardDuration = 0;
			punishDuration = round(basePunishDuration * 3);
			spawn TONE(toneDistHigh,toneDuration);							// present negative tone
			tone_time = time();									// record the time
			}
		else if (trialOutcome == distLowBet)
			{
			rewardDuration = round(rewardDuration);
			punishDuration = 0;
			spawn TONE(toneDistLow,toneDuration);							// present negative tone
			tone_time = time();									// record the time
			}
		else if (trialOutcome == brokeBet)			
			{
			// rewardDuration = round(rewardDuration / 2);
			rewardDuration = 0;			
			punishDuration = basePunishDuration;			
			spawn TONE(toneAbort,toneDuration*2);							// present negative tone
			}
		else if (trialOutcome == betAbort)			// Mask-only version
			{
			rewardDuration = 0;
			punishDuration = round(basePunishDuration * 2);			
			spawn TONE(toneAbort,toneDuration*2);							// present negative tone
			}
		}
		
	}

if (state == stateVWM)
	{
	if (trialOutcome == fa || //false alarm
		trialOutcome == miss || //miss
		trialOutcome == hitIncSac) //incorrect saccade
		{
		Event_fifo[Set_event] = Abort_;				// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue...
		punishDuration = round(basePunishDuration / 1.5);
		rewardDuration = 0;
		}
	if (trialOutcome == hitCorSac || //correct saccade
		trialOutcome == cr)			// correct rejection
		{
		spawn TONE(toneChoiceSuccess,toneDuration);				// give the secondary reinforcer tone
		tone_time = time();									// record the time

		Event_fifo[Set_event] = Tone_;						// ...queue strobe...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...

		Event_fifo[Set_event] = Reward_tone;				// ...queue strobe for Neuro Explorer...
		Set_event = (Set_event + 1) % Event_fifo_N;			// ...incriment event queue...



		nTrialComplete = nTrialComplete + 1;
		condCounterArray[condIndex] = condCounterArray[condIndex] + 1;
		nTrialRemain = nTrialRemain - 1;
		}
		
	}





//-----------------------------------------------------------------------------------------------------
// DELIVERY OF REWARD:
if (rewardDuration > 0 && state != stateFix)
	{
		while (time() < tone_time + rewardDelay)			// wait until it is OK to give reward
			{		
			nexttick;										// wait for it... wait for it...
			}		
	spawn JUICE(juiceChannel,rewardDuration);			// YEAH BABY!  THAT'S WHAT IT'S ALL ABOUT!
	}
// Wait for the duration of a timeout (could be zero).
while(time() < rewards_start_time + punishDuration) // Then figure out how much time has elapsed since trial start...
	{                                                       
	nexttick;                                               // ...and continue to wait until time is up + timeout.
	}        
// drop reward code only if reward or timeout earned	
if ((rewardDuration > 0 || punishDuration > 0) && state != stateFix)  
	{
	Event_fifo[Set_event] = Reward_;									// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	}



nTrial = nTrial + 1;
nexttick 20;
trl_end_time = time();											// record the time b/c the trial is now over
	
Event_fifo[Set_event] = Eot_;									// ...queue strobe...
Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...




spawnwait INFOS();									// ...queue a big ole` pile-o-strobes for plexon
nexttick 25;										// Give TEMPO a chance to catch its breath before attempting.. 
													// ...RDX communication with vdosync.
													// NOTE: if you add a bunch more strobes to INFOS.pro and you...
													// start getting buffer overflow errors increase the number of nextticks.







//-----------------------------------------------------------------------------------------------------
// If the animal moved, and we are training stillness, impose a punishment
while (Move_ct > 0)
	{
	now = time();
	while (time() < now + bmove_tout)
		{
		nexttick;
		}
	Move_ct = Move_ct - 1;
	}



	



// -----------------------------------------------------------------------------------------------
// Should we run a trial or are we done?
if (nTrialRemain == 0)
	{
	system("dpop");
	state = stateNoTask;     // if we're done, kick it out to idle state
	
	}







// -----------------------------------------------------------------------------------------------
// Add extra inter-trial time if we are doing fixed-trial durations
if (fixedTrialDuration)											// Did you want a fixed trial length?
	{                                                           
	while(time() < trialStartTime + trialDuration + punishDuration) // Then figure out how much time has elapsed since trial start...
		{                                                       
		nexttick;                                               // ...and continue to wait until time is up + timeout.
		}                                                       
	}                                                           
else                                                            // Did you want a fixed intertrial interval?
	{                                                           
	while (time() < trl_end_time + interTrialDuration) // Then watch the time since trial end...
		{                                                       
		nexttick;                                               // ...and wait until time is up + timeout.
		}		                                                
	}


}