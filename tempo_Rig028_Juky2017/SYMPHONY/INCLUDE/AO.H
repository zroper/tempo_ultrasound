//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

/*  .title  AO.H - Definitions for Active Objects
;+
; EDIT HISTORY
;   15Dec07 sh  Initial edit
;-
*/

#ifndef AO_H
#define AO_H

#ifndef SO_H
    #include    "so.h"
#endif


//------------------------------------------------------------

#define AO_FIRST        1               // First valid aoNum (1-based)

//------------------------------------------------------------
// AOBJ - Information kept per object

typedef struct
    {
    char        *object;                // malloc'd copy of object
    long        nBytes;                 // bytes used
    long        nAllocated;             // bytes allocated
    } AOBJ;
    

//------------------------------------------------------------
// AOCTRL - Control block (handle) for a set of active objects

typedef void (*AOLOGF)(char *fmt, ...);

typedef struct
    {
    char        isInitialized;          // ==1 if initialized
    char        unused[3];
    
    CRITICAL_SECTION    cs;             // Critical section access
    
    long        nObjects;               // # of objects
    AOBJ        *objects;               // malloc'd table of AOBJs
    
    struct _SO  *so;                    // List of observers
    
    unsigned long nUpdates;             // # of calls to aoSet
    } AOCTRL;


//------------------------------------------------------------
// SOEVENT Notifications.
// The event number to attach to is the object number [1..nObjects].
// All activities related to that object result in the AO package
// sending (soNotify) an AO_SOEVENT_NOTIFY event.

typedef struct _AO_SOEVENT_NOTIFY
    {
    AOCTRL      *aoc;                   // Pointer to AOCTRL block
    long        type;                   // Reason for update
#define AO_TYPE_CHANGE    1             // An object changed
#define AO_TYPE_CLOSE     2             // AOCTRL is being closed

    long        iObject;                // Object number [1..nObjects]
    
    // New object buffer
    
    void        *object;                // Pointer to object buffer
    long        nBytes;                 // # of bytes in object
    
    } AO_SOEVENT_NOTIFY;



//------------------------------------------------------------
// Status return codes

#define AOERR_OK                0       // Successful
#define AOERR_BADARG           -100     // Invalid argument
#define AOERR_NOTINIT          -200     // AOCTRL not initialized
#define AOERR_SOERR            -300     // An SOERR occurred
#define AOERR_NOMEMORY         -400     // No memory available

#define AOERR_LAST      AOERR_NOMEMORY


//------------------------------------------------------------
// Function prototypes

TEMPODLLAPI AOCTRL *aoOpen(long nObjects);
TEMPODLLAPI long aoGet(AOCTRL *aoc, long aoNum, void *buf, long nBuf);
TEMPODLLAPI long aoSet(AOCTRL *aoc, long aoNum, void *buf, long nBuf);
TEMPODLLAPI long aoRegister(AOCTRL *aoc, long aoNum, SOITEM **soItem, SOCALLBACK soCallback, void *context, long nContext);
TEMPODLLAPI long aoUnregister(AOCTRL *aoc, SOITEM *soItem);
TEMPODLLAPI long aoClose(AOCTRL *aoc);
TEMPODLLAPI char *aoErr(long aoerr);
TEMPODLLAPI AOLOGF aoSetLogf(AOLOGF f);



//-------------------------------------------------------------------------
#endif  // ifndef AO_H


#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above
