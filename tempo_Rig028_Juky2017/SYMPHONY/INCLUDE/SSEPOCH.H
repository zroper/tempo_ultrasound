//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

/*  .title  SSEPOCH - Epoch data produced by TEMPO/COBALT Symphony server
;+
; DESCRIPTION
;   This file contains definitions for Symphony's SSEPOCH struture.  This structure
;   is used by TEMPOW and COBALT to emit hyperstream objects containing database epochs.
;
;
; WARNING
;   These data structures are not designed for persistent storage (ie in a file).  
;
;   Rather, they are intended to be used by nodes to communicate DB epoch information.
;
;   In future Symphony releases, Reflective Computing may add new members, rearrange
;   existing members or change the size of (increase or decrease) these structures.
;
;   Reflective Computing requires that you recompile all of your custom programs with
;   each new Symphony release.
;
;   If you would like to store this information in a persistent data structure (file
;   or database), we recommend that you create your own data structure then copy the
;   members of these structure to it.  This way, your programs will continue to work
;   if we decide to change these structures (by adding new members, rearranging members
;   or changing the size of a structure).
;   
;
;
; EDIT HISTORY
;   13Mar07 sh  Moved from SSTEMPO.H
;               Change USHORT->ULONG: nEpoch, nEpochsAccumulated, nMaxEpochs
;               Add additional optional objects: PerChannelData, PerEpochData and UserData
;               Expand header to 256 bytes
;               Distribute reserved space
;   01Oct07 sh  Add SSEPOCH_FLAG_DATAORDER
;               Add HFUNC_SUM32F signed 32 bit float     Sum
;               Add HFUNC_APP32F signed 32 bit float     Append
;               Add HFUNC_SUM64F signed 64 bit double    Sum
;               Add HFUNC_APP64F signed 64 bit double    Append
;   11Oct07 sh  Add ssepochUnloadChannel
;   03Aug08 sh  Add TG_HSOBJECTTYPE to SSEPOCH
;   25Sep08 sh  Include TG.H
;   21Jan09 sh  Add ssepochHeaderTypeDefine(long ssHeaderType)
;   22Mar09 sh  Add CHANINFO
;   24Mar09 sh  Added 16 bytes at end of SSEPOCH to make it 256 bytes and to leave extra room for growth
;   25Mar09 sh  Move CHANINFO structure and definitions to CHANINFO.H
;   20May09 sh  Add ssepochPChannelFirstSample
;   19Nov09 sh  Improve comments; change SSEPOCH_CHANINFO to CHANINFO
;-
*/
#ifndef SSEPOCH_H
#define SSEPOCH_H

#ifndef TG_H
    #include "TG.H"
#endif


//---------------------------------------------------------------------
// Structure of TEMPO/COBALT TG/Hyperstream objects.
// Each object has this header followed by zero or more bytes of data.

#ifndef HTYPE_SUM                           // Standard TEMPO/COBALT definitions
    typedef signed   short  HTYPE_SUM;      // SUM for 8 bit ANALOG data
    typedef signed   char   HTYPE_APP;      // APP for 8 bit ANALOG data
    typedef unsigned short  HTYPE_USUM;     // SUM for COUNTER data
    typedef unsigned short  HTYPE_UAPP;     // APP for COUNTER data
    typedef unsigned short  HTYPE_ESUM;     // SUM for EVENT data
    typedef unsigned short  HTYPE_EAPP;     // APP for EVENT data
    typedef signed   short  HTYPE_XSUM;     // XSUM for 12 bit analog data
    typedef signed   short  HTYPE_XAPP;     // XAPP for 12 bit analog data
#endif


#ifndef HTYPE_SUM32                         // Symphony extensions to TEMPO/COBALT database types
    typedef long    HTYPE_SUM32;
    typedef long    HTYPE_APP32;
    typedef float   HTYPE_SUM32F;
    typedef float   HTYPE_APP32F;
    typedef double  HTYPE_SUM64F;
    typedef double  HTYPE_APP64F;
#endif
    


