/*  .title  SPIKE1.PRO - Protocol to test spike channel input
;
; DESCRIPITION
;
;   Use this protocol to verify that your spike channels are
;   working correctly and that TEMPO is collecting spike data correctly.
;
;   You can use this test protocol if you are having problems collecting
;   spike data and want to verify that your hardware is working and 
;   your configuration is set up correctly.
;
;   It simply collects data from each spike channel and displays it.
;   It is set up for 9 spike channels (CCHANNELS=9).  If you have
;   fewer channels, some of the databases will fail to be created
;   when you CLOAD this protocol.  This is OK.
;
;   The protocol continuously records from each channel and stores
;   each channel in its own database.  Please follow these instructions
;   to test your equipment.
;
; EQUIPMENT
;
;   This protocol was designed to work with the KPED kernel with a
;   pci-ctr10 board.  It should work with other boards and kernels
;   as well but the number of spike channels may vary.
;
; PARAMETERS
;
;   For this test, it is useful to set CCHANNELS in your kernel
;   configuration file (or SETUPTN's TEMPO configuration file) to 9.
;   (i.e., CCHANNELS=9).
;
;   If you have more than 9 spike channels and you want to test
;   them, you can create additional databases to monitor those
;   channels.
;
; INSTRUCTIONS
;
;   -----------------------------------------------------------------------
;   TEST 1 - record known data from each spike channel using pulse generator
;   -----------------------------------------------------------------------
;   
;   1. Connect a pulse generater to spike channel 1.  The pin
;   on the PCI-CTR10 card that you plug into is on P1 (Counter A) cable
;   pin 36 (CTR1CLK).  If you use gating, also connect your switch
;   to pin 37 (CTR1GATE).  If you don't use gating, connect pin 37 to
;   pin 11 (ground).
;   
;   2. Set your pulse generator to produce pulses every 100 ms.  The pulse
;   can be short (a few microseconds is plenty).
;   
;   3. Run this little test protocol.  It simply collects data
;   from all 10 spike channels.
;   
;   Start your TEMPONET server.  Then start your client.  Then type:
;   
;       cd /tempo/prowin
;       cload spike1
;       start
;       
;   You should see now see 10 spike pulses every second of data
;   collected in the chart on channel 1.
;   
;   4. If you see this, move the pulse generator to spike channel 2
;   (pin 19 CTR2CLK).  You should now see 10 spike pulses per second
;   in the chart.
;   
;   Repeat this for each of the 10 spike channels to verify that
;   each one is working individually.
;
;   You can also HSAVE each database (or all of them) and view the
;   data numerically to see that you receive the pulses at the proper
;   frequency.  To save all databases, 
;
;       1. type HSAVE * SPIKE1.HTB at the TEMPO prompt.
;       2. Open a DOS window, run HTB and convert database 1
;          to a text file:
;
;           cd \tempo\prowin
;           htb -p1 spike1.1
;
;       3. View SPIKE1.1 with any text editor
;
;   You can view spike channel 2 database with:
;
;           cd \tempo\prowin
;           htb -p2 spike1.2
;
;   etc.
;   
;   -----------------------------------------------------------------------
;   TEST 2 - record known data from multipl spike channels using pulse generators
;   -----------------------------------------------------------------------
;   
;   If you are able to see the data in TEST 2 correctly, you can do TEST 3.
;   
;   Here, we check multiple spike channels to verify that they are
;   record correctly.  If you have two pulse generators, set one to 100
;   msec and the other to 30msec (one is out of phase with the other).
;   If you have only one pulse generator, set it to 100 msec.
;   
;   Connect one pulse generator to channel 1 and one to channel 2.  If you
;   have only one pulse generator, connect it to both channel 1 and 2.
;   
;   Verify that you see the correct data in the spike chart.
;   
;   Test all adjacent 9 pairs of channels this way.
;   
;   Test all channels that are two apart (1+3, 2+4, 3+5, 4+6, 5+7, 6+8,
;   7+9).
;   
;   If these tests all produce the correct results, then your TEMPO system
;   is probably working correctly.
;   
;   -----------------------------------------------------------------------
;   TEST 3 - Connect spike discriminator to channel 1
;   -----------------------------------------------------------------------
;   
;   Connect your spike discriminator to TEMPO's spike channel 1.  Use its
;   tests modes to verify that you are receiving the signal properly.
;   
;   
;   -----------------------------------------------------------------------
;   
;   If all of the above tests are working, then your TEMPO system is
;   working and your spike discriminator is probably working correctly.
;   
;   If you are still unable to collect spike data from your protocol,
;   you may have one or more of these problems:
;   
;   1. your spike discriminator isn't working properly
;      (use an o-scope on its output to verify it is producing
;      the proper pulses)
;   
;   2. there is a cabling or connector problem from your spike
;      discriminator to the TEMPO spike channel.  Try a new cable.
;      
;   3. you have a bug in your protocol.
;   
; EDIT HISTORY
;   20Oct03 sh  Initial edit
*/
#pragma declare=1                       // Require declarations

declare MAIN();

//------------------------------------------------------------------
process MAIN() enabled
{
    int     n;

n = 0;    
while (1)
    {
    wait 1000;
    n = n + 1;                          // Count one more trigger
    trigger 1;                          // Collect data every 1 sec
    printf("Trigger %d\n", n);
    if ((n % htb_sweeps(1)) == 0)       // Have we filled the databases?
        {
        wait    4000;                   // Give user a chance to stop & save
        system("hzero *");              // zero all databases
        while (!system())
            nexttick;                   // Wait for all databases to zero
        n = 0;                          // Reset counter
        }
    }
}