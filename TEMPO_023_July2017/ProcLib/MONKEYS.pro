// Set up default variables for the monkey you want to test
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare MONKEYS(int monkey);

process MONKEYS(int monkey)
	{
	declare hide int fechner 	= 1;
	declare hide int xena    	= 2;
	declare hide int yoyo    	= 3;
	declare hide int archimedes	= 4;
	declare hide int r_, g_, b_;
	r_ = 0; g_ = 1; b_ = 2;
	
	
	//--------------------------------------------------------------------------------------------------------------------
	// Fechner
	if(monkey == fechner)
		{		
		
		Subj_dist     = 430.0; 			// distance from center of subjects eyeball to screen	
				
		//----------------------------------------------------------------------------------------------------------------
		// Trial type distributions (MUST SUM TO 100)
		Go_weight				= 50.0;
		Stop_weight				= 50.0;
		Ignore_weight			= 0;
		
		Bonus_weight			= 0.0;	// percentage of time that the subject is wrong but gets rewarded anyway.
		Dealer_wins_weight		= 0.0;	// percentage of time that the subject is right but gets punished anyway.

		BigR_weight				= 33.33;// weights for random changes of reward size
		MedR_weight				= 33.34;// weights for random changes of reward size
		SmlR_weight				= 33.33;// weights for random changes of reward size
		SmlP_weight				= 33.33;// weights for random changes of punsiment size
		MedP_weight				= 33.34;// weights for random changes of punsiment size
		BigP_weight				= 33.33;// weights for random changes of punsiment size



		//----------------------------------------------------------------------------------------------------------------
		// Stimulus properties
		// Blue can also be used
		// iso luminant value is 0,0,52;
		Classic					= 0;
		
		Stop_sig_color[r_]		= 50;	
		Stop_sig_color[g_]		= 0;	
		Stop_sig_color[b_]		= 21;	
		
		Ignore_sig_color[r_]	= 0;	
		Ignore_sig_color[g_]	= 17;	
		Ignore_sig_color[b_]	= 0;	
						   
		Fixation_color[r_]		= 33;	
		Fixation_color[g_]		= 30;	
		Fixation_color[b_]		= 30;	
		
		// Target colors
		Color_list[0,r_]		= 15;	// color of each target individually
		Color_list[0,g_]		= 15;	// color of each target individually
		Color_list[0,b_]		= 15;	// color of each target individually
						          
		Color_list[1,r_]		= 15;
		Color_list[1,g_]		= 15;
		Color_list[1,b_]		= 15;
						
		Color_list[2,r_]		= 0;
		Color_list[2,g_]		= 0;
		Color_list[2,b_]		= 0;
								  
		Color_list[3,r_]		= 0;
		Color_list[3,g_]		= 0;
		Color_list[3,b_]		= 0;
						          
		Color_list[4,r_]		= 0;
		Color_list[4,g_]		= 0;
		Color_list[4,b_]		= 0;
								  
		Color_list[5,r_]		= 0;
		Color_list[5,g_]		= 0;
		Color_list[5,b_]		= 0;
								  
		Color_list[6,r_]		= 0;
		Color_list[6,g_]		= 0;
		Color_list[6,b_]		= 0;
								  
		Color_list[7,r_]		= 0;
		Color_list[7,g_]		= 0;
		Color_list[7,b_]		= 0;
		
		// Target sizes
		Size_list[0]			= 3.0;	// size of each target individually (degrees)
		Size_list[1]			= 3.0;
		Size_list[2]			= 0;
		Size_list[3]			= 0;
		Size_list[4]			= 0;
		Size_list[5]			= 0;
		Size_list[6]			= 0;
		Size_list[7]			= 0;
		
		// Target angles
		Angle_list[0]			= 0;	// angle of each target individually (degrees)
		Angle_list[1]			= 180;
		Angle_list[2]			= 90;
		Angle_list[3]			= 135;
		Angle_list[4]			= 180;
		Angle_list[5]			= -135;
		Angle_list[6]			= -90;
		Angle_list[7]			= -45;
		
		// Target eccentricities
		Eccentricity_list[0]	= 10.0;	// distance of each target from center of screen individually (degrees)
		Eccentricity_list[1]	= 10.0;
		Eccentricity_list[2]	= 10.0;
		Eccentricity_list[3]	= 10.0;
		Eccentricity_list[4]	= 10.0;
		Eccentricity_list[5]	= 10.0;
		Eccentricity_list[6]	= 10.0;
		Eccentricity_list[7]	= 10.0;
		
		Fixation_size			= .5;	// size of the fixatoin point (degrees)	
		
		Success_Tone_bigR		= 100;	// positive secondary reinforcer in Hz (large reward)
		Success_Tone_medR		= 200;	// positive secondary reinforcer in Hz (medium reward)
		Success_Tone_smlR		= 400;	// positive secondary reinforcer in Hz (small reward)		
		Failure_Tone_smlP		= 800;	// negative secondary reinforcer in Hz (short timeout)
		Failure_Tone_medP		= 1600;	// negative secondary reinforcer in Hz (medium timeout)
		Failure_Tone_bigP		= 3200;	// negative secondary reinforcer in Hz (long timeout)	
		
		Fixation_Target 		= 0;	// Target number for the fixation task (not used here);

		//----------------------------------------------------------------------------------------------------------------
		// Eye related variables
		Fix_win_size			= 4;	// size of fixation window (degrees)
		Targ_win_size			= 5;	// size of target window (degrees)



		//----------------------------------------------------------------------------------------------------------------
		// Task timing paramaters (all times in ms unless otherwise specified)
		Allowed_fix_time		= 2000;	// subject has this long to acquire fixation before a new trial is initiated
		Expo_Jitter				= 1;	// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
		Min_Holdtime			= 600;  // minimum time after fixation before target presentation
		Max_Holdtime			= 1100; // maximum time after fixation before target presentation
		Max_saccade_time		= 800;	// subject has this long to saccade to the target
		Max_sacc_duration		= 60;	// once the eyes leave fixation they must be in the target before this time is up
		Targ_hold_time			= 600; 	// after saccade subject must hold fixation at target for this long
		Staircase				= 1;	// do we select the next SSD based on a staircasing algorithm?
		
		SSD_list[0]				= 2;	// needs to be in vertical retrace units
		SSD_list[1]				= 5;
		SSD_list[2]				= 8;
		SSD_list[3]				= 11;
		SSD_list[4]				= 14;
		SSD_list[5]				= 17;
		SSD_list[6]				= 20;
		SSD_list[7]				= 23;
		SSD_list[8]				= 26;
		SSD_list[9]				= 29;
		SSD_list[10]			= 0;
		SSD_list[11]			= 0;
		SSD_list[12]			= 0;
		SSD_list[13]			= 0;
		SSD_list[14]			= 0;
		SSD_list[15]			= 0;
		SSD_list[16]			= 0;
		SSD_list[17]			= 0;
		SSD_list[18]			= 0;
		SSD_list[19]			= 0;

		Cancl_time				= Max_saccade_time * 2;	// subject must hold fixation for this long on a stop trial to be deemed canceled
		Tone_Duration			= 30;	// how long should the error and success tones be presented?
		Base_Reward_time		= 80;	// medium time for the juice solonoid to remain open (monkeys are very interested in this varaible)
		Base_Punish_time		= 2000;	// medium time out for messing up (monkeys care less for this one)
		Fixed_trl_length		= 1;	// 1 for fixed trial length, 0 for fixied inter trial intervals
		Trial_length			= 0; 	// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
		Inter_trl_int			= 0;	// how long between trials (only works if Fixed_trl_length == 0)
		}
	
	
	
	//--------------------------------------------------------------------------------------------------------------------
	// Xena
	else if(Monkey == xena)
		{
		Subj_dist     = 475.0; 			// distance from center of subjects eyeball to screen	
				
		//----------------------------------------------------------------------------------------------------------------
		// Trial type distributions (MUST SUM TO 100)
		Go_weight				= 50.0;
		Stop_weight				= 50.0;
		Ignore_weight			= 0;
		
		Bonus_weight			= 0.0;	// percentage of time that the subject is wrong but gets rewarded anyway.
		Dealer_wins_weight		= 0.0;	// percentage of time that the subject is right but gets punished anyway.

		BigR_weight				= 33.33;// weights for random changes of reward size
		MedR_weight				= 33.34;// weights for random changes of reward size
		SmlR_weight				= 33.33;// weights for random changes of reward size
		SmlP_weight				= 33.33;// weights for random changes of punsiment size
		MedP_weight				= 33.34;// weights for random changes of punsiment size
		BigP_weight				= 33.33;// weights for random changes of punsiment size



		//----------------------------------------------------------------------------------------------------------------
		// Stimulus properties
		// Blue can also be used
		// iso luminant value is 0,0,52;
		Classic					= 0;
		
		Stop_sig_color[r_]		= 0;	
		Stop_sig_color[g_]		= 33;	
		Stop_sig_color[b_]		= 10;			
		
		Ignore_sig_color[r_]	= 50;	
		Ignore_sig_color[g_]	= 0;	
		Ignore_sig_color[b_]	= 21;	
						   
		Fixation_color[r_]		= 33;	
		Fixation_color[g_]		= 30;	
		Fixation_color[b_]		= 30;	
		
		// Target colors
		Color_list[0,r_]		= 15;	// color of each target individually
		Color_list[0,g_]		= 15;	// color of each target individually
		Color_list[0,b_]		= 15;	// color of each target individually
						          
		Color_list[1,r_]		= 15;
		Color_list[1,g_]		= 15;
		Color_list[1,b_]		= 15;
						          
		Color_list[2,r_]		= 0;
		Color_list[2,g_]		= 0;
		Color_list[2,b_]		= 0;
								  
		Color_list[3,r_]		= 0;
		Color_list[3,g_]		= 0;
		Color_list[3,b_]		= 0;
						          
		Color_list[4,r_]		= 0;
		Color_list[4,g_]		= 0;
		Color_list[4,b_]		= 0;
								  
		Color_list[5,r_]		= 0;
		Color_list[5,g_]		= 0;
		Color_list[5,b_]		= 0;
								  
		Color_list[6,r_]		= 0;
		Color_list[6,g_]		= 0;
		Color_list[6,b_]		= 0;
								  
		Color_list[7,r_]		= 0;
		Color_list[7,g_]		= 0;
		Color_list[7,b_]		= 0;
		
		// Target sizes
		Size_list[0]			= 3.0;	// size of each target individually (degrees)
		Size_list[1]			= 3.0;
		Size_list[2]			= 0;
		Size_list[3]			= 0;
		Size_list[4]			= 0;
		Size_list[5]			= 0;
		Size_list[6]			= 0;
		Size_list[7]			= 0;
		
		// Target angles
		Angle_list[0]			= 0;	// angle of each target individually (degrees)
		Angle_list[1]			= 180;
		Angle_list[2]			= 90;
		Angle_list[3]			= 135;
		Angle_list[4]			= 180;
		Angle_list[5]			= -135;
		Angle_list[6]			= -90;
		Angle_list[7]			= -45;
		
		// Target eccentricities
		Eccentricity_list[0]	= 10.0;	// distance of each target from center of screen individually (degrees)
		Eccentricity_list[1]	= 10.0;
		Eccentricity_list[2]	= 10.0;
		Eccentricity_list[3]	= 10.0;
		Eccentricity_list[4]	= 10.0;
		Eccentricity_list[5]	= 10.0;
		Eccentricity_list[6]	= 10.0;
		Eccentricity_list[7]	= 10.0;
		
		Fixation_size			= .5;	// size of the fixation point (degrees)	
		
		Set_Tones				= 1;	// high tones will be used to signal reward	
		
		Fixation_Target 		= 0;	// Target number for the fixation task (not used here);

		//----------------------------------------------------------------------------------------------------------------
		// Eye related variables
		Fix_win_size			= 4;	// size of fixation window (degrees)
		Targ_win_size			= 6;	// size of target window (degrees)



		//----------------------------------------------------------------------------------------------------------------
		// Task timing paramaters (all times in ms unless otherwise specified)
		Allowed_fix_time		= 1000;	// subject has this long to acquire fixation before a new trial is initiated
		Expo_Jitter				= 1;	// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
		Min_Holdtime			= 600;  // minimum time after fixation before target presentation
		Max_Holdtime			= 1100; // maximum time after fixation before target presentation
		Max_saccade_time		= 1200;	// subject has this long to saccade to the target
		Max_sacc_duration		= 60;	// once the eyes leave fixation they must be in the target before this time is up
		Targ_hold_time			= 600; 	// after saccade subject must hold fixation at target for this long
		Staircase				= 1;	// do we select the next SSD based on a staircasing algorithm?
		
		SSD_list[0]				= 3;	// needs to be in vertical retrace units
		SSD_list[1]				= 10;
		SSD_list[2]				= 17;
		SSD_list[3]				= 24;
		SSD_list[4]				= 31;
		SSD_list[5]				= 38;
		SSD_list[6]				= 45;
		SSD_list[7]				= 52;
		SSD_list[8]				= 59;
		SSD_list[9]				= 66;
		SSD_list[10]			= 73;
		SSD_list[11]			= 80;
		SSD_list[12]			= 0;
		SSD_list[13]			= 0;
		SSD_list[14]			= 0;
		SSD_list[15]			= 0;
		SSD_list[16]			= 0;
		SSD_list[17]			= 0;
		SSD_list[18]			= 0;
		SSD_list[19]			= 0;

		Cancl_time				= Max_saccade_time * 2;	// subject must hold fixation for this long on a stop trial to be deemed canceled
		Tone_Duration			= 30;	// how long should the error and success tones be presented?
		Base_Reward_time		= 30;	// medium time for the juice solonoid to remain open (monkeys are very interested in this varaible)
		Base_Punish_time		= 1400;	// medium time out for messing up (monkeys care less for this one)
		Fixed_trl_length		= 1;	// 1 for fixed trial length, 0 for fixied inter trial intervals
		Trial_length			= 0; 	// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
		Inter_trl_int			= 0;	// how long between trials (only works if Fixed_trl_length == 0)
		}
	
	
	//--------------------------------------------------------------------------------------------------------------------
	// Yoyo
	else if(Monkey == yoyo)
		{
		Subj_dist     = 455.0; 			// distance from center of subjects eyeball to screen	
				
		//----------------------------------------------------------------------------------------------------------------
		// Trial type distributions (MUST SUM TO 100)
		Go_weight				= 33.34;
		Stop_weight				= 33.33;
		Ignore_weight			= 33.33;
		
		Bonus_weight			= 0.0;	// percentage of time that the subject is wrong but gets rewarded anyway.
		Dealer_wins_weight		= 0.0;	// percentage of time that the subject is right but gets punished anyway.

		BigR_weight				= 33.33;// weights for random changes of reward size
		MedR_weight				= 33.34;// weights for random changes of reward size
		SmlR_weight				= 33.33;// weights for random changes of reward size
		SmlP_weight				= 33.33;// weights for random changes of punsiment size
		MedP_weight				= 33.34;// weights for random changes of punsiment size
		BigP_weight				= 33.33;// weights for random changes of punsiment size



		//----------------------------------------------------------------------------------------------------------------
		// Stimulus properties
		// Blue can also be used
		// iso luminant value is 0,0,52;
		Classic					= 0;
		
		Stop_sig_color[r_]		= 0;	
		Stop_sig_color[g_]		= 33;	
		Stop_sig_color[b_]		= 10;			
		
		Ignore_sig_color[r_]	= 20;	
		Ignore_sig_color[g_]	= 0;	
		Ignore_sig_color[b_]	= 0;	
						   
		Fixation_color[r_]		= 33;	
		Fixation_color[g_]		= 30;	
		Fixation_color[b_]		= 30;	
		
		// Target colors
		Color_list[0,r_]		= 15;	// color of each target individually
		Color_list[0,g_]		= 15;	// color of each target individually
		Color_list[0,b_]		= 15;	// color of each target individually
						
		Color_list[1,r_]		= 15;
		Color_list[1,g_]		= 15;
		Color_list[1,b_]		= 15;
						
		Color_list[2,r_]		= 0;
		Color_list[2,g_]		= 0;
		Color_list[2,b_]		= 0;
								  
		Color_list[3,r_]		= 0;
		Color_list[3,g_]		= 0;
		Color_list[3,b_]		= 0;
						          
		Color_list[4,r_]		= 0;
		Color_list[4,g_]		= 0;
		Color_list[4,b_]		= 0;
								  
		Color_list[5,r_]		= 0;
		Color_list[5,g_]		= 0;
		Color_list[5,b_]		= 0;
								  
		Color_list[6,r_]		= 0;
		Color_list[6,g_]		= 0;
		Color_list[6,b_]		= 0;
								  
		Color_list[7,r_]		= 0;
		Color_list[7,g_]		= 0;
		Color_list[7,b_]		= 0;
		
		// Target sizes
		Size_list[0]			= 3.0;	// size of each target individually (degrees)
		Size_list[1]			= 3.0;
		Size_list[2]			= 0;
		Size_list[3]			= 0;
		Size_list[4]			= 0;
		Size_list[5]			= 0;
		Size_list[6]			= 0;
		Size_list[7]			= 0;
		
		// Target angles
		Angle_list[0]			= 0;	// angle of each target individually (degrees)
		Angle_list[1]			= 180;
		Angle_list[2]			= 90;
		Angle_list[3]			= 135;
		Angle_list[4]			= 180;
		Angle_list[5]			= -135;
		Angle_list[6]			= -90;
		Angle_list[7]			= -45;
		
		// Target eccentricities
		Eccentricity_list[0]	= 10.0;	// distance of each target from center of screen individually (degrees)
		Eccentricity_list[1]	= 10.0;
		Eccentricity_list[2]	= 10.0;
		Eccentricity_list[3]	= 10.0;
		Eccentricity_list[4]	= 10.0;
		Eccentricity_list[5]	= 10.0;
		Eccentricity_list[6]	= 10.0;
		Eccentricity_list[7]	= 10.0;
		
		Fixation_size			= .5;	// size of the fixation point (degrees)	
		
		Success_Tone_bigR		= 100;	// positive secondary reinforcer in Hz (large reward)
		Success_Tone_medR		= 200;	// positive secondary reinforcer in Hz (medium reward)
		Success_Tone_smlR		= 400;	// positive secondary reinforcer in Hz (small reward)		
		Failure_Tone_smlP		= 800;	// negative secondary reinforcer in Hz (short timeout)
		Failure_Tone_medP		= 1600;	// negative secondary reinforcer in Hz (medium timeout)
		Failure_Tone_bigP		= 3200;	// negative secondary reinforcer in Hz (long timeout)	
		
		Fixation_Target 		= 0;	// Target number for the fixation task (not used here);

		//----------------------------------------------------------------------------------------------------------------
		// Eye related variables
		Fix_win_size			= 2.5;	// size of fixation window (degrees)
		Targ_win_size			= 5;	// size of target window (degrees)



		//----------------------------------------------------------------------------------------------------------------
		// Task timing paramaters (all times in ms unless otherwise specified)
		Allowed_fix_time		= 2000;	// subject has this long to acquire fixation before a new trial is initiated
		Expo_Jitter				= 1;	// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
		Min_Holdtime			= 600;  // minimum time after fixation before target presentation
		Max_Holdtime			= 1100; // maximum time after fixation before target presentation
		Max_saccade_time		= 800;	// subject has this long to saccade to the target
		Max_sacc_duration		= 60;	// once the eyes leave fixation they must be in the target before this time is up
		Targ_hold_time			= 600; 	// after saccade subject must hold fixation at target for this long
		Staircase				= 1;	// do we select the next SSD based on a staircasing algorithm?
		
		SSD_list[0]				= 3;	// needs to be in vertical retrace units
		SSD_list[1]				= 8;
		SSD_list[2]				= 13;
		SSD_list[3]				= 18;
		SSD_list[4]				= 23;
		SSD_list[5]				= 28;
		SSD_list[6]				= 33;
		SSD_list[7]				= 38;
		SSD_list[8]				= 43;
		SSD_list[9]				= 0;
		SSD_list[10]			= 0;
		SSD_list[11]			= 0;
		SSD_list[12]			= 0;
		SSD_list[13]			= 0;
		SSD_list[14]			= 0;
		SSD_list[15]			= 0;
		SSD_list[16]			= 0;
		SSD_list[17]			= 0;
		SSD_list[18]			= 0;
		SSD_list[19]			= 0;

		Cancl_time				= Max_saccade_time * 2;	// subject must hold fixation for this long on a stop trial to be deemed canceled
		Tone_Duration			= 30;	// how long should the error and success tones be presented?
		Base_Reward_time		= 70;	// medium time for the juice solonoid to remain open (monkeys are very interested in this varaible)
		Base_Punish_time		= 1200;	// medium time out for messing up (monkeys care less for this one)
		Fixed_trl_length		= 1;	// 1 for fixed trial length, 0 for fixied inter trial intervals
		Trial_length			= 0; 	// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
		Inter_trl_int			= 0;	// how long between trials (only works if Fixed_trl_length == 0)
		}
		
		
	//--------------------------------------------------------------------------------------------------------------------
	// Archimedes
	else if(Monkey == archimedes)
		{
		Subj_dist     = 494.0; 			// distance from center of subjects eyeball to screen	
				
		//----------------------------------------------------------------------------------------------------------------
		// Trial type distributions (MUST SUM TO 100)
		Go_weight				= 100.0;
		Stop_weight				= 0;
		Ignore_weight			= 0;
		
		Bonus_weight			= 0.0;	// percentage of time that the subject is wrong but gets rewarded anyway.
		Dealer_wins_weight		= 0.0;	// percentage of time that the subject is right but gets punished anyway.

		BigR_weight				= 33.33;// weights for random changes of reward size
		MedR_weight				= 33.34;// weights for random changes of reward size
		SmlR_weight				= 33.33;// weights for random changes of reward size
		SmlP_weight				= 33.33;// weights for random changes of punsiment size
		MedP_weight				= 33.34;// weights for random changes of punsiment size
		BigP_weight				= 33.33;// weights for random changes of punsiment size



		//----------------------------------------------------------------------------------------------------------------
		// Stimulus properties
		// Blue can also be used
		// iso luminant value is 0,0,52;
		Classic					= 0;
		
		Stop_sig_color[r_]		= 50;	
		Stop_sig_color[g_]		= 0;	
		Stop_sig_color[b_]		= 21;	
		
		Ignore_sig_color[r_]	= 0;
		Ignore_sig_color[g_]	= 33;
		Ignore_sig_color[b_]	= 10;
						   
		Fixation_color[r_]		= 33;	
		Fixation_color[g_]		= 30;	
		Fixation_color[b_]		= 30;	
		
		// Target colors
		Color_list[0,r_]		= 15;	// color of each target individually
		Color_list[0,g_]		= 15;	// color of each target individually
		Color_list[0,b_]		= 15;	// color of each target individually
						
		Color_list[1,r_]		= 15;
		Color_list[1,g_]		= 15;
		Color_list[1,b_]		= 15;
						
		Color_list[2,r_]		= 0;
		Color_list[2,g_]		= 0;
		Color_list[2,b_]		= 0;
								  
		Color_list[3,r_]		= 0;
		Color_list[3,g_]		= 0;
		Color_list[3,b_]		= 0;
						          
		Color_list[4,r_]		= 0;
		Color_list[4,g_]		= 0;
		Color_list[4,b_]		= 0;
								  
		Color_list[5,r_]		= 0;
		Color_list[5,g_]		= 0;
		Color_list[5,b_]		= 0;
								  
		Color_list[6,r_]		= 0;
		Color_list[6,g_]		= 0;
		Color_list[6,b_]		= 0;
								  
		Color_list[7,r_]		= 0;
		Color_list[7,g_]		= 0;
		Color_list[7,b_]		= 0;
		
		// Target sizes
		Size_list[0]			= 3.0;	// size of each target individually (degrees)
		Size_list[1]			= 3.0;
		Size_list[2]			= 0;
		Size_list[3]			= 0;
		Size_list[4]			= 0;
		Size_list[5]			= 0;
		Size_list[6]			= 0;
		Size_list[7]			= 0;
		
		// Target angles
		Angle_list[0]			= 0;	// angle of each target individually (degrees)
		Angle_list[1]			= 180;
		Angle_list[2]			= 90;
		Angle_list[3]			= 135;
		Angle_list[4]			= 180;
		Angle_list[5]			= -135;
		Angle_list[6]			= -90;
		Angle_list[7]			= -45;
		
		// Target eccentricities
		Eccentricity_list[0]	= 10.0;	// distance of each target from center of screen individually (degrees)
		Eccentricity_list[1]	= 10.0;
		Eccentricity_list[2]	= 10.0;
		Eccentricity_list[3]	= 10.0;
		Eccentricity_list[4]	= 10.0;
		Eccentricity_list[5]	= 10.0;
		Eccentricity_list[6]	= 10.0;
		Eccentricity_list[7]	= 10.0;
		
		Fixation_size			= .5;	// size of the fixation point (degrees)	
		
		Success_Tone_bigR		= 100;	// positive secondary reinforcer in Hz (large reward)
		Success_Tone_medR		= 200;	// positive secondary reinforcer in Hz (medium reward)
		Success_Tone_smlR		= 400;	// positive secondary reinforcer in Hz (small reward)		
		Failure_Tone_smlP		= 800;	// negative secondary reinforcer in Hz (short timeout)
		Failure_Tone_medP		= 1600;	// negative secondary reinforcer in Hz (medium timeout)
		Failure_Tone_bigP		= 3200;	// negative secondary reinforcer in Hz (long timeout)	
		
		Fixation_Target 		= 0;	// Target number for the fixation task (not used here);

		//----------------------------------------------------------------------------------------------------------------
		// Eye related variables
		Fix_win_size			= 2.5;	// size of fixation window (degrees)
		Targ_win_size			= 5;	// size of target window (degrees)



		//----------------------------------------------------------------------------------------------------------------
		// Task timing paramaters (all times in ms unless otherwise specified)
		Allowed_fix_time		= 2000;	// subject has this long to acquire fixation before a new trial is initiated
		Expo_Jitter				= 1;	// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
		Min_Holdtime			= 600;  // minimum time after fixation before target presentation
		Max_Holdtime			= 1100; // maximum time after fixation before target presentation
		Max_saccade_time		= 800;	// subject has this long to saccade to the target
		Max_sacc_duration		= 60;	// once the eyes leave fixation they must be in the target before this time is up
		Targ_hold_time			= 600; 	// after saccade subject must hold fixation at target for this long
		Staircase				= 1;	// do we select the next SSD based on a staircasing algorithm?
		
		SSD_list[0]				= 3;	// needs to be in vertical retrace units
		SSD_list[1]				= 0;
		SSD_list[2]				= 0;
		SSD_list[3]				= 0;
		SSD_list[4]				= 0;
		SSD_list[5]				= 0;
		SSD_list[6]				= 0;
		SSD_list[7]				= 0;
		SSD_list[8]				= 0;
		SSD_list[9]				= 0;
		SSD_list[10]			= 0;
		SSD_list[11]			= 0;
		SSD_list[12]			= 0;
		SSD_list[13]			= 0;
		SSD_list[14]			= 0;
		SSD_list[15]			= 0;
		SSD_list[16]			= 0;
		SSD_list[17]			= 0;
		SSD_list[18]			= 0;
		SSD_list[19]			= 0;

		Cancl_time				= Max_saccade_time * 2;	// subject must hold fixation for this long on a stop trial to be deemed canceled
		Tone_Duration			= 30;	// how long should the error and success tones be presented?
		Base_Reward_time		= 70;	// medium time for the juice solonoid to remain open (monkeys are very interested in this varaible)
		Base_Punish_time		= 1200;	// medium time out for messing up (monkeys care less for this one)
		Fixed_trl_length		= 1;	// 1 for fixed trial length, 0 for fixied inter trial intervals
		Trial_length			= 0; 	// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
		Inter_trl_int			= 0;	// how long between trials (only works if Fixed_trl_length == 0)
		}
	
	
	}