typedef struct
    {
    TG_HSOBJECTTYPE hsObjectType;           //32 Standard HyperStream type TG_HSOT_SSEPOCH
                                            
    char            headerType;             //01 Type of this header
#define SS_HEADERTYPE_BEGIN          1      // Begin data with DB format
#define SS_HEADERTYPE_END            2      // End data with DB format
#define SS_HEADERTYPE_ZEROED         3      // DB has been zeroed
#define SS_HEADERTYPE_EPOCHDATA      4      // New epoch data

#define SS_HEADERTYPE_LASTONE   SS_HEADERTYPE_EPOCHDATA

    char            Func;                   //01 Type of database
#ifndef HFUNC_SUM                           //  SAMPLE PROPERTIES       DB TYPE
    #define HFUNC_SUM       0               //  signed    16 bit short  Sum
    #define HFUNC_APP       1               //  signed     8 bit char   Append
    #define HFUNC_USUM      2               //  unsigned  16 bit short  Sum
    #define HFUNC_UAPP      3               //  unsigned  16 bit short  Append
    #define HFUNC_ESUM      4               //  unsigned  16 bit short  Sum
    #define HFUNC_EAPP      5               //  unsigned  16 bit short  Append
    #define HFUNC_XSUM      6               //  signed 12/16 bit short  Sum
    #define HFUNC_XAPP      7               //  signed 12/16 bit short  Append
#endif
                                  
#ifndef HFUNC_SUM32                         // Symphony extensions to TEMPO/COBALT database types
    #define HFUNC_SUM32     8               //  signed    32 bit long   Sum
    #define HFUNC_APP32     9               //  signed    32 bit long   Append    
    #define HFUNC_SUM32F   10               //  signed    32 bit float  Sum
    #define HFUNC_APP32F   11               //  signed    32 bit float  Append
    #define HFUNC_SUM64F   12               //  signed    64 bit double Sum
    #define HFUNC_APP64F   13               //  signed    64 bit double Append
    
    #define HFUNC_LASTONE   HFUNC_APP64F
    
#endif

    unsigned short  flag;                   //02 Flag word
#define SSEPOCH_FLAG_AUTODOWNLOAD   0x01    //  ==1 iff this epoch was sent automatically
                                            //  ==0 iff this epoch was manually requested by application
                                        
#define SSEPOCH_FLAG_DATAORDER      0x02    //  ==0 iff sample data is in time order (ie by channel set)
                                            //  ==1 iff sample data is in channel order
                                            // 01Oct07 TEMPO and COBALT databases are in time order

    // Database Sequencing information
    // -------------------------------

    unsigned char   FmtSeqNo;               //01 Client's DB hdr seq #                        
    unsigned char   ZeroSeqNo;              //01 Client's HZERO seq #
    unsigned char   TitleSeqNo;             //01 Client's title sequence number
    unsigned char   FileSeqNo;              //01 Client's file sequence number
    
    unsigned long   nEpoch;                 //04 Epoch count for data in this object, if any 0 or [1,..nMaxEpochs]
    unsigned long   nEpochsAccumulated;     //04 Current # of epochs accumulated on TEMPO/COBALT [0,..nMaxEpochs]
    unsigned long   nMaxEpochs;             //04 Maximum # of epochs allocated for TEMPO/COBALT database
    
    char            reserved1[16];          //16 Reserved
    

    // Database parameters
    // -------------------
    
    short           nDb;                    //02 Database number on CLIENT [1,2..]
    short           Tag;                    //02 Database trigger tag
    long            Period;                 //04 # of channel sets per epoch
    long            Offset;                 //04 # of channel sets offset to trigger
    long            Extension;              //04 # of channel sets extended to end of db
    unsigned long   CancelOverride;         //04 Cancel override bits
    unsigned short  skip;                   //02 # of additional ring buffer bins per DB bin (0-based, =TPB-1)
    unsigned short  nBytesPerSample;        //02 # of bytes per sample
    unsigned short  firstChannel;           //02 First data channel 1-based [1,2,..]
    unsigned short  nChannels;              //02 # of channels per channel set. [1,2..]
    unsigned long   Speed;                  //04 Current speed
    unsigned long   SpeedUnits;             //04 Divisor for speed
    char            Title[80];              //80 Database title
    
    char            reserved2[24];          //24 Reserved
    

    // Object control information (includes the SSEPOCH_HEADER and all optional objects)
    // ---------------------------------------------------------------------------------
    
    unsigned long   nHeaderBytes;           //04 # of bytes in this header
    unsigned long   nObjectBytes;           //04 Total # of bytes in this object (header+data)
    

    // Optional objects
    // ----------------
    
    // 22Mar09 If sample is present, the following values are non-zero
    // The standard Symphony sample data is a matrix of sample values in channel set order.
    // In memory, the sample matrix follows the SSEPOCH_HEADER
    // The data type of each sample is defined by the Func member.
    // The number of channels is defined by nChannels (# cols).
    // The number of channel sets is defined by nPeriod (# rows).
    
    unsigned long   nDataBytes;             //04 # of bytes in sample matrix
    unsigned long   nOffsetToData;          //04 offset (# bytes from beginning of SSEPOCH_HEADER) to sample matrix
    

    // 19Nov09 The Channel Information Table is an optional data structure that contains
    // information about each data channel.  The channel information table is typically
    // layed out to follow the sample matrix in memory.
    // The standard Symphony per-channel structures is CHANINFO (see CHANINFO.H).
    //
    // If a channel information table is present, the following values are non-zero
    //
    //          SSEPOCH_HEADER.nPerChannelDataBytes        // sizeof(CHANINFO) * eh->nChannels
    //          SSEPOCH_HEADER.nOffsetToPerChannelData     // # of bytes from beginning of SSEPOCH_HEADER..
    //                                                     // ..to first byte of CHANINFO table.
    //
    // The following pseudo code shows how to compute the pointer to the CHANINFO table
    // given a pointer, eh, to the SSEPOCH_HEADER.
    //
    //          SSEPOCH_HEADER *eh;
    //
    //          CHANINFO *ci = (CHANINFO *) ((char *) eh + eh->nOffsetToPerChannelData))
    //
    // There are eh->nChannels of the CHANINFO structures in the channel information table.
    // Standard Symphony nodes such as TEMPOW and COBALT's Symphony server include a
    // channel information table in the SSEPOCHs they produce.  For other nodes that
    // emit SSEPOCHs, if the channel information is available, it is recommended that
    // the CHANINFO table be included in the SSEPOCH.
    
    unsigned long   nPerChannelDataBytes;   //04 # of bytes of per-channel data (see CHANINFO.H
    unsigned long   nOffsetToPerChannelData;//04 Offset (# bytes from beginning of header) to CHANINFO table
    
    
    
    unsigned long   nPerEpochDataBytes;     //04 # of bytes of per-epoch data
    unsigned long   nOffsetToPerEpochData;  //04 Offset (# bytes from beginning of header) to object
    
    
    
    unsigned long   nPerUserDataBytes;      //04 # of bytes of user data
    unsigned long   nOffsetToPerUserData;   //04 Offset (# bytes from beginning of header) to object
    
    char            reserved3[24];          //24 Reserved
    
    } SSEPOCH_HEADER;                       //256 bytes total



