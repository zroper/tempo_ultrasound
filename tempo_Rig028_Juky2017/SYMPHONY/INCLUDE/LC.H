//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

/* .title   LC.H    Definitions for LC API
;+
; DESCRIPTION
;   This file contains definitions for the LC Application Programming Interface.
;   LC the the control portion of the TEMPO Grid sofware.
;
; EDIT HISTORY
;   04Oct06 sh  Initial edit
;   23Oct06 sh  Change LCPARAM_DIRECTORY to LCPARAM_WORKINGDIRECTORY
;   28Oct06 sh  Change NPARAMSIZE from 1878 to 3878
;   13Nov06 sh  3.1 First beta release to Mike Page
;   21Nov06 sh  Add lcGetConnectionFinalParams, LCERR_TOOMANYCONNECTIONS
;   14Dec06 sh  Add LC_LOCALPOOLNAME and LC_POOLNAMESIZE
;   18Feb07 sh  3.7 Change names of some lc functions (ie lcAddNode to lcAddNodeToGraph)
;                   Change LCCBERR to contain error strings, not just pointers to them.
;                   Pass entire LCCBERR to LCCBERRHANDLER, not just pointer to it
;   19Feb07 sh  3.8 Revert back to passing const *LCCBERR to lccberr handler
;                   (Thank's to Mike Page for pointing out a better way to implement this)
;   27Feb07 sh  Add more LCPARAM_xxx for parameter list returned by lcGetConnectInfo
;   04Mar07 sh  3.14 Add nwerr to LCERR
;   18Mar07 sh  4.1  Add lcerr.tgsrvStatus and lcerr.userStatus
;   05Apr07 sh  4.2  Change lcUpdateGraphNodeStatcode to lcUpdateNodeProcessStatus
;                    Change lcNCMGetConnectionInfo to lcNCMFindConnectionInfo
;                    lcNCMFindConnectionInfo: allow for computerName==NULL
;                    Display LCPARAM_PROCESSID as "decimal (hex)"
;                    Display LCPARAM_HPROCESS  as "decimal (hex)"
;   30Jun07 sh       Add LCPARAM_LOCALIP, LCPARAM_REMOTEIP (for lcGetPoolInfo)
;   11Jul07 sh       Add LCRR_CANTESTABLISHCONNECTION
;   05Aug07 sh       Increase TG_PACKETSIZE from 4000 to 8000
;   08Jan08 sh       Add LCERR_REMOTETGSRVERR
;   28Mar08 sh       Add lcDumpf
;   12Feb09 sh      Remove LCERR_POOLALREADYDEFINED (see lcSetPoolName)
;-
*/
#ifndef LC_H
#define LC_H                            // Define only once

#ifndef TG_H                            // We require TG.H
    #include    "tg.h"                  // Include it if its not already included
#endif

//--------------------------------------------
// Size of various structures 

#ifndef NNAMESIZE
    #define NNAMESIZE   32                  // Space to hold NULL terminated name
#endif

#ifdef TG_TGCMDSRV_NODENAMESIZE             // Check for consistency
    #if NNAMESIZE != TG_TGCMDSRV_NODENAMESIZE
        #error  NNAMESIZE mismatches TG_TGCMDSRV_NODENAMESIZE
    #endif
#endif

#ifndef NPARAMSIZE
    #define NPARAMSIZE  (8000-98-40)        // Space to hold NULL terminated parameter list (leave room for command)
                                            // 8000==TG_PACKETSIZE
                                            // 98==sizeof(TG_HEADER)
#endif

#ifdef TG_BUFSIZE                           // Check for consistency
    #if NPARAMSIZE != (TG_BUFSIZE-40)
        #error  NPARAMSIZE mismatches TG_BUFSIZE-40
    #endif
#endif


#ifndef LC_NPOOLNAMESIZE
    #define LC_NPOOLNAMESIZE    8           // 8 alphanums including trailing NULL
#endif
#ifdef NPOOLNAMESIZE                        // Must be consistent with NW.H
    #if NPOOLNAMESIZE != LC_NPOOLNAMESIZE
        #error  LC_POOLNAMESIZE != NPOOLNAMESIZE in nw.h
    #endif
