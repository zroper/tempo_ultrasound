//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

// which room are we in?
declare constant hide int 	Room			= 23;		// which room are we in?


// viewing measurements used to compute degrees (units need to be the same)
declare constant hide float screenWidth 		= 40.00;	// in some units
declare constant hide float screenHeight		= 30.00;	// in some units
declare 		 hide float subjDist 		= 58.0;	// distance from center of subjects eyeball to screen
	
// where does your photodiode marker need to be?	
declare constant hide float pdLeft			= 1.0; //2.1; 		// distance from left of screen (same units as above)
declare constant hide float pdBottom		= 1.0; //1.8; 		// distance from bottom of screen (same units as above)
declare constant hide float pdSize			= 2;		// minimum targSize for consistant triggering (same units as above)
	
// what is your screen resolution	
declare constant hide int   screenPixelX    	= 1024;//640; //720;		// number of pixels across
declare constant hide int   screenPixelY    	= 768;//480;		// number of pixels in height
declare constant hide float	screenRefreshRate	= 70;		// in Hz

// what is the gain on your eye tracking setup?
// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
declare constant hide float	eyeXGain			= 60;//12.44;//3.622;	// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
declare constant hide float eyeYGain			= 60;//12.44;//3.837;	// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
//declare constant hide float eyeXGain			= 9.74;	// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
//declare constant hide float eyeYGain			= 11.23;	// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
// declare constant hide float	eyeXGain			= 4.8;	// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
// declare constant hide float eyeYGain			= 5;	// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)

declare hide float			eyeXOffset		= 0; 		// for zeroing x trace
declare hide float			eyeYOffset		= 0;		// for zeroing y trace

// what kind of hardware configuration are you using?
declare constant hide int	juiceChannel   = 0;   // line 0 is pin #51 (i.e. Digital A0 on the PIC-DAS1602)
declare constant hide int	stimChannel   = 6;//  (029 = 8;)    // line 8 is pin #59 (i.e. Digital BO on the PCI-DAS1602)
declare constant hide int	eyeXChannel   = 1;   
declare constant hide int	eyeYChannel   = 2;    
declare constant hide int	pdChannel  = 5;
declare constant hide float	maxVoltage 		= 10;		//look at das_gain and das_polarity in kped (setup tn)
declare constant hide float	analogUnits		= 65536;	// use this for a 64 bit AD board
// declare constant hide float analogUnits   = 4096;	// use this for a 12 bit AD board

// what kind of motion detector hardware are you using?
declare  hide 		checkMouthFlag		= 0;		// use this if you have a motion detector on the MOUTH going into channel 3
declare  hide 		checkBodyFlag		= 0;		// use this if you have a motion detector on the BODY going into channel 3