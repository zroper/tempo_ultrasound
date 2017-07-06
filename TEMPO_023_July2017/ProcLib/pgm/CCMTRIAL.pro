//--------------------------------------------------------------------------------------------
// Run a choice countermanding trial based on the variables calculated by SETCCTRL.pro and those 
// given by the user.
//
// 11-2011: Adapted from CMDTRIAL and integrated choice countermanding task into ALL_PROS.pro. -pgm

declare int nSuccess;

declare CCMTRIAL();			// animated graph object

process CCMTRIAL()        		// animated graph object
{


// Number the trial stages to make them easier to read below
declare hide int 	need_fix  		= 1;
declare hide int 	fixating  		= 2;
declare hide int 	targ_on   		= 3;
declare hide int 	choice_on  		= 4;
declare hide int 	in_flight 		= 5;
declare hide int 	on_target 		= 6;	
declare hide int 	on_distractor 	= 7;	// pgm
declare hide int 	choice_delay 	= 8;	// pgm
declare hide int 	stage;

// Number the stimuli pages to make reading easier
declare hide int   	blank       = 0;
// declare hide int	fixation_pd = 1;
// declare hide int	fixation    = 2;
declare hide int	target_pd   = 1;
declare hide int	target      = 2;
declare hide int	choice_pd   = 3;										
declare hide int	choice      = 4;										
declare hide int	signal_pd   = 5;										
declare hide int	signal      = 6;

											
// Timing variables which will be used to time task
declare hide float 	fix_spot_time; 					
declare hide float  targ_time; 					
declare hide float  cue_time; 					
declare hide float  saccade_time;
declare hide float 	aquire_fix_time;
declare hide float 	stop_sig_time;
declare hide float	aquire_targ_time;	
declare hide float	aquire_dist_time;	
declare hide float	aquire_chkr_time;
	
declare int			ssdMS;		// ssd in ms, not in screen flips	
declare int 		preSSDResponse;

// Have to be reset on every iteration since 
// variable declaration only occurs at load time
trl_running 		= 1;
stage 				= need_fix;
preSSDResponse 	= 0;
ssdMS = round(ssd * (1000.0/screenRefreshRate));


// Tell the user what's up
printf(" \n");
printf("# %d",nTrial);
printf(" (%d complete)\n",nTrialComplete);
if (trialType == goTrial)
	{
	printf("GO\n");
	// if (targ1targ2Flag == 0)
		// printf("BLUE\n");
	// else if (targ1targ2Flag == 1)
		// printf("RED\n");
	}
if (trialType == stopTrial)
	{
	printf("*** STOP ***\n");
	printf(" Successful stops: %d\n", nSuccess);
	// if (targ1targ2Flag == 0)
		// printf("BLUE\n");
	// else if (redBlueFlag == 1)
		// printf("RED\n");
	printf("                      ssd = %d\n", ssdMS);
	}
if (trialType == ignoreTrial)
	{
	printf("IGNORE\n");
	printf("               isd = %d\n", ssdMS);
	}
	// printf("   Target 1 Proportion = %.2d\n", psyValue);
	printf("pre-target holdtime = %d\n",preTargHoldtime);
	printf("post-target holdtime = %d\n",postTargHoldtime);
	printf("             Target 1 Pct = %d\n", targ1CheckerProp*100);
	
	printf("             Delay = %d\n", soa);


																		// HERE IS WHERE THE FUN BEGINS
Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
// dsendf("vp %d\n",fixation_pd);											// flip the pg to the fixation stim with pd marker
// dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
// dsendf("cl:\n");																			// clear screen
spawn DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
dsendf("XM RFRSH:\n"); 													// wait one vertical retrace	
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,0,fill,unit2pix_X,unit2pix_Y);			// erase photodiode marker
fix_spot_time = time();  												// record the time
Event_fifo[Set_event] = FixSpotOn_;										// queue strobe
Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
// dsendf("XM RFRSH:\n"); 													// wait one vertical retrace	
// dsendf("vp %d\n",fixation);												// flip the pg to the fixation stim without pd marker
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
			stage = fixating;											// ...advance to the next stage.
			}
		else if (time() > fix_spot_time + allowFixTime)				// But if time runs out...
			{
			trialOutcome = noFix;    									// TRIAL OUTCOME ERROR (no fixation)
			lastOutcome = noChange;								// Don't change SSD
			spawn DRW_SQR(fixSize, fixAngle, fixAmp, 0, fill, deg2pix_X, deg2pix_Y);   	// erase fixation point
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Aborted (no fixation)\n");							// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}			
		}
		
		

