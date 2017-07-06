#include    "tempodll.h"

#define TVMAXITEMSIZE      256          // Maximum size of TV text (including trailing NULL)

TEMPODLLAPI void tvDeleteAll(HWND hTV);
TEMPODLLAPI HTREEITEM tvSetParameter(HWND hTreeView, char *value, char *fmt, ...);
TEMPODLLAPI HTREEITEM tvGetParameter(HWND hTreeView,
                                     char *nakedParam, long nNakedParam,
                                     char *value, long nValue,
                                     char *fmt, ...);

//lint -printf(3,tvSetParameter);
//lint -printf(6,tvGetParameter);

//lint -esym(534, tvGetParameter, tvSetParameter)

#include "tempodlx.h"
