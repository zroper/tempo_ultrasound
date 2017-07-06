-------------------------------------------------------------------------
                         TEMPO Technical Support

                             VIDEOSYNC NOTES
                              January 2001


-------------------------------------------------
To install
-------------------------------------------------

If you already have VideoSYNC, simply copy the files on the diskette into
your VideoSYNC directory on your VideoSYNC computer.  For example, to copy
the contents of A: into C:\VDOSYNC

    xcopy a:\*.* c:\vdosync /s



-------------------------------------------------
First time users
-------------------------------------------------

Rename VS_.CFG to VS.CFG.  To run VideoSYNC, type:

    VDOSYNC VS.CFG

Type ESC at any time to exit.



-------------------------------------------------
To test your RDX parallel cable
-------------------------------------------------

You can test that the RDX parallel cable is wired and connected correctly
using the DDX program.

On the TEMPO computer, type:

    DDX send con 0x700

The above command assumes you have a CIO-DAS-1602 card installed on your
TEMPO computer and configured at it's factory default base address of
0x300.  It also assumes you are using the 8255 DIO chip on the
CIO-DAS-1602 for communication with VideoSYNC (the base address of this
chip is 0x400 higher than the base address of the CIO-DAS-1602).  If you
are using another 8255 DIO chip for VideoSYNC, change the base address in
the above command to the base address of that chip.

On the VideoSYNC computer, type:

    DDX recv con 0x300

The above command assumes you have a CIO-DIO-24 card in your VideoSYNC
computer configured at the factory default base address of 0x300.  If you
are using another 8255 DIO chip for VideoSYNC, change the base address in
the above command to the base address of that chip.

Characters typed on the TEMPO computer should appear on the VideoSYNC
computer's screen when the RDX parallel cable is working correctly.

Type ESC to exit DDX.

Note that DDX may be used to transfer files across the RDX link.  Simply
replace CON in the above commands with the name of the file you wish
to transfer.  When the file transfer is complete, type ESC on the
receiving computer to exit DDX.



-------------------------------------------------
To test 1024x768x256 (VIDEO=261) color video mode
-------------------------------------------------

Some video controllers & monitors do not support the higher resolutions
of SVGA.  You can use VideoSYNC to test whether or not your video
controller and monitor support 1024x768x256 color mode by typing
at the DOS prompt:

256

This runs 256.BAT.  You should see a checkerboard pattern which shows
all colors available in 256 color mode.  Press the ESC key at any time
to cancel the test.

Refer to 256.wpl text file for more information.


-------------------------------------------------
To test color images
-------------------------------------------------

Unzip IMAGES.ZIP:

    pkunzip images
    
Then run MONKEY.BAT.  This should display a red brain and a monkey face.


-------------------------------------------------
To test sound blaster
-------------------------------------------------

Unzip the SOUND.ZIP file:

    pkunzip sound
    
Then run the SOUND.BAT file by typing at the DOS prompt:
    
    SOUND
    
You should hear a series of sounds.



-------------------------------------------------
To test true color video modes
-------------------------------------------------

VideoSYNC runs fine on nearly every computer in 4, 8, 16 and 256
color modes.

For higher color modes (32768, 65536 and 16m color modes), the video
controller (chip or card) must support 15, 16 and 24 bits per pixel
(BPP) VESA modes, respectively.  Some computers now come with 32
bits per pixel which VideoSYNC does not support 32 BPP.

For most people, the 256 color modes are sufficient.  If you require
the higher resolutions (eg: you want to display multiple PCX images
simultaneously), you can test a particular computer to see which
video modes it will support by running VideoSYNC:

    vdosync -v >vsmodes.txt
    
The output in VSMODES.TXT is a table of the video modes that are
supported by VideoSYNC.  A YES in the "Avail" column indicates that
the mode is available.

One TEMPO user has reported that his Dell GX110 supports 24 BPP
modes using an ATI video controller on the motherboard.  But Dell
changes their computers so quickly that it is important to verify
with Dell that the video controller you will receive will support 24
BPP modes, if this is important to you.

-------------------------------------------------
PCX images and true color modes
-------------------------------------------------

Please note that even when 24 Bits Per Pixel (BPP) video modes are not
available, your video controller may support 16 BPP video modes.  In 16
BPP video modes, each pixel is stored in two bytes as 5:6:5 (5 bits for
red, 6 bits for green and 5 bits for blue).  In 24 BPP modes, each pixel
is stored in three bytes as 8:8:8.

PCX images are usually stored as 256 color images (6:6:6).  So when you
load a 256 color PCX file into VideoSYNC in a 16 BPP video mode, you
lose one bit of color depth for red and blue. This slightly reduced
color depth is difficult to observe and so some people are happy to use
the 16 BPP modes because it gives them more video pages than the 24 BPP
modes.

-------------------------------------------------
To test Mode X Video modes
-------------------------------------------------

We have recently observed (Jan 2001) that some of the ModeX video modes
are not fully supported by some video controllers.  So it is possible
that some of the modeX video modes that appear to be "available" are, in
fact, not available.

So we have a test program, MODEX.VS, which can be used to determine
if the video controller implements multiple video pages in a
particular video mode.  There are directions in MODEX.VS on how to
use it.


-------------------------------------------------
To test speaker
-------------------------------------------------

Every computer has a built in speaker which is normally used to
make the "Beep" tone when you make an error.  You can access the
speaker for tone generation with VideoSYNC.  The SPEAKER.BAT and
SPEAKER.WPL files can be used to test the speaker.  At the DOS
prompt, to test the speaker, type:

    SPEAKER



Other files
-----------

Use PKUNZIP to uncompress these files.

goldwave.zip    A shareware product for creating VOC sound files
sound.zip       A sample of VOC sound files; speaker tests
wav2voc.zip     Utilities for converting WAV to VOC and playing VOC files
tracking.zip    Utilities for checking vertical retrace tracking
wordlist.zip    Sample files for using wordlists (WD command)
images.zip      Sample PCX images and utilities


VDOSYNC\README.TXT
-------------------------------------------------------------------------
