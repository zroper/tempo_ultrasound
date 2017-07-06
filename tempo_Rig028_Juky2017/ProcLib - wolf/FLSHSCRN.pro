//--------------------------------------------------------------------------------------------------
// This is the main flash protocol.  
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

	
declare FLSHSCRN();						

process FLSHSCRN()     
	{
	declare hide int run_flash_sess	= 5;
	declare hide int run_idle		= 0;
	declare hide int blank			= 0;
	declare hide int flash			= 1;
	declare int		 trl_ct			= 0;
	
	trl_ct = 0;
	
	dsend("DM RFRSH");                			// This code sets up a vdosync macro definition to wait a specified ...
	if (Room == 23)                   			// ...number of vertical retraces based on the room in which we are    ...
		{                             			// ...recording.  This kluge is necessary because vdosync operates     ...
		dsendf("vw %d:\n",1);         			// ...differently in the different rooms.  In 028 a command to wait    ...
		}                             			// ...2 refresh cycles usually only waits for one and a command to     ...
	else                              			// ...wait for 1 usually only waits for 0.  Room 029 and 023 appear to ...
		{                             			// ...work properly.
		dsendf("vw %d:\n",2);
		}
	dsend("EM RFRSH");
	
		
	if (Last_task != run_flash_sess)			// Only do this if we have gone into another task or if this is first run of day.
		{
		system("dialog Select_Monkey");
		spawnwait DEFAULT(State,				// Set all globals to their default values.
						Monkey,						
						Room);	
		Last_task = run_flash_sess;
		}
	
	while(!OK)									
		{
		nexttick;
		if(Set_monkey)
			{
			spawnwait DEFAULT(State,			// Set all globals to their default values based on the monkey.
						Monkey,					
						Room);	
			Set_monkey = 0;
			}
		}
			
	nexttick 10;									// to prevent buffer overflows after task reentry.
	
	while (State == run_flash_sess)					// while the user has not yet terminated the countermanding task
		{		
		
		
		spawnwait WINDOWS(fixation_target,			// GLOBAL set by F_DFAULT and KEY_TARG (key macros KEY_T_UP and KEY_T_DN)
					fix_win_size,  					// see DEFAULT.pro and ALL_VARS.pro
					targ_win_size, 					// see DEFAULT.pro and ALL_VARS.pro
					object_fixwin, 					// animated graph object
					object_targwin,					// animated graph object
					deg2pix_X,     					// see SET_COOR.pro
					deg2pix_Y);    					// see SET_COOR.pro
		oSetAttribute(object_targwin, aINVISIBLE);	
		
		spawnwait FLS_PGS(scr_width,              	// see RIGSETUP.pro
					scr_height,                   	// see RIGSETUP.pro
					pd_left,                      	// see RIGSETUP.pro
					pd_bottom,                    	// see RIGSETUP.pro
					pd_size,                      	// see RIGSETUP.pro
					deg2pix_X,                    	// see SET_COOR.pro
					deg2pix_Y,                    	// see SET_COOR.pro
					unit2pix_X,                   	// see SET_COOR.pro
					unit2pix_Y,                   	// see SET_COOR.pro
					object_targ);               	// see GRAPHS.pro
		
		while (In_FixWin)
			{
			dsendf("vp %d\n",flash);
			dsendf("XM RFRSH:\n");
			dsendf("vp %d\n",blank);
			//spawn TONE(success_Tone_medR,tone_duration);				// give the secondary reinforcer tone
			spawn JUICE(juice_channel,Base_Reward_time);				// YEAH BABY!  THAT'S WHAT IT'S ALL ABOUT!
			trl_ct = trl_ct + 1;
			print(trl_ct);
			nexttick(250);
			}
		
		nexttick(100);									// wait at least one cycle and do it all again
		
		}

													// the State global variables allow a control structure...
													// ...to impliment the task.
	State = run_idle;								// If we are out of the while loop the user wanted...
													// ...to stop cmanding.
												
	oDestroy(object_fixwin);						// destroy all graph objects
	oDestroy(object_targwin);
	oDestroy(object_fix);
	oDestroy(object_targ);
	oDestroy(object_eye);
	
	oSetGraph(gleft,aCLEAR);						// clear the left graph
	
	system("key currt = ");							// clear right key macro
	system("key curlf = ");							// clear left key macro
	system("key curup = ");							// clear up key macro
	system("key curdn = ");							// clear down key macro
		
	spawn IDLE;										// return control to IDLE.pro
    }
	
		