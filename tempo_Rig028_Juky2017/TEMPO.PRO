/*  .title  TEMPO.PRO - Standard definitions for use with TEMPO
** Copyright 2000-2002 Reflective Computing.  All rights reserved.
**
** SYNOPSIS
**  #include "tempo.pro"
**
** DESCRIPTION
**  This protocol file defines standard constants used by TEMPO
**  functions.
**
** EDIT HISTORY
**  10 Aug 96   sh  Add process states
**  04 Sep 97   sh  Add definitions for GetSystemInfo()
**  08 Jul 99   sh  Add GSI_ASETS, GSI_SPEED, GSI_SPEED_UNITS, GSI_PROCESSES and GSI_DATABASES
**  13 Oct 99   sh  Add GSI_TIO1600P and GSI_TIO6400P
**  05 May 00   sh  Add GSI_ANALOGINRESOLUTION
**  12 Jul 00   sh  Add GSI_PCIDAS* and GSI_PCIDIO*
**  22 Sep 01   sh  ADD GSI_PCICTR9513
**  12 Mar 03   sh  Add GSI_CURRENTPROCESSID
*/

declare constant hide PROCESS_NOTEXIST       =  0; // Process doesn't exist
declare constant hide PROCESS_SUSPENDED      =  1; // Process is suspended
declare constant hide PROCESS_RUNNING        =  2; // Process is running
declare constant hide PROCESS_DONE           =  3; // Process is done

// Definitions for GetSystemInfo()

declare constant hide GSI_ATMIO16            =  1; // 1=at-mio-16 is present
declare constant hide GSI_DAS1600            =  2; // 1=cio-das-160X is present
declare constant hide GSI_DAS8               =  3; // 1=cio-das8 is present
declare constant hide GSI_DAS1200            =  4; // 1=cio-das1200/1400/1600 is present
declare constant hide GSI_FAKEMIO            =  5; // 1=Fake MIO is present
declare constant hide GSI_PCTIO10            =  6; // 1=pc-tio-10 is present
declare constant hide GSI_8254               =  7; // 1=c8254 is present
declare constant hide GSI_FAKETIO            =  8; // 1=Fake TIO is present
declare constant hide GSI_SET                =  9; // Kernel Set number
declare constant hide GSI_KERNELVERSION      = 10; // Kernel version number
declare constant hide GSI_KERNELRELEASE      = 11; // Kernel release number
declare constant hide GSI_MOUSE              = 12; // 1=mouse is present
declare constant hide GSI_ASETS              = 13; // ASETS in kernel cfg
declare constant hide GSI_SPEED              = 14; // Speed (Hz)=SPEED_UNITS/SPEED
declare constant hide GSI_SPEED_UNITS        = 15; // Units of speed (1/SPEED_UNITS)
declare constant hide GSI_PROCESSES          = 16; // PROCESSES in kernel cfg
declare constant hide GSI_DATABASES          = 17; // DATABASES in kernel cfg
declare constant hide GSI_TIO1600P           = 18; // TIO1600+ driver is present
declare constant hide GSI_TIO6400P           = 19; // TIO6400+ driver is present
declare constant hide GSI_ANALOGINRESOLUTION = 20; // Analog input resolution (in bits) (0=unknown, 8, 12 or 16)
declare constant hide GSI_PCIDAS1602_12      = 21; // pci-das-1602/12 is present
declare constant hide GSI_PCIDAS1602_16      = 22; // pci-das-1602/16 is present
declare constant hide GSI_PCIDIO24CTR3       = 23; // pci-dio24/ctr3 is present
declare constant hide GSI_PCIDIO48CTR15      = 24; // pci-dio48/ctr15 is present
declare constant hide GSI_PCICTR9513         = 25; // PCICTR9513 driver is present
declare constant hide GSI_CURRENTPROCESSID   = 26; // Get current process ID =[1..PROCESSES]