//--------------------------------------------------------------------------------------------
// Run a countermanding trial based on the variables calculated by SETC_TRL.pro and those 
// given by the user.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare hide int Trl_Outcome;			// Global output used in END_TRL
declare hide int Trl_Start_Time;		// Global output used in END_TRL
declare hide int LastStopOutcome = 1;	// Global output used to staircase SSD

declare CMDTRIAL(allowed_fix_time,		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime, 			// see SETC_TRL.pro
				trl_type, 				// see SETC_TRL.pro
				max_saccade_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_ssd, 				// see SETC_TRL.pro
				cancl_time,				// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,			// see ALL_VARS.pro and DEFAULT.pro
				object_fix);			// animated graph object

process CMDTRIAL(allowed_fix_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime,     		// see SETC_TRL.pro
				trl_type,          		// see SETC_TRL.pro
				max_saccade_time,  		// see ALL_VARS.pro and DEFAULT.pro
				curr_ssd,          		// see SETC_TRL.pro
				cancl_time,        		// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,    		// see ALL_VARS.pro and DEFAULT.pro
				object_fix)        		// animated graph object
	{
	

		 
	// Number the trial types to make them easier to read below
	declare hide int 	go_trl 		= 0;
	declare hide int 	stop_trl 	= 1;
	declare hide int 	ignore_trl 	= 2;
	
	// Number the trial stages to make them easier to read below
	declare hide int 	need_fix  	= 1;
	declare hide int 	fixating  	= 2;
	declare hide int 	searchon   	= 3;
	declare hide int 	in_flight 	= 4;
	declare hide int 	on_target 	= 5;	
	declare hide int 	stage;
	
	// Number the stimuli pages to make reading easier
	declare hide int   	blank       = 0;
	declare hide int	fixation_pd = 1;
	declare hide int	fixation    = 2;
	declare hide int	plac_pd    = 2;
	declare hide int	plac    = 2;	
	declare hide int	target_pd   = 3;
	declare hide int	target      = 4;
	declare hide int	signal_pd   = 5;
	declare hide int	signal      = 6;

	// Assign values to success and failure so they are more readable
	declare hide int	success		= 1;
	declare hide int	failure		= 0;
	declare hide int	no_change	= 2;
	
	// Code all possible outcomes
	declare hide int constant no_fix		= 1;	// never attained fixation
	declare hide int constant broke_fix		= 2;	// attained and then lost fixation before target presentation
	declare hide int constant go_wrong		= 3;	// never made saccade on a go trial
	declare hide int constant nogo_correct	= 4;	// successfully canceled trial
	declare hide int constant sacc_out		= 5;	// made an inaccurate saccade out of the target box
	declare hide int constant broke_targ	= 6;	// didn't hold fixation at the target for long enough
	declare hide int constant go_correct	= 7;	// correct saccade on a go trial
	declare hide int constant nogo_wrong	= 8;	// error noncanceled trial
	declare hide int constant body_move		= 12;	// error body movement (for training stillness)
	declare hide int constant too_fast		= 14;	// low RT while in training to slow down.
	                                        
	// Timing variables which will be used to time task
	declare hide float 	fix_spot_time;
	declare hide float  plac_time;	
	declare hide float  targ_time; 					
	declare hide float  saccade_time;
	declare hide float 	aquire_fix_time;
	declare hide float 	stop_sig_time;
	declare hide float	aquire_targ_time;	
	
	// This variable makes the while loop work
	declare hide int 	trl_running;
	
	// Have to be reset on every iteration since 
	// variable declaration only occurs at load time
	trl_running 		= 1;
	stage 				= need_fix;
	
	

	
	// Tell the user what's up
	printf(" \n");
	printf("# %d",Trl_number);
	printf(" (%d",Comp_Trl_number);
	printf(" correct)\n");
	if (trl_type == go_trl)
		{
		printf("GO\n");
		printf("holdtime = %d\n",curr_holdtime);
		}
	if (trl_type == stop_trl)
		{
		printf("STOP\n");
		printf("holdtime = %d\n",curr_holdtime);
		printf("               ssd = %d\n",round(curr_ssd * (1000.0/Refresh_rate)));
		}
	if (trl_type == ignore_trl)
		{
		printf("IGNORE\n");
		printf("holdtime = %d\n",curr_holdtime);
		printf("               isd = %d\n",round(curr_ssd * (1000.0/Refresh_rate)));
		}
	
	
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
				Trl_Start_Time = aquire_fix_time;							// Global output
				Event_fifo[Set_event] = Fixate_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = fixating;											// ...advance to the next stage.
				}
			else if (time() > fix_spot_time + allowed_fix_time)				// But if time runs out...
				{
				Trl_Outcome = no_fix;    									// TRIAL OUTCOME ERROR (no fixation)
				LastStopOutcome = no_change;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (no fixation)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE fixating (the subject is looking at the fixation point waiting for placeholders to onset)		
		else if (stage == fixating)
			{
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				LastStopOutcome = no_change;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)	// But if the eyes are still in the window at end of holdtime...
				{
				dsendf("vp %d\n",plac_pd);								// ...flip the pg to the paceholders with pd marker...	
				plac_time = time(); 										// ...record the time...
				dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
				dsendf("vp %d\n",plac);									// ...flip the pg to the target without pd marker.
				wait 2000;
				
				Event_fifo[Set_event] = FixSpotOff_;						// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			
				oSetAttribute(object_targ, aVISIBLE); 					// ...show target in animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
					
				stage = search_on;											// Advance to the next trial stage.				
				}
			}
			
			
