//--------------------------------------------------------------------------------------------
// Run a memory guided saccade trial based on the variables calculated by SETV_TRL.pro and 
// those given by the user.  Adapted from CMDTRIAL.
//
// 11-2011: Created by adapting MEMTRIAL.pro -pgm


declare VISTRIAL();	
	
process VISTRIAL()        	
	{
	
	
	// Number the trial stages to make them easier to read below
	declare hide int 	need_fix  	= 1;
	declare hide int 	fixating  	= 2;
	declare hide int 	targ_on   	= 3;
	declare hide int	fix_off		= 4;
	declare hide int 	in_flight 	= 5;
	declare hide int 	on_target 	= 6;	
	declare hide int 	stage;
	
	// Number the stimuli pages to make reading easier
	declare hide int   	blank       		= 0;
	declare hide int	pd					= 1;
	declare hide int	fixation_pd 		= 2;
	declare hide int	fixation    		= 3;
	declare hide int	target_pd   		= 4;	
	declare hide int	target      		= 5;
	
	  
	// Timing variables which will be used to time task
	declare hide float 	fix_on_time; 	
	declare hide float 	aquire_fix_time;
	declare hide float  targ_time;	
	declare hide float  saccade_time;
	declare hide float	aquire_targ_time;	
	
	
	// Have to be reset on every iteration since 
	// variable declaration only occurs at load time
	trl_running 		= 1;
	stage 				= need_fix;
	
	// Tell the user what's up
	printf(" \n");
	printf("# %d\n",nTrial);

	
	
																			// HERE IS WHERE THE FUN BEGINS
	Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	dsendf("vp %d\n",fixation_pd);											// flip the pg to the fixation stim with pd marker
	fix_on_time = time();  													// record the time
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
				Event_fifo[Set_event] = Fixate_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = fixating;											// ...advance to the next stage.
				}
			else if (time() > fix_on_time + allowFixTime)				// But if time runs out...
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
			if (!In_FixWin && time() > aquire_fix_time + 100)													// If the eyes stray out of the fixation window...
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
				dsendf("vp %d\n",target_pd);						// ...flip the pg to the target with pd marker...	
				targ_time = time(); 										// ...record the time...
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				dsendf("vp %d\n",target);							// ...flip the pg to the target point without pd marker.
		
					
		
				oSetAttribute(object_targ, aVISIBLE); 						// ...show target in animated graph...
														
				stage = targ_on;											// Advance to the next trial stage.				
				}
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE targ_on (the target has been presented but the subject is still fixating)		
		else if (stage == targ_on)
			{		
			if (!In_FixWin)													// If the eyes leave the fixation window...			
				{															// ...we have a saccade, so...
				saccade_time = time();										// ...record the time...
				Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("                          rt = %d\n",saccade_time - targ_time);	// ...tell the user whats up...
				stage = in_flight;											// ...and advance to the next stage.
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > targ_time + saccTimeMax) 					// ...and time for a saccade runs out...
				{
				trialOutcome = noSacc;           							// TRIAL OUTCOME ERROR (no saccade after cue)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (no saccade)\n");								// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}	
			}


			
			
	//--------------------------------------------------------------------------------------------
	// STAGE in_flight (eyes have left fixation window but have not entered target window)		
		else if (stage == in_flight)
			{
			if (In_TargWin)													// If the eyes get into the target window...
				{
				// dsendf("vp %d\n",target_pd);								// ...flip the pg to the target with pd marker...	
				aquire_targ_time = time(); 									// ...record the time...
				// dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				// dsendf("vp %d\n",target);									// ...flip the pg to the target without pd marker.
				Event_fifo[Set_event] = Decide_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = on_target;											// ...and advance to the next stage of the trial.
				}
			else if (time() > saccade_time + saccDurationMax)				// But, if the eyes are out of the target window and time runs out...
				{
				trialOutcome = saccOut;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
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
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}		
			else if (In_TargWin  											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targHoldtime)				// ...and the target hold time is up...				
				{
				trialOutcome = saccTarg;									//TRIAL OUTCOME CORRECT (correct sacc trial)
				Event_fifo[Set_event] = Correct_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("Correct (saccade)\n");								// ...tell the user whats up...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
		nexttick;
		}
	}