// Updates psychometric function in the animated graph online. 
// NOTE: SET_GNG must have been run already to set inhibition
// function graph up.  Needed for global objects.
//
// 04-17-2012:  adapted from UPD8_INH.pro  -pgm


declare UPD8_PSY();

process UPD8_PSY()
	{
	declare int ct;
	declare int hide position_x;
	declare float hide position_y[10];
	
	ct = 0;
	if (FirstTrial == 1)
		{
		while(ct<10)
			{
			position_y[ct] = 0;
			nPsy[ct] = 0;
			ct = ct + 1;
			FirstTrial = 0;
			}
		}

	// Specific graphs for specific tasks:
	if (state == stateGNG)
		{
		if(trialOutcome == goTarg ||					// For choice RT pcychometric function
			trialOutcome == nogoCorrect ||
			trialOutcome == goIncorrect ||
			trialOutcome == nogoTarg)									
			{
			nPsy[psyIndex] = nPsy[psyIndex] + 1;
			printf("nPsy: %d\n", nPsy[psyIndex]);
			// Increment the number of trials with a response at this discriminatory level
			if (trialOutcome == nogoTarg ||
				trialOutcome == goTarg)
				{
				nPsyRespond[psyIndex] = nPsyRespond[psyIndex] + 1;
				}
			}
		}
	else if (state == stateCCM)
		{
		if(trialOutcome == goTarg ||					// For choice RT pcychometric function
			trialOutcome == goDist)							
			{
			nPsy[psyIndex] = nPsy[psyIndex] + 1;
			// printf("nPsy: %d\n", nPsy[psyIndex]);
			// Increment the rightward response tally at this discriminatory level if necessary 
			if ((targIndex == targ1 &&
				trialOutcome == goTarg) ||
				(targIndex == targ1 + 2 &&
				trialOutcome == goTarg) ||
				(targIndex == targ2 && 
				trialOutcome == goDist) ||
				(targIndex == targ2 + 2 && 
				trialOutcome == goDist))
				{
				nTarg1Respond[psyIndex] = nTarg1Respond[psyIndex] + 1;
				}
				// printf("psyIndex: %d   Targ1 responses: %d   ", psyIndex, nTarg1Respond[psyIndex]);
			}
		}
	// Increment the total number of trials at this discriminatory level
	//nPsy[psyIndex] = nPsy[psyIndex] + 1;
			// printf("nPsy: %d\n", nPsy[psyIndex]);
		
	
	position_x = psyValue * 1000;

	if (state == stateGNG)
		{
		position_y[psyIndex] = 1000 * nPsyRespond[psyIndex] / nPsy[psyIndex];
		}
	else if (state == stateCCM)
		{
		position_y[psyIndex] = 1000 * nTarg1Respond[psyIndex] / nPsy[psyIndex];
		}
		

		
	//---------------------------------------------------------------------
	// GO Proportion 0		
	if ((state == stateGNG && psyValue == goPropArray[0]) ||
		(state == stateCCM && psyValue == targ1PropArray[0]))
		{
		oSetAttribute(object_psy0,aFILLED);
		oSetAttribute(object_psy0,aVISIBLE);
		oMove(object_psy0,position_x,position_y[0]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 1		
	if ((state == stateGNG && psyValue == goPropArray[1]) ||
		(state == stateCCM && psyValue == targ1PropArray[1]))
		{
		oSetAttribute(object_psy1,aFILLED);
		oSetAttribute(object_psy1,aVISIBLE);
		oMove(object_psy1,position_x,position_y[1]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 2		
	if ((state == stateGNG && psyValue == goPropArray[2]) ||
		(state == stateCCM && psyValue == targ1PropArray[2]))
		{
		oSetAttribute(object_psy2,aFILLED);
		oSetAttribute(object_psy2,aVISIBLE);
		oMove(object_psy2,position_x,position_y[2]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 3		
	if ((state == stateGNG && psyValue == goPropArray[3]) ||
		(state == stateCCM && psyValue == targ1PropArray[3]))
		{
		oSetAttribute(object_psy3,aFILLED);
		oSetAttribute(object_psy3,aVISIBLE);
		oMove(object_psy3,position_x,position_y[3]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 4		
	if ((state == stateGNG && psyValue == goPropArray[4]) ||
		(state == stateCCM && psyValue == targ1PropArray[4]))
		{
		oSetAttribute(object_psy4,aFILLED);
		oSetAttribute(object_psy4,aVISIBLE);
		oMove(object_psy4,position_x,position_y[4]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 5		
	if ((state == stateGNG && psyValue == goPropArray[5]) ||
		(state == stateCCM && psyValue == targ1PropArray[5]))
		{
		oSetAttribute(object_psy5,aFILLED);
		oSetAttribute(object_psy5,aVISIBLE);
		oMove(object_psy5,position_x,position_y[5]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 6		
	if ((state == stateGNG && psyValue == goPropArray[6]) ||
		(state == stateCCM && psyValue == targ1PropArray[6]))
		{
		oSetAttribute(object_psy6,aFILLED);
		oSetAttribute(object_psy6,aVISIBLE);
		oMove(object_psy6,position_x,position_y[6]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 7		
	if ((state == stateGNG && psyValue == goPropArray[7]) ||
		(state == stateCCM && psyValue == targ1PropArray[7]))
		{
		oSetAttribute(object_psy7,aFILLED);
		oSetAttribute(object_psy7,aVISIBLE);
		oMove(object_psy7,position_x,position_y[7]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 8		
	if ((state == stateGNG && psyValue == goPropArray[8]) ||
		(state == stateCCM && psyValue == targ1PropArray[8]))
		{
		oSetAttribute(object_psy8,aFILLED);
		oSetAttribute(object_psy8,aVISIBLE);
		oMove(object_psy8,position_x,position_y[8]);	
		}
	//---------------------------------------------------------------------
	// GO Proportion 9		
	if ((state == stateGNG && psyValue == goPropArray[9]) ||
		(state == stateCCM && psyValue == targ1PropArray[9]))
		{
		oSetAttribute(object_psy9,aFILLED);
		oSetAttribute(object_psy9,aVISIBLE);
		oMove(object_psy9,position_x,position_y[9]);	
		}
	}