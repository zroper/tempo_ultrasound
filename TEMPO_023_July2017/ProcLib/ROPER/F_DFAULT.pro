// This sets all of the user defined global variables for the fixation task.
// It is needed because of the loop structure which allows multiple tasks to run 
// from the same protocol.  If multiple protocols use the same variables, we may 
// run into problems if we don't specifically reset them at the beginning of each
// task change.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare F_DFAULT();

process F_DFAULT()
	{
	declare hide int r_, g_, b_;
	r_ = 0; g_ = 1; b_ = 2;
	
	Trl_number				= 1;
	Block_number			= 1;
		
	//----------------------------------------------------------------------------------------------------------------
	// Trial type distributions (MUST SUM TO 100)
	Go_weight				= 0;
	Stop_weight				= 0;
	Ignore_weight			= 0;
	
	Bonus_weight			= 0;	// percentage of time that the subject is wrong but gets rewarded anyway.
	Dealer_wins_weight		= 0;	// percentage of time that the subject is right but gets punished anyway.

	BigR_weight				= 0;	// weights for random changes of reward size
	MedR_weight				= 100;	// weights for random changes of reward size
	SmlR_weight				= 0;	// weights for random changes of reward size
	SmlP_weight				= 0;	// weights for random changes of punsiment size
	MedP_weight				= 100;	// weights for random changes of punsiment size
	BigP_weight				= 0;	// weights for random changes of punsiment size

	//----------------------------------------------------------------------------------------------------------------
	// Stimulus properties
	// Blue can also be used
	// value is 0,0,52;
	Classic					= 0;
	
	Stop_sig_color[r_]		= 0;	
	Stop_sig_color[g_]		= 0;	
	Stop_sig_color[b_]		= 0;	
	
	Ignore_sig_color[r_]	= 0;	
	Ignore_sig_color[g_]	= 0;	
	Ignore_sig_color[b_]	= 0;	
                       
	Fixation_color[r_]		= 0;	
	Fixation_color[g_]		= 0;	
	Fixation_color[b_]		= 0;	

	N_targ_pos				= 9;	// number of target positions (this is calculated below based on user input)
	
	Color_list[0,r_]		= 33;	// color of each target individually
	Color_list[0,g_]		= 30;	// color of each target individually
	Color_list[0,b_]		= 30;	// color of each target individually
                    
	Color_list[1,r_]		= 33;
	Color_list[1,g_]		= 30;
	Color_list[1,b_]		= 30;
                    
	Color_list[2,r_]		= 33;
	Color_list[2,g_]		= 30;
	Color_list[2,b_]		= 30;
	                          
	Color_list[3,r_]		= 33;
	Color_list[3,g_]		= 30;
	Color_list[3,b_]		= 30;
	                
	Color_list[4,r_]		= 33;
	Color_list[4,g_]		= 30;
	Color_list[4,b_]		= 30;
                              
	Color_list[5,r_]		= 33;
	Color_list[5,g_]		= 30;
	Color_list[5,b_]		= 30;
                              
	Color_list[6,r_]		= 33;
	Color_list[6,g_]		= 30;
	Color_list[6,b_]		= 30;
                              
	Color_list[7,r_]		= 33;
	Color_list[7,g_]		= 30;
	Color_list[7,b_]		= 30;
	
	Color_list[8,r_]		= 33;
	Color_list[8,g_]		= 30;
	Color_list[8,b_]		= 30;
	
	Size_list[0]			= 0.5;	// size of each target individually (degrees)
	Size_list[1]			= 0.5;
	Size_list[2]			= 0.5;
	Size_list[3]			= 0.5;
	Size_list[4]			= 0.5;
	Size_list[5]			= 0.5;
	Size_list[6]			= 0.5;
	Size_list[7]			= 0.5;
	Size_list[8]			= 0.5;
	
	Angle_list[0]			= 0;	// angle of each target individually (degrees)
	Angle_list[1]			= 90;
	Angle_list[2]			= -90;
	Angle_list[3]			= 180;
	Angle_list[4]			= 0;
	Angle_list[5]			= 135;
	Angle_list[6]			= 45;
	Angle_list[7]			= -135;
	Angle_list[8]			= -45;
	
	Eccentricity_list[0]	= 0.0;	// distance of each target from center of screen individually (degrees)
	Eccentricity_list[1]	= 11.0;
	Eccentricity_list[2]	= 11.0;
	Eccentricity_list[3]	= 11.0;
	Eccentricity_list[4]	= 11.0;
	Eccentricity_list[5]	= 15.6;
	Eccentricity_list[6]	= 15.6;
	Eccentricity_list[7]	= 15.6;
	Eccentricity_list[8]	= 15.6;
	
	Fixation_size			= 0.0;	// size of the fixatoin point (degrees)
	Success_Tone_bigR		= 3200;	// positive secondary reinforcer in Hz (large reward)
	Success_Tone_medR		= 1600;	// positive secondary reinforcer in Hz (medium reward)Success_Tone	
	Success_Tone_smlR		= 800;	// positive secondary reinforcer in Hz (small reward)	Failure_Tone
	Failure_Tone_smlP		= 400;	// negative secondary reinforcer in Hz (short timeout)
	Failure_Tone_medP		= 200;	// negative secondary reinforcer in Hz (medium timeout)
    Failure_Tone_bigP		= 100;	// negative secondary reinforcer in Hz (long timeout)
	
	Fixation_Target			= 0;	// Target number for the fixation task (changed by key macros);

	//----------------------------------------------------------------------------------------------------------------
	// Eye related variables
	Fix_win_size			= 0;	// size of fixation window (degrees)
	Targ_win_size			= 2.5;	// size of target window (degrees)



	//----------------------------------------------------------------------------------------------------------------
	// Task timing paramaters (all times in ms unless otherwise specified)
	Allowed_fix_time		= 1200;	// subject has this long to acquire fixation (or target fixation protocol) before a new trial is initiated
	Expo_Jitter				= 0;	// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
	Min_Holdtime			= 0;  	// minimum time after fixation before target presentation
	Max_Holdtime			= 0; 	// maximum time after fixation before target presentation
	Max_saccade_time		= 800;	// subject has this long to saccade to the target
	Max_sacc_duration		= 0;	// once the eyes leave fixation they must be in the target before this time is up
	Targ_hold_time			= 600; 	// after saccade subject must hold fixation at target for this long
	N_SSDs					= 0;	// number of stop signal delays (need to calculate this myself)
	Staircase				= 0;	// do we select the next SSD based on a staircasing algorithm?
	
	SSD_list[0]				= 0;	// needs to be in vertical retrace units
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

	Cancl_time				= 0;	// subject must hold fixation for this long on a stop trial to be deemed canceled
	Tone_Duration			= 30;	// how long should the error and success tones be presented?
	Reward_Offset			= 600;	// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
	Base_Reward_time		= 60;	// medium time for the juice solonoid to remain open (monkeys are very interested in this varaible)
	Base_Punish_time		= 0;	// medium time out for messing up (monkeys care less for this one)
	Fixed_trl_length		= 0;	// 1 for fixed trial length, 0 for fixied inter trial intervals
	Trial_length			= 0; 	// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
	Inter_trl_int			= 1500;	// how long between trials (only works if Fixed_trl_length == 0)
	
	
	}