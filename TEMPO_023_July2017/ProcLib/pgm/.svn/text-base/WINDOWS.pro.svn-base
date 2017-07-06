//----------------------------------------------------------------------------------------------------
// Process for locating fixation and target window locations.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
// 11-2011: Integrated choice countermanding task into ALL_PROS.pro. -pgm

declare hide float Fix_win_left;	
declare hide float Fix_win_right;		
declare hide float Fix_win_down;	
declare hide float Fix_win_up;	
declare hide float Targ_win_left;		
declare hide float Targ_win_right;	
declare hide float Targ_win_down;
declare hide float Targ_win_up;
declare hide float Dist_win_left;		// For Choice countermanding task
declare hide float Dist_win_right;	
declare hide float Dist_win_down;
declare hide float Dist_win_up;
declare hide float Chkr_win_left;		// For Choice countermanding task
declare hide float Chkr_win_right;	
declare hide float Chkr_win_down;
declare hide float Chkr_win_up;
declare hide float highBet_win_left;		// For Betting tasks
declare hide float highBet_win_right;	
declare hide float highBet_win_down;
declare hide float highBet_win_up;
declare hide float lowBet_win_left;		// For Betting tasks
declare hide float lowBet_win_right;	
declare hide float lowBet_win_down;
declare hide float lowBet_win_up;
declare hide float Dist1_win_left;		// For Choice countermanding task
declare hide float Dist1_win_right;	
declare hide float Dist1_win_down;
declare hide float Dist1_win_up;
declare hide float Dist2_win_left;		// For Choice countermanding task
declare hide float Dist2_win_right;	
declare hide float Dist2_win_down;
declare hide float Dist2_win_up;
declare hide float Dist3_win_left;		// For Choice countermanding task
declare hide float Dist3_win_right;	
declare hide float Dist3_win_down;
declare hide float Dist3_win_up;
     
     
     
              
declare WINDOWS();						// see SETC_TRL

