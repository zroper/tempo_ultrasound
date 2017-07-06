// D1600.PRO - Test DAS-1600 card
// This protocol displays analog input channels and digital inputs
// while controlling analog outputs and digital outputs.
//
// Use a jumper to connect analog or digital outputs to analog inputs
// to see the changes.
//
// Protocol variable 'freq' controls the rate of switching output values.
// Protocol variable 'jump' controls the amount of change for analog
// outputs.  These can be changed directly from TEMPO's command line
// while the protocol is running.
//
// For the CIO-DAS1602, the pin assignments on the 37 pin analog connector
// are used in the variable names.
//
// The pin outs for other boards (ie CIO-DAS6402, PCI-DAS1602, etc)
// are different than the CIO-DAS1602.  Please check your Users Manual
// that came with your analog board for pinouts.
//
// The Appendix in the TEMPO Reference Manual also provides pin information
// for each board.
//
// You can use SHOW A to display the analog input values
//
// EDIT HISTORY
//  05Feb04 sh  Correct comments

jump = 200;                      // Amount to jump Analog out 0 by
freq = 50;                       // # of ms to switch analog out 1

//--------------------------------------------------------------------------
process ANALOG_INPUTS enabled
    {
    declare hide count;

    print("ao0-1 = analog outputs, do0-3 = digital outputs, di0-2 = digital inputs");
    print("freq = ms to switch analog and digital outputs");
    print("jump = amount to adjust analog outputs by");

    while (1)
        {
        wait 1000;                      // Trigger collection every second
        trigger 1;
        count = count + 1;
        if (count > 10)
            {
            system("hzero *");          // Zero data and start over
            while (system())
                nexttick;
            count = 0;
            }
        }
    }

//--------------------------------------------------------------------------
// Analog output channel 0: Ramp analog out 0 up and down
// You should see a sawtooth wave (levels +/- 2047) 
// when connecting analog out 0 to analog in 0.

process AOUT0 enabled
    {
    declare hide ao0dir = 1;

    while (1)
        {
        ao0_pin9 = ao0_pin9 + ao0dir * jump;
        if (ao0_pin9 < -2047)
            {
            ao0_pin9 = -2047;
            ao0dir = 1;                    // Start going up
            }
        else if (ao0_pin9 > 2047)
            {
            ao0_pin9 = 2047;
            ao0dir = -1;                   // Start going down
            }
        mio_ao_set(0, ao0_pin9);
        nexttick;
        }
    }

//--------------------------------------------------------------------------
// Analog out 1: square wave
// You should see a stair-step waveform with levels at +/-2047, +/- 1024 and 0
// when connecting analog out 1
// to analog in 1

process AOUT1 enabled
    {
    while (1)
        {
        ao1_pin27 = -2047;
        mio_ao_set(1, ao1_pin27);
        wait freq;
        ao1_pin27 = -1024;
        mio_ao_set(1, ao1_pin27);
        wait freq;
        ao1_pin27 = 0;
        mio_ao_set(1, ao1_pin27);
        wait freq;
        ao1_pin27 = 1024;
        mio_ao_set(1, ao1_pin27);
        wait freq;
        ao1_pin27 = 2047;
        mio_ao_set(1, ao1_pin27);
        wait freq;
        }
    }

//--------------------------------------------------------------------------
// Toggle digital outs.
// Digital outs are toggled at twice the freq.
// Digital out 0 and 3 are the same and opposite from 1 & 2.
// You should see square waves when connecting the 4 digital outs
// to 4 analog ins: dig out 0 (pin 23) to ana in 2 (pin 35)
//                  dig out 1 (pin 4)  to ana in 3 (pin 34)
//                  dig out 2 (pin 22) to ana in 4 (pin 33)
//                  dig out 3 (pin 3)  to ana in 5 (pin 32)

process DIGOUT enabled
    {
    do0_pin23 = 0;                      // Initial settings
    do1_pin4  = 1;
    do2_pin22 = 0;
    do3_pin3  = 1;
    while (1)
        {
        mio_dig_set(0, do0_pin23);
        mio_dig_set(1, do1_pin4 );
        mio_dig_set(2, do2_pin22);
        mio_dig_set(3, do3_pin3 );

        wait 2 * freq;

        do0_pin23 = 1 - do0_pin23;      // Toggle 0->1 and 1->0
        do1_pin4  = 1 - do1_pin4 ;
        do2_pin22 = 1 - do2_pin22;
        do3_pin3  = 1 - do3_pin3 ;
        }
    }

//--------------------------------------------------------------------------
// MONITOR DIGITAL INPUTS (ALSO IN STATUS REGISTER)
// Monitor input values for digital inputs.
// Connect a switch to each digital inputs and see that its corresponding
// variable switches between 0 (ground) and 1 (+5v).
// Alternatively, you can connect a digital output to a digital input
// and set freq to slow (i.e, 1000) and the digital input should match
// the digital output.
// NOTE: There are 3 digital inputs available.  Pin 25 is used by the
//  card to control trigger timing and is not available as an input.
//
//      Input line     pin              Output line    pin
//      ----------     ---              -----------    ---
//      0                6              0               23
//      1               24              1                4
//      2                5              2               22
//                                      3                3

process DIGIN enabled
    {
    while (1)
        {
        di0_pin6  = mio_dig_get(0);
        di1_pin24 = mio_dig_get(1);
        di2_pin5  = mio_dig_get(2);
        nexttick;
        }
    }

process LONGTIME
    {
    declare lt = 100;

    while (1)
        {
        i = 0;
        while (i < lt)
            i = i + 1;
        nexttick;
        }
    }