#endif

#define     LC_LOCALPOOLNAME    "local"     // Name of LOCAL pool
//14Dec06 C preprocessor doesn't allow for compile-time string comparisons.
//        NWCM_LOCALPOOLNAME is defined in NWCM.H and must be identical to this.
//#ifdef NWCM_LOCALPOOLNAME
//    #if LC_LOCALPOOLNAME != NWCM_LOCALPOOLNAME
//        #error LC_LOCALPOOLNAME mismatches NWCM_LOCALPOOLNAME (in NWCM.H)
//    #endif
//#endif


#define     NCOMPUTERS          32          // Maximum number of computers in POOL
#define     NNODES      (NCOMPUTERS*2)      // Maximum number of nodes we can handle.
#define     NCONNECTIONS  (NNODES*2)        // Total of send/recv connections we can handle.

// NNCMLINK is the maximum number of "links" between the local ELSIE computer
// and a remote NCM computer.  A link is an association between a local IP and
// a remote IP.  Multi-homed computers have more than one IP address (ie more
// than one adapter.  If both the ELSIE computer _and_ a remote NCM computer
// are multi-homed, the number of combinations of adapters is n * m where
// n=number of adapters on the local computer and m=number of adapters on remote
// computer.

#define     NNCMLINK    16                  // Max # of links (allows for 4x4)


//--------------------------------------------
// When specifying the COMPUTER= parameter in the lcAddNode function,
// You can specify the name of a computer in the POOL or one of the
// following "special" names.
//
//      $n          The nth computer in the pool, n=[0,..,)
//      $any        Let ELSIE assign the next computer (round robin assignment)
//      $elsie      The computer on which ELSIE is running
//                  If ELSIE's computer isn't in the pool, then use $any

#define     LC_COMPUTERPREFIX   "$"         // Prefix for special computers for NODE's COMPUTER= parmameter
#define     LC_COMPUTERANY      LC_COMPUTERPREFIX "ANY"
#define     LC_COMPUTERELSIE    LC_COMPUTERPREFIX "ELSIE"


//--------------------------------------------
// The LCNAMELIST type is used to refer to lists of one or more NODE or CONNECTION names
// (See lcGetPoolList, lcGetConnectionList, lcGetNodeList)

typedef struct
    {
    char    name[NNAMESIZE];
    } LCNAMELIST;
  
  
//--------------------------------------------
typedef struct {
    void    *p;
    } LC;                               // User's data type (pointer to LCCTRL)

//--------------------------------------------
// Defintion of error return codes


