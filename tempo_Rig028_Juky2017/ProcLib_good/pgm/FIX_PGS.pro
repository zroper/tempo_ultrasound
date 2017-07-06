//--------------------------------------------------------------------------------------------------
// Figure out stimulus that will be needed on the next fixation trial and
// place it into video memory.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

							

declare FIX_PGS();                        										// see GRAPHS.pro

process FIX_PGS()                        										// see GRAPHS.pro
	{										
	// declare hide float 	targSize;   											// Global output will be sent as stobes...        										
	// declare hide int   	targColor;									
										
	// declare hide float	fixX;										
	// declare hide float	fixY;										
	
	// number the pgs that need to be drawn
	declare hide int   	blank       = 0;										
	declare hide int	fix      = 1;
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Calculate screen coordinates for stimuli on this trial								
	targSize         = sizeArray[targIndex];   													// Figure out the attributes of the current fix 
	targColor        = targIndex + 1;																// zero is reserved for black.  see SET_CLRS.pro							
													
	// fixX = cos(fixAngle) * fixAmp;														// find the center of the box in x and y space based on the angle and fixAmp...
	// fixY = sin(fixAngle) * fixAmp * -1;												
	// oMove(object_fix, fixX*deg2pix_X, fixY*deg2pix_Y);								// ...and move the animated graph object there.
	// oSetAttribute(object_fix, aSIZE, targSize*deg2pix_X, targSize*deg2pix_Y);							// while we are at it, resize fixation object on animated graph
	//oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									
	
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fix");
	dsendf("rw %d,%d;\n",fix,fix); 														// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(targSize, fixAngle, fixAmp, targColor, fill, deg2pix_X, deg2pix_Y);          	// draw fix
    
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	
	
	}