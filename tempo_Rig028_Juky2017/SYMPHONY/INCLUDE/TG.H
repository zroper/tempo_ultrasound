//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"
/* .title   TG.H    TEMPO Grid API definitions
;+
; DESCRIPTION
;   These definitions are provided for use with the TEMPO GRID API
;
; EDIT HISTORY
;   16Jun06 sh  Initial edit
;   05Jul06 sh  Added tgSendHSData
;   11Jul06 sh  Add tg.printf
;   21Jul06 sh  v1.3 Add tgcbMessage Status Message callback
;   12Aug06 sh  Add TG_CONNECTINFO.hEmpty, and .hNotEmpty event handles
;   20Sep06 sh  1.4 Add negotiation (extra callback function)
;               Also, separate open/close send/recv callbacks
;   28Sep06 sh  1.5 Add tgSendf and tgcbReceive
;   02Oct06 sh  1.6 Add tgcbLogf to allow TG to send debug messages to application
;   04Oct06 sh  1.7 add tgLogf to tgsrvAskRecv, and tgsrvAskSend
;               1.8 tgInit: check version and set numbers of tgcb table against DLL
;   28Oct06 sh  1.9 Add tgcbUserDefine[] values; add TGCBFUNCTIONS pointer to TG_RQSTRESP
;                   Increase TG_BUFSIZE from 2000-82 to 4000-82
;   28Oct06 sh  2.2 Remove TGCBFUNCTIONS.tgcbInit and .tgcbUninit
;                   Add TGCBFUNCTIONS.tgcbUserDefined
;                   Remove TG_RQSTRESP.mdb
;                   Add TG_RQSTRESP.nRqstSize
;                   Add destNodeName to tgQueryf and tgSendf
;   01Nov06 sh  2.3 Rename tgHS level routines
;                   Move userDefined from TGCB table to tgInit, add tgGetUserDefined
;                   Add TGCID_x to make searching for connectID faster
;                   Add const to many declarations
;                   Add TG argument to tgcbLogf, tgcbMessagef and tgcbException
;   04Nov06 sh  2.4 Remove fmt from tgcbLogf and tgcbMessagef
;                   Add LCIDENT
;   06Nov06 sh  2.5 Rename TG_CONNECTION.lcIdent to .lcid
;                   (thanks to Mike Page for pointing out naming inconsistency with connectid)
;   09Nov06 sh  2.6 Use the low bit in the connectID to indicate send/recv
;   10Nov06 sh      Add LCIDENT to cache and many places
;   13Nov06 sh  3.1 First complete beta release to Mike Page
;   14Nov06 sh  3.2 Add tgEnableCallbacks, tgDisableCallbacks, add enableCallbacks arg to tgInit
;   16Nov06 sh  3.3 tgPrintf has been obsoleted
;   21Nov06 sh  3.4 Add rr.lcid = LCID of the requesting NODE
;   29Nov06 sh  3.5 Add localConnectID, remoteConnectID, connectName to TG_CONNECTINFO
;   08Dec06 sh  3.6 tgUninit: Don't allow TG CMD SRV thread to call tgUninit!
;   14Feb07 sh  3.7 Remove 2 states: endInit, beginUninit
;                   change beginInit to INVITE, and endUninit to UNINVITE
;   19Feb07 sh  3.8 Revert lccberr back to passing a const *LCCBERR pointer to user callbacks
;   27Feb07 sh  3.9 Add tgDeleteMapByRemoteNodeName
;               3.10 Add more debugging message to lcxErrorHandler and lcRunNode
;               3.11 Add tgDisableMapByRemoteNodeName.  Have lcExit call it.
;                    Have ELSIE's tgcbQuery pay attention to DISABLE_GETMESSAGE bit in IP MAP
;   01Mar07 sh  3.12 lcExitNode - zero tgServerPort to force rediscovery of node is restarted            
;               3.13 lcResolve - clean up logic and correct bug where it didn't wait 1500 ms
;   04Mar07 sh  3.14 Add nwerr to LCERR
;   18Mar07 sh  4.1  Add .h.tgsrvStatus and .h.userStatus to TG_HEADER
;                    Remove STATUS= and CALLBACK= parameters in response packet
;                    Add TGSRVSTATUS_RESPONSEBUFTOOSMALL
;                    Add tgTGSRVSTATUS()
;   05Apr07 sh  4.2  Change names: lcNCMFindConnectionInfo and lcGetNodeProcessStatus
;                    lcGetNodeInfo: format processID and hProcess as "decimal (hex)"
;                    lcNCMFindConnectionInfo: allow for computerName==NULL
;   16Apr07 sh  4.3  hAdded added to TG_CONNECTINFO
;   23Apr07 sh  4.4  Disregard adapters with subnet=255.255.255.255 (Mike Page's Juniper VPN)
;   25May07 sh       Add LODWORD64 and HIDWORD64 macros
;   10Jul07 sh       Add TGCMDSRV_TGSRVGATEWAY (for TGCMDSRV_GETMAPPING)
;   12Jul07 sh  4.5  Implement new multi-homing for 
;                       ELSIE talking to nodes (lcSetPoolName)
;                       NODES talking to other nodes (tgcbQuery: TGCMDSRV_GETMAPPING)
;                       Hyperstream connections (lcOpenConnection)
;   13Jul07 sh  4.6  Add tgNCMSet NCM's set number as global variable
;   18Jul07 sh  4.7  Fix tgxAddNodeToMap: Allow for multiple node names provided remote ip:port are unique
;   31Jul07 sh  5.7  tgxUsrvCallback: Write all errors to tgLogf; some to tgMessagef, too
;   03Aug07 sh  6.1  Add Remote Procedure Calls (RPC)
;   05Aug07 sh  6.2  Increase TG packet size from 4000 to 8000 bytes
;   06Aug07 sh  6.3  Add variable length arguments to RPC functions (tgRpcCallEx)
;   09Oct07 sh  6.4  Added TG_CONNECTINFO.hRemoved (for TGCI_SEND connections)
;   22Jan08 sh  6.5  Add response history database
;   28Mar08 sh  6.6  lcAddNodeToGraph: fix bug: Initialize SEND/RECV connection lists
;                    Add lcDumpf function
;               6.7  Fix bug: lcInit wasn't allocate llComputers, llNodes, llConnections
;   16Apr08 sh       tgRegisterLCID: make hTG a const
;   28Apr08 sh       Changed TGSRVSTATUS_UNAUTHORIZED_NODENAME to TGSRVSTATUS_UNAUTH_NODENAME
;                    Changed TGSRVSTATUS_CONNECTIONALREADYOPEN to TGSRVSTATUS_CONNECTALREADYOPEN
;   30Jun08 sh  6.8  Fixed mdbGet() bug
;   05Jul08 sh  6.9  Define TG_HSOBJECTTYPE
;   03Aug08 sh  7.1  Add nbytes plus 2 extra LONGs to TG_HSOBJECTTYPE 
;                    Add TG_HSOBJECTTYPE to SSEPOCH
;   28Nov08 sh       Add tgRpcVRegister, tgRpcVCall and tgRpcVCallEx
;   03Dec08 sh       Change TG_HSOT_STAGRAPH to TG_HSOT_STACUBE
;   26Jan09 sh       Improve naming and comments for RPC function arguments
;   27Jan09 sh       TGSRVSTATUS_REMOTETGCBERR removed from RPC handling.
;                    Symphony no longer places any interpretation on the
;                    userStatus returned from the server-side RPC function;
;                    Symphony simply passes it back to the client-side w/o
;                    setting a tgquery.tgerr or tgquery.tgsrvStatus error.
;                    Add tgSetTimeout()
;   06May09 sh  8.1  tgInit: check set number only, not version number, for compatibility
;                    tgRegisterHwnd: check if node is registered with NCM and return special
;                       error TG_NWCMNOTFOUND if not (so application can tell user not to run
;                       the application outside of a computation).
;-
*/
#ifndef TG_H
#define TG_H                            // Define only once

