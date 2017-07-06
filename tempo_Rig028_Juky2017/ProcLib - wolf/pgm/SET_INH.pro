// Sets up Inhibition function graph for cmanding 
// NOTE: GRAPHS.pro or OBJECT.pro needs to have been run already
// to set up globals.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare FirstStopTrial = 1; 								// GLOBAL ALERT; Lets UPD8_INH.pro know to reset counters


declare SET_INH();

process SET_INH()
	{
	declare int ssd_range;
	declare int inh_left;
	declare int inh_right;
	declare int inh_box_size;
	
	FirstStopTrial = 1;											// GLOBAL ALERT; Lets UPD8_INH.pro know to reset counters

	ssd_range = (ssdMax - ssdMin) * 1000;
	
	oSetGraph(gRIGHT, aCLEAR);
	
	if (ssdMin == ssdMax)
		{
		ssd_range = 200000;
		}
		
	inh_left = (ssdMin * 1000) - (ssd_range/40);
	inh_right = (ssdMax * 1000) + (ssd_range/40);
	
	oSetGraph(gRIGHT,   										// Object graph virt. coord
			aRANGE, 
			inh_left,  		
			inh_right,
			1025, 
			-25);			

	inh_box_size = (ssd_range/20);		
	
	oSetGraph(gRIGHT, aTITLE, "*** INHIBITION FUNCTION ***");	// Graph title
	
	object_ssd0 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object (20 is max b/c defaults.  could be changed.)
    oSetAttribute(object_ssd0, aINVISIBLE);						// Not visible yet
	
	object_ssd1 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd1, aINVISIBLE);						// Not visible yet
	
	object_ssd2 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd2, aINVISIBLE);						// Not visible yet
	
	object_ssd3 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd3, aINVISIBLE);						// Not visible yet
	
	object_ssd4 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd4, aINVISIBLE);						// Not visible yet
	
	object_ssd5 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd5, aINVISIBLE);						// Not visible yet
	
	object_ssd6 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd6, aINVISIBLE);						// Not visible yet
	
	object_ssd7 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd7, aINVISIBLE);						// Not visible yet
	
	object_ssd8 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd8, aINVISIBLE);						// Not visible yet
	
	object_ssd9 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd9, aINVISIBLE);						// Not visible yet
	
	object_ssd10 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd10, aINVISIBLE);						// Not visible yet
	
	object_ssd11 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd11, aINVISIBLE);						// Not visible yet
	
	nObject 		= object_ssd11; 			// update nObject to the biggest value possible
	
	}