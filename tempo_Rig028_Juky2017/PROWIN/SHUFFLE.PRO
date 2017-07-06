/*  .title  SHUFFLE.PRO - Example of Knuth's Shuffling Algorithm
;-
; SYNOPSIS
;   spawn Shuffle();
;
; DESCRIPTION
;   Demonstrates Donald Knuth's Shuffling algorithm.  Given an array of values
;   we randomize it.  The randomization is based on TEMPO's uniform random
;   number generator.
;
;   The array is initialized with values that are interpreted as trial types.
;   For example, suppose there are two types of trials, type 1 and type 2.
;   Suppose further that we want to present the subject with trial type 1
;   33% of the time and trial type 2 67% of the time.  We want to randomize
;   the presentation of trials with this proportion.  You can use this
;   algorithm to produce an array of 1s and 2s (in the correct proportion)
;   which are randomized.  You can then index through this randomized list
;   and present the trials to the subject.
;   
;   Note that this doesn't insure that you will get good trials in the
;   same proportion (33% type 1, 67% type 2).  The subject may find one
;   task (trial type) more difficult to perform.
;
;   If you want to obtain 33% good trials of type 1 and 67% good trials
;   of type 2, you can use the same randomized array.  As the subject
;   successfully performs a particular trial, you can set the array value
;   to 0.  If the subject fails a trial, let the trial type unchanged in
;   the array.  To determine the next trial type, scan through the array for
;   the next non-zero value.  When all values in the array are, you have
;   collected N good trials in the proper proportion.
;
;   This algorithm can be easily extended to handle more than two trial types.
;
;   Here, we essentially implement Knuth's "Algorithm P" (p125).
;
;   Because we can only perform a limited amount of computation per process
;   cycle, if NTRIALS gets large, we have to add NEXTTICKs to spread the
;   computation of multiple process cycles.  If we don't do this and the
;   computation takes too long to execute, TEMPO will suspend the process.
;   In general, it is not a problem to spread this computation of multiple
;   process cycles because this activity is generally done before the
;   trials start when timing is not critical.
;
; SEE ALSO
;   The Art of Computer Programming, Vol 2, Seminumerical Algorithms,
;   Donald Knuth, Addison-Wesely, 1969.  See "Random Sampling and Shuffling"
;   p121-125.  ISBN-0-201-03802-1.  There is also discussion of other
;   algorithms for random sampling with and without replacement.
;
;   Dr. Dobbs Journal, Jan 2000, p113 for a discussion of random sampling. 
;   
; EDIT HISTORY
;   03Nov02 sh    Initial edit
;+
*/
#pragma DECLARE=1                       // Force declarations

int constant NTRIALS = 20;              // Number of distinct trials
int Trials[NTRIALS];                    // Array of trial types for each trial

declare MAIN(), InitTrialArray(int nType1), ShuffleTrialArray();

//-----------------------------------------------------------------------------
// MAIN - Little test program

process MAIN() enabled
{
    int     i;
    
spawn InitTrialArray(NTRIALS / 3);      // 33% are trial type 1
waitforprocess InitTrialArray;          // Wait for it to complete

printf("Unshuffled:");
i = 0;
while (i < NTRIALS)
    {
    printf(" %d", Trials[i]);
    i = i + 1;
    }
printf("\n");

spawn ShuffleTrialArray();              // Now shuffle it
waitforprocess ShuffleTrialArray;

printf("  Shuffled:");
i = 0;
while (i < NTRIALS)
    {
    printf(" %d", Trials[i]);
    i = i + 1;
    }
printf("\n");
}

//-----------------------------------------------------------------------------
// InitTrialArray
// We load the trial types into the Trials[] array in the proportion that we
// want.  Here, nType1 (0<=nType1<=NTRIALS) is the number of trials of type 1.
// the remaining trials are type 2.

process InitTrialArray(int nType1)
{
    int         i;

if (nType1 > NTRIALS)                   // Make sure the caller didn't specify
    nType1 = NTRIALS;                   // ..something silly
else if (nType1 < 0)
    nType1 = 0;
    
i = 0;
while (i < nType1)
    {
    Trials[i] = 1;                      // Trial type 1
    i = i + 1;
    if ((i % 100) == 0) nexttick;       // We can only do so much in one process cycle
    }

while (i < NTRIALS)
    {
    Trials[i] = 2;                      // Trial type 2
    i = i + 1;
    if ((i % 100) == 0) nexttick;       // We can only do so much in one process cycle
    }
}


//-----------------------------------------------------------------------------
// ShuffleTrialArray()
// Use TEMPO's uniform random number generator to randomize the Trials[] array.
// We sequence through the entire Trials[] array.  For each element, we exchange
// its value with the a randomly selected element.

process ShuffleTrialArray()
{
    int     i;
    int     r;
    int     temp;
    
i = 0;
while (i < NTRIALS)
    {
    // Randomly select an element from the Trials[] array.
    
    r = random(NTRIALS);                // 0<=r<NTRIALS
    
    // Exchange the value of the randomly selected element
    // with the current element.
    
    temp = Trials[i];
    Trials[i] = Trials[r];
    Trials[r] = temp;
        
    i = i + 1;
    if ((i % 100) == 0) nexttick;       // We can only do so much in one process cycle
    }
}
