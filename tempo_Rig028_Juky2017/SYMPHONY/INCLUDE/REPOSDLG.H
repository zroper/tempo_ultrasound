//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

#ifndef REPOSDLG_H
#define REPOSDLG_H


TEMPODLLAPI void RePositionDialog(HWND hdlg, HWND hwnd);
TEMPODLLAPI void RePositionRect(HWND hdlg, HWND hwnd, RECT r);
TEMPODLLAPI void EraseWindow(HWND hwnd);
TEMPODLLAPI void SetTopMost(HWND hwnd, short flag);

#endif  // ifndef REPOSDLG_H

#include    "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above
