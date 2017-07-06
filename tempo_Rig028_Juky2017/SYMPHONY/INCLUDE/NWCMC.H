#ifndef MSDOS
    #include    "TEMPODLL.h"
#else
    #ifndef TEMPODLLAPI
        #define TEMPODLLAPI
        #pragma message(__FILE__ " defined TEMPODLLAPI as NULL")
    #endif
#endif
/*  .title NWCMC.H - NCM Client side definitions
;+
; SYNOPSIS
;
; DESCRIPTION
;
;
; EDIT HISTORY
;   01Oct06 sh  Initial edit
;   28Jun07 sh  Add nwcmClientEchoMulticast
;-
*/

// FUNCTION PROTOTYPES CLIENT SIDE

TEMPODLLAPI long nwcmClientBong(NWPROTOCOL      *nwp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    unsigned short  serviceType,
                    NWCMCRESPONSE   **pList);
                       
TEMPODLLAPI long nwcmClientEcho(NWPROTOCOL      *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    char            *poolName,
                    NWCMCRESPONSE   **pList);

TEMPODLLAPI long nwcmClientResourceMulticast(NWPROTOCOL *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostNameList,
                    char            *poolName,
                    NWCMCRESPONSE   **pList);
                    
TEMPODLLAPI long nwcmClientEchoMulticast(NWPROTOCOL *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostNameList,
                    char            *poolName,
                    NWCMCRESPONSE   **pList);
                    
TEMPODLLAPI long nwcmClientFree(NWCMCRESPONSE   **pList);

#ifndef MSDOS                                  // Win32
                       
TEMPODLLAPI long nwcmClientExec(NWCM_EXECRQST   *rqst,
                    NWPROTOCOL      *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    NWCMCRESPONSE   **pList);
                       
TEMPODLLAPI long nwcmClientStat(NWCM_STATRQST   *rqst,
                    NWPROTOCOL      *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    NWCMCRESPONSE   **pList);
                       
TEMPODLLAPI long nwcmClientTerm(NWCM_TERMRQST   *rqst,
                    NWPROTOCOL      *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    NWCMCRESPONSE   **pList);
                       
TEMPODLLAPI long nwcmClientConn(NWCM_CONNRQST   *rqst,
                    NWPROTOCOL      *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    NWCMCRESPONSE   **pList);
                       
TEMPODLLAPI long nwcmClientProc(NWCM_PROCRQST   *rqst,
                    NWPROTOCOL      *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    NWCMCRESPONSE   **pList);
                       
TEMPODLLAPI long nwcmClientInfo(NWPROTOCOL      *udp,
                    unsigned short  udpRemotePort,
                    char            *remoteHostName,
                    char            *poolName,
                    NWCMCRESPONSE   **pList);

#endif  // ifndef MSDOS


#ifndef MSDOS
    #include    "TEMPODLX.h"
#endif
