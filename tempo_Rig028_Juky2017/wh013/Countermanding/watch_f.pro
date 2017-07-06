process WATCHEYE()
{
	declare hide oldx, oldy;            						 // Last eye position.
	while (1)                           						 // Loop indefinitely.
	{
	/////////////////////////////////////////////////////////
	if (AUTOMONKEY)
	{                           // Fabricate "fake" position automatically
			 // in analog values
		bxc = TarH + 100;         // Target center in video coord
		byc = TarV + 100;
		axc = bxc;//(bxc * 4096)/XMAX - 2048; // Target center in analog coord
		ayc = byc;//(byc * 4096)/YMAX - 2048; // Target center in analog coord
		ax = ax + (axc - ax) / 50; // Go part way to target from previous loc
		ay = ay + (ayc - ay) / 50; // Go part way to target from previous loc
		ax = ax + 25 - random(50);
		ay = ay + 25 - random(50);
	}
	else if (DEBUG)                 // Which kind of input should we use?
	{
		ax = mouGetX();             // Get manual "fake" position from Mouse
		ay = mouGetY();
		x = (XMAX * (ax*XGAIN + 2048)) / 4096;// Map to video coordinates
		y = (YMAX * (ay*YGAIN + 2048)) / 4096;
	}
	else if(DEBUG==0 && AUTOMONKEY==0)
	{
	/////////////////////////////////////////////////////////////
		ax = atable(1);             					 	 // Get actual horizontal analog values.
		ay = -atable(2);			 					 	 // Get actual vertical analog values.
		x = (ax+H_OFFSET)*(XGAIN)/(XMAX);								 	 // Map to video coordinates
		y = (ay+V_OFFSET)*(YGAIN)/(YMAX);
	}
	//axc = (bxc * 4096)/XMAX - 2048;
	//	if (x != oldx || y != oldy)     				   	 	 // If position has changed..
	//  {
	oMove(oE, x, y);            					 	 // ..Update eye object
	oMove(oE1, x, y);           					 	 // ..Update eye object: right animated graph
	if(DEBUG==1 || AUTOMONKEY==1)
	{
		dsendf("om 1,%d,%d\n", x, y); 					 	 // ..Move sprite
		dsend("os 1");                       // Show "eye" sprite
	}
	oldx = x;                   					 	 // This is the new position.
	oldy = y;
	// }

	if ((abs(x) <= Fix_H/2) && (abs(y) <= Fix_V/2))// Check to see if eye position is inside the fixation window.
	{
		In_Fixation_Window = 1;
		Saccadic_time=time();
		if(types[j]==2) // if a stop signal trial
		{
			if(Stimu[s]==2 || Stimu[s]==3) // If a stop trial and eye is in fixation, act as if eye is in target also, since fixation=target.
			{
				In_Target = 1;
			}
		}
	}
	else
	{
		In_Fixation_Window = 0;
		if(trial_start==1 && step_wind==0)
		{
			spawn SendTTLToRemoteSystem(2810); /// Saccade The gaze goes out of the fixation window
			// Saccade event for No stop trials
			if (types[j] ==1 ) // if a no stop trial
			{
				spawn SendTTLToRemoteSystem(2820 + trials[i]); // Saccade The gaze goes out of the fixation window
			}
			else if (types[j] == 2) // if a stop signal trial
			{
				// Saccade event for Noncancelled trials
				if (Stimu[s] >1) // if NOT a no stop trial
				{					
					spawn SendTTLToRemoteSystem(2830 + trials[i]); // Saccade The gaze goes out of the fixation window				
					sac_latency = time() - end_fix_presentationT;				
					printf("Error RT = %dms\n",sac_latency);
					// print("inFix = ", In_Fixation_Window);										
					failed = ERR_NOFIX_STOPTRIAL;			
					LastTrialOutcome=1;	
					//print("wrong in TRIAL IN WATCH EYE ");					
					signal_respond_marker = 1;
					/*
					spawn WRONG;
					waitforprocess WRONG;
					*/
				}
			}
			step_wind=1;
		 }
	}
	if (x >= TarH - (Targ_H/2) && x <= TarH + (Targ_H/2) && y >= TarV - (Targ_V/2) && y <= TarV + (Targ_V/2)) // See if eye position is inside target.
	{
		if(trial_start==1 && step_targ==0)
		{
			spawn SendTTLToRemoteSystem(2811); /// The gaze goes to the target window
			event_set(1,0,2811);									 // Event Code for Tempo data base.
			nexttick;
			step_targ=1;
		 }
		In_Target = 1;

		if(trial_start==1)
		{
			if(types[j]==1 || Stimu[s]==1)
			{
				if(failed==0 && step_lat==0)
				{
					sac_latency= time() - end_fix_presentationT;
					printf("No Stop RT=%dms\n",sac_latency);
					step_lat=1;
					Saccade_time=time()-Saccadic_time;
					printf("saccade time=%dms\n",Saccade_time);
					if(Saccade_time>Sacc_time)
					{
						failed = ERR_TIME_SAC;
						LastTrialOutcome=1;
						print("Wrong Saccade Duration....");
						spawn WRONG;
						waitforprocess WRONG;
					}
				}
			}
		}
	}
	else
		In_Target = 0;
		nexttick;					 // We wait one process cycle because we want to monitor the eye position every process cycle.
	}
}
