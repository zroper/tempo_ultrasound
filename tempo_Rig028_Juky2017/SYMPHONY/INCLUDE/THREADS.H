#pragma pack(push, 1)
#include    "TEMPODLL.H"
/* .title   THREADS.H - Thread Management
;+
; EDIT HISTORY
;   24Jan04 sh  Increase NTCB from 15 to 25 (for CCQ)
;   28Jan04 sh  Add StartThreadEx
;   19Apr06 sh  Moved to lib32 and generalized Bugerf, and MessagePump calls
;               added THR_BUGERFFUNCTION
;   21Dec06 sh  Adapt for SYMPHONY's DLL
;   12Nov07 sh  Added SetKillThreadEventHandle
;   20Jan08 sh  Add THR_CANTSUICIDE and modify StopThread to test this.
;-
*/

#define THR_OK               0          // No errors
#define THR_TOOMANY         -1          // Too many threads
#define THR_BADSTART        -2          // Error starting thread
#define THR_BADINDEX        -3          // Bad thread index
#define THR_TERMINATED      -4          // Was forced to terminate thread
#define THR_NOTFOUND        -5          // Thread id not found
#define THR_BADBUF          -6          // No buffer specified
#define THR_NOSUICIDE       -7          // Thread attempted suicide

#define THR_LASTONE         THR_NOSUICIDE


typedef unsigned (__stdcall THREADFCN) (void *);

#define NTCB     25                     // Max # of threads supported

typedef struct
    {
    char        name[80];               // Thread name
    THREADFCN   *ThreadFcn;             // Entry point of thread
    HANDLE      hThread;                // Process network notifications
    DWORD       ThreadID;               // Thread ID from CreateThread
    short       KillFlag;               // Thread queries this to terminate
    char        State[80];              // Last thread state
    unsigned short RunCount;            // # of times state has changed
    HANDLE      hEvent;                 // Event handle to signal when Killing thread
    HWND        hwnd;                   // if not-NULL, Post a message to HWND to kill
    long        wmCommand, wParam, lParam; // WM_xxx message to post to HWND
    } TCB;
    
typedef void (*THR_BUGERFCALLBACK)(char *fmt, ...);        //lint -printf(1, THR_BUGERFCALLBACK)
typedef void (*THR_MESSAGEPUMPCALLBACK)(char *);    

TEMPODLLAPI void InitThread(void);
TEMPODLLAPI short StartThread(THREADFCN *ThreadFcn, char *name, void *parg);
TEMPODLLAPI short StartThreadEx(THREADFCN *fcn, char *name, void *parg, short dupFlag);
TEMPODLLAPI short StopThread(short t);
TEMPODLLAPI short GetKillFlag(short t);
TEMPODLLAPI short GetThreadState(short t, char *buf, short n);
TEMPODLLAPI char *GetThreadErr(short err);
TEMPODLLAPI short GetThreadNum(unsigned int threadID);
TEMPODLLAPI short SetKillThreadEventHandle(short t, HANDLE hEvent);
TEMPODLLAPI short SetKillThreadHWND(short t, HWND hwnd, long wmCommand, long wParam, long lParam);
TEMPODLLAPI TCB *GetThreadTCB(short t);
TEMPODLLAPI short IncrementRunCount(short t);
TEMPODLLAPI short SetThreadState(short t, char *fmt, ...);
TEMPODLLAPI THR_BUGERFCALLBACK SetThreadBugerfCallback(THR_BUGERFCALLBACK BugerfCallback);
TEMPODLLAPI THR_MESSAGEPUMPCALLBACK SetThreadMessagePumpCallback(THR_MESSAGEPUMPCALLBACK MessagePumpCallback);
TEMPODLLAPI DWORD GetThreadID(short t);
TEMPODLLAPI char *GetThreadName(short t, char *buf, long nBuf);

//lint -printf(2,SetThreadState);

//lint -esym(534,SetThreadState)
//lint -esym(534,SetKillThreadEventHandle)
//lint -esym(534,SetKillThreadHWND)
//lint -esym(534,GetThreadState)

#include    "TEMPODLX.H"
#pragma     pack(pop)
