/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																				   //
//																																				   //
//                                                        Countermanding task.	DECEMBER 2004													   //
//																																				   //
//                                           Created by pierre_pouget@vanderbilt.edu  & erik.emeric@vanderbilt.edu												   //
//																																				   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFIED 02/21/07 EEE
//		DECREASED THE ECCENTRICITY OF THE FIXATION STIM TO ~10 DEG 


//////////////////////////////////////// SUBFUNCTION NEEDED ///////////////////////////
				  
#pragma declare = 1                     					 	 // Require declarations of all variables.
#include object.pro                   						     // Required when using object graphs.
#include DIO.pro

//////////////////////////////////////// settings in dialog box

declare maya;

declare MONKEY=1;
declare DEBUG;   
declare AUTOMONKEY;

declare Fix_H=250;                                // Size of box in which eye can be and be said to fixate target.
declare Fix_V=250;


declare Fix_V_p=0;
declare Fix_H_p=0;		
declare calib_pos=1;


declare Volt_Fix_H_1;                          // Voltage value for Fixation Window
declare Volt_Fix_V_1;
declare Volt_Fix_H_2;                          // Voltage value for Fixation Window
declare Volt_Fix_V_2;


declare Targ_H;	                             // Size of box in which eye can be and be said to fixate center.
declare Targ_V;
declare int Volt_Targ_H_1;						 // Voltage value for the Target window
declare int Volt_Targ_V_1;
declare int Volt_Targ_H_2;						 // Voltage value for the Target window
declare int Volt_Targ_V_2;


declare XGAIN= 30;
declare YGAIN=-30;
declare V_OFFSET;
declare H_OFFSET;
declare XMAX=1280;  										 // Variables for size of animation graph windows.
declare YMAX=1024;  										 // Variables for size of animation graph windows.

declare XMAX_SCREEN=1280;  										 // Variables for size of animation graph windows.
declare YMAX_SCREEN=1024;  										 // Variables for size of animation graph windows.




/////////////////////////// GENERAL DECLARATION

declare int nASETS;												 // Current setting for ASETS .
                   // =0 for real analog, =1 for mouse input
declare READY_S=0;
declare SOUND_FLAG=0;                    /// Creat sound  start and stimulation 
declare toto=0;	    					 // Variable for debugging
declare step=0;

////////////////////////// PROTOCOL DECLARATION

declare Task=1;                       // Countermanding
declare TEST_VIDEO=0;				  // Check if the screen is on
declare oF, oF1, oE, oE1, oB1, oB1x;		   //	Animation object variables.           					                                                


/////////////////////////////// EVENT RELATIVE OT EYES LOCATION

declare In_Fixation_Window = 0;									 // Tracks whether eye position is in fixation square.
declare In_Target = 0;											 // Tracks whether the eye is in the target box.	   //500
declare failed = 0;												 // Monitors whether trial has failed.
declare fix_control=0; 											 // Controlling whether monkey needs to fix before trial; default=0; fix_conto=1 no fix needed
declare in_init_fixation_window;								 // Tracks whether the eye is in the initial fixation area.
declare ERR_OK = 0;												 // Sets variable Failed to 0 at beginning.
declare ERR_LEAVE_FIX = 1;										 // Error: left fixation too quickly.
declare ERR_NO_FIXHOLD = 2;										 // Error: did not hold fixation long enough.
declare ERR_TAR_TOOLATE = 3;									 // Error: did not acquire target quickly enough.
declare ERR_NO_HOLDTAR = 4;										 // Error: did not hold target (targ or fixation) long enough.
declare ERR_NOFIX_STOPTRIAL = 5;								 // Error: made a saccade in a stop-signal trial.
declare ERR_TIME_SAC=6;
declare correctmarker = 0;										 // Marks whether the trial was a success for WRITE_PARAMS().
declare float TrialCount, SuccessCount;		 					 // Trial record variables.
declare float NoStopSuccessCounter = 0;							 // Counter for no-stop trial successes.
declare float StopSuccessCounter = 0;							 // Counter for stop signal trial successes.
declare float StopCounter; 										 //	Counter for stop trials.
declare float NoStopCounter;									 // Counter for no-stop trials.
declare	signal_respond_marker = 0;								 // Marks whether trial failed because it was a signal-respond trial.

//////////////////////// TIME ON THE CLOCK////////////////////

declare end_fix_presentationT;									 // Marks the time on the clock when the fixation box will disappear.
declare end_fix_targ_maxT;										 // Marks the time on the clock by which the subject must have saccaded from fix to target.
declare stop_signal_startT;										 // Marks the time "Clock" when the stop signal was presented.
declare end;													 // Marks time on clock when holding time for target or fixating time in stop-signal trials ends.
declare start_time;												 // Stores the time at which a trial begins.
declare float sac_latency;											 // Records latency of saccade to target.
	
///////////////////////////// COUNTERMANDING VARIABLES

declare int nSSD;				// number of SOA intervalls			min, min*kStep .... max 
declare int nTrials;						 // Number of different trials in a cycle.
declare int nTypes; 	 	
declare int nStop;
declare int nPOS_zero;
declare int nPOS_others;
declare int nZAP_NOGO;				 // Number of NOGO trials with  Stimualtion
declare int nISNOTNOGO;					 // Number of GO Trials with Stimulation
declare int nNOGO;
declare int tfraction = 50;                                       // fraction of trials with target @ pos 0 (1== max) (2 == 50%)
declare int NOGO_RATIO =100;										 // Fraction of nogo trial
declare int ZAP_RATIO =0;
declare int ISNOTNOGO_RATIO=0;
declare ISNOTNOGO_RATIO_Dial=ISNOTNOGO_RATIO;

////////////////////////////// PERFORMANCE DIALOG BOX

	 /*
declare int NB_Success_SSD1
declare int NB_Success_SSD2
declare int NB_Success_SSD3
declare int NB_Success_SSD4
declare int NB_Success_SSD5

declare int NB_Error_SSD1
declare int NB_Error_SSD2
declare int NB_Error_SSD3
declare int NB_Error_SSD4
declare int NB_Error_SSD5

				   */
////// ARRAYS DECLARATION

declare i = 0;													 // Trial Array index (which side of axis target is presented on ).	
declare j = 0;													 // Type Array index (whether it's a stop or no-stop trial).
declare s = 0;													 // Stop Array index (stop-signal delay in stop trials).
declare Stimu[1000];
declare trials[1000];										 // Trial Array (which side of axis target is presented on ).	
declare types[1000];											 // Type Array (whether it's a stop or no-stop trial).
declare stop[1000];											 // Stop Array (stop-signal delay in stop trials).
declare STOP_success[1000];
declare SSD_array[1000];
declare inhib_fct[1000];
//////

declare tfraction_Dial=tfraction;
declare NOGO_RATIO_Dial=NOGO_RATIO;
declare SSD_Step=100;										 // SOA steps
declare SSD_min=200;										 // SOA min
declare SSD_max=400;  										 // SOA max
declare fix_targ_maxT = SSD_max*2;							 // Maximum RT for moving from fixation window to target window.
declare ZAP_RATIO_Dial=ZAP_RATIO;
declare staircase=0;                                             // Staircase for SSD =0 by default (no staircase)
declare SOUND_S = 0;                                                // Flag wether use of acoustic stop signal (0=no 1= yes)
declare ISNOT_NOGO = 0;										     // Flag wether the current trial is not a nogo trial 0 by default (for electrical stim parameter)
declare TRIG_CHANGE = 0;											 // Flag wether trigger is changed of color	0=no by default
declare REWARD_RATIO = 100;											 // Fraction of rewarded trial ( 09/21/2004 =1 Loop need to be added
declare frac_no_reward = 0;                                        // % of no reward trial (which should be rewarded
declare frac_extra_reward =0;
declare feedback = 0;                                             ///  flag whether to give feedback about errorby turning off the target
declare Bell=1;                                                   // ring the bell on each reward
declare REWARD_SIZE=50;  //MWL										 // Amount of time to give juice.
declare SOUND_REWARD=0;                                        // Acoustic reinforcement 
declare Block=0;
declare tot_others;
declare ind_others;
/////////////////////////////////////////////////////
	
declare FIXED_JITTER=0;											 // JITTER is Linear (random(value) + or -)
declare EXPO_JITTER=1;											 // JITTER is "expo" number (right part of normal distribution + constant

///////////////////////////// FRACTION JITTER IF LINEAR

declare int frac_fix_jitter=50;	 /// fixation
declare int frac_stop_t_jitter=50;	//// hold on fixation after stop signal
declare int frac_hold_jitter=0;		/// hold on target after Go trial
declare float expo_1;
declare float expo_2;
declare float expo_3;												 // Turn on animation.
declare int expo_jitter_fixation;
declare int expo_jitter_target;
declare int expo_jitter_stop;
		
///////////////////////////// HOLD Time 

