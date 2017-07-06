//------------------------------------------------------------------------
// process KEY_STIM()
// Give stimulation  when the button is pressed.  Had to be written
// b/c can't spawn processes with input at command prompt. 
//

declare KEY_STIM();

process KEY_STIM()
	{
	
	spawn STIM(stimChannel,stimDuration);
	
	}