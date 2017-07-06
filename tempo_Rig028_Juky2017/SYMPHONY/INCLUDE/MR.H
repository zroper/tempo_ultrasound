/*  .title  MR.H    Message Handling definitions
;+
; EDIT HISTORY
;   17Aug07 sh  Initial edit
;-
*/
#ifndef MR_H
#define MR_H

//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"


#define MR_NREGISTERED      16      // Max # of registered message handlers

//----------------------------------------------------------
// Caller's message handler looks like this

typedef LRESULT (*MRMSGHANDLER)(struct _MR *mr, long *wasHandled,
                   HWND hwnd, UINT iMsg, WPARAM wParam, LPARAM lParam);


//----------------------------------------------------------

typedef struct _MR
    {
    HWND        hwnd;               // HWND currently hooked
    
    long        iSelected;          // Index to selected handler (-1 if none)
    
    MRMSGHANDLER    registered[MR_NREGISTERED]; // List of registered handlers
    
    // Original WinProc for HWND
    
    void        *originalWinProc;
    } MR;



//----------------------------------------------------------
// MR return codes

#define MR_OK            0          // Successful
#define MR_BADMR        -1          // Invalid MR
#define MR_BADHWND      -2          // Invalid HWND
#define MR_FULL         -3          // No more control blocks
#define MR_NOTREGISTERED -4         // message handler is not registered
#define MR_BADHANDLER   -5          // invalid handler

#define MR_LASTONE      MR_BADHANDLER



//----------------------------------------------------------

TEMPODLLAPI long mrCreate(MR **pmr, HWND hwnd);
TEMPODLLAPI long mrRegisterHandler(MR *mr, MRMSGHANDLER fMsgHandler);
TEMPODLLAPI long mrSelectHandler(MR *mr, MRMSGHANDLER fMsgHandler);
TEMPODLLAPI long mrDestroy(MR *mr);
TEMPODLLAPI char *mrErr(long mrerr);

//----------------------------------------------------------

#include "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above


#endif  // ifndef MR_H

