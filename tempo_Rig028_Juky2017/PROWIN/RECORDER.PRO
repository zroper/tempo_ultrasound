/* RECORDER.PRO - Stream data to disk
*
* DESCRIPTION
*   This protocol continuously writes analog data to disk.
*   If you want to stream spike or event data, simply create two
*   spike or event databases with the same trigger tag and period
*   as the existing analog databases.
*
*   We use two analog append (XAPP) databases to double buffer the incoming
*   analog data.  When the first database is full, data is collected
*   in the second database.  The first database is written to
*   disk and zeroed.  When the second database is full, we switch
*   back to collecting data in the first database while we save & zero
*   the second database.
*
*   Each database collects 100 of 1 second epochs.
*
* 12Apr00 sh    Initial edit
*/

#pragma declare=1

declare MAIN(), SaveDatabase(int nDb);

//-----------------------------------------------------------------------

process MAIN() enabled
{
    int nEpochs;                        // # of epochs in databases
    int nTriggers;                      // # of times we've triggered database
    int nTag;                           // Database tag to trigger (1 or 2)
    int nPeriod;                        // duration of an epoch (ms)

nEpochs = htb_sweeps(1);                // Get max # of epochs per database
nTag = 1;                               // Current database
nTriggers = 0;                          // # of triggers in database
nPeriod = mspertick() * htb_period(1);  // # of ms in one epoch

while (1)
    {
    WAIT        nPeriod;                // Wait one epoch
    TRIGGER     nTag;                   // Trigger current database
    nTriggers = nTriggers + 1;          // Count one more trigger

    if (nTriggers >= nEpochs)           // Is it full?
        {
        nTriggers = 0;                  // Reset trigger count
        SPAWN   SaveDatabase(nTag);     // Save & zero database

        if (nTag == 1) nTag = 2;        // Flip databases
        else nTag = 1;
        }
    }
}

//-----------------------------------------------------------------------
// SaveDatabase() - Save & zero a database
// Wait for all triggers to collect, HSAVE then zero database
// This process runs in parallel with MAIN so data is collected
// without interruption.

process SaveDatabase(int nDb)
{
while (getPendingDBTriggers(nDb))
    NEXTTICK;                           // Wait for all triggers to complete

systemf("HSAVE %d recorder.htb\n", nDb);// Save database
systemf("HZERO %d\n", nDb);             // Zero database
while (system())
    NEXTTICK;                           // Wait for completion
}