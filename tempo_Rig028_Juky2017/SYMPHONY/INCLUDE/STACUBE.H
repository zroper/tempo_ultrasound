//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "tempodll.h"

/*  .title  STACUBE.H  Definitions for STAWKR Triggered Average cube
;+
; DESCRIPTION
;   This file defines the data structures for the STAWKR triggered
;   average cube.
;
;   This file describes the STACUBE and STAAVERAGE structures.
;   Neither can be fully described in C because they include 
;   several variable length arrays.
;
;   Userful macros are also defined to make it easier to obtain
;   information and pointers when working with STACUBEs
;   and STAAVERAGEs.
;
;
; Limitations on these data structures
;
;   The data structures here describe the format for the objects
;   that are sent over a hyperstream connection.  As such, they
;   do not contain pointers or references to external resources
;   (ie memory, handles, etc).  Instead, offsets are used within the
;   data structures to reference other items within the structure.
;
;   Thus, the entire memory structure for an STACUBE is self-contained
;   and is designed for short term persistent storage (within program
;   memory) or for transmission over a Hyperstream connection.
;
;   Any future enhancements to these structures must take this
;   into account.  For example, a pointer should never
;   be added to STACUBE or STAAVERAGE.  Nor should Handles to
;   Windows objects because they are not portable across a network.
;   References to files could be added provided they are self-contained
;   character strings and the full path, including location
;   within the network, is included or implied.
;
;   The memory bytes representing an STACUBE can be copied from one
;   place to another in program memory, written to disk and read back
;   into a different location, or transmitted over a hyperstream connection.
;
;   With regard to "long term" persistent storage (ie writing
;   STACUBEs to a file), it is NOT recommendend that you use thse
;   data structures because they may be changed in the future.
;   Any changes to these structures would invalidate files that
;   have stored objects using previous versions of the structures.
;   If you want to store STACUBEs in long term persistent storage,
;   we recommend you create your own format.
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
; SEE ALSO
;   See Symphony's CHANINFO.H structure for the layout of the three CHANINFO tables
;
;
; EDIT HISTORY
;   25Jul08 sh  Initial edit
;   08Nov08 sh  Change names to match STAWKR documentation
;   03Dec08 sh  Change names to "stacube"
;               Add function prototypes
;   04Dec08 sh  Correct documentation
;               Include tg.h and add reserved values to structures
;   05Dec08 sh  Add more comments, remove stacubeUninit
;               rename stacubeInit to stacubeInitialize.
;   01Feb09 sh  Add STACUBE.nRun and STACUBE.nEpoch
;   25Mar09 sh  Add 3 CHANINFO tables and offsets/nBytes to each
;               move nBytes to end of STACUBE structure
;-
*/

#ifndef STACUBE_H
#define STACUBE_H

#ifndef TG_H
    #include    "tg.h"                  // Symphony definitions
#endif

#ifndef CHANINFO_H
    #include    "chaninfo.h"            // Symphony definitions
#endif


//--------------------------------------------------------
// The STACUBE_DATATYPE specifies the C/C++ data type for
// the SUM and LAST arrays in STAAVERAGE structure.

typedef double STACUBE_DATATYPE;        // Data type for sample data



//--------------------------------------------------------
// The STAAVERAGE structure defines the contents of one element
// in the STA cube.
//
// The data for SUM and LAST wavelets are allocated immediately following
// the STAAVERAGE header.

typedef struct
    {
    unsigned long       nSum;           //04 Number of wavelets added to sumArray[]

    // Data for each STAAVERAGE comes from sample data such as analog data.
    // STAAVERAGE data may have come from different databases with different
    // sampling rates.  The sampling rate of an STAAVERAGE is stored
    // in the uBinwidth member.  This governs the temporal interpretation of
    // of the sample values (ie the duration) in sumArray[] and lastArray[].
        
    double              uBinwidth;      //08 Binwidth in microseconds
    
    
    char                reserved1[16];  //16 Reserved for future use

    // Following the STAAVERAGE header are two wavelets: sumArray[] and lastArray[].
    // C doesn't allow us to define variable length arrays so we leave
    // them as comments here.
    //
    //  STACUBE_DATATYPE sumArray[STACUBE->nPeriod]   // sum of wavelets
    //  STACUBE_DATATYPE lastArray[STACUBE->nPeriod]  // last wavelet added to sumArray
    
    } STAAVERAGE;                       // sizeof(STAAVERAGE)=29





//--------------------------------------------------------
// STACUBE defines the format for the STA cube.
// STACUBEs consist of an STACUBE (header) structure followed by
// a 3-D matrix of STAAVERAGE structures.
//
// We use the Hyperstream data type TG_HSOT_STACUBE to identify
// STACUBEs when they are transmitted over Hyperstream connections.

