//--------------------------------------------------------------------------------------------------
// process CCM_PGS();
//
// Figure out all stimuli that will be needed on the next countermanding trial and
// place it all into video memory.
//
// 11-2011: Based on CMD_PGS, integrated choice countermanding task into ALL_PROS.pro. -pgm



declare CCM_PGS();                       										// see GRAPHS.pro

process CCM_PGS()                        										// see GRAPHS.pro
{										
										
// number the pgs that need to be drawn
declare hide int   	blank       = 0;										
// declare hide int	fixation_pd = 1;										
// declare hide int	fixation    = 2;										
declare hide int	target_pd   = 1;										
declare hide int	target      = 2;										
declare hide int	choice_pd   = 3;										
declare hide int	choice      = 4;										
declare hide int	signal_pd   = 5;										
declare hide int	signal      = 6;

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

	
										

opposite = ((screenHeight/2)-pdBottom);											// Figure out angle and eccentricity of photodiode marker in pixels
adjacent = ((screenWidth/2)-pdLeft);                                        	// NOTE: I am assuming your pd is in the lower left quadrant of your screen
pdAmp = sqrt((opposite * opposite) + (adjacent * adjacent));
pdAngle = rad2deg(atan (opposite / adjacent));
pdAngle = pdAngle + 180; 														//change this for different quadrent or write some code for flexibility


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 1
// print("fixation with photodiode");
// dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
// dsendf("cl:\n");																			// clear screen
// spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
// spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 2	  
// print("fixation");
// dsendf("rw %d,%d;\n",fixation,fixation);   													// draw second pg of video memory                                       
// dsendf("cl:\n");																			// clear screen
// spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
// nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 1	 
// print("target with photodiode");
dsendf("rw %d,%d;\n",target_pd,target_pd);  												// draw pg 3                                        
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          // draw target
spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);    	// draw distractor
if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
	{
	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y); // draw fixation point
	}
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 2	  
// print("target");
dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);         	// draw target
spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);     	// draw distractor
if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
	{
	spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	}
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 3	 
// print("choice stim with photodiode");
dsendf("rw %d,%d;\n",choice_pd,choice_pd);  												// draw pg 3                                        
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          // draw target
spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);    	// draw distractor
spawnwait DRW_CHKR(changeStimulus);  														// draw checkered stimulus
if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
	{
	if (ccmDelayFlag)
		{
		spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y); // draw fixation point
		}
	else
		{
		spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
		}
	}
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 4	  
// print("choice stim");
dsendf("rw %d,%d;\n",choice,choice);  														// draw pg 4                                        
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);         	// draw target
spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);     	// draw distractor
spawnwait DRW_CHKR(keepStimulus);  															// draw checkered stimulus
if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
	if (ccmDelayFlag)
		{
		spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y); // draw fixation point
		}
	else
		{
		spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
		}
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 7 
// print("signal with photodiode");
dsendf("rw %d,%d;\n",signal_pd,signal_pd);    												// draw pg 5                                      
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);         	// draw target
spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y);    	// draw distractor
spawnwait DRW_CHKR(keepStimulus);  																// draw checkered stimulus
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
spawnwait DRW_SQR(fixSize*1, fixAngle, fixAmp, signalColor, fill, deg2pix_X, deg2pix_Y);   		// draw stop signal/ignore stim
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 8	 
// print("signal");
dsendf("rw %d,%d;\n",signal,signal);   														// draw pg 6                                       					
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          // draw target
spawnwait DRW_SQR(targSize, distAngle, distAmp, targColor, fill, deg2pix_X, deg2pix_Y); 		// draw distractor
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, open, deg2pix_X, deg2pix_Y); // draw fixation point
spawnwait DRW_SQR(fixSize*1, fixAngle, fixAmp, signalColor, fill, deg2pix_X, deg2pix_Y);   		// draw stop signal/ignore stim
spawnwait DRW_CHKR(keepStimulus);  																// draw checkered stimulus
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
// Draw pg 0 (last is displayed first)	
// print("blank"); 																			
dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
dsendf("cl:\n");                                                                            // clear screen (that's all)


}
