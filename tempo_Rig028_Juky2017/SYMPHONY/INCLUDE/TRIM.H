#include    "tempodll.h"

TEMPODLLAPI char *trim(char *, short);
TEMPODLLAPI char *SkipWhite(char *);
TEMPODLLAPI short GetString(char *in, char *out, short len);
TEMPODLLAPI short GetWord(char *p, char *buf, short n);
TEMPODLLAPI void ConvertCharToChar(char *string, char cFrom, char cTo);
TEMPODLLAPI char *SkipDelim(char *input, char *delims);
TEMPODLLAPI long GetToken(char *input, char *delims, char *token, long tokenLen);
TEMPODLLAPI long trimrzero(char *s);
TEMPODLLAPI long explode(char *input, char *delim, long nFields, char **av);


//lint -esym(534,trimrzero)         // OK to ignore return value

#include    "tempodlx.h"




