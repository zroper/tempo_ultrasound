// simple 1, 2, or 3 up down staircasing algorithm
//
// 04-17-2012: created  -pgm

				
declare STAIR_DSC();
			
process STAIR_DSC()
	{
	declare hide int	plus_minus;
	declare int 		lowBound;
	declare int 		hiBound;
	declare hide int  	goTrial 		= 0;				// label these so they are easier to read below
	declare hide int  	nogoTrial 	= 1;				// label these so they are easier to read below
	
	// 1) figure out the random proportionIndex step for the next trial
	//-------------------------------------------
	plus_minus = 1 + random(3);  				// pick a number 1, 2, or 3
	
	
	
	// 3) establish bounds of increasing/decreasing the difficulty
	//-------------------------------------------
	if (trialType == goTrial)
		{
		hiBound 	= nDiscriminate - 1;
		lowBound	= (nDiscriminate / 2) + 1 - 1;
		}
	else if (trialType == nogoTrial)
		{
		hiBound = (nDiscriminate / 2) - 1 - 1;
		lowBound = 0;
		}


	// 2) add or subtract plus_minus steps based on last trial performance, respecting the bounds
	//-------------------------------------------
	if (lastoutcome == success && trialType == goTrial)
		{	
		proportionIndex = proportionIndex - plus_minus; 	// decrease PSY to make it harder
		if (proportionIndex < lowBound)
			{
			proportionIndex = hiBound;
			}		
		}
	else if (lastoutcome == failure && trialType == goTrial)
		{	
		proportionIndex = proportionIndex + plus_minus; 	// increase PSY to make it easier
		if (proportionIndex > hiBound)
			{
			proportionIndex = hiBound;
			}		
		}
	else if (lastoutcome == success && trialType == nogoTrial)
		{	
		proportionIndex = proportionIndex + plus_minus; 	// increase PSY to make it harder
		if (proportionIndex > hiBound)
			{
			proportionIndex = hiBound;
			}		
		}
	else if (lastoutcome == failure && trialType == nogoTrial)
		{	
		proportionIndex = proportionIndex - plus_minus; 	// decrease PSY to make it easier
		if (proportionIndex < lowBound)
			{
			proportionIndex = hiBound;
			}		
		}
	
	
	}