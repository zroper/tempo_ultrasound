/*  .title  VO.H - VO application definitions
;+
; EDIT HISTORY
;   26Oct07 sh  Add fSetProp and fGetProp
;   10Nov09 sh  Add voPrevObjInTree() (for debugging)
;-
*/

#ifndef VO_H
#define VO_H                        // Define only once

//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"


//----------------------------------------------------------
// Status codes returned by VO

#define VOERR_OK             0      // Successful
#define VOERR_INVALIDVO     -1      // Invalid VO handle
#define VOERR_NOMEMORY      -2      // Out of memory
#define VOERR_NOCTRL        -3      // No more VO control blocks
#define VOERR_INVALIDHWND   -4      // Invalid HWND
#define VOERR_HWNDNOTFOUND  -5      // HWND not found
#define VOERR_INVALIDVOOBJ  -6      // Invalid VOOBJ handle
#define VOERR_INVALIDTYPE   -7      // Invalid object type
#define VOERR_CONSTRUCTORNOTFOUND   -8  // Constructor not found
#define VOERR_LLERR         -9      // A Link list error occurred
#define VOERR_INVALIDARG    -10     // Invalid argumnent to function
#define VOERR_NOTINIT       -11     // VO package not initialized


#define VOERR_LASTONE       VOERR_NOTINIT


//----------------------------------------------------------
// Types for votype argument in VOOFDRAG
    
#define VOTYPE_DRAG        1        // All 4 corners change
#define VOTYPE_RESIZE      2        // Only lower right corner changes

// Types for vosptype argument in VOOFSETPOSITION

#define VOSPTYPE_MOVE           1   // Application wants to move object
#define VOSPTYPE_DROP           2   // User wants to drop object


//----------------------------------------------------------
// Application callback functions allow an application to
// be notified when changes occur to the visual objects.
//----------------------------------------------------------
//
// VOOFCONSTRUCTOR - Application callback function.
// This function is called when the user creates a new object
// The VO system allocates/frees the memory for the object.
// The application's constructor initializes the object's memory.
// 
// IN
//      po          Pointer to a VOOBJ

typedef void (*VOOFCONSTRUCTOR)(struct _VOOBJ *po);



//----------------------------------------------------------
// VOOFPAINT - Application callback function.
// This function is called when VO needs to WM_PAINT the object
// 
// IN
//      po          Pointer to a VOOBJ

typedef void (*VOOFPAINT)(struct _VOOBJ *po, HDC hdc, long fErase, RECT rcPaint);


//--------------------------------------------------------
// An application can call the object's function with this macro.

#define VOCALL_FPAINT(po, hdc, fErase, rcPaint)         \
    do {                                                \
       if (po->f.fPaint)                                \
           {                                            \
           (po->f.fPaint)(po, hdc, fErase, rcPaint);    \
           }                                            \
       } while (0 /*lint --e(717)*/ )
       


//----------------------------------------------------------
// VOOFPROPERTIES - Application callback function.
// This function is called when the user right clicks on an object.
// The user expects a menu or dialog to appear that allows them to
// modify properties of the object or perform functions on all selected
// objects. 
//
// IN
//      po          Pointer to a VOOBJ
//      clientXY    client coordinates of where user right clicked.

typedef void (*VOOFPROPERTIES)(struct _VOOBJ *po, POINT clientXY);



//----------------------------------------------------------
// VOOFHITTEST - Application callback function.
// This callback function is called when the user left clicks in the client window.
// It is called to determine if the user is clicking on a particular object or
// its resize box.  It is useful for objects that have an unusual shape
// that doesn't conform to the usual rectangular hit region or resize box.
//
// The application can defer judgement to the VO package by returning -1
// or it can decide for itself if the object or its resize box is hit.
//
// Exactly one of clientXY and rectSelect pointers will be set.  The
// other will be NULL.
//
// If clientXY is non-NULL, it points to a POINT that contains the
// client coordinates of where the user left clicked.  The application's
// fHitTest() function can return -1,0,1,2.
// If fHitTest() returns -1, selection is based on VO's default method.
// If fHitTest() returns 0, the object is not selected.
// If fHitTest() returns 1, the object is selected.
// If fHitTest() returns 2, the object's resize box is selected.
//
//
// If rectSelect is non-NULL, it points to a RECT that contains the
// rubberband selection box created by the user.  It is intended to
// select zero or more objects that it encloses.  The application's
// fHitTest() function can return -1,0,1,2.
// If fHitTest() returns -1, selection is based on VO's default method.
// If fHitTest() returns 0, the object is not selected.
// If fHitTest() returns 1, the object is selected.
// If fHitTest() returns 2, the object is not selected.
// 
// IN
//      po          Pointer to a VOOBJ
//      clientXY    NULL or client X,Y where user clicked (client coordinates)
//      rectSelect  NULL or selection rectangle (client coordinates)
//      
//
// RETURNS
//      -1          Use default hit test
//       0          Did not hit object or its resize box
//       1          hit object
//       2          hit object's resize box