typedef struct
    {
    TG_HSOBJECTTYPE     hsObjectType;   //16 Hyperstream Object Type (=TG_HSOT_STACUBE)
    
    long    nRun;                       //04 STAWKR Run number for this cube
    long    nEpoch;                     //04 Database Epoch number for this cube
    

    //-----------------------------------
    // These values are computed from the parameters
    
    long    nStaAverages;               //04 Total # of STAAVERAGEs allocated
                                        // (first one follows this header)
                                        // ==nRegions * nTriggerChannels * nAverageChannels
    
    long    nSizeOfSTAAVERAGE;          //04 # of bytes per STAAVERAGE
                                        // ==sizeof(STACUBE)
                                        //   + 2 * (sizeof(STACUBE_DATATYPE) * STACUBE->nPeriod)

    long    offsetSumArray;             //04 # of bytes from 1st byte in STAAVERAGE to sumArray[]
                                        // ==sizeof(STAAVERAGE)
                            
    long    offsetLastArray;            //04 # of bytes from 1st byte of STAAVERAGE to lastArray[]
                                        // ==offsetSumArray + sizeof(STACUBE_DATATYPE) * STACUBE->nPeriod
                            
    char    reserved1[32];              //32 Reserved for future use
    

    //-----------------------------------
    // The user defines these parameters

    long    nRegions;                   //04 Number of Regions within an epoch
                                        // Defined by triage's Regions[] table
    
    long    nTriggerChannels;           //04 Number of Trigger channels
                                        // Defined by EXTRACT's Trigger Extraction table
                            
    long    nAverageChannels;           //04 Number of Average channels
                                        // Defined by EXTRACT's Average Extraction table

    long    nPeriod;                    //04 Number of samples per wavelet in STAAVERAGE.sumArray[]
                                        // STAAVERAGE.lastArray[]
                            
    long    nOffset;                    //04 Offset to trigger line (time=0=time of trigger event)
                                        // for each STAAVERAGE.sumArray[] and STAAVERAGE.lastArray[]

    char    reserved2[32];              //32 Reserved for future use
    
    
    //-----------------------------------
    
    long    nBytes;                     //04 Total number of bytes allocated for this STACUBE
                                        // STACUBE + all additional data structures below.

    //------------
    // Following the STACUBE header in memory is a 3-d matrix of
    // STAAVERAGEs (STACUBE.nStaAverages of them).
    //
    // Unfortunately, C doesn't allow us to express this data structure
    // but here's what it might look like if it did allow this.
    //
    //      STAAVERAGE staAverages[STACUBE.nRegions][STACUBE.nSpikeChannels][STACUBE.nAnalogChannels];
    //
    // The correct way to get to the STAAVERAGE matrix given a STACUBE *pcube, is to use code like this:
    //
    //      STAAVERAGE *a = (STAAVERAGE *) ((char *) pcube + pcube->nOffsetAverage);
    //
    // or more simply,
    //
    //      a = stacubeGetAverage(pcube, 0, 0, 0);      // 'a' points to first element of 3-d matrix
    
    long    nOffsetMatrix;              //04 # of bytes from beginning of STACUBE to first STAAVERAGE in 3-d matrix
    long    nMatrixBytes;               //04 # of bytes containing all STAAVERAGEs
    

    //------------
    // Following the STAAVERAGEs are three CHANINFO tables, one for each type of input channel.
    // Information in these tables comes from the input SSEPOCHs's CHANINFO table.
    //
    // The correct way to get to the first CHANINFO element given STACUBE *pcube is to use code like this:
    //
    //      CHANINFO *ciRegion  = (CHANINFO *) ((char *) pcube + pcube->offsetRegionChaninfo);
    //      CHANINFO *ciTrigger = (CHANINFO *) ((char *) pcube + pcube->offsetTriggerChaninfo);
    //      CHANINFO *ciAverage = (CHANINFO *) ((char *) pcube + pcube->offsetAverageChaninfo);
    //
    // Alternatively, you can use the functions defined in this file which use the above method:
    //
    //  CHANINFO *stacubeGetRegionChaninfo(const STACUBE *pCube, long iChannel);
    //  CHANINFO *stacubeGetTriggerChaninfo(const STACUBE *pCube, long iChannel);
    //  CHANINFO *stacubeGetAverageChaninfo(const STACUBE *pCube, long iChannel);
    
    long    nOffsetRegionChaninfo;      //04 # of bytes from beginning of STACUBE to first region CHANINFO
    long    nRegionChaninfoBytes;       //04 # of bytes for Region CHANINFO table (=nRegions * sizeof(CHANINFO))
    
    long    nOffsetTriggerChaninfo;     //04 # of bytes from beginning of STACUBE to first region CHANINFO
    long    nTriggerChaninfoBytes;      //04 # of bytes for Region CHANINFO table (=nTriggerChannels * sizeof(CHANINFO))

    long    nOffsetAverageChaninfo;     //04 # of bytes from beginning of STACUBE to first region CHANINFO
    long    nAverageChaninfoBytes;      //04 # of bytes for Region CHANINFO table  (=nAverageChannels * sizeof(CHANINFO))
    
    char    reserved3[48];              //48 Reserved space
    
    } STACUBE;                          // sizeof(STACUBE)=224
    
    