#ifndef HANDLE                          // We require HANDLE
    #include    <windows.h>
#endif


//-------------------------------------------------------------------------
// The purpose of the version number is to identify each release (or beta).
// Some changes don't require incrementing the set numbers because the change
// doesn't introduce a compatibility problem.  But the version
// number should be incremented each time Symphony is changed for any reason
// so that we can track which release a user has.
    
#define TG_VERSION               8      // Version number
#define TG_VERSIONSTRING        "8"


// The purpose of the set number is to provide a way to test for
// software compatibility.
//
// The TG_SET number is changed whenever the SYMPHONY.DLL changes
// or when NCM protocol changes in a way that makes it incompatible
// with the previous set.

#define TG_SET                   1      // Set number (for compatiblity)
#define TG_SETSTRING            "1"


//-------------------------------------------------------------------------
#ifndef TG_BUFSIZE
    #define TG_BUFSIZE    (8000-98)     // Maximum number of bytes in data portion of request/response packet (includes trailing NULL)
#endif                                  // (98 == sizeof(TG_HEADER))
                                        // (8000 == TG_PACKETSIZE)

#define NTGCONNECTIONS            16    // Maximum number of SEND or RECV connections allowed per NODE

#define TG_NIPP                    4    // Maximum number of TG CMD Srv/Cli connections

#define TG_TGCMDSRV_NODENAMESIZE  32    // Max # of bytes in a NODE name (including trailing NULL)

#ifdef NW_H
    #if TG_TGCMDSRV_NODENAMESIZE != NCMSHM_NODENAMESIZE
        #error TG_TGCMDSRV_NODENAMESIZE mismatches NCMSHM_NODENAMESIZE  !!!
    #endif
#endif

#define TG_TGCMDSRV_CONNECTNAMESIZE 32  // Max # of bytes in a CONNECTION name (including trailing NULL)

#ifdef NNAMESIZE
    #if NNAMESIZE != TG_TGCMDSRV_CONNECTNAMESIZE
        #error TG_TGCMDSRV_CONNECTNAMESIZE mismatches NNAMESIZE!
    #endif
#endif

#define TGSRVNODENAME_ELSIE    "ELSIE"  //  Default controller NODE name


//-------------------------------------------------------------------------
// RPC related definitions

#define TG_RPCNARGS         16          // Max # of RPC buffers (arguments to rpc functions)
#define TG_RPCFUNCSIZE      32          // Max # of significant chars in RPC function name
#define TG_RPCMAXARGSIZE  7824          // Max # of bytes in all RPC arguments (see tgudp.hp: TG_RPCBUFSIZE)


//-------------------------------------------------------------------------
// TG connectIDs are unique values across the entire Logical Computation
// (ie, each end of each connection in a Logical Computation has a unique connectID)
// Additionally, these bits help LC/TG to validate connectID values.
//
// Exactly one of TGCID_SEND and TGCID_RECV must be set

#define TGCID_SEND       0x1            // Bit mask indicating SEND/RECV connectID
#define TGCID_RECV       0x0            // (See lcconn.c:lcxOpenConnection)

#define TGCID_ISASENDCONNECTID(lcid, connectID)  ((connectID & TGCID_SEND) == TGCID_SEND)
#define TGCID_ISARECVCONNECTID(lcid, connectID)  ((connectID & TGCID_SEND) == 0)


//-------------------------------------------------------------------------
// TG status codes

