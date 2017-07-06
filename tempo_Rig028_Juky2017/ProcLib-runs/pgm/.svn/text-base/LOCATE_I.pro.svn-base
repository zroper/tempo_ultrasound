//----------------------------------------------------------------------
// LOCATE_I - Updates the global variables In_FixWin and In_TargWin 
// which tell where the eyes are.  This is called by WATCHEYE.pro every
// time the eye position changes.
//
// IN
//      No args
//      eyeX
// 		eyeY                   Mouse/eye position
//      fix_win_left		    Target and Fixation window positions
// 		fix_win_right
// 		fix_win_down
// 		fix_win_up
// 		targ_win_left
// 		targ_win_right
// 		targ_win_down
// 		targ_win_up
//
// OUT
//      In_FixWin                1 for yes, 0 for no
//		In_TargWin
//
// NOTE:  The logic of this function does not preclude the eyes being
// both at fixaion and at the target simultaneously.  This could 
// happen if the user accidentally made two overlapping windows in the
// setup.  It is up to the user to handle this with input or in the 
// protocol.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
// 11-2011: Integrated choice countermanding task into ALL_PROS.pro. -pgm

declare int In_FixWin, In_TargWin, In_DistWin, In_ChkrWin, In_HighBetWin, In_LowBetWin;

declare LOCATE_I(float eyeX,
				float eyeY);
				
process LOCATE_I(float eyeX,
                float eyeY)
	{
	
	
	// See if subject is in the fixation window
	if (eyeX >= fix_win_left  &&
		eyeX <= fix_win_right &&
		eyeY <= fix_win_down  &&
		eyeY >= fix_win_up)
		{
		In_FixWin = 1;               // Subject is inside fixation window
		}
	else
		{
		In_FixWin = 0;               // Subject is not inside fixation window
		}
		
	// See if subject is in the target window
	if (eyeX >= targ_win_left  &&
		eyeX <= targ_win_right &&
		eyeY <= targ_win_down  &&
		eyeY >= targ_win_up)
		{
		In_TargWin = 1;               // Subject is inside target window
		}
	else
		{
		In_TargWin = 0;               // Subject is not inside taraget window	
		}


	// For the choice choice countermanding task, also check the distractor target and the checkered stimulus
	if (state == stateCCM)
		{
		// See if subject is in the distractor window 
		if (eyeX >= dist_win_left  &&
			eyeX <= dist_win_right &&
			eyeY <= dist_win_down  &&
			eyeY >= dist_win_up)
			{
			In_DistWin = 1;               // Subject is inside distractor window
			}
		else
			{
			In_DistWin = 0;               // Subject is not inside distractor window		
			}
			
			//See if subject is in the checkered stimulus window 
		if (eyeX > chkr_win_left  &&
			eyeX < chkr_win_right &&
			eyeY < chkr_win_down  &&
			eyeY > chkr_win_up)
			{
			In_ChkrWin = 1;               // Subject is inside checkered stimulus window
			}
		else
			{
			In_ChkrWin = 0;               // Subject is not inside checkered stimulus window	
			}
		}

	if (state == stateMCM)
		{
		// For mask tasks also check the distractor windows
		if (trialType != tBetTrial)
			{
			// For 2-target trials, look inside the distractor window
			if (nTarg == 2)
				{
				if (eyeX >= dist1_win_left  &&
					eyeX <= dist1_win_right &&
					eyeY <= dist1_win_down  &&
					eyeY >= dist1_win_up)
					{
					In_DistWin = 1;               // Subject is inside distractor window
					}
				else
					{
					In_DistWin = 0;               // Subject is not inside distractor window		
					}
				}
			// For 4-target trials, also look inside the other 2 distractor windows
			if (nTarg == 4)
				{
				if ((eyeX >= dist1_win_left  &&
					eyeX <= dist1_win_right &&
					eyeY <= dist1_win_down  &&
					eyeY >= dist1_win_up) ||
					(eyeX >= dist2_win_left  &&
					eyeX <= dist2_win_right &&
					eyeY <= dist2_win_down  &&
					eyeY >= dist2_win_up) ||
					(eyeX >= dist3_win_left  &&
					eyeX <= dist3_win_right &&
					eyeY <= dist3_win_down  &&
					eyeY >= dist3_win_up))
					{
					In_DistWin = 1;               // Subject is inside distractor window
					}
				else
					{
					In_DistWin = 0;               // Subject is not inside distractor window		
					}
				} // nTarg == 4
			} // trialType != tBetTrial
			

		// For betting tasks, also check the high and low bet windows
		if (trialType != tMaskTrial)
			{
			// See if subject is in the high bet window 
			if (eyeX >= highBet_win_left  &&
				eyeX <= highBet_win_right &&
				eyeY <= highBet_win_down  &&
				eyeY >= highBet_win_up)
				{
				In_HighBetWin = 1;               // Subject is inside distractor window
				}
			else
				{
				In_HighBetWin = 0;               // Subject is not inside distractor window		
				}
				
			// See if subject is in the low bet window 
			if (eyeX >= lowBet_win_left  &&
				eyeX <= lowBet_win_right &&
				eyeY <= lowBet_win_down  &&
				eyeY >= lowBet_win_up)
				{
				In_LowBetWin = 1;               // Subject is inside distractor window
				}
			else
				{
				In_LowBetWin = 0;               // Subject is not inside distractor window		
				}
			}
		}

	}