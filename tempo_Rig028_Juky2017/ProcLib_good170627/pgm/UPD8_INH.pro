// Updates inhibition function in the animated graph online. 
// NOTE: SET_INH must have been run already to set inhibition
// function graph up.  Needed for global objects.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare UPD8_INH();

process UPD8_INH()
	{
	declare int ct;
	declare float hide weight;
	declare float hide change_value;
	declare int hide position_x;
	declare float hide position_y[12];  // nSSD = 12, but nSSD isn't initialized yet so we have to use 12 here
	declare float hide ct_ssd[12];		// ditto
	
	ct = 0;
	if (FirstStopTrial == 1)
		{
		while(ct < nSSD)
			{
			position_y[ct] = 0;
			ct_ssd[ct] = 0;
			ct = ct + 1;
			FirstStopTrial = 0;
			}
		}
	
	if (lastOutcome == success)
		{
		change_value = 0;
		}
	else if(lastOutcome == failure)
		{
		change_value = 1000;
		}
		
	
	position_x = (ssd * 1000.0/screenRefreshRate) * 1000;	

	weight = 1.0 / (ct_ssd[decideIndex] + 1.0);
	position_y[decideIndex] = ((1 - weight) * position_y[decideIndex]) + (change_value * weight);
	ct_ssd[decideIndex] = ct_ssd[decideIndex] + 1;

		
	//---------------------------------------------------------------------
	// SSD 0		
	if (ssd == ssdArray[0])
		{
		oSetAttribute(object_ssd0,aFILLED);
		oSetAttribute(object_ssd0,aVISIBLE);
		oMove(object_ssd0,position_x,position_y[0]);	
		}
	//---------------------------------------------------------------------
	// SSD 1		
	if (ssd == ssdArray[1])
		{
		oSetAttribute(object_ssd1,aFILLED);
		oSetAttribute(object_ssd1,aVISIBLE);
		oMove(object_ssd1,position_x,position_y[1]);	
		}
	//---------------------------------------------------------------------
	// SSD 2		
	if (ssd == ssdArray[2])
		{
		oSetAttribute(object_ssd2,aFILLED);
		oSetAttribute(object_ssd2,aVISIBLE);
		oMove(object_ssd2,position_x,position_y[2]);	
		}
	//---------------------------------------------------------------------
	// SSD 3		
	if (ssd == ssdArray[3])
		{
		oSetAttribute(object_ssd3,aFILLED);
		oSetAttribute(object_ssd3,aVISIBLE);
		oMove(object_ssd3,position_x,position_y[3]);	
		}
	//---------------------------------------------------------------------
	// SSD 4		
	if (ssd == ssdArray[4])
		{
		oSetAttribute(object_ssd4,aFILLED);
		oSetAttribute(object_ssd4,aVISIBLE);
		oMove(object_ssd4,position_x,position_y[4]);	
		}
	//---------------------------------------------------------------------
	// SSD 5		
	if (ssd == ssdArray[5])
		{
		oSetAttribute(object_ssd5,aFILLED);
		oSetAttribute(object_ssd5,aVISIBLE);
		oMove(object_ssd5,position_x,position_y[5]);	
		}
	//---------------------------------------------------------------------
	// SSD 6		
	if (ssd == ssdArray[6])
		{
		oSetAttribute(object_ssd6,aFILLED);
		oSetAttribute(object_ssd6,aVISIBLE);
		oMove(object_ssd6,position_x,position_y[6]);	
		}
	//---------------------------------------------------------------------
	// SSD 7		
	if (ssd == ssdArray[7])
		{
		oSetAttribute(object_ssd7,aFILLED);
		oSetAttribute(object_ssd7,aVISIBLE);
		oMove(object_ssd7,position_x,position_y[7]);	
		}
	//---------------------------------------------------------------------
	// SSD 8		
	if (ssd == ssdArray[8])
		{
		oSetAttribute(object_ssd8,aFILLED);
		oSetAttribute(object_ssd8,aVISIBLE);
		oMove(object_ssd8,position_x,position_y[8]);	
		}
	//---------------------------------------------------------------------
	// SSD 9		
	if (ssd == ssdArray[9])
		{
		oSetAttribute(object_ssd9,aFILLED);
		oSetAttribute(object_ssd9,aVISIBLE);
		oMove(object_ssd9,position_x,position_y[9]);	
		}
	//---------------------------------------------------------------------
	// SSD 10		
	if (ssd == ssdArray[10])
		{
		oSetAttribute(object_ssd10,aFILLED);
		oSetAttribute(object_ssd10,aVISIBLE);
		oMove(object_ssd10,position_x,position_y[10]);	
		}
	//---------------------------------------------------------------------
	// SSD 11		
	if (ssd == ssdArray[11])
		{
		oSetAttribute(object_ssd11,aFILLED);
		oSetAttribute(object_ssd11,aVISIBLE);
		oMove(object_ssd11,position_x,position_y[11]);	
		}
	//
	}