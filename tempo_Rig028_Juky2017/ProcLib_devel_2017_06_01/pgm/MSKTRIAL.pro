//--------------------------------------------------------------------------------------------
// Run a reverse masking trial based on the variables calculated by SETCCTRL.pro and those 
// given by the user.
//

declare hide int lastOutcome = 1;	// Global output used to staircase SSD
declare int nSuccess;

declare MSKTRIAL();			// animated graph object

process MSKTRIAL()        		// animated graph object
{


// Number the trial stages to make them easier to read below
declare hide int 	need_fix  		= 1;
declare hide int 	fixating  		= 2;
declare hide int 	mask_on   		= 3;
declare hide int 	fix_off  		= 4;
declare hide int 	in_flight 		= 5;
declare hide int 	on_target 		= 6;	
declare hide int 	on_distractor 	= 7;	// pgm
declare hide int 	stage;

// number the pgs that need to be drawn: need to be same as MSK_PGS
declare hide int   	blank       		= 0;
declare hide int	fixation_pd			= 1;
declare hide int	fixation    		= 2;
declare hide int	fixation_target		= 3;
declare hide int	fix_mask_pd			= 4;
declare hide int	fix_mask    		= 5;
declare hide int	mask_pd   			= 6;
declare hide int	mask      			= 7;

											
// Timing variables which will be used to time task
declare hide float 	fix_spot_time; 					
declare hide float  targ_time; 					
declare hide float  mask_time; 					
declare hide float  fix_off_time; 					
declare hide float  saccade_time;
declare hide float 	aquire_fix_time;
declare hide float	aquire_targ_time;	
declare hide float	aquire_dist_time;	



opposite = ((screenHeight/2)-pdBottom);														// Figure out angle and eccentricity of photodiode marker in pixels
adjacent = ((screenWidth/2)-pdLeft);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
pdAmp = sqrt((opposite * opposite) + (adjacent * adjacent));
pdAngle = rad2deg(atan (opposite / adjacent));
pdAngle = pdAngle + 180; 																	//change this for different quadrent or write some code for flexibility


// Have to be reset on every iteration since 
// variable declaration only occurs at load time
trl_running 		= 1;
stage 				= need_fix;

// Tell the user what's up
printf(" \n");
printf(" ********   DECISION TRIAL  ********\n");
printf("# %d",nTrial);
printf(" (%d complete)\n",nTrialComplete);
printf("pre-target holdtime = %d\n",preTargHoldtime);
printf("post-target holdtime = %d\n",postTargHoldtime);
printf("               soa = %d\n",round(soa * (1000.0/screenRefreshRate)));


																		// HERE IS WHERE THE FUN BEGINS
Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
dsendf("vp %d\n",fixation_pd);											// flip the pg to the fixation stim with pd marker
fix_spot_time = time();  													// record the time
Event_fifo[Set_event] = FixSpotOn_;										// queue strobe
Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
dsendf("XM RFRSH:\n"); 													// wait for one retrace
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
			trialStartTime = aquire_fix_time;							// Global output for timing iti
			Event_fifo[Set_event] = DecFixate_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			stage = fixating;											// ...advance to the next stage.
			}
		else if (time() > fix_spot_time + allowFixTime)				// But if time runs out...
			{
			trialOutcome = noFix;    									// TRIAL OUTCOME ABORT (no fixation)
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
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
			trialOutcome = brokeFix;									// TRIAL OUTCOME ABORT (broke fixation)
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}
		else if (In_FixWin && time() > aquire_fix_time + preTargHoldtime)	// But if the eyes are still in the window at end of holdtime...
			{
			targ_time = time(); 										// ...record the time...
			dsendf("vp %d\n",fixation_target);						// ...flip the pg to the target with pd marker...	
			dsendf("vw %d\n",soa);							// Wait so many vertical retraces 
			dsendf("vp %d\n",fix_mask_pd);							// ...flip the pg to the signal with the pd marker...
			mask_time = targ_time + 
				(round(soa * (1000.0 / screenRefreshRate))); 		// ...record TEMPO time of presentation...
			dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
			dsendf("vp %d\n",fix_mask);								// ...and flip the pg to the signal without pd marker.
	

			oSetAttribute(object_targ, aVISIBLE); 						// ...show target in animated graph...
													
			stage = mask_on;											// Advance to the next trial stage.				
			}
		}
		
		

//--------------------------------------------------------------------------------------------
// STAGE mask_on (the subject is looking at the fixation point waiting for cue to make saccade)		
	else if (stage == mask_on)
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
		else if (In_FixWin && time() > mask_time + postTargHoldtime)	// But if the eyes are still in the window at end of holdtime...
			{
			dsendf("vp %d\n",mask_pd);								// ...flip the pg to the choice stim pd marker...	
			fix_off_time = time(); 										// ...record the time...
			dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
			dsendf("vp %d\n",mask);									// ...flip the pg to the choice stim without pd marker.

			oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
				
			stage = fix_off;											// Advance to the next trial stage.				
			}
		}
		
		

//--------------------------------------------------------------------------------------------
// STAGE fix_off (the fixation spot has been extinguished but the masks are still visible)		
	else if (stage == fix_off)
		{		
		if (!In_FixWin)													// If the eyes leave the fixation window...
			{															// ...we have a saccade, so...
			saccade_time = time();										// ...record the time...
			Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			printf("           rt = %d\n",saccade_time - fix_off_time);	// ...tell the user whats up...
			stage = in_flight;											// ...and advance to the next stage.
			}
		else if (In_FixWin &&  											// But if no saccade occurs...
			time() > fix_off_time + saccTimeMax)					// ...and time for a saccade runs out...
			{
			trialOutcome = noSacc;           							// TRIAL OUTCOME ERROR
			lastOutcome = noChange;								// Don't change SSD
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (no saccade)\n");								// ...tell the user whats up...
			spawn SVR_BELL();
			trl_running = 0;											// ...and terminate the trial.
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
			Event_fifo[Set_event] = Correct_;					// ...queue strobe for Neuro Explorer
			Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
			}
		else if (In_DistWin)											// If the eyes get into the distractor window...
			{
			aquire_dist_time = time();									// ...record the time...
			Event_fifo[Set_event] = Decide_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			stage = on_distractor;										// ...and advance to the next stage of the trial.
			Event_fifo[Set_event] = Distract_;					// ...queue strobe for Neuro Explorer
			Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
			}
		else if (time() > saccade_time + saccDurationMax)				// But, if the eyes are out of the target window and time runs out...
			{
			trialOutcome = saccOut;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
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
			lastOutcome = noChange;								// Don't change SSD
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (broke target fixation)\n");					// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}		
		else if (In_TargWin  											// But if the eyes are still in the target window...
			&&  time() > aquire_targ_time + targHoldtime)				// ...and the target hold time is up...
			{
			trialOutcome = saccTarg;								//TRIAL OUTCOME CORRECT (correct go trial)
			lastOutcome = success;
			printf("Correct (saccade)\n");							// ...tell the user whats up...
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
			lastOutcome = noChange;								// Don't change SSD
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (broke distractor fixation)\n");				// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}		
		else if (In_DistWin  											// But if the eyes are still in the target window...
			&&  time() > aquire_dist_time + targHoldtime)				// ...and the target hold time is up...
			{
			trialOutcome = saccDist;								//TRIAL OUTCOME CORRECT (correct go trial)
			lastOutcome = failure;								// Don't change SSD
			printf("Error to distractor (saccade)\n");	//pgm						// ...tell the user whats up...
			dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			trl_running = 0;											// ...and terminate the trial.
			}			
		}
		
	nexttick;
	}
}