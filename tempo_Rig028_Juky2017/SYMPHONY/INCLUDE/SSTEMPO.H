/*  .title  SSTEMPO.H - TEMPO+COBALT Symphony Server Interface
;+
; EDIT HISTORY
;   14Aug06 sh  Initial edit
;   29Oct06 sh  Rename to LC_HEADEDTYPE_BEGIN, _END, _ZEROED
;   21Nov06 sh  Add definitions for TEMPO/COBALT's Symphony server
;               Rename .H from lcepoch.h to lctempo.h
;   28Nov06 sh  Change prefix from LC to SS
;   29Nov06 sh  Add nEpochsAccumulated, change nEpochs->nEpoch
;               Add flag and SSEPOCH_FLAG_xxx definitions
;   03Dec06 sh  Add SSTEMPOERR_CANTDELHOTNODES
;   17Jan07 sh  Add HFUNC_SUM32 symphony extensions to TEMPO's database types
;               Add prefix for parameter names in SYSINFO and DB topics
;               Make all topic names upper case
;               Make all topic's parameter names upper case
;               Make all request and response names upper case
;   13Mar07 sh  Move SSEPOCH to SSEPOCH.H
;-
*/
#ifndef SSTEMPO_H
#define SSTEMPO_H

#pragma pack(push, 1)                       // 1-byte structure packing

#include    "ssepoch.h"                     // Include definition of SSEPOCH type



#define     SSTEMPO_NODENAME    "tempow"    // Default NODE name for TEMPO
#define     SSCOBALT_NODENAME   "cobalt"    // Default NODE name for COBALT

//---------------------------------------------------------------------
// The following are the Symphony server parameters that TEMPO/COBALT accept
// as requests

#define SSTEMPO_REQUEST                 "REQUEST"             // Type of request
#define     SSTEMPO_REQUEST_COMMAND        "COMMAND"          //   Execute one or more TEMPO commands
#define     SSTEMPO_REQUEST_GET            "GET"              //   Get the values of one or more items
#define     SSTEMPO_REQUEST_CREATEHOTLINK  "CREATEHOTLINK"    //   Establish one or more hot links to items
#define     SSTEMPO_REQUEST_DESTROYHOTLINK "DESTROYHOTLINK"   //   Destroy one or more hot links to items
#define SSTEMPO_RESPONSE                "RESPONSE"            // Type of response
#define     SSTEMPO_RESPONSE_COMMAND        SSTEMPO_REQUEST_COMMAND         //   Execute one or more TEMPO commands
#define     SSTEMPO_RESPONSE_GET            SSTEMPO_REQUEST_GET             //   Get the values of one or more items
#define     SSTEMPO_RESPONSE_CREATEHOTLINK  SSTEMPO_REQUEST_CREATEHOTLINK   //   Establish one or more hot links to items
#define     SSTEMPO_RESPONSE_DESTROYHOTLINK SSTEMPO_REQUEST_DESTROYHOTLINK  //   Destroy one or more hot links to items
#define     SSTEMPO_RESPONSE_HOTUPDATE      "HOTUPDATE"                     //   HOT ITEM updates (sent to NODE's tgcbReceive())

// For SSTEMPO_REQUEST_GET, each request parameter has the form: topic , item, format

#define SSTEMPO_REQUEST_GET_TOPIC_SYSINFO       "SYSINFO"
    #define SSTEMPO_REQUEST_GET_SYSINFO_DATABASES      "SI.DATABASES"
    #define SSTEMPO_REQUEST_GET_SYSINFO_ACHANNELS      "SI.ACHANNELS"
    #define SSTEMPO_REQUEST_GET_SYSINFO_CCHANNELS      "SI.CCHANNELS"
    #define SSTEMPO_REQUEST_GET_SYSINFO_ECHANNELS      "SI.ECHANNELS"
    #define SSTEMPO_REQUEST_GET_SYSINFO_SPEED          "SI.SPEED"
    #define SSTEMPO_REQUEST_GET_SYSINFO_ASETS          "SI.ASETS"
    #define SSTEMPO_REQUEST_GET_SYSINFO_STATUS         "SI.STATUS"
    #define SSTEMPO_REQUEST_GET_SYSINFO_CANCEL         "SI.CANCEL"
    #define SSTEMPO_REQUEST_GET_SYSINFO_CLOCK          "SI.CLOCK"
    #define SSTEMPO_REQUEST_GET_SYSINFO_ANALOGBITS     "SI.ANALOGBITS"
    #define SSTEMPO_REQUEST_GET_SYSINFO_LOST           "SI.LOST"
    
