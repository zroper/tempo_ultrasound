/* DACTEST.PRO - Test CIO-DAC-16/12 and other Digital-to-Analog cards
; SYNOPSIS
;
; DESCRIPTION
;   This protocol tests one or more digital-to-analog cards.
;
;   The test consists of sending a sawtooth (ramp) to each
;   DAC.  We reverse the direction between even and odd DACs.
;
; WIRING
;   You must configure the jumpers and switches on the card
;   and define the DAC_BASE parameter in your KERNEL configuration
;   file.  This test assumes you have a CIO-DAC-16/12 (16 12-bit DACs).
;
;   To verify that each DAC is changing, test by connecting each
;   DAC to a scope, voltage meter or an analog input channel.
;
;   If you have a 12 bit DAC, set MAXVALUE=4095.  If you have
;   a 16 bit DAC, set MAXVALUE=65535.
;
;   Also, set MINVOLT and MAXVOLT if you changed from the factory
;   default of +/- 5v.
;
; EDIT HISTORY
;   07Jan00 sh  Initial edit
*/
#pragma declare = 1                     // Force discipline with declarations

declare int nDAC;                       // Number of DACs
declare int value;                      // Current output DAC units [0..MAXVALUE-1]
declare float valueVolt;                // Equivalent voltage
declare int otherValue;                 // =MAXVALUE-value
declare int direction = 1;              // Direction to move +1 or -1
declare int noise = 0;                  // =0 no sound, =1 sound
declare int scanChannel = 0;            // A channel number [0..nDAC-1] to scan

declare constant MAXVALUE = 4095;       // =4095 (12bit) =65535 16-bit DACs
//declare constant MAXVALUE = 65535;       // =4095 (12bit) =65535 16-bit DACs

declare constant float MINVOLT = -5.00; // Minimum voltage (=0 DAC value)
declare constant float MAXVOLT =  5.00; // Max voltage (=MAXVALUE-1 DAC value)

// DECLARE PROCESSES

DECLARE MAIN(), SCAN(), SetDacChannel(int channel, int value);
DECLARE SETDACS(), GetAll();

//---------------------------------------------------------------------
process MAIN() enabled
{
nDAC = dacGet();                        // Get number of DAC channels
printf("There are %d DACs available.\n", nDAC);
systemf("dialog DACTest\n");            // Display dialog
}

//---------------------------------------------------------------------
process SCAN()
{
while (nDAC > 0)                        // Always true or nDAC=0 if none
    {
    value = value + direction;          // Advance one analog unit
    if (value > MAXVALUE)
        {
        value = MAXVALUE - 1;           // Don't go higher than MAXVALUE
        direction = -1;
        }
    else if (value < 0)                 // Don't go lower than 0
        {
        value = 1;
        direction = 1;
        }
        
    if (noise)        
        sound(value);                   // Now for a little night music..
    else
        sound(0);

    spawn SetDacChannel(scanChannel, value);
        
    nexttick;
    }
printf("Test complete.\n");
}

//---------------------------------------------------------------------
// SETDACS - Set all DACs to value

process SETDACS()
{
    int     channel;
    
suspend SCAN;
    
channel = 0;
while (channel < nDAC)
    {
    spawn SetDacChannel(channel, value);
    channel = channel + 1;
    }
}


//---------------------------------------------------------------------
// SetDacChannel - Set a DAC channel with a DAC unit
// Also computes valueVolt and insures that v is within range.
//
// IN
//      channel         A DAC channel number [0..15]
//      v               A new DAC value [0..MAXVALUE]
// OUT
//      value           Updated with new value
//      valueVolt       Updated with new voltage
//      DAC channel is updated with new value

process SetDacChannel(int channel, int v)
{
    int constant VoltageRange = MAXVOLT - MINVOLT;
    
// In order to convert DAC value [0..MAXVALUE] to volts,
// we need to know the gain and polarity for each DAC on the
// card.  This information is not available by querying the
// card so we make some assumptions here about how the
// card is configured.  We assume that each DAC is configured
// for +/-5v.  So DAC value of 0 is -5v and a DAC value of
// MAXVALUE-1 is +5v.
//
// Since v can be any integer, we insure it is within valid limits
// for our particular card.

if (v < 0)                      // Insure value is within limits
    v = 0;
else if (v > MAXVALUE)
    v = MAXVALUE;
    
value = v;                      // Reset global variable

valueVolt = MINVOLT + ( (float(value % (MAXVALUE+1)) / MAXVALUE) * VoltageRange);
dacSet(channel, value);         // Load value into DAC channel
}

//---------------------------------------------------------------------
// GetAll - Read all DAC registers (up to 16).
// On the CIO-DAC-16/12, all return values are 65,535.
// Other DAC cards may support returning the current DAC setting, however.
// But dacGet() is still useful for triggering simultaneous update (XFER)
// even though the return value isn't apparently very useful.

declare Analog[16];             // Values returned by dacGet()

process GetAll()
{
    int     n, c;

if (nDAC > 16)
    n = 16;
else
    n = nDAC;
    
c = 0;
while (c < n)
    {
//    Analog[c] = dacGet(c);
    c = c + 1;
    }
}