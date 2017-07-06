//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

/*  .title  HTB.H       Defintions used by the HTB functions
;+
; USAGE
;   #include "htb.h"
;
; DESCRIPTION
;   This file contains definitions used by the HTB functions.
;
; EDIT HISTORY
;   12Dec06 sh  Initial edit
;-
*/
#ifndef HTB_H
#define HTB_H

#ifndef _WINDOWS_
    typedef unsigned char   UCHAR;
    typedef unsigned short  USHORT;
    typedef unsigned long   ULONG;
#endif

// NAMES FOR HTB FORMAT (FUNCTION) TYPES 
// NOTE: This table must agree with SYSTEM.H HFUNC_xxx settings

    typedef signed   short  HTYPE_SUM;      // SUM for 8 bit ANALOG data in 16 bit short
    typedef signed   char   HTYPE_APP;      // APP for 8 bit ANALOG data
    typedef unsigned short  HTYPE_USUM;     // SUM for COUNTER data
    typedef unsigned short  HTYPE_UAPP;     // APP for COUNTER data
    typedef unsigned short  HTYPE_ESUM;     // SUM for EVENT data
    typedef unsigned short  HTYPE_EAPP;     // APP for EVENT data
    typedef signed   short  HTYPE_XSUM;     // XSUM for 12 bit analog data
    typedef signed   short  HTYPE_XAPP;     // XAPP for 12 bit analog data

//----------------------------------------------------------------------

typedef struct                          // Defined to facilitate naming
    {                                   // Of HTABLE formats
    char    *name;
    unsigned char func;

#ifndef HFUNC_SUM
    #define HFUNC_SUM   0                   //  signed 8 bit analog SUM
    #define HFUNC_APP   1                   //  signed 8 bit analog APP
    #define HFUNC_USUM  2                   //  unsigned 12/16 bit counter USUM
    #define HFUNC_UAPP  3                   //  unsigned 12/16 bit counter UAPP
    #define HFUNC_ESUM  4                   //  unsigned 12/16 bit event ESUM
    #define HFUNC_EAPP  5                   //  unsigned 12/16 bit event EAPP
    #define HFUNC_XSUM  6                   //  signed 12/16 bit analog XSUM
    #define HFUNC_XAPP  7                   //  signed 12/16 bit analog XAPP
#endif
#ifndef HFUNC_SUM32
    #define HFUNC_SUM32 8                   //  signed 32 bit SUM data
    #define HFUNC_APP32 9                   //  signed 32 bit APPEND data
#endif
    
    /*lint -esym(754,filler) */         // symbol not referenced
    char    filler;
    short   sample_size;
    char    *description;
    } HFUNC;



//----------------------------------------------------------------------
// HTB database header in HTB file

typedef struct
    {                                   // OFFSET
    char    date[26];                   // 00-25    time/date saved (formatted by ctime)
    long    ldate;                      // 26-29    time/date (from time) equivalent to date
    char    cfg_file[14];               // 30-43    Null terminated configuration file name
    char    pro_file[14];               // 44-57    Null terminated protocol file name
    char    unused0[52];                // 58-109
    ULONG   speed;                      // 110-113  Speed of acquisition
    ULONG   alloc;                      // 114-117  # of bytes occupied by database in file (including header)

    long    offset;                     // 118-121  Offset from trigger point 
    ULONG   period;                     // 122-126  length of histogram 
    ULONG   extension;                  // 127-129  cancel vunerable time after period 
    USHORT  skip;                       // 130-131  # of additional ring buffer bins per database bins [0..) (=TPB-1)
    USHORT  first_channel;              // 132-133  First channel to accumulate (0, 1, .. ) 
    USHORT  nchannels;                  // 134-135  # of channels in a channel set (1, 2, .. ) 
    USHORT  sweep_limit;                // 136-137  Maximum number of functions 
    ULONG   cancel_override;            // 138-141  Cancel override bits 
    UCHAR   func;                       // 142-142  Function to perform 
                                        //           HFUNC_SUM new data in to histogram 
                                        //           HFUNC_APP new data to histogram 
    char    unused;                     // 143-143
    USHORT  tag;                        // 144-145  Class to which this histogram is a member 

    // THE FOLLOWING ARE COMPUTED FROM THE ABOVE VALUES
    // These values must NOT be changed except by the KERNEL
        
    USHORT  npages;                     // 146-147  # of 16kb EMM pages allocated 
    ULONG   nsamples;                   // 148-151  Total number of channel sets 
    USHORT  samples_per_page;           // 152-153  # of channel sets per page 
    USHORT  sweep;                      // 154-155  Current number of sweeps 
    USHORT  next_page;                  // 156-157  Next page location for new data 
    USHORT  next_off;                   // 158-159  Next offset location for new data

    char    title[80];                  // 160-239  Database title
    ULONG   speed_units;                // 240-243  Units of speed
    char    filler[268];                // 244-511  Fill out to 512
    } HTB;
    


