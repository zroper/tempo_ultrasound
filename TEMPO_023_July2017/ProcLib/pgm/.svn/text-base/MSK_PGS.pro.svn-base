//--------------------------------------------------------------------------------------------------
// process MSK_PGS();
//
// Figure out all stimuli that will be needed on the next mem guided trial and
// place it all into video memory.
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011


declare MSK_PGS();                       										// see GRAPHS.pro

process MSK_PGS()	                       										// see GRAPHS.pro
{

// number the pgs that need to be drawn
declare hide int   	blank       		= 0;
declare hide int	fixation_pd			= 1;
declare hide int	fixation    		= 2;
declare hide int	fixation_target		= 3;
declare hide int	fix_mask_pd			= 4;
declare hide int	fix_mask    		= 5;
declare hide int	mask_pd   			= 6;
declare hide int	mask      			= 7;

declare int i;
declare int tempFixColor;

declare float iMaskAngle, iMaskAmp;
if (trialType == tProTrial)
	{
	tempFixColor = proFixColor;
	}
else
	{
	tempFixColor = fixColor;
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Calculate screen coordinates for stimuli on this trial

targColor        = targIndex + 1;												// zero is reserved for black.  see SET_CLRS.pro

opposite = ((screenHeight/2)-pdBottom);														// Figure out angle and eccentricity of photodiode marker in pixels
adjacent = ((screenWidth/2)-pdLeft);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
pdAmp = sqrt((opposite * opposite) + (adjacent * adjacent));
pdAngle = rad2deg(atan (opposite / adjacent));
pdAngle = pdAngle + 180; 																	//change this for different quadrent or write some code for flexibility


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 1
// print("fixation with photodiode");
dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw second pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, tempFixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 2
// print("fixation");
dsendf("rw %d,%d;\n",fixation,fixation); 												// draw second pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, tempFixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
nexttick;


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 3
// print("fixation target and photodiode");
dsendf("rw %d,%d;\n",fixation_target,fixation_target);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, tempFixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
spawnwait DRW_SQR(targSize, targAngle, targAmp, targColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 4
// print("fixation target and photodiode");
dsendf("rw %d,%d;\n",fix_mask_pd,fix_mask_pd);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, tempFixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
i = 0;
while (i < nTarg)
	{
	// iMaskAngle = maskAngleArray[i];
	// iMaskAmp = maskAmpArray[i];
	// spawnwait DRW_SQR(maskSize, iMaskAngle, iMaskAmp, maskColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	spawnwait DRW_SQR(maskSize, maskAngleArray[i], maskAmpArray[i], maskColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	i = i + 1;
	}
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 5
// print("fixation target and photodiode");
dsendf("rw %d,%d;\n",fix_mask,fix_mask);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, tempFixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
i = 0;
while (i < nTarg)
	{
	spawnwait DRW_SQR(maskSize, maskAngleArray[i], maskAmpArray[i], maskColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	i = i + 1;
	}
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 6
// print("fixation target and photodiode");
dsendf("rw %d,%d;\n",mask_pd,mask_pd);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
i = 0;
while (i < nTarg)
	{
	spawnwait DRW_SQR(maskSize, maskAngleArray[i], maskAmpArray[i], maskColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	i = i + 1;
	}
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 7
// print("fixation target and photodiode");
dsendf("rw %d,%d;\n",mask,mask);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
i = 0;
while (i < nTarg)
	{
	spawnwait DRW_SQR(maskSize, maskAngleArray[i], maskAmpArray[i], maskColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
	i = i + 1;
	}
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 0 (last is displayed first)
// print("blank");
dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
dsendf("cl:\n");                                                                            // clear screen (that's all)

}