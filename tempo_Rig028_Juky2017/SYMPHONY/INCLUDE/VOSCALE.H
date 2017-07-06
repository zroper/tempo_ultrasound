#ifndef VOSCALE_H
#define VOSCALE_H

//lint -e537
#include    "tempodll.h"



#define VOOBJECT_SCALE          "Scale"

#define VOSCALE_NTEXT       40          // Max # of chars in scale text

typedef struct _VOSCALE
    {
    VOOBJ           obj;                // Must be first element
    
    // Public members
    
    // Private members
    
    VOFUNC          base;               // Copy of base class callbacks

    char            type;               // 0 (not known) or VOSCALE_TYPE_xxx
#define VOSCALE_TYPE_LEFT       1       //  This scale is on the LEFT of plot
#define VOSCALE_TYPE_RIGHT      2       //  This scale is on the RIGHT of plot
#define VOSCALE_TYPE_TOP        3       //  This scale is on TOP of plot
#define VOSCALE_TYPE_BOTTOM     4       //  This scale is on BOTTOM of plot

    char            unused[3];
    struct _VOPLOT  *poPlot;            // Pointer to our PLOT object (for rectangle)
    struct _VOGRAPH *poGraph;           // Pointer to our GRAPH object (for scale values)
    
    char            textTop[VOSCALE_NTEXT];     // top/right text
    char            textMiddle[VOSCALE_NTEXT];  // vcenter or center text
    char            textBottom[VOSCALE_NTEXT];  // bottom/left text

    unsigned long   features;           // Features in a scale
#define VOSCALE_FEATURE_LINE       0x1  //  Draw line
#define VOSCALE_FEATURE_TEXT       0x2  //  Draw text
#define VOSCALE_FEATURE_NUMBER     0x4  //  Draw numbers
#define VOSCALE_FEATURE_HASH       0x8  //  Draw hash marks

#define VOSCALE_FEATURE_ALL        (~0) //  Enable all features

    
    } VOSCALE;


//-----------------------------------------------------------------
// Used by .fSetProp() and .fGetProp()

#define VOSCALE_PROP_CONNECTIONS           1   // Connections to GRAPH and PLOT
#define VOSCALE_PROP_TYPE                  2   // Type of scale (left, right, top, bottom)
#define VOSCALE_PROP_FEATURES              3   // Get/Set scale features (VOSCALE_FEATURE_xxx)




//-----------------------------------------------------------------
// Helpful macro crackers for Get/Set props


// Macro voscaleSetConnections(VOSCALE *vop, VOGRAPH *poGraph, VOPLOT *poPlot)

//#define voscaleSetConnections(poScale, poGraph, poPlot)                         \   .
//        (void)                                                                  \   .
//        (poScale)->obj.f.fSetProp((VOOBJ*)(poScale), VOSCALE_PROP_CONNECTIONS,  \   .
//                                  (poGraph), (poPlot), NULL, NULL)


// Macro voscaleSetType(VOSCALE *vop, long voscale_type)

//#define voscaleSetType(poScale, voscale_type)                                   \   .
//        (void)                                                                  \   .
//        (poScale)->obj.f.fSetProp((VOOBJ*)(poScale), VOSCALE_PROP_TYPE,         \   .
//                                  (void *) (voscale_type), NULL, NULL, NULL)



/*
#define voscaleGetDrag(vop, pnDrag)     \
        (vop)->obj.f.fGetProp((VOOBJ*)(vop), VOSCALE_PROP_DRAG, (void *) (pnDrag), NULL, NULL, NULL);
*/


//---------------
// long voscaleGetFeatures(VOSCALE *poScale)

#define voscaleGetFeatures(poScale)      /*lint --e(522)*/          \
       (((poScale) && fVOSCALE.fGetProp) ?                          \
          fVOSCALE.fGetProp(&((VOSCALE *) (poScale))->obj,          \
                VOSCALE_PROP_FEATURES, NULL, NULL, NULL, NULL)      \
          : 0)


//---------------
// long voscaleSetFeatures(VOSCALE *poScale, long features)

#define voscaleSetFeatures(poScale, features) /*lint --e(522)*/     \
       (((poScale) && fVOSCALE.fSetProp) ?                          \
          fVOSCALE.fSetProp(&((VOSCALE *) (poScale))->obj,          \
                VOSCALE_PROP_FEATURES, (void *) (features),         \
                NULL, NULL, NULL)                                   \
          : 0)



//-----------------------------------------------------------------
// Global functions

TEMPODLLAPI extern const VOFUNC fVOSCALE;
TEMPODLLAPI long voscaleRegister(VO *Vo);
TEMPODLLAPI long voscaleUnregister(VO *Vo);

TEMPODLLAPI void voscaleSetConnections(VOSCALE *vop, struct _VOGRAPH *poGraph, struct _VOPLOT *poPlot);
TEMPODLLAPI void voscaleSetType(VOSCALE *vop, long voscale_type);

TEMPODLLAPI void voscaleSetTopText(VOSCALE *vop, char *fmt, ...);       //lint -printf(2, voscaleSetTopText)
TEMPODLLAPI void voscaleSetMiddleText(VOSCALE *vop, char *fmt, ...);    //lint -printf(2, voscaleSetMiddleText)
TEMPODLLAPI void voscaleSetBottomText(VOSCALE *vop, char *fmt, ...);    //lint -printf(2, voscaleSetBottomText)

#include    "tempodlx.h"


#endif // ifndef VOSCALE_H

