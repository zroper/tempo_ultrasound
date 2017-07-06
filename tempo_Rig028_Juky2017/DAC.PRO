/*  .title DAC.PRO - Definitions for use with the Analog Output TEMPO Driver.
;+
; DESCRIPTION
;   Include this file in your protocol if you use the DAC (Digital to Analog Converter)
;   driver.
;
;   It defines constants for use with the dacXXX() PCL functions.
;
; EDIT HISTORY
;   11Sep04 sh  Initial edit
;-
*/

// The following constants are used in the dacConfig() function. They
// are used to set the Gain/Range for a particular DAC (Digital to
// Analog Converter). For ISA based boards, the Gain/Range is set with
// jumpers and switches on the board. For PCI-DDA boards, Gain/Range is
// set with a call to the dacConfig() PCL function using these
// constants.

int constant DACCONFIG_DEFAULTRANGE =0;     // Range for dacConfig:    0v to  10v
int constant DACCONFIG_BIPOLAR10V   =1;     // Range for dacConfig:  -10v to  10v
int constant DACCONFIG_BIPOLAR5V    =2;     // Range for dacConfig:   -5v to   5v 
int constant DACCONFIG_BIPOLAR2_5V  =3;     // Range for dacConfig: -2.5v to 2.5v 
int constant DACCONFIG_UNIPOLAR10V  =4;     // Range for dacConfig:    0v to  10v 
int constant DACCONFIG_UNIPOLAR5V   =5;     // Range for dacConfig:    0v to   5v 
int constant DACCONFIG_UNIPOLAR2_5V =6;     // Range for dacConfig:    0v to 2.5v 

int constant hex DACCONFIG_SU       = 0x80; // Simultaneous update DAC ('OR' with other DACCONFIG_ bits)

// If you want two or more DACs to update simultaneously, "OR" (|) in
// the DACCONFIG_SU bit with any of the above range constants in the
// call to dacConfig().  The DAC will then update when the other SU
// marked DACs update (see dacSimulUpdate()).  For example, to set DAC0
//and DAC1 for simultaneous update:
// 
//     dacConfig(0, DACCONFIG_BIPOLAR10V | DACCONFIG_SU);
//     dacConfig(1, DACCONFIG_BIPOLAR5V  | DACCONFIG_SU);
//     ..
//     dacSet(0, 0x40);        // Loads DAC0 (actual output voltage doesn't change yet)
//     dacSet(1, 0x50);        // Loads DAC1 (actual output voltage doesn't change yet)
//     ..
//     dacSimulUpdate();       // Updates both DAC0 and DAC1 simultaneously (changes output voltages)
// 
//To unset a DAC for Simultaneous Update, call dacConfig() without OR-ing DACCONFIG_SU.
// 
//     dacConfig(0, DACCONFIG_BIPOLAR10V);
//     dacConfig(1, DACCONFIG_BIPOLAR5V);
//     ..
//     dacSet(0, 0x40);        // Loads DAC0 (actual output voltage changes immediately)
//     dacSet(1, 0x50);        // Loads DAC1 (actual output voltage changes immediately)


// The following constants define the maximum and median output DAC values for 16-bit
// and 12-bit DACs. The minimum output DAC value is 0.

int constant hex DAC16_MAXVALUE     = 0xFFFF;        // Maximum 16-bit DAC value
int constant hex DAC12_MAXVALUE     = 0xFFF;         // Maximum 12-bit DAC value

int constant hex DAC16_MIDVALUE     = 0x8000;        // Median 16-bit DAC value
int constant hex DAC12_MIDVALUE     = 0x800;         // Median 12-DAC value

