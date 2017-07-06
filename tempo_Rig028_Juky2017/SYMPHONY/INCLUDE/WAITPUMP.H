#ifndef WAITPUMP_H
#define WAITPUMP_H

//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

TEMPODLLAPI long WaitForMutexWithPump(HANDLE hMutex, DWORD timeout);
TEMPODLLAPI extern HWND hWaitPumpModelessDlg;

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above

#endif // ifndef WAITPUMP_H

