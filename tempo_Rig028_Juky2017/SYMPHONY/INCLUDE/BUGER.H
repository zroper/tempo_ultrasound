//lint -esym(537, tempodll.h)
#include    "tempodll.h"
/*  .title  BUGER.H
;+
; SEE ALSO
;   Rector, p1010 for cute trick that converts __LINE__ to a string at compile time
;
; EDIT HISTORY
;   24Apr02 sh Increase NBGRBUFFER from 128 to 256
;   20Jul09 sh Increase NBGRBUFFER from 256 to 512
;   21Jul09 sh  Declare _BugerDebug with TEMPODLLAPI
;-
*/

#ifndef BUGER_H
#define BUGER_H

#define NBGRBUFFER      512             // # of messages to keep
#define NBGRBUFFERSIZE  128             // Max size of a message including trailing NULL

#define BUGER_MAILSLOT_NAME  "\\\\.\\mailslot\\buggy"  // name of mailslot


extern short ibgrPut;                   // Index of place to put next message
extern char bgrBuffer[NBGRBUFFER][NBGRBUFFERSIZE];  // Ring buffer of messages

TEMPODLLAPI short BugerOpen(char *aName, SYSTEMTIME *pt);
TEMPODLLAPI void _Bugerf(char *fmt, ...);
TEMPODLLAPI short BugerClose(void);
//lint +printf(1, _Bugerf)
//lint -esym(534, BugerOpen, _Bugerf, BugerClose)    Ignore return




// --------------------------------------------------------------------------
// BUGER Debugging

#define BUGERDEBUG  0                   // 1=Include debugging code, 0=exclude debugging code

#if BUGERDEBUG

    #pragma message("BUGER DEBUGGING enabled")
    
    #define NBUGERDEBUGTABLE        4   // Max Number of entries to watch

    typedef struct
        {
        // The following members are set by the application
        // When adding an entry to the table, set the type last.
        // When deleting an entry from the table, first set type=BUGERDEBUG_UNUSED.
        
        long    type;
    #define BUGERDEBUG_UNUSED       0   // This entry is not set
    #define BUGERDEBUG_CHAR         1
    #define BUGERDEBUG_UCHAR        2
    #define BUGERDEBUG_SHORT        3
    #define BUGERDEBUG_USHORT       4
    #define BUGERDEBUG_LONG         5
    #define BUGERDEBUG_ULONG        6
        void    *pValue;                // Pointer to value
        ULONG   minValue;               // Minimum allowable value (actual data type determined by type)
        ULONG   maxValue;               // Maximum allowable value (actual data type determined by type)
        
        
        // The following members are set by BUGER
        // The application should not change these.
        
        long    prevType;               // Copies of previous values
        void    *prevpValue;
        ULONG   prevMinValue;
        ULONG   prevMaxValue;
        
        } BUGERDEBUGTABLE;
        
    extern BUGERDEBUGTABLE BugerDebugTable[NBUGERDEBUGTABLE];
    

    TEMPODLLAPI void  _BugerDebug(char *file, int line);
    #define Bugerf    (_BugerDebug(__FILE__,  __LINE__), _Bugerf)
    
    //// Cute trick to convert a compile-time number like __LINE__ into a string
    //// See Rector, p1010
    //
    //#define CHSTR(x)    #x
    //#define CHSTR2(x)   CHSTR(x)
    ////#define CHMSG(m)    __FILE__ "(" CHSTR2(__LINE__) ")" #m
    //#define CHMSG()    __FILE__ "(" CHSTR2(__LINE__) ")"
    //#undef Bugerf
    //#define Bugerf      (SetThreadState(hpr->threadIndex, CHMSG()), _Bugerf)
    
    
#else
    #define Bugerf (_Bugerf)            // No debugging
#endif

// --------------------------------------------------------------------------



#endif // BUGER_H


#include    "tempodlx.h"

