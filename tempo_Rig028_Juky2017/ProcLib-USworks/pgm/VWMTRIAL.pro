//--------------------------------------------------------------------------------------------
// Run a memory guided saccade trial based on the variables calculated by SETM_TRL.pro and 
// those given by the user.  Adapted from CMDTRIAL.
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011


declare VWMTRIAL();			// animated graph object

process VWMTRIAL()        		// animated graph object
	{
	
	
	// Number the trial stages to make them easier to read below
	declare hide int 	need_fix  	= 1;
	declare hide int 	fixating  	= 2;
	declare hide int 	targ_off   	= 3;
	declare hide int	same		= 4;
	declare hide int	diff		= 5;
	declare hide int 	in_flight 	= 6;
	declare hide int 	on_target 	= 7;	
	declare hide int 	test_hold 	= 8;
	declare hide int 	stage;
	
	// Number the stimuli pages to make reading easier
	declare hide int   	blank       		= 0;
	declare hide int	pd					= 1;
	declare hide int	fixation_pd 		= 2;
	declare hide int	fixation    		= 3;
	declare hide int	fixation_target_pd	= 4;
	declare hide int	fixation_target	= 5;
	declare hide int	test_pd   		= 6;	
	declare hide int	test      		= 7;
	declare hide int	emove      		= 8;

	
		  
	// Timing variables which will be used to time task
	declare hide float 	fix_on_time; 	
	declare hide float 	aquire_fix_time;
	declare hide float  targ_time;	
	declare hide float	fix_off_time;
	declare hide float  saccade_time;
	declare hide float	aquire_targ_time;	
	declare hide float test_on_time;
	declare hide float test_off_time;
	
	
	// Have to be reset on every iteration since 
	// variable declaration only occurs at load time
	trl_running 		= 1;
	stage 				= need_fix;
	
	// Tell the user what's up
	printf("\n# %d\n",nTrial);
	printf("Hold time:     %d\n",  soa);

	
	
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
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				trialOutcome = brokeFix;									// TRIAL OUTCOME ABORT (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				vwm_performance[18+setsize-1] = vwm_performance[18+setsize-1]+1; // ...update performance monitor
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + fixDuration)	// But if the eyes are still in the window at end of holdtime...
				{
				dsendf("vp %d\n",fixation_target_pd);						// ...flip the pg to the target with pd marker...	
				targ_time = time(); 										// ...record the time...
				Event_fifo[Set_event] = MemOn_;						// Queue strobe... #need to change 
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				dsendf("vp %d\n",fixation_target);						// ...flip the pg to the target with pd marker...	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
					dsendf("vw %d\n",memRefresh-1);							// Wait so many vertical retraces (one is waited implicitly b/c photodiode marker above)...
					
				dsendf("vp %d\n",fixation);									// ...flip the pg to the fixation point without pd marker.
								
				

				oSetAttribute(object_targ, aVISIBLE); 						// ...show target in animated graph...
				//here also provide set size and loc info as eventcodes!
				Event_fifo[Set_event] = 10000+setsize;
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 20000+LocArray[0];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 20000+LocArray[1];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 20000+LocArray[2];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 20000+LocArray[3];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 20000+LocArray[4];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 30000+ColorArray[0];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 30000+ColorArray[1];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 30000+ColorArray[2];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 30000+ColorArray[3];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				Event_fifo[Set_event] = 30000+ColorArray[4];
				Set_event = (Set_event + 1) % Event_fifo_N;	
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				
														
				stage = targ_off;											// Advance to the next trial stage.				
				}
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE targ_off (the target has been presented and disappeared but the subject is still fixating)		
		else if (stage == targ_off)
			{		
			if (!In_FixWin)													// If the eyes leave the fixation window...
				{
				trialOutcome = saccEarly;									// TRIAL OUTCOME ERROR (sacc before cued to do so)
				
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (early saccade)\n");							// ...tell the user whats up...
				vwm_performance[18+setsize-1] = vwm_performance[18+setsize-1]+1; // ...update performance monitor
				trl_running = 0;											// ...and terminate the trial.
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > targ_time + retDuration)	 							// ...and the stim onset asychrony passes...
				{

					dsendf("vp %d\n",pd);	//test_pd									// Flip the pg to the blank screen with the photodiode marker...
					// dsendf("vp %d\n",target_pd);										// DELAY TASK  Flip the pg to the target screen with the photodiode marker...
					fix_off_time = time();										// ...and record the time that the fixation point was extinguished.
					test_on_time = time();
					Event_fifo[Set_event] = TestOn_;						// Queue strobe... #need to change 
					Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
					dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
					dsendf("vp %d\n",test);									// ...flip the pg to the same screen without pd marker.
					// dsendf("vp %d\n",target);									// .DELAY TASK..flip the pg to the target screen without pd marker.
					oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
					stage = test_hold;

				}	
			}



	//--------------------------------------------------------------------------------------------
	// STAGE SAME (the fixation point has been turned off but the subject is still fixating)		
		else if (stage == test_hold)
			{
			if (!In_FixWin)													// If the eyes leave the fixation window...			
				{															// ...we have a saccade, so...
				trialOutcome = saccEarly;									// TRIAL OUTCOME ERROR (sacc before cued to do so)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (early saccade)\n");							// ...tell the user whats up...
				vwm_performance[18+setsize-1] = vwm_performance[18+setsize-1]+1; // ...update performance monitor
				trl_running = 0;											// ...and advance to the next stage.
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > fix_off_time + testHoldDuration) 					// ...and time for a saccade runs out...
				{
				//dsendf("vp %d\n",pd);									// Flip the pg to the blank screen...
				dsendf("vp %d\n",pd);//pd	
				test_off_time = time();										// ...and record the time that the fixation point was extinguished.
				Event_fifo[Set_event] = TestOff_;						// Queue strobe... #need to change 
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				if (samediff == 1)
						{
						stage = same;											// ...and advance to the next stage.
						}
					else if (samediff == 2)
						{
						stage = diff;
						}
				}	
	
			}			
			
	//--------------------------------------------------------------------------------------------
	// STAGE SAME (the fixation point has been turned off but the subject is still fixating)		
		else if (stage == same)
			{
			if (!In_FixWin)													// If the eyes leave the fixation window...			
				{															// ...we have a saccade, so...
				saccade_time = time();										// ...record the time...
				Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("                          rt = %d\n",saccade_time - fix_off_time);	// ...tell the user whats up...
				stage = in_flight;											// ...and advance to the next stage.
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > test_off_time + testDuration) 					// ...and time for a saccade runs out...
				{
				trialOutcome = miss;           							// TRIAL OUTCOME ERROR (no saccade after cue)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (miss)\n");								// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}	
			}	
	//-------------------------------------------------------------------------------------------------------------------------------------
	// STAGE Diff (the fixation point has been turned off but the subject is still fixating)		
		else if (stage == diff)
			{
			if (!In_FixWin)													// If the eyes leave the fixation window...			
				{															// ...we have a saccade, so...
				trialOutcome = fa;  
				saccade_time = time();										// ...record the time...
				Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("                          rt = %d\n",saccade_time - fix_off_time);	// ...tell the user whats up...

				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (false alarm)\n");								// ...tell the user whats up...
				trl_running = 0;	
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > fix_off_time + testDuration) 					// ...and time for a saccade runs out...
				{
				stage = on_target;											// ...and advance to the next stage of the trial.
				}	
			}				
			
			
	//--------------------------------------------------------------------------------------------
	// STAGE in_flight (eyes have left fixation window but have not entered target window)		
		else if (stage == in_flight)
			{
			if (In_TargWin)													// If the eyes get into the target window...
				{
				//dsendf("vp %d\n",blank);									// turn on the target again to reinforce the idea
				aquire_targ_time = time(); 									// ...record the time...
				Event_fifo[Set_event] = Decide_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = on_target;											// ...and advance to the next stage of the trial.
				}
			else if (time() > saccade_time + testDuration)				// But, if the eyes are out of the target window and time runs out...
				{
				trialOutcome = hitIncSac;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
				vwm_performance[6+setsize-1] = vwm_performance[6+setsize-1]+1; // ...update performance monitor
				trl_running = 0; 											// ...and terminate the trial.
				}
			}
		
		
		
	//--------------------------------------------------------------------------------------------
	// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)	
		else if (stage == on_target)
			{
			if (!In_Targwin)													// If the eyes stray out of the fixation window...
				{			
				trialOutcome = brokeTarg;									// TRIAL OUTCOME ERROR (broke target fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				vwm_performance[12+setsize-1] = vwm_performance[12+setsize-1]+1; // ...update performance monitor
				trl_running = 0;											// ...and terminate the trial.
				}		
			else if (In_TargWin 											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targHoldtime)				// ...and the target hold time is up...				
				{
				trialOutcome = hitCorSac;									//TRIAL OUTCOME CORRECT (correct sacc trial)
				Event_fifo[Set_event] = Correct_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("Correct (saccade)\n");								// ...tell the user whats up...
				vwm_performance[0+setsize-1] = vwm_performance[0+setsize-1]+1; // ...update performance monitor
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
		nexttick;
		}
	}