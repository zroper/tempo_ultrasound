/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																				   //
//																																				   //
//                                                        MEMORY GUIDED TASK.	DECEMBER 2004													   //
//																																				   //
//                                           Created by pierre_pouget@vanderbilt.edu  & erik.emeric@vanderbilt.edu												   //
//																																				   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFIED: 10-07-2007 EEE
//	 	DISTANCE FROM EACH MONK'S EYE TO MONITOR IS USED TO DETERMINE REAL VISUAL DEGREES
//  	
//		The visual angle, V, can be computed with the formula:
//		S is the object's frontal linear size (metric size) in meters
//		D is its distance from the eye
//			V = arctan(S/D);
//		For V < 10 the following approximation is ok
//			V = 57.3(S/D) degrees
//		In room 028:
// 			Fechner's D = 42.50; Pep's D = 39.50; (cm) 
//
// MODIFIED: 05-24-07 EEE
//		ADDED RATIO OF HOR VS VERT SCREEN DISTORTION
//		Y = 1.23*y, WHERE y IS THE VALUE OF Y IF THE SCREEN WAS SQUARE
// 
// MODIFIED 05/24/07 EEE
// 		STIM FILE INFO now included
//
// MODIFIED 03/06/07 EEE
// 		ADDED EVENT FOR FIX SPOT OFF (2300)
//		AND ADDED PHOTODIODE EVENT TOO (3 PD EVENTS IN A TRIAL TARGET FIX OFF & TARGET REAPPEAR)
//
// MODIFIED: 2-23-06
// 		ADDED cm COMMAND TO INCREASE THE LUMINANCE OF THE MARKER
// 		BECAUSE IT WAS NOT BRIGHT ENOUGH TO DRIVE THE PHOTODIODE
//
// MODIFIED 1-30-2007 EEE
// 		CHANGED THE REWARD CHANNEL TO 9 , PREVIOUSLY WAS 0
//		OLD
//  	mio_dig_set(0,0);

//////////////////////////////////////// SUBFUNCTION NEEDED ///////////////////////////

#pragma declare = 1                     					 	 // Require declarations of all variables.
#include object.pro                   						     // Required when using object graphs.
#include DIO.pro

/////////////////////////////////////////////

declare MONKEY=1;
// MODIFIED: 09-12-2007 EEE DISTANCE FROM EACH MONK'S EYE TO MONITOR IS USED TO DETERMINE REAL VISUAL DEGREES
declare float Distance; // DISTANCE FROM EACH MONK'S EYE TO MONITOR. user defined in main_f.pro	
declare float S_dist; 	// distance from fixation to target in cm

declare Task=2;                       // Memory guided
declare TEST_VIDEO = 0;
declare READY_S=0;
declare int nASETS;						// Current setting for ASETS .
declare toto=0;							// variables for debugging
declare step=0;
declare eFix_H;             					 	 // Get actual horizontal analog values.
declare eFix_V;

// Declare variables.

declare oF, oF1, oE, oE1, oB1, oB1x;							 //	Animation object variables.
			 			 

//////////////////////////////// Declare Monkey Settings

declare DEBUG;               // =0 for real analog, =1 for mouse input
declare AUTOMONKEY;          // =1 for automatic monkey
declare Fix_H = 190;	   	 // Size of box in which eye can be and be said to fixate center.
declare Fix_V = 190;
declare Volt_Fix_H_1;        // Voltage value for Fixation Window
declare Volt_Fix_V_1;
declare Volt_Fix_H_2;        // Voltage value for Fixation Window
declare Volt_Fix_V_2;
declare Sign_Volt_Fix_H_1;
declare Sign_Volt_Fix_H_2;
declare Sign_Volt_Fix_V_1;
declare Sign_Volt_Fix_V_2;
declare Targ_H =210;         // Size of box in which eye can be and be said to fixate target.
declare Targ_V = 210;
declare int Volt_Targ_H_1;	 // Voltage value for the Target window
declare int Volt_Targ_V_1;
declare int Volt_Targ_H_2;	 // Voltage value for the Target window
declare int Volt_Targ_V_2;
declare H_OFFSET;
declare V_OFFSET;
declare XGAIN = 30;
declare YGAIN = -30;
declare XMAX = 1280;		 // Variables for size of animation graph windows.
declare YMAX = 1024;		 // Variables for size of animation graph windows.

//////////////////////////////////////////////////


declare SOUND_FLAG = 0;					 // Creat sound  start  
declare float TrialCount, SuccessCount;	 // Trial record variables.
declare ERR_OK = 0;						 // Sets variable Failed to 0 at beginning.
declare ERR_LEAVE_FIX = 1;				 // Error: left fixation too quickly.
declare ERR_NO_FIXHOLD = 2;				 // Error: did not hold fixation long enough.
declare ERR_TAR_TOOLATE = 3;			 // Error: did not acquire target quickly enough.
declare ERR_NO_HOLDTAR = 4;				 // Error: did not hold target (targ or fixation) long enough.
declare ERR_NOFIX_STOPTRIAL = 5;		 // Error: made a saccade in a stop-signal trial.
declare ERR_TIME_SAC = 6;
declare In_Fixation_Window = 0;			 // Tracks whether eye position is in fixation square.
declare In_Target = 0;					 // Tracks whether the eye is in the target box.
declare failed = 0;						 // Monitors whether trial has failed.
declare in_init_fixation_window;		 // Tracks whether the eye is in the initial fixation area.
declare fix_control=0; 					 // Controlling whether monkey needs to fix before trial; default=0; fix_conto=1 no fix needed
declare end;							 // Marks time on clock when holding time for target or fixating time in stop-signal trials ends.
declare sac_latency;					 // Records latency of saccade to target.
declare correctmarker = 0;				 // Marks whether the trial was a success for WRITE_PARAMS().
declare	signal_respond_marker = 0;		 // Marks whether trial failed because it was a signal-respond trial.
declare signal_respond_punishT =0;

//////////////////////// TIME ON THE CLOCK////////////////////

declare start_time;						 // Stores the time at which a trial begins.
declare end_fix_presentationT;			 // Marks the time on the clock when the fixation box will disappear.
declare end_fix_targ_maxT;				 // Marks the time on the clock by which the subject must have saccaded from fix to target.
declare end_initfix_minT;				 // Marks the time on the clock during which the eye must be in the initial fix area (time() + initfix_minT).
declare stop_signal_startT;				 // Marks the time when the stop signal was presented.
declare React_time_max;
declare Saccade_time;
Saccadic_time;

/////////////////////////////// MEMORY GUIDED VARIABLES

declare REWARD_SIZE=60; 
declare SOUND_S;
declare SOUND_REWARD=0;
declare frac_no_reward = 0;             // % of no reward trial (which should be rewarded
declare REWARD_RATIO=100;				// Fraction of rewarded trial ( 09/21/2004 =1 Loop need to be added
declare frac_extra_reward =0;
declare Bell = 1;
declare PAUSE_REWARD=300;
///////////////////////////// FRACTION JITTER IF LINEAR

declare FIXED_JITTER=1;
declare EXPO_JITTER=0;
declare frac_fix_jitter=20;
declare float expo_1;
declare float expo_2;
declare float expo_3;		 // Turn on animation.
declare float expo_4;

declare int expo_jitter_fixation;
declare int expo_jitter_target;
declare int expo_jitter_stop;

///////////////////////////// HOLD Time 

declare int hold_time_memory;	 // Tracks presentation time of fixation which is fix_t plus a random amount.
declare HOLDT;
declare fix_t = 500;			 // Presentation time of fixation point. 
declare fix_jitter = 20;
declare hold_fixation_time;
declare memory_fix_t = 1000;		 // Time to fixate center after stop signal is presented.
declare frac_stop_t_jitter=40;
declare memory_fix_t_jitter;
declare memory_fix_time;
declare fix_targ_maxT =  600; //memory_fix_t*3 ; MWL  // Maximum RT for moving from fixation window to target window.
declare Sacc_time=300;		   // Time between leaving fixation and enter inot the Target
declare step_lat;
declare trial_start;
declare step_wind;
declare step_targ;
declare Hold_on_target=200;
declare Hold_targ;
declare frac_targ_t_jitter=0;
declare targ_fix_t_jitter;
declare targ_fix_time;


///////////////////////////

declare intertrial, inter_trial = 500;	  // Intertrial interval variables.
declare initfix_minT = 50;  			  // Initial fixation requirement time.
declare initfix_punishtime = 300;		  // Amount of wait time for punishment if initial fixation not maintained.

//////////////////////// STIMULI CONFIGURATION ///////////////////
declare vidre = 3; //number of video refreshes to display target
declare Stimulus_Time = 200;
declare x, y, ax, ay, fixx, fixy,bxc,byc,axc,ayc; //	Coordinates for determining eye position.                 											
declare float width;						// Width of squares.
declare float width_Deg, S_width, width_y;  // MODIFIED: 09-11-2007 EEE MADE STIMULI SQUARE.
declare float fix_width_Deg, fix_width , fix_S_width, fix_width_y; 
declare float fix_width_off_Deg, fix_off_width , fix_S_off_width, fix_off_width_y; 
declare ang=0;
declare ang_2=90;
declare ang_3=45;
declare ang_4=45;
							 // Eccentricity defines visual angle between center and target.
declare Necc=1;
declare minEcc = 200;
minEcc = minEcc * 1.33; //Scaled eccentricity size to account for new smaller monitor DCG
declare stepEcc = 200;
declare  eccen=((Necc-1)*stepEcc)+minEcc;
declare int eccen_Deg = 10;
// MODIFIED: 2-23-06
// ADDED cm COMMAND TO INCREASE THE LUMINANCE OF THE MARKER
// BECAUSE IT WAS NOT BRIGHT ENOUGH TO DRIVE THE PHOTODIODE
declare color_marker = 15;
declare MLumr =63;
declare MLumg =63;
declare MLumb =63;

declare Lumr =40;
declare Lumg =40;
declare Lumb =40;

// MODIFIED: 05-24-07 EEE
//	ADDED RATIO OF HOR VS VERT SCREEN DISTORTION
//	Y = 1.23*y, WHERE y IS THE VALUE OF Y IF THE SCREEN WAS SQUARE
declare float Anisop_Y = 1.23;


declare constant waitAutoMonkey = 520;
declare tx=0;
declare nTrials;
// Number of Trials in a cycle. We choose 40 because it is the smallest
// number that is divisible w/o remainder by 4 and 10. 10 is the number
// of different stop signal times. We need also a loop because we want
// 25% 33% 50% of the trials to be stop.

// Number of Types (Stop or No Stop) in a cycle.
declare int block=0;
declare int npos = 2;
declare int tpos = 0;

declare float ratio = 1;

declare Num_Holdt[100];
	
declare Ecc[1000];			  // Number of different Stop trials in a cycle.
declare trials[1000];		  // Trial Array (which side of axis target is presented on ).	
declare types[1000];		  // Type Array (whether it's a stop or no-stop trial).
declare stop[1000];			  // Stop Array (stop-signal delay in stop trials).


declare i = 0;				  // Trial Array index (which side of axis target is presented on ).	
declare j = 0;				  // Type Array index (whether it's a stop or no-stop trial).
declare s = 0;				  // Stop Array index (stop-signal delay in stop trials).
declare TarH, TarV;			  // Target horizonatal and vert location for VideoSync.
declare col_tar = 15;		  // VideoSync variable for the color of the target.


