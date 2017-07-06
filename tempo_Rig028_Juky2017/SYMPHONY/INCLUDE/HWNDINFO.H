#ifndef HWNDINFO_H
#define HWNDINFO_H

#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"

//--------------------------------------------------------

typedef struct
    {
    SIZE            szScreen;           // Desktop size in screen (pixels) coordinates
    POINT           ptOrigin;           // Upper left corner of desktop
    long            nMonitors;          // Number of monitors
    SIZE            szMonitor;          // Size of one monitor in screen (pixels) coordinates
    } HWNDINFO_DESKTOP;



//--------------------------------------------------------
// Information about the screen

typedef struct _HWNDINFO
    {
    HWNDINFO_DESKTOP    dtDesktop;      // Desktop information
    
    long            sizePalette;        // Number of distinct colors
    long            bitsPixel;          // Number of bits per pixel (color depth)
    long            numColors;          // Number of entries in the device’s color table, if the
                                        // device has a color depth of no more than 8 bits per pixel.
                                        // For devices with greater color depths, -1 is returned. 
    long            colorRes;           // Actual color resolution of the device, in bits per pixel.
                                        // This index is valid only if the device driver sets the
                                        // RC_PALETTE bit in the RASTERCAPS index and is available
                                        // only if the driver is compatible with Windows version 3.0
                                        // or later.
    long            cysize;             // Height of Window Caption
    TEXTMETRIC      tmFixed;            // SYSTEM_FIXED_FONT
    TEXTMETRIC      tmDefault;          // Default font
    
    SIZE            szFixedChar;        // # of pixels in fixed font
    
    SIZE            szDrag;             // # of pixels before starting drag operation
    } HWNDINFO;



//--------------------------------------------------------
// Function declarations

TEMPODLLAPI void hwndInfo(HWND hwnd, HWNDINFO *hi);

TEMPODLLAPI HWNDINFO_DESKTOP hwndInfoGetDesktop(void);
TEMPODLLAPI long hwndInfoAreDesktopsEqual(const HWNDINFO_DESKTOP *d1, const HWNDINFO_DESKTOP *d2);
TEMPODLLAPI long hwndInfoGetMonitor(POINT point, const HWNDINFO_DESKTOP *dt);
TEMPODLLAPI WINDOWPLACEMENT hwndInfoMapWindowplacement(const WINDOWPLACEMENT *wp,
                          long isChild,
                          const HWNDINFO_DESKTOP *dtOld,
                          const HWNDINFO_DESKTOP *dtNew);
TEMPODLLAPI RECT hwndInfoMapChildRect(RECT *rectChild, HWNDINFO_DESKTOP *dtOld, HWNDINFO_DESKTOP *dtNew);
TEMPODLLAPI RECT hwndInfoMapScreenRect(RECT *rectScreen, HWNDINFO_DESKTOP *dtOld, HWNDINFO_DESKTOP *dtNew);




#include "TEMPODLX.H"
#pragma pack(pop)                   // See pragma pack(push,1) above



#endif  // ifndef HWNDINFO_H
