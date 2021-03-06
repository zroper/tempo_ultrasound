//-------------------------------------------------------------------------------------------------------------------
// Records all of the parameters for a countermanding trial.  Should be sent during the inter trial interval while
// the communication lines are clear (no rdx communication with vdosync).  
// NOTES:
// 1) The order of these params is very important.  Matlab translation code identifies these parameters based on their
// order, so if you add more events, make sure to keep them in the same order in the matlab translation code.  (They 
// are currently in alphabetical order based on their Matlab variable names so that they are recorded in Infos_ in
// alphabetical order.
// 2) This process relies heavily on globals (since it is grabbing stuff from all over the protocol).
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011


declare INFOS();

process INFOS()
	{
	declare int stop_sig_color_r, stop_sig_color_g, stop_sig_color_b;
	declare int ignore_sig_color_r, ignore_sig_color_g, ignore_sig_color_b;
	declare int fixation_color_r, fixation_color_g, fixation_color_b;
	declare int target_color_r, target_color_g, target_color_b;
	
	stop_sig_color_r	= Stop_sig_color[0];
	stop_sig_color_g	= Stop_sig_color[1];
	stop_sig_color_b	= Stop_sig_color[2];
	                     
	ignore_sig_color_r	= Ignore_sig_color[0];
	ignore_sig_color_g	= Ignore_sig_color[1];
	ignore_sig_color_b	= Ignore_sig_color[2];
	
	fixation_color_r	= Fixation_color[0];
	fixation_color_g	= Fixation_color[1];
	fixation_color_b	= Fixation_color[2];
	                    
	target_color_r		= Color_list[Curr_target,0];
	target_color_g		= Color_list[Curr_target,1];
	target_color_b		= Color_list[Curr_target,2];
	
	Event_fifo[Set_event] = StartInfos_;								// Let Matlab know that trial infos are going to start streaming in...
	Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.
		
	//---------------------------------------------------------------------------------------------------------------------------------------
		Event_fifo[Set_event] = InfosZero + Allowed_fix_time;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Cancl_time;					// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Curr_ssd;					// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Curr_target;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Expo_jitter;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Failure_Tone;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Fix_win_size * 100);		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + fixation_color_b;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + fixation_color_g;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + fixation_color_r;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
		Event_fifo[Set_event] = InfosZero + (Fixation_size * 100);		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Fixed_trl_length;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Go_weight * 100);			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + ignore_sig_color_b;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + ignore_sig_color_g;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + ignore_sig_color_r;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Ignore_weight * 100);		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
		Event_fifo[Set_event] = InfosZero + Inter_trl_int;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Max_holdtime;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Max_sacc_duration;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Max_saccade_time;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Min_holdtime;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + N_SSDs;						// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Punish_time;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Reward_Duration;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Reward_Offset;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
		Event_fifo[Set_event] = InfosZero + Staircase;					// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + stop_sig_color_b;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + stop_sig_color_g;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + stop_sig_color_r;			// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Stop_weight * 100);		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Success_Tone;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Targ_win_size * 100);		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Angle;						// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + target_color_b;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + target_color_g;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + target_color_r;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Eccentricity * 100);		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Targ_hold_time;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Size * 100);				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Tone_Duration;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Trial_length;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
				
		Event_fifo[Set_event] = InfosZero + Trl_Outcome;				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + Trl_type;					// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (X_Gain * 100) + 1000;		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
		Event_fifo[Set_event] = InfosZero + (X_Offset * 100) + 1000;	// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
		Event_fifo[Set_event] = InfosZero + (Y_Gain * 100) + 1000;		// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
		Event_fifo[Set_event] = InfosZero + (Y_Offset * 100) + 1000;	// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
		
		Event_fifo[Set_event] = InfosZero + Curr_soa;					// Send event and... <-- added by Namsoo
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
				
		Event_fifo[Set_event] = InfosZero + Block_number;				// Send event and... <-- added by DCG
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
//---------------------------------------------------------------------------------------------------------------------------------------
		
	Event_fifo[Set_event] = EndInfos_;									// Let Matlab know that trial infos are finished streaming in...
	Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.	
	
	
	}