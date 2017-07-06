#ifndef GETTIME_H
#define GETTIME_H

//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"


TEMPODLLAPI long getTime(long starttime);

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above

#endif  // ifndef CMD_H