#define TG_OK                         0 // Successful operation
#define TG_NOMEMORY                  -1 // Out of memory
#define TG_HTGINVALID                -2 // Invalid pointer to hTG
#define TG_TGCBINVALID               -3 // invalid callback table
#define TG_NWERR                     -4 // A NW_xxx error occurred
#define TG_USRVERR                   -5 // A NW_xxx error returned from USRV
#define TG_THREADERR                 -6 // A THR_xxx error returned from THREADS
#define TG_ALREADYINIT               -7 // Only one TG server allowed
#define TG_HTGNOTINIT                -8 // hTG is not initialized
#define TG_NWERRCLIENT               -9 // Error Opening client-side connection
#define TG_INVALIDRQSTSIZE          -10 // Invalid request packet size
#define TG_INVALIDRQSTCMD           -11 // Invalid request packet command
#define TG_INVALIDSET               -12 // Invalid set number
#define TG_RQSTFLUSH                -13 // Error flushing FIFO
#define TG_RQSTGETEVENT             -14 // Error getting next hEvent
#define TG_WAITERROR                -15 // Error waiting for packet
#define TG_NWTAKEERROR              -16 // Error taking packet from FIFO
#define TG_NWRETURNERROR            -17 // Error returning packet to FIFO
#define TG_TIMEOUTERROR             -18 // Timeout
#define TG_STARTCLIENTFIFOERROR     -19 // Error starting client fifo
#define TG_RECVERROR                -20 // Error receiving packet
#define TG_RQSTTOOBIG               -21 // Request is too large to send.
#define TG_PARAMETERNOTFOUND        -22 // Parameter not found
#define TG_BADPARAMETERLIST         -23 // Invalid parameter list
#define TG_HROPENERR                -24 // Error opening Hyperstream receive
#define TG_HSOPENERR                -25 // Error opening Hyperstream send
#define TG_CONNECTIDBAD             -26 // Invalid connectID (out of range)
#define TG_CONNECTNOTOPEN           -27 // connectID is not an opened HS connection
#define TG_CONNECTBADBUFFER         -28 // buf==0 or nBytes!=nObjectSize
#define TG_FULL                     -29 // MDB is full
#define TG_MDBERR                   -30 // An MDB error occurred
#define TG_HSERR                    -31 // An HS error occurred
#define TG_EMPTY                    -32 // MDB is empty
#define TG_INVALIDARG               -33 // Invalid argument to function
#define TG_UNKNOWNHOSTNAME          -34 // Unable to resolve host name to IP
#define TG_UNKNOWNNODENAME          -35 // Unable to resolve NODE name to IP
#define TG_LOCKCREATE               -36 // Error creating hEvent
#define TG_LOCKTIMEOUT              -37 // Timeout waiting for lock
#define TG_UNLOCKFAILED             -38 // Failed to unlock
#define TG_RETRYBYTESOUTOFRANGE     -39 // Received packet with invalid byte count
#define TG_RETRYMISMATCHEDBYTES     -40 // Received packet with incorrect number of bytes
#define TG_RETRYBADSEQUENCE         -41 // Received packet with unexpected sequence number
#define TG_RETRYINVALIDRESPCMD      -42 // Received packet with incorrect response type
#define TG_NWCMALLOC                -43 // Error adding process to NCM
#define TG_NWCMWRITE                -44 // Error writing NCM shared memory
#define TG_NWCMREAD                 -45 // Error reading NCM shared memory
#define TG_NWCMNOTINIT              -46 // NCM shared memory access not initialized
#define TG_NWCMLOCK                 -47 // Error locking NCM shared memory
#define TG_NWCMUNLOCK               -48 // Error unlocking NCM shared memory
#define TG_TGCBBADSET               -49 // tgcbSet mismatches SYMPHONY.DLL
#define TG_UNAUTHORIZED_NODENAME    -50 // Remote NODE is not authorized to send us messages
#define TG_LCID_REQUIRED            -51 // Non-zero LCID must be specified
#define TG_CALLBACKSDISABLED        -52 // TG callbacks are disabled
#define TG_IMPROPERCONTEXT          -53 // Can't call tgUninit from this thread
#define TG_REMOTETGSRVERR           -54 // Remote TG processing failed
#define TG_RPCEXISTS                -55 // RPC function already exists
#define TG_RPCNOTFOUNDLOCAL         -56 // RPC function not locally registered
#define TG_RPCNOTFOUNDREMOTE        -57 // RPC function not registered on remote NODE
#define TG_RPCTOOMANY               -58 // RPC function limit exceeded
#define TG_RPCINVALIDNAME           -59 // RPC function name invalid  
#define TG_RPCINVALIDBUFSIZE        -60 // RPC Invalid buffer size
#define TG_RPCCLIENTSERVERARGS      -61 // RPC client arguments mismatch server
#define TG_INTERNAL1                -62 // An Symphony internal error was detected
#define TG_HISTOPENERR              -63 // Error opening response database
#define TG_HISTCLOSEERR             -64 // Error closing response database
#define TG_HISTNOTOPEN              -66 // response database not open
#define TG_HISTNOTFOUND             -67 // response not found in database
#define TG_HISTSAVEERR              -68 // LL error saving response
#define TG_CACHENODE                -69 // Error caching TG node information
#define TG_NWCMNOTFOUND             -70 // Application is not registered with NCM

#define TG_LASTERR                  TG_NWCMNOTFOUND


//-------------------------------------------------------------------------
// This is the user-level definition for a TG handle.

typedef struct
    {
    void        *pTGctrl;               // Definition for a TG control block
    } TG;
    

//-------------------------------------------------------------------------

typedef struct
    {
    char    ip[sizeof("###.###.###.###")];  // IP address string (NULL terminated)
    char    subnet[sizeof("###.###.###.###")];  // Subnet mask (if known)
    unsigned short port;                    // UDP port number
    } TG_IPPORT;


//-------------------------------------------------------------------------
// The LCIDENT identifies a single Logical Computation (ie ELSIE controller)
// and is guaranteed to be unique on any single subnet.

typedef unsigned __int64 LCIDENT;

#define LCID_UNKNOWN    (0uI64)             // Unknown/invalid LCIDENT value

