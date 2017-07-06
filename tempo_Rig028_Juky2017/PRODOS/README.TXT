                        TEMPO/Dos Sample Protocols
                                July 2001    

The TEMPO\PRODOS directory contains sample protocols that are written
for TEMPO/Dos.

The .PRO file contains the behavioral part of the protocol, written
in the PCL language.  The .CFG file is the TEMPO/Dos protocol
configuration file for the protocol.  The .CFG file is created by
TEMPO/Dos with the CSAVE command.  The protocol is loaded by using
CLOAD to load the .CFG file.

Some of these protocols have a .PCF file which is the TEMPO/Win
protocol configuration file.  TEMPO/Dos dialogs have not been
converted to TEMPO/Win so there are no TEMPO/Win dialogs for
these protocols.


Protocol File           Description
--------------          ----------------------------------------------------------

acquire.pro             Excellent example of a complete protocol
pursue.pro              How to draw multiple, overlapping moving sprites
vio.pro                 Tests for VIO routines with KCV kernel
