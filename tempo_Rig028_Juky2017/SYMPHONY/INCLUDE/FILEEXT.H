#include    "tempodll.h"

TEMPODLLAPI char *fileext(char *, char *, char *, short);
TEMPODLLAPI char *removeExt(char *infile, char *outfile, short len);
TEMPODLLAPI char *FileName(char *path);
TEMPODLLAPI char *FileExt(char *path);

//lint -esym(534,fileext)               ok to ignore return
//lint -esym(534,removeExt)             ok to ignore return

#include "tempodlx.h"


