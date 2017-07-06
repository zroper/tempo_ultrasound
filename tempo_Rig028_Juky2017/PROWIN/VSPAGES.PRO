/*  .title  VSPAGES.PRO - Protocol used to test access to VideoSYNC pages
;+
; SYNOPSIS
;   Writes a pattern to all VideoSYNC video memory pages then displays
;   each page.  You can use this to test access to multiple video memory
;   pages.
;
; DESCRIPTION
;   VideoSYNC supports multiple video memory pages which can be used
;   by your protocol to display quickly (in a single retrace) a complex
;   visual stimulus to the subject.
;
;   The number of available pages depends on the amount of video ram
;   on your video board and the current video mode (resolution).
;   You can use this protocol to test the available pages in
;   various video modes.
;
;   This protocol also provides an example of how to write to "unseen"
;   pages then "flip" to them in a single vertical retrace.
;
_video
_ncolors
_nrgb
_colormax
_rgbmax
_xmax
_ymax
_npages
_x
_y

; EDIT HISTORY
;   14Aug03 sh  Initial edit
;-
*/
#pragma declare = 1                     // Require declarations

//------------------------------------------------------------------
// The user sets the following two settings.
//
// WARNING: if you set maxPageNumber greater than the amount of
// available video RAM, you may cause VideoSYNC to halt.
// Check VDOSYNC -V for the mode you want to test and set maxPageNumber
// accordingly.
//------------------------------------------------------------------

DECLARE int Video         = 261;        // VideoSYNC mode to test
DECLARE int maxPageNumber =   4;        // Number of available pages in this mode

//------------------------------------------------------------------
// You shouldn't have to change anything below this line
//------------------------------------------------------------------

// The following table provides information about each video mode
// supported by VideoSYNC.  The number of pages varies depending
// on your video card and mode.  You can view information about each
// mode of your video card by running VDOSYNC -V.
// Also, see the VTIME.EXE program to get timing information on each
// video mode.

DECLARE int MODEINDEX  = 0;             // Index into modes[] to the MODE value
DECLARE int WHITEINDEX = 1;             // Index into modes[] to a MODE's white color

DECLARE constant int NMODES = 34;       // Maximum number of video modes
DECLARE int modes[NMODES, 2] =
    {
     16, 15,        // 0  640  350       16   4     2  Yes  EGA        640 x  350 x    16 ( 4 bpp)*
     18, 15,        // 1  640  480       16  64     2  Yes  VGA        640 x  480 x    16 ( 4 bpp)
    137,255,        // 2  320  240      256  64    27  Yes  VGA ModeX  320 x  240 x   256 ( 8 bpp)
    181,255,        // 3  320  200      256  64    32  Yes  VGA ModeX  320 x  200 x   256 ( 8 bpp)
    182,255,        // 4  320  400      256  64    16  Yes  VGA ModeX  320 x  400 x   256 ( 8 bpp)
    183,255,        // 5  320  480      256  64    13  Yes  VGA ModeX  320 x  480 x   256 ( 8 bpp)
    184,255,        // 6  360  200      256  64    29  Yes  VGA ModeX  360 x  200 x   256 ( 8 bpp)
    185,255,        // 7  360  240      256  64    24  Yes  VGA ModeX  360 x  240 x   256 ( 8 bpp)
    186,255,        // 8  360  400      256  64    14  Yes  VGA ModeX  360 x  400 x   256 ( 8 bpp)
    187,255,        // 9  360  480      256  64    12  Yes  VGA ModeX  360 x  480 x   256 ( 8 bpp)
    256,255,        //10  640  400      256  64     8  Yes  VESA 100H  640 x  400 x   256 ( 8 bpp)
    257,255,        //11  640  480      256  64     6  Yes  VESA 101H  640 x  480 x   256 ( 8 bpp)
    258,255,        //12  800  600       16  64     8  Yes  VESA 102H  800 x  600 x    16 ( 4 bpp)
    259,255,        //13  800  600      256  64     4  Yes  VESA 103H  800 x  600 x   256 ( 8 bpp)
    260,255,        //14 1024  768       16  64     5  Yes  VESA 104H 1024 x  768 x    16 ( 4 bpp)
    261,255,        //15 1024  768      256  64     2  Yes  VESA 105H 1024 x  768 x   256 ( 8 bpp)
    262,255,        //16 1280 1024       16  64     0   No  VESA 106H 1280 x 1024 x    16 ( 4 bpp)
    263,255,        //17 1280 1024      256  64     1  Yes  VESA 107H 1280 x 1024 x   256 ( 8 bpp)
    269,0xFFFFFF,   //18  320  200    32768  32    16  Yes  VESA 10DH  320 x  200 x 32768 (15 bpp)
    270,0xFFFFFF,   //19  320  200    65536  64    16  Yes  VESA 10EH  320 x  200 x 65536 (16 bpp)
    271,0xFFFFFF,   //20  320  200 16777216 256    10  Yes  VESA 10FH  320 x  200 x   16M (24 bpp)
    272,0xFFFFFF,   //21  640  480    32768  32     3  Yes  VESA 110H  640 x  480 x 32768 (15 bpp)
    273,0xFFFFFF,   //22  640  480    65536  64     3  Yes  VESA 111H  640 x  480 x 65536 (16 bpp)
    274,0xFFFFFF,   //23  640  480 16777216 256     2  Yes  VESA 112H  640 x  480 x   16M (24 bpp)
    275,0xFFFFFF,   //24  800  600    32768  32     2  Yes  VESA 113H  800 x  600 x 32768 (15 bpp)
    276,0xFFFFFF,   //25  800  600    65536  64     2  Yes  VESA 114H  800 x  600 x 65536 (16 bpp)
    277,0xFFFFFF,   //26  800  600 16777216 256     1  Yes  VESA 115H  800 x  600 x   16M (24 bpp)
    278,0xFFFFFF,   //27 1024  768    32768  32     1  Yes  VESA 116H 1024 x  768 x 32768 (15 bpp)
    279,0xFFFFFF,   //28 1024  768    65536  64     1  Yes  VESA 117H 1024 x  768 x 65536 (16 bpp)
    280,0xFFFFFF,   //29 1024  768 16777216 256     0   No  VESA 118H 1024 x  768 x   16M (24 bpp)
    281,0xFFFFFF,   //30 1280 1024    32768  32     0   No  VESA 119H 1280 x 1024 x 32768 (15 bpp)
    282,0xFFFFFF,   //31 1280 1024    65536  64     0   No  VESA 11AH 1280 x 1024 x 65536 (16 bpp)
    283,0xFFFFFF    //32 1280 1024 16777216 256     0   No  VESA 11BH 1280 x 1024 x   16M (24 bpp)
    };

