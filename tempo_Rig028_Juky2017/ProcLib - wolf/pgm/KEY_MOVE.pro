//------------------------------------------------------------------------
// process KEY_MOVE()
// Give timeout and bad tone when the button is pressed.  Had to be written
// b/c can't spawn processes with input at command prompt (stupid). 
//
// paul.g.middlebrooks@vanderbilt.edu 	September, 2011

declare KEY_MOVE();

process KEY_MOVE()
	{
	declare hide int tone_freq, tone_durr;			
	
		Move_ct = 2;	
		tone_freq = 400;	
		tone_durr = round(Bmove_tout/2);
	
	spawnwait TONE(600,tone_durr);
	spawnwait TONE(1000,tone_durr);
	
	}