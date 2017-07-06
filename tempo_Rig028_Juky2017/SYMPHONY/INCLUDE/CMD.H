//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

/*  .title  CMD.H Definitions for Command processor
;+
; EDIT HISTORY
;   25Jan07 sh  Initial edit
;-
*/

#ifndef CMD_H
#define CMD_H

//----------------------------------------------------------------
#define CMDERR_OK            0
#define CMDERR_NOOUTPUT     -1
#define CMDERR_CMDTOOLONG   -2
#define CMDERR_TABLEFULL    -3
#define CMDERR_CMDNOTFOUND  -4
#define CMDERR_FUNCERR      -5             // Error returned by CMD function (see outErr)

#define CMDERR_LASTONE      CMDERR_FUNCERR

//----------------------------------------------------------------
// The CMDTABLE type identifies a single entry in a table of commands.
// The final entry of any table must have fcmd==NULL!

typedef struct
    {
    char    *command;                   // Name of command
    long    (*fcmd)(char *output, long nOutput, void *context, char *args);
    } CMDTABLE;


//----------------------------------------------------------------
// FUNCTION DECLARATIONS

TEMPODLLAPI long cmdRegister(CMDTABLE *cmdTable);
TEMPODLLAPI long cmdUnregister(CMDTABLE *cmdTable);

TEMPODLLAPI long cmdf(long *outErr, char *output, long nOutput, void *context, char *fmt, ...);  //lint -printf(3, cmdf)
TEMPODLLAPI long cmdList(long *outErr, char *prefix, char *outputList, long nOutputList, void *context, char *paramList);

TEMPODLLAPI char *cmdErr(long cmderr);

//lint -esym(534,cmdf)



#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above

#endif  // ifndef CMD_H