//--------------------------------------------------------------------------------------------
// STAGE fixating (the subject is looking at the fixation point waiting for target onset)		
	else if (stage == fixating)
		{
		if (!In_FixWin && time() > aquire_fix_time + 200)													// If the eyes stray out of the fixation window...
			{
			trialOutcome = brokeFix;									// TRIAL OUTCOME ERROR (broke fixation)
			lastOutcome = noChange;								// Don't change SSD
			spawn DRW_SQR(fixSize, fixAngle, fixAmp, 0, fill, deg2pix_X, deg2pix_Y);   	// erase fixation point
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}
		else if (In_FixWin && time() > aquire_fix_time + preTargHoldtime)	// But if the eyes are still in the window at end of holdtime...
			{
			dsendf("vp %d\n",target_pd);								// ...flip the pg to the target with pd marker...	
			targ_time = time(); 										// ...record the time...
			dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
			dsendf("vp %d\n",target);									// ...flip the pg to the target without pd marker.
			// Reset the blank page as blank so we can easily flip to it 																			
			dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
			dsendf("cl:\n");                                                                            // clear screen (that's all)
			

				
			Event_fifo[Set_event] = Target_;						// Queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			
																		// Now the animated graphs have to catch up (seperate so that stim timing stays tight)
			oSetAttribute(object_targ, aVISIBLE); 					// ...show target in animated graph...
				


				stage = targ_on;											// Advance to the next trial stage.				
			}
		}
		
		

//--------------------------------------------------------------------------------------------
// STAGE targ_on (the subject is looking at the fixation point waiting for checkerboard onset)		
	else if (stage == targ_on)
		{
		if (!In_FixWin)													// If the eyes stray out of the fixation window...
			{
			trialOutcome = brokeFix;									// TRIAL OUTCOME ERROR (broke fixation)
			lastOutcome = noChange;								// Don't change SSD
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			spawn SVR_BELL();
			printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}
		else if (In_FixWin && time() > targ_time + postTargHoldtime)	// But if the eyes are still in the window at end of holdtime...
			{
			dsendf("vp %d\n",choice_pd);								// ...flip the pg to the choice stim pd marker...	
			cue_time = time(); 										// ...record the time...
			dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
			dsendf("vp %d\n",choice);									// ...flip the pg to the choice stim without pd marker.
			Event_fifo[Set_event] = Choice_;						// Queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...

			// If delaying the cue to respond, just go to stage delay_on- else wait for stop signal, etc, here
			if (ccmDelayFlag)
				{
				// If we're doing choice countermanding with a delay, kludge here:
				// Reset the target pages to the page(s) that will cue monkey to respond (checker on, fix off)

/*				//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
					// Draw pg 5	 
					dsendf("rw %d,%d;\n",target_pd,target_pd);  												// draw pg 3                                        
					dsendf("cl:\n");																			// clear screen
					spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          // draw target
					spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);    	// draw distractor
					spawnwait DRW_CHKR(0);  														// draw checkered stimulus
					if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
						{
						spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
						}
					spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
					// nexttick;
					//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
					// Draw pg 6	  
					dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
					dsendf("cl:\n");																			// clear screen
					spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);         	// draw target
					spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);     	// draw distractor
					spawnwait DRW_CHKR(0);  															// draw checkered stimulus
					if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
						{
						spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y);   	// draw fixation point
						}
*/				//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
					// Draw pg 5	 
					dsendf("rw %d,%d;\n",target_pd,target_pd);  												// draw pg 3                                        
					dsendf("cl:\n");																			// clear screen
					spawn DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          // draw target
					spawn DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);    	// draw distractor
					if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
						{
						spawn DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
						}
					spawn DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
					// spawn DRW_CHKR(0);  														// draw checkered stimulus
					nexttick;
					//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
					// Draw pg 6	  
					dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
					dsendf("cl:\n");																			// clear screen
					spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);         	// draw target
					spawn DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);     	// draw distractor
					if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
						{
						spawn DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y);   	// draw fixation point
						}
					// spawn DRW_CHKR(0);  															// draw checkered stimulus
					nexttick;
				stage = choice_delay;
				}
			else
				{
				if (trialType == stopTrial ||									// If it is a stop or ignore trial present the signal.
					trialType == ignoreTrial)										// This happens here so that no overhead intervenes between commands.
					{														// That way the # of vertical retraces remains independant of incidental processing time.
																			// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)
					// dsendf("vw %d\n",ssd-1);							// Wait so many vertical retraces (one is waited implicitly b/c photodiode marker above)...
					while (time() <= cue_time + ssdMS - (1000.0/screenRefreshRate))   // Do nothing in a loop while waiting for stop signal to come on...
						{																// wait until one screen refresh before ssd, then send the commoand to present stop signal on next screen refresh
						if (!In_FixWin)													// If the eyes leave the fixation window...
							{															// ...we have a saccade, so...
							if (preSSDResponse == 0)
								{
								saccade_time = time();										// ...record the time...
								Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
								Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
								// dsendf("vp %d\n",target);									// Flip the pg to the blank screen...
								printf("           rt = %d\n",saccade_time - cue_time);	// ...tell the user whats up...
								}
							preSSDResponse = 1;
							}
							nexttick;
						}
					dsendf("vp %d\n",signal_pd);							// ...flip the pg to the signal with the pd marker...
					
				
					stop_sig_time = cue_time + ssdMS; 		// ...record TEMPO time of presentation...
					dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
					dsendf("vp %d\n",signal);								// ...and flip the pg to the signal without pd marker.
					Event_fifo[Set_event] = StopSignal_;						// Queue strobe...
					Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
					}
					
				
																			// Now the animated graphs have to catch up (seperate so that stim timing stays tight)
				oSetAttribute(object_checker, aVISIBLE); 					// ...show target in animated graph...
				if (trialType == goTrial)										// If the trial is a go trial...
					{
					oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
					}
					
				// If a response was made before stop signal came on, skip choice_on stage and go straight to in_flight	
				if (preSSDResponse == 0)
					stage = choice_on;											// Advance to the next trial stage.	
				else if (preSSDResponse == 1)
					stage = in_flight;			
				}
			}
		}
		


