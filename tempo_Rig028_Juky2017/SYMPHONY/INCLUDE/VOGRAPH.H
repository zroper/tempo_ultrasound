/*  .title  VOGRAPH.H   Definitions for VOGRAPHs
;+
; EDIT HISTORY
;   17Mar09 sh  vographSetDataExtents, vographSetScaleExtents, vographGetScaleExtents: fix bug
;               In definition, changed fVOGRAPH. to (poGraph)->group.obj.f.
;-
*/

#ifndef VOGRAPH_H
#define VOGRAPH_H

#ifndef VOGROUP_H
    #include    "vogroup.h"
    #include    "vogrid.h"
#endif

//lint -e537
#include    "tempodll.h"



#define VOOBJECT_GRAPH      "Graph"

typedef struct _VOGRAPH
    {
    VOGROUP         group;              // Must be first element
    
    // Public members
    
    // Private members
    
    VOFUNC          base;               // Copy of base class callbacks
    
    struct _VOGRID  *objGrid;           // Grid (in group)
    struct _VOPLOT  *objPlot;           // Data plot object (in group)
    struct _VOSCALE *objLScale;         // Left scale object (in group)
    struct _VOSCALE *objRScale;         // Right scale object (in group)
    struct _VOSCALE *objTScale;         // Top scale object (in group)
    struct _VOSCALE *objBScale;         // Bottom scale object (in group)

    char            fLScale;            // =1 to display left scale
    char            fRScale;            // =1 to display right scale
    char            fTScale;            // =1 to display top scale
    char            fBScale;            // =1 to display bottom scale

    RECT            rectPlot;           // PLOT and GRID positions are the same
    RECT            rectLScale;         // Left scale position
    RECT            rectRScale;         // Right scale position
    RECT            rectTScale;         // Top scale position
    RECT            rectBScale;         // Bottom scale position
    
    char            autoscale;          // 1=automatically adjust scales, 0=manual
    char            unused[3];
    VOPROP_EXTENTS_T  scaleExtents;     // Scale extents
    RECT            rectMargins;        // Margins (used for VOSCALE sizes)
    
    HFONT           hfontHorizontalLabel;  // font used for horizontal labels
    LOGFONT         logfontHorizontalLabel;//
    
    HFONT           hfontVerticalLabel;    // font used for vertical labels
    LOGFONT         logfontVerticalLabel;  //
    
    HFONT           hfontScaleNumbers;    // font used for scale numbers
    LOGFONT         logfontScaleNumbers;  // 
    
    } VOGRAPH;
    
// The following values are used by vographSetData()

#ifdef VOPLOT_H
    #define VOGRAPH_DT_UCHAR    VOPLOT_DT_UCHAR      
    #define VOGRAPH_DT_CHAR     VOPLOT_DT_CHAR     
    #define VOGRAPH_DT_USHORT   VOPLOT_DT_USHORT   
    #define VOGRAPH_DT_SHORT    VOPLOT_DT_SHORT    
    #define VOGRAPH_DT_ULONG    VOPLOT_DT_ULONG    
    #define VOGRAPH_DT_LONG     VOPLOT_DT_LONG     
    #define VOGRAPH_DT_FLOAT    VOPLOT_DT_FLOAT    
    #define VOGRAPH_DT_DOUBLE   VOPLOT_DT_DOUBLE   
#endif

// The following values are used by fEnable flag vographEnableScales();
// They are bit-wise ORed to enable (or hide) each of the four scales.

#define VOGRAPH_ES_LEFT     0x1         // Scale to left of plot
#define VOGRAPH_ES_RIGHT    0x2         // Scale to right of plot
#define VOGRAPH_ES_TOP      0x4         // Scale to top of plot
#define VOGRAPH_ES_BOTTOM   0x8         // Scale to bottom of plot
#define VOGRAPH_ES_GRID     0x10        // Scale to bottom of plot


//-----------------------------------------------------------------
// Used by .fSetProp() and .fGetProp()

#define VOGRAPH_PROP_POSITION     1     // Position of a graph object


//-----------------------------------------------------------------
// Helpful macros

// Macro vographSetData(VOGRAPH *poGraph, double *pdata, long nData);
// Call fSetProp inside the PLOT object

//#define vographSetData(poGraph, pdata, nData)                                           \ .
//        (poGraph)->objPlot->obj.f.fSetProp((VOOBJ*)(poGraph)->objPlot, VOPLOT_PROP_DATA,\ .
//                                        pdata, (void*) (nData), NULL, NULL)


// Macro vographGetData(VOGRAPH *poGraph, double **ppdata, long *pnData);
// Call fGetProp inside the PLOT object

//#define vographGetData(vop, ppdata, pnData)                                             \ .
//        (poGraph)->objPlot->obj.f.fGetProp((VOOBJ*)(poGraph)->objPlot, VOPLOT_PROP_DATA,\ .
//                                        ppdata, pnData, NULL, NULL)


// Macro vographGetPosition(VOGRAPH *poGraph, VOOBJ *poObj, RECT *rectPosition)
// Call fGetProp inside the GRAPH object