#ifndef LODWORD64                           // Macros for accessing 32 bits of 64 bit value
    typedef union {__int64 i64; DWORD ul[2];} HILODWORD64;
    
    // Note: These macros are defined this way so they may appear on either the left hand
    // or right hand side of an assignment statement.  They are very fast
    // and generate efficient code.  However, since we take &i64, the i64
    // parameter must be something that can have its address taken.
    // In other words, it can't be a numeric constant.
    
    #define     HIDWORD64(i64)    ( ( *((HILODWORD64 *)&i64)).ul[1] )
    #define     LODWORD64(i64)    ( ( *((HILODWORD64 *)&i64)).ul[0] )
#endif


//-------------------------------------------------------------------------
// TG_CONNECTINFO
// This structure is used to pass open/close information
// to the user's callback functions, tgcbOpen() and tgcbClose(), when a
// Hyperstream connection is opened or closed (i.e., by ELSIE).
//
// It contains connection information that may be useful to the the user's
// callback function.  The information in this structure will not change
// while the connection is open.

typedef struct                              // Used in tgcbOpen, tgcbClose
    {
    LCIDENT             lcid;               // Logical Computation id
    unsigned long       localConnectID;     // Connection identification for this NODE (unique to an LC)
    unsigned long       remoteConnectID;    // Connection identification for remote NODE (unique to an LC)
    char                connectName[TG_TGCMDSRV_CONNECTNAMESIZE]; // Name of connection
    unsigned long       flag;               // Flag word
#define TGCI_RECV         0x1               //   ==1 iff RECV port
#define TGCI_SEND         0x2               //   ==1 iff SEND port
    unsigned long       nObjects;           // Minimum # of objects in FIFO
    unsigned long       nObjectSize;        // Maximum Size of any object in FIFO
    
                                            // NODE name at the other end of this HS connection
    char                remoteNodeName[TG_TGCMDSRV_NODENAMESIZE]; 
    
    
    // The following parameters are not set in tgcbAskSend and tgcbAskRecv
    // but they will be set in tgcbOpenSend, tgcbOpenRecv, tgcbCloseSend
    // and tgcbCloseRecv.
    
    TG_IPPORT           remoteNode;         // Remote NODE IP+port
    TG_IPPORT           localNode;          // Local NODE IP+port
    
    
    // These manual reset events are signaled by Symphony and
    // unsignaled (ResetEvent) by the user application.  Note that
    // Symphony does not unsignal (call ResetEvent) for any of these.
    //
    // The user application can wait on these events as a way of getting
    // informed of when a specific condition occurs.  When the user
    // application's wait completes, the user application should
    // immediately call ResetEvent() before processing the incoming
    // objects or sending more objects out.
    //
    // After the user application calls ResetEvent():
    //
    //   For receive connections, the user application must then get the
    //      number of objects in the input FIFO (tgGetObjectCount) 
    //      and process at least that number of objects.  The application
    //      can process more objects if it wants to (i.e., all objects
    //      until the input FIFO becomes empty).
    //
    //   For send connections, the user application should check if
    //      there is room in the output FIFO (tgGetObjectCount) and, if so,
    //      it can send more objects.
    
    HANDLE              hEmpty;             // Symphony signals this when FIFO Transition from n to 0, n>0
                                            // win32 manual reset Event Handle
                                            // User application must call ResetEvent
                                            
    HANDLE              hNotEmpty;          // Symphony signals this when FIFO Transition from 0 to n, n>0
                                            // win32 manual reset Event Handle
                                            // User application must call ResetEvent
                                            
    HANDLE              hAdded;             // Symphony signaled this when one or more new objects are added
                                            // win32 manual reset Event Handle
                                            // This event is valid only for TGCI_RECV connections
                                            // It is NULL for TGCI_SEND connections.
                                            // User application must call ResetEvent

    HANDLE              hRemoved;           // Symphony signals this when one or more objects are removed
                                            // win32 manual reset Event Handle
                                            // This event is valid only for TGCI_SEND connections
                                            // It is NULL for TGCI_RECV connections.
                                            // User application must call ResetEvent
                                            
    } TG_CONNECTINFO;
    

//-------------------------------------------------------------------------
// This structure is passed to most user callback functions.
// It contains the hTG handle as well as information about the
// request and a place to store a response.

typedef struct
    {
    TG                  hTG;                // TG handle
    char                fromNodeName[TG_TGCMDSRV_NODENAMESIZE]; // Node name of ELSIE controller making this request
    TG_IPPORT           fromNode;           // NODE's IP+port of TG CMD CLI on requesting computer
    LCIDENT             fromLCID;           // LCID of requesting node
    const char          *rqst;              // NULL or Request string ("#.#.#.#:# cmd\n{param=value\n...}") from requesting NODE
    long                nRqstSize;          // # of bytes in rqst buffer (could be 0)
    char                *resp;              // NULL or Place to store strings that will be returned to requesting NODE
    long                nRespSize;          // # of bytes in resp buffer (could be 0)
    } TG_RQSTRESP;
    

#ifndef _TGUSEREXCEPTIONHANDLER
    #define _TGUSEREXCEPTIONHANDLER
    typedef long (*TGUSEREXCEPTIONHANDLER)(const TG *tg, const char *exceptName, const EXCEPTION_RECORD *pExceptionRecord, const CONTEXT *pContext);
#endif


//-------------------------------------------------------------------------
// TG user Callback function table.
// The user provides this table of function pointers when opening TG.
//
// The user's callback functions are called by the TG software when
// certain events occur.
// 
// The user defines the semantic of these functions in the user's
// application program.  If the user doesn't have a need for a
// particular callback, the corresponding entry in the callback table
// can be set to NULL.
//
// They are called in the context a TG thread and _not_ in the context
// of the user's main process thread.  It is the user's responsibility
// to maintain coherency if there is any interaction between callback
// function the main process thread (or any other user thread).

