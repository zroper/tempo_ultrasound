// PCICTR.PRO - Tests for the KPED kernel (PCI-DAS1602 + PCI-CTR05 + PCI/DIO)
//
// Test counter board for proper functioning for PCI-DAS1602 + PCI-CTR05.
//
// 28Jun04 Note: if you're using a KBTxxx kernel (cio-das1602 + PC-TIO10),
//      you can use this protocol but you will have to change
//      the mio_fout() calls to tio_fout().  Note that the pin wiring
//      is dependent on which analog and counter boards you are using.
//
//
// PCI-DAS1602
//      pin 41          FOUT frequency output generator
//
// PCI-CTR05 (or main cable on PCI-CTR10)
//      pin 36          CTR1CLK (spike input channel 1 in SHOW C)
//      pin 19          CTR2CLK (spike input channel 2 in SHOW C)
//      pin 17          CTR3CLK (spike input channel 3 in SHOW C)
//      pin 15          CTR4CLK (spike input channel 4 in SHOW C)
//      pin 13          CTR5CLK (spike input channel 5 in SHOW C)
//      pin 30          OscOut (FOUT frequency output generator) for tio_fout()
//      pin 29          TTL in 1
//      pin 28          TTL in 2
//      pin 27          TTL in 3
//      pin 26          TTL in 4
//      pin 25          TTL in 5
//      pin 24          TTL in 6
//      pin 23          TTL in 7
//      pin 22          TTL in 8
//      pin 10          TTL out 1
//      pin  9          TTL out 2
//      pin  8          TTL out 3
//      pin  7          TTL out 4
//      pin  6          TTL out 5
//      pin  5          TTL out 6
//      pin  4          TTL out 7
//      pin  3          TTL out 8
// 
// The wiring for the PCI-CTR20 is different but this protocol will
// work with it.  Refer to the Measurement Computing manual for the
// pins associated with CTRnCLK, n=1..20
//
// 24Jun04 Updated wiring description to use CTRnCLK, not GATE


//---------------------------------------------------------------------------
// On PCI-DAS1602, pin 41 (OUT4) is the FOUT square wave.
// Connect pin 41 to a GATEn input on for one of the counters to CLKnCTR
// pin on your PCI-CTR board.
//
// With 1,000,000 Hz fout sampled at SPEED=1000 Hz, you should see values
// around 1,000 in each spike bin.

int MIOfreq = 1000000;                  // Frequency of PCI-DAS1602 FOUT pin 41

process MAIN enabled
{
if (freq > 0)
    {
    mio_fout(10000000 / freq);          // freq=10,000,000 / 1000
                                        // use tio_fout() for PC-TIO10 boards
    }

while (1)
    {
    wait 1000;                          // Trigger database accumulation every 1 sec
    trigger 1;
    }
}

//---------------------------------------------------------------------------
// PCI-CTR05 - FOUT test
// Connect pin 30 (OscOut) on PCI-CTR05 to one of the spike counters.
// With source=1,000,000 and div=3, with SPEED=1000 Hz, you should see
// counts of appx 333 in SHOW C.
//
// Note: Measurement Computing recommends that you use the PCI-DAS1602
// FOUT when connecting to the PCI-CTR.  Connecting the PCI-CTR's FOUT 
// to one of its CTRnCLK pins may cause spurious counts.

int TIOfout = 1;                        // am9513 chip to set FOUT
int TIOsource = 1000000;                // 100,1000,10000,100000,1000000
int TIOdiv = 3;                         // Divisor 0,1-16
int TIOnChips = 0;                      // # of am9513 chips

process FOUT
{

TIOnChips = tio_fout(0, TIOsource, TIOdiv);   // Get # of am9513 chips

TIOerr = tio_fout(TIOfout, TIOsource, TIOdiv);    // Set FOUT on first am9513

printf("nChips=%d  source=%d  divisor=%d  err=%d\n", TIOnChips, TIOsource, TIOdiv, TIOerr);
}


//---------------------------------------------------------------------------
// PCI-CTR05 - Test digital inputs/outputs
// Tests first 8 TTL INs and TTL outs
// Make the following connections on the first PCI-CTR05
//
// pin 10    TTL out 1     <--->   pin 29   TTL in 1
// pin  9    TTL out 2     <--->   pin 28   TTL in 2
// pin  8    TTL out 3     <--->   pin 27   TTL in 3
// pin  7    TTL out 4     <--->   pin 26   TTL in 4
// pin  6    TTL out 5     <--->   pin 25   TTL in 5
// pin  5    TTL out 6     <--->   pin 24   TTL in 6
// pin  4    TTL out 7     <--->   pin 23   TTL in 7
// pin  3    TTL out 8     <--->   pin 22   TTL in 8
//
// The TTL outs are toggled once per second so the TTLins should
// also toggle exactly the same way.