#define LCERR_OK                        0   // Operation successful
#define LCERR_NOMEMORY                 -1   // Failed to allocate memory
#define LCERR_INVALIDNODENAME          -2   // Invalid NODE name
#define LCERR_INVALIDTGCB              -3   // Invalid tgcb table
#define LCERR_INVALIDLC                -4   // Invalid LC pointer
#define LCERR_LCNOTINIT                -5   // LC not initialized
#define LCERR_TGERR                    -6   // A TG error was reported
#define LCERR_NCMNOTRESPONDING         -7   // No response from NCM on remote computer
#define LCERR_PARAMLISTTOOBIG          -8   // Parameter list is too big
#define LCERR_CANTOPENFILE             -9   // Unable to open file
#define LCERR_SYNTAXERROR             -10   // Syntax error
#define LCERR_INVALIDLCGI             -11   // Invalid LCGI_x value
#define LCERR_BUFTOOSMALL             -12   // Buffer is too small
#define LCERR_NODENOTFOUND            -13   // NODE Not found
#define LCERR_NCMUNEXPECTEDRESPONSE   -14   // An unexpected response was received from NCM
#define LCERR_NWERR                   -15   // A networking error was detected
#define LCERR_NCMNORESPONSE           -16   // NCM did not respond
#define LCERR_NOPROCESSID             -17   // Unable to determine NODE's processID
#define LCERR_POOLNOTDEFINED          -18   // The poolname is not defined
#define LCERR_TOOMANYCOMPUTERS        -19   // Too many computers in POOL
#define LCERR_COMPUTERNOTFOUND        -20   // COMPUTER Not found
#define LCERR_CONNECTIONNOTFOUND      -21   // Connection not found
#define LCERR_CANTRESOLVE             -22   // Can't locate TG CMD SRV port
#define LCERR_NOHPROCESS              -23   // NODE's hProcess (win32 handle) is not known
#define LCERR_NOTATGPROGRAM           -24   // NODE is not a TG program
#define LCERR_CONNECTIONSDISABLED     -25   // NODE's connections are disabled
#define LCERR_IPPORT                  -26   // Unable to determine our own TG CMD CLI port
#define LCERR_CONNECTIONALREADYOPEN   -27   // Connection is already open
#define LCERR_LLERR                   -28   // A LinkList error occurred
#define LCERR_NODEALREADYEXISTS       -29   // The NODE already exists
#define LCERR_CONNECTIONALREADYEXISTS -30   // The CONNECTION already exists
#define LCERR_TOOMANYCONNECTIONS      -31   // Too many connections in this LC
#define LCERR_INVALIDPOOLNAME         -32   // The name of the pool is invalid
#define LCERR_CANTESTABLISHCONNECTION -33   // Can't establish hyperstream connection between two nodes
#define LCERR_REMOTETGSRVERR          -34   // Remote TG processing failed

#define LCERR_LASTONE   LCERR_REMOTETGSRVERR    // Last defined error code



//--------------------------------------------
// Definition of the LCERR block returned by most LC functions

typedef struct
    {
    long        lcerr;                  // An LCERR_xxx code LC error code
    long        tgerr;                  // A TG_XXX code TG error code
    long        llerr;                  // An LLERR_xxx linked list error code
    long        nwerr;                  // An NW_xxx network error code
    long        tgsrvStatus;            // A TGSRVSTATUS_x code from remote NODE
    long        userStatus;             // Return code from user's tgcbFoo() function
    } LCERR;
    
    
//--------------------------------------------
// Definition of the LCCBERR block passed to the user's LCERRHANDLER function

typedef struct
    {
    LCERR       lcerr;                  // LCERR codes
    long        questionType;           // Type of question
#define LC_QUESTION_NONE                0   // No question, answer is ignored
#define LC_QUESTION_OK                  1   // OK=IDOK
#define LC_QUESTION_YESNO               2   // Yes=IDYES, no=IDNO
#define LC_QUESTION_RETRYCANCEL         3   // Retry=IDRETRY, cancel=IDCANCEL
#define LC_QUESTION_ABORTRETRYIGNORE    4   // Abort=IDABORT, retry=IDRETRY, ignore=IDIGNORE

#define LC_QUESTION_LASTONE LC_QUESTION_ABORTRETRYIGNORE

    char  title[256];                   // "" or dialog title
    char  message[2048];                // "" or dialog text
    char  nodeName1[NNAMESIZE];         // "" or first node
    char  pcName1[NNAMESIZE];           // "" or name of first node computer
    char  nodeName2[NNAMESIZE];         // "" or second node
    char  pcName2[NNAMESIZE];           // "" or name of second node computer
    char  connectionName[NNAMESIZE];    // "" or connection name
    } LCCBERR;

typedef long (LCCBERRHANDLER)(const LC *Lc, const LCCBERR *lccberr);// User's error handling callback function


//------------------------------------------------------------------
// Definitions for LC file parameters (used by lcParse)

// lcGetPoolComputerInfo parameters

#define LCPARAM_POOLNAME            "poolname"
#define LCPARAM_COMPUTER            "computer"
#define LCPARAM_REMOTEIP            "remoteIP"
#define LCPARAM_LOCALIP             "localIP"
#define LCPARAM_NCMPORT             "ncmport"

// lcGetConnectionInfo parameters

#define LCPARAM_CONNECTNAME         "connectName"
#define LCPARAM_RECVLOCALIP         TGSRVPARAM_RECVIP
#define LCPARAM_RECVLOCALPORT       TGSRVPARAM_RECVPORT

