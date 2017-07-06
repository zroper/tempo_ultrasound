
//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

#ifndef TSC_H
#define TSC_H

#ifndef LONG64_H
    #include    "\lib\gen\long64.h"
#endif
TEMPODLLAPI extern short    isTSCSupported; // 0=Not supported, 1=supported
TEMPODLLAPI extern LONG64   EmpiricalHz;    // CPU cycle rate (Up to 4 Ghz) (empirical)
TEMPODLLAPI extern LONG64   TheoreticalHz;  // Expected Hz (theoretical)

TEMPODLLAPI void CalibrateTSC(LONG64 *pEmpiricalHz, LONG64 *pTheoreticalHz);
TEMPODLLAPI void getTSC(LONG64 *pTsc);


#endif // ifndef TSC_H

//----------------------------------------------------------

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above


