#include    "tempodll.h"

TEMPODLLAPI char *SysErr(char *buf, long nLen);
TEMPODLLAPI char *formatSysErr(char *buf, long nLen, DWORD err, char *type);

TEMPODLLAPI char *WsaSysErr(char *buf, long nLen);
TEMPODLLAPI char *WsaErrorMessage(long wsaLastError);

//lint -esym(534,SysErr, WsaSysErr)

#include    "tempodlx.h"

