// OVERLOAD.PRO - How to pace an experiment based on the client's
//                limited ability to download the databases quickly.
//
// It is possible to collect data on the server faster than the client
// can download it.  If this condition persists, the client can fall
// behind.  When an HSAVE is executed, the client detects that it has
// not downloaded all the epochs and displays a dialog asking you if
// you want to wait for the client to finish downloading all the
// epochs.
//
// This condition occurs because the protocol is collecting data
// faster than your client, server and network can process it.
// To correct the problem, you can:
//
//  0. do nothing.  You're not loosing data; if you want to HSAVE
//     all epochs, you'll just have to wait for the client to download
//     them from the server.  You can watch its progress with the
//     SHOW H display.
//  1. get faster CPUs
//  2. install a faster network (eg upgrade from 10 mbit to 100 mbit)
//  3. eliminate network traffic by using a crossover cable
//  4. Reduce the amount of data you collect per trial
//  5. slow down the experiment by making sure the client has
//     downloaded all data before proceeding to the next trial.
//
// We recommend that you do one or more of 0-4 above.
//
// If, however, you want to do #5, this sample protocol shows you how to
// force the protocol to wait for the client to finish downloading all
// of the data it collected during a trial before continuing to the
// next trial.
//
// Note that if you wait for the client to download the data, you may
// be subtly changing the methodology of your experiment because
// pacing of the trials is now based on the (limited) speed of your hardware,
// which may make it difficult to reproduce the experiment by others
// (as well as in your lab!)
// 
// To simulate the problem, the protocol triggers databases very fast,
// causing the server to collect data faster than the client can
// download it.  It then issues an HSAVE command.
//
// The global variable, waitForDownload, is used to decide whether
// to wait for the client to download the epochs at the end of
// each trial.  If it is 0, the protocol does not wait.  If it is
// 1 (default), the protocol will wait for the client.
//
// We check only the last database, assuming that when this one is
// completely downloaded by the client, all the other databases will be
// downloaded, too.
//
// Some large database append databases are defined with TAG=1
// in the PCF file.

#pragma declare=1

// The waitForDownload flag is set to 1 when we want to wait for the
// client to download all epochs at the end of each trial.  If this
// is set to 0, we won't wait and the server will collect epochs
// faster than the client can download them.  This will result in
// a dialog being displayed when the databases are HSAVEd asking
// you if you want to wait for the client to finish downloading the
// rest of the server's epochs (see the HSAVE command in the TEMPO
// manual).

int waitForDownload = 1;

// nLastDatase is the database we check to make sure that the
// client had download all epochs from server.

int nLastDatabase = 7;

// The debug variable is set to 1 to suppress printing of the client &
// server epoch counts when the CheckClientDownloadComplete() process
// is checking the client & server epoch counts.  Set to 0 to see the
// client & server epoch counts in the message window.

int debug = 1;

// PROCESS DECLARATIONS

declare int FLOOD();
declare int CheckClientDownloadComplete(int nDb);

//---------------------------------------------------------------------------------
process FLOOD enabled
{
    int     waitTime;                   // # of ms we had to wait for client to..
                                        // ..download databases
    
while (1)
    {
    // BEGINNING OF TRIAL
    
    wait 500;
    trigger 1;
    
    // END OF TRIAL.  DO WE WAIT FOR THE CLIENT TO DOWNLOAD THE DATA?
    
    if (waitForDownload)
        {
        // WAIT FOR CLIENT TO DOWNLOAD THE LAST DATABASE.
        // This insures that the client downloads the database
        // before going on to the next trial.
        
        waitTime = time();              // Just for fun, display how long we wait for client
        
        spawn           CheckClientDownloadComplete(nLastDatabase);
        waitforprocess  CheckClientDownloadComplete;
        
        waitTime = time() - waitTime;
        printf("Waited %d ms for client to download database epoch %d.\n", waitTime, htb_sweep(nLastDatabase));
        }
        
    // ARE WE AT THE END OF THE RUN?    
    
    if (htb_sweep(nLastDatabase) > 0 && htb_sweep(nLastDatabase) == htb_sweeps(nLastDatabase))
        {
        printf("%d Epoch collected.  Calling HSAVE...\n", htb_sweeps(nLastDatabase));
        systemf("hsave *\n");
        systemf("hzero *\n");
        
        while (systemf())               // Wait for client to save data
            nexttick;
        }
    }
}



//---------------------------------------------------------------------------------
int nEpochsOnClient;            // Temp variable
int nEpochsOnServer;            // Temp variable

process CheckClientDownloadComplete(int nDb)
{
    int     nDone;

nDone = 0;
while (!nDone)
    {
    // WAIT UNTIL ALL PENDING TRIGGERS HAVE MATURED.
    
    while (getPendingDBTriggers())
        nexttick;
    
    // GET THE NUMBER OF EPOCHS THAT ARE ON THE SERVER AT THIS MOMENT.
    // WE ASSUME THAT THE SERVER WON'T KEEP TRIGGERING MORE EPOCHS
    // (EG VIA ANOTHER PROCESS RUNNING IN PARALLEL WITH THIS ONE).
    
    nEpochsOnServer = htb_sweep(nDb);

    // ASK CLIENT HOW MANY EPOCHS IT HAS DOWNLOADED.  STORE
    // THE RESULT IN A PROTOCOL VARIABLE.  THE htb_sweep()
    // FUNCTION IS EXECUTED ON THE CLIENT AND RETURNS THE
    // CURRENT NUMBER OF EPOCHS THAT HAVE BEEN DOWNLOADED
    // FROM THE SERVER.  THE RESULT IS STORED IN A PROTOCOL
    // VARIABLE (nEpochsOnClient).  THIS IS NOT YET POSSIBLE
    // BECAUSE htb_sweep(nDB) ISN'T DEFINED FOR TEMPO
    // EXPRESSIONS.
    
    // The QUIET prefix to an assignment command suppresses printing a
    // message in the message window.
    
    if (debug)
        systemf("nEpochsOnClient=ClientHtbSweep(%d);?nEpochsOnServer\n", nDb);
    else
        systemf("QUIET nEpochsOnClient=ClientHtbSweep(%d)\n", nDb);
        
    while (systemf())
        nexttick;

    // NOW COMPARE WHAT THE CLIENT HAS WITH WHAT THE SERVER HAS.
    // IF THE CLIENT HAS ALL EPOCHS THAT ARE ON THE SERVER, WE
    // EXIT THIS LOOP.
    
    if (nEpochsOnClient >= nEpochsOnServer)
        nDone = 1;                  // Yes, exit process

    // NO, GIVE CLIENT A CHANCE TO DOWNLOAD
    // THE EPOCHS, THEN ASK AGAIN.   WE DON'T WANT TO ASK
    // TOO QUICKLY BECAUSE WE ARE CONSUMING NETWORK AND CPU
    // RESOURCES EVERY TIME WE SEND A TEMPO COMMAND TO THE
    // CLIENT.  4 REQUESTS PER SECOND SHOULDN'T ADVERSLY
    // AFFECT THE NETWORK, CLIENT OR SERVER.

    wait 250;
    }
}
