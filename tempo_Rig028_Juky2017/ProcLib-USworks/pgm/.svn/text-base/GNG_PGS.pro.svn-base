//--------------------------------------------------------------------------------------------------
// process GNG_PGS(int targIndex, 
				// float fixSize, 
				// int fixColor, 
				// int signalColor, 
				// float screenWidth, 
				// float screenHeight, 
				// float pdLeft, 
				// float pdBottom, 
				// float pdSize);
// Figure out all stimuli that will be needed on the next go/no-go trial and
// place it all into video memory.
//
// 11-2011: Based on CMD_PGS 	-pgm


declare GNG_PGS();                       										// see GRAPHS.pro

process GNG_PGS()                        										// see GRAPHS.pro
	{										
											
	
	// number the pgs that need to be drawn
	declare hide int   	blank       = 0;										
	declare hide int	fixation_pd = 1;										
	declare hide int	fixation    = 2;										
	declare hide int	cue_pd   	= 3;										
	declare hide int	cue      	= 4;										
	declare hide int	target_pd   = 5;										
	declare hide int	target      = 6;										
//	declare hide int	signal_pd   = 5;										
//	declare hide int	signal      = 6;
	
	declare int changeStimulus = 1;
	declare int keepStimulus = 0;


	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Calculate screen coordinates for stimuli on this trial								
	if (AutoTargetSizeFlag)
		{
		targSize        	 	= targAmp * TargetSizeConversion;   			// Figure out the attributes of the current target
		}
	else
		{
		targSize				= sizeArray[targIndex];
		}
	targColor        = targIndex + 1;																// zero is reserved for black.  see SET_CLRS.pro
													
	
	opposite = ((screenHeight/2)-pdBottom);														// Figure out angle and eccentricity of photodiode marker in pixels
	adjacent = ((screenWidth/2)-pdLeft);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	pdAmp = sqrt((opposite * opposite) + (adjacent * adjacent));
	pdAngle = rad2deg(atan (opposite / adjacent));
	pdAngle = pdAngle + 180; 																	//change this for different quadrent or write some code for flexibility
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fixation with photodiode");
	dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 2	  
	// print("fixation");
	dsendf("rw %d,%d;\n",fixation,fixation);   													// draw second pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;

	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 3
	// print("cue with photodiode");
	dsendf("rw %d,%d;\n",cue_pd,cue_pd); 												// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	spawnwait DRW_GNG(changeStimulus);   	// draw fixation point
	spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 4	  
	// print("cue");
	dsendf("rw %d,%d;\n",cue,cue);   													// draw second pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	spawnwait DRW_GNG(changeStimulus);   	// draw fixation point
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 5	 
	// print("target with photodiode");
	dsendf("rw %d,%d;\n",target_pd,target_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y); // draw fixation point
	spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
	
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 6	  
	// print("target");
	dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);         	// draw target
	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 5 
	// print("signal with photodiode");
//	dsendf("rw %d,%d;\n",signal_pd,signal_pd);    												// draw pg 5                                      
//	dsendf("cl:\n");																			// clear screen
//	spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);         	// draw target
//	if (Classic)
//	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, signalColor, fill, deg2pix_X, deg2pix_Y);   		// draw stop signal/ignore stim
//	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
//		{
//		spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
//		}
//	spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
  //  nexttick;
	
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 6	 
	// print("signal");
//	dsendf("rw %d,%d;\n",signal,signal);   														// draw pg 6                                       					
//	dsendf("cl:\n");																			// clear screen
//	spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
//	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, signalColor, fill, deg2pix_X, deg2pix_Y);   		// draw stop signal/ignore stim
//	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
//		{
//		spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
//		}
//	nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	
	
	}