typedef struct _TGCBFUNCTIONS
    {
    long    tgcbVersion;                            // = TG_VERSION
    long    tgcbSet;                                // = TG_SET
    long    tgcbSize;                               // = sizeof(TGCBFUNCTIONS)
   
    long    (*tgcbAskSend)(const TG_RQSTRESP      *rr,      // Ask about HS SEND connection
                           const TG_CONNECTINFO   *ci);     // Connection information
    
    long    (*tgcbOpenSend)(const TG_RQSTRESP     *rr,      // Open HS SEND connection
                            const TG_CONNECTINFO  *ci);     // Connection information
    
    long    (*tgcbCloseSend)(const TG_RQSTRESP    *rr,      // Close HS SEND connection
                             const TG_CONNECTINFO *ci);     // Connection information
    
    long    (*tgcbAskRecv)(const TG_RQSTRESP      *rr,      // Ask about HS SEND connection
                           const TG_CONNECTINFO   *ci);     // Connection information
    
    long    (*tgcbOpenRecv)(const TG_RQSTRESP     *rr,      // Open HS RECV connection
                            const TG_CONNECTINFO  *ci);     // Connection information
    
    long    (*tgcbCloseRecv)(const TG_RQSTRESP    *rr,      // Close HS RECV connection
                             const TG_CONNECTINFO *ci);     // Connection information
    
    long    (*tgcbState)(const TG_RQSTRESP        *rr,      // LC state change
                         long                     state);   // See TGSRVPARAM_STATE_xxx for possible values
                        
    long    (*tgcbQuery)(const TG_RQSTRESP        *rr);     // Unknown query handler
    long    (*tgcbRecv)(const TG_RQSTRESP         *rr);     // Receive a message from remote tgSendf
    
    void    (*tgcbMessage)(const TG               *hTG,     // Status message from TG
                           const char             *text);
                                                    
    void    (*tgcbLog)(const TG                   *hTG,     // Debug message from TG
                       const char                 *text);
                                                    
    long    (*tgcbExceptionHandler)(const TG      *hTG,     // Called when TG or HS threads generates an exception
                    const char             *threadName,     // Also called if a user callback generates an exception
                    const EXCEPTION_RECORD *pExceptionRecord, 
                    const CONTEXT          *pContext);
    } TGCBFUNCTIONS;



//-------------------------------------------------------------------------
// This structure is returned from tgQueryf() and tgSendf() functions.
// It contains status information on the result of your query or send.

typedef struct
    {
    long            tgerr;              // TG_xxx status (use tgErr() function to get message string)
    long            nwerr;              // NW_xxx status
    long            nReceived;          // Actual number of bytes received from network
    long            nLoaded;            // Number of bytes loaded into caller's buffer
    TG_IPPORT       remote;             // IP+port of responding computer
    long            tgsrvStatus;        // A TGSRVSTATUS_xxx from remote NODE
    long            userStatus;         // Return code from user's tgcb callback function
    } TG_QUERY;
    
    
//-------------------------------------------------------------------------
// TG function call table
// These functions are typically called from the user's main program
// or from within the user's callback.


TEMPODLLAPI extern const long tgVersion;            // TG_VERSION of TEMPO.DLL
TEMPODLLAPI extern const long tgSet;                // TG_SET of TEMPO.DLL
TEMPODLLAPI extern const long tgNCMSet;             // NCM's Set number (in TEMPO.DLL)

TEMPODLLAPI long tgGetInfo(const TG       *hTG,     // Get TG system information
                long            tggiType,           // A TGGI_xxx type
                    #define TGGI_GETTGCMDSRV    1   //   Get TG CMD SRV TG_IPPORT blocks
                    #define TGGI_GETTGCMDCLI    2   //   Get TG CMD CLI TG_IPPORT blocks
                    #define TGGI_GETMYNODENAME  3   //   Get this TG apps NODE name
                void            *p,                 // pointer to caller buffer
                long            n);                 // Size of buffer

TEMPODLLAPI const char *tgErr(long  tgerr);               // Convert TG_xxx status to string
TEMPODLLAPI const char *tgTGSRVSTATUS(long tgsrvstatus);  // Convert TGSRVSTATUS_xxx status to string
TEMPODLLAPI const char *tgNwErr(long nwerr);              // Convert an nwerr to a string.

TEMPODLLAPI long tgInit(TG          *hTG,           // Initialize TG package
                const char          *ourNodeName,   // NULL or the name of this NODE
                unsigned short      localPort,      // 0=use system assigned port
                const TGCBFUNCTIONS *tgcb,          // User's TG callback function table
                const void          *userDefined,   // A user defined value that is available to ..
                                                    // .. the user's callback functions (see tgGetUserDefined)
                long                enableCallbacks);// ==1 iff user callbacks are enabled                                       
                
TEMPODLLAPI long tgUninit(TG        *hTG);          // Uninitialize TG package

TEMPODLLAPI long tgEnableCallbacks(TG   *hTG);      // Enable user callbacks
TEMPODLLAPI long tgDisableCallbacks(TG  *hTG);      // Disable user callbacks

TEMPODLLAPI long tgGetUserDefined(const TG       *hTG,
                void            **userDefined);     // Return userDefined value from tgInit
                
TEMPODLLAPI TG_QUERY tgSendf(const TG       *hTG,   // Formatted send a message
                LCIDENT         lcid,               // LCID of destination node (or 0)
                const char      *destNodeName,      // Name (or "#.#.#.#:#") of destination NODE
                const char      *fmt, ...);         //lint -printf(4, tgSendf)
                
TEMPODLLAPI TG_QUERY tgQueryf(const TG       *hTG,  // Formatted Query of a TG server
                LCIDENT         lcid,               // LCID of destination node (or 0)
                const char      *destNodeName,      // Name (or "#.#.#.#:#") of destination NODE
                void            *resp,              // Buffer to receive response (TG_BUFSIZE)
                long            nRespBytes,         // Size of response buffer (TG_BUFSIZE)
                long            timeout,            // Timeout in ms
                const char      *fmt, ...);         // Formatted request
                                                    //lint -printf(7, tgQueryf)
                                               
