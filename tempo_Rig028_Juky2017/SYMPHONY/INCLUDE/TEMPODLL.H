//lint -e537
/*  .title  TEMPODLL.H - Definitions for use with modules that export from TEMPO.DLL
;+
; DESCRIPTION
;
;   This header (and TEMPODLX.H) are used in .H and .C modules that are in
;   TEMPO.DLL and contain definitions that need to be exported from TEMPO.DLL.
;
;   Modules which don't export definitions from TEMPO.DLL do not need to
;   use TEMPODLL.H.
;
;
; THE PROBLEM
;
;   We want to compile the same .H and .C files but for different purposes:
;
;   1. LIB32 .OBJs in are used by TEMPO software.  All .OBJs are statically
;      linked so no DLLEXPORT or DLLIMPORT attributes are associated with
;      the declarations.
;
;   2. TEMPODLL .OBJs are included in TEMPO.DLL.  TEMPO.DLL is dynamically
;      linked by the user written programs.  Any functions and variables
;      in TEMPO.DLL that are meant to be visible to the user are declared
;      with the DLLEXPORT.
;
;      When a lib32\*.c file is compiled for tempodll, some global
;      variables are not exported from the DLL; they are used
;      internally by other TEMPO.DLL functions.  These internal functions
;      and variables are not exported by the DLL and are declared with
;      only the extern attribute.
;
;      But some variables and functions are exported by TEMPO.DLL.  These
;      variables and functions are declared with __declspec(dllexport)
;      attribute by the .C function that _defines_ the functions/variables.
;
;   3. When a user written program uses TEMPO.DLL, the .Hs in TEMPODLL\*.h
;      are the user-visible API to TEMPO.DLL.  These functions and variables
;      are declared the tempodll\*.h files a __declspec(dllimport).
;
;   The problem is to have a way for the same exact .C and .H files (in lib32)
;   to be compiled and used in these three different contexts.
;
;   For TEMPO software that doesn't use the TEMPO.DLL, access to functions are
;   fast because they are statically linked as externs.
;
;
; HOW IT WORKS
;
;   We use the following #defines:
;
;       ISLIB32 -     Defined when compiling .obj for LIB32
;                     (we don't care about its value)
;                     The -D compiler switch is used in the LIB32.MAK to set this.
;
;       ISTEMPODLL -  Defined when compiling .obj for TEMPO.DLL
;                     (we don't care about its value)
;                     The -D compiler switch is used in the TEMPODLL.MAK to set this.
;
;       For TEMPO software that doesn't use the TEMPO.DLL (TEMPOW.exe) and for
;       user compiled software, neither of the above two are defined.
;
;       TEMPODLLAPI - used in .H declarations to indicate that this
;                     function or variable is exportable by TEMPO.DLL.
;                     Whether or not it is in fact declared to export
;                     depends on TEMPODLLAPIDEFAULT.
;
;       TEMPODLLAPIDEFAULT - This is used only when TEMPODLLAPI is defined.
;                     When ISLIB32 is defined or neither ISLIB32 nor ISTEMPODLL
;                     are defined, it is ignored.
;
;                     TEMPODLLAPIDEFAULT is set in a .C file to __declspec(dllexport)
;                     to indicate that any extern functions or
;                     variables in subsequent .H files that contain declarations
;                     with TEMPODLLAPI attribute should be DLL exported.
;
;
;   COMPILING IN LIB32. When .C + .H modules are compiled for LIB32,
;   any TEMPODLLAPI declared variables and functions in the .H will compile
;   with TEMPODLLAPI defined to the empty string / * ... * /.  The LIB32\lib32.mak
;   file #defines the ISLIB32 so we can tell if we're compiling inside LIB32.
;   When ISLIB32 is not defined, we are not compiling for LIB32.
;
;
;   COMPILING IN TEMPODLL. When compiling inside TEMPODLL, the TEMPODLL\tempodll.mak
;   #defines ISTEMPODLL.  This tells us that TEMPODLLAPI will be declared either as 
;   the empty string or as __declspec(dllexport).  This is determined
;   by the .C file that is being compiled.  When the C file that contains
;   the _definitions_ for the _declarations_ in the .h file is being compiled
;   it surrounds the #include ...h with the following.  For example, Y.C
;   would look like this:
;
;       #include    "tempodll.h"
;       ...
;       #include x.h                // Y.C refers to these
;       ...
;
;       #define TEMPODLLAPIDEFAULT  __declspec(dllexport)
;       #include y.h                // Y.C defines these
;       #undef TEMPODLLAPIDEFAULT
;
;       ...
;       #include z.h                // Y.C refers to these
;
;       #include    "tempodlx.h"    // End C declarations for C++ users
;
;
;   COMPILING IN OTHER LOCATIONS (user).
;
;   The .OBJs in LIB32 are not made available to the user.  They are
;   used internally by TEMPO software.
;
;   The .OBJs in TEMPODLL are in the TEMPO.DLL and are, thus, being
;   made available to the use.  Only functions and variables which are
;   declared in TEMPODLL\*.H are visible to the user.  Other .OBJs
;   for which no .H is in TEMPODLL are not visible to the user.  These
;   modules are used internally by other functions in TEMPO.DLL.
;
;   The lib32\*.c and lib32\*.h are original source files.  A read-only version
;   of selected lib32\*.h files are copied to tempodll.  These are
;   the modules that "export" functions or variables from TEMPO.DLL.
;   
;
; COMPILATION BY C++ Users
;
;   This header defines compile time code so C++ users can call these functions.
;   Any .H that includes TEMPODLL.H, must do so at the beginning of the the .H
;   file.  The .H must also include TEMPODLX.H at the end to "close" the C++
;   definitions.
;
;
; EDIT HISTORY
;   01Oct06 sh  Initial edit
;   02Oct06 sh  if LIB16 or LIB32
;   14Nov06 sh  change _cplusplus to __cplusplus (two underscores)
;-
*/
//lint -esym(537, c:\usr\tempo\lib32\tempodll.h)
//lint -esym(537, c:\usr\tempo\tempodll\tempodll.h)