declare initfix_minT = 150;     								 // Initial fixation requirement time.
declare end_initfix_minT;										 // Marks the time on the clock during which the eye must be in the initial fix area (time() + initfix_minT).
declare fix_t=1000; 						                         // Presentation time of fixation point. 
declare fix_jitter;
declare hold_fixation_time;
declare stop_fix_t = SSD_max*3;	 							 // Minimum time to fixate center after stop signal is presented.
declare stop_fix_t_jitter;
declare stop_fix_time;
declare holdtime=400;											 // Time to hold target in no signal trial.
declare holdtime_jitter;
declare hold_target_time;
declare step_lat;
declare trial_start;
declare step_wind;
declare step_targ;
//////////////////////////////////////////////////////////////////

declare constant waitAutoMonkey = 520;
declare inter_trial = 800;  					            	 // Intertrial interval variables.
declare initfix_punishtime = 3000;	   //MWL							 // Amount of wait time for punishment if initial fixation not maintained.
declare signal_respond_punishT = 500;							 // Wait time if trial failed due to signal-respond.
declare Sacc_time=300;
declare Saccade_time;
declare Saccadic_time;
declare GO_DELAY=0;												  // Time between fixation off and target on // 0 in coutnermanding
//////////////////////// STIMULI CONFIGURATION ///////////////////

declare float width = 40;										 // Width of squares TARGET.
declare npos = 2;											 // Number of stimulus position
declare tpos = 0;                                            // angle relative to right==0 for the target location 
declare ang = 0;												 // Angles it the angle in degrees from horizontal axis going clockwise.
declare ang_2=45;                                                // In Case of 4 target locations Angles between the two first targets in degrees from H clock between the TARGET location  
declare ang_3=45;												 // In Case of 6 target locations Angles between the two seconds targets targets in degrees from H clock between the TARGET location  
declare eccen = 315;   											 // Eccentricity defines visual angle between center and target.
declare TarH, TarV;												 // Target horizonatal and vert location for VideoSync.
declare float screen_scale  = 1.3;									// Correcion factor to account for a swap in screens and to change eccentricity to ~11 degrees 6-28-10 DCG
declare fix_size = 5;

declare col_tar = 2;											 // VideoSync variable for the color of the target.
declare x, y, ax, ay, fixx, fixy,bxc,byc,axc,ayc;				//	Coordinates for determining eye position.

//////////////////////////////////////////////////////////////////


///////////////////////////////// STIMULATION VARIABLES

declare STIM_MARKER=2; ///1 for fixation 2 SSD 3 REWARD
declare STIM_OFFSET=52;
declare STIM_FLAG=0;  
declare time_trials_start;
declare time_target_on;
declare time_stop_signal;
declare time_reward;

///////////////////////////////////////////////////////////////////


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
declare SHUFFLE_STOP_ARRAY(int nStop);
declare INIT_STOP_ARRAY(int nSSD, SSD_Step, SSD_min, nTrials);
declare SHUFFLE_TYPES(int nTypes);
declare INIT_TYPES(int NOGO_RATIO,nTrials);
declare SHUFFLE_TRIAL_ARRAY(int nTrials);
declare INIT_TRIAL_ARRAY(int npos, nTrials);
declare SHUFFLE();
declare CLEAN_UP();
declare WRITE_PARAMS_TEMPO();
declare INIT_STIM_ARRAY (int nSSD, SSD_Step, SSD_min, nZAP_NOGO,nTrials);											 
declare SHUFFLE_STIM_ARRAY(int nSTop);
declare ELECT_STIM();
declare SOUND_ON_REWARD();
declare EXTRA_REWARD();			
declare WATCH_TIME();
declare CLEAR_B();
declare ACCOUSTIC_STOP();
declare CAL_FIX();

//////////////////////////////////////////////// ADJUST OFFSET //////////////////////////////

declare eFix_H=0;
declare eFIX_V=0;

/////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////// PLEXON COMUNICATION ////////////////////////////////

declare int value;   
declare int get = 0, put = 0;               // get and put indexes into xmit[]
declare int constant nXMIT = 100;            // Size of xmit[]
declare int xmit[nXMIT];                    // Transmit array to Remote system
declare int constant nEventsPerProcessCycle = 10;    // Max # of events sent per process cycle
declare int eventCode;//=3255;
declare int usec = 150;
declare int REMOTE_TTL=1;
declare HEX dio_a,dio_b, dio_c;
declare queueEvent(),xmitEvents();
declare SendTTLToRemoteSystem (int value);
declare Delay(int uSeconds);

///////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process MAIN: Controls all the other processes and is the only process enabled when the protocol is started. //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

process MAIN() enabled 											 // "enabled" makes this process start when the protocol is started.  					   										 	 
																 // All other processes must be spawned.
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
    oSetGraph(gRight, aRANGE, -XMAX_SCREEN/2, XMAX_SCREEN/2, -YMAX_SCREEN/2, YMAX_SCREEN/2); // Object graph virt. coord - Right Graph
    oF = oCreate(tBOX, gRight, Fix_H, Fix_V);    			 // Create FIXATION object
    oSetAttribute(oF, aVISIBLE);  //aIN            				 // Not visible yet
    
    oE = oCreate(txCross, gRight, 20, 20);       				 // Create EYE object
    oSetAttribute(oE, aVISIBLE);                				 // It's always visible

    oSetGraph(gLeft, aRANGE, -XMAX_SCREEN/2, XMAX_SCREEN/2, -YMAX_SCREEN/2, YMAX_SCREEN/2);  // Object graph virt. coord - Left Graph
	oE1 = oCreate(txCross, gLeft, 20, 20);     					 // Create EYE object
	oSetAttribute(oE1, aVISIBLE);             					 // Visible only during a trial
    oSetAttribute(oE1, aREPLACE);               				 // Draw trace on left graph
	
	// These are the VideoSync Eye Cross used for debugging
//    dsendf("oc 1,3\n");                          				 // Cross hair for "eye"
  //  dsendf("ow 1,20,20\n");                      				 // width & height
    //dsendf("oi 1,13\n");                         				 // color
    //dsendf("os 1\n");                            				 // make visible

 	dsend("dm fix_init($1, $2, $3)");  	
 	dsend("rf $1-5, $2-5, $1+5, $2+5");
	dsendf("co $3;");			  
	dsend("em");
	
	nexttick;													 // Wait one process cycle.

	dsend("vc -640, 640, -512, 512"); 							 // Set virtual coordinates.
	dsend("mv 0,0");		  									 // Move mouse to VC (0,0)
    
    TrialCount = 0;                             				 // Zero out statistics
    SuccessCount = 0;
	NoStopCounter = 0;
	StopCounter = 0;
	NoStopSuccessCounter = 0;
	StopSuccessCounter = 0;
	Block = 0;

if(FIXED_JITTER==1)
{
EXPO_JITTER=0;
}

if(EXPO_JITTER==1)
{
FIXED_JITTER=0;
}

//////////////////// needed when reshuffle or when we made a change during the session ////

nSSD = ((SSD_max-SSD_min)/SSD_Step)+1;				

NOGO_RATIO=NOGO_RATIO_Dial;
ZAP_RATIO=ZAP_RATIO_Dial;
tfraction=tfraction_Dial;
ISNOTNOGO_RATIO=ISNOTNOGO_RATIO_Dial;

////////////////////////////////////////////////// PERCENTAGE to FRACTION to INTERGER ///////////////////////////////
//////////////////////////////////////////////////
if(NOGO_RATIO==0)
{
NOGO_RATIO=-100;
NOGO_RATIO_Dial=0;
}
//////////////////////////////////////////////////



/////////////////////////////////////////////////
if(ZAP_RATIO==0)
{
ZAP_RATIO=-100;
ZAP_RATIO_Dial=0;
}
/////////////////////////////////////////////////



/////////////////////////////////////////////////
if(tfraction==0)
{
tfraction=-100;
tfraction_Dial=0;
}
/////////////////////////////////////////////////

if(ISNOTNOGO_RATIO==0)
{
ISNOTNOGO_RATIO=-100;
ISNOTNOGO_RATIO_Dial=0;
}


////////////////////////////////////////////////////

nTrials = (npos*nSSD*(100/abs(NOGO_RATIO))*(100/abs(ZAP_RATIO))*(100/abs(tfraction)));	
nTypes = nTrials; 	 	

nStop = (nTrials*NOGO_RATIO)/100;

///////////////////////////////////////////////////

if(nStop<0)
{
nStop=0;
}

nZAP_NOGO = (nStop*ZAP_RATIO)/100;				 

if(nZAP_NOGO<0)
{
nZAP_NOGO=0;
}


nISNOTNOGO = (nZAP_NOGO*ISNOTNOGO_RATIO)/100;					                           
if(nISNOTNOGO<0)
{
nISNOTNOGO=0;
}

nNOGO=(nStop-nISNOTNOGO);

