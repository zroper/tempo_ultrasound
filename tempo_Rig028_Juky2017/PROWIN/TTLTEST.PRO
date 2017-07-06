// TTLTEST.PRO
// Test protocol for Naoyuki Matsumoto
// 01Jul04  S. Hoffman

// This protocol gives you a simple way to check all TTL inputs and outputs
// on your ANALOG board.  One particular TTL output is toggled once per second.
// Simultaneously, a high or low tone is sounded indicating +5v or 0v.
//
// The pin definitions here are for the PCI-DAS1602.  
// If you have are using a different analog board, consult the manual for
// pin definitions.
//
// This protocol assumes you have DAS_DIGITALIN=8 on the PCI-DAS1602.
// When you have MIO_DIGITAL=8 in your SETUPTN configuration,
//
//      pci-das pins 51-58 are the 8 TTL inputs
//      pci-das pins 59-74 are the 16 TTL outputs
//
// You will need a volt meter or oscilloscope to test your TTLs.
// 
// Connect your volt meter or oscillocope signal to 
// pci-das pin 59 (B0).  This is the first (of 16)
// TTL output pins (pins 59-74) on the pci-das.  Connect the ground
// to PC GROUND on the pci-das board (ie. pin 89).
//
// 1. Make sure you see the voltage on pin 59 toggle between +5v and +0v
//    once per second.  Connect your test equipment ground to pci-das
//    PC GROUND pin 89 (any PCI GROUND pin is ok).
//
//    The following process causes TTL output on pin 59 pci-das to change once
//    per second between +5v and +0v.
//    Make sure you see this change on your test equipment.

process OUTPUT enabled
{
systemf("show v\n");                    // Display SHOW V window on client computer.
while (1)
    {
    pin59Output = 0;                    // 0=0v, 1=5v
    mio_dig_set(0, pin59output);        // output line 0 = pin 59, output line 1 = pin60, ...
    spawn NOISE(200);                   // low tone for 0v
    wait 1000;
    
    pin59Output = 1;
    mio_dig_set(0, pin59output);
    spawn NOISE(400);                   // high tone for +5v
    wait 1000;
    }
}


// Play a tone for a 100 ms.  If you stop the clock when the tone it
// playing, this process won't be able to turn off the sound.  You can
// turn off the sound by typing SOUND 0 at the TEMPO Command line.

process NOISE(int freq)
{
sound(freq);
wait 100;
sound(0);
}


// 2. Assuming you see the change on output pin59 from the above
//    test, the following process lets you
//    test the digital input on the pci-das.
//
//    Connect pin 59 (B0) to pin 51 (A0).  Pin 51 is the first
//    of 8 TTL inputs on the pci-das board.  The others are pins
//    51-58.
//
//    The following process reads each of the 8 TTL inputs on the
//    pci-das
//    and displays them in eight protocol variables (0=0v, 1=5v)
//    pin51input .. pin58input.
//
//    If any pin51-58 is not connected, it is "floating" and can
//    be any value at any time (random).  Floating inputs must be
//    ignored because they are meaningless.
//
//    When you connect pin 59 to pin 51, the pin51input variable
//    should start toggling once per second and should match the pin59.
//
//    In the PCL Functions chapter under the mio_dig_get() function,
//    it says that the mio_dig_get function uses "inverted logic".
//    The little process below uses 1-xxx to invert the returned
//    value from mio_dig_get() so protocol variable pin51input
//    will be displayed as the same value (0 or 1) as pin59Output.
//    See p234 in your 2004 TEMPO Reference Manual for more information.

process INPUT enabled
{
while (1)
    {
    pin51input = 1 - mio_dig_get(0);    // pin59 -> pin51  = input line 0
    pin52input = 1 - mio_dig_get(1);    // pin59 -> pin52  = input line 1
    pin53input = 1 - mio_dig_get(2);    // pin59 -> pin53  = input line 2
    pin54input = 1 - mio_dig_get(3);    // pin59 -> pin54  = input line 3
    pin55input = 1 - mio_dig_get(4);    // pin59 -> pin55  = input line 4
    pin56input = 1 - mio_dig_get(5);    // pin59 -> pin56  = input line 5
    pin57input = 1 - mio_dig_get(6);    // pin59 -> pin57  = input line 6
    pin58input = 1 - mio_dig_get(7);    // pin59 -> pin58  = input line 7
    
    nexttick;
    }
}


//  3. You can check each TTL input on the pci-das board by connecting
//  TTL output pin 59 to each pin 51-58 sequentially and verify that
//  the corresponding protocol variable changes to match pin59output.