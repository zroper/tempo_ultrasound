//-------------------------------------------------------------------------------------------------------------------------
// perform a few checks to try to guard against poor user input

declare GOODVARS();

process GOODVARS()
{	
declare hide int i, j;
declare float sumDist, trialRateFactor;


//---------------------------------------------------------------------------------------------------------------------------	
if (state == stateCMD)
	{
	if (goPct				
		+ stopPct
		+ ignorePct != 100)
		{
		printf("WARNING!!!\n");
		printf("Trial weights do not sum to 100.\n");
		printf("CHANGE PARAMETERS BEFORE RECORDING\n");
		State = 0;  					// hook the user back into IDLE()
		system("dpop");					// clear dialogs
		}
	
	
	i = 0;								// count up the target locations based on sizeArray
	nTarg = 0;
	while(i < 8)
		{
		if(sizeArray[i] != 0)
			{
			nTarg = nTarg + 1;
			}
		i = i + 1;
		nexttick;
		}
		
	i = 2;								// count up the levels of discrimination
	nDiscriminate = 2;							// want at least 2 levels of discrimination (can be 1 and 0)
	while(i < 10)
		{
		if(targ1PropArray[i] != 0)
			{
			nDiscriminate = nDiscriminate + 1;
			}
		i = i + 1;
		nexttick;
		}

	i = 0;								// count up the SSDs
	nSSD = 0;
	while(i < 12)
		{
		if(ssdArray[i] != 0)
			{
			nSSD = nSSD + 1;
			}
		i = i + 1;
		nexttick;
		}
	
	ssdMax = ssdArray[nSSD-1];
	ssdMax = ceil(ssdMax * (1000.0/screenRefreshRate));
	ssdMin = ssdArray[0];
	ssdMin = ceil(ssdMin * (1000.0/screenRefreshRate));
	
	if (ssdMax > saccTimeMax)
		{
		printf("WARNING!!!\n");
		printf("SSDs exceed Max time allowed...\n");
		printf("...for saccade to target.\n");
		printf("CHANGE PARAMETERS BEFORE RECORDING\n");
		State = 0;  					// hook the user back into IDLE()
		system("dpop");					// clear dialogs
		}
	
	if(trialDuration < holdtimeMax
					+ ssdMax
					+ holdStopDuration
					+ toneDuration
					+ rewardDelay
					+ baseRewardDuration * 2
					+ 100) 				// maximum time a trial can take including 100ms for iti calculations (generous)
		{
		trialDuration = holdtimeMax
					+ ssdMax
					+ holdStopDuration
					+ toneDuration
					+ rewardDelay
					+ baseRewardDuration * 2
					+ 100;
		printf("WARNING!!!\n");
		printf("Trial length too short\n");
		printf("Extending trial length to %d\n",trialDuration);
		}
		
	}
	
//---------------------------------------------------------------------------------------------------------------------------	


//---------------------------------------------------------------------------------------------------------------------------	
if (state == stateCCM)
	{
	if (goPct				
		+ stopPct
		+ ignorePct != 100)
		{
		printf("WARNING!!!\n");
		printf("Trial weights do not sum to 100.\n");
		printf("CHANGE PARAMETERS BEFORE RECORDING\n");
		State = 0;  					// hook the user back into IDLE()
		system("dpop");					// clear dialogs
		}
	
	
	i = 0;								// count up the target locations based on sizeArray
	nTarg = 0;
	while(i < 8)
		{
		if(sizeArray[i] != 0)
			{
			nTarg = nTarg + 1;
			}
		i = i + 1;
		nexttick;
		}


	i = 0;								// count up the levels of discrimination
	nDiscriminate = 0;							// want at least 2 levels of discrimination (can be 1 and 0)
	sumDist = 0.0;						// will be used below to calculate trial rate within each level of discim
	while(i < 10)
		{
		if (targ1PropArray[i] == 0 && i == 0)
			{
			nDiscriminate = nDiscriminate + 1;
			sumDist = sumDist + trialDist[i];
			}		
		else if(targ1PropArray[i] != 0)
			{
			nDiscriminate = nDiscriminate + 1;
			sumDist = sumDist + trialDist[i];
			}
		i = i + 1;
		nexttick;
		}

	maxDiscriminate = targ1PropArray[nDiscriminate-1];
	minDiscriminate = targ1PropArray[0];
	
	
	
	// Calculate the absolute trial rate within each level of discrimination
	trialRateFactor = 1.0 / sumDist;
	i = 0;
	while (i < nDiscriminate)
		{
		trialRate[i] = trialDist[i] * trialRateFactor;
		i = i + 1;
		}
	// Calculate the boundaries between trial rates. This will be used in SETTRIAL.pro to choose which level of discrimnation to use
	i = 1;
	trialRateBound[0] = trialRate[0];
	while (i < nDiscriminate)
		{
		trialRateBound[i] = trialRateBound[i-1] + trialRate[i]; 
		printf("%d\n", trialRateBound[i]);
		i = i + 1;
		}



	i = 0;								// count up the SSDs
	nSSD = 0;
	while(i < 12)
		{
		if(ssdArray[i] != 0)
			{
			nSSD = nSSD + 1;
			}
		i = i + 1;
		nexttick;
		}
	
	ssdMax = ssdArray[nSSD-1];
	ssdMax = ceil(ssdMax * (1000.0/screenRefreshRate));
	ssdMin = ssdArray[0];
	ssdMin = ceil(ssdMin * (1000.0/screenRefreshRate));
	
	if (ssdMax > saccTimeMax)
		{
		printf("WARNING!!!\n");
		printf("SSDs exceed Max time allowed...\n");
		printf("...for saccade to target.\n");
		printf("CHANGE PARAMETERS BEFORE RECORDING\n");
		State = 0;  					// hook the user back into IDLE()
		system("dpop");					// clear dialogs
		}
	
	// Reset all the counters in case this isn't the first run of choice countermanding (so inhibition and psychometric functions reset)
	i = 0;
	while (i < 10)
		{
		j = 0;
		while (j < 10)
			{
			nTrialPsySSD[i,j] 	= 0;
			nSaccPsySSD[i,j] 	= 0;
			nTarg1PsySSD[i,j] 	= 0;
			j = j + 1;
			}
		i = i + 1;
		}
		
		
	if(trialDuration < holdtimeMax
					+ ssdMax
					+ holdStopDuration
					+ toneDuration
					+ rewardDelay
					+ baseRewardDuration * 2
					+ 100) 				// maximum time a trial can take including 100ms for iti calculations (generous)
		{
		trialDuration = holdtimeMax
					+ ssdMax
					+ holdStopDuration
					+ toneDuration
					+ rewardDelay
					+ baseRewardDuration * 2
					+ 100;
		printf("WARNING!!!\n");
		printf("Trial length too short\n");
		printf("Extending trial length to %d\n",trialDuration);
		}
	}


//---------------------------------------------------------------------------------------------------------------------------	
if (state == stateGNG)
	{
	if (goPct				
		+ NogoPct != 100)
		{
		printf("WARNING!!!\n");
		printf("Trial weights do not sum to 100.\n");
		printf("CHANGE PARAMETERS BEFORE RECORDING\n");
		State = 0;  					// hook the user back into IDLE()
		system("dpop");					// clear dialogs
		}
	
	
	i = 0;								// count up the target locations based on sizeArray
	nTarg = 0;
	while(i < 8)
		{
		if(sizeArray[i] != 0)
			{
			nTarg = nTarg + 1;
			}
		i = i + 1;
		nexttick;
		}
		
	i = 2;								// count up the levels of discrimination
	nDiscriminate = 2;							// want at least 2 levels of discrimination (can be 1 and 0)
	while(i < 10)
		{
		if(goPropArray[i] != 0)
			{
			nDiscriminate = nDiscriminate + 1;
			}
		i = i + 1;
		nexttick;
		}
	
	maxDiscriminate = goPropArray[nDiscriminate-1];
	minDiscriminate = goPropArray[0];
	
	
	if(trialDuration < holdtimeMax
					+ holdStopDuration
					+ toneDuration
					+ rewardDelay
					+ baseRewardDuration * 2
					+ 100) 				// maximum time a trial can take including 100ms for iti calculations (generous)
		{
		trialDuration = holdtimeMax
					+ holdStopDuration
					+ toneDuration
					+ rewardDelay
					+ baseRewardDuration * 2
					+ 100;
		printf("WARNING!!!\n");
		printf("Trial length too short\n");
		printf("Extending trial length to %d\n",trialDuration);
		}
	}
	
//---------------------------------------------------------------------------------------------------------------------------	

	
if (state == stateVIS ||
	state == stateMEM ||
	state == stateDEL)
	{
	i = 0;								// count up the target locations based on sizeArray
	nTarg = 0;
	while(i < 8)
		{
		if(sizeArray[i] != 0)
			{
			nTarg = nTarg + 1;
			}
		i = i + 1;
		nexttick;
		}
	
	}

if (state == stateAMP)
	{
	i = 0;								// count up the target locations based on sizeArray
	nTarg = 0;
	while(i < 8)
		{
		if(ampArray[i] != 0)
			{
			nTarg = nTarg + 1;
			}
		i = i + 1;
		nexttick;
		}
	
	}

if (trialDuration < holdtimeMax
			+ ssdMax
			+ holdStopDuration
			+ toneDuration
			+ rewardDelay
			+ baseRewardDuration * 2
			+ 100) 					// maximum time a trial can take including 100ms for iti calculations (generous)
	{
	trialDuration = holdtimeMax
				+ ssdMax
				+ holdStopDuration
				+ toneDuration
				+ rewardDelay
				+ baseRewardDuration * 2
				+ 100;
	printf("WARNING!!!\n");
	printf("Trial length too short\n");
	printf("Extending trial length to %d\n",trialDuration);
	}
	
	
if (Set_tones == 1)
	{
	Success_Tone_bigR		= 3200;	// positive secondary reinforcer in Hz (large reward)
	Success_Tone_medR		= 1600;	// positive secondary reinforcer in Hz (medium reward)
	Success_Tone_smlR		= 800;	// positive secondary reinforcer in Hz (small reward)		
	Failure_Tone_smlP		= 400;	// negative secondary reinforcer in Hz (short timeout)
	Failure_Tone_medP		= 200;	// negative secondary reinforcer in Hz (medium timeout)
	Failure_Tone_bigP		= 100;	// negative secondary reinforcer in Hz (long timeout)
	}
else
	{
	Success_Tone_bigR		= 100;	// positive secondary reinforcer in Hz (large reward)
	Success_Tone_medR		= 200;	// positive secondary reinforcer in Hz (medium reward)
	Success_Tone_smlR		= 400;	// positive secondary reinforcer in Hz (small reward)		
	Failure_Tone_smlP		= 800;	// negative secondary reinforcer in Hz (short timeout)
	Failure_Tone_medP		= 1600;	// negative secondary reinforcer in Hz (medium timeout)
	Failure_Tone_bigP		= 3200;	// negative secondary reinforcer in Hz (long timeout)
	}			
	





//---------------------------------------------------------------------------------------------------------------------------			
if (state == stateMCM)
	{

	if (maskPct				
		+ betPct
		+ retroPct
		+ proPct != 100)
		{
		printf("WARNING!!!\n");
		printf("Trial weights do not sum to 100.\n");
		printf("CHANGE PARAMETERS BEFORE RECORDING\n");
		state = stateNoTask;  					// hook the user back into IDLE()
		system("dpop");					// clear dialogs
		}


	i = 0;								// count up the target locations based on maskAmpArray (up to 4 target locations for now)
	nTarg = 0;
	while(i < 4)
		{
		if(maskAmpArray[i] != 0)
			{
			nTarg = nTarg + 1;
			}
		i = i + 1;
		nexttick;
		}
	}

	i = 0;								// count up the SOAs
	nSOA = 0;
	while(i < 10)
		{
		if(soaArray[i] != 0)
			{
			nSOA = nSOA + 1;
			}
		i = i + 1;
		nexttick;
		}




}
	