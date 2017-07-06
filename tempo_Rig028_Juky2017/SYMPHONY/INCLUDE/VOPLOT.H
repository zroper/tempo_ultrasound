#ifndef VOPLOT_H
#define VOPLOT_H

//lint -e537
#include    "tempodll.h"


#define VOOBJECT_PLOT            "Plot"


#define VOPLOT_NSETS      4             // Max # of sets of lines

//-----------------------------------------------------------
// VOPLOT supports drawing multiple sets of lines.
// This is what is kept on a per set basis.

typedef struct
    {
    long            nDataSamples;       // # data samples per array
    long            nDataArrays;        // # arrays
    long            dataType;           // Type of data (must be VOPLOT_DT_x)
#define VOPLOT_DT_UCHAR     1           
#define VOPLOT_DT_CHAR      2
#define VOPLOT_DT_USHORT    3
#define VOPLOT_DT_SHORT     4
#define VOPLOT_DT_ULONG     5
#define VOPLOT_DT_LONG      6
#define VOPLOT_DT_FLOAT     7
#define VOPLOT_DT_DOUBLE    8

    // PolyPolyLine needs two arrays: one POINT array and one array that
    // contains the number of samples in each line (in the POINT array).
    // This data array contains a copy of the sample data for all the lines for this set.
    
    long            nBytesPerSample;    // Number of bytes per sample
    long            nBytesPerArray;     // Number of bytes per array (= nBytesPerSample * nDataSamples)
    long            nBytesPerSet;       // Number of bytes per set (= nBytesPerArray * nDataArrays)
    
    void            *data;              // malloc'd pointer to wavelet matrix: data[nDataArrays][nDataSamples]
                                        // The data type is defined by dataType
    long            nData;              // # of bytes allocated (>= nDataArrays*nDataSamples*sampleSize)
    
    void            *index[1];          // When only one array is specified (voplotSetDataOne)
                                        // This table holds a pointer to the data array
    
    LOGPEN          logpenData;         // Pen used to draw data
    
    // Computed values
    
    double          dataMax;            // max/min of all lines in this set.
    double          dataMin;
    } VOPLOTSET;


//-----------------------------------------------------------

typedef struct _VOPLOT
    {
    VOOBJ           obj;                // Must be first element
    
    // Public members
    
    // Private members
    
    VOFUNC          base;               // Copy of base class callbacks
    
    struct _VOGRAPH *objGraph;          // NULL or pointer to the graph that controls this object
    
    VOPLOTSET       set[VOPLOT_NSETS];  // Multiple sets of lines
    
    
    VOPROP_EXTENTS_T    dataExtents;    // Data extents
    
    // These are temporary arrays required by plotLine to draw lines.
    // They will grow to accomodate any of the line sets.
    
    POINT           *points;            // malloc'd array of POINTs for polypoly line
    long            nPoints;            // # of bytes in points (==nDataSamples * nDataArrays)
    DWORD           *lineSizes;         // Array of # of points in each line (all values == nDataSamples)
    long            nLineSizes;         // # of bytes in lineSizes[]
    
    SO              *so;                // Our SO event queue
    } VOPLOT;


//-----------------------------------------------------------------
// Used by .fSetProp() and .fGetProp()

// fGetProp supports VOPROP_POSITION, VOPROP_GETSO, VOPROP_GETXEXTENT and VOPROP_GETYEXTENT

//#define VOPLOT_PROP_DATA         1      // p1=(double *), p2=nData
//#define VOPLOT_PROP_VSCALE       2      // vert scale p1=top, p2=bot, p3=max, p4=min
//#define VOPLOT_PROP_HSCALE       3      // horiz scale p1=right, p2=left, p3=rightLimit, p4=leftLimit
//#define VOPLOT_PROP_AUTOSCALE    4      // Autoscale flag


//-----------------------------------------------------------------
// SO Events emitted by VOPLOT
    
#define VOPLOT_SOEVENT_POSITION     1       // Position changed
#define VOPLOT_SOEVENT_XEXTENT      2       // X extent changed
#define VOPLOT_SOEVENT_YEXTENT      3       // Y extent changed

typedef struct                              // VOPLOT_SOEVENT_POSITION
    {
    VOPLOT      *po;
    long        vospType;                   // VOSPTYPE_xxx (VOSPTYPE_MOVE, VOSPTYPE_DROP)
    RECT        *oldPosition;               // Old position
    RECT        *newPosition;               // New position
    } VOPLOT_SOEVENT_POSITION_STRUCT;

typedef struct                              // VOPLOT_SOEVENT_XEXTENT
    {
    VOPLOT     *po;
    double      oldLow, oldHigh;
    double      newLow, newHigh;
    } VOPLOT_SOEVENT_XEXTENT_STRUCT;
    

typedef struct                              // VOPLOT_SOEVENT_YEXTENT
    {
    VOPLOT     *po;
    double      oldLow, oldHigh;
    double      newLow, newHigh;
    } VOPLOT_SOEVENT_YEXTENT_STRUCT;
    


//-----------------------------------------------------------------
// Helpful macros

/*
// Macro VoplotSetData(VOPLOT *vop, double *pdata, long nData);
#define VoplotSetData(vop, pdata, nData)        \ .
        vop->obj.f.fSetProp((VOOBJ*)vop, VOPLOT_PROP_DATA, pdata, (void*) (nData), NULL, NULL);
*/

/*
// Macro VoplotGetData(VOPLOT *vop, double **ppdata, long *pnData);
#define VoplotGetData(vop, ppdata, pnData)       \ .
        vop->obj.f.fGetProp((VOOBJ*)vop, VOPLOT_PROP_DATA, ppdata, pnData, NULL, NULL);
*/



//-----------------------------------------------------------------
// Global functions

TEMPODLLAPI long voplotRegister(VO *Vo);
TEMPODLLAPI long voplotUnregister(VO *Vo);

TEMPODLLAPI void voplotSetGraph(VOPLOT *voPlot, struct _VOGRAPH *voGraph);
TEMPODLLAPI void voplotSetDataMany(VOPLOT *vop, long iSet, long dataType, void *pArrays[], long nArrays, long nSamples);

TEMPODLLAPI void voplotSetHorizontalDataRange(VOPLOT *vop, double *left, double *right);
TEMPODLLAPI void voplotGetHorizontalDataRange(VOPLOT *vop, double *left, double *right);

TEMPODLLAPI long voplotWorld2ClientX(VOPLOT *vop, double worldX);
TEMPODLLAPI long voplotWorld2ClientY(VOPLOT *vop, double worldY);
TEMPODLLAPI double voplotClient2WorldX(VOPLOT *vop, long clientX);
TEMPODLLAPI double voplotClient2WorldY(VOPLOT *vop, long clientY);


#include    "tempodlx.h"


#endif // ifndef VOPLOT_H