/////////////////////////////////////// PROCESSES DECLARATION ///////////////////////////////////

declare MAIN();
declare INITIALIZE();
declare STIM();
declare DRAW_STIM();
declare ANIMATION();
declare WATCHEYE();
declare TRIAL_LOOP();
declare TRIAL();
declare START_SOUND();
declare WRONG();
declare SUCCESS();
declare CLEAR();
declare END_TRIAL();
declare REWARD();
declare REWARD_SOUND();
declare WRITE_PARAMS();
declare MARKER();
declare MARKER_2();
declare INIT_FIX_CORRECTOR();
declare INIT_FIXATION_CHECK();
declare SHUFFLE_TRIAL_ARRAY();
declare INIT_TRIAL_ARRAY(int npos);
declare SHUFFLE();
declare CLEAN_UP();
declare WRITE_PARAMS_TEMPO();
declare SOUND_ON_REWARD();
declare CAL_FIX();
declare EXTRA_REWARD();

//////////////////////////////////////// PLEXON COMUNICATION ////////////////////////////////

declare int value;   
declare int get = 0, put = 0;               		// get and put indexes into xmit[]
declare int constant nXMIT = 100;            		// Size of xmit[]
declare int xmit[nXMIT];                    		// Transmit array to Remote system
declare int constant nEventsPerProcessCycle = 10;   // Max # of events sent per process cycle
declare int eventCode;
declare int usec = 150;
declare int REMOTE_TTL=1;
declare HEX dio_a,dio_b, dio_c;

declare queueEvent(),xmitEvents();
declare SendTTLToRemoteSystem (int value);
declare Delay(int uSeconds);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process MAIN: Controls all the other processes and is the only process enabled when the protocol is started. //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

