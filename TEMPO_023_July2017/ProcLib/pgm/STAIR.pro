// simple 1, 2, or 3 up down staircasing algorithm
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

				
declare STAIR(int nIndex);
			
process STAIR(int nIndex)
	{
	declare hide int	plus_minus;
	declare int			randStep;
	
	// For simple countermanding, make the step larger to make SSD less predictable. Otherwise, use smaller step
	if (state == stateCMD)
		{
		randStep = 2;
		}
	else
		{
		randStep = 1;
		// randStep = 0;
		}
		
		
	if (decideIndex == -1)
	{
		decideIndex = random(randStep) + 1;					// Sorry for weirdness.  See above.
	}
	
												// 1) figure out the random SSD step for the next trial
	plus_minus = 1 + random(randStep);  				// pick a number 1 or 2
	if (state == stateMCM)
		{
		plus_minus = -plus_minus;
		}
	
												// 2) add or subtrace SSD steps based on last trial performance.
	if (lastOutcome == success)
		{
		decideIndex = decideIndex + plus_minus; 	// increase SSD to make it harder
		}
	else if (lastOutcome == failure)
		{
		decideIndex = decideIndex - plus_minus; 	// decrease SSD to make it easier
		}
	
												// 3) set to limits if we went out of bounds
	if (decideIndex > nIndex - 1)
		{
		decideIndex = nIndex - 1;
		}
	if (decideIndex < 0)
		{
		decideIndex = 0;
		}
		

	}