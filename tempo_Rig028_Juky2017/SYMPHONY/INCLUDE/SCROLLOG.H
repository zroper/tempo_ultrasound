//lint -e537
#pragma pack(push, 1)                   // 1 byte packing for data structures
#include    "TEMPODLL.H"

#ifndef SCROLLOG_H
#define SCROLLOG_H

#define SCR_NRING         50            // Max # of recent lines in message ring
#define SCR_MSGSIZE      256            // Max # of bytes per line including trailing NULL


//------------------------------------------------------------------
// Status codes returned by functions

#define SCRLOG_OK               0       // Successful
#define SCRLOG_NOMEMORY        -1       // No memory for operation
#define SCRLOG_BADHANDLE       -2       // Invalid handle
#define SCRLOG_CANTOPENFILE    -3       // Error opening log file
#define SCRLOG_CANTOPENWINDOW  -4       // Error opening window



#define SCRLOG_LASTONE      SCRLOG_CANTOPENWINDOW


//------------------------------------------------------------------
// Other threads can set the title of the scrolling window by
// calling SendMessage with this parameter
// Warning: 05Feb07 not fully implemented.

#define WM_SAH_SETTITLE  (WM_USER+2000)  // Our message to set title



//------------------------------------------------------------------
// Declarations

typedef struct                      // SCRLOG user's handle
    {
    void        *p;
    } SCRLOG;
    
typedef struct
    {
    char    buf[SCR_NRING][SCR_MSGSIZE];
    } SCR_RING;

TEMPODLLAPI long scrLogOpenByWin(SCRLOG *h, char *filename, HWND hParentDlg, long dlgCtrl);
TEMPODLLAPI long scrLogClose(SCRLOG *h);
TEMPODLLAPI long scrLogf(SCRLOG *h, char *fmt, ...);  //lint -printf(2,scrLogf)
TEMPODLLAPI long scrLogfx(SCRLOG *h, char *fmt, va_list arg_ptr);
TEMPODLLAPI long scrGetRecentMessages(SCRLOG *h, SCR_RING *pRing);
TEMPODLLAPI char *scrLogErr(long scrlogerr);

//lint -esym(534, scrLogf)


#endif  // SCROLLOG_H

#include "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above