TEMPODLLAPI long tgGetNextObjectSize(const TG       *hTG, // TG handle
                LCIDENT         lcid,               // Logical Computation ID for this connection (or 0)
                long            connectID,          // Opened HS connection id [1..NTGCONNECTIONS]
                unsigned long   *pnObjectSize);     // pointer to # of bytes in FIFO's next object

TEMPODLLAPI long tgReadNextObject(const TG       *hTG,    // TG handle
                LCIDENT         lcid,               // Logical Computation ID for this connection (or 0)
                long            connectID,          // Opened HS connection id [1..NTGCONNECTIONS]
                void            *buf,               // caller's buffer with data
                long            nBytes);            // # of bytes

TEMPODLLAPI long tgGetObjectCount(const TG       *hTG,    // TG handle
                LCIDENT         lcid,               // Logical Computation ID for this connection (or 0)
                long            connectID,          // Opened HS connection id [1..NTGCONNECTIONS]
                unsigned long   *pnObjectCount);    // pointer to number of objects in FIFO

TEMPODLLAPI long tgWriteObject(const TG       *hTG, // TG handle
                LCIDENT         lcid,               // Logical Computation ID for this connection (or 0)
                long            connectID,          // Opened HS connection id [1..NTGCONNECTIONS]
                const void      *buf,               // caller's buffer with data
                long            nBytes);            // # of bytes

TEMPODLLAPI long tgRegisterHwnd(TG       *hTG,      // Register hwnd for NCM termination
                HWND            hwnd,               // NODE's main HWND
                DWORD           wmCommand,          // 0 or WM_xxx command to send 
                WPARAM          wParam,             // wParam for WM_xxx command
                LPARAM          lParam);            // lParam for WM_xxx command


//------------------------------------------------
// Remote Procedure Call functions and definitions

typedef struct                                      // This is passed to RPC function
    {                                               // ..as rr->rqst
    char    rpcFuncName[TG_RPCFUNCSIZE];            // Name of RPC function
    long    nArgs;                                  // Number of arguments to function
    long    argSize[TG_RPCNARGS];                   // Number of bytes in each argument
    void    *arg[TG_RPCNARGS];                      // Pointers to each argument buffer
    } TG_RPCINFO;

typedef long (*TG_RPC)(const TG_RQSTRESP *rr, ...); // RPC function prototype (server side)

TEMPODLLAPI long tgRpcRegister(const TG *hTG,       // TG handle
                const char      *clientRPCFuncName, // Client side name of RPC function
                const char      *serverRPCFuncName, // Server side name of RPC function
                TG_RPC          funcEntryPoint,     // function entry point (on server side)
                                ...);               // NULL terminated list of buffer sizes
                
                
TEMPODLLAPI long tgRpcVRegister(const TG *hTG,      // TG handle
                const char      *clientRPCFuncName, // Client side name of RPC function
                const char      *serverRPCFuncName, // Server side name of RPC function
                TG_RPC          funcEntryPoint,     // function entry point (on server side)
                va_list         args);              // NULL terminated list of buffer sizes
                
                
TEMPODLLAPI long tgRpcUnregister(const TG *hTG,     // TG handle
                const char      *clientRPCFuncName);// Client Name of RPC function
                
TEMPODLLAPI TG_QUERY tgRpcCall(const TG *hTG,       // TG handle
                LCIDENT         lcid,               // lcid of destination NODE (or 0)
                const char      *serverNodeName,    // Name of server (remote) node
                const char      *clientRPCFuncName, // Client side name of RPC function
                long            timeoutMs,          // ms to wait for response
                                ...);               // Zero or more buffer pointers (void *)
                                
TEMPODLLAPI TG_QUERY tgRpcVCall(const TG *hTG,      // TG handle
                LCIDENT         lcid,               // lcid of destination NODE (or 0)
                const char      *serverNodeName,    // Name of server (remote) node
                const char      *clientRPCFuncName, // Client side name of RPC function
                long            timeoutMs,          // ms to wait for response
                va_list         args);              // Zero or more buffer pointers (void *)
                                
TEMPODLLAPI TG_QUERY tgRpcCallEx(const TG *hTG,     // TG handle
                LCIDENT         lcid,               // lcid of destination NODE (or 0)
                const char      *serverNodeName,    // Name of server (remote) node
                const char      *clientRPCFuncName, // Client side name of RPC function
                long            timeoutMs,          // ms to wait for response
                                ...);               // Zero or more buffer pointers (void *) + sizes
                                
TEMPODLLAPI TG_QUERY tgRpcVCallEx(const TG *hTG,    // TG handle
                LCIDENT         lcid,               // lcid of destination NODE (or 0)
                const char      *serverNodeName,    // Name of server (remote) node
                const char      *clientRPCFuncName, // Client side name of RPC function
                long            timeoutMs,          // ms to wait for response
                va_list         args);              // Zero or more buffer pointers (void *) + sizes

// Allow application to control Symphony's timeouts.

TEMPODLLAPI long tgSetTimeout(TG *hTG, long category, const void *subCategory, double value);

// Timeout categories for tgSetTimeout

#define TG_TIMEOUT_MULTIPLIER       1       // Timeout multiplier




//-------------------------------------------------------------------------
// User Definitions for TG SERVER parameter strings.
//
// A Parameter List is a NULL terminated string with the following format.
// It is a concatenation of zero or more strings of the form:
//
//           "PARAM=VALUE\n"
//
// For example:
//
//          "STATUS=0\n"
//
// The following parameters (TGSRVPARAM_xxx) are used.  The values they
// can have are shown below each parameter.  Note that the values are defined
// as numbers but will appear in a parameter list as a string.
//
// Symphony reserves state numbers >= TGSRVPARAM_STATE_FIRSTONE.
// The user can create their own state numbers and use them with lcSendState().
// Be sure to make sure you don't use any state numbers that are already being
// used by the Symphony.  

#define TGSRVPARAM_STATE                    "state"      // State value from ELSIE to user apps

#define TGSRVPARAM_STATE_USER_FIRST              0L      // First user-defined state
#define TGSRVPARAM_STATE_USER_LAST     (1000000000L - 1L) // Last user-defined state