//---------------------------------------------------------------------
// HELPFUL MACROS

        
    

    

//---------------------------------------------------------------------
// FUNCTION PROTOTYPES


TEMPODLLAPI long ConvertUSToBins(long us, long speed, long speedUnits, long skip);
TEMPODLLAPI long ConvertBinsToUS(long bins, long speed, long speedUnits, long skip);
TEMPODLLAPI long ssepochConvertData(SSEPOCH_HEADER *in, SSEPOCH_HEADER **ppout, long newFunc, long newOrder);
TEMPODLLAPI long ssepochUnloadChannel(SSEPOCH_HEADER *in, long iChannel, double **ppdata);
TEMPODLLAPI long ssepochLoadChannel(SSEPOCH_HEADER *in, long iChannel, double *pdata);
TEMPODLLAPI char *ssepochHfuncName(long hfunc);
TEMPODLLAPI char *ssepochHeaderTypeName(long ssHeaderType);
TEMPODLLAPI char *ssepochHeaderTypeDefine(long ssHeaderType);
TEMPODLLAPI void *ssepochPChannelFirstSample(SSEPOCH_HEADER *eh, long iChannel);


//---------------------------------------------------------------------
#endif // ifndef SSEPOCH_H

#include    "TEMPODLX.H"
#pragma pack(pop)                           // See pragma pack(push,1) above
