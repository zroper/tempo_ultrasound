//------------------------------------------------------------------------
// process KEY_REWD()
// Give reward and play a tone when the button is pressed.  Had to be written
// b/c can't spawn processes with input at command prompt (stupid). 
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare KEY_REWD();

process KEY_REWD()
	{
	declare hide int juice_duration, tone_freq, tone_durr;			
	
	// if (baseRewardDuration == 0)				//Don't know if these user defined globals have values yet
		// {
		// juice_duration = 80;
		// }
	// else
		// {
		// juice_duration = baseRewardDuration;
		// }
		// juice_duration = 50;
		juice_duration = 100;
		
	if (Success_Tone_medR == 0)				//Don't know if these user defined globals have values yet
		{
		tone_freq = 600;
		}
	else
		{
		tone_freq = Success_Tone_medR;
		}
	
	if (toneDuration == 0)					//Don't know if these user defined globals have values yet
		{
		tone_durr = 30;
		}
	else
		{
		tone_durr = toneDuration;
		}
	
	spawn JUICE(juiceChannel,juice_duration);
	// spawn TONE(tone_freq,tone_durr);
	
	}