process WINDOWS()						// see SETC_TRL
{
declare hide float fixX, fixY,
				targX, targY,
				distX, distY,
				chkrX, chkrY,
				dist1X, dist1Y,
				dist2X, dist2Y,
				dist3X, dist3Y,
				hbetX, hbetY,
				lbetX, lbetY,
				old_fix_win_size,
				old_targ_win_size,
				old_chkr_win_size,
				old_bet_win_size;
declare int i;




// find the center of the fixation spot in x and y space based on the angle and eccentricity	
fixX		= cos(fixAngle) * fixAmp;
fixY		= sin(fixAngle) * fixAmp * -1;
oMove(object_fix, fixX*deg2pix_X , fixY*deg2pix_Y); //move the animated graph window to location
oMove(object_fixwin, fixX*deg2pix_X , fixY*deg2pix_Y); //move the animated graph window to location
oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									


// find the center of the target in x and y space based on the angle and eccentricity
targX			= cos(targAngle) * targAmp;
targY			= sin(targAngle) * targAmp * -1;
oMove(object_targwin, targX*deg2pix_X , targY*deg2pix_Y); //move the animated graph window to location
oMove(object_targ, targX*deg2pix_X , targY*deg2pix_Y); //move the animated graph window to location
oSetAttribute(object_targ, aSIZE, targSize*deg2pix_X, targSize*deg2pix_Y);							// while we are at it, resize fixation object on animated graph


// Dynamically change the target window when the amplitude varies:
if (randomAmpFlag)
	{
	targwinSize = 4 + targAmp * .4;
	} 

// calculate the params of the fixation window
Fix_win_left 	= fixX - fixWinSize/2;					
Fix_win_right 	= fixX + fixWinSize/2;				
Fix_win_down 	= fixY + fixWinSize/2;
Fix_win_up		= fixY - fixWinSize/2;

// calculate the params of the target window
Targ_win_left	= targX - targWinSize/2;
Targ_win_down	= targY + targWinSize/2;
Targ_win_right	= targX + targWinSize/2;
Targ_win_up		= targY - targWinSize/2;

// If running choice countermanding, get distractor and chekered stimulus  window parameters, too
if (State == stateCCM)
	{
	// Move the distractor window to its location
	distX			= cos(distAngle) * distAmp;
	distY			= sin(distAngle) * distAmp * -1;
	oMove(object_distwin, distX*deg2pix_X , distY*deg2pix_Y); // move the animated graph window to location
	
	// calculate the params of the distractor window... pgm: for now the distractor is 180 degrees opposite from target
	Dist_win_left	= distX - targWinSize/2;
	Dist_win_down	= distY + targWinSize/2;
	Dist_win_right	= distX + targWinSize/2;
	Dist_win_up		= distY - targWinSize/2;
	
	// pgm: find the center of the checkered stimulus in x and y space based on the angle and eccentricity
	chkrX		= cos(checkerAngle) * checkerAmp;
	chkrY		= -1 * sin(checkerAngle) * checkerAmp;
	oMove(object_chkrwin, chkrX*deg2pix_X , chkrY*deg2pix_Y); //move the animated graph window to location
	oMove(object_checker, chkrX*deg2pix_X , chkrY*deg2pix_Y); //move the animated graph window to location

	// pgm: calculate the params of the checkered stimulus window
	Chkr_win_left	= chkrX - chkrWinSize/2;
	Chkr_win_down	= chkrY + chkrWinSize/2;
	Chkr_win_right	= chkrX + chkrWinSize/2;
	Chkr_win_up		= chkrY - chkrWinSize/2;
	}


// Need to move the mask (non-target) windows to their locations... 
if (State == stateMCM)
	{
	if (trialType != tBetTrial)
		{
		// Always at least 1 other mask location	
		dist1X	= cos(maskAngleArray[distIndex1]) * maskAmpArray[distIndex1];
		dist1Y	= -1 * sin(maskAngleArray[distIndex1]) * maskAmpArray[distIndex1];
		oMove(object_distwin1, dist1X*deg2pix_X , dist1Y*deg2pix_Y); //move the animated graph window to location

		// pgm: calculate the params of the 1st distractor window
		dist1_win_left	= dist1X - targWinSize/2;
		dist1_win_down	= dist1Y + targWinSize/2;
		dist1_win_right	= dist1X + targWinSize/2;
		dist1_win_up	= dist1Y - targWinSize/2;

		// Sometimes there 4 mask locations- need the other 2 distractors here	
		if (nTarg == 4)
			{
			dist2X	= cos(maskAngleArray[distIndex2]) * maskAmpArray[distIndex2];
			dist2Y	= -1 * sin(maskAngleArray[distIndex2]) * maskAmpArray[distIndex2];
			oMove(object_distwin2, dist2X*deg2pix_X , dist2Y*deg2pix_Y); //move the animated graph window to location

			dist3X	= cos(maskAngleArray[distIndex3]) * maskAmpArray[distIndex3];
			dist3Y	= -1 * sin(maskAngleArray[distIndex3]) * maskAmpArray[distIndex3];
			oMove(object_distwin3, dist3X*deg2pix_X , dist3Y*deg2pix_Y); //move the animated graph window to location

			// pgm: calculate the params of the 2nd distractor window
			dist2_win_left	= dist2X - targWinSize/2;
			dist2_win_down	= dist2Y + targWinSize/2;
			dist2_win_right	= dist2X + targWinSize/2;
			dist2_win_up	= dist2Y - targWinSize/2;
		
			// pgm: calculate the params of the 3rd distractor stimulus window
			dist3_win_left	= dist3X - targWinSize/2;
			dist3_win_down	= dist3Y + targWinSize/2;
			dist3_win_right	= dist3X + targWinSize/2;
			dist3_win_up	= dist3Y - targWinSize/2;
			}
			
		// if the user changes the size of the fix window update the graph
		if (nTrial == 1			||
			targWinSize != old_targ_win_size)
			{
			oSetAttribute(object_targwin, aSIZE, targWinSize*Deg2pix_X, targWinSize*Deg2pix_Y);
			oSetAttribute(object_targwin, aVISIBLE);
			oSetAttribute(object_distwin1, aSIZE, targWinSize*Deg2pix_X, targWinSize*Deg2pix_Y);
			oSetAttribute(object_distwin1, aVISIBLE);
			if (nTarg == 4)
				{
				oSetAttribute(object_distwin2, aSIZE, targWinSize*Deg2pix_X, targWinSize*Deg2pix_Y);
				oSetAttribute(object_distwin2, aVISIBLE);
				oSetAttribute(object_distwin3, aSIZE, targWinSize*Deg2pix_X, targWinSize*Deg2pix_Y);
				oSetAttribute(object_distwin3, aVISIBLE);
				}
			old_targ_win_size = targWinSize;
			}
		}
	if (trialType != tMaskTrial)
		{
		hbetX = cos(highBetAngle) * highBetAmp;												// find the center of the box in x and y space based on the targAngle and targAmp...
		hbetY = sin(highBetAngle) * highBetAmp * -1;
		oMove(object_highBet, hbetX*deg2pix_X, hbetY*deg2pix_Y);								// ...and move the animated graph object there.
		oMove(object_highBetwin, hbetX*deg2pix_X, hbetY*deg2pix_Y);								// ...and move the animated graph object there.
		oSetAttribute(object_highBet, aSIZE, targSize*deg2pix_X, targSize*deg2pix_Y);				// while we are at it, resize fixation object on animated graph
	
		highBet_win_left	= hbetX - betWinSize/2;
		highBet_win_down	= hbetY + betWinSize/2;
		highBet_win_right	= hbetX + betWinSize/2;
		highBet_win_up	= hbetY - betWinSize/2;

		lbetX = cos(lowBetAngle) * lowBetAmp;												// find the center of the box in x and y space based on the targAngle and targAmp...
		lbetY = sin(lowBetAngle) * lowBetAmp * -1;
		oMove(object_lowBet, lbetX*deg2pix_X, lbetY*deg2pix_Y);								// ...and move the animated graph object there.
		oMove(object_lowBetwin, lbetX*deg2pix_X, lbetY*deg2pix_Y);								// ...and move the animated graph object there.
		oSetAttribute(object_lowBet, aSIZE, targSize*deg2pix_X, targSize*deg2pix_Y);					// while we are at it, resize fixation object on animated graph

		lowBet_win_left	= lbetX - betWinSize/2;
		lowBet_win_down	= lbetY + betWinSize/2;
		lowBet_win_right	= lbetX + betWinSize/2;
		lowBet_win_up	= lbetY - betWinSize/2;

		// if the user changes the size of the bet window update the graph
		if (nTrial == 1			||
			betWinSize != old_bet_win_size)
			{
			oSetAttribute(object_highBetWin, aSIZE, betWinSize*Deg2pix_X, betWinSize*Deg2pix_Y);
			oSetAttribute(object_highBetWin, aVISIBLE);
			oSetAttribute(object_lowBetWin, aSIZE, betWinSize*Deg2pix_X, betWinSize*Deg2pix_Y);
			oSetAttribute(object_lowBetWin, aVISIBLE);
			old_bet_win_size = betWinSize;
			}
		}
	}

	
// if the user changes the size of the fix window update the graph
if (nTrial == 1			||
	fixWinSize != old_fix_win_size)
	{
	oSetAttribute(object_fixwin, aSIZE, fixWinSize*Deg2pix_X, fixWinSize*Deg2pix_Y);
	oSetAttribute(object_fixwin, aVISIBLE);
	old_fix_win_size = fixWinSize;
	}
	
// if the user changes the size of the targ window update the graph
if (nTrial == 1			||
	targWinSize != old_targ_win_size)
	{
	oSetAttribute(object_targwin, aSIZE, targWinSize*Deg2pix_X, targWinSize*Deg2pix_Y);
	oSetAttribute(object_targwin, aVISIBLE);
	old_targ_win_size = targWinSize;
	
	// For choice countermanding task, do the same for the distractor window
	if (State == stateCCM)
		{
		oSetAttribute(object_distwin, aSIZE, targWinSize*Deg2pix_X, targWinSize*Deg2pix_Y);
		oSetAttribute(object_distwin, aVISIBLE);
		}
	}
	
// For choice countermanding task: if the user changes the size of the stimulus window update the graph
if (State == stateCCM)
	{
	if (nTrial == 1			||
		chkrWinSize != old_chkr_win_size)
		{
		oSetAttribute(object_chkrwin, aSIZE, chkrWinSize*Deg2pix_X, chkrWinSize*Deg2pix_Y);
		oSetAttribute(object_chkrwin, aVISIBLE);
		old_chkr_win_size = chkrWinSize;
		}
	}
if (state == stateVWM) //(State == stateVWM)
	{

	if (samediff == 1) //same
		{
		testColor = ColorArray[0];
		targAngle = LocArray[0];
		targAmp = testAmp;
			
		}
	else if (samediff == 2) //diff
		{
		testColor = ColorArray[6];
		targAngle = 0;
		targAmp = testAmp;
		}
	
	// find the center of the fixation spot in x and y space based on the angle and eccentricity	
	// fixX		= cos(fixAngle) * fixAmp;
	// fixY		= sin(fixAngle) * fixAmp * -1;
	// oMove(object_fix, fixX*deg2pix_X , fixY*deg2pix_Y); //move the animated graph window to location
	// oMove(object_fixwin, fixX*deg2pix_X , fixY*deg2pix_Y); //move the animated graph window to location
	// oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									


	// find the center of the target in x and y space based on the angle and eccentricity
	printf("targAngle = %d\n",targAngle);
	targX			= cos(targAngle) * targAmp;
	targY			= sin(targAngle) * targAmp * -1;
	oMove(object_targwin, targX*deg2pix_X , targY*deg2pix_Y); //move the animated graph window to location
	oMove(object_targ, targX*deg2pix_X , targY*deg2pix_Y); //move the animated graph window to location
	oSetAttribute(object_targ, aSIZE, targSize*deg2pix_X, targSize*deg2pix_Y);	
	
	// calculate the params of the fixation window
	Fix_win_left 	= fixX - fixWinSize/2;					
	Fix_win_right 	= fixX + fixWinSize/2;				
	Fix_win_down 	= fixY + fixWinSize/2;
	Fix_win_up		= fixY - fixWinSize/2;

	// calculate the params of the target window
	Targ_win_left	= targX - targWinSize/2;
	Targ_win_down	= targY + targWinSize/2;
	Targ_win_right	= targX + targWinSize/2;
	Targ_win_up		= targY - targWinSize/2;	
	
	}
}