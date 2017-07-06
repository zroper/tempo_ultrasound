//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

/*  .title  IFUNC.H - Definitions for Installable functions
;+
; DESCRIPTION
;   Definitions for IFUNC module
;
; EDIT HISTORY
;   23Jan07 sh  Initial edit
;   08Apr07 sh  Adapted from sorter's CLASS module
;-
*/
#ifndef IFUNC_H
#define IFUNC_H


//----------------------------------------------------------------
// IFUNC - Data structure common to all installable functions

struct _IFUNC
    {
    long    type;
//#define IFUNCTYPE_THRESHOLD     1
//#define IFUNCTYPE_TEMPLATE      2

    char    name[32];                       // Name of installable function

    long    (*construct)(struct _IFUNC **ppIFunc);    // Constructor
    long    (*destroy)(struct _IFUNC *pIFunc);        // Destructor
    long    (*setParamByName)(struct _IFUNC *pIFunc,  char *value,  char *paramFmt, ...);
    long    (*getParamByName)(struct _IFUNC *pIFunc,  char *value,  long nValue, char *paramFmt, ...);
    long    (*setParamByIndex)(struct _IFUNC *pIFunc, char *value,  long index);
    long    (*getParamByIndex)(struct _IFUNC *pIFunc, char *value,  long nValue, long index);
    long    (*getParamIndex)(struct _IFUNC *pIFunc,   long *pindex, char *paramFmt, ...);
    long    (*execute)(struct _IFUNC *pIFunc, void *pVoid);
    };
    
typedef struct _IFUNC IFUNC;
    
//lint -printf(3,setParamByName);
//lint -printf(4,getParamByName);
//lint -printf(3,getParamIndex);

//----------------------------------------------------------------
// External "user" handle to IFUNCCTRL structure

typedef struct
    {
    void        *p;                         // Opaque handle
    } IFUNCCTRL;


//----------------------------------------------------------------
// Control Shared data structure

#define IFUNC_NTEMPLATES     32             // Max # of registered template functions

typedef struct
    {
    CRITICAL_SECTION    cs;                 // Lock for accessing this structure
    char                *signature;         // = IFUNC_SIGNATURE
    IFUNCCTRL           H;                  // Copy of user's handle
    
    IFUNC               *template[IFUNC_NTEMPLATES]; // Table of registered template IFUNCs
    
    // The slots are a list of pointers to malloc's IFUNC blocks.
    // Each function's constructor allocates its own IFUNC block
    // allowing each function to dedicate additional memory for
    // contextual information beyond what is defined in IFUNC.
    
    long                nSlots;             // # of slots allocated
    IFUNC               **slot;             // Malloc'd List of pointers to malloc'd slots, one for installed functions
    } IFUNCCTRL_;
    


//----------------------------------------------------------------
// Status codes returned by IFUNC functions

#define IFUNCERR_OK                      0  // Successful
#define IFUNCERR_BADTYPE                -1  // Invalid function type
#define IFUNCERR_NOTINIT                -2  // IFUN not initialized
#define IFUNCERR_ALREADYINIT            -3  // IFUN already initialized
#define IFUNCERR_BADSLOT                -4  // Invalid slot number
#define IFUNCERR_IFUNCNOTFOUND          -5  // Function not available
#define IFUNCERR_ALREADYINSTALLED       -6  // Function already installed
#define IFUNCERR_CONSTRUCTORBUG         -7  // Function constructor has a bug
#define IFUNCERR_BADHANDLE              -8  // Invalid handle
#define IFUNCERR_NOMEMORY               -9  // Not enough memory    
#define IFUNCERR_CMDTOOLONG            -10  // Command too long
#define IFUNCERR_PARAMNOTFOUND         -11  // Parameter not found
#define IFUNCERR_INVALIDARG            -12  // Invalid argument to function


#define IFUNCERR_LASTONE        IFUNCERR_INVALIDARG

//----------------------------------------------------------------
// GLOBAL functions

TEMPODLLAPI long ifuncInit(IFUNCCTRL *h, long nSlots);
TEMPODLLAPI long ifuncUninit(IFUNCCTRL *h);

TEMPODLLAPI long ifuncRegister(IFUNCCTRL *h, IFUNC *pTemplate);
TEMPODLLAPI long ifuncUnregister(IFUNCCTRL *h, IFUNC *pTemplate);
TEMPODLLAPI long ifuncGetRegistered(IFUNCCTRL *h, char *name, IFUNC **ppTemplate);

TEMPODLLAPI long ifuncInstall(IFUNCCTRL *h, char *name, long slot);
TEMPODLLAPI long ifuncUninstall(IFUNCCTRL *h, long slot);
TEMPODLLAPI long ifuncGetInstalled(IFUNCCTRL *h, long slot, IFUNC **ppIfunc);

TEMPODLLAPI long ifuncExecute(IFUNCCTRL *H, long slot, void *pVoid);
TEMPODLLAPI long ifuncExecuteAll(IFUNCCTRL *H, void *pVoid);

TEMPODLLAPI long ifuncLock(IFUNCCTRL *H);
TEMPODLLAPI long ifuncUnlock(IFUNCCTRL *H);     //lint -esym(534, ifuncUnlock)

TEMPODLLAPI char *ifuncErr(long ifuncerr);


#endif // ifndef IFUNC_H