int TIO1out = 1;
int TIO2out = 0;
int TIO3out = 1;
int TIO4out = 1;
int TIO5out = 0;
int TIO6out = 1;
int TIO7out = 0;
int TIO8out = 1;

int TIO1in = 0;
int TIO2in = 0;
int TIO3in = 0;
int TIO4in = 0;
int TIO5in = 0;
int TIO6in = 0;
int TIO7in = 0;
int TIO8in = 0;

process TIOTTL 
{
TIOnInputs = tio_dig_get(0);             // Get # of TTL inputs
TIOnOutputs = tio_dig_set(0, 0);         // Get # of TTL outputs
printf("%d TTL inputs, %d TTL outputs\n", TIOnInputs, TIOnOutputs);

if (!TIOnInputs || !TIOnOutputs)
    {
    printf("NO TTL INPUTS or OUTPUTS\n");
    }
else while (1)
    {
    wait    1000;
    
    TIO1out = 1 - TIO1out;                  // Toggle value
    TIO2out = 1 - TIO2out;                  // Toggle value
    TIO3out = 1 - TIO3out;                  // Toggle value
    TIO4out = 1 - TIO4out;                  // Toggle value
    TIO5out = 1 - TIO5out;                  // Toggle value
    TIO6out = 1 - TIO6out;                  // Toggle value
    TIO7out = 1 - TIO7out;                  // Toggle value
    TIO8out = 1 - TIO8out;                  // Toggle value
    
    TIOSeterr1 = tio_dig_set(1, TIO1out);
    TIOSeterr2 = tio_dig_set(2, TIO2out);
    TIOSeterr3 = tio_dig_set(3, TIO3out);
    TIOSeterr4 = tio_dig_set(4, TIO4out);
    TIOSeterr5 = tio_dig_set(5, TIO5out);
    TIOSeterr6 = tio_dig_set(6, TIO6out);
    TIOSeterr7 = tio_dig_set(7, TIO7out);
    TIOSeterr8 = tio_dig_set(8, TIO8out);
    
    TIO1in = tio_dig_get(1);
    TIO2in = tio_dig_get(2);
    TIO3in = tio_dig_get(3);
    TIO4in = tio_dig_get(4);
    TIO5in = tio_dig_get(5);
    TIO6in = tio_dig_get(6);
    TIO7in = tio_dig_get(7);
    TIO8in = tio_dig_get(8);
    
    TTLout =     TIO1out
              | (TIO2out << 1)
              | (TIO3out << 2)
              | (TIO4out << 3)
              | (TIO5out << 4)
              | (TIO6out << 5)
              | (TIO7out << 6)
              | (TIO8out << 7);
    
    TTLin =      TIO1in
              | (TIO2in << 1)
              | (TIO3in << 2)
              | (TIO4in << 3)
              | (TIO5in << 4)
              | (TIO6in << 5)
              | (TIO7in << 6)
              | (TIO8in << 7);

    if (TTLout == TTLin)
        printf("TTL %02x OUT   %02x IN (TTLs working correctly)\n", TTLout, TTLin);
    else
        {
        printf("TTL %02x OUT   %02x IN (TTLs not working right)\n", TTLout, TTLin);
        if (TIO1in != TIO1out)
            printf("TTL 1:      pin 10 TTL out 1 <---> pin 29 TTL in 1  INCORRECT\n");
        if (TIO2in != TIO2out)
            printf("TTL 2:      pin  9 TTL out 2 <---> pin 28 TTL in 2  INCORRECT\n");
        if (TIO3in != TIO3out)
            printf("TTL 3:      pin  8 TTL out 3 <---> pin 27 TTL in 3  INCORRECT\n");
        if (TIO4in != TIO4out)
            printf("TTL 4:      pin  7 TTL out 4 <---> pin 26 TTL in 4  INCORRECT\n");
        if (TIO5in != TIO5out)
            printf("TTL 5:      pin  6 TTL out 5 <---> pin 25 TTL in 5  INCORRECT\n");
        if (TIO6in != TIO6out)
            printf("TTL 6:      pin  5 TTL out 6 <---> pin 24 TTL in 6  INCORRECT\n");
        if (TIO7in != TIO7out)
            printf("TTL 7:      pin  4 TTL out 7 <---> pin 23 TTL in 7  INCORRECT\n");
        if (TIO8in != TIO8out)
            printf("TTL 8:      pin  3 TTL out 8 <---> pin 22 TTL in 8  INCORRECT\n");
        }
    }
}