//----------------------------------------------------------------------
// HTBFILE - User's pointer to an HTBFILE_ structure

typedef struct
    {
    void        *p;
    } HTBFILE;
    

//----------------------------------------------------------------------
// ERROR RETURN CODES FOR HTB functions

#define HTBERR_OK                    0  // No errors
#define HTBERR_BADHANDLE            -1  // Invalid HTBFILE handle
#define HTBERR_NOMEMORY             -2  // No memory
#define HTBERR_CANTOPEN             -3  // Can't open HTB file
#define HTBERR_CANTCLOSE            -4  // Can't open HTB file
#define HTBERR_CANTSEEK             -5  // Can't seek HTB file
#define HTBERR_CANTREAD             -6  // Can't read HTB file
#define HTBERR_BADDB                -7  // Invalid DB index
#define HTBERR_BADEPOCH             -8  // Invalid iEpoch
#define HTBERR_CANTOPENNEWDB        -9  // Can't open new DB for write
#define HTBERR_NEWDBNOTOPEN        -10  // New DB not open
#define HTBERR_INVALIDFUNC         -11  // htb.func is invalid
#define HTBERR_INVALIDEPOCHSIZE    -12  // htb.period or htb.nchannels is invalid
#define HTBERR_SWEEPLIMITREACHED   -13  // Can't write new epoch; sweep limit reached.
#define HTBERR_CANTWRITE           -14  // Can't write HTB file
#define HTBERR_COMMIT              -15  // Error committing blocks to disk

#define HTBERR_LASTONE      HTBERR_COMMIT

TEMPODLLAPI long htbOpen(HTBFILE *hf, char *filename, long rdwr);
TEMPODLLAPI long htbClose(HTBFILE *hf);
TEMPODLLAPI long htbGetHeader(HTBFILE *hf, long iDB, HTB **ppHtb);
TEMPODLLAPI long htbGetEpoch(HTBFILE *hf, long iDb, long iEpoch, void *epochData);
TEMPODLLAPI long htbGetEpochSize(HTBFILE *hf, long iDb, long *pnEpochSize);
TEMPODLLAPI long htbGetBytesPerSample(HTBFILE *hf, long iDb, long *pnBytesPerSample);
TEMPODLLAPI long htbGetBytesPerSampleFunc(long func, long *pnBytesPerSample);
TEMPODLLAPI long htbGetFuncName(long func, char *funcName, long nFuncName);
TEMPODLLAPI long htbGetNEpochs(HTBFILE *hf, long iDb, USHORT *pnEpochs);
TEMPODLLAPI long htbGetNDatabases(HTBFILE *hf, long *pnDb);
TEMPODLLAPI char *htbErr(long err);

TEMPODLLAPI long htbOpenNewDB(HTBFILE *hf, HTB *phtb);
TEMPODLLAPI long htbAccumulateEpoch(HTBFILE *hf, void *epochData);
TEMPODLLAPI long htbCloseNewDB(HTBFILE *hf);


#endif  // HTB_H

#include    "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above
