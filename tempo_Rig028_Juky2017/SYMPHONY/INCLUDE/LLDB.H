#ifndef LLDB_H
#define LLDB_H

//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

/*  .title  LLDB.H - Definitions for LLDB package
;+
; EDIT HISTORY
;   29Mar07 sh  initial edit
;-
*/

#define LLDBERR_OK           0      // LLDB Successful

// Start our error codes after the last LLERR code.

#define LLDBERR_BASE        LLERR_LASTONE

#define LLDBERR_NOTINIT     (LLDBERR_BASE-1)  // LLDB Control block not initialized
#define LLDBERR_BADARG      (LLDBERR_BASE-2)  // LLDB Invalid argument
#define LLDBERR_NOMEMORY    (LLDBERR_BASE-3)  // LLDB No memory


#define LLDBERR_LASTONE     LLDBERR_NOMEMORY

typedef struct
    {
    void    *p;
    } LLDB;
    

TEMPODLLAPI long lldbOpen(LLDB *plldb, long nFree);
TEMPODLLAPI long lldbClose(LLDB *plldb);
TEMPODLLAPI long lldbReset(LLDB *plldb);
TEMPODLLAPI long lldbAdd(LLDB *plldb, void *pData, long nBytes);
TEMPODLLAPI long lldbPruneTail(LLDB *plldb, long nPrune);
TEMPODLLAPI long lldbGetHead(LLDB *plldb, LINKHEAD **ppll, LINKNODE **ppItem, long *nItems);
TEMPODLLAPI char *lldbErr(long lldberr);



#include    "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above


#endif  // ifndef LLDB_H

