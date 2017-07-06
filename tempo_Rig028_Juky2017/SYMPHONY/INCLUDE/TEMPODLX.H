/*  .title  TEMPODLX.H - Used with TEMPODLL.H 
;+
; DESCRIPTION
;   This file "closes" the C++ definitions that were "opened" in TEMPODLL.H
;   It should be #included the end of any .H file that #includes TEMPODLL.H at the
;   beginning.
;
; EDIT HISTORY
;   01Oct06 sh  Initial edit
;   14Nov06 sh  change _cplusplus to __cplusplus (two underscores)
;-
*/
//lint -esym(537, tempodlx.h)

#ifdef __cplusplus                       // Allow C++ users to access these definitions
    }
#endif

// The scope of TEMPODLLDEFAULT ends at the end of each .H file

#ifdef TEMPODLLDEFAULT
    #undef TEMPODLLDEFAULT
#endif

