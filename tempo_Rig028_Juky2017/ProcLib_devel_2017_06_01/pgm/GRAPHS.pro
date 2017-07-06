// Modified version of OBJECT.pro which sets globals neccessary for use with
// animated graphs and also sets graphs up for countermanding task.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
// 11-2011: Integrated choice countermanding task into ALL_PROS.pro. -pgm

// Graph references used in oCreate() and oSetGraph()

hide constant gLEFT           =0;             						// Left graph
hide constant gRIGHT          =1;             						// Right graph
						
// Object types for use with oCreate()						
						
hide constant tPOINT          =1;             						// A single pixel
hide constant tBOX            =2;             						// A rectangle
hide constant tCROSS          =3;             						// '+' Horizontal/Vertical Cross
hide constant tXCROSS         =4;             						// 'x' Diagonal Cross
hide constant tELLIPSE        =5;             						// An ellipse (VideoSYNC only)
						
// Object attributes used by oSetAttribute()						
						
hide constant aXOR            =1;             						// Erase object when moving
hide constant aREPLACE        =2;             						// Replace pixels
hide constant aVISIBLE        =3;             						// Make object visible
hide constant aINVISIBLE      =4;             						// Don't draw object
hide constant aFILLED         =5;             						// Filled rectangle
hide constant aUNFILLED       =6;             						// Hollow rectangle
hide constant aSIZE           =7;             						// Resize box, cross, plus
			
// Graph attributes used by oSetGraph()			
			
hide constant aRANGE          =1;									// Define graph coordinate system
hide constant aTITLE          =2;									// Define graph title
hide constant aCLEAR          =3;									// Clear graph
			
declare hide object_fixwin,											// Eye and Box objects (left graph)
			object_eye,
			object_targwin,
			object_distwin,  										// distractor window, for choice countermanding task
			object_chkrwin,  										// checkered stimulus window, for choice countermanding task
			object_fix,
			object_targ,
			object_checker,
			object_distwin1,
			object_distwin2,
			object_distwin3,
			object_highBet,
			object_lowBet,
			object_highBetwin,
			object_lowBetwin;
			                 	  
declare hide object_ssd0 ;
declare hide object_ssd1 ;
declare hide object_ssd2 ;
declare hide object_ssd3 ;
declare hide object_ssd4 ;
declare hide object_ssd5 ;
declare hide object_ssd6 ;
declare hide object_ssd7 ;
declare hide object_ssd8 ;
declare hide object_ssd9 ;
declare hide object_ssd10;
declare hide object_ssd11;


declare hide object_psy0;
declare hide object_psy1;
declare hide object_psy2;
declare hide object_psy3;
declare hide object_psy4;
declare hide object_psy5;
declare hide object_psy6;
declare hide object_psy7;
declare hide object_psy8;
declare hide object_psy9;


declare GRAPHS();

process GRAPHS()
	{
	
	declare hide int left, right, down, up;
	
	nObject = object_psy9;  // keep track of how many objects there are so they can easily be destroyed when exiting a task
	
	oSetGraph(gleft, aCLEAR);
	
	// SETUP UP TARGET & EYE OBJECTS IN LEFT GRAPH
	left 	= screenPixelX/-2;
	right 	= screenPixelX/2;
	up 		= screenPixelY/-2;
	down 	= screenPixelY/2;
	
    oSetGraph(gleft, aRANGE, left, right, up, down);				// Object graph virt. coord
	oSetGraph(gleft, aTITLE, "*** TASK ***");						// Graph title
				
    object_fixwin = oCreate(tBOX, gLEFT, 0, 0);						// Create fix window object
    oSetAttribute(object_fixwin, aINVISIBLE);						// Not visible yet	
				
	object_targwin = oCreate(tBOX, gLEFT, 0, 0);					// Create target window object
    oSetAttribute(object_targwin, aINVISIBLE);						// Not visible yet
	
	// Have to inclued choice countermanding checker stimulus window and 2nd target windw here
	// (since GRAPHS.pro is called early in ALL_PROS.pro), but they don't get drawn if running regular countermanding task
	object_distwin = oCreate(tBOX, gLEFT, 0, 0);					// Create distractor window object
	oSetAttribute(object_distwin, aINVISIBLE);						// Not visible yet

	object_chkrwin = oCreate(tBOX, gLEFT, 0, 0);					// Create checkered stimulus window object
	oSetAttribute(object_chkrwin, aINVISIBLE);						// Not visible yet	

	object_fix = oCreate(tBOX, gLEFT, 0, 0);						// Create fix object
    oSetAttribute(object_fix,aFILLED);								// Draw it filled
	oSetAttribute(object_fix, aINVISIBLE);							// Not visible yet	
				
	object_targ = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
	oSetAttribute(object_targ,aFILLED);								// Draw it filled
    oSetAttribute(object_targ, aINVISIBLE);							// Not visible yet
	
	object_checker = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
	oSetAttribute(object_checker,aFILLED);								// Draw it filled
    oSetAttribute(object_checker, aINVISIBLE);							// Not visible yet

	object_distwin1 = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
    oSetAttribute(object_distwin1, aINVISIBLE);							// Not visible yet
	
	object_distwin2 = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
    oSetAttribute(object_distwin2, aINVISIBLE);							// Not visible yet
	
	object_distwin3 = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
    oSetAttribute(object_distwin3, aINVISIBLE);							// Not visible yet
	
	object_highBetwin = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
    oSetAttribute(object_highBetwin, aINVISIBLE);							// Not visible yet
	
	object_lowBetwin = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
    oSetAttribute(object_lowBetwin, aINVISIBLE);							// Not visible yet
	
	object_highBet = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
	oSetAttribute(object_highBet,aFILLED);								// Draw it filled
    oSetAttribute(object_highBet, aINVISIBLE);							// Not visible yet
	
	object_lowBet = oCreate(tBOX, gLEFT, 0, 0);						// Create target object
	oSetAttribute(object_lowBet,aFILLED);								// Draw it filled
    oSetAttribute(object_lowBet, aINVISIBLE);							// Not visible yet

    object_eye = oCreate(tCross, gLEFT, 2*deg2pix_X, 2*deg2pix_Y);	// Create EYE object
	oSetAttribute(object_eye, aVISIBLE);							// It's always visible
	

	nObject = object_eye;
	
	
	
	
	
	}		