typedef long (*VOOFHITTEST)(struct _VOOBJ *po, POINT *clientXY, RECT *rectSelect);

       


//----------------------------------------------------------
// VOOFDRAG - Application callback function.
// An application can register an fDrag callback function for a particular
// object.  This gives the application control over how the user can drag
// the object.  The fDrag function can modify the dx,dy parameters to
// limit dragging trajectory of the object.
//
// IN
//      po          Pointer to a VOOBJ
//      votype      Type of change (VOTYPE_x)
//                      VOTYPE_DRAG     Object is being dragged
//                      VOTYPE_RESIZE   Object is being resized
//      dx, dy      Pointers to X, Y changes relative to current position
// OUT
//      dx, dy      

typedef void (*VOOFDRAG)(struct _VOOBJ *po, long votype, long *dx, long *dy);



//----------------------------------------------------------
// VOOFSETPOSITION - Application callback function.
// An application can register an fSetPosition callback function for a particular
// object.  This gives the application control over how the user can move
// the object.  The fSetPosition function can modify the dx,dy parameters to
// limit position of the object.
//
// The position and size of the object can change.
//
// IN
//      po          Pointer to a VOOBJ
//      vospType    A VOSPTYPE_xx code (VOSPTYPE_MOVE, VOSPTYPE_DROP)
//      oldPosition Pointer to RECT containing old position in client coordinates
//                      (read only)
//      newPosition Pointer to RECT containing new position in client coordinates
//                      (read/write)
//
// OUT
//      newPosition    

typedef void (*VOOFSETPOSITION)(struct _VOOBJ *po, long vospType, RECT *oldPosition, RECT *newPosition);



//----------------------------------------------------------
// VOOFDESTROY - Application callback function.
// This function is called before an object is destroyed.
// When the callback returns, the VO system will destroy the object
// erase it, and release its resources
// 
// IN
//      po          Pointer to a VOOBJ

typedef void (*VOOFDESTROY)(struct _VOOBJ *po);


       
//----------------------------------------------------------
// VOOFSETPROP - Application callback function.
// Set object properties.  The semantics of this is object specific.
// The interpretation of prop, the p1-p4 and the return value are object specific.
// 
// IN
//      po          Pointer to a VOOBJ
//      prop        the property number
//      p1,p2,p3,p4 parameters
//
// OUT
//      object specific return value.

typedef long (*VOOFSETPROP)(struct _VOOBJ *po, long prop, void *p1, void *p2, void *p3, void *p4);


       
//----------------------------------------------------------
// VOOFGETPROP - Application callback function.
// Get object properties.  The semantics of this is object specific.
// The interpretation of prop, the p1-p4 and the return value are object specific.
// 
// IN
//      po          Pointer to a VOOBJ
//      prop        the property number
//      p1,p2,p3,p4 parameters
//
// OUT
//      object specific return value.

typedef long (*VOOFGETPROP)(struct _VOOBJ *po, long prop, void *p1, void *p2, void *p3, void *p4);


//---------------------------------
// VO reserved properties codes.
// Not all objects implement these.
// But if these VOPROP_x are supported, here is what they mean.

#define VOPROP_FIRST        0x8000000

