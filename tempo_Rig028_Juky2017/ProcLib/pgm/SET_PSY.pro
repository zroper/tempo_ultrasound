// Sets up  graph for go/no-go 
// NOTE: GRAPHS.pro or OBJECT.pro needs to have been run already
// to set up globals.
//
// 2012-04: adapted from SET_INH 	-pgm

declare FirstTrial 		= 1; 								// GLOBAL ALERT; Lets UPD8_PSY.pro know to reset counters


declare SET_PSY();

process SET_PSY()
	{
	declare int psy_range;
	declare int psy_left;
	declare int psy_right;
	declare int psy_box_size;
	
	FirstTrial = 1;											// GLOBAL ALERT; Lets UPD8_PSY.pro know to reset counters

	psy_range = 5 + (maxDiscriminate - minDiscriminate) * 1000;
	
	oSetGraph(gRIGHT, aCLEAR);
	
	if (minDiscriminate == maxDiscriminate)
		{
		psy_range = 1000;
		}
		
	psy_left = (minDiscriminate * 1000) - (psy_range/40);
	psy_right = (maxDiscriminate * 1000) + (psy_range/40);
	
	oSetGraph(gRIGHT,   										// Object graph virt. coord
			aRANGE,   
			psy_left,  		
			psy_right,
			1025, 
			-25);			

	psy_box_size = (psy_range/20);		
	
	oSetGraph(gRIGHT, aTITLE, "*** PSYCHOMETRIC FUNCTION ***");	// Graph title
	
	object_psy0 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object (20 is max b/c defaults.  could be changed.)
    oSetAttribute(object_psy0, aINVISIBLE);						// Not visible yet
	
	object_psy1 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy1, aINVISIBLE);						// Not visible yet
	
	object_psy2 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy2, aINVISIBLE);						// Not visible yet
	
	object_psy3 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy3, aINVISIBLE);						// Not visible yet
	
	object_psy4 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy4, aINVISIBLE);						// Not visible yet
	
	object_psy5 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy5, aINVISIBLE);						// Not visible yet
	
	object_psy6 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy6, aINVISIBLE);						// Not visible yet
	
	object_psy7 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy7, aINVISIBLE);						// Not visible yet
	
	object_psy8 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy8, aINVISIBLE);						// Not visible yet
	
	object_psy9 = oCreate(tBOX, gRIGHT, psy_box_size, 50);		// Create psy object
    oSetAttribute(object_psy9, aINVISIBLE);						// Not visible yet
		
	nObject 		= object_psy9; 			// update nObject to the biggest value possible
		
	// Reset counter arrays:
	nPsy[0] = 0;
	nPsy[1] = 0;
	nPsy[2] = 0;
	nPsy[3] = 0;
	nPsy[4] = 0;
	nPsy[5] = 0;
	nPsy[6] = 0;
	nPsy[7] = 0;
	nPsy[8] = 0;
	nPsy[9] = 0;

	nPsyRespond[0] = 0;
	nPsyRespond[1] = 0;
	nPsyRespond[2] = 0;
	nPsyRespond[3] = 0;
	nPsyRespond[4] = 0;
	nPsyRespond[5] = 0;
	nPsyRespond[6] = 0;
	nPsyRespond[7] = 0;
	nPsyRespond[8] = 0;
	nPsyRespond[9] = 0;

	nTarg1Respond[0] = 0;
	nTarg1Respond[1] = 0;
	nTarg1Respond[2] = 0;
	nTarg1Respond[3] = 0;
	nTarg1Respond[4] = 0;
	nTarg1Respond[5] = 0;
	nTarg1Respond[6] = 0;
	nTarg1Respond[7] = 0;
	nTarg1Respond[8] = 0;
	nTarg1Respond[9] = 0;

	}