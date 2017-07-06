/*  .title  DDEERR - DDE Error messages
;+
; SYNOPSIS
;   char *ddeerr(long err);
;
; DESCRIPTION
;   This routine returns a static DDE error string.
;
;   We give a short form of the error message.  The long form is
;   listed as a comment.
;
; EDIT HISTORY
;   11Jun99 sh  Initial edit
;-
*/
#include    <windows.h>

#include    "ddeerr.h"

//---------------------------------------------------------------------
char *
ddeerr(long err)
{
switch (err)
    {
    case DMLERR_NO_ERROR:
        return("DDEERR operation successful.");
        
    case DMLERR_ADVACKTIMEOUT:
        return("DDEERR Synchronous advise transaction timed out");

    case DMLERR_BUSY:
        return("DDEERR Response to the transaction set DDE_FBUSY");

    case DMLERR_DATAACKTIMEOUT:
        return("DDEERR Synchronous data transaction timed out");

    case DMLERR_DLL_NOT_INITIALIZED:
            // A DDEML function was called without first calling the
            // DdeInitialize function, or an invalid instance identifier
            // was passed to a DDEML function.
        return("DDEERR DDEML not initialized or bad hInst");

    case DMLERR_DLL_USAGE:
            // An application initialized as APPCLASS_MONITOR has
            // attempted to perform a dynamic data exchange (DDE)
            // transaction, or an application initialized as
            // APPCMD_CLIENTONLY has attempted to perform server
            // transactions
        return("DDEERR Improper use of a DDEML function");

    case DMLERR_EXECACKTIMEOUT:
            // A request for a synchronous execute transaction has timed out
        return("DDEERR Synchronous execute request timed out");

    case DMLERR_INVALIDPARAMETER:
            // A parameter failed to be validated by the DDEML. Some of
            // the possible causes follow:  The application used a data
            // handle initialized with a different item name handle than
            // was required by the transaction.  The application used a
            // data handle that was initialized with a different clipboard
            // data format than was required by the transaction.  The
            // application used a client-side conversation handle with a
            // server-side function or vice versa.The application used a
            // freed data handle or string handle.  More than one instance
            // of the application used the same object
        return("DDEERR Invalid DDEML parameter");

    case DMLERR_LOW_MEMORY:
            // A DDEML application has created a prolonged race condition
            // (in which the server application outruns the client),
            // causing large amounts of memory to be consumed
        return("DDEERR DDEML memory low due to server flooding client");

    case DMLERR_MEMORY_ERROR:
         return("DDEERR No memory");

    case DMLERR_NO_CONV_ESTABLISHED:
         return("DDEERR Client attempt to establish a conversation failed");

    case DMLERR_NOTPROCESSED:
         return("DDEERR A transaction has failed");

    case DMLERR_POKEACKTIMEOUT:
         return("DDEERR Synchronous poke transaction timed out");

    case DMLERR_POSTMSG_FAILED:
         return("DDEERR An internal DDEML call to PostMessage() failed");

    case DMLERR_REENTRANCY:
         // An application instance with a synchronous transaction
         // already in progress attempted to initiate another
         // synchronous transaction, or the DdeEnableCallback function
         // was called from within a DDEML callback function
         return("DDEERR DDEML reentrancy is not allowed");

    case DMLERR_SERVER_DIED:
         // A server-side transaction was attempted on a conversation
         // terminated by the client, or the server terminated before
         // completing a transaction
         return("DDEERR The other side terminated");

    case DMLERR_SYS_ERROR:
         return("DDEERR Internal error in the DDEML");

    case DMLERR_UNADVACKTIMEOUT:
         return("DDEERR Request to end advise transaction timed out");

    case DMLERR_UNFOUND_QUEUE_ID:
         // An invalid transaction identifier was passed to a DDEML
         // function. Once the application has returned from an
         // XTYP_XACT_COMPLETE callback, the transaction identifier
         // for that callback function is no longer valid
         return("DDEERR DDEML detected invalid transaction identifier");

    default:
        return("DDEERR unknown error detected");
    }
}