#define VOPROP_POSITION     (VOPROP_FIRST+1)   // Returns RECT *p1 = object position
#define VOPROP_SO           (VOPROP_FIRST+2)   // Returns SO *p1 = NULL or SO*
//#define VOPROP_XEXTENT      (VOPROP_FIRST+3)   // Returns double *p1 = xLow, double *p2 = xHigh
//#define VOPROP_YEXTENT      (VOPROP_FIRST+4)   // Returns double *p1 = yLow, double *p2 = yHigh
#define VOPROP_DATAEXTENTS  (VOPROP_FIRST+5)   // Get/Set data extents, p1=VOPROP_EXTENTS*
#define VOPROP_SCALEEXTENTS (VOPROP_FIRST+6)   // Get/Set scale extents, p1=VOPROP_EXTENTS*

typedef struct                          // for VOPROP_DATAEXTENTS  VOPROP_SCALEEXTENTS
    {
    char        flag;                   // Bitwise flag
#define VOPROPFLAG_HSET   1             // hmin,hmax are set
#define VOPROPFLAG_VSET   2             // vmin,vmax are set
#define VOPROPFLAG_MANUAL 4             // If manualscale mode, use these values
    char        unused[3];
    double      hmin, hmax;             // Horizontal limits
    double      vmin, vmax;             // Vertical limits
    } VOPROP_EXTENTS_T;



       
//----------------------------------------------------------
// VOOFGETMENU - Ask Object to generate its Menu
// The object's fGetMenu() function calls voMenuInsertItem() zero
// or more times to insert menu items.
//
// IN
//      po              This VOOBJ*
//      Xmenu           NULL or handle for adding menu items
//      clientXY        client location of right click
//      fDoubleClick    =1 if user double right clicked
//      keyFlags        Indicates whether various keys are down
//                        MK_CONTROL  Set if the CTRL key is down. 
//                        MK_LBUTTON  Set if the left mouse button is down. 
//                        MK_MBUTTON  Set if the middle mouse button is down. 
//                        MK_RBUTTON  Set if the right mouse button is down. 
//                        MK_SHIFT    Set if the SHIFT key is down. 
//
// OUT
//      Adds zero or more menu items by calling voMenuInsertItem()
//      and voMenuPrefix();
//
// RETURNS
//      Nothing

typedef struct _VOMENU
    {
    long            flag;
#define VOMENU_FLAG_GETMENU     0       // Get menu
#define VOMENU_FLAG_FREEMENU    1       // Free menu resources
    struct _VOOBJ   *Po;                // NULL or Pointer to object hit by right click
    void            *Xmenu;             // Handle to XMENU control block
    POINT           clientXY;           // client coordinates of right click
    BOOL            fDoubleClick;       // =1 if user double right clicked
    UINT            keyFlags;           // Flags indicating which key was pressed    
    } VOMENU;


    
typedef void (*VOOFGETMENU)(struct _VOOBJ *Po, struct _VOMENU *vomenu);
typedef void (*VOOFDEFAULTMENU)(struct _VO *Vo, struct _VOMENU *vomenu, void *vocontext, long nvoContext);


typedef void (VOMENUFUNC)(struct _VOOBJ *Po, struct _VOMENU *vomenu, long wID, void *context, long nContext);
typedef void (VODEFAULTMENUFUNC)(struct _VO *Vo, struct _VOMENU *vomenu, long wID, void *context, long nContext);

typedef struct
    {
    LINKNODE        ll;                 // Must be first member
    VOMENUFUNC      *f;                 // object's menu callback function
    struct _VOOBJ   *Po;                // Pointer to object
    void            *context;           // object's context
    long            nContext;           // # of bytes in context
    } XMENUITEM;
    
    
//----------------------------------------------------------
// VOCONSTRUCTOR is the information maintained by the VO system for object constructors

typedef struct
    {
    char            name[32];           // Name of object
    VOOFCONSTRUCTOR fConstructor;       // Application's constructor function
    long            nBytes;             // # of bytes to allocate for object
    } VOCONSTRUCTOR;
    

//----------------------------------------------------------
// VO handle - User's version

typedef struct _VO
    {
    void    *p;                         // Pointer to internal VO_ structure
    } VO;
    

//----------------------------------------------------------
// VOFUNC is the table of standard callbacks for all objects.

