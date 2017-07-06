// TTLTEST.PRO
// Test protocol for Naoyuki Matsumoto
// 03Jul04  S. Hoffman

// CLOAD and START this protocol to test spike collection on PCI-CTR board.
//
// This protocol uses the pci-das's FOUT to generate pulses that are
// taken in by the pci-ctr's counter 1 as a spike pulse.  We produce
// pulses at 2000 Hz for 250 ms, followed by no pluses for 250 ms.
// This is repeated indefinitely.
//
// The SPIKE (UAP) append database 1 collects up to 20 epochs of data.
// Once the data is collected, you can type HZERO * to zero it.
// Or you can save it by typing HSAVE *
// This saves the database to a file called CTRTEST.HTB.
// To examine the data in this file, at a command prompt, type:
//
//      htb ctrtest.htb -p1 ctrtest.txt
//
// This converts the first database in CTRTEST.HTB to a text file
// called CTRTEST.TXT.  You can use this text file to examine
// the data collected.
//
// You should see is something like this in the CTRTEST.TXT file:
// 
//ctrtest.txt Sat Jul 03 10:35:35 2004 BinWidth=0.001 seconds
//9000 2
// 0.001     1    |
// 0.002     2    |
// 0.003     2    |
// 0.004     2    |
// 0.005     2    | Signal goes for 250 ms.
// 0.006     2    |
// 0.007     2    |
// 0.008     2    |
// 0.009     2    |
// 0.010     2    |
// ...            |
// 0.246     2    |
// 0.247     2    |
// 0.248     2    |
// 0.249     2    |
// 0.250     2    |
// 0.251     1    v
// 0.252     0    |
// 0.253     0    |
// 0.254     0    |
// 0.255     0    |
// 0.256     0    | No Signal for 250 ms.
// ...            |
// 0.498     0    |
// 0.499     0    |
// 0.500     0    v
// 0.501     1    |
// 0.502     2    |
// 0.503     2    |
// 0.504     2    |
// ...            | Signal goes for 250 ms.
// 0.748     2    |
// 0.749     2    |
// 0.750     2    |
// 0.751     1    v
// 0.752     0    |
// 0.753     0    |
// 0.754     0    |
// 0.755     0    |
// ...            | No Signal for 250 ms.
// 0.997     0    |
// 0.998     0    |
// 0.999     0    |
// 1.000     0    v
//
// 1.001     1        First data of epoch 2 (repeats sequence)
// 1.002     2 
// 1.003     2 
// 1.004     2 
// 1.005     2 
// 
//
// The reason a "2" is displayed is that we are collecting at SPEED=1000
// and the pulse frequency is 2000 Hz.  So each 1ms bin collects two counts.
// The occasional '1' at the end points of the 250 ms interval means that
// the MIO_FOUT() function caught the counter between pulses.  This is OK
// and does not indicate a problem.
//
// Once you have this test running, you know that your PCI-CTR board is
// able to collect spike pulses correctly.
//
// You can now connect your signal generator (wave form discriminator)
// into pci-ctr pin 36.
// Also connect ground from your signal generator to pci-ctr pin 11.
//
// You should now be able to record and examine data from your signal generator.
//
// If you set FREQ=4000, you should see '4' as the count.  You can play
// around with the frequency.  Review the mio_fout() function in the
// TEMPO Reference Manual for limits on frequency.
//
// Wiring:
//      Connect pci-das1602, pin 41 (FOUT)  to pci-ctr pin 36 (CTR1CLK)

freq = 2000;                            // Hz to pulse, min is about 600 hz

process MAIN enabled
{
    int     count;
    
spawn COLLECT;

while (1)                               // Toggle the pulsing
    {    
    count = 10000000 / freq;
    prev = mio_fout(count);             // Start pulse at FREQ frequency
    wait 250;                           // Wait for 250 ms

    mio_fout(0);                        // Stop pulse
    wait 250;                           // Wait for 250 ms
    }
}

//-------------------------------------------------------------------------
// COLLECT - Trigger database collection for TAG=1 once every 1 second.

process COLLECT
{
while (1)
    {
    trigger 1;
    wait 1000;
    }
}