//--------------------------------------------------------------------------------------------
// STAGE Search array onset (the subject is looking at the fixation point waiting for search array onset)		
		else if (stage == search_on)
			{
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				LastStopOutcome = no_change;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)	// But if the eyes are still in the window at end of holdtime...
				{
				dsendf("vp %d\n",target_pd);								// ...flip the pg to the target with pd marker...	
				targ_time = time(); 										// ...record the time...
				dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
				dsendf("vp %d\n",target);									// ...flip the pg to the target without pd marker.
				
				if (trl_type == stop_trl ||									// If it is a stop or ignore trial present the signal.
				trl_type == ignore_trl)										// This happens here so that no overhead intervenes between commands.
					{														// That way the # of vertical retraces remains independant of incidental processing time.
																			// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)
					dsendf("vw %d\n",curr_ssd-1);							// Wait so many vertical retraces (one is waited implicitly b/c photodiode marker above)...
					dsendf("vp %d\n",signal_pd);							// ...flip the pg to the signal with the pd marker...
					stop_sig_time = targ_time + 
						(round(curr_ssd * (1000.0 / Refresh_rate))); 		// ...record TEMPO time of presentation...
					dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
					dsendf("vp %d\n",signal);								// ...and flip the pg to the signal without pd marker.
					}
					
				Event_fifo[Set_event] = FixSpotOff_;						// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				
																			// Now the animated graphs have to catch up (seperate so that stim timing stays tight)
				if (trl_type == go_trl)										// If the trial is a go trial...
					{
					oSetAttribute(object_targ, aVISIBLE); 					// ...show target in animated graph...
					oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
					}
				else if (trl_type == ignore_trl)							// But if the trial is an ignore trial
					{
					oSetAttribute(object_targ, aVISIBLE); 					// ...just show target in animated graph (fixation point stays on).
					}														// If it is a stop trial the target just never comes up in the animated graph.
					
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
				if (saccade_time - targ_time < Min_saccade_time)
					{
					Trl_Outcome = too_fast; 								// TRIAL OUTCOME TOO FAST (too fast while being trained to slow down)
					LastStopOutcome = no_change;							// Don't change SSD
					dsendf("vp %d\n",blank);								// Flip the pg to the blank screen...
					oSetAttribute(object_targ, aINVISIBLE); 				// ...remove target from animated graph...
					oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph...
					printf("Error (too fast)\n");							// ...tell the user whats up...
					trl_running = 0;										// ...and terminate the trial.
					}
				}
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > targ_time + max_saccade_time)				// ...and a saccade was supposed to be made.
				{
				Trl_Outcome = go_wrong;           							// TRIAL OUTCOME ERROR (incorrect go trial)
				LastStopOutcome = no_change;								// Don't change SSD
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
								
				Event_fifo[Set_event] = Correct_sacc;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.										
				}
			else if (time() > saccade_time + max_sacc_duration)				// But, if the eyes are out of the target window and time runs out...
				{
				Trl_Outcome = sacc_out;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
				LastStopOutcome = no_change;							// ...make sure that the last outcome is cleared.						
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
				Trl_Outcome = broke_targ;									// TRIAL OUTCOME ERROR (broke target fixation)				
				LastStopOutcome = no_change;							// ...make sure that the last outcome is cleared.						
				
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}		
			else if (In_TargWin  											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targ_hold_time)				// ...and the target hold time is up...
				{

					Trl_Outcome = go_correct;								//TRIAL OUTCOME CORRECT (correct go trial)
					LastStopOutcome = no_change;							// Don't change SSD
					Correct_trls = Correct_trls + 1;						// ...set a global for 1DR...
					Event_fifo[Set_event] = Correct_;						// ...queue strobe...
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
					printf("Correct (saccade)\n");							// ...tell the user whats up...
					}
																			// Either way we are done, so...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
		if (Move_ct > 0)
			{
			Trl_Outcome = body_move;   										// TRIAL OUTCOME ABORTED (the body was moving)
			LastStopOutcome = no_change;									// ...make sure that the last outcome is cleared.	
			dsendf("vp %d\n",blank);										// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 						// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 							// ...remove fixation point from animated graph...
			printf("Aborted (body movement)\n");							// ...tell the user whats up...
			trl_running = 0; 												// ...and terminate the trial.
			}	
			
		nexttick;
		}
	}