typedef struct
    {
    VOOFCONSTRUCTOR fConstructor;       // Construct object
    VOOFDESTROY     fDestroy;           // Destroy object
    VOOFPAINT       fPaint;             // Repaint object
    VOOFPROPERTIES  fProperties;        // Display properties menu/dialog
    VOOFHITTEST     fHitTest;           // User's hit test callback
    VOOFSETPOSITION fSetPosition;       // User's setPosition callback
    VOOFDRAG        fDrag;              // User's drag callback
    VOOFSETPROP     fSetProp;           // Set Properties
    VOOFGETPROP     fGetProp;           // Get Properties
    VOOFGETMENU     fGetMenu;           // Get Object's menu
    } VOFUNC;


//----------------------------------------------------------
// VOOBJ (a VO object) Control block

typedef struct                          // Used by fDefaultMenu
    {
    UINT        wID;
    POINT       clientXY;
    BOOL        fDoubleClick;
    UINT        keyFlags;
    } VODEFAULTMENUCONTEXT;


typedef struct _VOOBJ
    {
    LINKNODE        linknode;           // List linkage information (MUST BE FIRST MEMBER!)
    VOCONSTRUCTOR   voc;                // Constructor info that created this object
    
    DWORD           data;               // User's data value
    
    struct _VO      Vo;                 // user handle of VO that owns this object
    
    // User callback functions.

    VOFUNC          f;                  // Table of standard callbacks for all objects

    //--------------------------------------------------------------    
    // The following information is considered "private"
    // to the VO system and shouldn't be accessed or changed directly
    // by a user application or object.
    
    char            isInitialized;      // 0=no, 1=yes
    char            isAGroup;           // 1=this is a VOGROUP, 0=not a group
    char            isNotHitable;       // 1=not hitable by mouse click or rubberband
    char            unused[1];
    
    //char            fConstructor_recursion; // =1 if inside function
    //char            fPaint_recursion;       // =1 if inside function
    //char            fProperties_recursion;  // =1 if inside function
    //char            fHitTest_recursion;     // =1 if inside function
    //
    //char            fSetPosition_recursion; // =1 if inside function
    //char            fDrag_recursion;        // =1 if inside function
    //char            fDestroy_recursion;     // =1 if inside function
    //char            unused1[1];

    RECT            position;           // Current position of object (smallest rectangle containing object)
    
    // State information about moving/resizing the object
    // These are used when selected (po.isSelected is set)
    // The dragBox and resizeBox are valid only when dragState != VODS_NONE
    
    char            unused2[3];         //
    char            isSelected;         // 0=no, 1=yes Is object selected?
    long            dragState;          // VODS_NONE, VODS_ISDRAGGINGOBJ or VODS_ISDRAGGINGRESIZE
    
    long            dx, dy;             // Change from original position (0,0)=no change
    RECT            dragBox;            // Box around object
    RECT            resizeBox;          // Small box for resizing
    
    VODEFAULTMENUCONTEXT  xcontext;     // Used when a default menu is created
    } VOOBJ;



//----------------------------------------------------------
// FUNCTION DECLARATIONS
// Functions an application can call to manipulate the VO system

TEMPODLLAPI long voInit(void);
TEMPODLLAPI long voUninit(void);

TEMPODLLAPI long voOpenControl(HWND *phwndVoControl, HWND hwndParent, long idctrl, RECT controlPosition);
TEMPODLLAPI long voCloseControl(HWND hwndVoControl);

TEMPODLLAPI long voOpen(VO *Vo, VO *VoParent, HWND hwnd);
TEMPODLLAPI long voClose(VO *Vo);
TEMPODLLAPI long voNObjects(VO *Vo);
TEMPODLLAPI long voHook(VO *Vo, HWND hwnd);
TEMPODLLAPI long voEnable(VO *Vo, long isEnabled);

TEMPODLLAPI VO *voRootVo(VO *Vo);
TEMPODLLAPI VO *voFindVOByHWND(HWND hwnd);
TEMPODLLAPI VO *voGetParentVo(VO *Vo);

TEMPODLLAPI HWND voGetHWND(VO *Vo);
TEMPODLLAPI struct _HWNDINFO *voGetHwndInfo(VO *Vo);

TEMPODLLAPI struct _VOGROUP *voGetVOObj(VO *Vo);

TEMPODLLAPI char *voErr(long voerr);


TEMPODLLAPI long voRegisterConstructor(VO *Vo, VOCONSTRUCTOR *voc);
TEMPODLLAPI long voUnregisterConstructor(VO *Vo, char *name);
TEMPODLLAPI long voGetConstructorInfo(VO *Vo, char *name, VOCONSTRUCTOR *voc);