//--------------------------------------------------------------------------------------------
// STAGE choice_delay (the subject is looking at the fixation point waiting for cue onset)		
	else if (stage == choice_delay)
		{
		if (!In_FixWin)													// If the eyes stray out of the fixation window...
			{
			trialOutcome = brokeFix;									// TRIAL OUTCOME ERROR (broke fixation)
			lastOutcome = noChange;								// Don't change SSD
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			spawn SVR_BELL();
			printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}
		else if (In_FixWin && time() > cue_time + soa)	// But if the eyes are still in the window at end of holdtime...
			{
			dsendf("vp %d\n",target_pd);								// ...flip the pg to the choice stim pd marker...	
			cue_time = time(); 										// ...record the time...
			dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
			dsendf("vp %d\n",target);									// ...flip the pg to the choice stim without pd marker.
			Event_fifo[Set_event] = Cue_;						// Queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...


			if (trialType == stopTrial ||									// If it is a stop or ignore trial present the signal.
				trialType == ignoreTrial)										// This happens here so that no overhead intervenes between commands.
				{														// That way the # of vertical retraces remains independant of incidental processing time.
																		// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)
				// dsendf("vw %d\n",ssd-1);							// Wait so many vertical retraces (one is waited implicitly b/c photodiode marker above)...
				while (time() <= cue_time + ssdMS - (1000.0/screenRefreshRate))   // Do nothing in a loop while waiting for stop signal to come on...
					{																// wait until one screen refresh before ssd, then send the commoand to present stop signal on next screen refresh
					if (!In_FixWin)													// If the eyes leave the fixation window...
						{															// ...we have a saccade, so...
						if (preSSDResponse == 0)
							{
							saccade_time = time();										// ...record the time...
							Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
							Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
							// dsendf("vp %d\n",target);									// Flip the pg to the blank screen...
							printf("           rt = %d\n",saccade_time - cue_time);	// ...tell the user whats up...
							}
						preSSDResponse = 1;
						}
						nexttick;
					}
				dsendf("vp %d\n",signal_pd);							// ...flip the pg to the signal with the pd marker...
				
			
				stop_sig_time = cue_time + ssdMS; 		// ...record TEMPO time of presentation...
				dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
				dsendf("vp %d\n",signal);								// ...and flip the pg to the signal without pd marker.
				Event_fifo[Set_event] = StopSignal_;						// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				}
				
			
																		// Now the animated graphs have to catch up (seperate so that stim timing stays tight)
			oSetAttribute(object_checker, aVISIBLE); 					// ...show target in animated graph...
			if (trialType == goTrial)										// If the trial is a go trial...
				{
				oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
				}
				
			// If a response was made before stop signal came on, skip choice_on stage and go straight to in_flight	
			if (preSSDResponse == 0)
				stage = choice_on;											// Advance to the next trial stage.	
			else if (preSSDResponse == 1)
				stage = in_flight;			
			}
		}
		


//--------------------------------------------------------------------------------------------
// STAGE choice_on (the choice stimulus has been presented but the subject is still fixating)		
	else if (stage == choice_on)
		{		
		if (!In_FixWin)													// If the eyes leave the fixation window...
			{															// ...we have a saccade, so...
			saccade_time = time();										// ...record the time...
			Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			// dsendf("vp %d\n",target);									// Flip the pg to the blank screen...
			printf("           rt = %d\n",saccade_time - cue_time);	// ...tell the user whats up...
			stage = in_flight;											// ...and advance to the next stage.
			}
		else if (In_FixWin &&  											// But if no saccade occurs...
			time() > cue_time + saccTimeMax && 					// ...and time for a saccade runs out...
			(trialType == goTrial || trialType == ignoreTrial))				// ...and a saccade was supposed to be made.
			{
			trialOutcome = goIncorrect;           							// TRIAL OUTCOME ERROR (incorrect go trial)
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (no saccade)\n");								// ...tell the user whats up...
			spawn SVR_BELL();
			trl_running = 0;											// ...and terminate the trial.
			}				
		else if (In_FixWin &&											// But if no saccade occurs...
			time() > cue_time + ssdMS + holdStopDuration && 				// ...and time for a saccade runs out...
			trialType == stopTrial)										// ...and a saccade was NOT supposed to be made...
			{
			nTrialPsySSD[psyIndex, decideIndex] = nTrialPsySSD[psyIndex, decideIndex] + 1;  //tally the stop trial (for exporting to excel)
			trialOutcome = nogoCorrect;   								// TRIAL OUTCOME CORRECT (canceled trial)
			lastOutcome = success;				// set the global for staircasing...
			nSuccess = nSuccess + 1;
			dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			Event_fifo[Set_event] = Correct_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			printf("Correct (canceled)\n");								// ...tell the user whats up...
			trl_running = 0;  											// ...and terminate the trial.
			}		
		}
		
		
		
//--------------------------------------------------------------------------------------------
// STAGE in_flight (eyes have left fixation window but have not entered target window)		
	else if (stage == in_flight)
		{
		// if (trialType == stopTrial)
			// {
		// spawn TONE(300,toneDuration);							// present negative tone
			// }
		if (In_TargWin)													// If the eyes get into the target window...
			{
			aquire_targ_time = time();									// ...record the time...
			Event_fifo[Set_event] = Decide_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			stage = on_target;											// ...and advance to the next stage of the trial.
			if (trialType == stopTrial)									// But if a saccade was the wrong thing to do...
				{												
				lastOutcome = failure;
				if (targIndex == targ1 || targIndex == targ1+2)
					{					
					nTarg1PsySSD[psyIndex, decideIndex] = nTarg1PsySSD[psyIndex, decideIndex] + 1;  //tally that it was a rightward response on stop trial (for exporting to excel)
					}
				nTrialPsySSD[psyIndex, decideIndex] = nTrialPsySSD[psyIndex, decideIndex] + 1;  //tally that it was a stop trial (for exporting to excel)
				nSaccPsySSD[psyIndex, decideIndex] = nSaccPsySSD[psyIndex, decideIndex] + 1;  //tally that it was a respond trial (for exporting to excel)
				Event_fifo[Set_event] = Error_sacc;						// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.
				}
			else 														// Otherwise...
				{								
				Event_fifo[Set_event] = Correct_;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
				}
			}
		else if (In_DistWin)											// If the eyes get into the distractor window...
			{
			aquire_dist_time = time();									// ...record the time...
			Event_fifo[Set_event] = Decide_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			stage = on_distractor;										// ...and advance to the next stage of the trial.
			if (trialType == stopTrial)									// But if a saccade was the wrong thing to do...
				{												
				lastOutcome = failure;
				if (targIndex == targ2 || targIndex == targ2+2)
					{					
					nTarg1PsySSD[psyIndex, decideIndex] = nTarg1PsySSD[psyIndex, decideIndex] + 1;  //tally that it was a rightward response on stop trial (for exporting to excel)
					}
				nTrialPsySSD[psyIndex, decideIndex] = nTrialPsySSD[psyIndex, decideIndex] + 1;  //tally that it was a stop trial (for exporting to excel)
				nSaccPsySSD[psyIndex, decideIndex] = nSaccPsySSD[psyIndex, decideIndex] + 1;  //tally that it was a respond trial (for exporting to excel)
				Event_fifo[Set_event] = Error_sacc;						// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.
				}
			else 														// Otherwise...
				{								
				Event_fifo[Set_event] = Distract_;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
				}
			}
		else if (In_ChkrWin)											// If the eyes get into the checker stimulus window...
			{
			aquire_chkr_time = time();									// ...record the time...
			trialOutcome = checkerAbort;   								// TRIAL OUTCOME ERROR (innacurrate saccade)
			if (trialType == stopTrial)									// But if a saccade was the wrong thing to do...
				{												
				lastOutcome = noChange;							// ...make sure that the last outcome is cleared.						
				}
				// lastOutcome = failure;								// ...record the failure.
				// }
			// else 														// Otherwise...
				// {								
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			spawn SVR_BELL();
			printf("Error (looked at checker stimulus)\n");				// ...tell the user whats up...
			trl_running = 0; 											// ...and terminate the trial.
			}
		else if (time() > saccade_time + saccDurationMax)				// But, if the eyes are out of the target window and time runs out...
			{
			trialOutcome = saccOut;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
			if (trialType == stopTrial)									// But if a saccade was the wrong thing to do...
				{												
				lastOutcome = noChange;							// ...make sure that the last outcome is cleared.						
				}
			// if (trialType == stopTrial)									// But if a saccade was the wrong thing to do...
				// {												
				// lastOutcome = failure;								// ...record the failure.
				// }
			// else 														// Otherwise...
				// {								
				// lastOutcome = noChange;							// ...make sure that the last outcome is cleared.						
				// }
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
			spawn SVR_BELL();
			trl_running = 0; 											// ...and terminate the trial.
			}
		}
	
	
	
//--------------------------------------------------------------------------------------------
// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)	
	else if (stage == on_target)
		{
		if (!In_TargWin)												// If the eyes left the target or distractor window...
			{			
			trialOutcome = brokeTarg;									// TRIAL OUTCOME ERROR (broke target fixation)
			// if (trialType == stopTrial)									// But if a saccade was the wrong thing to do...
				// {												
				// lastOutcome = failure;
				// }
			// else 														// Otherwise...
				// {								
				// lastOutcome = noChange;							// ...make sure that the last outcome is cleared.						
				// }
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
				Event_fifo[Set_event] = Correct_;						// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
				printf("Correct (saccade)\n");							// ...tell the user whats up...
				}
			else if (trialType == stopTrial)								// But if a saccade was the wrong thing to do...
				{
				trialOutcome = nogoTarg;								//TRIAL OUTCOME ERROR (noncanceled trial)
				printf("Error (noncanceled)\n");						// ...tell the user whats up...
				}														// Either way we are done, so...
			dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			trl_running = 0;											// ...and terminate the trial.
			}			
		}
		

