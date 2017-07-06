//--------------------------------------------------------------------------------------------
// Run a bet trial based on the variables calculated by SETCCTRL.pro and those 
// given by the user.
//

declare hide int lastOutcome = 1;	// Global output used to staircase SSD
declare int nSuccess;

declare BETTRIAL();			// animated graph object

process BETTRIAL()        		// animated graph object
{


// Number the trial stages to make them easier to read below
declare hide int 	need_fix  		= 1;
declare hide int 	fixating  		= 2;
declare hide int 	bet_on   		= 3;
declare hide int 	in_flight 		= 4;
declare hide int 	on_Highbet 		= 5;	
declare hide int 	on_Lowbet 		= 6;	
declare hide int 	stage;

// number the pgs that need to be drawn
declare hide int   	blank       		= 0;
declare hide int	pd					= 1;
declare hide int	betFix_pd			= 2;
declare hide int	betFix    			= 3;
declare hide int	fix_bet_pd			= 4;
declare hide int	fix_bet				= 5;

											
// Timing variables which will be used to time task
declare hide float 	fix_spot_time; 					
declare hide float  betTarg_time; 					
declare hide float  fix_off_time; 					
declare hide float  saccade_time;
declare hide float 	aquire_fix_time;
declare hide float	aquire_bet_time;	



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
printf(" ********   BET TRIAL   ********\n");
printf("# %d",nTrial);
printf(" (%d complete)\n",nTrialComplete);
printf("preBet Holdtime = %d\n",preBetHoldtime);


																		// HERE IS WHERE THE FUN BEGINS
Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
dsendf("vp %d\n",betFix_pd);											// flip the pg to the fixation stim with pd marker
fix_spot_time = time();  													// record the time
Event_fifo[Set_event] = FixSpotOn_;										// queue strobe
Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
dsendf("XM RFRSH:\n"); 													// wait for one retrace
dsendf("vp %d\n",betFix);												// flip the pg to the fixation stim without pd marker
oSetAttribute(object_fix, aVISIBLE); 									// turn on the fixation point in animated graph


while (trl_running)														// trials ending will set trl_running = 0
	{	
	
//--------------------------------------------------------------------------------------------
// STAGE need_fix (the fixation point is on, but the subject hasn't looked at it)
	if (stage == need_fix)
		{		
		if (In_FixWin && time() > aquire_fix_time + 200)													// If the eyes have entered the fixation window (before time, see below)...
			{
			aquire_fix_time = time();									// ...function call to time to note current time and...
			trialStartTime = aquire_fix_time;							// Global output for timing iti
			Event_fifo[Set_event] = BetFixate_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			stage = fixating;											// ...advance to the next stage.
			}
		else if (time() > fix_spot_time + allowFixTime)				// But if time runs out...
			{
			trialOutcome = noFix;    									// TRIAL OUTCOME ABORT (no fixation)
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
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
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}
		else if (In_FixWin && time() > aquire_fix_time + preBetHoldtime)	// But if the eyes are still in the window at end of holdtime...
			{
			dsendf("vp %d\n",fix_bet_pd);						// ...flip the pg to the target with pd marker...	
			betTarg_time = time(); 										// ...record the time...
			dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
			dsendf("vp %d\n",fix_bet);						// ...flip the pg to the target with pd marker...	
	
			oSetAttribute(object_highBet, aVISIBLE); 						// ...show target in animated graph...
			oSetAttribute(object_lowBet, aVISIBLE); 						// ...show target in animated graph...
													
			stage = bet_on;											// Advance to the next trial stage.				
			}
		}
		
		

	

//--------------------------------------------------------------------------------------------
// STAGE bet_on (the fixation spot has been extinguished but the masks are still visible)		
	else if (stage == bet_on)
		{		
		if (!In_FixWin)													// If the eyes leave the fixation window...
			{															// ...we have a saccade, so...
			saccade_time = time();										// ...record the time...
			Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			// dsendf("vp %d\n",target);									// Flip the pg to the blank screen...
			printf("           rt = %d\n",saccade_time - betTarg_time);	// ...tell the user whats up...
			stage = in_flight;											// ...and advance to the next stage.
			}
		else if (In_FixWin &&  											// But if no saccade occurs...
			time() > betTarg_time + saccTimeMax)					// ...and time for a saccade runs out...
			{
			trialOutcome = betAbort;           							// TRIAL OUTCOME ERROR
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_highBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_lowBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (no saccade)\n");								// ...tell the user whats up...
			spawn SVR_BELL();
			trl_running = 0;											// ...and terminate the trial.
			}				
		}
		
		
		
//--------------------------------------------------------------------------------------------
// STAGE in_flight (eyes have left fixation window but have not entered either bet window)		
	else if (stage == in_flight)
		{
		if (In_HighBetWin)													// If the eyes get into the target window...
			{
			aquire_bet_time = time();									// ...record the time...
			Event_fifo[Set_event] = Decide_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			stage = on_HighBet;											// ...and advance to the next stage of the trial.
			Event_fifo[Set_event] = HighBet_;					// ...queue strobe for Neuro Explorer
			Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
			}
		else if (In_LowBetWin)											// If the eyes get into the distractor window...
			{
			aquire_bet_time = time();									// ...record the time...
			Event_fifo[Set_event] = Decide_;							// ...queue strobe...
			Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
			stage = on_LowBet;										// ...and advance to the next stage of the trial.
			Event_fifo[Set_event] = LowBet_;					// ...queue strobe for Neuro Explorer
			Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
			}
		else if (time() > saccade_time + saccDurationMax)				// But, if the eyes are out of the target window and time runs out...
			{
			trialOutcome = betAbort;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_highBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_lowBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
			spawn SVR_BELL();
			trl_running = 0; 											// ...and terminate the trial.
			}
		}
	
	
	
//--------------------------------------------------------------------------------------------
// STAGE on_HighBet (eyes have entered the target window.  will they remain there for duration?)	
	else if (stage == on_HighBet)
		{
		if (!In_HighBetWin)												// If the eyes left the target or distractor window...
			{			
			trialOutcome = brokeBet;									// TRIAL OUTCOME ERROR (broke target fixation)
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_highBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_lowBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (broke bet target fixation)\n");					// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}		
		else if (In_HighBetWin  											// But if the eyes are still in the target window...
			&&  time() > aquire_bet_time + targHoldtime)				// ...and the target hold time is up...
			{
			betOutcome = highBet;								//TRIAL OUTCOME CORRECT (correct go trial)
			printf("High Bet (saccade)\n");							// ...tell the user whats up...
			dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
			oSetAttribute(object_highBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_lowBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			trl_running = 0;											// ...and terminate the trial.
			if (maskOutcome == saccTarg)
				{
				trialOutcome = targHighBet;
				}
			else if (maskOutcome == saccDist)
				{
				trialOutcome = distHighBet;
				}
			}			
		}
		

// STAGE on_LowBet (eyes have entered the distractor window.  will they remain there for duration?)	
	else if (stage == on_LowBet)
		{
		if (!In_LowBetWin)												// If the eyes left the distractor or distractor window...
			{			
			trialOutcome = brokeBet;									// TRIAL OUTCOME ERROR (broke target fixation)
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_highBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_lowBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			printf("Error (broke bet target fixation)\n");				// ...tell the user whats up...
			trl_running = 0;											// ...and terminate the trial.
			}		
		else if (In_LowBetWin  											// But if the eyes are still in the target window...
			&&  time() > aquire_bet_time + targHoldtime)				// ...and the target hold time is up...
			{
			betOutcome = lowBet;								//TRIAL OUTCOME CORRECT (correct go trial)
			printf("Low Bet (saccade)\n");	//pgm						// ...tell the user whats up...
			dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
			oSetAttribute(object_highBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_lowBet, aINVISIBLE); 					// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
			trl_running = 0;											// ...and terminate the trial.
			if (maskOutcome == saccTarg)
				{
				trialOutcome = targLowBet;
				}
			else if (maskOutcome == saccDist)
				{
				trialOutcome = distLowBet;
				}
			}			
		}
		
	nexttick;
	}
}