#include    "tempodll.h"

#ifndef FIO_H
#define FIO_H
TEMPODLLAPI extern short FIOSetMaxLine(short maxline);
TEMPODLLAPI extern long FIOWriteBufToFilename(char *filename, char *buf, long nBytes, short spaces, short flag);
TEMPODLLAPI extern long FIOWriteStrToFilename(char *filename, char *fmt, ...);
TEMPODLLAPI extern long FIOWriteBufToFileid(FILE *fid, char *buf, long nBytes, short spaces);
TEMPODLLAPI extern long FIOReadBufFromFilename(char *filename, char *buf, long nBytes);
TEMPODLLAPI extern long FIOReadBufFromFileid(FILE *fid, char *buf, long nBytes);

#define FIO_NEWLINE     0x1             // Add \n at the end
#define FIO_APPEND      0x2             // Append instead of overwriting existing file
#define FIO_REMOVE      0x4             // If file exists, remove it and recreate it

//lint -esym(534,FIOSetMaxLine)         Ignore return value ok
//lint -esym(534,FIOWriteBufToFileid)   Ignore return value ok
//lint -esym(534,FIOWriteStrToFilename)   Ignore return value ok
//lint +printf(2, FIOWriteStrToFilename)

#endif /* ifndef FIO_H */


#include "tempodlx.h"

