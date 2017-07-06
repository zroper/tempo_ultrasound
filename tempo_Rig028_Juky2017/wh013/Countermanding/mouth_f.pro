process WATCHMOUTH()                                                                                                                                      
{ 
	// MOTION DETECTOR ANALOG OUTPUT 
	// WHEN INACTIVE (STILL)+10V. WHEN ACTIVE (NOT_STILL) MOTION IS DETECTED AND ~0V 
	// THE UNIT WILL AUTOMATICALLY RESET TO INACTIVE AFTER MOTION CEASES.
	// THE DIP SWITCHES ON THE REAR OF THE UNIT DEFINE THE RESET INTERVAL.
	// CURRENTLY SET TO 1/2 SEC (SHORTEST INTERVAL AVAILIBLE). SO MOTIONS 
	// LESS THAN 1/2 SECOND APART WILL NOT BE DETECTED AS SEPARATE EVENTS.
	// 

	// CHECK STATUS AT BEGINNING OF TRIAL
	// Motion detection comes in on analog channel 3 IN TEMPO
	if (atable(3)>14500)
	{
		STATUS = STILL;// IF NOT MOVING 
	}
	else if (atable(3)<14500)
	{
		STATUS = NOT_STILL;// IF MOVING 
	}

 	while (1)	// Loop indefinitely.
    {							 
    	mouth = atable(3);// Motion detection comes in on analog channel 3
		if (STATUS == STILL & mouth < 14500)
		{
			// SEND MOVING STROBE TO PLEXON
			if (WRITE_PARAMS_FLAG==0)
				spawn SendTTLToRemoteSystem(2655);	
						
			STATUS = NOT_STILL; // SET STATUS TO NOT_STILL
		}
		else if (STATUS == NOT_STILL & mouth > 14500)
		{
			// SEND STOP MOVING STROBE TO PLEXON
			if (WRITE_PARAMS_FLAG==0)
				spawn SendTTLToRemoteSystem(2656);
			 
			STATUS = STILL;// SET STATUS TO STILL	
		}
		nexttick;
	}
}