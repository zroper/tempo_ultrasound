//--------------------------------------------------------------------------------------------
// Run a GO/NO-GO trial based on the variables calculated by SETC_TRL.pro and those 
// given by the user.
//


declare GNGTRIAL();			

process GNGTRIAL()        		
	{
	
	
	// Number the trial stages to make them easier to read below
	declare hide int 	need_fix  	= 1;
	declare hide int 	fixating  	= 2;
	declare hide int 	cue_on   	= 3;
	declare hide int 	targ_on   	= 4;
	declare hide int 	in_flight 	= 5;
	declare hide int 	on_target 	= 6;	
	declare hide int 	stage;
	
	// Number the stimuli pages to make reading easier
	declare hide int   	blank       = 0;
	declare hide int	fixation_pd = 1;
	declare hide int	fixation    = 2;
	declare hide int	cue_pd 		= 3;
	declare hide int	cue    		= 4;
	declare hide int	target_pd   = 5;
	declare hide int	target      = 6;

		                                        
	// Timing variables that will be used to time task
	declare hide float 	fix_spot_time; 					
	declare hide float 	cue_time; 					
	declare hide float  targ_time; 					
	declare hide float  saccade_time;
	declare hide float 	aquire_fix_time;
	declare hide float	aquire_targ_time;	
	
	
	// Have to be reset on every iteration since 
	// variable declaration only occurs at load time
	trl_running 		= 1;
	stage 				= need_fix;
	
	// Tell the user what's up
	printf(" \n");
	printf("#: %d",nTrial);
	printf(" (%d correct) ",nTrialComplete);
	if (trialType == goTrial)
		{
		printf("  GO\n");
		}
	if (trialType == nogoTrial)
		{
		printf("  NO-GO\n");
		}
		printf("pre-cue holdtime = %d\n",preTargHoldtime);
		printf("post-cue holdtime = %d\n",postTargHoldtime);
		printf("        Go Proportion = %.2d\n", goCheckerProp);
	
	
																			// HERE IS WHERE THE FUN BEGINS
	Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	dsendf("vp %d\n",fixation_pd);											// flip the pg to the fixation stim with pd marker
	fix_spot_time = time();  												// record the time
	Event_fifo[Set_event] = FixSpotOn_;										// queue strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	dsendf("XM RFRSH:\n"); 													// wait one vertical retrace
	dsendf("vp %d\n",fixation);												// flip the pg to the fixation stim without pd marker
	oSetAttribute(object_fix, aVISIBLE); 									// turn on the fixation point in animated graph
	
	
	while (trl_running)														// trials ending will set trl_running = 0
		{	
		
	//--------------------------------------------------------------------------------------------
	// STAGE need_fix (the fixation point is on, but the subject hasn't looked at it)
		if (stage == need_fix)
			{		
			if (In_FixWin)													// If the eyes have entered the fixation window (before time, see below)...
				{
				aquire_fix_time = time();									// ...function call to time to note current time and...
				trialStartTime = aquire_fix_time;							// Global output
				Event_fifo[Set_event] = Fixate_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				// if (time() > aquire_fix_time + 50)
				// {
				stage = fixating;						// ...advance to the next stage.
				}
			else if (time() > fix_spot_time + allowFixTime)				// But if time runs out...
				{
				trialOutcome = noFix;    									// TRIAL OUTCOME ERROR (no fixation)
				LastOutcome = noChange;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (no fixation)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE fixating (the subject is looking at the fixation point waiting for cue onset)		
		else if (stage == fixating)
			{
			if (!In_FixWin && time() > aquire_fix_time + 100)													// If the eyes stray out of the fixation window...
				{
				trialOutcome = brokeFix;									// TRIAL OUTCOME ERROR (broke fixation)
				lastOutcome = noChange;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + preTargHoldtime)	// But if the eyes are still in the window at end of holdtime...
				{
				dsendf("vp %d\n", target_pd);								// ...flip the pg to the target with pd marker...	
				targ_time = time(); 										// ...record the time...
				dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
				dsendf("vp %d\n",target);									// ...flip the pg to the target without pd marker.
				oSetAttribute(object_targ, aVISIBLE); 					// ...remove target from animated graph...
				
					
				Event_fifo[Set_event] = Target_;							// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				
																			// Now the animated graphs have to catch up (seperate so that stim timing stays tight)					
				stage = targ_on;											// Advance to the next trial stage.				
				}
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE targ_on (the subject is looking at the target waiting for cue onset)		
		else if (stage == targ_on)
			{
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				trialOutcome = brokeFix;									// TRIAL OUTCOME ERROR (broke fixation)
				lastOutcome = noChange;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > targ_time + postTargHoldtime)	// But if the eyes are still in the window at end of holdtime...
				{
				// if (trialType == nogoTrial)
				// spawn JUICE(juiceChannel, 100);
				dsendf("vp %d\n",cue_pd);								// ...flip the pg to the target with pd marker...	
				cue_time = time(); 										// ...record the time...
				dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
				dsendf("vp %d\n",cue);									// ...flip the pg to the target without pd marker.
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				Event_fifo[Set_event] = Cue_;							// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
									
				stage = cue_on;											// Advance to the next trial stage.				
				}
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE cue_on (the target has been presented but the subject is still fixating)		
		else if (stage == cue_on)
			{		
			if (!In_FixWin)													// If the eyes leave the fixation window...
				{															// ...we have a saccade, so...
				saccade_time = time();										// ...record the time...
				Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("                          rt = %d\n",saccade_time - cue_time);	// ...tell the user whats up...
				stage = in_flight;											// ...and advance to the next stage.
				if (trialType == nogoTrial)
					{
					spawn TONE(200,400);
					}
				}
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > cue_time + saccTimeMax && 					// ...and time for a saccade runs out...
				trialType == goTrial)				// ...and a saccade was supposed to be made.
				{
				trialOutcome = goIncorrect;           							// TRIAL OUTCOME ERROR (incorrect go trial)
				lastOutcome = failure;										// 
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (no saccade)\n");								// ...tell the user whats up...
				// spawn SVR_BELL();
				trl_running = 0;											// ...and terminate the trial.
				}				
			else if (In_FixWin &&											// But if no saccade occurs...
				time() > cue_time + holdStopDuration && 				// ...and time for a saccade runs out...
				trialType == nogoTrial)										// ...and a saccade was NOT supposed to be made...
				{
				trialOutcome = nogoCorrect;   								// TRIAL OUTCOME CORRECT (canceled trial)
				lastOutcome = success;									// set the global for staircasing...
				dsendf("vp %d\n",blank);									// ...flip the pg to remove target...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				Event_fifo[Set_event] = Correct_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("Correct (no-go)\n");								// ...tell the user whats up...
				trl_running = 0;  											// ...and terminate the trial.
				}		
			}
			
			
			
	//--------------------------------------------------------------------------------------------
	// STAGE in_flight (eyes have left fixation window but have not entered target window)		
		else if (stage == in_flight)
			{
			if (In_TargWin)													// If the eyes get into the target window...
				{
				aquire_targ_time = time();									// ...record the time...
				Event_fifo[Set_event] = Decide_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = on_target;											// ...and advance to the next stage of the trial.
				if (trialType == nogoTrial)									// But if a saccade was the wrong thing to do...
					{												
					Event_fifo[Set_event] = Error_sacc;						// ...queue strobe for Neuro Explorer
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.
					}
				else 														// Otherwise...
					{								
					Event_fifo[Set_event] = Correct_;					// ...queue strobe for Neuro Explorer
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
					}
				}
			else if (time() > saccade_time + saccDurationMax)				// But, if the eyes are out of the target window and time runs out...
				{
				trialOutcome = saccOut;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
				if (trialType == nogoTrial)									// But if a saccade was the wrong thing to do...
					{												
					lastOutcome = failure;								// ...record the failure.
					}
				else 														// Otherwise...
					{								
					lastOutcome = noChange;							// ...make sure that the last outcome is cleared.						
					}
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
				trl_running = 0; 											// ...and terminate the trial.
				}
			}
		
		
		
	//--------------------------------------------------------------------------------------------
	// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)	
		else if (stage == on_target)
			{
			if (!In_TargWin)												// If the eyes left the target window...
				{			
				trialOutcome = brokeTarg;									// TRIAL OUTCOME ERROR (broke target fixation)
				if (trialType == nogoTrial)									// But if a saccade was the wrong thing to do...
					{												
					lastOutcome = failure;
					}
				else 														// Otherwise...
					{								
					lastOutcome = noChange;							// ...make sure that the last outcome is cleared.						
					}
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}		
			else if (In_TargWin  											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targHoldtime)				// ...and the target hold time is up...
				{
				if (trialType == goTrial || trialType == ignoreTrial)			// ...and a saccade was the correct thing to do...
					{
					trialOutcome = goTarg;								//TRIAL OUTCOME CORRECT (correct go trial)
					lastOutcome = success;									// 
					Event_fifo[Set_event] = Correct_;						// ...queue strobe...
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
					printf("Correct (saccade)\n");							// ...tell the user whats up...
					}
				else if (trialType == nogoTrial)								// But if a saccade was the wrong thing to do...
					{
					trialOutcome = nogoTarg;								//TRIAL OUTCOME ERROR (noncanceled trial)
					lastOutcome = failure;
					printf("Error (noncanceled)\n");						// ...tell the user whats up...
					}														// Either way we are done, so...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
		if (Move_ct > 0)
			{
			trialOutcome = bodyMove;   									// TRIAL OUTCOME ABORTED (the body was moving)
			lastOutcome = noChange;								// ...make sure that the last outcome is cleared.	
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Aborted (body movement)\n");							// ...tell the user whats up...
			trl_running = 0; 											// ...and terminate the trial.
			}
			
		nexttick;
		}
	}