#define LCPARAM_LCSENDNODENAME      "lcSendNodeName"
#define LCPARAM_SENDCONNECTID       "lcSendConnectID"
#define LCPARAM_ISSENDOPEN          "lcIsSendOpen"
#define LCPARAM_SENDLOCALIP         TGSRVPARAM_SENDIP
#define LCPARAM_SENDLOCALPORT       TGSRVPARAM_SENDPORT

// lcGetConnectionInfo parameters


#define LCPARAM_LCRECVNODENAME      "lcRecvNodeName"
#define LCPARAM_RECVCONNECTID       "lcRecvConnectID"
#define LCPARAM_ISRECVOPEN          "lcIsRecvOpen"


// lcGetNodeInfo parameters

#define LCPARAM_NODENAME            "nodename"          // Name of node
#define LCPARAM_COMMANDLINE         "commandline"       // =program command line (may include path to .EXE)
#define LCPARAM_WORKINGDIRECTORY    "workingdirectory"  // =workingdirectory (dir to run program in)
//#define LCPARAM_COMPUTER          "computer"          // =name of computer (already defined)
#define LCPARAM_ISATGPROGRAM        "isaTGprogram"      // ="yes" or "no"
#define LCPARAM_RUNPROGRAM          "runProgram"        // ="yes" or "no"
#define LCPARAM_EXITPROGRAM         "exitProgram"       // ="yes", "no" or "byncm"

// 05Apr07 The LCPARAM_PROCESSID and LCPARAM_HPROCESS returned by lcGetNodeInfo
// are 32 bit unsigned quantities displayed as "decimal (hex)" where the value
// is shown both as a ULONG decimal number and its corresponding HEX value.
//
// C users can use strtoul() to parse the decimal or hex portion of these strings.
//
// Note that different operating systems may choose different integers (ie Windows 98
// starts processID at FFFFFFFF and decriments with new processes, win2k
// seems to start processID at 0 and increments.

#define LCPARAM_PROCESSID           "processID"         // win32 processID
#define LCPARAM_HPROCESS            "hProcess"          // win32 hProcess (copy of NCM's hProcess)

#define LCPARAM_LASTERROR           "lasterror"         // win32 NCM's last error for process
#define LCPARAM_DONTSENDSTATE       "dontSendState"     // 1=don't send state to NODE
#define LCPARAM_DONTSENDOPENCLOSE   "dontSendOpenClose" // 1=don't try to open/close connection
#define LCPARAM_ISTERMINATED        "isTerminated"      // 1=process is terminated
#define LCPARAM_TGSERVERIP          "tgServerIP"        // a TG CMD SRV IP for NODE
#define LCPARAM_TGSERVERPORT        "tgServerPort"      // a TG CMD SRV port for NODE



//------------------------------------------------------------------
// These are some of the parameters returned by lcGetNodeInfo

#define LCPARAM_STATCODE     "statCode"       // =# process exit code (used to detect termination)



//------------------------------------------------------------------
// LCNCMCONNINFO - This structure is returned by the lcNCMGetConnInfo function.

