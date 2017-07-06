#ifndef SO_H
#define SO_H

//lint -e537

#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

/*  .title  SO.H - Subject/Observer definitions
*/

#define SOERR_OK            0
#define SOERR_INVALIDSO    -1
#define SOERR_NOMEMORY     -2
#define SOERR_LLERR        -3
#define SOERR_BADARG       -4

#define SOERR_LAST          SOERR_BADARG



#define SOEVENT_ALL         (~0)        // All events


typedef void SO;                        // Handle to SO control block

typedef void SOITEM;                    // Handle to a specific registered item

typedef void (SOCALLBACK)(SO *So, SOITEM *soItem, long eventType, void *context, void *event);



// Subject calls these functions.

TEMPODLLAPI SO *soInit(void);
TEMPODLLAPI long soUninit(SO *So);
TEMPODLLAPI long soNotify(SO *So, long eventType, void *event);


// Observer calls these functions

TEMPODLLAPI long soRegister(SO *So, SOITEM **soItem, SOCALLBACK *soCallback, long eventType, void *context, long nContext);
TEMPODLLAPI long soUnregister(SO *So, SOITEM *soItem);


// Both Subject and Observer functions

TEMPODLLAPI char *soErr(long soerr);

//-------------------------------------------------------------------------

#endif // ifndef SO_H

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above


