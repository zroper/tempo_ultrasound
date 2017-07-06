//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

#ifndef BINSEARC_H
#define BINSEARC_H

TEMPODLLAPI long binsearch(void *key, void *base, long num, long width, long (*compare)(void *, void *));



#endif // ifndef BINSEARC_H

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above