typedef struct
    {
    char            computerName[TG_TGCMDSRV_NODENAMESIZE]; //32 Name of responding computer
    long            iConnection;        //04 Connection index [-1, 0..)
    char            processName[80];    //80 Name of process
    char            nodeName[TG_TGCMDSRV_NODENAMESIZE]; //32 TG Node Name, if known. NULL terminated
    long            serviceType;        //04 Connection Service Type
#define     LCNCM_SERVICE_UNKNOWN   0   // Unknown service type
#define     LCNCM_SERVICE_NWCMS     1   // NCM broadcast server port
#define     LCNCM_SERVICE_NWCMC     2   // NCM client port
#define     LCNCM_SERVICE_PONGS     3   // PONG sender
#define     LCNCM_SERVICE_PONGR     4   // PONG receiver
#define     LCNCM_SERVICE_BONGS     5   // BONG sender
#define     LCNCM_SERVICE_BONGR     6   // BONG receiver
#define     LCNCM_SERVICE_SSRVS     7   // SSRV server
#define     LCNCM_SERVICE_SSRVC     8   // SSRV client (COBALT)
#define     LCNCM_SERVICE_KSRVS     9   // KSRV/KSRVB server
#define     LCNCM_SERVICE_KSRVC    10   // KSRV client (TEMPOW)
#define     LCNCM_SERVICE_UDPS     11   // UDP Command server
#define     LCNCM_SERVICE_UDPC     12   // UDP Command client
#define     LCNCM_SERVICE_HPRS     13   // Hyperstream sender
#define     LCNCM_SERVICE_HPRR     14   // Hyperstream receiver
#define     LCNCM_SERVICE_NWCMSU   15   // NCM unicast server port
#define     LCNCM_SERVICE_NWCMCU   16   // NCM unicast client port
#define     LCNCM_SERVICE_TGCMDS   17   // TEMPO Grid Command server
#define     LCNCM_SERVICE_TGCMDC   18   // TEMPO Grid Command client

#define     LCNCM_SERVICE_LAST LCNCM_SERVICE_TGCMDC

                               
    // The following information is made available provided the correct
    // password is provided in the request.

    unsigned long   processID;          //04 processID
    char            quadLocalIP[sizeof("###.###.###.###")]; //16 Local IP address of connection
    unsigned short  localPort;                              //04 Local port number of connection
    char            quadRemoteIP[sizeof("###.###.###.###")];//16 Remote IP address of connection
    unsigned short  remotePort;                             //04 Remote port number of connection
    } LCNCMCONNINFO;                    //164 bytes
    

//--------------------------------------------
// Function prototypes


TEMPODLLAPI LCERR lcInit(LC *lc, const TGCBFUNCTIONS *tgcb, const void *userDefined, long enableCallbacks);
TEMPODLLAPI LCERR lcUninit(LC *lc);
TEMPODLLAPI LCERR lcGetInfo(long lcgi, void *buf, long nBytes);
    #define LCGI_NAMESIZE       1           // Get size of NODE/CONNECTION name (in bytes, includes NULL)
    #define LCGI_PARAMLISTSIZE  2           // Get size of parameter List
TEMPODLLAPI LCERR lcSendState(const LC *lc, LCCBERRHANDLER *lccbErrHandler, long tgsrvparamState, const char *nodeName, const char *paramList);
TEMPODLLAPI char *lcErr(long lcerr);
TEMPODLLAPI LCERR lcGetUserDefined(const LC *lc, void **pUserDefined);
TEMPODLLAPI LCERR lcGetTG(const LC *Lc, TG *tg);
TEMPODLLAPI LCERR lcGetLC(const TG *Tg, LC *lc);
TEMPODLLAPI LCERR lcEnableCallbacks(const LC *lc);
TEMPODLLAPI LCERR lcDisableCallbacks(const LC *lc);

TEMPODLLAPI LCERR lcParse(const LC *Lc, const char *filename);

TEMPODLLAPI LCERR lcDumpf(const LC *Lc, const char *filename, const char *fmt, ...);    //lint -printf(3,lcDumpf)

TEMPODLLAPI LCERR lcSetPoolName(const LC *lc, const char *poolName, LCCBERRHANDLER *lccbErrHandler, const char *paramListFmt, ...);
TEMPODLLAPI LCERR lcGetPoolName(const LC *lc, char *poolName, long nPoolNameSize);
TEMPODLLAPI LCERR lcGetPoolParams(const LC *lc, char *paramList, long nParamListSize);
TEMPODLLAPI LCERR lcGetPoolInfo(const LC *lc, char *paramList, long nParamListSize);
TEMPODLLAPI LCERR lcGetPoolCount(const LC *Lc, long *nComputers);
TEMPODLLAPI LCERR lcGetPoolList(const LC *Lc, LCNAMELIST *poolList, long nBytes);
TEMPODLLAPI LCERR lcGetPoolComputerInfo(const LC *Lc, const char *computerName, char *computerInfoList, long nBytes);