TEMPODLLAPI void voDebug(char *logFilename);
TEMPODLLAPI void voLogf(char *fmt, ...);        //lint -printf(1, voLogf)

TEMPODLLAPI VOOBJ *voNextObj(VO *Vo, VOOBJ *po);
TEMPODLLAPI VOOBJ *voNextSelectedObj(VO *Vo, VOOBJ *po);
TEMPODLLAPI VOOBJ *voNextObjInTree(VO *Vo, VOOBJ *Po);
TEMPODLLAPI VOOBJ *voNextSelectedObjInTree(VO *Vo, VOOBJ *Po);

TEMPODLLAPI VOOBJ *voPrevObjInTree(VO *Vo, VOOBJ *Po);

TEMPODLLAPI VOOBJ *voPrevObj(VO *Vo, VOOBJ *po);

//----------------------------------------------------------
// Functions an application can call to manipulate an object


TEMPODLLAPI void *vooAdd(VO *Vo, char *constructorName, RECT *position);
TEMPODLLAPI long vooGetPosition(VOOBJ *po, RECT *position); //lint -esym(534, vooGetPosition)
TEMPODLLAPI long vooSetPosition(VOOBJ *po, RECT *position); //lint -esym(534,vooSetPosition)
TEMPODLLAPI long vooGetData(VOOBJ *po, DWORD *data);
TEMPODLLAPI long vooSetData(VOOBJ *po, DWORD data);
TEMPODLLAPI VO *vooGetVO(VOOBJ *po);
TEMPODLLAPI VO *vooGetGroupVO(VOOBJ *po);
TEMPODLLAPI long vooDestroy(VOOBJ *po);
TEMPODLLAPI void vooInvalidate(VOOBJ *Po, long fErase);     // Invalidate
TEMPODLLAPI VOOBJ *vooGetParent(VOOBJ *po);     // Returns parent VOOBJ * (==VOGROUP *)
TEMPODLLAPI char *vooGetConstructorName(VOOBJ *po);
TEMPODLLAPI long vooNotHitable(VOOBJ *po, long isNotHitable);   //lint -esym(534, vooNotHitable)


//--------------
// 13Jan08 WARNING: When using macros like vooGetProp/vooSetProp, the fGetProp/fSetProp function
//      that ACTUALLY gets called is the one in the object's VOOBJ.f structure!  For instance,
//      when vogroupSetProp(VOGRAPH *po,..) was # defined as vooSetProp(..),
//      vogroupSetProp(VOGRAPH *po, ..) wasn't calling VOGROUP's fSetProp function because
//      VOGRAPH hooked it!  Instead, vogroupSetProp was calling VOGRAPH's fSetProp!
//      If you WANT this effect, then use a macro-defined function like these (where the
//      function that gets called is determined by the particular po->f. function.  Otherwise,
//      use the particular fVOXXX. function (ie fVOGROUP.fSetProp).
//
//--------------

#define vooGetProp(po, prop, p1, p2, p3, p4) /*lint --e(522) */     \
        ((po) ?                                                     \
            ((po)->f.fGetProp((po), (prop), (p1), (p2), (p3), (p4)))\
           : 0)

//--------------
#define vooSetProp(po, prop, p1, p2, p3, p4) /*lint --e(522) */     \
        ((po) ?                                                     \
            ((po)->f.fSetProp((po), (prop), (p1), (p2), (p3), (p4)))\
           : 0)


//--------------
TEMPODLLAPI UINT voMenuInsertItem(void *Xmenu,
    VOMENUFUNC  *fMenuFunc,
    VOOBJ       *Po,
    void        *context,
    long        nContext,
    UINT        fType,
    UINT        fState,
    char        *fmt, ...);         //lint -printf(8, voMenuInsertItem)
    
TEMPODLLAPI void voMenuPrefix(void *Xmenu, char *prefix);

TEMPODLLAPI VOOFDEFAULTMENU voDefaultMenu(VO *Vo, VOOFDEFAULTMENU fDefaultMenu, void *vocontext, long nContext);


//----------------------------------------------------------
#include "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above

#endif // ifndef VO_H
