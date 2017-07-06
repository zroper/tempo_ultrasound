// JOURNAL.PRO - Example protocol for journaling messages to a text
// file from a protocol.
// A message is formatted and appended to a file every .1 second.

process MAIN enabled
    {
    trial = 0;
    systemf("WRITE journal.txt Starting experiment.\\n\n");
    print("Experiment beginning - results being written to JOURNAL.TXT");
    print("Takes about 20s. Look at JOURNAL.TXT when done.");
    while (trial < 200)
        {
        trial = trial + 1;
        systemf("WRITE journal.txt Trial %4d %6d ms, Sec since midnight %6d\\n\n",
            trial, time(), timeofday());
        wait    100;
        }
    systemf("WRITE journal.txt End of experiment\\n\n");
    system("FLUSH");
    print("Experiment over - results in JOURNAL.TXT");
    }
