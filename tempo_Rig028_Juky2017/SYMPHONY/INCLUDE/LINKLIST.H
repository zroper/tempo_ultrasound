#ifndef LINKLIST_H
#define LINKLIST_H

//lint -e537
#include    "tempodll.h"
/*  .title  LINKLIST.H - Definitions for managing link lists
;+
; EDIT HISTORY
;   28May06     Obsolete the old functions and structure and add the new ones.
;   05Sep06     Add LLERR_BADARG
;   30Mar07 sh  Add pUserDefined to LINKNODE
;   11Dec07 sh  Add LLERR_NOTINIT and LINKHEAD.isInitalized
;   15Apr08 sh  Add signature and LLSIGNATURE test for valid LINKHEAD BLOCK
:-
*/

typedef struct _LINKNODE
    {
    struct _LINKNODE    *next;          // Points to next in chain (NULL if tail)
    struct _LINKNODE    *prev;          // Points to prev in chain (NULL if head)
    
    void                *pUserDefined;  // A user-defined value
    
    // The following values are used by LINKLIST if LINKLIST allocates
    // heap memory for the item's buffer.  If this is not done, these
    // values can be used by the user.
    
    void                *p;             // Pointer to buffer
    long                nBytes;         // Number of bytes allocated for buffer
    } LINKNODE;


typedef struct
    {
    LINKNODE            *head;          // Points to head in chain
    LINKNODE            *tail;          // Points to tail of chain
    char                isCS;           // ==1 iff cs is defined
    char                unused[3];      // Unused values
    unsigned long       signature;      // =LL_SIGNATURE iff LINKHEAD is initialized
#define LLSIGNATURE     0xFADEC0DE      // LinkList's unique signature
    long                count;          // # of nodes in list
    CRITICAL_SECTION    cs;             // For synchronized access to this chain
    } LINKHEAD;

#define LLERR_OK             0          // Successful
#define LLERR_NOLOCK        -1          // Lock not initialized
#define LLERR_LOCKFAILED    -2          // Failed to lock list
#define LLERR_NOMEMORY      -3          // Failed to allocate memory
#define LLERR_NOTFOUND      -4          // Item not found
#define LLERR_BADARG        -5          // Invalid argument
#define LLERR_NOTINIT       -6          // link list not initialized

#define LLERR_LASTONE   LLERR_NOTINIT


TEMPODLLAPI long llNewList(LINKHEAD  *ll, short flag);
TEMPODLLAPI long llReleaseListUnlink(LINKHEAD *ll);
TEMPODLLAPI long llReleaseList(LINKHEAD *ll);
TEMPODLLAPI long llReleaseListFree(LINKHEAD *ll);
TEMPODLLAPI long llIsInitialized(LINKHEAD *ll);


TEMPODLLAPI long llCount(LINKHEAD *ll);
TEMPODLLAPI long llLock(LINKHEAD *ll);
//long llTryLock(LINKHEAD *ll);
TEMPODLLAPI long llUnlock(LINKHEAD *ll);
TEMPODLLAPI long llDeleteAll(LINKHEAD *ll);
TEMPODLLAPI long llDeleteAllFree(LINKHEAD *ll);

TEMPODLLAPI long llNewHead(LINKHEAD *ll, void *p, long nBytes);
TEMPODLLAPI long llNewTail(LINKHEAD *ll, void *p, long nBytes);
TEMPODLLAPI long llNewHeadAlloc(LINKHEAD *ll, void **p, long nBytes, void *buf);
TEMPODLLAPI long llNewTailAlloc(LINKHEAD *ll, void **p, long nBytes, void *buf);
TEMPODLLAPI long llIsValue(LINKHEAD *ll, void *p);
TEMPODLLAPI long llDeleteValue(LINKHEAD *ll, void *p);
TEMPODLLAPI long llDeleteValueFree(LINKHEAD *ll, void *p);

TEMPODLLAPI long llLinkNodeHead(LINKHEAD *ll, LINKNODE *pn);
TEMPODLLAPI long llLinkNodeTail(LINKHEAD *ll, LINKNODE *pn);
TEMPODLLAPI long llUnlinkNode(LINKHEAD *ll, LINKNODE *pn);
TEMPODLLAPI long llUnlinkAll(LINKHEAD *ll);

TEMPODLLAPI LINKNODE *llGetNode(LINKHEAD *ll, void *p);
TEMPODLLAPI LINKNODE *llGetHeadNode(LINKHEAD *ll);
TEMPODLLAPI LINKNODE *llGetTailNode(LINKHEAD *ll);
TEMPODLLAPI LINKNODE *llGetNextNode(LINKHEAD *ll, LINKNODE *n);
TEMPODLLAPI LINKNODE *llGetPrevNode(LINKHEAD *ll, LINKNODE *n);
TEMPODLLAPI LINKNODE *llGetIthNodeFromHead(LINKHEAD *ll, long i);
TEMPODLLAPI LINKNODE *llGetIthNodeFromTail(LINKHEAD *ll, long i);

TEMPODLLAPI long llDeleteNode(LINKHEAD *ll, LINKNODE *n);
TEMPODLLAPI long llDeleteNodeFree(LINKHEAD *ll, LINKNODE *n);

TEMPODLLAPI long llSplitFromHead(LINKHEAD *ll, long n, LINKHEAD *llNew, short flag);
TEMPODLLAPI long llSplitFromTail(LINKHEAD *ll, long n, LINKHEAD *llNew, short flag);
TEMPODLLAPI long llMergeListToHead(LINKHEAD *ll, LINKHEAD *llhead);
TEMPODLLAPI long llMergeListToTail(LINKHEAD *ll, LINKHEAD *lltail);

TEMPODLLAPI char *llErr(long llerr);


// OBSOLETED (28May06) Data structure

typedef struct _LINKLIST
    {
    struct _LINKLIST  *next;            // First, if this is head
    struct _LINKLIST  *prev;            // Last, if this is head
    } LINKLIST;

// OBSOLETED (28May06) Functions
// 22Dec07 Added to TEMPODLLAPI for malloc.c

TEMPODLLAPI void LLUnlink(LINKLIST *l, LINKLIST *entry);
TEMPODLLAPI void LLAddEnd(LINKLIST *l, LINKLIST *entry);


#include    "tempodlx.h"


#endif // ifndef LINKLIST_H

