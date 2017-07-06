// P16.PRO - Test PCI-DAS1602/12 and PCI-DAS1602/16 cards

#include dio.pro                        // For DIO definitions
#include tempo.pro                      // For GSI definitions


//---------------------------------------------------------------------
process MAIN enabled
{
//system("dshow main");

while (1)
    {
    trigger 1;
    wait 2000;
    if (htb_sweep(1) == 100)
        {
        system("hzero *");
        while (system()) nexttick;
        }
    }
}

//---------------------------------------------------------------------
// Analog output test.  Wire the two analog outputs to two analog input
// channels.  You should see two sawtooth wave forms, DAC1 has a longer
// period than DAC0.
//
// DAC0 ground  pin35
// DAC0 hi      pin36
// DAC1 ground  pin37
// DAC1 hi      pin38
//
// AnalogIn1    pin2
// AnalogIn2    pin4

int MAXDAC, MINDAC;
int dac0, dac1, dac0dir, dac1dir;
int dac0jump = 900;
int dac1jump = 260;

process ANALOG_OUT enabled
{
if (GetSystemInfo(GSI_PCIDAS1602_16))
    {
    MINDAC = -32767;                    // 16 bit DACs
    MAXDAC =  32768;
    }
else
    {
    MINDAC = -2047;                     // 12 bit DACs
    MAXDAC =  2048; 
    }
    
dac0 = MINDAC;
dac1 = MAXDAC;
dac0dir = 1;
dac1dir = -1;

while (1)
    {
    mio_ao_set(0, dac0);                // Generate a sawtooth
    mio_ao_set(1, dac1);                // dac0 is out of phase of dac1
    
    dac0 = dac0 + dac0dir * dac0jump;
    if (dac0 > MAXDAC || dac0 < MINDAC)
        {
        dac0dir = -dac0dir;
        dac0 = dac0 + dac0dir * dac0jump;
        }
    
    dac1 = dac1 + dac1dir * dac1jump;
    if (dac1 > MAXDAC || dac1 < MINDAC)
        {
        dac1dir = -dac1dir;
        dac1 = dac1 + dac1dir * dac1jump;
        }
        
    nexttick;
    }
}

//---------------------------------------------------------------------
// Pulse each TTL output at its own frequency.  The pulse lasts 1 process cycle.
// Frequencies are specified in milliseconds and must be multiples of the process
// cycle time.  The test requires wiring TTLouts 0-15 to analog inputs 0-15 and
// spike inputs 0-14.  You should see the same pattern of pulses when you
// display the first 15 analog inputs and spike inputs.  Note that the 8254
// counters require an up transition (0->5v) followed by a down transition (5v->0v).
// The 8254 counter counts on the down transition.
//
//
//declare doutfreq[16] = {90, 80, 70, 60, 50, 40, 30, 20, 90, 80, 70, 60, 50, 40, 30, 20};
//declare doutfreq[16] = {20, 30, 40, 50, 60, 70, 80, 90, 20, 30, 40, 50, 60, 70, 80, 90};
//declare doutfreq[16] = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20};
//declare doutfreq[16] = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50};
//declare doutfreq[16] = {50, 100, 50, 100, 50, 100, 50, 100, 50, 100, 50, 100, 50, 100, 50, 100};
//declare doutfreq[16] = {100, 50, 100, 50, 100, 50, 100, 50, 100, 50, 100, 50, 100, 50, 100, 50};
  declare doutfreq[16] = {20 ,100, 150, 200, 250, 300, 350, 400, 350 ,300, 250, 200, 150, 100, 50, 30};

process DOUT enabled
{
    int line;
    
while (1)
    {
    ms = time();
    line = 0;
    while (line < 16)
        {
        if ((ms % doutfreq[line]) == 0)
            mio_dig_set(line, 1);
        else
            mio_dig_set(line, 0);
        line = line + 1;
        }
    nexttick;
    }
}

//---------------------------------------------------------------------
// For TTL inputs, use the SHOW V display and connect a switch to
// each TTL input.  Be sure to add a pull-down or pull-up resistor
// (see Computer Boards manual).  You should see the TTL0-7 variables
// toggle as you toggle the switch.

process DIN enabled
{
while (1)
    {
    ttl0 = mio_dig_get(0);
    ttl1 = mio_dig_get(1);
    ttl2 = mio_dig_get(2);
    ttl3 = mio_dig_get(3);
    ttl4 = mio_dig_get(4);
    ttl5 = mio_dig_get(5);
    ttl6 = mio_dig_get(6);
    ttl7 = mio_dig_get(7);
    nexttick;
    }
}

//---------------------------------------------------------------------
// Test mio_fout() function.
// Freq is in units of 10 Mhz.
// Connect OUT (pin 41 on PCI-DAS-1602) to a spike input channel
// You may have to wire GATE (pin 40) to +5v (pin 48).
// The 8254 counter is programmed in mode 3 (square wave) so
// the OUT toggles each time the counter counts down to 0 (from freq).

declare fout = 50000;               // 10,000,000/50,000 = 200 Hz

process MIOFOUT enabled
{
    int prevFout;                   // Remember previous setting
    
while (1)
    {
    if (prevFout != fout)
        {
        mio_fout(fout);
        prevFout = fout;
        }
    
    nexttick;
    }
}


//---------------------------------------------------------------------
// Process DIOOUT - Digital output
// Remove comments if you have a kernel with the DIO driver

//hex DIOA, DIOB, DIOC;
//
//process DIOOUT enabled
//{
//dioSetMode(0, PORTA | PORTB | PORTC);   // All 24 are output
//while (1)
//    {
//    DIOA = 0xFF; dioSetA(0, DIOA);
//    DIOB = 0x00; dioSetB(0, DIOB);
//    DIOC = 0xFF; dioSetC(0, DIOC);
//    wait 1000;
//    DIOA = 0x00; dioSetA(0, DIOA);
//    DIOB = 0xff; dioSetB(0, DIOB);
//    DIOC = 0x00; dioSetC(0, DIOC);
//    wait 1000;
//    }
//}