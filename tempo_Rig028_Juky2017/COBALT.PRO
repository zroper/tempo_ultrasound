/*  .title  COBALT.PRO  Declarations for COBALT
;+
; DESCRIPTION
;   This file contains definitions and declarations for use with COBALT.
;   It should be #included in any protocol that needs to access information
;   from one or more COBALT systems.
;
;   Because TEMPO supports multiple COBALT systems, most values are
;   indexed by the COBALT system number.  COBALT system numbers start
;   at '1' but these arrays are based starting at '0'.  So your COBALT 1
;   system will be the zeroth array index.  For example, cobaltTick[0]
;   is the tick time of the last CHT (see below) processed by COBALT
;   system # 1.
;
; EDIT HISTORY
;   29Sep05 sh  Initial edit
;-
*/

declare int constant NCOBALTS   =   8;     // Max number of cobalt systems



// Cobalt systems are numbered 1,2, .., NCOBALTS
// But we use a 0-based index to access these arrays.
// So you can use COBALT1, COBALT2, ... instead of constants 0,1,2..
// when accessing these COBALT arrays.

declare int constant COBALT1    =   0;
declare int constant COBALT2    =   1;
declare int constant COBALT3    =   2;
declare int constant COBALT4    =   3;
declare int constant COBALT5    =   4;
declare int constant COBALT6    =   5;
declare int constant COBALT7    =   6;
declare int constant COBALT8    =   7;

declare int constant NCOBALTDBS = 255;     // Max number of databases per cobalt system



// Each COBALT client receives TRIGGERs, CANCEL and HARVESTs (CHT)
// from the TEMPO protocol.  Each COBALT client uses this information
// to build its databases.
//
// At the time a CHT is is created (by your protocol), it is stamped
// with the TEMPO tick time (see PCL's tick() function).
//
// Each COBALT client updates its cobaltTick[] value with the tick time
// of the CHT after the CHT is processed.
//
// You can compare this value with TEMPO's tick() count to determine if
// the COBALT system has processed all CHTs up to a particular point in time.
// This is especially useful when the protocol wants to wait for all CHTs
// before sending the HSAVE command to the COBALT client.

declare int cobaltTick[NCOBALTS];



// Each COBALT system supports a number of databases.
// The cobaltDBnEpochs[.,.] contain the current number of accumulated
// epochs on each COBALT system's databases.
// This is especially useful when the protocol wants to wait for all CHTs
// before sending the HSAVE command to the COBALT client.

declare int cobaltDBnEpochs[NCOBALTS, NCOBALTDBS];



// Each COBALT system maintains a count of the number of triggers
// in its pending trigger request queue (PTRQ) for each database it
// has defined.
//
// The cobaltDBnPending[.,.] contain the current number of pending
// triggers for each COBALT database.
// This is especially useful when the protocol wants to wait for all CHTs
// before sending the HSAVE command to the COBALT client.

declare int cobaltDBnPending[NCOBALTS, NCOBALTDBS];


