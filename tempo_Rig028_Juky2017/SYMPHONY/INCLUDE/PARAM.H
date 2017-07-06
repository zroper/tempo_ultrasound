#include    "tempodll.h"

#define PARAM_MAXPARAM      1024            // Largest parameter, including trailing NULL
#define PARAM_MAXVALUE      2048            // Largest value

#define PARAM_OK                     0
#define PARAM_PARAMETERNOTFOUND     -1
#define PARAM_BADPARAMETERLIST      -2
#define PARAM_PARAMETERTOOBIG       -3 
#define PARAM_FULL                  -4

#define PARAM_LASTONE   PARAM_FULL


TEMPODLLAPI long paramGetNext(char *paramList, char **next, char *param, long nParam, char *value, long nValue);

TEMPODLLAPI long paramGetString(char *paramList, char *string, long nString, char *fmt, ...);
TEMPODLLAPI long paramGetLong(char *paramList, long *lvalue, char *fmt, ...);
TEMPODLLAPI long paramGetShort(char *paramList, short *svalue, char *fmt, ...);
TEMPODLLAPI long paramGetULong(char *paramList, unsigned long *ulvalue, char *fmt, ...);
TEMPODLLAPI long paramGetUShort(char *paramList, unsigned short *usvalue, char *fmt, ...);
TEMPODLLAPI long paramGetUI64(char *paramList, unsigned __int64 *uI64value, char *fmt, ...);
TEMPODLLAPI long paramGetI64(char *paramList, __int64  *I64value, char *fmt, ...);

TEMPODLLAPI long paramClear(char *paramList, long n);
TEMPODLLAPI long paramAppend(char *paramList, long n, char *fmt, ...);
TEMPODLLAPI long paramPrepend(char *paramList, long n, char *fmt, ...);
TEMPODLLAPI long paramDelete(char *paramList, char *fmt, ...);
TEMPODLLAPI long paramAppendUnique(char *paramList, long n, char *fmt, ...);
TEMPODLLAPI long paramAppendList(char *paramListDst, long n, char *paramListSrc);

//lint -printf(4, paramGetString)
//lint -printf(3, paramGetLong)
//lint -printf(3, paramGetShort)
//lint -printf(3, paramGetULong)
//lint -printf(3, paramGetUShort)
//lint -printf(3, paramAppend)
//lint -printf(3, paramPrepend)
//lint -printf(3, paramDelete)
//lint -printf(3, paramAppendUnique)

//lint -esym(534, paramGetNext, paramGetString, paramGetLong, paramGetShort, paramGetULong, paramGetUShort)
//lint -esym(534, paramClear, paramAppend, paramPrepend, paramDelete, paramAppendUnique)
//lint -esym(534, paramAppendList)

TEMPODLLAPI char *paramErr(long paramerr);


#include "tempodlx.h"