#define TGSRVPARAM_STATE_FIRSTONE       (TGSRVPARAM_STATE_USER_LAST + 1)    // First state reserved by Symphony
    
    // The following "type 1" states are sent by the LC library
    // The user should not send these states.

    #define TGSRVPARAM_STATE_INVITE         (TGSRVPARAM_STATE_FIRSTONE + 1) // Invitation into an LC; assigns node name
    #define TGSRVPARAM_STATE_UNINVITE       (TGSRVPARAM_STATE_FIRSTONE + 2) // NODE is being removed from LC

    #define TGSRVPARAM_STATE_BEFORENODETERM (TGSRVPARAM_STATE_FIRSTONE + 3) // NOTICE sent to all nodes before a NODE is terminated
    #define TGSRVPARAM_STATE_NODETERM       (TGSRVPARAM_STATE_FIRSTONE + 4) // NOTICE sent to all nodes after a NODE is terminated
    #define TGSRVPARAM_STATE_EXIT           (TGSRVPARAM_STATE_FIRSTONE + 5) // NODE is being removed from LC; NODE should exit program

    // The following "type 2" states are sent by ELSIE.C
    
    #define TGSRVPARAM_STATE_BEFOREINIT     (TGSRVPARAM_STATE_FIRSTONE + 6) // Computation about to be initialized
    #define TGSRVPARAM_STATE_INIT           (TGSRVPARAM_STATE_FIRSTONE + 7) // Computation is initialized
                                                                          
    #define TGSRVPARAM_STATE_BEFORESTART    (TGSRVPARAM_STATE_FIRSTONE + 8) // About to start the computation
    #define TGSRVPARAM_STATE_START          (TGSRVPARAM_STATE_FIRSTONE + 9) // Computation is started
    
    #define TGSRVPARAM_STATE_BEFORESTOP     (TGSRVPARAM_STATE_FIRSTONE + 10) // About to stop the computation
    #define TGSRVPARAM_STATE_STOP           (TGSRVPARAM_STATE_FIRSTONE + 11) // Computation is stopped
    
    #define TGSRVPARAM_STATE_BEFOREUNINIT   (TGSRVPARAM_STATE_FIRSTONE + 12) // Computation about to be uninitialized
    #define TGSRVPARAM_STATE_UNINIT         (TGSRVPARAM_STATE_FIRSTONE + 13) // Computation is uninitialized
    
#define TGSRVPARAM_STATE_LASTONE        TGSRVPARAM_STATE_UNINIT  // For table maintenance


#define TGSRVPARAM_LCID                 "lcid"          // LC Identification

#define TGSRVPARAM_TGSRVNODENAME        "tgsrvnodename" // NODE name of the TG CMD SRV
#define TGSRVPARAM_TGSRVIP              "tgsrvip"       // ###.###.###.### of TG server
#define TGSRVPARAM_TGSRVPORT            "tgsrvport"     // Port number of TG server
#define TGSRVPARAM_TGSRVSUBNET          "tgsrvsubnet"   // Subnet on TG CMD SRV adapter
#define TGSRVPARAM_TGSRVGATEWAY         "tgsrvgateway"  // gateway on TG CMD SRV adapter

#define TGSRVPARAM_MDBOBJECTS           "mdbobjects"    // [1..n)  # of objects in MDB database
#define TGSRVPARAM_MDBOBJECTSIZE        "mdbobjectsize" // [1..n)  Size of objects in MDB database

// Connection specific parameters 

#define TGSRVPARAM_SENDIP               "sendip"        // SEND IP: "###.###.###.###"
#define TGSRVPARAM_SENDPORT             "sendport"      // SEND Port to open (0=any is ok)

#define TGSRVPARAM_RECVIP               "recvip"        // RECV IP: "###.###.###.###"
#define TGSRVPARAM_RECVPORT             "recvport"      // RECV port to open (0=any is ok)



//-------------------------------------------------------------------------
// The TGSRV_STATUS_xxx codes are returned in the TG_QUERY.tgsrvStatus member
// when tgSendf(), tgQueryf(), tgRpcCall(), etc return.  These codes
// are generated by Symphony on the client and server side if an error
// occurs during the processing of a node-to-node request.

#define TGSRVSTATUS_OK                       0      // Successful
#define TGSRVSTATUS_UNKNOWNCMD              -1
#define TGSRVSTATUS_BADCONNECTION           -2
#define TGSRVSTATUS_CONNECTALREADYOPEN      -3
#define TGSRVSTATUS_BADMDBOBJECTS           -4
#define TGSRVSTATUS_BADMDBOBJECTSIZE        -5
#define TGSRVSTATUS_BADREMOTEIP             -6
#define TGSRVSTATUS_BADREMOTEPORT           -7
#define TGSRVSTATUS_BADLOCALIP              -8
#define TGSRVSTATUS_BADLOCALPORT            -9
#define TGSRVSTATUS_MDBERR                  -10
#define TGSRVSTATUS_HROPENERR               -11
#define TGSRVSTATUS_HSOPENERR               -12
#define TGSRVSTATUS_HSCLOSEERR              -13
#define TGSRVSTATUS_HRCLOSEERR              -14
#define TGSRVSTATUS_CONNECTIONNOTOPEN       -15
#define TGSRVSTATUS_BADSTATE                -16
#define TGSRVSTATUS_MISSINGYOURNODENAME     -17
#define TGSRVSTATUS_NOTFOUND                -18
#define TGSRVSTATUS_MISSINGPARAMETER        -19
#define TGSRVSTATUS_NODENAMEMISMATCH        -20
#define TGSRVSTATUS_CALLBACKERROR           -21
#define TGSRVSTATUS_NWCMSETNODENAME         -22
#define TGSRVSTATUS_TOOMANYCONNECTIONS      -23
#define TGSRVSTATUS_BADSENDNODENAME         -24
#define TGSRVSTATUS_BADRECVNODENAME         -25
#define TGSRVSTATUS_LCID                    -26
#define TGSRVSTATUS_UNAUTH_NODENAME         -27
#define TGSRVSTATUS_RESPONSEBUFTOOSMALL     -28
#define TGSRVSTATUS_CALLBACKSDISABLED       -29
#define TGSRVSTATUS_REMOTETGCBERR           -30
#define TGSRVSTATUS_INVALIDARG              -31

