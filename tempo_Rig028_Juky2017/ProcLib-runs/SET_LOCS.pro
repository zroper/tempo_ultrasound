declare SET_LOCS();

process SET_LOCS()
{
	declare hide int ia;
	declare hide int angDiff;
	//declare hide int targInd;
	
	// eventCodes     put that word in files where I drop event codes for pro/anti so it's searchable
	
	// First, check that the set size hasn't changed
	angDiff = 360/SetSize;
	ia = 0;
	while (ia < SetSize)
	{
		if (angleOffset < 0)
		{
			angleOffset = 90 + angleOffset;
		}
		Angle_list[ia] = (90+angleOffset-(angDiff*ia)) % 360;
		Eccentricity_list[ia] = SearchEcc;
		
		//Event_fifo[Set_event] = 5000 + Angle_list[ia];		// Set a strobe to identify this file as a Search session and...	
		//Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
		
		
		ia = ia+1;
	}
	Event_fifo[Set_event] = 900 + SearchEcc;		// Set a strobe to identify this file as a Search session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	Event_fifo[Set_event] = 300 + angleOffset;		// Set a strobe to identify this file as a Search session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	
	nexttick;	
}