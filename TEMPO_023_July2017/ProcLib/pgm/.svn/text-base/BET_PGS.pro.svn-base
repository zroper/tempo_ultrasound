//--------------------------------------------------------------------------------------------------
// process BET_PGS();
//
// Figure out all stimuli that will be needed on the next mem guided trial and
// place it all into video memory.
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011


declare BET_PGS();                       										// see GRAPHS.pro

process BET_PGS()	                       										// see GRAPHS.pro
{

// number the pgs that need to be drawn
declare hide int   	blank       		= 0;
declare hide int	pd					= 1;
declare hide int	betFix_pd			= 2;
declare hide int	betFix    			= 3;
declare hide int	fix_bet_pd			= 4;
declare hide int	fix_bet				= 5;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Calculate screen coordinates for stimuli on this trial


opposite = ((screenHeight/2)-pdBottom);														// Figure out angle and eccentricity of photodiode marker in pixels
adjacent = ((screenWidth/2)-pdLeft);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
pdAmp = sqrt((opposite * opposite) + (adjacent * adjacent));
pdAngle = rad2deg(atan (opposite / adjacent));
pdAngle = pdAngle + 180; 																	//change this for different quadrent or write some code for flexibility

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 1
// print("betFix with photodiode");
dsendf("rw %d,%d;\n",betFix_pd,betFix_pd); 												// draw second pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 2
// print("betFix with photodiode");
dsendf("rw %d,%d;\n",betFix,betFix); 												// draw second pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
nexttick;



//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 4
// print("betFix target and photodiode");
dsendf("rw %d,%d;\n",fix_bet_pd,fix_bet_pd);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
spawnwait DRW_SQR(betSize, highBetAngle, highBetAmp, highBetColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
spawnwait DRW_SQR(betSize, lowBetAngle, lowBetAmp, lowBetColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
spawnwait DRW_SQR(pdSize,pdAngle,pdAmp,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
nexttick;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 5
// print("fixation target and photodiode");
dsendf("rw %d,%d;\n",fix_bet,fix_bet);   								// draw 4th pg of video memory
dsendf("cl:\n");																			// clear screen
spawnwait DRW_SQR(fixSize, fixAngle, fixAmp, fixColor, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
spawnwait DRW_SQR(betSize, highBetAngle, highBetAmp, highBetColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
spawnwait DRW_SQR(betSize, lowBetAngle, lowBetAmp, lowBetColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
nexttick;


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Draw pg 0 (last is displayed first)
// print("blank");
dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
dsendf("cl:\n");                                                                            // clear screen (that's all)

}