//--------------------------------------------------------------------------------------------
// Run a fixation trial based on the variables calculated by SETF_TRL.pro and those 
// given by the user.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011


declare FIXTRIAL();			// animated graph object

process FIXTRIAL()			// animated graph object
{


// Number the trial stages to make them easier to read below
declare hide int 	need_fix  	= 1;
declare hide int 	fixating  	= 2;


// Number the stimuli pages to make reading easier
declare hide int   	blank       = 0;
declare hide int	fix      = 1;

										
// Timing variables which will be used to time task
declare hide float  fix_time; 					
declare hide float	aquire_fix_time;	

// These variables make the while loop work
declare hide int	stage;

	
// Have to be reset on every iteration since 
// variable declaration only occurs at load time
trl_running 		= 1;
stage 				= need_fix;




																		// HERE IS WHERE THE FUN BEGINS
dsendf("vp %d\n",fix);												// flip the pg to the fix stim 
fix_time = time();  													// record the time
oSetAttribute(object_fix, aVISIBLE); 									// turn on the fix in animated graph	

while (trl_running)														// trials ending will set trl_running = 0
	{	
	
//--------------------------------------------------------------------------------------------
// STAGE need_fix (the fix is on, but the subject hasn't looked at it)
	if (stage == need_fix)
		{		
		if (In_Fixwin)													// If the eyes have entered the fixation window (before time, see below)...
			{
			aquire_fix_time = time();									// ...function call to time to note current time and...
			stage = fixating;											// ...advance to the next stage.
			}
		else if (time() > fix_time + saccTimeMax)					// But if time runs out...
			{
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
			oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fix from animated graph...
			trl_running = 0;											// ...and terminate the trial.
			}			
		}
		
		

//--------------------------------------------------------------------------------------------
// STAGE fixating (the subject is looking at the fix waiting for reward)		
	else if (stage == fixating)
		{
		if (!In_Fixwin)												// If the eyes stray out of the fix window...
			{
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fix from animated graph...
			print("broke");
			trl_running = 0;											// ...and terminate the trial.
			}
		else if (In_Fixwin && time() > 
				aquire_fix_time + targHoldtime) 						// But if the eyes are still in the window at end of holdtime...
			{
			dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
			oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fix from animated graph...
			spawn TONE(success_Tone_medR,toneDuration);				// give the secondary reinforcer tone
			spawn JUICE(juiceChannel,baseRewardDuration);				// YEAH BABY!  THAT'S WHAT IT'S ALL ABOUT!
			trl_running = 0;											// ...and terminate the trial.
			
			}
		}
		
		
				
	nexttick;
	}		
}