//--------------------------------------------------------
// Convenient macros
            
// iSTAAVERAGE - Index in pSTACUBE->staAverages[] of a particular STAAVERAGE                    x
//                                                                                              x
//#define iSTAAVERAGE(pSTACUBE, r, s, a)                                     \                  x
//            (a + pSTACUBE->nAverageChannels * (s + pSTACUBE->nTriggerChannels * r))           x
//                                                                                              x
//                                                                                              x
//// pSTAAVERAGE - returns pointer to an STAAVERAGE given its 3-d coordinates                   x
//                                                                                              x
//#define pSTAAVERAGE(pSTACUBE, iRegion, iTriggerChan, iAverageChan)   /*lint --e(826) */    \  x
//            (STAAVERAGE *) ((char *) pSTACUBE                       \                         x
//                    + sizeof(STACUBE)                               \                         x
//                    + iSTAAVERAGE(pSTACUBE iRegion, iTriggerChan, iAverageChan) \             x
//                        * pSTACUBE->nSizeOfSTAAVERAGE)                                        x
//                                                                                              x
//                                                                                              x
//                                                                                              x
//// pSUMARRAY - returns pointer to an STAAVERAGE sumArray[] wavelet.                           x
//                                                                                              x
//#define pSUMARRAY(pSTACUBE, pSTAAVERAGE)  /*lint --e(826) */        \                         x
//    (STACUBE_DATATYPE *) ((char *) pSTACUBE + pSTACUBE->offsetSumArray)                       x
//                                                                                              x
//// pLASTARRAY - returns pointer to STAAVERAGE's lastArray[] wavelet                           x
//                                                                                              x
//#define pLASTARRAY(pSTACUBE, pSTAAVERAGE) /*lint --e(826) */        \                         x
//    (STACUBE_DATATYPE *) ((char *) pSTACUBE + pSTACUBE->offsetLastArray)                      x
//                                                                                              x



//--------------------------------------------------------
// Return status codes from stacube functions

#define STACUBEERR_OK            0      // Successful
#define STACUBEERR_CUBEPTR      -1      // Invalid STACUBE pointer
#define STACUBEERR_REGION       -2      // Invalid region
#define STACUBEERR_TRIGGER      -3      // Invalid trigger channel
#define STACUBEERR_AVERAGE      -4      // Invalid average channel
#define STACUBEERR_PERIOD       -5      // Invalid period
#define STACUBEERR_DIMENSION    -6      // Invalid dimensionality
#define STACUBEERR_AVERAGEPTR   -7      // Invalid STAAVERAGE pointer

#define STACUBEERR_LASTONE      STACUBEERR_AVERAGEPTR



//--------------------------------------------------------
// Function prototypes


TEMPODLLAPI long stacubeSizeof(long nRegions, long nTriggerChans, long nAverageChans, long nPeriod);

TEMPODLLAPI long stacubeInitialize(STACUBE *pCube, long nRegions, long nTriggerChans, long nAverageChans, long nPeriod, long nOffset);

TEMPODLLAPI long stacubeZeroAllAverages(STACUBE *pCube);
TEMPODLLAPI long stacubeZeroOneAverage(STACUBE *pCube, long iRegion, long iTriggerChan, long iAverageChan);

TEMPODLLAPI long stacubeAdd(const STACUBE *pSrcCube, STACUBE *pDstCube);


// stacubeGetXChaninfo() Returns pointer to one of the CHANINFO blocks inside STACUBE

TEMPODLLAPI CHANINFO *stacubeGetRegionChaninfo(const STACUBE *pCube, long iChannel);
TEMPODLLAPI CHANINFO *stacubeGetTriggerChaninfo(const STACUBE *pCube, long iChannel);
TEMPODLLAPI CHANINFO *stacubeGetAverageChaninfo(const STACUBE *pCube, long iChannel);


// stacubeGetAverage() Returns pointer to one of the STAAVERAGEs in an STACUBE.

TEMPODLLAPI STAAVERAGE *stacubeGetAverage(const STACUBE *pCube, long iRegion, long iTriggerChan, long iAverageChan);


TEMPODLLAPI STACUBE_DATATYPE *stacubeGetSumArray(const STACUBE *pCube, const STAAVERAGE *pAverage);
TEMPODLLAPI STACUBE_DATATYPE *stacubeGetLastArray(const STACUBE *pCube, const STAAVERAGE *pAverage);


TEMPODLLAPI char *stacubeErr(long stacubeerr);


#endif  // ifndef STACUBE_H

#include    "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above
