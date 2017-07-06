; MODEX.VS - Test availability of multiple video pages in a particular video mode
;
; To run this test:
;
;       vdosync video=### mode=modex.vs     where ### is a VideoSYNC video mode
;
; Here is a table of the possible video modes (from VDOSYNC -V).  The modes
; listed as "Yes" in the AVAIL column are considered by VideoSYNC to be
; available.
;
;   Mode   X    Y   COLORS  RGB PAGES AVAIL DESC     4.0 Mb VideoRAM
;   ---- ---- ---- -------- --- ----- ----- ----
;     16  640  350       16   4     2  Yes  EGA        640 x  350 x    16 ( 4 bpp)*
;     18  640  480       16  64     2  Yes  VGA        640 x  480 x    16 ( 4 bpp)
;    256  640  400      256  64    16  Yes  VESA 100H  640 x  400 x   256 ( 8 bpp)
;    257  640  480      256  64    13  Yes  VESA 101H  640 x  480 x   256 ( 8 bpp)
;    258  800  600       16  64    17  Yes  VESA 102H  800 x  600 x    16 ( 4 bpp)
;    259  800  600      256  64     8  Yes  VESA 103H  800 x  600 x   256 ( 8 bpp)
;    260 1024  768       16  64    10  Yes  VESA 104H 1024 x  768 x    16 ( 4 bpp)
;    261 1024  768      256  64     5  Yes  VESA 105H 1024 x  768 x   256 ( 8 bpp)
;    262 1280 1024       16  64     6  Yes  VESA 106H 1280 x 1024 x    16 ( 4 bpp)
;    263 1280 1024      256  64     3  Yes  VESA 107H 1280 x 1024 x   256 ( 8 bpp)
;    269  320  200    32768  32     0   No  VESA 10DH  320 x  200 x 32768 (15 bpp)
;    270  320  200    65536  64    32  Yes  VESA 10EH  320 x  200 x 65536 (16 bpp)
;    271  320  200 16777216 256     0   No  VESA 10FH  320 x  200 x   16M (24 bpp)
;    272  640  480    32768  32     0   No  VESA 110H  640 x  480 x 32768 (15 bpp)
;    273  640  480    65536  64     6  Yes  VESA 111H  640 x  480 x 65536 (16 bpp)
;    274  640  480 16777216 256     0   No  VESA 112H  640 x  480 x   16M (24 bpp)
;    275  800  600    32768  32     0   No  VESA 113H  800 x  600 x 32768 (15 bpp)
;    276  800  600    65536  64     4  Yes  VESA 114H  800 x  600 x 65536 (16 bpp)
;    277  800  600 16777216 256     0   No  VESA 115H  800 x  600 x   16M (24 bpp)
;    278 1024  768    32768  32     0   No  VESA 116H 1024 x  768 x 32768 (15 bpp)
;    279 1024  768    65536  64     2  Yes  VESA 117H 1024 x  768 x 65536 (16 bpp)
;    280 1024  768 16777216 256     0   No  VESA 118H 1024 x  768 x   16M (24 bpp)
;    281 1280 1024    32768  32     0   No  VESA 119H 1280 x 1024 x 32768 (15 bpp)
;    282 1280 1024    65536  64     1  Yes  VESA 11AH 1280 x 1024 x 65536 (16 bpp)
;    283 1280 1024 16777216 256     0   No  VESA 11BH 1280 x 1024 x   16M (24 bpp)
;    181  320  200      256  64    65  Yes  VGA ModeX  320 x  200 x   256 ( 8 bpp)
;    137  320  240      256  64    54  Yes  VGA ModeX  320 x  240 x   256 ( 8 bpp)
;    182  320  400      256  64    32  Yes  VGA ModeX  320 x  400 x   256 ( 8 bpp)
;    183  320  480      256  64    27  Yes  VGA ModeX  320 x  480 x   256 ( 8 bpp)
;    184  360  200      256  64    58  Yes  VGA ModeX  360 x  200 x   256 ( 8 bpp)
;    185  360  240      256  64    48  Yes  VGA ModeX  360 x  240 x   256 ( 8 bpp)
;    186  360  400      256  64    29  Yes  VGA ModeX  360 x  400 x   256 ( 8 bpp)
;    187  360  480      256  64    24  Yes  VGA ModeX  360 x  480 x   256 ( 8 bpp)
; 
; Some manufactures do not fully support certain features such as multiple
; video pages in some modeX video modes .  Thus, while a
; ModeX video mode may appear to be available in the
; Vdosync -v table, the multi-paging may not work properly.
; Unfortunately, it is not possible for VideoSYNC to automatically detect
; when a video chip does not all certain features of a particular video mode.
; So this must be determined empirically with a test such as this one.
;
; This little VideoSYNC command file can be used to test
; whether the first three video pages (page 0, 1 and 2)
; are working properly.
;
; Different things are drawn on each video pages.  We
; then "flip" through each page showing each page for one second.
; You should see the screen change with each page and each
; page should be _completely_ different.
;
; Here are some faulty behaviors that we have observed when the video mode
; fails to properly support multiple video pages.
;
;   1. VideoSYNC crashes, requiring a power boot to restart the computer
;   2. page 0 shows ok but page 1 and page 2 show together
;   3. all three pages appear overlayed on each other

vc 0,1024,0,768
cl

; page 0
; Draw "Page 0" in white and a filled rectangle in dark magenta

rw 0,0
co 5
rf 100,100,200,200
mv 100,100
co 15
tx Page 0

; page 1
; Draw "Page 1" in white and a filled rectangle in brown

rw 1,1
co 6
rf 200,200,300,300
mv 200,200
co 15
tx Page 1

; page 2
; Draw "Page 2" in white and a filled rectangle in light green

rw 2,2
co 10
rf 300,300,400,400
mv 300,300
co 15
tx Page 2

; show each page for 1 second
; cycle through the three pages twice

vp 0
wm 1000
vp 1
wm 1000
vp 2
wm 1000

vp 0
wm 1000
vp 1
wm 1000
vp 2
wm 1000


