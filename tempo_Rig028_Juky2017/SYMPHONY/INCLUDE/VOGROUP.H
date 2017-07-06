#ifndef VOGROUP_H
#define VOGROUP_H

//----------------------------------------------------------
// The VOGROUP structure has VOOBJ as its base class.

#define VOOBJECT_GROUP  "group"         // Name of a group object

typedef struct _VOGROUP
    {
    VOOBJ   obj;                        // Must be first member
    
    // Additional stuff specific to being a group
    
    VO      Vo;                         // Vo handle to list of objects
    VOFUNC  base;                       // Base class callbacks
    
    } VOGROUP;
    

extern long vogroupRegister(VO *Vo);
extern long vogroupUnregister(VO *Vo);
extern VOFUNC  fVOGROUP;

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
// long vogroupGetDataExtents(VOGROUP *poGroup, VOPROP_EXTENTS_T *ext)
#define vogroupGetDataExtents(poGroup, ext) /*lint --e(522)*/       \
        (((poGroup) && fVOGROUP.fGetProp) ?                         \
            fVOGROUP.fGetProp(&((VOGROUP *) (poGroup))->obj,        \
                VOPROP_DATAEXTENTS, (VOPROP_EXTENTS_T *)(ext),      \
                NULL, NULL, NULL)                                   \
            : 0)

//---------------
// long vogroupSetScaleExtents(VOGROUP *poGroup, VOPROP_EXTENTS_T *ext)
#define vogroupSetScaleExtents(poGroup, ext)  /*lint --e(522)*/     \
        (((poGroup) && fVOGROUP.fSetProp) ?                         \
            fVOGROUP.fSetProp(&((VOGROUP *) (poGroup))->obj,        \
                VOPROP_SCALEEXTENTS, (VOPROP_EXTENTS_T *)(ext),     \
                NULL, NULL, NULL)                                   \
            : 0)


#endif  // ifndef VOGROUP_H