//#define vographGetPosition(poGraph, poObj, rectPosition)                    \             .
//        (void)                                                              \             .
//        (poGraph)->group.obj.f.fGetProp((VOOBJ*)(poGraph), VOGRAPH_PROP_POSITION, \       .
//                                   poObj, rectPosition, NULL, NULL)         \             .

//---------------
// 13Jan08 WARNING: When using macros like vooGetProp/vooSetProp, the fGetProp/fSetProp function
//      that ACTUALLY gets called is the one in the object's VOOBJ.f structure!  For instance,
//      when vogroupSetProp(VOGRAPH *po,..) was # defined as vooSetProp(..),
//      vogroupSetProp(VOGRAPH *po, ..) wasn't calling VOGROUP's fSetProp function because
//      VOGRAPH hooked it!  Instead, vogroupSetProp was calling VOGRAPH's fSetProp!
//      If you WANT this effect, then use a macro-defined function like these (where the
//      function that gets called is determined by the particular po->f. function.  Otherwise,
//      use the particular fVOXXX. function (ie fVOGROUP.fSetProp).

//---------------
// long vographSetDataExtents(VOGRAPH *poGraph, VOPROP_EXTENTS_T *ext)

#define vographSetDataExtents(poGraph, ext) /*lint --e(522)*/       \
       (((poGraph) && (poGraph)->group.obj.f.fSetProp) ?            \
          (poGraph)->group.obj.f.fSetProp(&((VOGRAPH *) (poGraph))->group.obj,  \
                VOPROP_DATAEXTENTS, (VOPROP_EXTENTS_T *)(ext),      \
                NULL, NULL, NULL)                                   \
          : 0)

//---------------
// long vographSetScaleExtents(VOGRAPH *poGraph, VOPROP_EXTENTS_T *ext)
//
// 19Mar09 Before calling this function, you MUST set the
// ext->flag |= VOPROPFLAG_MANUAL or the scales will not be set.
// You MUST also set one or both of VOPROPFLAG_HSET and/or VOPROPFLAG_VSET
// along with the appropriate ext->?min and ext->?max.

#define vographSetScaleExtents(poGraph, ext) /*lint --e(522)*/      \
       (((poGraph) && (poGraph)->group.obj.f.fSetProp) ?                        \
          (poGraph)->group.obj.f.fSetProp(&((VOGRAPH *) (poGraph))->group.obj,  \
                VOPROP_SCALEEXTENTS, (VOPROP_EXTENTS_T *)(ext),     \
                NULL, NULL, NULL)                                   \
          : -200)


//---------------
// long vographGetScaleExtents(VOGRAPH *poGraph, VOPROP_EXTENTS_T *ext)

#define vographGetScaleExtents(poGraph, ext) /*lint --e(522)*/      \
       (((poGraph) && (poGraph)->group.obj.f.fGetProp) ?                        \
          (poGraph)->group.obj.f.fGetProp(&((VOGRAPH *) (poGraph))->group.obj,  \
                VOPROP_SCALEEXTENTS, (VOPROP_EXTENTS_T *)(ext),     \
                NULL, NULL, NULL)                                   \
          : 0)


//-----------------------------------------------------------------
// Global functions

extern VOFUNC  fVOGRAPH;
TEMPODLLAPI long vographRegister(VO *Vo);
TEMPODLLAPI long vographUnregister(VO *Vo);

TEMPODLLAPI void vographSetDataMany(VOGRAPH *poGraph, long iSet, long dataType, void **pdata, long nDataArrays, long nDataSamples);
TEMPODLLAPI void vographSetHorizontalDataRange(VOGRAPH *poGraph, double *left, double *right);
TEMPODLLAPI void vographGetPosition(VOGRAPH *poGraph, VOOBJ *poObj, RECT *rectPosition);
TEMPODLLAPI long vographEnableAutoscale(VOGRAPH *poGraph, long flag);
TEMPODLLAPI unsigned long vographEnableScales(VOGRAPH *poGraph, unsigned long fEnable);

TEMPODLLAPI void vographSetMargins(VOGRAPH *vop, RECT *rectMargins);
TEMPODLLAPI RECT vographGetMargins(VOGRAPH *vop);


TEMPODLLAPI void vographSetLabelFont(VOGRAPH *vop, char *faceName, double points, long fBold, long fItalic);
TEMPODLLAPI void vographSetScaleFont(VOGRAPH *vop, char *faceName, double points, long fBold, long fItalic);
TEMPODLLAPI HFONT vographGetHorizontalLabelHFONT(VOGRAPH *vop);
TEMPODLLAPI HFONT vographGetVerticalLabelHFONT(VOGRAPH *vop);
TEMPODLLAPI HFONT vographGetScaleHFONT(VOGRAPH *vop);

TEMPODLLAPI void vographSetGridType(VOGRAPH *poGraph, long vogridType);  // See VOGRID.H for VOGRID_TYPE_xxx

//lint -esym(534, vographEnableScales)
//lint -esym(534, vographEnableAutoscale)

#include    "tempodlx.h"


#endif // ifndef VOGRAPH_H

