// EVENT.PRO - Sample program to generate variable number of event codes
// 
// DESCRIPTION
//      This protocol demonstrates how you can produce a variable number
//      of event codes per process cycle and still store them into the
//      TEMPO event channels.

//      In each process cycle, for each event channel, there are ASETS
//      places to store event codes.  This example packes up to ASETS
//      event codes per process cycle into an event channel.  If there
//      are more than ASETS event codes emitted by the protocol in
//      a given process cycle, the remaining codes will be written out
//      in the next process cycle(s).
//
//      This sample handles any ASETS value.  The ECHANNELS constant
//      can be changed to accomodate any number of event channels.
//      The NCODES constant can be changed if you feel there is a
//      chance that you'll be writing more event codes per process
//      cycle.
//
//      The main protocol spawns EVENT_SAVE(eChannel, eCode) to "emit"
//      an event code.
//
//      For each event channel there is an array of event codes
//      waiting to be written out (eStream[eChan, *]).  The "put"
//      index indicates where the next event code will be saved
//      to the eStream[] array by EVENT_SAVE.
//
//      The EVENT_UPDATE process _must_ be the last process executed
//      in each process cycle.  (Actually, it just needs to execute
//      after any process that can call EVENT_SAVE.)  To do this, simply
//      position it as the last process in your main .PRO file (the
//      file you PLOAD).  For each event channel, EVENT_UPDATE uses
//      the "get" index to determine the next event code to write
//      to TEMPO's event stream (with etable_set function).
//
//      An event channel's array is "empty" when get == put. 
//      An event channel's array is "full" when (put+1)%NCODES == get.
//      This imples that up to NCODES-1 event codes can be stored
//      in a channel's outgoing event array (eStream[eChan, *]) at
//      one time.
//
// EDIT HISTORY
// 29Jan03  sh  initial edit, tested with ASETS=5, SPEED=1000.

#pragma declare=1                           // Force declarations
#include    TEMPO.PRO                       // Include GSI_definitions

//-------------------------------------------------------------------
// Declarations for management of event codes

int constant ECHANNELS = 2;                 // Number of event channels
int constant NCODES = 20;                   // Array holds 20 codes per channel
int eStream[ECHANNELS, NCODES];             // Temporary holding area for eCodes
int ePut[ECHANNELS];                        // "put" index
int eGet[ECHANNELS];                        // "get" index

declare EVENT_SAVE(int eChannel, int eCode);
declare EVENT_UPDATE();
declare MAIN();

//-------------------------------------------------------------------
process MAIN enabled                        // Test program for EVENT_SET/UPDATE
{
    int     i, n;
    
while (1)
    {
    n = random(10) + 1;                     // =1..10
    i = 0;
    while (i < n)
        {
        spawn EVENT_SAVE(n % ECHANNELS + 1, n);
        i = i + 1;
        }
    wait    random(1000) + 1000;
    }
}

//-------------------------------------------------------------------
// Process EVENT_SAVE - Write out an event code to a particular event channel
// The eCode is written to the eStream[eChannel] at the next ePut location
// provided (ePut + 1) % NCODES != eGet (i.e., array is full).
// This means that we can store NCODES-1 event codes into the each channel array.
// No error checking is one on eChannel; it must be in the range [1..ECHANNELS]
//
// IN
//      eChannel            an event channel [1..ECHANNELS]
//      eCode               a 16 bit event code
// OUT
//      nothing

process EVENT_SAVE(int eChannel, int eCode)
{
eChannel = eChannel - 1;                    // PCL array indexes begin at 0
if ( (ePut[eChannel] + 1) % NCODES == eGet[eChannel])
    {
    // Oops.  The array for this event channel is full!  We have
    // no place to store this event code.
    
    print("EVENT_SET - Event channel %d array is full! eCode=%d not saved.  Increase NCODES.\n", 
        eChannel + 1, eCode);
    }
else
    {
    eStream[eChannel, ePut[eChannel]] = eCode;       // Save the event code
    ePut[eChannel] = (ePut[eChannel] + 1) % NCODES;  // Advance put index    
    }
}


//-------------------------------------------------------------------
// Process EVENT_UPDATE - Save event codes in eStream[] arrays to the
// event channels.
// Note: This process MUST be the _last_ process in your protocol.
// (At a minimum, within a particular process cycle, it must execute
// after all calls to Process EVENT_SET().

process EVENT_UPDATE() enabled
{
    int     N;                          // = ASETS
    int     cs;                         // eChannel set index [0..ASETS)
    int     eChan;                      // An event channel number [1..ECHANNELS]
    int     get;                        // A particular "get" index [0..NCODES)

N = GetSystemInfo(GSI_ASETS);           // =ASETS (this only needs to be done once)

while (1)                               // Do the following on every process cycle ...
    {
    eChan = 0;                          // Starting with first event channel ...
    while (eChan < ECHANNELS)           // .. do the following for each event channel
        {    
        cs = 0;                         // Start with first channel set
        while (cs < N)                  // Loop up to ASETS times in this process cycle
            {
            get = eGet[eChan];          // Get the "get" index for this eChannel
            if (get == ePut[eChan])     // Are there any more eCodes in this channel?
                {
                cs = N;                 // No, we're done with this channel
                }
            else
                {                       // Yes ... output to event stream
                etable_set(eChan + 1, cs, eStream[eChan, get]); // "save" next eCode
                
                // For debugging
                printf("%d: EVENT %d Channel %d ChannelSet=%d get=%d put=%d\n", 
                    tick(),
                    eStream[eChan, get], eChan+1, cs, eGet[eChan], ePut[eChan]);
                    
                eGet[eChan] = (get + 1) % NCODES;           // Advance "get" index
                cs = cs + 1;            // Advance to next channel set
                }
            }
                
        eChan = eChan + 1;              // Advance to next event channel
        }
    nexttick;                           // Wait for next process cycle
    }
}

