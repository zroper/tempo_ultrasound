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
// 11-2011: Integrated choice countermanding task into ALL_PROS.pro. -pgm


declare INFOS();

process INFOS()
{
declare int stopColor_r, stopColor_g, stopColor_b;
declare int ignoreColor_r, ignoreColor_g, ignoreColor_b;
declare int fixColor_r, fixColor_g, fixColor_b;
declare int targColor_r, targColor_g, targColor_b;
declare int targ1CheckerColor_r, targ1CheckerColor_g, targ1CheckerColor_b; 	// (choice countermanding)
declare int targ2CheckerColor_r, targ2CheckerColor_g, targ2CheckerColor_b;		// (choice countermanding)
declare int goCheckerColor_r, goCheckerColor_g, goCheckerColor_b; 	// (choice countermanding)
declare int nogoCheckerColor_r, nogoCheckerColor_g, nogoCheckerColor_b;		// (choice countermanding)
declare int maskColor_r, maskColor_g, maskColor_b;		// (choice countermanding)
declare int highBetColor_r, highBetColor_g, highBetColor_b;		// (choice countermanding)
declare int lowBetColor_r, lowBetColor_g, lowBetColor_b;		// (choice countermanding)
declare int betFixColor_r, betFixColor_g, betFixColor_b;		// (choice countermanding)
declare int proFixColor_r, proFixColor_g, proFixColor_b;		// (choice countermanding)
declare int iChecker;

stopColor_r	= stopColorArray[0];
stopColor_g	= stopColorArray[1];
stopColor_b	= stopColorArray[2];
					 
ignoreColor_r	= ignoreColorArray[0];
ignoreColor_g	= ignoreColorArray[1];
ignoreColor_b	= ignoreColorArray[2];

fixColor_r	= fixColorArray[0];
fixColor_g	= fixColorArray[1];
fixColor_b	= fixColorArray[2];
					
targColor_r		= targColorArray[targIndex,0];
targColor_g		= targColorArray[targIndex,1];
targColor_b		= targColorArray[targIndex,2];

targ1CheckerColor_r	= Targ1SquareColor[0];			// (choice countermanding)
targ1CheckerColor_g	= Targ1SquareColor[1];			
targ1CheckerColor_b	= Targ1SquareColor[2];

targ2CheckerColor_r		= Targ2SquareColor[0];			// (choice countermanding)
targ2CheckerColor_g		= Targ2SquareColor[1];
targ2CheckerColor_b		= Targ2SquareColor[2];

goCheckerColor_r	= goSquareColor[0];			// (go/no-go)
goCheckerColor_g	= goSquareColor[1];			
goCheckerColor_b	= goSquareColor[2];

nogoCheckerColor_r		= noGoSquareColor[0];			// (go/no-go)
nogoCheckerColor_g		= noGoSquareColor[1];
nogoCheckerColor_b		= noGoSquareColor[2];

maskColor_r		= maskColorArray[0];			// (metacog)
maskColor_g		= maskColorArray[1];
maskColor_b		= maskColorArray[2];

highBetColor_r		= highBetColorArray[0];			// (metacog)
highBetColor_g		= highBetColorArray[1];
highBetColor_b		= highBetColorArray[2];

lowBetColor_r		= lowBetColorArray[0];			// (metacog)
lowBetColor_g		= lowBetColorArray[1];
lowBetColor_b		= lowBetColorArray[2];

betFixColor_r		= betFixColorArray[0];			// ((metacog)
betFixColor_g		= betFixColorArray[1];
betFixColor_b		= betFixColorArray[2];

proFixColor_r		= proFixColorArray[0];			// (metacog)
proFixColor_g		= proFixColorArray[1];
proFixColor_b		= proFixColorArray[2];






Event_fifo[Set_event] = StartInfos_;								// Let Matlab know that trial infos are going to start streaming in...
Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.
	
//---------------------------------------------------------------------------------------------------------------------------------------
	Event_fifo[Set_event] = InfosZero + allowFixTime;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + holdStopDuration;					// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + ssd;					// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + targIndex;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + expoJitterFlag;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + toneStopFailure;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (fixWinSize * 100);		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + fixColor_b;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + fixColor_g;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + fixColor_r;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
		
	Event_fifo[Set_event] = InfosZero + (fixSize * 100);		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + fixedTrialDuration;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (goPct * 100);			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + ignoreColor_b;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + ignoreColor_g;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + ignoreColor_r;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (ignorePct * 100);		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
		
	Event_fifo[Set_event] = InfosZero + interTrialDuration;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + holdtimeMax;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + saccDurationMax;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + saccTimeMax;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + holdtimeMin;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + nSSD;						// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + punishDuration;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + rewardDuration;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + rewardDelay;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
	Event_fifo[Set_event] = InfosZero + Staircase;					// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + stopColor_b;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + stopColor_g;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + stopColor_r;			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (stopPct * 100);		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + toneStopSuccess;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (targWinSize * 100);		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + targAngle;						// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + targColor_b;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + targColor_g;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + targColor_r;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (targAmp * 100);		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + targHoldtime;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (targSize * 100);				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + toneDuration;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + trialDuration;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + trialOutcome;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + trialType;					// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (eyeXGain * 100) + 1000;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
		
	Event_fifo[Set_event] = InfosZero + (eyeXOffset * 100) + 1000;	// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
			
	Event_fifo[Set_event] = InfosZero + (eyeYGain * 100) + 1000;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
		
	Event_fifo[Set_event] = InfosZero + (eyeYOffset * 100) + 1000;	// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
	
	Event_fifo[Set_event] = InfosZero + soa;					// Send event and... <-- added by Namsoo
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue





	Event_fifo[Set_event] = InfosZero + preTargHoldtime;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + postTargHoldtime;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targ1CheckerColor_r;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targ1CheckerColor_g;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targ1CheckerColor_b;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targ2CheckerColor_r;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targ2CheckerColor_g;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targ2CheckerColor_b;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + chkrWinSize * 100;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + nCheckerColumn;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + nCheckerRow;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + iSquareSizePixels;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + CheckerWidthDegrees * 100;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + CheckerHeightDegrees * 100;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + checkerAmp * 100;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + checkerAngle;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targAmp * 100;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + targAngle;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + distAmp * 100;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + distAngle;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + nDiscriminate;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + round(targ1CheckerProp * 100);				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	// printf("   INFOS Target 1 Percentage = %d\n", targ1CheckerProp*100);
	// printf("   INFOS Target 1 Proportion = %.3d\n", targ1CheckerProp);
			
	


	Event_fifo[Set_event] = InfosZero + goCheckerColor_r;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + goCheckerColor_g;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + goCheckerColor_b;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + nogoCheckerColor_r;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + nogoCheckerColor_g;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + nogoCheckerColor_b;		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + goCheckerProp * 100;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	iChecker = 0;		
	while (iChecker < 100)
		{
		Event_fifo[Set_event] = InfosZero + checkerboardArray[iChecker];				// Send event and...	
		Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
		iChecker = iChecker + 1;
		}


// After adding metacog suite:

	Event_fifo[Set_event] = InfosZero + (maskSize * 100);			// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
		
	Event_fifo[Set_event] = InfosZero + preBetHoldtime;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + preProHoldtime;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + highBetAngle;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + highBetAmp;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + lowBetAngle;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + lowBetAmp;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + maskColor_r;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + maskColor_g;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + maskColor_b;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + highBetColor_r;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + highBetColor_g;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + highBetColor_b;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + lowBetColor_r;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + lowBetColor_g;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + lowBetColor_b;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + betFixColor_r;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + betFixColor_g;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + betFixColor_b;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + proFixColor_r;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + proFixColor_g;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + proFixColor_b;				// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
			
	Event_fifo[Set_event] = InfosZero + (betWinSize * 100);		// Send event and...	
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.



	//---------------------------------------------------------------------------------------------------------------------------------------
	
Event_fifo[Set_event] = EndInfos_;									// Let Matlab know that trial infos are finished streaming in...
Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.	


}