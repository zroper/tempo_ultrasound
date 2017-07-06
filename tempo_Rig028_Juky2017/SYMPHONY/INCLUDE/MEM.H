//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

#ifndef MEM_H
#define MEM_H


TEMPODLLAPI long memGrow(void **ppbuf, long *curSize, long newSize);
TEMPODLLAPI unsigned long memSize(void *pbuf);
TEMPODLLAPI void memFree(void *pbuf);


#endif  // ifndef MEM_H

#include    "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above