// STAGE on_distractor (eyes have entered the distractor window.  will they remain there for duration?)	
	else if (stage == on_distractor)
		{
		if (!In_DistWin)												// If the eyes left the distractor or distractor window...
			{			
			trialOutcome = brokeDist;									// TRIAL OUTCOME ERROR (broke target fixation)
			// if (trialType == stopTrial)									// But if a saccade was the wrong thing to do...
				// {												
				// lastOutcome = failure;
				// }
			// else 														// Otherwise...
				// {								
				// lastOutcome = noChange;							// ...make sure that the last outcome is cleared.						
				// }
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (broke distractor fixation)\n");				// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}		
		else if (In_DistWin  											// But if the eyes are still in the target window...
			&&  time() > aquire_dist_time + targHoldtime)				// ...and the target hold time is up...
			{
			if (trialType == goTrial || trialType == ignoreTrial)			// ...and a saccade was the correct thing to do...
				{
				trialOutcome = goDist;								//TRIAL OUTCOME CORRECT (correct go trial)
				// Event_fifo[Set_event] = Correct_;// pgm need to change this?						// ...queue strobe...
				// Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
				printf("Error to distractor (saccade)\n");	//pgm						// ...tell the user whats up...
				}
			else if (trialType == stopTrial)								// But if a saccade was the wrong thing to do...
				{
				trialOutcome = nogoDist;							//TRIAL OUTCOME ERROR (noncanceled trial)
				printf("Error to distractor (noncanceled)\n");	//pgm					// ...tell the user whats up...
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
		// lastStopArray[ampIndex] = failure;
		dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
		oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
		oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
		printf("Aborted (body movement)\n");							// ...tell the user whats up...
		trl_running = 0; 											// ...and terminate the trial.
		}

		
	nexttick;
	}
}