process MAIN() enabled // "enabled" makes this process start when the protocol is started. All other processes must be spawned.
{
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
    
    // MODIFIED: 10-07-2007 EEE   
    // 		EYE'S DISTANCE FROM THE SCREEN IS FACTORED INTO DETERMINING THE VISUAL ANGLE	
	if(MONKEY==1)// Fechner rm 028
	{
		Distance = 42.50; // distance in cm from screen
	}  	  
	else if (MONKEY==2)// pep rm 028 
	{
		Distance = 39.50; // distance in cm from screen
	}

    print("---------------------------------------------");
	print("---------------------------------------------");
	print("########### MEMORY GUIDED PROTOCOL ##########");
	print("---------------------------------------------");
	print("################ CREATED 12/2004 #############");
	print("---------------------------------------------");
	print("---------------------------------------------");

	dioSetMode(0, PORTA|PORTB|PORTC);	

      
    spawn CLEAR;
	waitforprocess CLEAR;  
    
    spawn INITIALIZE;			 							 	 // Initialize animation and VideoSync objects.
	waitforprocess INITIALIZE;

	spawn SHUFFLE;												 // Shuffle all the trial types.
	waitforprocess SHUFFLE;

   	spawn WATCHEYE;			 								 	 // Monitor the eye coordinates.

   	spawn TRIAL_LOOP;			 								 // Start the trials.
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Process INITIALIZE                                                                           //
// This process intializes the animation and VideoSync objects and zeroes out the data from the //
// previous trial.  It is spawned by process MAIN.												//
//////////////////////////////////////////////////////////////////////////////////////////////////

process CAL_FIX()
{
eFix_H = atable(1);             					 	 // Get actual horizontal analog values.
eFix_V= -atable(2);
H_OFFSET=-eFix_H;

V_OFFSET=-eFix_V;	

}


process INITIALIZE()
{
   
      
   
	nASETS= mspercycle();//=4; // GetSystemInfo(GSI_ASETS);
        
    // These are the animation graphs and objects.
    oSetGraph(gRight, aRANGE, -XMAX/2, XMAX/2, -YMAX/2, YMAX/2); // Object graph virt. coord - Right Graph
    oF = oCreate(tBOX, gRight, Fix_H, Fix_V);    			 // Create FIXATION object
    oSetAttribute(oF, aVISIBLE);  //aIN            				 // Not visible yet
    
    oE = oCreate(txCross, gRight, 20, 20);       				 // Create EYE object
    oSetAttribute(oE, aVISIBLE);                				 // It's always visible

    oSetGraph(gLeft, aRANGE, -XMAX/2, XMAX/2, -YMAX/2, YMAX/2);  // Object graph virt. coord - Left Graph
	oE1 = oCreate(txCross, gLeft, 20, 20);     					 // Create EYE object
	oSetAttribute(oE1, aVISIBLE);             					 // Visible only during a trial
    oSetAttribute(oE1, aREPLACE);               				 // Draw trace on left graph
	
 	dsend("dm fix_init($1, $2, $3)");  	
 	dsend("rf $1-5, $2-5, $1+5, $2+5");
	dsendf("co $3;");			  
	dsend("em");
	
	nexttick;													 // Wait one process cycle.

	dsend("vc -640, 640, -512, 512"); 							 // Set virtual coordinates.
	dsend("mv 0,0");		  									 // Move mouse to VC (0,0)
    
    TrialCount = 0;                             				 // Zero out statistics
    SuccessCount = 0;
   
 
 nTrials=npos*nEcc*10000;
 eccen=(Necc*stepEcc)+minEcc;

		
if(FIXED_JITTER==1)
  {
 EXPO_JITTER=0;
  }

if(EXPO_JITTER==1)
  {
 FIXED_JITTER=0;
  }



}




///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process WATCHEYE																					     //
// This process continuously monitors the eye position and registers whether the position is within the	 //
// fixation window.  It does not monitor how *long* the eye is at a certain location, only where it is.	 //
// This process is spawned by process MAIN. 															 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////

process WATCHEYE()
{
    declare hide oldx, oldy;            						 // Last eye position.
	


    while (1)                           						 // Loop indefinitely.
    {
	  		
     /////////////////////////////////////////////////////////   
          if (AUTOMONKEY)
            {                           // Fabricate "fake" position automatically
                                        // in analog values
            bxc = TarH + 100;         // Target center in video coord
            byc = TarV + 100;
            axc = bxc;//(bxc * 4096)/XMAX - 2048; // Target center in analog coord
            ayc = byc;//(byc * 4096)/YMAX - 2048; // Target center in analog coord
            
            ax = ax + (axc - ax) / 50; // Go part way to target from previous loc
            ay = ay + (ayc - ay) / 50; // Go part way to target from previous loc
            
            ax = ax + 25 - random(50);
            ay = ay + 25 - random(50);
            }
        else if (DEBUG)                 // Which kind of input should we use?
            {
            ax = mouGetX();             // Get manual "fake" position from Mouse
            ay = mouGetY();
		
			x = (XMAX * (ax*XGAIN + 2048)) / 4096;// Map to video coordinates
            y = (YMAX * (ay*YGAIN + 2048)) / 4096;
			 			 
		      }
		else if(DEBUG==0 && AUTOMONKEY==0)
		  {

      /////////////////////////////////////////////////////////////   
        
        ax = atable(1);             					 	 // Get actual horizontal analog values.
        ay = -atable(2);			 					 	 // Get actual vertical analog values.
    	x = (ax+H_OFFSET)*(XGAIN)/(XMAX);								 	 // Map to video coordinates
    	y = (ay+V_OFFSET)*(YGAIN)/(YMAX);
		 }
		   //axc = (bxc * 4096)/XMAX - 2048;
    	if (x != oldx || y != oldy)     				   	 	 // If position has changed..
        {
            oMove(oE, x, y);            					 	 // ..Update eye object
            oMove(oE1, x, y);           					 	 // ..Update eye object: right animated graph
          if(DEBUG==1 || AUTOMONKEY==1)
	       {
            dsendf("om 1,%d,%d\n", x, y); 					 	 // ..Move sprite
		    dsend("os 1");                       // Show "eye" sprite
	       }
                oldx = x;                   					 	 // This is the new position.
            oldy = y;
        }
	   
		if ((abs(x) <= Fix_H/2) && (abs(y) <= Fix_V/2))		 // Check to see if eye position is inside the fixation window.
		{
			In_Fixation_Window = 1;									 
			Saccadic_time=time();
													 
		   In_Target = 1;
		 
		}
		else
		{
			In_Fixation_Window = 0;

			
                     if(trial_start==1 && step_wind==0)
					 {
                     spawn SendTTLToRemoteSystem(2810); /// Saccade The gaze goes out of the fixation window					   

					 event_set(1,0,2810);									 // Event Code for Tempo data base.
                     nexttick;
		 			 //trial_start=0;  MWL 1/23/06 removed because not in countermanding
					 //protol and prevented event 2811 from being send, directly below
		 			 step_wind=1;
					 }
		 
		 }
		if (x >= TarH - (Targ_H/2) && x <= TarH + (Targ_H/2) && y >= TarV - (Targ_V/2) && y <= TarV + (Targ_V/2)) // See if eye position is inside target.
    	 {
                     //gets to here when he enters target window
                       if(trial_start==1 && step_targ==0)
					   {
					   spawn SendTTLToRemoteSystem(2811); /// The gaze goes to the target window					   
       
                        event_set(1,0,2811);									 // Event Code for Tempo data base.
                        nexttick;
          				//trial_start=0;  MWL 1/23/06 removed because not in countermanding protocol
					    step_targ=1;
						}

          In_Target = 1;       
          
           if(failed==0 && step_lat==0)
			  {	
			    dsend("VW");
				dsend("WM 1"); 
					spawn MARKER_2;
				dsendf("co col_tar;");
				dsend("xm target(TarH, TarV, col_tar)");
					dsend("co 15;");			  // set color to white, prepare to turn on after VW
				dsend("xm targmarker(-615,484,0)");
				dsend("VW");
				dsendf("co 0;");
				// dsend("xm targmarker(-615,484,0)");
				print("target back on");          
	           
               sac_latency= time() - end_fix_presentationT;
          	   printf("Latency=%dms\n",sac_latency);
          	   step_lat=1;
          	   Saccade_time=time()-Saccadic_time;
          	   printf("saccade time=%dms\n",Saccade_time);
          	   if(Saccade_time>Sacc_time) 
          	   {
          	   failed = ERR_TIME_SAC;
	           print("Wrong Saccade Duration....");
		        spawn WRONG;
	        	waitforprocess WRONG;

          	   	}
          	   
          	   
          	   
          	   
          	   }
		             
          /*event_set(1,0,EV_DECIDE);									 // Tell the event channel that fixation is on.
	      nexttick;
			*/
          
          }
		 		
		else
			In_Target = 0;
		
		nexttick;					 // We wait one process cycle because we want to monitor the eye position every process cycle.
       	}
   
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process STIM																								   //	
// This process sends macro definitions to VideoSync every trial.  It is really only needed if there are       //
// different types of trials.  Since there is only the fixation trial in this experiment, it is not necessary, //
// but it is placed here in case other types of trials are included later.  It is spawned by process MAIN and  //
// by process TRIAL.     																					   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

process STIM()
{
	fix_width_Deg = 0.3;
	fix_S_width = Distance * sin(fix_width_Deg)/ cos(fix_width_Deg);
	fix_width = fix_S_width / 0.0362;
	fix_width_y = fix_width*Anisop_Y;
	dsend("sv fix_width= ", fix_width);
	dsend("sv fix_width_y = ", fix_width); 
	dsend("dm fix($1, $2, $3)");				// Fixation filled rectangle.
	dsend("rf $1-fix_width/2, $2-fix_width_y/2, $1 + fix_width/2, $2+fix_width_y/2");			// This is the rectangle the monkey must
	dsendf("co $3;");							// fixate for a specified amount of time.
	dsend("em");
	
	
	fix_width_off_Deg = 0.2;
	fix_S_off_width = Distance * sin(fix_width_off_Deg)/ cos(fix_width_off_Deg);
	fix_off_width = fix_S_off_width / 0.0362;
	fix_off_width_y = fix_off_width*Anisop_Y;
	dsend("sv fix_off_width= ", fix_off_width);
	dsend("sv fix_off_width_y = ", fix_off_width); 
	dsend("dm fix_off($1, $2, $3)");				// Fixation filled rectangle.
	dsend("rf $1-fix_off_width/2, $2-fix_off_width_y/2, $1 + fix_off_width/2, $2+fix_off_width_y/2");			// This is the unfilled rectangle which instructs 
	dsendf("co $3;");							// the monkey that it is OK to saccade to the target.
	dsend("em");
	
	//dsend("dm fix($1, $2, $3)");								 // Fixation filled rectangle.
	//dsend("rf $1-5, $2-5, $1+5, $2+5");							 // This is the rectangle the monkey must
	//dsendf("co $3;");											 // fixate for a specified amount of time.
	//dsend("em");
	
	/////////////////////////////////////////////////////////////////////////////////////    
    dsend("sv width= ", width);		// Define width (squares' width & length) for vdosync  	
	dsend("sv width_y =",width_y); // MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
  	dsend("dm target($1, $2, $3)");	// Target square.
	dsend("rf $1-width/2, $2 - width_y/2, $1+width/2, $2 + width_y/2");// MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
	dsendf("co $3;");	  
	dsend("em");

    //dsend("sv width= ", width);									 // Define width (squares' width & length) for vdosync
  	
  	//dsend("dm target($1, $2, $3)");								 // Target square.
	//dsend("rf $1-width/2, $2-width/2, $1+width/2, $2+width/2");
	//dsendf("co $3;");	  
	//dsend("em");

    dsend("dm targmarker($1, $2, $3)");  		// One square for photodiode (MARKER process).
	//dsend("rf $1-50, $2-50, $1+50, $2+50");
	dsendf("cm %d,%d,%d,%d;",14,MLumr,Mlumg,Mlumb);
	dsendf("co 14;");
	dsend("rf $1-9, $2-9, $1+9, $2+9");
	//dsendf("co 15;");
	dsend("VW");
	dsendf("cm %d,%d,%d,%d;",14,0,0,0);
	//dsendf("co $3;");	  
	dsend("em");

		
		
   ////////////////////////////// Select the eccentricty

	   		 			//eccen = Ecc[i]; //minEcc + stepEcc;
			
						 eccen = Ecc[trials[i]-1];


//MWL 9/19/06  CASE 1 STIMULUS
///////////////////////////////////////////////////////////////////////////////
		   //////////////////////////// CASE 1 STIMULUS  Right or left 0 or 180deg ////////////////////////////////
if (npos==1)
{
	if (trials[i] == 1 || trials[i] == 3 || trials[i] == 5)			// Specifies on which side of the axis the target will appear.
{
TarH = cos(ang+tpos)*eccen;
TarV = -sin(ang+tpos)*eccen* Anisop_Y;
}
else if (trials[i] == 2 || trials[i] == 4 || trials[i] == 6)
{
TarH = cos(ang+tpos - 180)*eccen;
TarV = -sin(ang+tpos - 180)*eccen* Anisop_Y;
} 			    
} //end npos==1 
		
		
///////////////////////////////////////////////////////////////////////////////
//////////////////////////// CASE 2 STIMULI  Right or left 0 or 180deg ////////////////////////////////
if (npos==2)
{
if (trials[i] == 1 || trials[i] == 3 || trials[i] == 5)			// Specifies on which side of the axis the target will appear.
{
TarH = cos(ang+tpos)*eccen;
TarV = -sin(ang+tpos)*eccen* Anisop_Y;
}
else if (trials[i] == 2 || trials[i] == 4 || trials[i] == 6)
{
TarH = cos(ang+tpos - 180)*eccen;
TarV = -sin(ang+tpos - 180)*eccen* Anisop_Y;
} 			    
} //end npos==2 

 
 
                             //////////////////////////////////////////////////////////////////////////////
		   //////////////////////////// CASE 4 STIMULI   Cross 0 90 180 270 ////////////////////////////////
if (npos==4)
{
if (trials[i] == 1 || trials[i] == 5 || trials[i] == 9)										     // Specifies on which side of the axis the target will appear.
{
TarH = cos(ang+tpos)*eccen;
TarV = -sin(ang+tpos)*eccen* Anisop_Y;
}
else if (trials[i] == 2 || trials[i] == 6 || trials[i] == 10)
{
TarH = cos(ang+tpos+ang_2)*eccen;
TarV = -sin(ang+tpos+ang_2)*eccen* Anisop_Y;  
}
else if (trials[i] == 3 || trials[i] == 7 || trials[i] == 11)
{
TarH = cos((ang+tpos) - 180)*eccen;   //// oposite to 1
TarV = -sin((ang+tpos) - 180)*eccen* Anisop_Y;
}
else if (trials[i] == 4 || trials[i] == 8 || trials[i] == 12)
{
TarH = cos((ang+tpos+ang_2) - 180)*eccen;	  //// oposite to 2 
TarV = -sin((ang+tpos+ang_2) - 180)*eccen* Anisop_Y;
}
} // end of 4 stimuli


                           //////////////////////////////////////////////////////////////////////////////
		   //////////////////////////// CASE 6 STIMULI   Cross 0 90 180 270 ////////////////////////////////
if (npos==6)
{
if (trials[i] == 1 || trials[i] == 7 || trials[i] == 13)										     // Specifies on which side of the axis the target will appear.
{
TarH = cos(ang+tpos)*eccen;
TarV = -sin(ang+tpos)*eccen* Anisop_Y;
}
else if (trials[i] == 2 || trials[i] == 8 || trials[i] == 14)
{
TarH = cos(ang+tpos+ang_2)*eccen;
TarV = -sin(ang+tpos+ang_2)*eccen* Anisop_Y;  
}
else if (trials[i] == 3 || trials[i] == 9 || trials[i] == 15)
{
TarH = cos(ang+tpos+ang_2+ang_3)*eccen;
TarV = -sin(ang+tpos+ang_2+ang_3)*eccen* Anisop_Y;  
}

else if (trials[i] == 4 || trials[i] == 10 || trials[i] == 16)
{
TarH = cos(ang+tpos - 180)*eccen;   //// oposite to 1
TarV = -sin(ang+tpos - 180)*eccen* Anisop_Y;
}
else if (trials[i] == 5 || trials[i] == 11 || trials[i] == 17)
{
TarH = cos(ang+tpos+ang_2 - 180)*eccen;	  //// oposite to 2 
TarV = -sin(ang+tpos+ang_2 - 180)*eccen* Anisop_Y;
}
else if (trials[i] == 6 || trials[i] == 12 || trials[i] == 16)
{
TarH = cos(ang+tpos+ang_2+ang_3 - 180)*eccen;	  //// oposite to 3 
TarV = -sin(ang+tpos+ang_2+ang_3 - 180)*eccen* Anisop_Y;
}

} // end of 6 stimuli

                        //////////////////////////////////////////////////////////////////////////////
		   //////////////////////////// CASE 8 STIMULI   Cross 0 90 180 270 360 ////////////////////////////////
if (npos==8)
{
if (trials[i] == 1 || trials[i] == 9 || trials[i] == 17)										     // Specifies on which side of the axis the target will appear.
{
TarH = cos(ang+tpos)*eccen;
TarV = -sin(ang+tpos)*eccen* Anisop_Y;
}
else if (trials[i] == 2 || trials[i] == 10 || trials[i] == 18)
{
TarH = cos(ang+tpos+ang_2)*eccen;
TarV = -sin(ang+tpos+ang_2)*eccen* Anisop_Y;  
}
else if (trials[i] == 3 || trials[i] == 11 || trials[i] == 19)
{
TarH = cos(ang+tpos+ang_2+ang_3)*eccen;
TarV = -sin(ang+tpos+ang_2+ang_3)*eccen* Anisop_Y;  
}
else if (trials[i] == 4 || trials[i] == 12 || trials[i] == 20)
{
TarH = cos(ang+tpos+ang_2+ang_3+ang_4)*eccen;
TarV = -sin(ang+tpos+ang_2+ang_3+ang_4)*eccen* Anisop_Y;  
}
 
else if (trials[i] == 5 || trials[i] == 13 || trials[i] == 21)
{
TarH = cos(ang+tpos - 180)*eccen;   //// oposite to 1
TarV = -sin(ang+tpos - 180)*eccen* Anisop_Y;
}
else if (trials[i] == 6 || trials[i] == 14 || trials[i] == 22)
{
TarH = cos(ang+tpos+ang_2 - 180)*eccen;	  //// oposite to 2 
TarV = -sin(ang+tpos+ang_2 - 180)*eccen* Anisop_Y;
}
else if (trials[i] == 7 || trials[i] == 15 || trials[i] == 23)
{
TarH = cos(ang+tpos+ang_2+ang_3 - 180)*eccen;	  //// oposite to 3 
TarV = -sin(ang+tpos+ang_2+ang_3 - 180)*eccen* Anisop_Y;
}
else if (trials[i] == 8 || trials[i] == 16 || trials[i] == 24)
{
TarH = cos(ang+tpos+ang_2+ang_3+ang_4 - 180)*eccen;	  //// oposite to 4 
TarV = -sin(ang+tpos+ang_2+ang_3+ang_4 - 180)*eccen* Anisop_Y;
}


} // end of 6 stimuli

	    


	dsend("sv TarH= ", TarH);									 // Assign var 'TarH' into vdosync var 'TarH'.
	dsend("sv TarV= ", TarV);

	dsend("sv col_tar= ", col_tar);			  // Assign var 'col_tar' (target_color) into vdosync var 'col_tar'.
}

/////////////////////////////////////////////////////////////////////////////////////////////
// Process DRAW_STIM 																	   //
// This process draws the fixation squares on the screen.  It is spawned by process TRIAL. //
/////////////////////////////////////////////////////////////////////////////////////////////

process DRAW_STIM()
{																 
	int x_1;
	int x_2;
	int x_3;
	int x_4;
	int rand_t1;
	int rand_t2;
	int rand_t3;



	float float_frac_fix_jitter;
	float float_frac_hold_jitter;
	float float_frac_stop_jitter;
	float float_frac_targ_jitter;


	/////////////////////////////////////////////////////
	if(frac_fix_jitter==0)
	{
		fix_jitter=0;
	}
	
	if(frac_fix_jitter>0)
	{
		float_frac_fix_jitter=fix_t*(frac_fix_jitter/100.0);
		fix_jitter=random(float_frac_fix_jitter);
		rand_t1=random(100);
	 	if(rand_t1<50)
		{
			fix_jitter=-fix_jitter;
		}															/////////////////////////// FIXATION HOLD
	 }

	///////////////////////////////////////////////////////
	//if(linear
	if(EXPO_JITTER==1)
	{
		x_1=random(1000);
		expo_1=(x_1/1000.0)+((x_1/1000.0*x_1/1000.0)/(2*1))+((x_1/1000.0*x_1/1000.0*x_1/1000.0)/(3*2*1))+((x_1/1000.0*x_1/1000.0*x_1/1000.0*x_1/1000.0)/(4*3*2*1))+((x_1/1000.0*x_1/1000.0*x_1/1000.0*x_1/1000.0*x_1/1000.0)/(5*4*3*2*1));
		float_frac_fix_jitter=(frac_fix_jitter/100.0)*expo_1*2.0;
		expo_jitter_fixation=float_frac_fix_jitter;			  
		hold_fixation_time = fix_t + expo_jitter_fixation; 	
	}
	if(FIXED_JITTER==1)
	{
		hold_fixation_time = fix_t	+ fix_jitter;
	}



	//////////////////////////////////////////////////////
							
							
							//////////////////////////////////// MEMORY TIME
	//////////////////////////////////////////////////////////
	if(frac_stop_t_jitter==0)
	{
		memory_fix_t_jitter=0;
	}
	if(frac_stop_t_jitter>0)
	{

		//float_frac_fix_jitter=fix_t*(frac_fix_jitter/100.0);
		float_frac_stop_jitter=memory_fix_t*(frac_stop_t_jitter/100.0);
		memory_fix_t_jitter=random(float_frac_stop_jitter);			///////////////// HOLDTIME 	on FIXATION AFTER NOGO TRIAL
		rand_t2=random(100);

		if(rand_t2<50)
		{
		memory_fix_t_jitter=-memory_fix_t_jitter;
		}
	}
	///////////////////////////////////////////////////////////
	if(EXPO_JITTER==1)
	{
		x_3=random(1000);
		expo_3=(x_3/1000.0)+((x_3/1000.0*x_3/1000.0)/(2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0)/(3*2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0)/(4*3*2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0)/(5*4*3*2*1));
		float_frac_stop_jitter=(frac_stop_t_jitter/100.0)*expo_3*2.0;
		expo_jitter_stop=float_frac_stop_jitter;			  
		memory_fix_time= memory_fix_t + expo_jitter_stop; 
	}
	if(FIXED_JITTER==1)
	{
		memory_fix_time= memory_fix_t + memory_fix_t_jitter; 
	}

	// stimulus distance from fixation point in cm 
	S_dist = Distance * sin(eccen_Deg)/cos(eccen_Deg); 
	eccen = S_dist / 0.0362;
	eccen = eccen*1.5;
	
	/////////////////////////////////////////////////////
	// MODIFIED 05-25-07 EEE						   //
	//		TARGET SIZE NOW SCALES WITH ECCENTRICITY,  //
	//		0.3 DEG ACROSS AT 4 DEG ECCEN			   //
	//		1.0 DEG ACROSS AT 10 DEG ECCEN			   //
	//		width target = eccen*0.1617 - 14.048;	   //
	//		width_Deg = 0.1167 * eccen_Deg - 0.1667;   //
	//		width = Distance * tan(width_Deg/57.2958); //
	/////////////////////////////////////////////////////
	if (eccen_Deg >= 4)
	{		
		width_Deg = 0.1167 * eccen_Deg - 0.1667;
		S_width = Distance * sin(width_Deg)/cos(width_Deg);	// width = 0.1617*eccen-9;//14.048;   // width target = eccen*0.1617 - 14.048;
		width = S_width / 0.0362;
		width_y = width*Anisop_Y; // MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
	}
	else
	{
		width_Deg = 0.3;
	  	S_width = Distance * sin (width_Deg) / cos (width_Deg);	// width = 0.1617*eccen-9;//14.048;   // width target = eccen*0.1617 - 14.048;
		width = S_width / 0.0362; //width = 7;
		width_y = width*Anisop_Y; // MODIFIED: 09-11-2007 EEE MADE TARGETS SQUARE.
	} 


	///////////////////////////////////////////////////////////
	////////////           FIXATE ON TARGET	       ////////////
	//////////////////////////////////////////////////////////
	if(frac_targ_t_jitter==0)
	{
		targ_fix_t_jitter=0;
	}
	if(frac_targ_t_jitter>0)
	{
		//float_frac_fix_jitter=fix_t*(frac_fix_jitter/100.0);
		float_frac_targ_jitter=Hold_on_target*(frac_targ_t_jitter/100.0);
		targ_fix_t_jitter=random(float_frac_targ_jitter);			///////////////// HOLDTIME 	on FIXATION AFTER NOGO TRIAL
		rand_t3=random(100);

		if(rand_t3<50)
		{
			targ_fix_t_jitter=-targ_fix_t_jitter;
		}
	}
///////////////////////////////////////////////////////////
	if(EXPO_JITTER==1)
	{
		x_4=random(1000);

		expo_4=(x_4/1000.0)+((x_4/1000.0*x_4/1000.0)/(2*1))+((x_4/1000.0*x_4/1000.0*x_4/1000.0)/(3*2*1))+((x_4/1000.0*x_4/1000.0*x_4/1000.0*x_4/1000.0)/(4*3*2*1))+((x_4/1000.0*x_4/1000.0*x_4/1000.0*x_4/1000.0*x_4/1000.0)/(5*4*3*2*1));
		float_frac_targ_jitter=(frac_targ_t_jitter/100.0)*expo_4*2.0;
		expo_jitter_target=float_frac_targ_jitter;			  

		targ_fix_time= Hold_on_target + expo_jitter_target; 
	}
	if(FIXED_JITTER==1)
	{
		targ_fix_time= Hold_on_target + targ_fix_t_jitter; 
	}
///////////////////////////////////////////////////////////
	spawn ANIMATION;											 // Turn on animation.
 
 	//these lines disply the fixation point	
    //dsendf("co %d;",15); 
    dsendf("co 15;"); //MWL changed 15 to 10	DCG changed back to white (15)  // 15 = white.
	dsend("xm fix(0, 0, 15)");	  //MWL changed 15 to 10  DCG changed back to white (15) 									  
 
 	// Fixation Spot on time
	spawn SendTTLToRemoteSystem(2301);			      
 	event_set(1,0,2301);			   // Event Code for Tempo data base.
 	nexttick;

    wait(hold_fixation_time);		

	if (failed == 0) //but only if he didn't leave fix early
	{    	  	
  		// Target and Photodiode Marker Presentation
		spawn SendTTLToRemoteSystem(2651);
	   	dsend("VW");
	    dsend("WM 1"); 
	 	spawn MARKER;
		//these 2 lines display target
		dsendf("co col_tar;");
		dsend("xm target(TarH, TarV, col_tar)");
		//these lines display marker for photodiode in lower left of screen
		dsendf("cm %d,%d,%d,%d;",color_marker,Lumr,Lumg,Lumb);
		dsendf("co %d;",color_marker);

	 	//dsend("co 15;"); // set color to white, prepare to turn on after VW
	    dsend("xm targmarker(-615,484,0)");
		dsend("VW");
		//these lines cover the marker with black (in effect this turns off the marker)
	    dsendf("co 0;");
	    // dsend("xm targmarker(-615,484,0)");
	  	event_set(1,0,2651);									 // Event Code for Tempo data base.
	    nexttick;  	  	  	  	  	  	   	  	  	
  	}
  	IF(failed>0)
	{
	    dsend("cl");
	  	printf("         \n");
	    printf("         \n");
		printf("         \n");   
   	}
   			 
	//MWL 9/19/06
	//the number after VW represents how many vertical refreshes (16 ms each) to wait
	//this is how long the target will be displayed for
	//3 = 48 ms;  6 = 96 ms;  9 = 144 ms;  12 = 192 ms
	//as noted below, subtract one from this because 1 refresh used to erase marker
	//i.e. if you want to wait 12 refreshes, enter 11
	//vidre value before 9/19/06 was 2
	//vidre is declared and set at beginning of protocol
   	dsend("VW",vidre);		// wait 3 refreshs ~48ms marked 2 here because one refresh has already been used to erase the marker
  
 	if (failed == 0) //but only if he didn't leave fix early
	{
		// Remove target from display
		dsendf("co 0;");
		dsend("xm target(TarH, TarV, 0)");
		// Clear graph.
		// Tells the photodiode on the screen to look for light to indicate presentation of target.																	    
		// memory time..... 
	    wait(memory_fix_time);
		event_set(1,0,memory_fix_time);
		nexttick;

		// FIX SPOT OFF			
	 	dsend("VW");  	   
	 	dsendf("co 0;");
	 	dsend("xm fix_off(0, 0, 0)");
		// MODIFIED 03/06/07 EEE
		// 		PRESENT MARKER TO PHOTODIODE WHEN FIXSPOTOFF
		//these lines display marker for photodiode in lower left of screen
		dsendf("cm %d,%d,%d,%d;",color_marker,Lumr,Lumg,Lumb);
		dsendf("co %d;",color_marker);
	 	//dsend("co 15;"); // set color to white, prepare to turn on after VW
	    dsend("xm targmarker(-615,484,0)");
		dsend("VW");
		spawn SendTTLToRemoteSystem(2300);
		//these lines cover the marker with black (in effect this turns off the marker)
	    dsendf("co 0;");
	    // dsend("xm targmarker(-615,484,0)");

	  	event_set(1,0,2300);									 // Event Code for Tempo data base.
	    nexttick;  	  	  	  	  	  	   	 		
	 }
	  
	IF(failed>0)
	{
    	dsend("cl");
  		printf("         \n");
    	printf("         \n");
		printf("         \n");   
   	}
	// then remove the fixation       	   	
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process ANIMATION																					  //
// This process is used to clear and reset the objects in the left graph.  The objects in the right graph //
// always remain because the eye cross does not create a trace, and, thus, does not need clearing.		  //
// In the original ACQUIRE protocol, the targets and distractors are all erased and recreated also.		  //
// It is spawned by DRAW_STIM.																			  //
////////////////////////////////////////////////////////////////////////////////////////////////////////////

process ANIMATION()
{
	if(TrialCount>1)
	{
	oSetAttribute(oF1, aINVISIBLE);            				 	 // Make invisible.
	oSetAttribute(oB1, aINVISIBLE);             				 
    oSetAttribute(oB1x, aINVISIBLE);               				 
	
	 
	oDestroy(oF1);					 							 // Destroy objects in the previous trial.
	oDestroy(oB1);					 
    oDestroy(oB1x);
	}

	oSetGraph(gLeft, aCLEAR);									 // Clear graph.
	oSetGraph(gRight, aCLEAR);									 // Clear graph.

    oB1 = oCreate(tBOX, gLeft, Targ_H, Targ_V);  			 // Create TARGET object
	oB1x = oCreate(tCross, gLeft, 40, 40);						 // a + cross for target 

    oF1 = oCreate(tBOX, gLeft, Fix_H, Fix_V);  			     // Create fixation object
    oSetAttribute(oF1, aVISIBLE);
    oSetAttribute(oF, aVISIBLE);             					 // Make visible.

    oMove(oB1, TarH, TarV);										 // Move target box.
	oMove(oB1x, TarH, TarV);	 								 
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Process TRIAL_LOOP 																			//
// This process loops indefinitely, starting a trial each time.  It is spawned by process MAIN.	//
//////////////////////////////////////////////////////////////////////////////////////////////////

process TRIAL_LOOP()
{
 	int rand_extra_reward;

 	
 	while (1)                           						 // Loop Ntrials * NBlocks
    {
		
		 step=0;
		 TEST_VIDEO=0;
		
		while(READY_S<1)
		 {
		 wait(4);
		 nexttick;
		 }


   // Beginning of the Trial BOB  
spawn SendTTLToRemoteSystem(1666);			   
	
 trigger 1;	
						 // Trigger databases with Tag 1.
 event_set(1,0,1666);										 // Tell the event channel that a trial began.
 nexttick;




	   	if (AUTOMONKEY)
            {
           // waitAutoMonkey = 100 + random(100);
            printf("Automonkey will press bar in %d ms\n", waitAutoMonkey);
            wait waitAutoMonkey;
           system("cls");
           while (system()) nexttick;  // Wait for CLS to complete
		    x=0;
			y=0;
		    In_Fixation_Window=1;
			spawn START_SOUND;	
			TrialCount = TrialCount + 1;
			printf("Starting Trial %d\n", TrialCount);
			spawn TRIAL;										 // Spawn the current trial.
			waitforprocess TRIAL;
            }
    //    else if (DEBUG)
     //       {
       //     print("Waiting for left mouse button...");
         //   while (!(mouGetButtons() & 0x1))
           //     nexttick;               // Wait for left button down
           // }
	   		
		  else 
		  {			
		spawn INIT_FIXATION_CHECK;								 // Is eye near fixation?
	    waitforprocess INIT_FIXATION_CHECK;                 
	   		
		if (In_Fixation_Window == 1 && In_init_fixation_window == 1)
		{			   
			
		  	// FIXATE
			spawn SendTTLToRemoteSystem(2660);

			event_set(1,0,2660);									 // Event Code for Tempo data base.
            nexttick;

			print("Fixating.");


			if(SOUND_FLAG==1)
			{
				spawn START_SOUND;
			}
			
						
			TrialCount = TrialCount + 1;
			printf("Starting Trial %d\n", TrialCount);
			spawn TRIAL;										 // Spawn the current trial.
			waitforprocess TRIAL;
		}
		else
		{
			print("Monkey is not in initial fixation square.");
	 		spawn CLEAR;
		}

       }

	   rand_extra_reward=random(100);
       if(rand_extra_reward < frac_extra_reward) 
       {

        wait(inter_trial/2);
        spawn REWARD;
	    waitforprocess REWARD;
	    wait(inter_trial/2);
	    }
      	else
	    {
		 wait(inter_trial);   										 // Intertrial time.
	    }
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process TRIAL																						   //
// This process starts the actual trial.  It draws the stimuli and records whether the trial was a success //
// or a failure.  It is spawned by process TRIAL_LOOP.													   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

process TRIAL()
{
 
    
    spawn STIM;
	waitforprocess STIM;
	spawn DRAW_STIM;

 	failed = ERR_OK;                    						 // Assume success - ERR_OK = 0.

   	start_time = time();                					 	 // Note current time.  
	end_fix_presentationT = start_time + hold_fixation_time;		 // Amount of time that fixation square is presented.
	
	while (time() < end_fix_presentationT && In_Fixation_Window) // Start counting time to fixate and make sure
		nexttick;										 	     // monkey stays in window for amount of time			
															     // that the fixation point is on the screen.
	if(!In_Fixation_Window && time() < end_fix_presentationT)
	{
		failed = ERR_LEAVE_FIX;
		print("Failure: did not fixate long enough!");
		printf("Accuracy: %d, %d, %6.3d %%\n", SuccessCount, TrialCount, (SuccessCount/TrialCount)*100); 
		correctmarker = 0;
	   	signal_respond_marker=1;
	   	failed=1;	  /// Faillure the monkey does not fixate long enough
		spawn SendTTLToRemoteSystem(2750);			   
	   	event_set(1,0,2750);									 // Event Code for Tempo data base.
       	nexttick;

		spawn WRONG;
		waitforprocess WRONG;
	}
	 	
	// Stage 2: Did the monkey fixate the target?
	if(!failed)
	{

	     trial_start=1;
         step_wind=0;
         step_targ=0;
 	 	 step_lat=0;
	 															 
		if(In_Fixation_Window)		  
		{
          				
			hold_time_memory = time() + memory_fix_time;
        	
			while(time() < hold_time_memory && In_Fixation_Window) // And make sure that they fixate for that amount of time.
				nexttick;

			if(!In_Fixation_Window && time() < hold_time_memory)	 // If they didn't fixate for that long, stop trial.
			{
					failed = ERR_NOFIX_STOPTRIAL;
					print("Made a saccade too fast\n");
					printf("Accuracy: %d, %d, %6.3d %%\n", SuccessCount, TrialCount, (SuccessCount/TrialCount)*100); 
					correctmarker=0;

					signal_respond_marker = 1;
					spawn WRONG;
					waitforprocess WRONG;
			}
				
	   
			React_time_max=time()+ fix_targ_maxT;		   
		 	     
    while(time() < React_time_max && In_Fixation_Window) // And make sure that they fixate for that amount of time.
				nexttick;
					 
	if(In_Fixation_Window)	 // If they didn't fixate for that long, stop trial.
	{
			print("the monkey doesn't make a saccade to the target\n");
			correctmarker=0;
			failed = ERR_NOFIX_STOPTRIAL;

			signal_respond_marker = 1;
			spawn WRONG;
			waitforprocess WRONG;
	}
     
    
	
 
 	if(!In_Fixation_Window)
 	{
 		Saccade_time=time()+ Sacc_time;		   	     
    	while(!In_Fixation_Window && time() < Saccade_time) // And make sure that they fixate for that amount of time.
				nexttick;
	
 		if(!In_Target)
	    {
	           print("Saccade but not to the target\n");
		       failed = ERR_NOFIX_STOPTRIAL;

				signal_respond_marker = 1;
				spawn WRONG;
				waitforprocess WRONG;
	       }

	   }
	
	 if(In_Target)
	  {
	  Hold_targ=time() + targ_fix_time;
	  while(In_Target && time()< Hold_targ)
	  nexttick;
	  if(!In_Target)
	   {
	   print("Unable to hold on target\n");
		failed = ERR_NOFIX_STOPTRIAL;

				signal_respond_marker = 1;
				spawn WRONG;
				waitforprocess WRONG;
	       }

	   }


	  }
    }
    
    if (!failed)                        						 // Was the trial successful?
    {
	  
	  	dsend("cl");//clears display at end of trial
        
		print("A successful trial.");
		printf("Accuracy: %d, %d, %6.3d %%\n", SuccessCount, TrialCount, (SuccessCount/TrialCount)*100); 
 		spawn SUCCESS;
		waitforprocess SUCCESS;
       
	    
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
// Process START_SOUND																	 //
// This process creates a sound in the testing room indicating the beginning of a trial. //
// It is spawned by process TRIAL_LOOP.													 //
///////////////////////////////////////////////////////////////////////////////////////////

process START_SOUND()
{
   		sound(300);
		wait 200;
		sound(0);
	      
    
    
   // mio_fout(6000);												 // Speakers in testing room.
	//sound(300);
   //	wait 200;                									 // Wait a period of time (ms).
  //	mio_fout(0);
   //	sound(0);
}

///////////////////////////////////////////////////////////////////////////
// Process WRONG														 //
// This process is spawned by process TRIAL when the trial is a failure. //
///////////////////////////////////////////////////////////////////////////

process WRONG()
{

// ERROR in the current trial  

spawn SendTTLToRemoteSystem(2620);			   	  // WRONG 


 event_set(1,0,2620);									 // Event Code for Tempo data base.
 nexttick;

 
//if (staircase==1 && types[j] == 2)
//    {
/// Stair Case procedure
//  stop[s+1] = stop[s]-SSD_Step;
//  spawn CLEAR;
//  spawn END_TRIAL;/////
//   }
   

if (signal_respond_marker == 1)
		
	{	
	spawn CLEAR;
	wait(signal_respond_punishT);
	spawn END_TRIAL;
	waitforprocess END_TRIAL;
	//harvest 2;   need to be clarified
	}
else
{
spawn CLEAR;
//waitforprocess CLEAR;
spawn END_TRIAL;
waitforprocess END_TRIAL;

/////
}


}

///////////////////////////////////////////////////////////////////////////
// Process SUCCESS														 //
// This process is spawned by process TRIAL when the trial is a success. //
///////////////////////////////////////////////////////////////////////////

process SUCCESS()
{

int rand_reward;

 if(TEST_VIDEO==0)
	{
	print("########## ERROR DISPLAY NOT PRESENTED ###########");
	print("########## ERROR DISPLAY NOT PRESENTED ###########");
	print("########## ERROR DISPLAY NOT PRESENTED ###########");
	print("########## ERROR DISPLAY NOT PRESENTED ###########");
	print("########## ERROR DISPLAY NOT PRESENTED ###########");
	print("########## ERROR DISPLAY NOT PRESENTED ###########");
    spawn CLEAN_UP;
    }
	  
  

spawn SendTTLToRemoteSystem(2600);	   //// CORRECT_TRIAL

 
 event_set(1,0,2600);									 // Event Code for Tempo data base.
 nexttick;



  rand_reward=random(100);
if(rand_reward <= REWARD_RATIO) 
 {

 if(SOUND_REWARD==0)   
   {
   
  	if(Bell==1)
	{
	spawn SOUND_ON_REWARD;
	//waitforprocess SOUND_ON_REWARD;
	}
  	
  	if(random(100) >= frac_no_reward) 
    {
    wait(PAUSE_REWARD);
    spawn REWARD;
	//waitforprocess REWARD;
	}

  	
  	spawn END_TRIAL;
	waitforprocess END_TRIAL;
   	
   }

  if (SOUND_REWARD==1)
  	{ 
  	spawn REWARD_SOUND;	                                                                                                                                                  
   	waitforprocess REWARD_SOUND;
   	spawn END_TRIAL;
	waitforprocess END_TRIAL;
  	}
  }

if(rand_reward > REWARD_RATIO) 
 {
	spawn END_TRIAL;
	waitforprocess END_TRIAL;
 }

}


////////////////////////////////////////////////////////////////////////////////
// Process CLEAR															  //
// This process clears the screen and registers how long it took to clear it. //
// It is spawned by processes WRONG and SUCCESS.							  //
////////////////////////////////////////////////////////////////////////////////

process CLEAR()														 
{
	declare time1, time2;

	time1 = time();
  	dsend("cl");
  	time2 = time()-time1;
	printf("         \n");
	printf("         \n");
	printf("         \n");
	//printf("Screen Clear Time = %d\n", time1);
}


///////////////////////////////////////////////////////////////
// Process REWARD											  //
// This process gives juice and a reward sound to the monkey. //
// It is spawned by process SUCCESS.						  //
////////////////////////////////////////////////////////////////

process REWARD()
{
   	// Correct_ the monkey received Juice reward
	spawn SendTTLToRemoteSystem(2727);			   
  	//7 Size of the reward    
	spawn SendTTLToRemoteSystem(REWARD_SIZE);			   
  	// Turn on TTL to juice solenoid 
   	event_set(1,0,2727);									 // Event Code for Tempo data base.
   	nexttick;
   	event_set(1,0,REWARD_SIZE);									 // Event Code for Tempo data base.
   	nexttick;
	// Turn off TTL to juice solenoid 
   	// MODIFIED 1-30-2007 EEE
	// 		CHANGED THE REWARD CHANNEL TO 9 , PREVIOUSLY WAS 0
	//		OLD: mio_dig_set(0,1); 
  	mio_dig_set(9,1); 
   	wait(REWARD_SIZE);
 	// MODIFIED 1-30-2007 EEE
	// 		CHANGED THE REWARD CHANNEL TO 9 , PREVIOUSLY WAS 0
	//		OLD : mio_dig_set(0,0);
  	mio_dig_set(9,0);
	// Turn off TTL to juice solenoid                                	
	nexttick;    		 
}

///////////////////////////////////////////////////////////////////////////////////////////
//   Process EXTRA_REWARD																 //
// ///////////////////////////////////////////////////////////////////////////////////////////


process EXTRA_REWARD()
{
     
spawn SendTTLToRemoteSystem(2777);			   
    //7 Size of the reward    
spawn SendTTLToRemoteSystem(REWARD_SIZE);			   

  									   // Turn on TTL to juice solenoid 

    event_set(1,0,2777);									 // Event Code for Tempo data base.
    nexttick;
	event_set(1,0,REWARD_SIZE);									 // Event Code for Tempo data base.
    nexttick;
 
	
    	     
 //    sound(800);
  			 // Turn off TTL to juice solenoid 
   	     
// MODIFIED 1-30-2007 EEE
// 		CHANGED THE REWARD CHANNEL TO 9 , PREVIOUSLY WAS 0
//		OLD
//  	mio_dig_set(0,1);	
   mio_dig_set(9,1);
 

  wait(REWARD_SIZE);
// MODIFIED 1-30-2007 EEE
// 		CHANGED THE REWARD CHANNEL TO 9 , PREVIOUSLY WAS 0
//		OLD
//  	mio_dig_set(0,0);	 	   
  mio_dig_set(9,0);
                     						 // Turn off TTL to juice solenoid 
                                   	
 //  sound(0);                       	
   nexttick;  

 

}




///////////////////////////////////////////////////////////////////////////////////////////
//   Process SOUND_ON REWARD																 //
// ///////////////////////////////////////////////////////////////////////////////////////////

process SOUND_ON_REWARD()
{
     		 	    
   	 //	sound(800);
	//	wait 200;
	//	sound(0);
	    
      mio_fout(6000);												 // Speakers in testing room.
      
    	wait(160);                									 // Wait a period of time (ms).
   	mio_fout(0);
}




////////////////////////////////////////////////////////////////////////////////
// Process END_TRIAL														  //
// This process registers the end of a trial. 								  //
// It is spawned by processes WRONG and SUCCESS.							  //
////////////////////////////////////////////////////////////////////////////////		 	
process END_TRIAL()
{
 

 
 
 // END of the Trial EOB  
spawn SendTTLToRemoteSystem(1667);			   


spawn WRITE_PARAMS;
waitforprocess WRITE_PARAMS;

event_set(1,0,1667);										 // Tell the event channel that a trial began.
nexttick;



						 // Trigger databases with Tag 1.
	printf("Starting Trial %d\n", TrialCount);
  
i = i + 1;
if (i>nTrials-1)   
{ 
i=0;
Block=Block+1;
//printf(" block = %d\n", Block);
spawn SHUFFLE;												 // Shuffle all the trial types.
waitforprocess SHUFFLE;
nexttick;
signal_respond_marker = 0;
    printf("         \n");
	printf("         \n");
	printf("         \n");
	printf("         \n");


}
 
}




///////////////////////////////////////////////////////////////////////////////////////////
// Process REWARD_SOUND																	 //
// This process creates a sound in the testing room indicating a successful trial. 		 //
// It is spawned by process REWARD.													     //
///////////////////////////////////////////////////////////////////////////////////////////

process REWARD_SOUND()
{
    mio_fout(52000);											 // Speakers in testing room.
    wait 200;                									 // Wait a period of time (ms).
	mio_fout(0);
}

//////////////////////////////////////////////////////////////////////////////////
// Process SEND_PARAMS FOR PLEXON															//
// This process writes the parameters of a certain trial to the event channels.	//
// It is spawned by process END_TRIAL.											//
//////////////////////////////////////////////////////////////////////////////////

 

process WRITE_PARAMS()

///// SEND EVENTS TO PLEXON  


{

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																													 //
//																													 //
//											            INFOS														 //
//																													 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
spawn SendTTLToRemoteSystem(1502);
			  nexttick;
// 20 Columns...... and number of line = number of trials

 //1 NPOS Number of stimulus position 

spawn SendTTLToRemoteSystem(2721);			   

spawn SendTTLToRemoteSystem(npos);			   

				 nexttick;

 //2 Current POS of stimulus 

spawn SendTTLToRemoteSystem(2722);			   
	
spawn SendTTLToRemoteSystem(trials[i]);	
nexttick;		   
//// we could put here more information about the stimulus location

//3 Flag wether use an acoustic stop signal (0 or 1) 0 by default 

spawn SendTTLToRemoteSystem(2723);			   
spawn SendTTLToRemoteSystem(SOUND_S);			   
		   nexttick;
//4 Empty

//5 Empty


//6 Flag wether trigger is changed of color or not (0 = no by default) 

spawn SendTTLToRemoteSystem(2726);			   
	
spawn SendTTLToRemoteSystem(npos);			   

			nexttick;

//8 Fraction of rewarded trial 

spawn SendTTLToRemoteSystem(2728);			   
	
spawn SendTTLToRemoteSystem(REWARD_RATIO);			   

			nexttick;
//9  Empty


//10 Empty 


//11 Empty 

 //12 Empty 

 //13 Flad wether retangular (0) or exponential (1) hold distribution  

spawn SendTTLToRemoteSystem(2733);			   
spawn SendTTLToRemoteSystem(EXPO_JITTER);			   
		   nexttick;

 //14 Delay between TARGET ON and FIXATION OFF (=0 by default) 

spawn SendTTLToRemoteSystem(2734);			   
spawn SendTTLToRemoteSystem(memory_fix_time);			   

		   nexttick;

 //15 Hold time Jitter % of the total holdtime  

spawn SendTTLToRemoteSystem(2735);			   

spawn SendTTLToRemoteSystem(frac_stop_t_jitter);			   

			nexttick;
 // 16 Length of target presentation MWL
spawn SendTTLToRemoteSystem(2736);			   
	
spawn SendTTLToRemoteSystem(Stimulus_Time);			   
		   nexttick;

 //17 empty 

 //18 Empty 

 //19 Empty 

 //20 Empty
 //######################
 //###################### 
 //######################
 //21 FixWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)
//MWL 1/23/06 
// copied fix and target window info from countermanding protocol
// old way of sending this info is commented out below
spawn SendTTLToRemoteSystem(2770);			   
	   nexttick;

 //////////////// Lower left corner H coordinates
	 //// 3000 added just to be different than potential events
Volt_Fix_H_1 = 3000 + abs(((-Fix_H/2)* XMAX / XGAIN) - H_OFFSET);

			  nexttick;
spawn SendTTLToRemoteSystem(Volt_Fix_H_1);			   

 if ( ((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
spawn SendTTLToRemoteSystem(2);	
nexttick;		   
 Sign_Volt_Fix_H_1=1;
 }
 if (((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)<0)
 {
spawn SendTTLToRemoteSystem(0);			   
 Sign_Volt_Fix_H_1=-1;
 }

//////////////// Lower left corner V coordinates
 
Volt_Fix_V_1 = 3000 + abs((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET);
				nexttick;
 
spawn SendTTLToRemoteSystem(Volt_Fix_V_1);		  

 if (((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)>=0)
 {																						
spawn SendTTLToRemoteSystem(2);	
nexttick;		   
 Sign_Volt_Fix_V_1=1;
 }
 if (((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)<0)
 {
spawn SendTTLToRemoteSystem(0);			   
 Sign_Volt_Fix_V_1=-1;
 }
			  nexttick;
 //////////////// Upper right corner H coordinates
 
Volt_Fix_H_2 = 3000 + abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET);

spawn SendTTLToRemoteSystem(Volt_Fix_H_2);	   
 if ( ((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
spawn SendTTLToRemoteSystem(2);	
nexttick;		   
 Sign_Volt_Fix_H_2=1;
 }
 if ( ((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)<0)
 {
spawn SendTTLToRemoteSystem(0);			   
 Sign_Volt_Fix_H_2=-1;
 }

	nexttick;
//////////////// Upper right corner V coordinates
 Volt_Fix_V_2 = 3000 + abs((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET);
 Volt_Fix_H_2 = 3000 + abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET);
 
spawn SendTTLToRemoteSystem(Volt_Fix_V_2);		   

 
 if ( ((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)>=0)
 {
spawn SendTTLToRemoteSystem(2);	
nexttick;		   
 Sign_Volt_Fix_V_2=1;
 }
 if ( ((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)<0)
 {
spawn SendTTLToRemoteSystem(0);			   

 Sign_Volt_Fix_V_2=-1;
 }


		 nexttick;
 //22 TARGWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)

spawn SendTTLToRemoteSystem(2771);			   

  printf("trial[i]: %d\n", trials[i]);
  printf("TargH: %d\n", TarH);

//////////////// Lower left corner H coordinates
 Volt_Targ_H_1 = 3000 + abs(((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET);
 		 nexttick;
spawn SendTTLToRemoteSystem(Volt_Targ_H_1);	  
 if ((((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
spawn SendTTLToRemoteSystem(2);			   

 }
 if ((((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)<0)
 {
spawn SendTTLToRemoteSystem(0);			   

 }
		nexttick;


//////////////// Lower left corner V coordinates
 Volt_Targ_V_1 = 3000 + abs(((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET);
 
spawn SendTTLToRemoteSystem(Volt_Targ_V_1);	 	   
		nexttick;
 if ((((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)>=0)
 {
spawn SendTTLToRemoteSystem(2);			   

 }
 if ((((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)<0)
 {
spawn SendTTLToRemoteSystem(0);			   

 }


		nexttick;

  //////////////// upper right corner H coordinates
 
 Volt_Targ_H_2 = 3000 + abs(((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET);
 
spawn SendTTLToRemoteSystem(Volt_Targ_H_2);			   

 		 nexttick;
 if ((((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
spawn SendTTLToRemoteSystem(2);			   

 }
 if ((((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)<0)
 {
spawn SendTTLToRemoteSystem(0);			   

 }

	   nexttick;


	//////////////// upper right corner V coordinates
 
 	Volt_Targ_V_2 = 3000 + abs(((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET);

	nexttick;
	spawn SendTTLToRemoteSystem(Volt_Targ_V_2);	   
	if ((((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)>=0)
	{
		spawn SendTTLToRemoteSystem(2);			   
	}
	if ((((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)<0)
	{
	spawn SendTTLToRemoteSystem(0);			   
 	}
  	nexttick;

	//MODIFIED 05/24/07 EEE
	// STIM FILE INFO now included
	spawn SendTTLToRemoteSystem(7000);			   	 
	spawn SendTTLToRemoteSystem(Necc);
	spawn SendTTLToRemoteSystem(minEcc); 
	spawn SendTTLToRemoteSystem(stepEcc); 		   
	nexttick;
	spawn SendTTLToRemoteSystem(ang);
	spawn SendTTLToRemoteSystem(ang_2);
	spawn SendTTLToRemoteSystem(ang_3);
	nexttick;

}


//////////////////////////////////////////////////////////////////////////////////
// Process Write_PARAMS FOR TEMPO														//
// This process writes the parameters of a certain trial to the event channels.	//
// It is spawned by process END_TRIAL.											//
//////////////////////////////////////////////////////////////////////////////////

 

process WRITE_PARAMS_TEMPO()

///// SEND EVENTS TO TEMPO DATA BASE

{

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																													 //
//																													 //
//											            INFOS														 //
//																													 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 20 Columns...... and number of line = number of trials

 //1 NPOS Number of stimulus position 

 event_set(1,0,2721);
 nexttick;
 event_set(1,0,npos);
 nexttick;

  
 //2 Current POS of stimulus 

 event_set(1,0,2722);
 nexttick;
 event_set(1,0,trials[i]);
 nexttick;

 //// we could put here more information about the stimulus location

 //3 Flag wether use an acoustic stop signal (0 or 1) 0 by default 

 
 event_set(1,0,2723);
 nexttick;
 event_set(1,0,SOUND_S);
 nexttick;

  //4 Flag wether the current trial is no NOGO trial // Electrical stim parameter 


 event_set(1,0,2724);
 nexttick;
 event_set(1,0,npos);
 nexttick;
     
//5 Empty


 //6 Flag wether trigger is changed of color or not (0 = no by default) 

 event_set(1,0,2726);
 nexttick;
 event_set(1,0,npos);
 nexttick;

 //8 Fraction of rewarded trial 

 event_set(1,0,2728);
 nexttick;
 event_set(1,0,npos);
 nexttick;

		  
 //9 fraction of NoGO trial  1/NOGO_RATIO = ratio of nogo e.g NOGO_RATIO=3 0.33 of STOP Trials

 event_set(1,0,2729);
 nexttick;
 event_set(1,0,npos);
 nexttick;
	
 
 //10 Flag wether the current trial is a NOGO trial 1= GO 2=NOGO we added -1 to send 0 or 1 (conform to PDP coding)

 event_set(1,0,2730);
 nexttick;
 event_set(1,0,types[j]);
 nexttick;
		     
 //11 Time relative to the cue to Stim (+ or - time) we defined 700 as the origin (we can no send a negative number 

 event_set(1,0,2731);
 nexttick;
 event_set(1,0,npos);
 nexttick;
	   
 //12 Duration of the electric stimulation  

 event_set(1,0,2732);
 nexttick;
 event_set(1,0,npos);
 nexttick;
	

 //13 Flad wether retangular (0) or exponential (1) hold distribution  

 event_set(1,0,2733);
 nexttick;
 event_set(1,0,npos);
 nexttick;


 //14 Delay between TARGET ON and FIXATION OFF (=0 by default) 

 event_set(1,0,2734);
 nexttick;
 event_set(1,0,HOLDT);
 nexttick;
		 
 //15 Hold time Jitter % of the total holdtime  

 event_set(1,0,2735);
 nexttick;
 event_set(1,0,npos);
 nexttick;


 // 16 Length of target presentation MWL
 event_set(1,0,2736);
 nexttick;
 event_set(1,0,Stimulus_Time);
 nexttick;



 //17 SOA of the current trial SSD 

 event_set(1,0,2737);
 nexttick;
 event_set(1,0,npos);
 nexttick;
	 		  
 //18 Maximum SOA between the GO and NOGO cue 

 event_set(1,0,2738);
 nexttick;
 event_set(1,0,npos);
 nexttick;

 
 //19 Minimum SOA between the GO and NOGO cue 

 event_set(1,0,2739);
 nexttick;
 event_set(1,0,npos);
 nexttick;

	
 //20 SOA intervalls

 event_set(1,0,2740);
 nexttick;
 event_set(1,0,npos);
 nexttick;
			  
 //21 FixWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)  ATTENTION : we considered here that the fixation windows were placed in the center of the screen

 event_set(1,0,2770);
 nexttick;

	
//////////////// Lower left corner H coordinates
 
 event_set(1,0,abs(-Fix_H/2));
 nexttick;
 event_set(1,0,0);
 nexttick;

 	  
//////////////// Lower left corner V coordinates
 
 event_set(1,0,abs(-Fix_V/2));
 nexttick;
 event_set(1,0,0);
 nexttick;
		  	
 //////////////// Upper right corner H coordinates
 
 event_set(1,0,Fix_H/2);
 nexttick;
 event_set(1,0,2);
 nexttick;


//////////////// Upper right corner V coordinates
 
event_set(1,0,Fix_V/2);
nexttick;
event_set(1,0,2);
nexttick;
 		   

 //22 TARGWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)

event_set(1,0,2771);
nexttick;
   

//////////////// Lower left corner H coordinates
 
event_set(1,0,abs((TARH-(Targ_H/2))));
nexttick;
 if ((TARH-(Targ_H/2))>=0)
 {
 
event_set(1,0,2);
nexttick;

 }
 if ((TARH-(Targ_H/2))<0)
 {
event_set(1,0,0);
nexttick;
 }


 
event_set(1,0,abs((TARH-(Targ_H/2))));
nexttick; 
if ((TARH-(Targ_H/2))>=0)
 {
event_set(1,0,2);
nexttick;
 }
 if ((TARH-(Targ_H/2))<0)
 {
event_set(1,0,0);
nexttick;
 }



//////////////// Lower left corner V coordinates
 
event_set(1,0,abs((TARV-(Targ_V/2))));
nexttick; 
 
 if ((TARV-(Targ_V/2))>=0)
 {
event_set(1,0,2);
nexttick;
 }
 if ((TARV-(Targ_V/2))<0)
 {
event_set(1,0,0);
nexttick; }

//////////////// Lower left corner H coordinates
 
 

 event_set(1,0,abs((TARH+(Targ_H/2))));
 nexttick;
 
 if ((TARH+(Targ_H/2))>=0)
 {
event_set(1,0,2);
nexttick;
 }
 if ((TARH+(Targ_H/2))<0)
 {
event_set(1,0,0);
nexttick;
 }
	
//////////////// Lower left corner V coordinates
 
 event_set(1,0,abs((TARV+(Targ_V/2))));
 nexttick;
    
	if ((TARV+(Targ_V/2))>=0)
	 {
	event_set(1,0,2);
	nexttick;
	 }
	 if ((TARV+(Targ_V/2))<0)
	 {
	event_set(1,0,0);
	nexttick;
	 } 
   
}








//////////////////////////////////////////////////////////////////////////////
// Process MARKER															//
//																			//
// A light sensitive diode (LSD) is connected to counter channel 5.  It		//
// is positioned on the VideoSYNC monitor.  Periodically, the protocol will	//
// display/hide a box causing the LSD to emit a pulse which is picked up	//
// on counter channel 5.  This pulse is used to identify when the VideoSYNC	//
// stimulus is actually displayed to the subject.							//
//																			//
// This process runs until the LSD emits a pulse.  An event code is emitted	//
// to event channel 1 and the process terminates.							//
//																			//
// INPUT																	//
//      event																//
//      CounterChannel5 connected to LSD									//
// OUTPUT																	//
//      EventChannel1[0] receives the value "event + index" where "index"	//
//      is 0..ASETS-1, indicating the time the LSD pulse was detected.		//
//      This 																//
//////////////////////////////////////////////////////////////////////////////

process MARKER()
{
    int MarkerOn;           									 // 0=we haven't yet seen a pulse, 1=we've seen a pulse
    int index;              									 // Indexes through all ASETS samples of a channel
	int nAsets=2;
	MarkerOn = 0; 
	                      						 // We haven't yet seen the TTL pulse
	while (!MarkerOn)                   						 // Keep going provided we haven't see the pulse...
    {
		// Scan the first 4 (presumably ASETS=4) samples on Counter5[] looking
		// for the LSD pulse.  If we find it, set an event in EventChannel 1[0]
		// which is the sum of "event" and the index (time) of the LSD pulse.
    	index = 0;
		

	    while (index < nAsets)               					 // index=0,1,2,3 (scan through ASETS samples) ..
        {
 	 
 			// We check to see if the LSD emitted a pulse.  We do this
 			// by calling ctable_set(), which returns the "previous" sample.
 			// I'm not sure why ctable_get() wasn't used instead.  There is
 			// some reason why the user wants to test if an LSD pulse was
 			// received while simultaneously setting counter channel 5 to 0.
        
        	if (ctable_set(1,index,0))          				 // If (Counter5[index] != 0) ...
            {       
                                    					 // ..(also sets Counter5[index]=0)
            	if (!MarkerOn)                  				 // Has event code already been set?
                {                           					 // No,		 		  
         			// VARIABLE USED...for TARGET_ON COULD BE COMPARED with TARGET_PRE 
		            spawn SendTTLToRemoteSystem(2650);				   ///// event code target on  
        		 	//////////////////// Event create for neuro explorer  not used in the matlab code
		         	//1 NPOS Number of stimulus position 
                 	spawn SendTTLToRemoteSystem(2800+trials[i]);				   
                	MarkerOn = 1;  
                	TEST_VIDEO=1;	            				 // Note that we've set the event code
                }
            }
	        index = index + 1;                  				 // Advance to next element in Counter5[]
        }
    	// The LSD did not generate a pulse.  Wait one process cycle
    	// and continue looking for it.
    	nexttick;
    }
  	// We detected an LSD pulse.  Exit this processs.
}

process MARKER_2()
{
    int MarkerOn;           									 // 0=we haven't yet seen a pulse, 1=we've seen a pulse
    int index;              									 // Indexes through all ASETS samples of a channel
	int nAsets=2;
	MarkerOn = 0; 
	                      						 // We haven't yet seen the TTL pulse
	while (!MarkerOn)                   						 // Keep going provided we haven't see the pulse...
    {
		// Scan the first 4 (presumably ASETS=4) samples on Counter5[] looking
		// for the LSD pulse.  If we find it, set an event in EventChannel 1[0]
		// which is the sum of "event" and the index (time) of the LSD pulse.
    	index = 0;
		

	    while (index < nAsets)               					 // index=0,1,2,3 (scan through ASETS samples) ..
        {
 	 
 			// We check to see if the LSD emitted a pulse.  We do this
 			// by calling ctable_set(), which returns the "previous" sample.
 			// I'm not sure why ctable_get() wasn't used instead.  There is
 			// some reason why the user wants to test if an LSD pulse was
 			// received while simultaneously setting counter channel 5 to 0.
        
        	if (ctable_set(1,index,0))          				 // If (Counter5[index] != 0) ...
            {       
                                    					 // ..(also sets Counter5[index]=0)
            	if (!MarkerOn)                  				 // Has event code already been set?
                {                           					 // No,

				  
         // VARIABLE USED...for TARGET_ON COULD BE COMPARED with TARGET_PRE 
          spawn SendTTLToRemoteSystem(2654);	//////// event code stop on


		      	
					event_set(1,0,2654);									 // Event Code for Tempo data base.
                    nexttick;


                  //	event_set(1,0,EV_TAR_ON); 					 // Set EventChannel1[0] = EV_TAR_ON.
                	MarkerOn = 1;               				 // Note that we've set the event code
                }
            }
	        index = index + 1;                  				 // Advance to next element in Counter5[]
        }
    	// The LSD did not generate a pulse.  Wait one process cycle
    	// and continue looking for it.
    	nexttick;
    }
  
  
}




process SHUFFLE()
{
  	
 READY_S=0;

 // Task_type here memory guided
spawn SendTTLToRemoteSystem(1502);					   


 event_set(1,0,1502);									 // Event Code for Tempo data base.
 nexttick;

 
	printf("         \n");
	printf("########### RESHUFFLING END OF BLOCK! ########### \n");
	printf("         \n");

  	
  	
  	spawn INIT_TRIAL_ARRAY(npos);	     	 // Assign the position of the target for each trials   
  	waitforprocess INIT_TRIAL_ARRAY;							 // - to change this, you can either change the ratio here manually, or 
																 // create a macro in Tempo to do it.
  //	printf("########### Step 1 ########### \n");
  	
  	spawn SHUFFLE_TRIAL_ARRAY;              					 // Now shuffle it
  	waitforprocess SHUFFLE_TRIAL_ARRAY;
  // printf("########### Step 2 ########### \n");
	 
  	i = 0;
    READY_S=1;
     
  
 }

process CLEAN_UP()
{
	
    READY_S=0;
    
    spawn CLEAR;
	waitforprocess CLEAR;

	spawn END_TRIAL;
	waitforprocess END_TRIAL;

     
    
    	 
    dsend("cl");
	printf("         \n");
	printf("         \n");
	printf("########### RESHUFFLING! ########### \n");
	printf("         \n");
	printf("         \n");
			 // Clear graph.

	if(TrialCount>1)
	{

	
   	oSetAttribute(oF1, aINVISIBLE);            				 	 // Make invisible.
	oSetAttribute(oB1, aINVISIBLE);             				 
    oSetAttribute(oB1x, aINVISIBLE);               				 
	
   	 }
    	
   	oDestroy(oF);
    
   	oSetGraph(gLeft, aCLEAR);
	oSetGraph(gRight, aCLEAR);

	
	
    spawn INITIALIZE;			 							 	 // Initialize animation and VideoSync objects.
   	waitforprocess INITIALIZE;
 	if(TrialCount>1)
	{
   
    oDestroy(oF1);					 							 // Destroy objects in the previous trial.
    oDestroy(oB1);					 
    oDestroy(oB1x);
	}
   
    
	spawn SHUFFLE;												 // Shuffle all the trial types.
	waitforprocess SHUFFLE;
	
	
		
	//spawn WATCHEYE;			 								 	 // Monitor the eye coordinates.

	//spawn TRIAL_LOOP;		
}

	  
	  
	  
	  //////////////////////// ECCENTRICITY 

process INIT_TRIAL_ARRAY(int npos)					 // These nTypes are LOCAL variables - not the same as the var's for InitTypes.
{

int Pos;
int kpos;
int ipos;
int jpos;
int inc_ecc;
int pipo;
int nECC_cond;
int kecc;

pipo=0;
while (pipo<100)
{
trials[pipo]=0;
pipo=pipo+1;
nexttick;
}


inc_ecc=1;
kecc=1;
kpos=1;
ipos=0;



   nECC_cond=(nTrials/(npos*Necc));	  
   
   while(ipos<nTrials)
   	 {
	  kecc=1;
	  while (kecc <= nEcc_cond)
  	   	{		
		 kpos=1;
		 while(kpos<=npos)
			{  	  		
	  		Ecc[ipos]= minEcc+(stepEcc*(inc_ecc-1));
	  		trials[ipos]=kpos;
	  		ipos = ipos + 1;
			kpos = kpos + 1;
			nexttick;
			}
			kecc=kecc+1;
		nexttick;
		}
	   inc_ecc=inc_ecc+1;
	  nexttick;
	  }

}
///////////////////////////////////////////////////////////////////////////////////
// Process ShuffleTrialArray()													 //
// Use TEMPO's uniform random number generator to randomize the Trials[] array.	 //
// We sequence through the entire Trials[] array.  For each element, we exchange //
// its value with the a randomly selected element.								 //
///////////////////////////////////////////////////////////////////////////////////

process SHUFFLE_TRIAL_ARRAY()
{
    int i_v;
    int r;
    int temp;
    
	i_v=0;
 //printf("nTrials: %d\n", nTrials);
 //printf("i_v: %d\n", i_v);

	while (i_v < nTrials)
    {
	    r = random(nTrials);                					 // Randomly select an element from the Trials[] array.
	    
   //	     printf("i_v: %d\n", i_v);
   //		 wait(600);
   //		 printf("r: %d\n", r);
	    														 // 0 <= r < NTRIALS
    	temp = trials[i_v];										 // Exchange the value of the randomly selected element
		trials[i_v] = trials[r];								     // with the current element. 
	    trials[r] = temp;
        
    	i_v = i_v + 1;
    }


}


   


 ////////////////////////////////////////////////

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 
///                                       PROCESS INIT_FIXATION_CHECK
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


process INIT_FIXATION_CHECK()
{
   
   
   if(TrialCount>0 && step<1)
	{

    oSetAttribute(oB1, aINVISIBLE);  
   	oSetGraph(gLeft, aCLEAR);	
	oSetGraph(gRight, aCLEAR);	
	
  	oSetAttribute(oB1x, aINVISIBLE);  
	step=step+1;
	}

	end_initfix_minT = time() + initfix_minT;   	
	while (time() < end_initfix_minT && In_Fixation_Window==0) /// && In_Fixation_Window==0	added 10/07/2005
		nexttick;
	
	if (!In_Fixation_Window)         
	{ 
		failed = ERR_LEAVE_FIX;       
		in_init_fixation_window=fix_control;	 				 // If fix_control == 1, no init fixation needed
		
		if (fix_control == 0)
		{
			dsendf("co 0;");
	   		dsend("xm fix_init(0,0,3)"); 
			wait(initfix_punishtime);
			nexttick;

		   	spawn INIT_FIX_CORRECTOR; 
			waitforprocess INIT_FIX_CORRECTOR;
			print("No initial fixation!");
		}
		else if (fix_control == 1)								 // We don't need initial fixation.  Suspend the fixation corrector.
		{
			suspend INIT_FIX_CORRECTOR; 
			print("No initial fixation needed.");
		}
	}
	else 
	{
		in_init_fixation_window = 1;							 // We don't need initial fixation.  Suspend the fixation corrector.
		suspend INIT_FIX_CORRECTOR;
	    suspend INIT_FIXATION_CHECK; // added 10/07/2005
	}
}

process INIT_FIX_CORRECTOR()
{
	 
	int time_melanie;

	while(in_init_fixation_window == 0 && In_Fixation_Window==0)  /// && In_Fixation_Window==0	added 10/07/2005
	{
		
	    time_melanie = time() + 3600;   	
    			
		dsendf("co 15;"); //MWL changed from 15 to 10	  
		dsend("xm fix(0,0,15)"); 
		while (time() < time_melanie && In_Fixation_Window==0) /// && In_Fixation_Window==0	added 10/07/2005
		{
		wait(4);
   		nexttick;
   		}
   	   	

	   
		//MWL
//		dsendf("co 0;");
//	    dsend("xm fix_init(0,0,3)"); 
//		wait(100);
//		nexttick;
		
		spawn INIT_FIXATION_CHECK;
		
		wait(initfix_punishtime);   				
	}

	if(in_init_fixation_window==1 || In_Fixation_Window==1)	   /// || In_Fixation_Window==1	added 10/07/2005

	{	
		suspend INIT_FIX_CORRECTOR;
		suspend INIT_FIXATION_CHECK; 
	}
	   
	nexttick;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 
///                                       PROCESS SENDING STROBE TO PLEXON 
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




// Call queueEvent() in your protocol when you want to send an event code to Plexon

process queueEvent()  enabled  // Call this to queue an event code	  // enabled : here run in the background
{                                   // for transmission to Plexon

     	   
    int     nextPut;
  	
 nextPut = (put + 1) % nXMIT;        // precompute the next put value

if (nextPut == get)                 // Are we full (nXmit-1 events in xmit[])?
    printf("queueEvent - xmit[] buffer is full! - Can't send event %d to Plexon\n", eventCode);
else
    {
    xmit[put] = eventCode;                  // store event code in transmit array
    put = nextPut;                  // Advance put index to next location
    }
}


//-------------------------------------------------------------------------
process SendTTLToRemoteSystem(int value)	      
      {
      dioSetMode(REMOTE_TTL, PORTA|PORTB|PORTC);		       
	   			  	   	   
    	 dioSetA(REMOTE_TTL, (value & 0xFF ));
         dioSetB(REMOTE_TTL, ((value / 256) & 0x7F) | 0x80); // load & strobe
		 dioSetC(REMOTE_TTL, 0x01);     
           	   		
           spawn delay(150);
           waitforprocess Delay; 
             			 	 
		 dioSetA(REMOTE_TTL, (0x0 & 0xFF));
		 dioSetB(REMOTE_TTL, (0x0 & 0x7F));   
     	 dioSetC(REMOTE_TTL, 0x00);                
     }

   
process Delay(int uSeconds)	
        {
		int start, duration;
        int ticks;

        ticks = uSeconds * 1.193180;     // Convert uSec to 1193180 Hz ticks
        start = timeus();
        duration = 0;
        while (duration < ticks)
                {
                duration = (timeus() - start) & 0xFFFF;
                }
        }

//-------------------------------------------------------------------------
// Process xmitEvents() runs in the background and sends up to 5 event codes
// per process cycle to the remote system, drawing them from the xmit[] array.
// This process should be the last process in your protocol so that any
// preceeding process that adds an event code to the xmit[] will do so
// before xmitEvents() runs.

process xmitEvents() enabled        // This could also be spawned in your init() process
{
    int         ki;                  // # of codes sent this process cycle
 

while (1)                           // We loop indefinitely..
    {
    ki = 0;
    while (ki < nEventsPerProcessCycle && get != put)    // Up to nEventsPerProcessCycle are sent..
        {
        spawn SendTTLToRemoteSystem(xmit[get]);  //toto // Send next code to Plexon
        waitforprocess SendTTLToRemoteSystem;     // Prudent but not necessary
        get = (get + 1) % nXMIT;            // Advance to next event code xmit[]        
        ki = ki + 1;                          // Count one more code transmitted
        }
    
    nexttick;                       // ..Wait one process cycle
    }
}




///////////////////////////////////////////// C'EST FINI ///////////////////////////////////////////////////////////