tot_others =(nTrials*(100-tfraction)/100);
ind_others =tot_others/(npos-1);

nPOS_zero = nTrials - (ind_others*(npos-1));

//nPOS_zero = ((nTrials*tfraction)/100);


if(nPOS_zero<0)
{
nPOS_zero=0;
}

//nPOS_others = (nTrials-nPOS_zero)/(npos-1);
nPOS_others = ind_others;



//////////////////////////////////////////////////////////////////////////

stop_fix_t = SSD_max*3;	 							 // Minimum time to fixate center after stop signal is presented. here in case of reshuffling
fix_targ_maxT = SSD_max*2;
	
//////////////////////////////////////////////////////////////////////////
  

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
	   
	 //	if ((abs(x) <= Fix_H/2) && (abs(y) <= Fix_V/2))		 // Check to see if eye position is inside the fixation window.
		if (x >= Fix_H_p - (Fix_H/2) && x <= Fix_H_p + (Fix_H/2) && y >= Fix_V_p - (Fix_V/2) && y <= Fix_V_p + (Fix_V/2)) // See if eye position is inside target.
	   		
		{
			In_Fixation_Window = 1;									 
			Saccadic_time=time();
													 
			if(types[j]==2)
			{
			if(Stimu[s]==2 || Stimu[s]==3)									 // If a stop trial and eye is in fixation, act as if eye is in target also, since fixation=target.
			  {
			  In_Target = 1;
			  }
			 }

		}
		else
		{
			In_Fixation_Window = 0;

			
                     if(trial_start==1 && step_wind==0)
					 {
                     eventCode=2810; /// Saccade The gaze goes out of the fixation window					   
                     spawn queueEvent();	
					 event_set(1,0,2810);									 // Event Code for Tempo data base.
                     nexttick;
		 			 step_wind=1;
		 			 }
		 
		 }
		if (x >= TarH - (Targ_H/2) && x <= TarH + (Targ_H/2) && y >= TarV - (Targ_V/2) && y <= TarV + (Targ_V/2)) // See if eye position is inside target.
    	 {
                     if(trial_start==1 && step_targ==0)
					   {
					    eventCode=2811; /// The gaze goes to the target window					   
                        spawn queueEvent();	   
                        event_set(1,0,2811);									 // Event Code for Tempo data base.
                        nexttick;
          			    step_targ=1;
		 			 }

          In_Target = 1;       
          
		 if(trial_start==1)
		  {
          if(types[j]==1 || Stimu[s]==1)
           { 
            if(failed==0 && step_lat==0)
			  {
               sac_latency= time() - end_fix_presentationT;
          	  // printf("Latency=%dms\n",sac_latency);
          	   step_lat=1;
          	   Saccade_time=time()-Saccadic_time;
          	  // printf("saccade time=%dms\n",Saccade_time);
          	   if(Saccade_time>Sacc_time) 
          	   {
          	   failed = ERR_TIME_SAC;
	          // print("Wrong Saccade Duration....");
		        spawn WRONG;
	        	waitforprocess WRONG;

          	   	}
          	   
          	   
          	   
          	   
          	   }
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
   dsend("cl");		// added 072905 clear screen

	
	
	dsend("dm fix($1, $2, $3)");								 // Fixation filled rectangle.
	dsend("rf $1-5, $2-5, $1+5, $2+5");							 // This is the rectangle the monkey must
	dsendf("co $3;");											 // fixate for a specified amount of time.
	dsend("em");
	
    dsend("sv width= ", width);									 // Define width (squares' width & length) for vdosync
  	
  	dsend("dm target($1, $2, $3)");								 // Target square.
	dsend("rf $1-width/2, $2-width/2, $1+width/2, $2+width/2");
	dsendf("co $3;");	  
	dsend("em");

	dsend("dm targmarker($1, $2, $3)");  						 // One square for photodiode (MARKER process).
	// dsend("rf $1-800, $2-800, $1+300, $2+300");		  //75
	// dsend("rf $1-150, $2-150, $1+15, $2+150");		  //75
	dsendf("co $3;");	  
	dsend("em");
			   



			        ///////////////////////////////////////////////////////////////////////////////
		   //////////////////////////// CASE TWO STIMULI  Right or left 0 or 180deg ////////////////////////////////
if (npos==2)
{
if (trials[i] == 1)										     // Specifies on which side of the axis the target will appear.
{
TarH = cos(ang+tpos)*eccen;
TarV = -sin(ang+tpos)*eccen;
}
else if (trials[i] == 2)
{
TarH = cos(ang+tpos - 180)*eccen;
TarV = -sin(ang+tpos - 180)*eccen;
} 			    
} //end npos==2 

 
 
                             //////////////////////////////////////////////////////////////////////////////
		   //////////////////////////// CASE FOUR STIMULI   Cross 0 90 180 270 ////////////////////////////////
if (npos==4)
{
if (trials[i] == 1)										     // Specifies on which side of the axis the target will appear.
{
TarH = cos(ang)*eccen;
TarV = -sin(ang)*eccen;
}
else if (trials[i] == 2)
{
TarH = cos(ang+ang_2)*eccen;
TarV = -sin(ang+ang_2)*eccen;  
}
else if (trials[i] == 3)
{
TarH = cos(ang - 180)*eccen;   //// oposite to 1
TarV = -sin(ang - 180)*eccen;
}
else if (trials[i] == 4)
{
TarH = cos(ang+ang_2 - 180)*eccen;	  //// oposite to 2 
TarV = -sin(ang+ang_2 - 180)*eccen;
}
} // end of 4 stimuli


                           //////////////////////////////////////////////////////////////////////////////
		   //////////////////////////// CASE SIX STIMULI   Cross 0 90 180 270 ////////////////////////////////
if (npos==6)
{
if (trials[i] == 1)										     // Specifies on which side of the axis the target will appear.
{
TarH = cos(ang+tpos)*eccen;
TarV = -sin(ang+tpos)*eccen;
}
else if (trials[i] == 2)
{
TarH = cos(ang+tpos+ang_2)*eccen;
TarV = -sin(ang+tpos+ang_2)*eccen;  
}
else if (trials[i] == 3)
{
TarH = cos(ang+tpos+ang_2+ang_3)*eccen;
TarV = -sin(ang+tpos+ang_2+ang_3)*eccen;  
}

else if (trials[i] == 4)
{
TarH = cos(ang+tpos - 180)*eccen;   //// oposite to 1
TarV = -sin(ang+tpos - 180)*eccen;
}
else if (trials[i] == 5)
{
TarH = cos(ang+tpos+ang_2 - 180)*eccen;	  //// oposite to 2 
TarV = -sin(ang+tpos+ang_2 - 180)*eccen;
}
else if (trials[i] == 6)
{
TarH = cos(ang+tpos+ang_2+ang_3 - 180)*eccen;	  //// oposite to 2 
TarV = -sin(ang+tpos+ang_2+ang_3 - 180)*eccen;
}

} // end of 6 stimuli

				  
				  
				  //////////////////////////////////////////////////////////////////////////////



/*
if (types[j] == 1)									     // Specifies whether it will be a stop signal/ no stop signal trial.
{
print("Go Trial \n");
}
else if (types[j] == 2)
{
if(Stimu[s]==2 || Stimu[s]==3)
{
print("NOGo Trial \n");
printf("SSD=%dms\n",stop[s]);
}
if(Stimu[s]==1)
{
print("ISNOTNOGo Trial \n");
} 

}
else if (types[j] == 0) 
{	  
printf("ERROR ");
}
if (trials[i]== 0)
{
printf("ERROR 0");
}

  */		 
	dsend("sv TarH= ", TarH);									 // Assign var 'TarH' into vdosync var 'TarH'.
	dsend("sv TarV= ", TarV);
	dsend("sv col_tar= ", col_tar);								 // Assign var 'col_tar' (target_color) into vdosync var 'col_tar'.

    

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
float float_frac_fix_jitter;
float float_frac_hold_jitter;
float float_frac_stop_jitter;


/////////////////////////////////////////////////////
 if(frac_fix_jitter==0)
	{
	fix_jitter=0;
	}
if(frac_fix_jitter>0)
	{
	fix_jitter=random(fix_t/frac_fix_jitter);
	if(fix_jitter<((fix_t/frac_fix_jitter)/2))
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
float_frac_fix_jitter=(frac_fix_jitter/1.0)*expo_1*2.0;
expo_jitter_fixation=float_frac_fix_jitter;			  

hold_fixation_time = fix_t + expo_jitter_fixation; 	

}
if(FIXED_JITTER==1)
{
hold_fixation_time = fix_t	+ fix_jitter;
}



//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
if(frac_hold_jitter==0)
{
holdtime_jitter=0;
}
if(frac_hold_jitter>0)
{
holdtime_jitter=random(holdtime/frac_hold_jitter);			///////////////// HOLDTIME 	 on TARGET AFTER GO TRIAL
if(holdtime_jitter<(holdtime/(frac_hold_jitter)/2))
{
holdtime_jitter=-holdtime_jitter;
}
}
//////////////////////////////////////////////////////////
if(EXPO_JITTER==1)
{
x_2=random(1000);
expo_2=(x_2/1000.0)+((x_2/1000.0*x_2/1000.0)/(2*1))+((x_2/1000.0*x_2/1000.0*x_2/1000.0)/(3*2*1))+((x_2/1000.0*x_2/1000.0*x_2/1000.0*x_2/1000.0)/(4*3*2*1))+((x_2/1000.0*x_2/1000.0*x_2/1000.0*x_2/1000.0*x_2/1000.0)/(5*4*3*2*1));
float_frac_hold_jitter=(frac_hold_jitter/1.0)*expo_2*2.0;
expo_jitter_target=float_frac_hold_jitter;			  


hold_target_time=holdtime + expo_jitter_target;

}
if(FIXED_JITTER==1)
{
hold_target_time=holdtime + holdtime_jitter;
}


//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
if(frac_stop_t_jitter==0)
{
stop_fix_t_jitter=0;
}
if(frac_stop_t_jitter>0)
{
stop_fix_t_jitter=random(stop_fix_t/frac_stop_t_jitter);			///////////////// HOLDTIME 	on FIXATION AFTER NOGO TRIAL
if(stop_fix_t_jitter<(stop_fix_t/(frac_stop_t_jitter)/2))
{
stop_fix_t_jitter=-stop_fix_t_jitter;
}
}
///////////////////////////////////////////////////////////
if(EXPO_JITTER==1)
{

x_3=random(1000);

expo_3=(x_3/1000.0)+((x_3/1000.0*x_3/1000.0)/(2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0)/(3*2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0)/(4*3*2*1))+((x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0*x_3/1000.0)/(5*4*3*2*1));
float_frac_stop_jitter=(frac_stop_t_jitter/1.0)*expo_3*2.0;
expo_jitter_stop=float_frac_stop_jitter;			  


stop_fix_time= stop_fix_t + expo_jitter_stop; 
}
if(FIXED_JITTER==1)
{
stop_fix_time= stop_fix_t + stop_fix_t_jitter; 
}


///////////////////////////////////////////////////////////
	 
	spawn ANIMATION;
  /*
   	if(DEBUG==1 || AUTOMONKEY==1)
	{
    dsend("os 1");                       // Show "eye" sprite
	}
   */    
   // FIXATION ON  
    dsendf("co 15;");											 // 15 = white.
    dsend("xm fix(Fix_H_p, Fix_V_p, 7)");	
    eventCode=2301;			   
    spawn queueEvent(); 
    // SEND TARGET MARKER
   dsend("xm targmarker(-615,485,0)"); //dsend("xm targmarker(-640,510,0)");
    
	
    event_set(1,0,2301);									 // Event Code for Tempo data base.
    nexttick;
        
 
 	wait(hold_fixation_time);							 			 // Wait a fix_t + random amount of time.
	dsendf("co 0;");
	dsend("xm fix(Fix_H_p, Fix_V_p, 0)");

 
    // FIXATION OFF  
    eventCode=2300;			   
    spawn queueEvent(); 
   	event_set(1,0,2300);									 // Event Code for Tempo data base.
    nexttick;
   	//wait(GO_DELAY)                                        /// 0 in countermanding

   // dsendf("co col_tar;");
   //	dsend("xm target(TarH, TarV, col_tar)");
 	
   //	dsendf("co 15;");
   // dsend("xm targmarker(-640,510,0)");
   //  trigger 1;	
      

   // NOT REALLY USED... COULD BE COMPARED with TARGET_ON of photodiode response
   //  eventCode=2651;
   //  spawn queueEvent();
	
   //	event_set(1,0,2651);									 // Event Code for Tempo data base.
   // nexttick;
  	IF(failed>0)
	{
    dsend("cl");
  	printf("         \n");
    printf("         \n");
	printf("         \n");
   
   	}
	 
	 //spawn MARKER;  												 // Tells the photodiode on the screen to look for light to indicate presentation of target.
   	
   																	    
if(types[j] == 2)
	{
		
			 /// increment the number of Stop tRials not very usefull but Erik is interested by this variable
	   
	    if(Stimu[s]==1 || Stimu[s]==2 || Stimu[s]==3)
		  { 
		   //	 wait(stop[s]);
			 
			 
			 if(Stimu[s]==2 || Stimu[s]==3)
			 {
			 SSD_array[Stop[s]]= SSD_array[Stop[s]]+1;
			 if(SOUND_S==0)
			 {
			// dsendf("co 15;");			   // then present the fixation spot again.
		    // dsend("xm fix(0,0,15)");		
			// dsendf("co 15;");
             dsend("xm targmarker(-640,510,0)");
			 }
			 if(SOUND_S==1)
			 {
			 spawn ACCOUSTIC_STOP();
			 }

		   //  eventCode=2653;
           //  spawn queueEvent();
	       //  event_set(1,0,2653);									 // Event Code for Tempo data base.
           //  nexttick;
  		   //	 spawn MARKER_2;
			 }
			   			 
		  	 		        	
           }	 /// end loop Stim[]


	  
     } /// end of loop types[]=2 NOGO TRial
	
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
 //	oSetAttribute(oB1, aINVISIBLE);             				 
 //   oSetAttribute(oB1x, aINVISIBLE);               				 
	
	 
	oDestroy(oF1);					 							 // Destroy objects in the previous trial.
 //	oDestroy(oB1);					 
 //   oDestroy(oB1x);
  }

	oSetGraph(gLeft, aCLEAR);									 // Clear graph.

  //  oB1 = oCreate(tBOX, gLeft, Targ_H, Targ_V);  			 // Create TARGET object
  //	oB1x = oCreate(tCross, gLeft, 60, 60);						 // a + cross for target 

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
		 trial_start=0;

		 while(READY_S<1)
		 {
		 wait(nASETS);
		 nexttick;
		 }


// Changed the numbers of calib_pos to reflect ordering of EyeLink calibration points
if (calib_pos==6)
    {
    Fix_H_p= (cos(135)*304)*screen_scale;   
	Fix_V_p = (-sin(135)*304)*screen_scale;
	}
if (calib_pos==2)
    {
    // MODIFIED 02/21/07 EEE
	//		DECREASED THE ECCENTRICITY OF THE FIXATION STIM TO ~10 DEG 
    //Fix_H_p= cos(90)*350; 
	//Fix_V_p = -sin(90)*350;
	Fix_H_p= (cos(90)*215)*screen_scale;       
	Fix_V_p = (-sin(90)*215)*screen_scale;
	}
if (calib_pos==7)
    {
	// MODIFIED 02/21/07 EEE
	//		DECREASED THE ECCENTRICITY OF THE FIXATION STIM TO ~10 DEG
    //Fix_H_p= cos(45)*495;   
	//Fix_V_p = -sin(45)*495;
	Fix_H_p= (cos(45)*304)*screen_scale;   
	Fix_V_p = (-sin(45)*304)*screen_scale;
	}

if (calib_pos==4)
    {
    Fix_H_p= (cos(180)*215)*screen_scale;   
	Fix_V_p = (-sin(1800)*215)*screen_scale;	
	}

if (calib_pos==1)
    {
    Fix_H_p= (cos(0)*0)*screen_scale;   
	Fix_V_p = (-sin(0)*0)*screen_scale;
	}

if (calib_pos==5)
    {
    Fix_H_p= (cos(0)*215)*screen_scale;   
	Fix_V_p = (-sin(0)*215)*screen_scale;
	}

if (calib_pos==8)
    {
    Fix_H_p= (cos(225)*304)*screen_scale;   
	Fix_V_p = (-sin(225)*304)*screen_scale;
	}

if (calib_pos==3)
    {
    Fix_H_p= (cos(270)*215)*screen_scale;   
	Fix_V_p = (-sin(270)*215)*screen_scale;
	}
 
if (calib_pos==9)
    {		
    Fix_H_p= (cos(315)*304)*screen_scale;   
	Fix_V_p = (-sin(315)*304)*screen_scale;
	}

	
	 
	dsend("sv Fix_H_p= ", Fix_H_p);		 // Assign var 'TarH' into vdosync var 'TarH'.
	dsend("sv Fix_V_p= ", Fix_V_p);

	// Beginning of the Trial BOB  
 	eventCode=1666;			   
 	spawn queueEvent();	
 		
    event_set(1,0,1666);										 // Tell the event channel that a trial began.
    nexttick;

	   	

	   	if (AUTOMONKEY)
            {
           // waitAutoMonkey = 100 + random(100);
            printf("Automonkey will press bar in %d ms\n", waitAutoMonkey);
            wait waitAutoMonkey;
            system("cls");
            while (system()) nexttick;  // Wait for CLS to complete
			In_Fixation_Window=1;
			spawn START_SOUND;	
			TrialCount = TrialCount + 1;
			printf("Starting Trial %d\n", TrialCount);
			printf("Trial [count] %d\n", i);

			spawn TRIAL;										 // Spawn the current trial.
			waitforprocess TRIAL;


            }
        /*else if (DEBUG)
            {
           print("Waiting for left mouse button...");
            while (!(mouGetButtons() & 0x1))
                nexttick;               // Wait for left button down
           }
	   		 */
		  else 
		  {			
	   	spawn INIT_FIXATION_CHECK;								 // Is eye near fixation?
	    waitforprocess INIT_FIXATION_CHECK;                 
	   		   
	   		   
	   		   
		if (In_Fixation_Window == 1 && In_init_fixation_window == 1)
		{			   
			

			// FIXATE
            eventCode=2660;
            spawn queueEvent();

			event_set(1,0,2660);									 // Event Code for Tempo data base.
            nexttick;
  											  		
			print("Monkey is Fixating.......");

			if(SOUND_FLAG==1)
			{
			spawn START_SOUND;
			}
						
			TrialCount = TrialCount + 1;
		  //	printf("Trial Number: %d\n", TrialCount);
	   		//printf("TOTAL Trials = %d\n", nTrials);
          //  printf("Block Number: %d\n", Block);

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
        spawn EXTRA_REWARD;
	    waitforprocess EXTRA_REWARD;
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
  
   declare stop_trial_loop;
   											 // Trigger databases with Tag 1.
		  
	trigger 1;			 // Trigger databases with Tag 1.

 	stop_trial_loop=0;
 	step_wind=0;
    step_targ=0;
    step_lat=0;

 	          
    spawn STIM;
	waitforprocess STIM;
	spawn DRAW_STIM;
   	spawn WATCH_TIME;

    
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
	   //	printf("Accuracy: %d, %d, %6.3d %%\n", SuccessCount, TrialCount, (SuccessCount/TrialCount)*100); 
		correctmarker = 0;

	   /// Faillure the monkey does not fixate long enough
	   eventCode=2750;			   
       spawn queueEvent();	
	   event_set(1,0,2750);									 // Event Code for Tempo data base.
       nexttick;
	
	   
	   	spawn WRONG;
		waitforprocess WRONG;
	}
	
 
	
	// Stage 2: Did the monkey fixate the target?

if(!failed)
	{
        trial_start=1;
        
        
        
        if(types[j] == 1 || Stimu[s]==1)										 // If a no-stop trial...
		{
	        	       	        
	   						       
	       
	       
	    end_fix_targ_maxT = time() + (fix_targ_maxT);			 // Fix_targ_maxT == 400.
        	
		while(!In_Target && time() < end_fix_targ_maxT)				 	 // Wait for subject to saccade to target.
			 nexttick;	
				 
				       		
			
			if(In_Target)										 // If the subject saccaded to the target on time.
			{
				  
		 //       printf("Correct saccade trial\n"); 		 // Latency=current time- end of fixation square.
							   
			   		  
			   /// Correct saccade the monkey makes a sacade in a GO trial
	           eventCode=2751;			   
               spawn queueEvent();	
			   
			   event_set(1,0,2751);									 // Event Code for Tempo data base.
               nexttick;
	
				end = time() + hold_target_time;       					 // Holdtime = 400 ms 
				while(time() < end && In_Target)			 	 // Wait for subject to hold target.				
					nexttick;
		    }
			else if(!In_Target)									 // Else if they didn't saccade to target on time...
			{
				failed = ERR_TAR_TOOLATE;
		   //		print("Failed to saccade to target on time!\n");
		   //		printf("Accuracy: %d, %d, %6.3d %%\n", SuccessCount, TrialCount, (SuccessCount/TrialCount)*100); 
				correctmarker=0;

				/// Failled to make a saccade on time in a GO trial
	           eventCode=2752;			   
               spawn queueEvent();	
			   
			   event_set(1,0,2752);									 // Event Code for Tempo data base.
               nexttick;
	
				spawn WRONG;
				waitforprocess WRONG;
			}

		 	 
			
		}
																 
		else if(In_Fixation_Window && types[j] == 2)			 // Else if this is a stop trial...
		{
           
		  if(Stimu[s]==2 || Stimu[s]==3)
			 {
		
		
			  stop_signal_startT = time() + 0;					    // Find out how long to wait...

						
			//stop_signal_startT = time() + stop[s];					    // Find out how long to wait...

        	
			while(time() < stop_signal_startT && In_Fixation_Window) // And make sure that they fixate for that amount of time.
				nexttick;

			if(!In_Fixation_Window && time() < stop_signal_startT)	 // If they didn't fixate for that long, stop trial.
			{
				failed = ERR_NOFIX_STOPTRIAL;
			 //	print("Made a saccade in a stop signal trial!\n");
				correctmarker=0;


			  /// ERROR The monkey made a saccade in a NOGO trial
	           eventCode=2753;			   
               spawn queueEvent();	
			   
			   event_set(1,0,2753);									 // Event Code for Tempo data base.
               nexttick;

	   	    	signal_respond_marker = 1;
				
				if(feedback==1) /////////////////////////// feedback turn off the target if the monkey makes a saccade in nogo trials
				{
				 dsendf("co col_tar;");
	             dsend("xm target(TarH, TarV, col_tar)");
 	             dsendf("co 15;");                              ////////////////////turnoff the target
				}


				spawn WRONG;
				waitforprocess WRONG;
				
		  			 
			}
			
			else if(In_Fixation_Window)							 // But if they did fixate for that long...
			{
			  
			  end = time() + 0;       					 // Holdtime = 400 ms 

			  //	end = time() + stop_fix_time;       					 // Holdtime = 400 ms 
				while(time() < end && In_Fixation_Window)		 // Wait for subject to hold fixation.
					nexttick;
			}
		
		  }
		}

        if (!In_Target && time() < end)    						 // Did subject hold target? - no.
        {														 // Process WATCHEYE will set In_Target = 1 if types = 2 and eye is in fixation.									 
            failed = ERR_NO_HOLDTAR;          
           // printf("Error: unable to hold for: %d ms...\n", holdtime);
		   //	printf("Accuracy: %d, %d, %6.3d %%\n", SuccessCount, TrialCount, (SuccessCount/TrialCount)*100); 
			correctmarker=0;


			 /// ERROR The monkey made a saccade in a GO trial But was unabled to Hold the TARGET
	         eventCode=2754;			   
             spawn queueEvent();	

			event_set(1,0,2754);									 // Event Code for Tempo data base.
            nexttick;

			spawn WRONG;
			waitforprocess WRONG;
			

        }

	}
   
   

    if (!failed)                        						 // Was the trial successful?
		
    {
				 ////////////////////////////
		SuccessCount = SuccessCount + 1;						 // Count successes.
		correctmarker = 1;
		   

		if(types[j] == 1)
		{
	        NoStopCounter = NoStopCounter + 1;
			NoStopSuccessCounter = NoStopSuccessCounter + 1;
		
	   		}
		else if (types[j] == 2)
		{
         	if(Stimu[s]==2 || Stimu[s]==3)
			{
         	StopCounter = StopCounter + 1;
		 	StopSuccessCounter = StopSuccessCounter + 1;  		  	
		  			
		 	STOP_success[Stop[s]]=STOP_success[Stop[s]]+1;
		 
		 	inhib_fct[Stop[s]]=100-(STOP_success[Stop[s]]*100/SSD_array[Stop[s]]);
 			 }
		 }

		print("Successful Fixation");
		
		dsend("cl");
      			
		  
		spawn SUCCESS;
		waitforprocess SUCCESS;
	   
       }

spawn CLEAR();
}

process ACCOUSTIC_STOP()
{
sound(500);
wait(160);
sound(0);
}

///////////////////////////////////////////////////////////////////////////////////////////
// Process START_SOUND																	 //
// This process creates a sound in the testing room indicating the beginning of a trial. //
// It is spawned by process TRIAL_LOOP.													 //
///////////////////////////////////////////////////////////////////////////////////////////

process START_SOUND()
{
     /// debugging 		 	    
   	if (types[j] == 1)
		{
		sound(300);
		wait 200;
		sound(0);
		}
		else if (types[j] == 2)
		{
		sound (1000);
		wait 200;
		sound(0);
		}
        
    mio_fout(6000);												 // Speakers in testing room.
	//sound(300);
   wait 200;                									 // Wait a period of time (ms).
  	mio_fout(0);
   //	sound(0);
}

///////////////////////////////////////////////////////////////////////////
// Process WRONG														 //
// This process is spawned by process TRIAL when the trial is a failure. //
///////////////////////////////////////////////////////////////////////////

process WRONG()
{
 // ERROR in the current trial  
  

 eventCode=2620;			   	  // WRONG 
 spawn queueEvent();	

 event_set(1,0,2620);									 // Event Code for Tempo data base.
 nexttick;
 
if (staircase==1 && types[j] == 2)
   {
  //Stair Case procedure
  stop[s+1] = stop[s]-SSD_Step;
  spawn END_TRIAL;
  waitforprocess END_TRIAL;

   }
   

if (signal_respond_marker == 1)
		
	{	

	wait(signal_respond_punishT);
	spawn END_TRIAL;
	waitforprocess END_TRIAL;
   	}
else
{


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
/*
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
 */
 eventCode=2600;	   //// CORRECT_TRIAL
 spawn queueEvent();	
 
 event_set(1,0,2600);									 // Event Code for Tempo data base.
 nexttick;
  /*	
  if(types[j] == 2)
  {
  printf("P(Non-Canceled) for SSD(%dms)=%d %%\n", Stop[s],inhib_fct[Stop[s]]); 
  }  	   

	*/


    if(types[j] == 1)
         {

	 /// CORRECT GO Trial the monkey made a saccade and was abled to Hold the TARGET
	eventCode=2755;			   
	spawn queueEvent();	

	event_set(1,0,2755);									 // Event Code for Tempo data base.
	nexttick;
        }
	
	
   if (types[j] == 2)
   {
    /// CORRECT NOGO Trial the monkey did not make a saccade and was abled to Hold the Fixation point
    eventCode=2756;			   
    spawn queueEvent();   
    event_set(1,0,2756);									 // Event Code for Tempo data base.
    nexttick;
    }		

 
  rand_reward=random(100);
if(rand_reward <= REWARD_RATIO) 
 {

 if(SOUND_REWARD==0)   
   {
   
    if(random(100) > frac_no_reward) 
    {
    spawn REWARD;
	//waitforprocess REWARD;
	}
	if(Bell==1)
	{
	spawn SOUND_ON_REWARD;
	//waitforprocess SOUND_ON_REWARD;
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
   //	printf("         \n");
   //	printf("         \n");
  	READY_S=1;

}

process CLEAR_B()														 
{
   //	declare time1, time2;
	
   //	time1 = time();
  	dsend("cl");
   //	time2 = time()-time1;
   //	printf("         \n");
   //	printf("         \n");
   //	printf("         \n");

  
}

///////////////////////////////////////////////////////////////
// Process REWARD											  //
// This process gives juice and a reward sound to the monkey. //
// It is spawned by process SUCCESS.						  //
////////////////////////////////////////////////////////////////

process REWARD()
{
   
   
 
   // Correct_ the monkey received Juice reward
    eventCode=2727;			   
    spawn queueEvent();	
  //7 Size of the reward    
    eventCode=REWARD_SIZE;			   
    spawn queueEvent();	
  									   // Turn on TTL to juice solenoid 
   event_set(1,0,2727);									 // Event Code for Tempo data base.
   nexttick;
   event_set(1,0,REWARD_SIZE);									 // Event Code for Tempo data base.
   nexttick;
	  

   	     
   			 // Turn off TTL to juice solenoid 
   	     
   mio_dig_set(9,1);
   


  wait(REWARD_SIZE);
 	   
   mio_dig_set(9,0);
                                                                                                                                                                            
 
     
                     						 // Turn off TTL to juice solenoid 
                                   	
   nexttick;  
  		
	 
}

///////////////////////////////////////////////////////////////////////////////////////////
//   Process EXTRA_REWARD																 //
// ///////////////////////////////////////////////////////////////////////////////////////////


process EXTRA_REWARD()
{
     
    eventCode=2777;			   
    spawn queueEvent();	
    //7 Size of the reward    
    eventCode=REWARD_SIZE;			   
    spawn queueEvent();	
  									   // Turn on TTL to juice solenoid 
    event_set(1,0,2777);									 // Event Code for Tempo data base.
    nexttick;
	event_set(1,0,REWARD_SIZE);									 // Event Code for Tempo data base.
    nexttick;
 
	
    if(Bell==1)
	{
	spawn SOUND_ON_REWARD;
	//waitforprocess SOUND_ON_REWARD;
	}
	

  			 // Turn off TTL to juice solenoid 
   	     
   mio_dig_set(9,1);
  
  wait(REWARD_SIZE);
 	   
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
      
    	wait(100);                									 // Wait a period of time (ms).
   	mio_fout(0);
   
}




////////////////////////////////////////////////////////////////////////////////
// Process END_TRIAL														  //
// This process registers the end of a trial. 								  //
// It is spawned by processes WRONG and SUCCESS.							  //
////////////////////////////////////////////////////////////////////////////////		 	

process END_TRIAL()
{



 
event_set(1,0,1667);										 // Tell the event channel that a trial began.
nexttick;


if(types[j]==2 && Stimu[s]==1)
{
ISNOT_NOGO=1; //// just used for the write parameter
}


 // END of the Trial EOB  
 eventCode=1667;			   
 spawn queueEvent();

spawn WRITE_PARAMS;
waitforprocess WRITE_PARAMS;


ISNOT_NOGO=0; ///// reset the current value not very elegant but....


if (types[j] == 2)
{
 s = s + 1;
  
   if (s>nSTop-1) 
   {
    s=0;
    }
}

j = j + 1;
if (j>nTrials-1)
{
j=0;
}

i = i + 1;
if (i>nTrials-1)
{ 
i=0;
Block=Block+1;

spawn SHUFFLE;												 // Shuffle all the trial types.
waitforprocess SHUFFLE;
nexttick;
signal_respond_marker = 0;
}

  
}



///////////////////////////////////////////////////////////////////////////////////////////
// Process REWARD_SOUND																	 //
// This process creates a sound in the testing room indicating a successful trial. 		 //
// It is spawned by process REWARD.													     //
///////////////////////////////////////////////////////////////////////////////////////////

process REWARD_SOUND()
{
    mio_fout(6000);											 // Speakers in testing room.
    //sound(300);
   	wait(REWARD_SIZE);
   // sound(0);              									 // Wait a period of time (ms).
	mio_fout(0);
}



//////////////////////////////////////////////////////////////////////////////////
// Process INCRI_TARG															//
// This process  clears the screen and moves on to the next EyeLink				//
// calibration target position.  It is called by key macros to minimize user 	//
// eye and hand movements during calibration.									//
//////////////////////////////////////////////////////////////////////////////////
process INCRI_TARG()
{
	dsend("cl"); //Clear the screen since residuals sometimes remain.
	calib_pos = calib_pos + 1;  //Incriment the target postition by 1.
	if(calib_pos > 9)			//If we went out of bounds...
	{
		calib_pos = 1;			//...wrap around.
	}
	
}

//////////////////////////////////////////////////////////////////////////////////
// Process DECRI_TARG															//
// This process clears the screen and moves on to the previoious EyeLink		//
// calibration target position.  It is called by key macros to minimize user 	//
// eye and hand movements during calibration.									//
//////////////////////////////////////////////////////////////////////////////////
process DECRI_TARG()
{
	dsend("cl"); //Clear the screen since residuals sometimes remain.
	calib_pos = calib_pos - 1;  //Decriment the target postition by 1.
	if(calib_pos < 1)			//If we went out of bounds...
	{
		calib_pos = 9;			//...wrap around.
	}
	
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

	 
 	    printf("TargH: %d\n", TarH);

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
 event_set(1,0,ISNOT_NOGO);
 nexttick;
     
//5 Empty


 //6 Flag wether trigger is changed of color or not (0 = no by default) 

 event_set(1,0,2726);
 nexttick;
 event_set(1,0,TRIG_CHANGE);
 nexttick;

 //8 Fraction of rewarded trial 

 event_set(1,0,2728);
 nexttick;
 event_set(1,0,REWARD_RATIO);
 nexttick;

		  
 //9 fraction of NoGO trial  1/NOGO_RATIO = ratio of nogo e.g NOGO_RATIO=3 0.33 of STOP Trials

 event_set(1,0,2729);
 nexttick;
 event_set(1,0,NOGO_RATIO);
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
 event_set(1,0,holdtime);
 nexttick;
		 
 //15 Hold time Jitter % of the total holdtime  

 event_set(1,0,2735);
 nexttick;
 event_set(1,0,Frac_hold_jitter);
 nexttick;


 // 16 empty


 //17 SOA of the current trial SSD 

 event_set(1,0,2737);
 nexttick;
 event_set(1,0,stop[s]);
 nexttick;
	 		  
 //18 Maximum SOA between the GO and NOGO cue 

 event_set(1,0,2738);
 nexttick;
 event_set(1,0,SSD_max);
 nexttick;

 
 //19 Minimum SOA between the GO and NOGO cue 

 event_set(1,0,2739);
 nexttick;
 event_set(1,0,SSD_min);
 nexttick;

	
 //20 SOA intervalls

 event_set(1,0,2740);
 nexttick;
 event_set(1,0,SSD_Step);
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


  // End of write parameters (TEMPO)

 

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
        
        	if (ctable_set(5,index,0))          				 // If (Counter5[index] != 0) ...
            {       
                                    					 // ..(also sets Counter5[index]=0)
            	if (!MarkerOn)                  				 // Has event code already been set?
                {                           					 // No,

		 		  
         // VARIABLE USED...for TARGET_ON COULD BE COMPARED with TARGET_PRE 
             eventCode=2650;				   ///// event code target on
             spawn queueEvent();
        		 //////////////////// Event create for neuro explorer  not used in the matlab code
		         //1 NPOS Number of stimulus position 
                 eventCode=2800+trials[i];				   
                 spawn queueEvent();	
						  
						  event_set(1,0,2650);									 // Event Code for Tempo data base.
                          nexttick;			   

                  //	event_set(1,0,EV_TAR_ON); 					 // Set EventChannel1[0] = EV_TAR_ON.
                	MarkerOn = 1;               				 // Note that we've set the event code
                	TEST_VIDEO=1;
                }
            }
	        index = index + 1;                  				 // Advance to next element in Counter5[]
        }
    	// The LSD did not generate a pulse.  Wait one process cycle
    	// and continue looking for it.
    	nexttick;
    }
   dsendf("co 0;");
   dsend("xm targmarker(-640,510,0)");
  
	// We detected an LSD pulse.  Exit this processs.
}





process MARKER_2()
{
    int MarkerOn;           									 // 0=we haven't yet seen a pulse, 1=we've seen a pulse
    int index;              									 // Indexes through all ASETS samples of a channel
	int nAsets=4;
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
        
        	if (ctable_set(5,index,0))          				 // If (Counter5[index] != 0) ...
            {       
                                    					 // ..(also sets Counter5[index]=0)
            	if (!MarkerOn)                  				 // Has event code already been set?
                {                           					 // No,

				  
         // VARIABLE USED...for TARGET_ON COULD BE COMPARED with TARGET_PRE 
           eventCode=2654;	//////// event code stop on
           spawn queueEvent();
		      	
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
   dsendf("co 0;");
   dsend("xm targmarker(-640,510,0)");
 // We detected an LSD pulse.  Exit this processs.
   
nexttick;
  /*nexttick;
	nexttick;
      nexttick;
       nexttick;
	*/
  	 
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
///
///							  PROCESS SHUFFLE
///
///////////////////////////////////////////////////////////////////////////////////////////////////////// 
process SHUFFLE()
{
   	
   	print("-------------------------------------------\n");
	print("################ SHUFFLING! #############\n");
	print("-------------------------------------------\n");
	print("-------------------------------------------\n");
	print(".............");

     	/// Task_type here Countermanding
    
    
    
    eventCode=1504;					   
    spawn queueEvent();	

    event_set(1,0,1504);									 // Event Code for Tempo data base.
    nexttick;


	spawn INIT_TRIAL_ARRAY(npos,nTrials);	     	 // Assign %50 of trials to display the target on one side of the axis.  
	waitforprocess INIT_TRIAL_ARRAY;							 // - to change this, you can either change the ratio here manually, or 
																 // create a macro in Tempo to do it.
	nexttick;

	spawn SHUFFLE_TRIAL_ARRAY(nTrials);              					 // Now shuffle it
	waitforprocess SHUFFLE_TRIAL_ARRAY;
	 
	i = 0;
	nexttick;
	print("........");

		  
	spawn INIT_TYPES(NOGO_RATIO,nTrials); 					 				 // Assign T1 out of nTypes to trial type1 (no Stop Signal) and T2-T1 out of nTypes to trial type2 (No Stop).
	waitforprocess INIT_TYPES;

	nexttick;

	spawn SHUFFLE_TYPES(nTypes);
	waitforprocess SHUFFLE_TYPES;
	
	print(".....");

	j = 0;
	nexttick;
	
	spawn INIT_STOP_ARRAY (nSSD, SSD_Step, SSD_min, nTrials);											 
	waitforprocess INIT_STOP_ARRAY;
    
    
	nexttick;
	
	spawn SHUFFLE_STOP_ARRAY(nStop);
	waitforprocess SHUFFLE_STOP_ARRAY;
	
	print("...");
	
	s = 0;
	
   	nexttick;

	
   	spawn INIT_STIM_ARRAY (nSSD, SSD_Step, SSD_min, nZAP_NOGO,nTrials);									 
    waitforprocess INIT_STIM_ARRAY;
	
	nexttick;
		 
	spawn SHUFFLE_STIM_ARRAY(nStop);
	waitforprocess SHUFFLE_STIM_ARRAY;
   
	nexttick;

    ///GLOBAL Variables

    i=0; /// trials location
	j=0; /// GO or NOGO
	s=0; /// SSD 
	
	READY_S=1;
	print(".");

 }

process CLEAN_UP()
{
	
    READY_S=0;
    
    spawn CLEAR;
	waitforprocess CLEAR;

	spawn END_TRIAL;
	waitforprocess END_TRIAL;

     
    
    	 
    dsend("cl");
	print("-------------------------------------------\n");
	print("-------------------------------------------\n");
	print("########### STOP THE CURRENT TRIAL ########\n");
	print("-------------------------------------------\n");
	print("################ RESHUFFLING! #############\n");
	print("-------------------------------------------\n");
	print("-------------------------------------------\n");
			 // Clear graph.
	
   	
   	if(TrialCount>1)
	{

   	oSetAttribute(oF1, aINVISIBLE);            				 	 // Make invisible.
   //	oSetAttribute(oB1, aINVISIBLE);             				 
   // oSetAttribute(oB1x, aINVISIBLE);               				 
	}
   	 
    	
   	oDestroy(oF);
    
   	oSetGraph(gLeft, aCLEAR);		

	
	
    spawn INITIALIZE;			 							 	 // Initialize animation and VideoSync objects.
   	waitforprocess INITIALIZE;
    
	if(TrialCount>1)
	{
    oDestroy(oF1);					 							 // Destroy objects in the previous trial.
   // oDestroy(oB1);					 
   // oDestroy(oB1x);
	}
   
    
	spawn SHUFFLE;												 // Shuffle all the trial types.
	waitforprocess SHUFFLE;
	
	
		
	//spawn WATCHEYE;			 								 	 // Monitor the eye coordinates.

	//spawn TRIAL_LOOP;		
}

process INIT_TRIAL_ARRAY(int npos, nTrials)					 // These nTypes are LOCAL variables - not the same as the var's for InitTypes.
{


int Pos;
int kpos;
int ipos; 
int jpos;
int pipo;

pipo=0;
while (pipo<200)
{
trials[pipo]=0;
pipo=pipo+1;

}


kpos=1;
nexttick;
ipos=0;

while (kpos <= npos)
    {		
  
  
//////////////////// Loop for the tfraction   
    if(kpos==1)
	{
Pos = nPOS_zero;
jpos = 1;	 
	 }
	else if(kpos>1)
	{
Pos = nPOS_others;
jpos = 1;
     }	

	
	while (jpos <= Pos)
	{
	  trials[ipos]=kpos;
	  jpos = jpos + 1;
	  ipos = ipos + 1;
	}
	kpos = kpos + 1;
 	
   }
 nexttick;
}
///////////////////////////////////////////////////////////////////////////////////
// Process ShuffleTrialArray()													 //
// Use TEMPO's uniform random number generator to randomize the Trials[] array.	 //
// We sequence through the entire Trials[] array.  For each element, we exchange //
// its value with the a randomly selected element.								 //
///////////////////////////////////////////////////////////////////////////////////

process SHUFFLE_TRIAL_ARRAY(int nTrials)
{
    int i;
    int r;
    int temp;
    
	i=0;
	while (i < nTrials)
    {
	    r = random(nTrials);                					 // Randomly select an element from the Trials[] array.
	    														 // 0 <= r < NTRIALS
    	temp = trials[i];										 // Exchange the value of the randomly selected element
		trials[i] = trials[r];								     // with the current element. 
	    trials[r] = temp;
        
    	i = i + 1;
		}
	nexttick;
}

process	INIT_TYPES(int NOGO_RATIO, nTrials)
{
	int j;
	int k;
    int Type_GO;
 	int Type_tot;
    int pipo;

pipo=0;
while (pipo<300)
{
types[pipo]=0;
pipo=pipo+1;

}
	
	
	j = 0;
	if(NOGO_RATIO<0)
	{
	Type_GO=nTrials;
	}
	else if(NOGO_RATIO>0)
	{
	Type_GO=(nTrials-((nTrials*abs(NOGO_RATIO))/100));	
	}
	Type_tot= nTrials;
	
	while (j < Type_GO)
    {
    	types[j] = 1;                      						 // Trial type 1
	    j = j + 1;
    }

	while (j < Type_tot)
    {
    	types[j] = 2;                      						 // Trial type 2
	    j = j + 1;
		
	       }
nexttick;
}

process SHUFFLE_TYPES(int nTypes)
{
    int j;
    int r;
    int temp;
    
  j=0;
	while (j < nTypes)
    {
    	r = random(nTypes); 					 				 // Randomly select an element from the Types[] array.
							               						 // 0<=r<NTRIALS
	    temp = types[j];										 // Exchange the value of the randomly selected element
		types[j] = types[r];									 // with the current element.
	    types[r] = temp;
        
    	j = j + 1;
	 nexttick;  
    }
   nexttick;
}

process	INIT_STOP_ARRAY (int nSSD, SSD_Step, SSD_min, nTrials)
{
  
    
	int j;
	int k;
	int Num_SSD;
    int pipo;

pipo=0;
while (pipo<500)
{
stop[pipo]=0;
pipo=pipo+1;
nexttick;
}
	
 	
	s = 0;	
    k = 0;
    Num_SSD=((nTrials*abs(NOGO_RATIO)/100)/nSSD);

while (k < nSSD)
  {		
  j = Num_SSD*k;
	while (j < Num_SSD*(k+1))
	{
	  stop[s]=SSD_min+(k*SSD_Step);
	  j = j + 1;
	  s = s + 1;
	 	}
	k = k + 1;
 	nexttick;
 	}
   nexttick;
}
	


process SHUFFLE_STOP_ARRAY(int nStop)
{
    int s;
    int r;
    int temp;
    
	s = 0;
	while (s < nStop)
    {
    	r = random(nStop); 					 				 // Randomly select an element from the Types[] array.
							               						 // 0<=r<NTRIALS
	    temp = stop[s];											 // Exchange the value of the randomly selected element
		stop[s] = stop[r];										 // with the current element.
	    stop[r] = temp;
        
    	s = s + 1;
	     nexttick;
	     }
	nexttick;
}	   




 ////////////////////////////////////////////////


process	INIT_STIM_ARRAY (int nSSD, SSD_Step, SSD_min, nZAP_NOGO,nTrials)
{
  
    
	int j;
	int k;
	int l;
	int pipo;

   pipo=0;

  while (pipo<300)
  {

  Stimu[pipo]=0;
  pipo=pipo+1;
 
  }
	


    k = 0;
   
while (k < nStop)
  {		
  
    if (k< nZAP_NOGO) //// Loop for NOGO ZAP Trials
     {	
	  if (k< nISNOTNOGO)  
	  {
	  Stimu[k]=1;
	 // printf("SHUFFLE ISNOTNOGO 3 %d \n", s); 		
	  }
	  else if (k>= nISNOTNOGO)  
	  {
	  Stimu[k]=2;
	 // printf("SHUFFLE ZAP_NOGO 2 %d \n", s); 		
	  }
	 }
	  
	 else if (k>=nZAP_NOGO)
	  {
	  Stimu[k]=3;
	 // printf("SHUFFLE ZAP_NOGO just NOGO 0 %d \n", s); 		
	  }

  k = k + 1;
   	
   }
   nexttick;
}
	


process SHUFFLE_STIM_ARRAY(int nStop)
{
    int i;
    int r;
    int temp;
    
	i=0;
	while (i < nStop)
    {
	    r = random(nStop);                					 // Randomly select an element from the Trials[] array.
	    														 // 0 <= r < NTRIALS
    	temp = Stimu[i];										 // Exchange the value of the randomly selected element
		Stimu[i] = Stimu[r];								     // with the current element. 
	    Stimu[r] = temp;
        
    	i = i + 1;
    }
	nexttick;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////                         END OF SHUFFLE                                /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 
///                                       PROCESS WATCH TIME
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


process WATCH_TIME()
{
   int time_start;

			  
   time_trials_start=time();


//                        Predictive time Marker
/* marker 1 */     time_target_on = time_trials_start + hold_fixation_time;
/* marker 2 */     time_stop_signal = time_target_on + Stop[s];
/* marker 3 */     time_reward = time_stop_signal	+ stop_fix_t;					//// 12/21 success for nogo trials


if(types[j]==2)
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if(Stimu[s]==1 || Stimu[s]==2)   
   {
   if(STIM_MARKER==1)
    { 
while (time() < time_target_on + STIM_OFFSET) 
	  nexttick;
        if(!failed)
          {
            spawn ELECT_STIM;
            print("Stimulation time 1");
           }
     }
 } 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

if(Stimu[s]==1 || Stimu[s]==2)   
{
  if(STIM_MARKER==2)
    { 
while (time() < time_stop_signal + STIM_OFFSET) 
	  nexttick;
        if(!failed)
          {
            spawn ELECT_STIM;
            print("Stimulation time 2");
          }
     }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if(Stimu[s]==1 || Stimu[s]==2)   
  {
if(STIM_MARKER==3) 
    { 		   
while (time() < time_reward + STIM_OFFSET)  
	  nexttick;
        if(!failed)
          {
            spawn ELECT_STIM;
            print("Stimulation time 3");
           }
     }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
} // end types[j]=2

}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 
///                                       PROCESS ELECTRIC STIM (send TTL to the pulsar)
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


process ELECT_STIM()
{
 
 eventCode=666;	//////// event code Stimulation on
 spawn queueEvent();
  mio_dig_set(8,0);
  wait(4);
  mio_dig_set(8,1);

 if(SOUND_FLAG==1)
 {
 sound(2000);
 wait(24);		 
 sound(0);
 }
 nexttick;

}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 
///                                       PROCESS INIT_FIXATION_CHECK
///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


process INIT_FIXATION_CHECK()
{
   
   
   if(TrialCount>0 && step<1)
	{

 //   oSetAttribute(oB1, aINVISIBLE);  
   	oSetGraph(gLeft, aCLEAR);		
	
 // 	oSetAttribute(oB1x, aINVISIBLE);  
	step=step+1;
	}

	end_initfix_minT = time() + initfix_minT;   	
	while (time() < end_initfix_minT)	
		nexttick;
	
	if (!In_Fixation_Window)         
	{ 
		failed = ERR_LEAVE_FIX;       
		in_init_fixation_window=fix_control;	 				 // If fix_control == 1, no init fixation needed
		
		if (fix_control == 0)
		{
			dsendf("co 0;");
	   		dsend("xm fix_init(Fix_H_p,Fix_V_p,3)"); 
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
	}
}

process INIT_FIX_CORRECTOR()
{
	 

	while(in_init_fixation_window == 0)
	{
		
		if (calib_pos==6)
    {
	// MODIFIED 02/21/07 EEE
	//		DECREASED THE ECCENTRICITY OF THE FIXATION STIM TO ~10 DEG 
    Fix_H_p= (cos(135)*304)*screen_scale;   
	Fix_V_p = (-sin(135)*304)*screen_scale;
	}
if (calib_pos==2)
    {
    Fix_H_p= (cos(90)*215)*screen_scale;   
	Fix_V_p = (-sin(90)*215)*screen_scale;
	}
if (calib_pos==7)
    {
    Fix_H_p= (cos(45)*304)*screen_scale;   
	Fix_V_p = (-sin(45)*304)*screen_scale;
	}

if (calib_pos==4)
    {
    Fix_H_p= (cos(180)*215)*screen_scale;   
	Fix_V_p = (-sin(1800)*215)*screen_scale;
	}

if (calib_pos==1)
    {
    Fix_H_p= (cos(0)*0)*screen_scale;   
	Fix_V_p = (-sin(0)*0)*screen_scale;
	}

if (calib_pos==5)
    {
    Fix_H_p= (cos(0)*215)*screen_scale;   
	Fix_V_p = (-sin(0)*215)*screen_scale;
	}

if (calib_pos==8)
    {
    Fix_H_p= (cos(225)*304)*screen_scale;   
	Fix_V_p = (-sin(225)*304)*screen_scale;
	}

if (calib_pos==3)
    {
    Fix_H_p= (cos(270)*215)*screen_scale;   
	Fix_V_p = (-sin(270)*215)*screen_scale;
	}
 
if (calib_pos==9)
    {		
    Fix_H_p= (cos(315)*304)*screen_scale;   
	Fix_V_p = (-sin(315)*304)*screen_scale;
	}

	
	 
	dsend("sv Fix_H_p= ", Fix_H_p);									 // Assign var 'TarH' into vdosync var 'TarH'.
	dsend("sv Fix_V_p= ", Fix_V_p);

		
		
		dsendf("co 7;");	  
		dsend("xm fix_init(Fix_H_p,Fix_V_p,3)"); 
		wait(1000);
	    nexttick;

		dsendf("co 0;");
	    dsend("xm fix_init(Fix_H_p,Fix_V_p,3)"); 
		wait(100);
		nexttick;
		
		spawn INIT_FIXATION_CHECK;
		
		wait(initfix_punishtime);   				
	}

	if(in_init_fixation_window==1)
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
           	   		
           spawn delay(200);
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