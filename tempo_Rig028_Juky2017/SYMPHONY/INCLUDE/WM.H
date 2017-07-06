#ifndef WM_H
#define WM_H                        // Define only once


//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

TEMPODLLAPI char *wm(unsigned int iMsg);
TEMPODLLAPI char *en(int notificationCode);
TEMPODLLAPI char *cbn(int notificationCode);   // CBN_xxx  COMBOBOX notification
TEMPODLLAPI char *lbn(int notificationCode);   // LBN_xxx  LISTBOX notification
TEMPODLLAPI char *bn(int notificationCode);    // BN_xxx   BUTTON notification


//----------------------------------------------------------

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above

#endif // ifndef WM_H