DECLARE int whiteColor = 0;             // Color to use for white in CO

DECLARE Main();
DECLARE InitPage(int pageNumber);
DECLARE ShowPage(int pageNumber);
DECLARE FindWhite();

//---------------------------------------------------------------
process Main() enabled
{
    int     pageNumber;                 // A videoSYNC page number [0, 1, ..., _npages)

spawnwait FindWhite();                  // Determine the color index for WHITE
if (!whiteColor)
    {
    printf("Video mode %d is not available\n", Video);
    suspend;
    }
    
printf("Initializing VideoSYNC for VIDEO=%d ...\n", Video);    
    
dsendf("VI %d\n", Video);               // Set video mode
dsendf("CA\n");                         // Clear all settings
wait 5000;                              // Wait for these slow commands

// Loop once and initialize each page

pageNumber = 0;
while (pageNumber < maxPageNumber)
    {
    spawnwait InitPage(pageNumber);
    pageNumber = pageNumber + 1;
    }

// Loop continuously showing each page

pageNumber = 0;
while (1)
    {
    printf("Displaying VIDEO=%d page %d\n", Video, pageNumber);
    spawnwait ShowPage(pageNumber);
    wait    2000;                           // Give user a time to view it
    
    pageNumber = pageNumber + 1;
    if (pageNumber >= maxPageNumber)
        pageNumber = 0;
    }

}

//---------------------------------------------------------------
// Determine the color of white for the VIDEO mode selected by user.

process FindWhite()
{
    int     i;
    
i = 0;
whiteColor = 0;
while (i < NMODES)                      // Look for the video mode
    {
    if (modes[i,MODEINDEX] == Video)
        {
        whiteColor = modes[i, WHITEINDEX];
        i = NMODES;                     // Quit loop
        }
    i = i + 1;
    }
}

//---------------------------------------------------------------
process InitPage(int pageNumber)
{
dsendf("RW %d,%d\n", pageNumber, pageNumber);// RW sets page to write to
dsendf("CO %d\n", whiteColor);              // Set current color to WHITE
dsendf("CL\n");                             // Clear page

dsendf("MV 0,0\n");                         // Upper left corner
dsendf("TX PAGE %d TOP LEFT\n", pageNumber);

dsendf("MV _xmax / 2, _ymax / 2\n");        // Center of page
dsendf("TX PAGE %d CENTER\n", pageNumber);

dsendf("MV _xmax - 160, _ymax -20\n");      // Lower right corner
dsendf("TX PAGE %d BOTTOM RIGHT\n", pageNumber);

dsendf("RU 0,0,_xmax-1, _ymax-1\n");        // White box around page

dsendf("MV 0,      0; DR _xmax-1, _ymax-1\n");// diagnoal ulc to lrc
dsendf("MV _xmax-1,0; DR 0,       _ymax-1\n");// diagnoal lrc to llc

while (dsend()) nexttick;                   // Wait for all commands
}

//---------------------------------------------------------------
process ShowPage(int pageNumber)
{
dsendf("VP %d\n", pageNumber);
}
