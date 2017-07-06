// VSWORDEP.PRO - Demonstrate word evoked potential response
// Please review the WD VideoSYNC command in the TEMPO manual
// to see how to set up VideoSYNC with word lists.

hide constant NLISTS = 2;               // Number of word lists
hide nwords[NLISTS] = {10, 10};         // Number of words in each wordlist
     delay = 200;

hide VideoSync = 1;                     // 0=wordplay, 1=videosync

process MAIN enabled
    {
    list = 0;
    word = 0;
    font = 0;
    if (VideoSync)
        dsend("CA; VI 16");
    else
        send("CA: VI 16");
    wait 2000;
        
    while (1)
        {
        if (VideoSync)
            dsendf("WD %d,%d,%d\n", list, word, font);
        else
            sendf("WD %d,%d,%d\n", list, word, font);

        trigger word;

        wait delay;
        word = word + 1;
        if (word >= nwords[list])
            {
            word = 0;
            list = list + 1;
            if (list >= NLISTS)
                list = 0;               // Back to first list
            }
        }
    }

process SAVEDB enabled
    {
    while (1)
        {
        while (htb_sweep(1) < htb_sweeps(1))
            nexttick;
        system("hzero *");              // Save & zero databases
        wait  2000;                     // Wait for zero to complete
        }
    }
