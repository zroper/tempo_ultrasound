#pragma declare = 1                     // require declarations of all variables

declare CHKRSTIM();	

declare int running = 1;
int stimPage = 0;
int changeStimulus = 1;
int State = 1;
int Monkey = 0;
int Room = 29;
int targIndex, targ1, targ2;

#include C:/TEMPO/ProcLib/pgm/RIGSETUP.pro  // declares a bunch of rig specific global variables
#include C:/TEMPO/ProcLib/pgm/EVENTDEF.pro	// event code definitions
#include C:/TEMPO/ProcLib/pgm/ALL_VARS.pro	// declares global variables needed to run protocols
#include C:/TEMPO/ProcLib/pgm/DEFAULT.pro	// sets all globals to their appropriate defaults for countermanding
#include C:/TEMPO/ProcLib/pgm/GOODVARS.pro	// do user defined variables make sense before starting the task?
#include C:/TEMPO/ProcLib/pgm/SET_CLRS.pro	// sets the stim colors up
#include C:/TEMPO/ProcLib/pgm/DIO.pro		// necessary for digital input output communication
#include C:/TEMPO/ProcLib/pgm/SET_COOR.pro  // set screen coordinates up and calculate some conversion factors
// #include C:/TEMPO/ProcLib/GRAPHS.pro    // required when using object graphs in cmanding protocol (modified from object.pro to include graph setup)
// #include C:/TEMPO/ProcLib/SET_INH.pro	// sets up the inhibition function graph used in cmanding
// // #include C:/TEMPO/ProcLib/WINDOWS.pro	// sets fixation and target window targSize (these valeus are needed in WATCHEYE.pro)
// #include C:/TEMPO/ProcLib/WATCHEYE.pro	// monitors eye position on each process cyle
// #include C:/TEMPO/ProcLib/TONE.pro      // does simple frequency conversion and presents tone accordingly
// #include C:/TEMPO/ProcLib/TONESWEP.pro	// a sweep through several tones for a sound which can be distinguished from pure tones
// #include C:/TEMPO/ProcLib/WATCHMTH.pro	// monitors mouth movement on each process cycle
// #include C:/TEMPO/ProcLib/WATCHBOD.pro	// monitors body movement on each process cycle
// #include C:/TEMPO/ProcLib/SVR_BELL.pro	// sounds speaker on server
// #include C:/TEMPO/ProcLib/SVR_BEL2.pro	// sounds speaker on server (different)
// #include C:/TEMPO/ProcLib/CMDTRIAL.pro	// runs a single countermanding trial based on input
// #include C:/TEMPO/ProcLib/CCMTRIAL.pro	// modified from CMDTRIAL, for choice countermanding
// #include C:/TEMPO/ProcLib/DRW_SQR.pro	// simple process for drawing stim
#include C:/TEMPO/ProcLib/pgm/DRW_CHKR.pro	// process for drawing checkered discriminatory stimulus
// #include C:/TEMPO/ProcLib/FIX_PGS.pro	// setup fixation stimuli
// #include C:/TEMPO/ProcLib/SETC_TRL.pro	// sets up all of the input to run a countermanding trial
// #include C:/TEMPO/ProcLib/SETM_TRL.pro	// sets up all input to run a mem guided trial
// #include C:/TEMPO/ProcLib/SETV_TRL.pro	// sets up all input to run a visually guided trial
// #include C:/TEMPO/ProcLib/SETA_TRL.pro	// sets up all input to run an amplitude trial
// #include C:/TEMPO/ProcLib/SETCCTRL.pro	// sets up all of the input to run a choice countermanding trial
// #include C:/TEMPO/ProcLib/MEMTRIAL.pro	// runs a single mem guided trial based on input
// #include C:/TEMPO/ProcLib/VISTRIAL.pro	// runs a single visually guided trial based on input
// #include C:/TEMPO/ProcLib/AMPTRIAL.pro	// runs a single amplitude trial based on input
// #include C:/TEMPO/ProcLib/UPD8_INH.pro	// updates inhibition function for cmanding
// #include C:/TEMPO/ProcLib/INFOS.pro		// queue up all trial event codes for strobing to plexon
// #include C:/TEMPO/ProcLib/END_TRL.pro	// ends a trial based on outcome
// #include C:/TEMPO/ProcLib/KEY_REWD.pro	// needed to give reward manually from keyboard (stupid)
// #include C:/TEMPO/ProcLib/KEY_TARG.pro	// see above
// #include C:/TEMPO/ProcLib/FIXATION.pro	// fixation control structure
// #include C:/TEMPO/ProcLib/CMANDING.pro	// countermanding control structure
// #include C:/TEMPO/ProcLib/MEMORY.pro	// mem guided sacc task control structure
// #include C:/TEMPO/ProcLib/VISGUIDE.pro	// visually guided sacc task control structure
// #include C:/TEMPO/ProcLib/AMPLTUDE.pro	// visually guided sacc task control structure
// #include C:/TEMPO/ProcLib/CHOICECM.pro	// choice countermanding task, modified from CMANDING
// #include C:/TEMPO/ProcLib/QUE_TTL.pro	// makes a ring buffer for sending TTL events


process CHKRSTIM() enabled					// When the clock is started the task is not yet running.
{

state = 4; // stateCCM, see ALL_VARS
		nCheckerColumn = 10;
		nCheckerRow = 10;
		nSquare = nCheckerColumn * nCheckerRow;

dsend("vi 256;");					// make sure vdosync is in correct config
dsend("ca");						// flush all vdosync memory
printf("flushing video memory please wait...\n");
wait 1000; 							// it can take up to 5 seconds to clear all vdo sync memory (pg 7-37)
dsend("DM RFRSH");                			// This code sets up a vdosync macro definition to wait a specified ...
	dsendf("vw %d:\n",2);
dsend("EM RFRSH");

spawn DEFAULT();	

spawn SET_COOR();				// set up screen coordinates based on globals defined in RIGSETUP.pro	

		iSquareSizePixels = 8;

while (running)
	{
	printf("what the hell\n");
	dsendf("rw %d,%d;\n",stimPage,stimPage);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_CHKR(changeStimulus);  														// draw checkered stimulus
	wait 1000;
	dsendf("vp %d\n",stimPage);							// ...flip the pg to the signal with the pd marker...
	wait 5000;
	dsendf("cl:\n");																			// clear screen
	}
dsend("ca");						// flush all vdosync memory

}

