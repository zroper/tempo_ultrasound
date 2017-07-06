//--------------------------------------------------------------------------------------------------
// process MEM_PGS();
//
// Figure out all stimuli that will be needed on the next mem guided trial and
// place it all into video memory.
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011


declare VWM_PGS();                       										// see GRAPHS.pro

process VWM_PGS()	                       										// see GRAPHS.pro
{


// number the pgs that need to be drawn
declare hide int   	blank       		= 0;
declare hide int	pd					= 1;
declare hide int	fixation_pd			= 2;
declare hide int	fixation    		= 3;
declare hide int	fixation_target_pd	= 4;
declare hide int	fixation_target	= 5;
declare hide int	test_pd   		= 6;
declare hide int	test      		= 7;
declare hide int	emove     		= 8;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Calculate screen coordinates for stimuli on this trial

if (AutoTargetSizeFlag)
	{
	targSize        	 	= targAmp * TargetSizeConversion;   			// Figure out the attributes of the current target
	}
else
	{
	targSize				= sizeArray[targIndex]*3;
	}
//targAngle        = angleArray[targIndex]; 													// THESE USER DEFINED GLOBALS ARE ARRAYS SO
//targColor        = targIndex + 1;																// zero is reserved for black.  see SET_CLRS.pro


opposite = ((screenHeight/2)-pdBottom);														// Figure out angle and eccentricity of photodiode marker in pixels
adjacent = ((screenWidth/2)-pdLeft);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
pdAmp = sqrt((opposite * opposite) + (adjacent * adjacent));
pdAngle = rad2deg(atan (opposite / adjacent));
pdAngle = pdAngle + 180; 																	//change this for different quadrent or write some code for flexibility

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 1
// print("photodiode");
dsendf("rw %d,%d;\n",pd,pd);				 												// draw first pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 2
// print("fixation with photodiode");
dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw second pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 3
// print("fixation");
dsendf("rw %d,%d;\n",fixation,fixation);   													// draw 3rd pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 4
// print("fixation target and photodiode");
dsendf("rw %d,%d;\n",fixation_target_pd,fixation_target_pd);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

spawnwait DRW_SQR(targSize, LocArray[0], targAmp, ColorArray[0], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[1], targAmp, ColorArray[1], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[2], targAmp, ColorArray[2], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[3], targAmp, ColorArray[3], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize, LocArray[4], targAmp, ColorArray[4], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize, LocArray[5], targAmp, ColorArray[5], fill, deg2pix_X, deg2pix_Y);          	// draw target 

spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 5
// print("fixation and target");
dsendf("rw %d,%d;\n",fixation_target,fixation_target);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

spawnwait DRW_SQR(targSize, LocArray[0], targAmp, ColorArray[0], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[1], targAmp, ColorArray[1], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[2], targAmp, ColorArray[2], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[3], targAmp, ColorArray[3], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize, LocArray[4], targAmp, ColorArray[4], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize, LocArray[5], targAmp, ColorArray[5], fill, deg2pix_X, deg2pix_Y);          	// draw target 


nexttick;



//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 6
// print("target");
dsendf("rw %d,%d;\n",test_pd,test_pd);  																	// draw pg 6
dsendf("cl:\n");																							// clear screen 

spawnwait DRW_SQR(targSize, fixAngle, fixAmp, testColor, fill, deg2pix_X, deg2pix_Y);          				// draw target 

spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);										// draw photodiode marker
//spawnwait DRW_SQR(targSize*1, LocArray[0], targAmp, ColorArray[0], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize*1, LocArray[1], targAmp, ColorArray[1], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize*1, LocArray[2], targAmp, ColorArray[2], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize*1, LocArray[3], targAmp, ColorArray[3], fill, deg2pix_X, deg2pix_Y);          	// draw target 
// spawnwait DRW_SQR(targSize*1, LocArray[4], targAmp, ColorArray[4], fill, deg2pix_X, deg2pix_Y);          	// draw target 
// spawnwait DRW_SQR(targSize*1, LocArray[5], targAmp, ColorArray[5], fill, deg2pix_X, deg2pix_Y);          	// draw target 

nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 7
// print("target");
dsendf("rw %d,%d;\n",test,test);  																			// draw pg 7
dsendf("cl:\n");																							// clear screen 

spawnwait DRW_SQR(targSize, fixAngle, fixAmp, testColor, fill, deg2pix_X, deg2pix_Y);          				// draw target 
//spawnwait DRW_SQR(targSize*1, LocArray[0], targAmp, ColorArray[0], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize*1, LocArray[1], targAmp, ColorArray[1], fill, deg2pix_X, deg2pix_Y);          	// draw target
//spawnwait DRW_SQR(targSize*1, LocArray[2], targAmp, ColorArray[2], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize*1, LocArray[3], targAmp, ColorArray[3], fill, deg2pix_X, deg2pix_Y);          	// draw target 
//spawnwait DRW_SQR(targSize*1, LocArray[4], targAmp, ColorArray[4], fill, deg2pix_X, deg2pix_Y);          		// draw target 
// spawnwait DRW_SQR(targSize*1, LocArray[5], targAmp, ColorArray[5], fill, deg2pix_X, deg2pix_Y);          	// draw target  

nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Draw pg 8
dsendf("rw %d,%d;\n",emove,emove);   																	// draw 8th pg of video memory
dsendf("cl:\n");																						// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   					// draw fixation point

spawnwait DRW_SQR(targSize, LocArray[0], targAmp, ColorArray[0], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[1], targAmp, ColorArray[1], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[2], targAmp, ColorArray[2], fill, deg2pix_X, deg2pix_Y);          	// draw target 
spawnwait DRW_SQR(targSize, LocArray[3], targAmp, ColorArray[3], fill, deg2pix_X, deg2pix_Y);          	// draw target 
// spawnwait DRW_SQR(targSize, LocArray[4], targAmp, ColorArray[4], fill, deg2pix_X, deg2pix_Y);          	// draw target 
// spawnwait DRW_SQR(targSize, LocArray[5], targAmp, ColorArray[5], fill, deg2pix_X, deg2pix_Y);          	// draw target 


 // nexttick;








//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 0 (last is displayed first)
// print("blank");
dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
dsendf("cl:\n");                                                                            // clear screen (that's all)

}