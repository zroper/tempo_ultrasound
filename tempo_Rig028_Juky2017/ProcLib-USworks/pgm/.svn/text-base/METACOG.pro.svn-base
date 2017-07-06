//----------------------------------------------------------------------------
// METACOG.pro



#pragma declare = 1                     // require declarations of all variables

declare IDLE();							// must be declared in top because it is called by other processes below

declare int state;						// The state global variable allows the control structure to run tasks...
										// ...depending on the current stystem state. The beginning state is idling.
declare int beginTaskFlag;				// Starts tasks after setting variables;
declare int allowTaskToBegin;
declare int setMonkey;
declare int monkey;	
declare int Pause;						// Gives user ability to pause task with a button press
declare int Last_task;					// Keeps track of the last task which was run to hold onto default variable values
declare int Event_fifo_N = 1000;		// Length of strobed event buffer
declare int Event_fifo[Event_fifo_N];	// Global first in first out buffer for event codes
declare int Set_event = 0;              // Current index of Event_fifo buffer to set


#include C:/TEMPO/ProcLib/PGM/RIGSETUP.pro  // declares a bunch of rig specific global variables
#include C:/TEMPO/ProcLib/PGM/EVENTDEF.pro	// event code definitions
#include C:/TEMPO/ProcLib/PGM/ALL_VARS.pro	// declares global variables needed to run protocols
#include C:/TEMPO/ProcLib/PGM/DEFAULT.pro	// sets all globals to their appropriate defaults for countermanding
#include C:/TEMPO/ProcLib/PGM/GOODVARS.pro	// do user defined variables make sense before starting the task?
#include C:/TEMPO/ProcLib/PGM/SET_CLRS.pro	// sets the stim colors up
#include C:/TEMPO/ProcLib/PGM/DIO.pro		// necessary for digital input output communication
#include C:/TEMPO/ProcLib/PGM/SET_COOR.pro  // set screen coordinates up and calculate some conversion factors
#include C:/TEMPO/ProcLib/PGM/GRAPHS.pro    // required when using object graphs in cmanding protocol (modified from object.pro to include graph setup)
// #include C:/TEMPO/ProcLib/PGM/SET_INH.pro	// sets up the inhibition function graph used in cmanding
#include C:/TEMPO/ProcLib/PGM/SET_PSY.pro	// sets up the psychometric function graph used in go/no-go
#include C:/TEMPO/ProcLib/PGM/JUICE.pro
#include C:/TEMPO/ProcLib/PGM/STIM.pro
#include C:/TEMPO/ProcLib/PGM/SETTRIAL.pro	// sets up all of the input to run a countermanding trial
#include C:/TEMPO/ProcLib/PGM/WINDOWS.pro	// sets fixation and target window targSize (these valeus are needed in WATCHEYE.pro)
#include C:/TEMPO/ProcLib/PGM/WATCHEYE.pro	// monitors eye position on each process cyle
#include C:/TEMPO/ProcLib/PGM/TONE.pro      // does simple frequency conversion and presents tone accordingly
#include C:/TEMPO/ProcLib/PGM/TONESWEP.pro	// a sweep through several tones for a sound which can be distinguished from pure tones
#include C:/TEMPO/ProcLib/PGM/WATCHMTH.pro	// monitors mouth movement on each process cycle
#include C:/TEMPO/ProcLib/PGM/WATCHBOD.pro	// monitors body movement on each process cycle
#include C:/TEMPO/ProcLib/PGM/SVR_BELL.pro	// sounds speaker on server
#include C:/TEMPO/ProcLib/PGM/SVR_BEL2.pro	// sounds speaker on server (different)
#include C:/TEMPO/ProcLib/PGM/DRW_SQR.pro	// simple process for drawing stim
#include C:/TEMPO/ProcLib/PGM/DRW_CHKR.pro	// process for drawing checkered discriminatory stimulus
#include C:/TEMPO/ProcLib/PGM/DRW_GNG.pro	// process for drawing checkered go/no-go discriminatory stimulus
#include C:/TEMPO/ProcLib/PGM/MSK_PGS.pro						// sets all pgs of video memory up for the impending trial
#include C:/TEMPO/ProcLib/PGM/BET_PGS.pro						// sets all pgs of video memory up for the impending trial
#include C:/TEMPO/ProcLib/PGM/MSKTRIAL.pro	// modified from CMDTRIAL, for go/no-go
#include C:/TEMPO/ProcLib/PGM/BETTRIAL.pro	// modified from CMDTRIAL, for go/no-go
#include C:/TEMPO/ProcLib/PGM/RETTRIAL.pro	// modified from CMDTRIAL, for go/no-go
#include C:/TEMPO/ProcLib/PGM/PROTRIAL.pro	// modified from CMDTRIAL, for go/no-go
// #include C:/TEMPO/ProcLib/PGM/UPD8_INH.pro	// updates inhibition function for cmanding
#include C:/TEMPO/ProcLib/PGM/UPD8_PSY.pro	// updates psychometric function for go/no-go
#include C:/TEMPO/ProcLib/PGM/INFOS.pro		// queue up all trial event codes for strobing to plexon
#include C:/TEMPO/ProcLib/PGM/REWARDS.pro	// ends a trial based on outcome
#include C:/TEMPO/ProcLib/PGM/KEY_REWD.pro	// needed to give reward manually from keyboard (stupid)
#include C:/TEMPO/ProcLib/PGM/KEY_TARG.pro	// see above
#include C:/TEMPO/ProcLib/PGM/KEY_MOVE.pro	// see above
#include C:/TEMPO/ProcLib/PGM/KEY_STIM.pro	// see above
#include C:/TEMPO/ProcLib/PGM/QUE_TTL.pro	// makes a ring buffer for sending TTL events