TEMPODLLAPI LCERR lcAddNodeToGraph(const LC *lc, const char *nodeName, LCCBERRHANDLER *lccbErrHandler, const char *paramListFmt, ...);
TEMPODLLAPI LCERR lcRunNode(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *nodeName);
TEMPODLLAPI LCERR lcExitNode(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *nodeName);
TEMPODLLAPI LCERR lcGetNodeParams(const LC *lc, char *paramList, long nParamListSize, const char *nodeName);
TEMPODLLAPI LCERR lcGetNodeInfo(const LC *lc, char *paramList, long nParamListSize, const char *nodeName);
TEMPODLLAPI LCERR lcDeleteNodeFromGraph(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *nodeName);
TEMPODLLAPI LCERR lcGetNodeCount(const LC *lc, long *pNodeCount);
TEMPODLLAPI LCERR lcGetNodeList(const LC *lc, LCNAMELIST *nodeNameList, long nBytes);
TEMPODLLAPI LCERR lcUpdateNodeProcessStatus(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *nodeName);
TEMPODLLAPI LCERR lcSetNodeAbnormalEnd(const LC *Lc, unsigned long inhibitFlag, unsigned long exitProgram, const char *nodeName);
    #define LCSNA_INHIBIT_STATES         0x1    // Don't send state messages to NODE
    #define LCSNA_INHIBIT_OPENCLOSE      0x2    // Don't send open/close Hyperstream messages to NODE
    
    #define LCSNA_EXITPROGRAM_NOCHANGE     0    // Use existing NODE's setting
    #define LCSNA_EXITPROGRAM_DEFAULT      1    // Exit using default behavior
    #define LCSNA_EXITPROGRAM_YES          2    // Exit by sending EXIT state message
    #define LCSNA_EXITPROGRAM_NO           3    // Don't cause NODE to exit
    #define LCSNA_EXITPROGRAM_BYNCM        4    // Exit by asking NCM to terminate the NODE

TEMPODLLAPI LCERR lcAddConnectionToGraph(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *connectName, const char *sendNodeName, const char *recvNodeName, const char *paramListFmt, ...);

TEMPODLLAPI LCERR lcOpenConnectionByConnection(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *connectName);
TEMPODLLAPI LCERR lcOpenConnectionByNode(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *nodeName);

TEMPODLLAPI LCERR lcCloseConnectionByConnection(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *connectName);
TEMPODLLAPI LCERR lcCloseConnectionByNode(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *nodeName);

TEMPODLLAPI LCERR lcGetConnectionInfoByConnection(const LC *lc, char *paramList, long nParamListSize, const char *connectName);
TEMPODLLAPI LCERR lcGetConnectionParams(const LC *lc, char *paramList, long nParamListSize, const char *connectName);
TEMPODLLAPI LCERR lcGetConnectionCount(const LC *lc, long *pConnectionCount);
TEMPODLLAPI LCERR lcGetConnectionList(const LC *lc, LCNAMELIST *connectNameList, long nBytes);
TEMPODLLAPI LCERR lcGetConnectionFinalParams(LC *Lc, char *paramList, long nParamListSize, char *connectName);

TEMPODLLAPI LCERR lcDeleteConnectionByConnectionFromGraph(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *connectName);
TEMPODLLAPI LCERR lcDeleteConnectionByNodeFromGraph(const LC *lc, LCCBERRHANDLER *lccbErrHandler, const char *nodeName);

TEMPODLLAPI LCERR lcNCMFindConnectionInfo(const LC  *Lc, // in
                   const char       *password,      // in
                   const char       *computerName,  // in
                   long             iConnection,    // in
                   long             serviceType,    // in
                   unsigned long    processID,      // in
                   const char       *nodeName,      // in
                   LCNCMCONNINFO    *pNcmConnInfo); // out


//lint -printf(4, lcSetPoolName)
//lint -printf(4, lcAddNode)
//lint -printf(6, lcAddConnection)


#endif  // ifndef LC_H

#include    "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above