#define TGSRVSTATUS_LASTONE     TGSRVSTATUS_INVALIDARG


//-------------------------------------------------------------------------
// LC LEVEL ELSIE COMMANDS
// ELSIE returns TGSRVSTATUS_xxx on all commands.  Additional TGSRVPARAM_xxx
// may also be returned depending on the particular TGSRVCMD_xxx.

// ---------------------------------------------------------
// The following is required by LC and generally will not be useful to the user.
//
// We maintain a cache of localIP <-> remoteIP mappings that
// we use on multi-homed systems to determine which local adapter
// to use when sending to a remote IP.
//
// Every TG app (including ELSIE) can have multiple TG CMD SRV
// IP+PORT pairs (if it is running on a multi-homed system).
//
// In our cache, we store only the IP+PORT pairs of remote NODES
// that we know we can communicate with via one of our TG CMD CLI
// adapters.
//
// So its possible for our cache to have multiple entries for
// a node name if multiple local TG CMD CLI adapters can talk
// to multiple remote TG CMD SRV's for that node.  In this case,
// it really doesn't matter that there are multiple entries
// since any one (in particular the first one) will work!
//
// The TG_IPMAP.flag member is a bitwise flag for the entry
//      TGIPMAP_FLAG_DONT_GIVE_OUT is set/cleared by lcExitNode.
//          Elsie's tgcbQuery(GETMAPPING) request will refuse to give
//          out the address (ie the node is being shut down) to
//          requesting nodes if this is set.

typedef struct
    {
    LCIDENT         lcid;               // Logical Computation Identification
    char            remoteTgCmdSrvNodeName[TG_TGCMDSRV_NODENAMESIZE];   // NODE name in that lcid
    TG_IPPORT       local;              // IP+Port of local adapter
    TG_IPPORT       remote;             // IP+Port of remote TG CMD SRV
    unsigned long   flag;               // Bitwise flag
#define TGIPMAP_FLAG_DISABLE_GETMAPPING  0x1 //  1=Don't let ELSIE's tgcbQuery(TGSRVCMD_GETMAPPING) give out IP:PORT
    } TG_IPMAP;


TEMPODLLAPI TG_IPMAP *tgFindMapByRemoteIPPORT(      // Get IPMAP of remote NODE with TGCMDSRV at IP+PORT
    const TG        *hTG,               // TG HANDLE
    TG_IPPORT       *remote);           // Searches local cache for IPMAP

TEMPODLLAPI TG_IPMAP *tgFindMapByRemoteNodeName(    // GET IPMAP of remote NODE by NODE name
    const TG        *hTG,               // TG HANDLE
    LCIDENT         lcid,               // An LCID
    const char      *remoteNodeName);   // Searches local cache for IPMAP
    
long tgRegisterLCID(const TG  *hTG, LCIDENT lcid);    // Defined in TGCACHE.C
                                                // Called by lcInit
                                                
TEMPODLLAPI long tgDeleteMapByRemoteNodeName(
    const TG        *hTG,               // TG HANDLE
    LCIDENT         lcid,               // 0 or An LCID
    const char      *remoteNodeName);   // Node name to delete

                
TEMPODLLAPI long tgDisableMapByRemoteNodeName(
    const TG        *hTG,               // TG HANDLE
    LCIDENT         lcid,               // 0 or An LCID
    const char      *remoteNodeName);   // Node name to delete (NULL for all entries matching LCID)

                
//-------------------------------------------------------------------------
// Symphony allows for a standard Hyperstream object header, TG_HSOBJECTTYPE,
// at the beginning of each Hyperstream object.  This enables applications to
// detect the type of data in an incoming Hyperstream object.
//
// Symphony defines a number of standard object types (TG_HSOT_xxx) but
// the application programmer can also create their own types using
// this mechanism.  Application-defined hsObjectType values range from
// TG_HSOT_BASE_USER to TG_HSOT_BASE_SYMPHONY-1 inclusively.  Symphony
// reserves hsObjectType values from TG_HSOT_BASE_SYMPHONY to ~0, inclusively.
//
// Note that the Symphony Hyperstream specification does not require the
// TG_HSOBJECTYPE header to appear at the beginning of all Hyperstream Objects.
// For instance, if the application programmer controls both the sender and
// receiver side of the connection, the programmer does not need to prefix
// their Hyperstream objects with TG_HSOBJECTYPE; Symphony and Hyperstream
// allow for any binary format for a Hyperstream object.
//
// However, all Symphony-based applications written by Reflective Computing
// assume that objects received and sent are prefixed with the TG_HSOBJECTTYPE
// header.


#define TG_HSOT_BASE_SYMPHONY 0x80000000  // Symphony defined object base
#define TG_HSOT_BASE_USER     0x00000000  // User defined object base

typedef struct
    {
    unsigned long   hsObjectType;       //04 Hyperstream object type code
#define TG_HSOT_UNKNOWN         (TG_HSOT_BASE_SYMPHONY + 0)
#define TG_HSOT_SSEPOCH         (TG_HSOT_BASE_SYMPHONY + 1)
#define TG_HSOT_STACUBE         (TG_HSOT_BASE_SYMPHONY + 2)

    unsigned long   nBytes;             //04 Number of bytes in object (including TG_HSOBJECTTYPE)
    
    unsigned long   reserved[2];        //08 Reserved for future expansion

    } TG_HSOBJECTTYPE;                  //16 Hyperstream object type
    

//-------------------------------------------------------------------------

#endif // ifndef TG_H

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above
