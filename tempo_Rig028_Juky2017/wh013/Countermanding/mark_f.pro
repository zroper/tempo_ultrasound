process MARKER()
{
    int MarkerOn;           									 // 0=we haven't yet seen a pulse, 1=we've seen a pulse
    int index;              									 // Indexes through all ASETS samples of a channel
	int nAsets=2;
	MarkerOn = 0; 
	 //print("MARKER_1 SPAWNED");                        						 // We haven't yet seen the TTL pulse
	while (!MarkerOn)                   						 // Keep going provided we haven't see the pulse...
    {
		// Scan the first 4 (presumably ASETS=4) samples on Counter5[] looking
		// for the LSD pulse.  If we find it, set an event in EventChannel 1[0]
		// which is the sum of "event" and the index (time) of the LSD pulse.
    	index = 0;
		

	    while (index < nAsets)               					 // index=0,1,2,3 (scan through ASETS samples) ..
        {
 	 
 			// We check to see if the LSD emitted a pulse.  We do this
 			// by calling ctable_set(), which returns the "previous" sample.
 			// I'm not sure why ctable_get() wasn't used instead.  There is
 			// some reason why the user wants to test if an LSD pulse was
 			// received while simultaneously setting counter channel 5 to 0.
        
        	if (ctable_set(1,index,0))          				 // If (Counter5[index] != 0) ...
            {       
                                    					 // ..(also sets Counter5[index]=0)
            	if (!MarkerOn)                  				 // Has event code already been set?
                {                           					 // No,

		 		  
         // VARIABLE USED...for TARGET_ON COULD BE COMPARED with TARGET_PRE 
         spawn SendTTLToRemoteSystem(2650);				   ///// event code target on
           		 //////////////////// Event create for neuro explorer  not used in the matlab code
		         //1 NPOS Number of stimulus position 
             spawn SendTTLToRemoteSystem(2800+trials[i]);	
             //print("SENT 2800");			   
             // CHANGE: MAY 31, 2006 BY ERIK EMERIC
				// CHANGE time_stop_signal to the time the photodiode value is recieved
				// If the current trial is an ISNOTNOGO
				if(types[j] == 2)
				{
					time_stop_signal = time() + (SSD_refresh+1)*Vrefresh;
				}
		  
				 //event_set(1,0,2650);	   // Event Code for Tempo data base.
				 //nexttick;			   

                  //	event_set(1,0,EV_TAR_ON); 					 // Set EventChannel1[0] = EV_TAR_ON.
                	MarkerOn = 1;               				 // Note that we've set the event code
                	TEST_VIDEO=1;
                }
            }
	        index = index + 1;                  				 // Advance to next element in Counter5[]
        }
    	// The LSD did not generate a pulse.  Wait one process cycle
    	// and continue looking for it.
    	nexttick;
    }
  // dsendf("co 0;");
  // dsend("xm targmarker(-640,510,0)");
  
	// We detected an LSD pulse.  Exit this processs.
}





process MARKER_2()
{
	
    int MarkerOn;           									 // 0=we haven't yet seen a pulse, 1=we've seen a pulse
    int index;              									 // Indexes through all ASETS samples of a channel
	int nAsets=2;
	MarkerOn = 0; 
	// print("MARKER_2 SPAWNED");                      						 // We haven't yet seen the TTL pulse
	while (!MarkerOn)                   						 // Keep going provided we haven't see the pulse...
    {
		// Scan the first 4 (presumably ASETS=4) samples on Counter5[] looking
		// for the LSD pulse.  If we find it, set an event in EventChannel 1[0]
		// which is the sum of "event" and the index (time) of the LSD pulse.
    	index = 0;
		

	    while (index < nAsets)               					 // index=0,1,2,3 (scan through ASETS samples) ..
        {
 	 
 			// We check to see if the LSD emitted a pulse.  We do this
 			// by calling ctable_set(), which returns the "previous" sample.
 			// I'm not sure why ctable_get() wasn't used instead.  There is
 			// some reason why the user wants to test if an LSD pulse was
 			// received while simultaneously setting counter channel 5 to 0.
        
        	if (ctable_set(1,index,0))          				 // If (Counter5[index] != 0) ...
            {       
                                    					 // ..(also sets Counter5[index]=0)
            	if (!MarkerOn)                  				 // Has event code already been set?
                {                           					 // No,

				  
		// VARIABLE USED...for TARGET_ON COULD BE COMPARED with TARGET_PRE 
 		spawn SendTTLToRemoteSystem(2654);	//////// event code stop on
		time_stop_signal = time();
			if(Stimu[s]==2)
			{
				if(STIM_MARKER==2)
				{
					while (time() < time_stop_signal + STIM_OFFSET)
						nexttick;
					if(!failed)
					{
						//print("uStim spawned ",time());
						spawn ELECT_STIM;
						time_stop_signal = time_stop_signal + 200000;
					}
					if (failed)
					{
						spawn SendTTLToRemoteSystem(667);	
					}
				}
			}
			//  print("SENT 2654 ");
			//  print("stop sig pd@M2");
			//  print (time_stop_signal);

		   event_set(1,0,2654);	   				 // Event Code for Tempo data base.
           nexttick;


                  //	event_set(1,0,EV_TAR_ON); 					 // Set EventChannel1[0] = EV_TAR_ON.
                	MarkerOn = 1;               				 // Note that we've set the event code
				//	print("MARKER_2 ON");
                }
            }
	        index = index + 1;                  				 // Advance to next element in Counter5[]
        }
    	// The LSD did not generate a pulse.  Wait one process cycle
    	// and continue looking for it.
    	nexttick;
    }
 // We detected an LSD pulse.  Exit this processs.
   
//nexttick;
  /*nexttick;
	nexttick;
      nexttick;
       nexttick;
	*/
  	 
}

process MARKER_FIX()
{
	int MarkerOn;           									 // 0=we haven't yet seen a pulse, 1=we've seen a pulse
	int index;              									 // Indexes through all ASETS samples of a channel
	int nAsets=2;
	MarkerOn = 0; 
	// We haven't yet seen the TTL pulse
	while (!MarkerOn)   // Keep going provided we haven't see the pulse...
	{
	// Scan the first 4 (presumably ASETS=4) samples on Counter5[] looking
	// for the LSD pulse.  If we find it, set an event in EventChannel 1[0]
	// which is the sum of "event" and the index (time) of the LSD pulse.
	index = 0;
	while (index < nAsets)               					 // index=0,1,2,3 (scan through ASETS samples) ..
	{	
		// We check to see if the LSD emitted a pulse.  We do this
		// by calling ctable_set(), which returns the "previous" sample.
		// I'm not sure why ctable_get() wasn't used instead.  There is
		// some reason why the user wants to test if an LSD pulse was
		// received while simultaneously setting counter channel 5 to 0.		
		if (ctable_set(1,index,0))          				 // If (Counter5[index] != 0) ...
		{       // ..(also sets Counter5[index]=0)			
			if (!MarkerOn)	// Has event code already been set?
			{               // No,	  
				// actually FixSpotOn_ 
				spawn SendTTLToRemoteSystem(2301);				   ///// event code target on
				MarkerOn = 1;               				 // Note that we've set the event code
				TEST_VIDEO=1;
			}
		}
		index = index + 1;                  				 // Advance to next element in Counter5[]
	}
	nexttick; // The LSD did not generate a pulse.  Wait one process cycle and continue looking for it.
	}	// We detected an LSD pulse.  Exit this processs.
}

