//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

#ifndef PARSELST_H
#define PARSELST_H

TEMPODLLAPI long parseNamedList(char *input, char *parens, char *name, long nName, char *paramList, long nList);

#endif  // ifndef PARSELST_H

#include    "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above