//------------------------------------------------------------------------------
#ifndef TEMPODLLDEFAULT             // Does the .C want us to export the declarations?
    #define TEMPODLLDEFAULT  /* */  /* No, these functions/variables are used by DLL modules but not exported */
#endif

#ifdef TEMPODLLAPI                  // Start fresh
    #undef TEMPODLLAPI
#endif

// If we are being included with #include "..\lib32\..", then
// THISLIB.H will have ISLIB32 defined.
// If we are being included with #include "..\tempodll\.. then
// ISLIB32 won't be set.

#include "thislib.h"                // In 

// Redefine TEMPODLLAPI based on what we know at this point.

#ifdef ISLIB32                          // Are we compiling from LIB32?

    #define TEMPODLLAPI /* */           /* Yes, we don't export/import anything! */
    //#pragma message(__FILE__ " Defining TEMPODLLAPI as NULL (ISLIB32)")
    
#elif defined(ISLIB16)                  // Are we compiling from LIB16?

    #define TEMPODLLAPI /* */           /* Yes, we don't export/import anything! */
    //#pragma message(__FILE__ " Defining TEMPODLLAPI as NULL (ISLIB16)")
    
#elif defined(ISTEMPODLL)               // Are we compiling in TEMPODLL?

    // The .C file can #define TEMPODLLDEFAULT to __declspec(dllexport)
    // or it can not define it.  If it is not defined, then variables
    // declared with TEMPODLLAPI attribute will not be exported.
    //
    // Otherwise, they will be exported.
    //
    // Only .C files that contain the DEFINITIONS for these DECLARATIONS
    // should #define TEMPODLLDEFAULT __declspec(dllexport).
    // All other >C files should leave TEMPODLLDEFAULT undefined or
    // define it to / *  ... * / 
    
    #define TEMPODLLAPI     TEMPODLLDEFAULT     /* This will either export or do nothing */
    //#pragma message(__FILE__ " Defining TEMPODLLAPI as TEMPODLLDEFAULT (ISTEMPODLL)")

#else                                   // Are we compiling in someplace else?

    #ifdef MSDOS
        #define TEMPODLLAPI /* */           /* Yes, we don't export/import anything! */
        //#pragma message(__FILE__ " Defining TEMPODLLAPI as NULL (DOS)")
    #else
        #define TEMPODLLAPI __declspec(dllimport)   /* Yes, import these functions */
        //#pragma message(__FILE__ " Defining TEMPODLLAPI as DLLIMPORT (WIN32)")
    #endif

#endif    

//------------------------------------------------------------------------------
// For the benefit of C++ users, we add this all public .H files so C++ users
// don't need to.

#ifdef __cplusplus                      // Allow C++ users to access these definitions
    extern "C" {
#endif


