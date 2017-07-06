//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

#ifndef LINEAR_H
#define LINEAR_H


TEMPODLLAPI double linearA2B(double a, double amin, double amax, double bmin, double bmax);
TEMPODLLAPI double linearA2BClip(double a, double amin, double amax, double bmin, double bmax);

//-------------------------------------------------------------------------

#endif // ifndef LINEAR_H

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above

