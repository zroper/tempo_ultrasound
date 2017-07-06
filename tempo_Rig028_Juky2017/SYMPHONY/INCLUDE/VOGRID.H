#ifndef VOGRID_H
#define VOGRID_H

//lint -e537
#include    "tempodll.h"


#define VOOBJECT_GRID            "GRID"

//-----------------------------------------------------------

typedef struct
    {
    double  x, y;
    } VOGRID_DPOINT;
    
typedef struct
    {
    VOGRID_DPOINT   *dpoints;           // Points in world coordinates
    long            nPoints;            // Number of VOGRID_DPOINTs used in dpoints[]
    long            nPointsBytes;       // Number of bytes allocated to VOGRID_DPOINTs in polygon

    LOGPEN          logpen;             // Logical pen for perimeter of polygon
    LOGBRUSH        logbrush;           // Logical brush for interior of polygon
        
    } VOGRID_POLYGON;



//-----------------------------------------------------------

#define VOGRID_NPOLYGONS        8       // Max number of polygons

typedef struct _VOGRID
    {
    VOOBJ           obj;                // Must be first element
    
    // Public members
    
    // Private members
    
    VOFUNC          base;               // Copy of base class callbacks
    
    struct _VOGRAPH *poGraph;           // NULL or pointer to the VOGRAPH that controls this object
    
    VOPROP_EXTENTS_T    scaleExtents;   // Current Scale Extents (used to display grid)
    
    long            gridType;           // Type of grid to display
#define     VOGRID_TYPE_NONE    0       //  No grid
#define     VOGRID_TYPE_HZERO   1       //  Horizontal line at scale == 0.0
#define     VOGRID_TYPE_VZERO   2       //  Vertical line at scale == 0.0
#define     VOGRID_TYPE_ORIGIN  3       //  Origin (HZERO + VZERO)

    LOGPEN          logpenData;         // Pen to use when drawing grid
    
    
    VOGRID_POLYGON  polygons[VOGRID_NPOLYGONS];  // List of polygons indexed [0..VOGRID_NPOLYGONS)
    
    POINT           *points;            // malloc'd array of POINTs used as temporary buffer for polygons
                                        //  It stores points in a polygon in device (client) coordinates
                                        //  This array grows as needed by the polygons
    long            nPoints;            // Number of points allocated to points[]
    long            nPointsBytes;       // Number of bytes allocated to points[]
    
    } VOGRID;


//-----------------------------------------------------------------
// Global functions

TEMPODLLAPI long vogridRegister(VO *Vo);
TEMPODLLAPI long vogridUnregister(VO *Vo);

TEMPODLLAPI void vogridSetConnections(VOGRID *poGrid, struct _VOGRAPH *poGraph);
TEMPODLLAPI long vogridGetGridType(VOGRID *poGrid);
TEMPODLLAPI void vogridSetGridType(VOGRID *poGrid, long vogridType);
TEMPODLLAPI void vogridSetScaleExtents(VOGRID *poGrid, VOPROP_EXTENTS_T *scaleExtents);

TEMPODLLAPI long vogridSetPolygon(VOGRID *poGrid, long iPolygon, VOGRID_DPOINT *p, long nPoints);

TEMPODLLAPI long vogridSetPolygonPen(VOGRID *poGrid, long iPolygon, LOGPEN *logpen);
TEMPODLLAPI long vogridSetPolygonBrush(VOGRID *poGrid, long iPolygon, LOGBRUSH *logbrush);

//lint -esym(534, vogridSetPolygon, vogridSetPolygonPen, vogridSetPolygonBrush)     OK to ignore return code

#include    "tempodlx.h"


#endif // ifndef VOGRID_H
