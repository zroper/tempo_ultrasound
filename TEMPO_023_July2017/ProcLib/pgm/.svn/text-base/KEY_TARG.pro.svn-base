// This had be be written in this klugey way for 2 reasons
// 1) This has to only happen during fixation.  Otherwise, an accidental
// button press could upset the apple cart during cmanding.
// 2) There is no way to give user defined input to processes at the
// command promt (lame).

//------------------------------------------------------------------------
// process KEY_T_UP()
// Advance to the next target during the fixation task based on a user button press
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare KEY_T_UP();

process KEY_T_UP()
	{
	if (state == stateFIX)									// Global which defines which task we are running (2 = fixation)
		{
		targIndex = (targIndex + 1) % 9;
		}
	}
	
	
//------------------------------------------------------------------------
// process KEY_T_DN()
// Advance to the next target during the fixation task based on a user button press
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare KEY_T_DN();

process KEY_T_DN()
	{
	if (State == stateFIX)									// Global which defines which task we are running (2 = fixation)
		{
		targIndex = targIndex - 1;
		if (targIndex == -1)
			{
			targIndex = 8;
			}
		}	
	}