//----------------------------------------------------------------------
process IDLE() enabled				// When the clock is started the task is not yet running.
{									// At any time we can press a button to return to this...
									// ...idle loop.  It will make sure everything is off...
									// ...and all necessary variables are reset before...
									// ...starting the task over or starting a new task.
declare hide int off = 0;
declare hide int idling = 1;			// makes the while loop run
declare int i;

seed1(timeus());					// randomly seed the number generator
normal(1);							// call the normal distribution to replenish queue after seeding
				  
dioSetMode(0, PORTA|PORTB|PORTC); 	// set 1st three TTL lines to output					  
mio_dig_set(juiceChannel,off);		// make sure the juice line is closed
mio_fout(off);						// make sure the speaker is off
dsend("vi 256;");					// make sure vdosync is in correct config
dsend("ca");						// flush all vdosync memory
		
		
		
		
spawn SET_COOR();					// set up screen coordinates based on globals defined in RIGSETUP.pro	
			
spawn GRAPHS();						// this is currently countermanding specific and should be changed
	
spawn WATCHEYE();					// start monitoring eye position

spawn QUE_TTL();					// set up for plexon communication


printf("flushing video memory please wait...\n");
wait 5000; 							// it can take up to 5 seconds to clear all vdo sync memory (pg 7-37)
printf("done!\n");
system("dialog Choose_Task");		// Pop up choose task dialog
if (!setMonkey)
	{
	system("dialog Select_Monkey");
	}
		system("key curup = spawn KEY_REWD");		// define up key macro
		system("key pgup = spawn KEY_STIM");		// define page up key macro







	
while (idling)						// wait for the user to specify which task to run
	{
	beginTaskFlag = 0;				// after exiting a task (or before ever starting one for the session), reset (set) beginTaskFlag
	allowTaskToBegin = 0;			// ensures a task doesn't get spawned before re-setting stuff in "if (state != stateNoTask)" conditional
	




	
// --------------------------------------------------------------------------------
// If a task has been selected to run, do a few things common to all tasks before calling relevant task below
// --------------------------------------------------------------------------------
	if (state != stateNoTask)					// stop idling if a task is being run
		{
		idling = 0;					
		
		nTrial				= 1;			// initialize some counters
		nTrialComplete			= 0;
		Block_number			= 1;

								
	
		dsend("DM RFRSH");                			// This code sets up a vdosync macro definition to wait a specified ...
		if (Room == 23)                   			// ...number of vertical retraces based on the room in which we are    ...
			{                             			// ...recording.  This kluge is necessary because vdosync operates     ...
			dsendf("vw %d:\n",1);         			// ...differently in the different rooms.  In 028 a command to wait    ...
			}                             			// ...2 refresh cycles usually only waits for one and a command to     ...
		else                              			// ...wait for 1 usually only waits for 0.  Room 029 and 023 appear to ...
			{                             			// ...work properly.
			dsendf("vw %d:\n",2);
			}
		dsend("EM RFRSH");
		
		// if (setMonkey)
			// {
			// spawnwait DEFAULT();			// Set all globals to their default values based on the monkey.
			// }
	

		spawn WATCHMTH;								// start watching the mouth motion detector if present
		spawn WATCHBOD;								// start watching motion detector for body if present
		

		
		allowTaskToBegin = 1;
		nexttick 10;								// to prevent buffer overflows after task reentry.
		
		}
		
		
		

		


// --------------------------------------------------------------------------------
// REVERSE MASKING METACOGNITION SUITE
// --------------------------------------------------------------------------------
	if (state == stateMCM && allowTaskToBegin)		// metacog task
		{
		
		spawnwait DEFAULT();
		spawnwait GOODVARS();
		spawnwait SET_CLRS();

		
		nTrial				= 1;
		
		// Wait for user to specify when to start (by pressing Start button on task GUI)
		while (!beginTaskFlag)									
			{
			nexttick;
			}
		Event_fifo[Set_event] = MaskBetHeader_;			// Set a strobe to identify this file as a visually guided session and...	
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
		Event_fifo[Set_event] = Identify_Room_;		// Set a strobe to identify this file as a Cmanding session and...	
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
		Event_fifo[Set_event] = Room;				// Set a strobe to identify this file as a Cmanding session and...	
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
		
		while (State == stateMCM)				// while the user has not yet terminated the mem guided task
			{
			
			spawnwait 	SETTRIAL();		// see ALL_VARS.pro and DEFAULT.pro
			spawnwait 	WINDOWS();		// see ALL_VARS.pro and DEFAULT.pro	
			
			if (trialType == tMaskTrial)
				{
				spawnwait	MSK_PGS();
				spawnwait	MSKTRIAL();
				}
			else if (trialType == tBetTrial)
				{
				spawnwait	BET_PGS();
				spawnwait	BETTRIAL();
				}
			else if (trialType == tRetroTrial)
				{
				spawnwait	MSK_PGS();
				spawnwait	RETTRIAL();
				}
			else if (trialType == tProTrial)
				{
				spawnwait	MSK_PGS();
				spawnwait	PROTRIAL();
				}

			spawnwait 	REWARDS();			// end a trial with trialOutcome set in MEMTRIAL.pro
					
			lastMaskArray[targIndex] = lastOutcome;   // THIS NEEDS TO BE UPDATED BEFORE CALLING SETTRIAL, SINCE lastOutcome gets updated there based on the last outcome in a newly assigned discriminatory level
			nexttick;								// wait at least one cycle and do it all again
			
			while(Pause)							// gives the user the ability to pause the task without ending it
				{
				nexttick;
				}
			
			}
		}




				

		
	
	
	nexttick;						// if no task is specified idle for another process... 
									// ...cycle and then check again.
	}  // while (idling) loop
	oSetGraph(gleft,aCLEAR);					// clear the left graph
	oSetGraph(gright,aCLEAR);					// clear the right graph
	
	i = 1;
	while (i <= nObject)
		{
		oDestroy(i);
		i = i + 1;
		}
	idling = 1;
	spawn IDLE();  // kick it back to the top to reset stuff and start a new task

} // process



