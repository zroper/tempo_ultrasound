/* VOICE.PRO - This protocol collects analog (voice) data.
 * Connect a microphone to analog channel 1 and channel 2.
 *
 * When individual words are spoken into the microphone, the analog voice
 * data is accumulated +/- .5 sec around the vocalization.  Throughout
 * the experiment, the continuous signal is acquired and displayed in the
 * upper two graphs.
 *
 * This example demonstrates
 *  o Real-time analog functions for detecting vocalization (ADIS on channel 1)
 *  o Real-time response to external events (i.e., subject initiated vocalization)
 *  o Acquisition of pre- and post-event data (Database OFFSET=250)
 *  o Multiple processes make overall task easier.
 *  o Acquisition using multiple databases for different types of collections
 *  o Use of STATUS bits to signal significant events
 *  o Both recording and online averaging (see databases 3 and 4)
 */

process background enabled              // Constantly collect in background
    {
    while (1)
        {
        while (htb_sweep(1) < htb_sweeps(1))
            {
            wait    1000;
            trigger 1;                  // Causes 2 databases to collect
            }
        system("hzero 1; hzero 2");
        while (system() > 0)
            nexttick;                   // Wait for hzero to finish
        }
    }

voice_bit = 0x2;                        // Bit in status indicating vocalization

process voiceact enabled
    {
    nexttick;                           // Wait for one cycle to set status
    while (1)
        {
        wsof    voice_bit;              // Wait for status bit to go OFF
        trigger 3;                      // Triggers both APP and SUM
        count = count + 1;
        print("Vocalization ", count);
        wait    1000;                   // Wait for voice to settle
        print();                        // Erase messages
        }
    }
