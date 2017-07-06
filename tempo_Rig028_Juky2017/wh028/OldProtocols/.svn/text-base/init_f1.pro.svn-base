process INITIALIZE()
{
 
  	
	 nASETS=4; // GetSystemInfo(GSI_ASETS); 							 // Get ASETS from TEMPO
          
	 // These are the animation graphs and objects.
	 oSetGraph(gRight, aRANGE, -XMAX_SCREEN/2, XMAX_SCREEN/2, -YMAX_SCREEN/2, YMAX_SCREEN/2); // Object graph virt. coord - Right Graph
	 oF = oCreate(tBOX, gRight, Fix_H, Fix_V);    			 // Create FIXATION object
	 oSetAttribute(oF, aVISIBLE);  //aIN            				 // Not visible yet
    
    	oE = oCreate(txCross, gRight, 20, 20);       				 // Create EYE object
    	oSetAttribute(oE, aVISIBLE);                				 // It's always visible

    	oSetGraph(gLeft, aRANGE, -XMAX_SCREEN/2, XMAX_SCREEN/2, -YMAX_SCREEN/2, YMAX_SCREEN/2);  // Object graph virt. coord - Left Graph
	oE1 = oCreate(txCross, gLeft, 20, 20);     					 // Create EYE object
	oSetAttribute(oE1, aVISIBLE);             					 // Visible only during a trial
	oSetAttribute(oE1, aREPLACE);               				 // Draw trace on left graph
	
	// These are the VideoSync Eye Cross used for debugging
	// dsendf("oc 1,3\n");                          				 // Cross hair for "eye"
	//dsendf("ow 1,20,20\n");                      				 // width & height
	//dsendf("oi 1,13\n");                         				 // color
	//dsendf("os 1\n");                            				 // make visible

 	dsend("dm fix_init($1, $2, $3)");  	
 	dsend("rf $1-5, $2-5, $1+5, $2+5");
	dsendf("co $3;");			  
	dsend("em");
	
	nexttick;													 // Wait one process cycle.

	dsend("vc -640, 640, -512, 512"); 							 // Set virtual coordinates.
	dsend("mv 0,0");		  									 // Move mouse to VC (0,0)
    

	spawn SendTTLToRemoteSystem(1501);					   


	//event_set(1,0,1501);									 // Event Code for Tempo data base.
	//nexttick;


	TrialCount = 0;                             				 // Zero out statistics
	SuccessCount = 0;
	NoStopCounter = 0;
	StopCounter = 0;
	NoStopSuccessCounter = 0;
	StopSuccessCounter = 0;
	Block = 0;
	fix_targ_maxT=Sacc_time;
	staircaseSSD1 = SSD_min;
	
	if(FIXED_JITTER==1)
	{
		EXPO_JITTER=0;
	}
	
	if(EXPO_JITTER==1)
	{
		FIXED_JITTER=0;
	}

//////////////////// needed when reshuffle or when we made a change during the session ////

	nSSD = ((SSD_max-SSD_min)/SSD_Step)+1;				
	
	NOGO_RATIO=NOGO_RATIO_Dial;
	ZAP_RATIO=ZAP_RATIO_Dial; 
	
	if (npos ==2)
	{
		tfraction_Dial = 50;
	}
	else if  (npos ==4)
	{
		tfraction_Dial = 25;
	}
	else if  (npos == 6)
	{
		tfraction_Dial = 17;
	}
	tfraction=tfraction_Dial;
	
	ISNOTNOGO_RATIO=ISNOTNOGO_RATIO_Dial;
	//////////////////////////////////////////////////////////////////////////
	//MWL
	//stop_fix_t = SSD_max*3;	 	 // Minimum time to fixate center after stop signal is presented. here in case of reshuffling
	//stop_fix_t = Sacc_time + 100 - SSD_min;
	//stop_fix_t = 3000 - stop[s]; doesn't work, only get one value set at beginning of shuffle
	//////////////////////////////////////////////////////////////////////////
}