#define SSTEMPO_REQUEST_GET_TOPIC_DB            "DB"
    #define SSTEMPO_REQUEST_GET_DB_FMTSEQNO            "DB.FMTSEQNO"
    #define SSTEMPO_REQUEST_GET_DB_ZEROSEQNO           "DB.ZEROSEQNO"
    #define SSTEMPO_REQUEST_GET_DB_TITLESEQNO          "DB.TITLESEQNO"
    #define SSTEMPO_REQUEST_GET_DB_FILESEQNO           "DB.FILESEQNO"
    #define SSTEMPO_REQUEST_GET_DB_TYPE                "DB.TYPE"
    #define SSTEMPO_REQUEST_GET_DB_EPOCHCOUNT          "DB.EPOCHCOUNT"
    #define SSTEMPO_REQUEST_GET_DB_MAXEPOCHCOUNT       "DB.MAXEPOCHCOUNT"
    #define SSTEMPO_REQUEST_GET_DB_HANDLE              "DB.HANDLE"
    #define SSTEMPO_REQUEST_GET_DB_PERIOD              "DB.PERIOD"
    #define SSTEMPO_REQUEST_GET_DB_EXTENT              "DB.EXTENT"
    #define SSTEMPO_REQUEST_GET_DB_OFFSET              "DB.OFFSET"
    #define SSTEMPO_REQUEST_GET_DB_CANCEL              "DB.CANCEL"
    #define SSTEMPO_REQUEST_GET_DB_SKIP                "DB.SKIP"
    #define SSTEMPO_REQUEST_GET_DB_NCHANNELS           "DB.NCHANNELS"
    #define SSTEMPO_REQUEST_GET_DB_FIRSTCHANNEL        "DB.FIRSTCHANNEL"
    #define SSTEMPO_REQUEST_GET_DB_DIRTY               "DB.DIRTY"
    #define SSTEMPO_REQUEST_GET_DB_SPEED               "DB.SPEED"
    #define SSTEMPO_REQUEST_GET_DB_SPEEDUNITS          "DB.SPEEDUNITS"
    #define SSTEMPO_REQUEST_GET_DB_TAG                 "DB.TAG"
    #define SSTEMPO_REQUEST_GET_DB_FILENAME            "DB.FILENAME"
    #define SSTEMPO_REQUEST_GET_DB_TITLE               "DB.TITLE"
    #define SSTEMPO_REQUEST_GET_DB_EPOCHDATA           "DB.EPOCHDATA"

#define SSTEMPO_REQUEST_GET_TOPIC_EXPRESSION    "EXPRESSION"
// The "item" for an EXPRESSION topic is the expression itself

//---------------------------------------------------------------------
// The following formats are recognized where a format is specified

#define SSTEMPO_FORMAT_DEFAULT              "DEFAULT"
#define SSTEMPO_FORMAT_INT                  "INT"
#define SSTEMPO_FORMAT_FLOAT                "FLOAT"
//#define SSTEMPO_FORMAT_STRING               "STRING"
//#define SSTEMPO_FORMAT_HEX                  "HEX"   


//---------------------------------------------------------------------
// TEMPO's Symphony server returns the following codes from its TG callback funnctions

#define SSTEMPOERR_OK                      0    // Operation was successful
#define SSTEMPOERR_INVALIDREQUESTBUFFER   -1    // Invalid request buffer
#define SSTEMPOERR_INVALIDRESPONSEBUFFER  -2    // Invalid response buffer
#define SSTEMPOERR_INVALIDREQUEST         -3    // Invalid request
#define SSTEMPOERR_PARAMERR               -4    // Error accessing parameter list
#define SSTEMPOERR_INVALIDTOPIC           -5    // TOPIC is invalid
#define SSTEMPOERR_INVALIDITEM            -6    // ITEM is invalid
#define SSTEMPOERR_INVALIDFORMAT          -7    // FORMAT is invalid
#define SSTEMPOERR_NODATABASE             -8    // Database does not exist
#define SSTEMPOERR_CANTADDHOTITEM         -9    // Error adding ITEM to hot list
#define SSTEMPOERR_CANTDELHOTITEM         -10   // Error deleting ITEM from hot list
#define SSTEMPOERR_PARSEITEM              -11   // Error parsing ITEM string
#define SSTEMPOERR_EVALUATEITEM           -12   // Error evaluating ITEM
#define SSTEMPOERR_CONVERTITEM            -13   // Error converting ITEM value to string
#define SSTEMPOERR_CANTDELHOTNODES        -14   // Error deleting a HOT NODE
#define SSTEMPOERR_CANTDELHSCONNECTIONS   -15   // Error deleting HyperStream Connection
                

#define SSTEMPOERR_LASTONE      SSTEMPOERR_CANTDELHSCONNECTIONS


//---------------------------------------------------------------------
// When opening a connection to a TEMPO/COBALT database, the following
// parameters can be specified in your connection parameter list.

#define SSTEMPO_CONNECTPARAM_DB             "DB"            // DB=n [1,2,..] Database to connect to
#define SSTEMPO_CONNECTPARAM_OBJECTSIZE     TGSRVPARAM_MDBOBJECTSIZE // Maximum size of an object in FIFO
#define SSTEMPO_CONNECTPARAM_OBJECTS        TGSRVPARAM_MDBOBJECTS    // Minimum number of objects in send FIFO
#define SSTEMPO_CONNECTPARAM_AUTODOWNLOAD   "AUTODOWNLOAD"  // =YES or NO to automatically download new epochs


#pragma pack(pop)                               // Restore original structure packing

#endif  // ifndef SSTEMPO_H

