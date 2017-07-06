//-----------------------------------------------------------------------------------
// process SETM_TRL(int n_targ_pos,
				// int min_holdtime,
				// int max_holdtime,
				// int expo_jitter,
				// int min_soa,
				// int max_soa,
				// int expo_jitter_soa);
// Calculates all variables needed to run a mem guided sacc trial based on user defined
// space.  See DEFAULT.pro and M_VARS.pro for an explanation of the global input variables
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011

#include C:/TEMPO/ProcLib/MEM_PGS.pro						// sets all pgs of video memory up for the impending trial

declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Curr_soa;									// next trial time between target onset and fixation offset
declare hide int soa;
//declare hide int SOA_list[20];
declare hide int per_jitter;
declare hide int r_, g_, b_;		
	r_ = 0; g_ = 1; b_ = 2;	
	
declare SETM_TRL(int n_targ_pos,							// see DEFAULT.pro and M_VARS.pro for explanations of these globals
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int min_soa,
				int max_soa,
				int expo_jitter_soa);

process SETM_TRL(int n_targ_pos,							// see DEFAULT.pro and M_VARS.pro for explanations of these globals
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int min_soa,
				int max_soa,
				int expo_jitter_soa)
	{
	
	declare hide float jitter, decide_jitter, holdtime_diff, soa_diff;
	declare hide float decide_soa_jitter, per_soa_jitter, soa_jitter;
	declare hide int fixation_color 	= 255;				// see SET_CLRS.pro


	// -----------------------------------------------------------------------------------------------
	// 1) Pick a target

	Curr_target = random(n_targ_pos);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
	


	
	// -----------------------------------------------------------------------------------------------
	// 2) Set up all vdosync pages for the upcoming trial using globals defined by user and setc_trl
	spawnwait MEM_PGS(curr_target,							// set above
				fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
				fixation_color, 							// see SET_CLRS.pro
				scr_width, 									// see RIGSETUP.pro
				scr_height, 								// see RIGSETUP.pro
				pd_left, 									// see RIGSETUP.pro
				pd_bottom, 									// see RIGSETUP.pro
				pd_size,									// see RIGSETUP.pro
				deg2pix_X,									// see SET_COOR.pro
				deg2pix_Y,									// see SET_COOR.pro
				unit2pix_X,									// see SET_COOR.pro
				unit2pix_Y,									// see SET_COOR.pro
				object_targ);								// see GRAPHS.pro
		
		
	

	// -----------------------------------------------------------------------------------------------
	// 3) Set Up Target and Fixation Windows and plot them on animated graphs
	spawnwait WINDOWS(curr_target,							// see above
				fix_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				targ_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				object_fixwin,								// animated graph object
				object_targwin,								// animated graph object
				deg2pix_X,									// see SET_COOR.pro
	            deg2pix_Y);                                 // see SET_COOR.pro
				

				
	
	// -----------------------------------------------------------------------------------------------
	// 4) Select current holdtime
	
	holdtime_diff = max_holdtime - min_holdtime;
	if (expo_jitter)
		{		
		decide_jitter 	= (random(1001))/1000.0;				
		per_jitter 		= exp(-1.0*(decide_jitter/0.25));	
		}
	else
		{
		per_jitter 	= random(1001) / 1000.0;				// random number 0-100 (percentages)
		}
	jitter 			= holdtime_diff * per_jitter;
	Curr_holdtime 	= round(min_holdtime + jitter);
	
	

	
		
	// -----------------------------------------------------------------------------------------------
	// 5) Select current soa (same logic as above)
	SOA_list[0] = 600;
	SOA_list[1] = 800;
	SOA_list[2] = 1000;
	SOA_list[3] = 1200;
	SOA_list[4] = 1400;
	SOA_list[5] = 0;
	SOA_list[6] = 0;
	SOA_list[7] = 0;
	SOA_list[8] = 0;
	SOA_list[9] = 0;
	SOA_list[10] = 0;
	SOA_list[11] = 0;
	SOA_list[12] = 0;
	SOA_list[13] = 0;
	SOA_list[14] = 0;
	SOA_list[15] = 0;
	SOA_list[16] = 0;
	SOA_list[17] = 0;
	SOA_list[18] = 0;
	SOA_list[19] = 0;
	
	
	
/* 	soa_diff = max_soa - min_soa;
	if (expo_jitter_soa == 1)
		{
	
	
		decide_soa_jitter 	= (random(1000) + 1)/1000.0;
	//	per_jitter 		= exp(-1.0*(decide_jitter/0.25));	
		per_soa_jitter 		= -1.2 * ln(decide_soa_jitter);
		
		
		while (per_soa_jitter > 5)
		{
			decide_soa_jitter 	= (random(1000) + 1)/1000.0;
			per_soa_jitter 		= -1.2 * ln(decide_soa_jitter);
		}
		
		per_jitter = floor(per_soa_jitter);
		Curr_soa = 500 //SOA_list[per_jitter];	
		}
	else
	//	{
	//	per_soa_jitter 	= (random(1000) + 1)/ 1000.0;				// random number 0-100 (percentages)
	//	soa_jitter 			= soa_diff * per_soa_jitter;
	//	Curr_soa 			= round(min_soa + soa_jitter);	
	
	//	per_jitter = random(3);
	//	
	//	Curr_soa = SOA_list[per_jitter];
	//	}

		{		
		decide_soa_jitter 	= (random(1000) + 1)/1000.0;
	//	per_jitter 		= exp(-1.0*(decide_jitter/0.25));	
		per_soa_jitter 		= -1.2 * ln(decide_soa_jitter);
		
		
		while (per_soa_jitter > 5)
		{
			decide_soa_jitter 	= (random(1000) + 1)/1000.0;
			per_soa_jitter 		= -1.2 * ln(decide_soa_jitter);
					
		} */
		
		per_jitter = random(4);
		Curr_soa = SOA_list[per_jitter];	
		
	}
	
	
	