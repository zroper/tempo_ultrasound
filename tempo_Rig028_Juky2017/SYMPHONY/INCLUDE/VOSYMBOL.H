#ifndef VOSYMBOL_H
#define VOSYMBOL_H

//lint -e537
#include    "tempodll.h"



#define VOOBJECT_SYMBOL            "symbol"


typedef struct _VOSYMBOL
    {
    VOOBJ           obj;                // Must be first element
    
    // Public members
    
    // Private members
    
    VOFUNC          base;               // Copy of base class callbacks
    
    long            symbolType;         // Type of symbol
#define VOSYMBOL_ST_RECTANGLE     0     //  Rectangle
#define VOSYMBOL_ST_ELLIPSE       1     //  Ellipse

#define VOSYMBOL_ST_LAST    VOSYMBOL_ST_ELLIPSE

    LOGPEN          logPen;             // Pen details
    LOGBRUSH        logBrush;           // Brush details
    
    SO              *so;                // Event notification
    
    VOPROP_EXTENTS_T dataExtents;       // Our world coordinates (hmin==hmax, vmin==vmax)
                                        // we only need wx,wy so we only use hmin,vmin
    
    struct _VOGRAPH *parent;            // Parent object (we assume its a graph)
    struct _VOPLOT  *poRect;            // Pointer to object for current rectangle (ie VOPLOT)
    struct _VOGRAPH *poGraph;           // Pointer to object for scale values (ie VOGRAPH)
    } VOSYMBOL;


//-----------------------------------------------------------------
// Used by .fSetProp() and .fGetProp()

//#define VOSYMBOL_PROP_DATA         1      // 

#define VOSYMBOL_PROP_WORLDPOSITION     1   // Get/Set world coordinates


//-----------------------------------------------------------------
// Helpful macros

// Macro VoscaleSetData(VOPLOT *vop, double *pdata, long nData);
//#define VoscaleSetData(vop, pdata, nData)        \.
//        vop->obj.fSetProp((VOOBJ*)vop, VOSCALE_PROP_DATA, pdata, (void*) (nData), NULL, NULL);
//
//// Macro VoscaleGetData(VOPLOT *vop, double **ppdata, long *pnData);
//#define VoscaleGetData(vop, ppdata, pnData)       \.
//        vop->obj.fGetProp((VOOBJ*)vop, VOSCALE_PROP_DATA, ppdata, pnData, NULL, NULL);



//-----------------------
// void vosymbolGetWorldPosition(VOSYMBOL *poSymbol, double *pwx, double *pwy);

#define vosymbolGetWorldPosition(poSymbol, pwx, pwy)        \
    vooGetProp(&(poSymbol)->obj, VOSYMBOL_PROP_WORLDPOSITION, (double *)(pwx), (double *)(pwy), NULL, NULL)


//-----------------------
// void vosymbolSetWorldPosition(VOSYMBOL *poSymbol, double *pwx, double *pwy);

#define vosymbolSetWorldPosition(poSymbol, pwx, pwy)        \
    vooSetProp(&(poSymbol)->obj, VOSYMBOL_PROP_WORLDPOSITION, (double *)(pwx), (double *)(pwy), NULL, NULL)
    
    
//-----------------------
// void vosymbolGetDataExtents(VOSYMBOL *poSymbol, VOPLOT_EXTENTS_T *ext)
#define vosymbolGetDataExtents(poSymbol, ext)               \
    vooGetProp(&(poSymbol)->obj, VOPROP_DATAEXTENTS, (VOPLOT_EXTENTS_T *)(ext), NULL, NULL, NULL)


//-----------------------
// void vosymbolSetDataExtents(VOSYMBOL *poSymbol, VOPLOT_EXTENTS_T *ext)
#define vosymbolSetDataExtents(poSymbol, ext)               \
    vooSetProp(&(poSymbol)->obj, VOPROP_DATAEXTENTS, (VOPLOT_EXTENTS_T *)(ext), NULL, NULL, NULL)


//-----------------------------------------------------------------
// EVENT Notification

#define VOSYMBOL_SOEVENT_MOVE       1       // Position changed
#define VOSYMBOL_SOEVENT_DROP       2       // Drop symbol 
#define VOSYMBOL_SOEVENT_DRAG       3       // Drag symbol    
#define VOSYMBOL_SOEVENT_RESIZE     4       // Resize symbol    

typedef struct                              // VOSYMBOL_SOEVENT_DRAG
    {
    VOSYMBOL    *po;                        // Symbol
    RECT        *oldPosition;               // Old position
    RECT        *newPosition;               // New position
    } VOSYMBOL_SOEVENT_MOVE_TYPE;

typedef struct                              // VOSYMBOL_SOEVENT_DROP
    {
    VOSYMBOL    *po;                        // Symbol
    RECT        *oldPosition;               // Old position
    RECT        *newPosition;               // New position
    } VOSYMBOL_SOEVENT_DROP_TYPE;

typedef struct                              // VOSYMBOL_SOEVENT_DRAG
    {
    VOSYMBOL    *po;                        // Symbol
    long        *pdx, *pdy;                 // Pointers to delta for new position
    RECT        position;                   // Current position
    } VOSYMBOL_SOEVENT_DRAG_TYPE;
    
typedef struct                              // VOSYMBOL_SOEVENT_RESIZE
    {
    VOSYMBOL    *po;                        // Symbol
    long        *pdx, *pdy;                 // Pointers to delta for new position
    RECT        position;                   // Current position
    } VOSYMBOL_SOEVENT_RESIZE_TYPE;
    


//-----------------------------------------------------------------
// Global functions

TEMPODLLAPI long vosymbolRegister(VO *Vo);
TEMPODLLAPI long vosymbolUnregister(VO *Vo);

TEMPODLLAPI void vosymbolSetConnections(VOSYMBOL *vop, struct _VOGRAPH *poGraph, struct _VOPLOT *poPlot);

TEMPODLLAPI long vosymbolSetSymbolType(VOSYMBOL *vop, long symbolType);
TEMPODLLAPI LOGPEN vosymbolSetLogPen(VOSYMBOL *vop, LOGPEN *logPen);
TEMPODLLAPI LOGBRUSH vosymbolSetLogBrush(VOSYMBOL *vop, LOGBRUSH *logBrush);

TEMPODLLAPI VOSYMBOL *vosymbolConstructEx(
                    VO          *Vo,
                    RECT        *position,
                    long        symbolType);
                        


#include    "tempodlx.h"


#endif // ifndef VOSYMBOL_H
