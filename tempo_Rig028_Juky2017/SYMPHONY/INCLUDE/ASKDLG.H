#ifndef ASKDLG_H
#define ASKDLG_H

//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

//---------------------
// Global function declarations


TEMPODLLAPI long askDlg(HWND hParent, RECT *r, char *input, char *output, long nOutput);


//---------------------
// Status return codes

#define ASKDLG_OK            0      // Successful (user hit RETURN)
#define ASKDLG_NOOUTPUT     -100    // output buffer is invalid
#define ASKDLG_CANCEL        1      // Successful (user hit ESC)




//-------------------------------------------------------------------------

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above



//-------------------------------------------------------------------------
#endif  // ifndef ASKDLG_H

