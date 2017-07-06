process MAIN() enabled 											 // "enabled" makes this process start when the protocol is started.  					   										 	 
																 // All other processes must be spawned.
{
	//dsend("cm *");
	dsendf("cm %d,%d,%d,%d;",col_tar,LumR,LumG,LumB);	
	print("target color change");
	//dsendf("cm %d,%d,%d,%d;",col_fix,LumR,LumG,LumB);
	 //LumR=21;  LumG=21; LumB=21;
	 //dsendf("cm %d,%d,%d,%d;",col_tar,LumR,LumG,LumB);
   	if(MONKEY==0)
	{
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
   	wait(10000);
	}

   	
   	print("---------------------------------------------");
	print("---------------------------------------------");
	print("########### COUNTERMANDING PROTOCOL ##########");
	print("---------------------------------------------");
	print("################ CREATED 12/2004 #############");
	print("---------------------------------------------");
	print("---------------------------------------------");

  	
  	 if(MONKEY==0)
	{
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	print("########## MONKEY SETTINGS NOT SELECTED ###########");
	spawn CLEAN_UP;
	}

  	 // MODIFIED: 01-17-2008  EEE		EYE'S DISTANCE FROM THE SCREEN IS FACTORED INTO DETERMINING THE VISUAL ANGLE	
	if(MONKEY==1) // Fechner rm 028
	{
		Distance = 42.50; // distance in cm from screen
	}  	  
	else if (MONKEY==2) // pep rm 028 
	{
		Distance = 39.50; // distance in cm from screen
	}
 
  	if (PLEXON) dioSetMode(0, PORTA|PORTB|PORTC);	
	
	if (seq_flag==1)//MODIFIED: 01-17-2008 EEE ADDED IF STATEMENT TO MAIN_F.PRO SO THAT THE SEQUENTIAL SHUFFLE IS ONLY PERFORMED IF THE SEQUENTIAL FLAG IS ON
	{
  		spawn sequential_shuffle;		  // pierre 06/13/06}
		waitforprocess sequential_shuffle; 		// pierre 06/13/06
    	}
	
	spawn CLEAR;
	waitforprocess CLEAR;    
	
	spawn INITIALIZE;			 							 	 // Initialize animation and VideoSync objects.
	waitforprocess INITIALIZE;

  //	spawn SHUFFLE;												 // Shuffle all the trial types.
  //	waitforprocess SHUFFLE;
		
	spawn WATCHEYE;			 								 	 // Monitor the eye coordinates.
	spawn WATCHMOUTH;
	spawn TRIAL_LOOP;			 								 // Start the trials.
}

