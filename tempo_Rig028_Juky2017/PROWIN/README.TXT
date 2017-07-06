                        TEMPO/Win Sample Protocols
                                July 2001    

The TEMPO\PROWIN directory contains sample protocols that are written
for TEMPO/Win.

The .PRO file contains the behavioral part of the protocol, written
in the PCL language.  The .PCF file is the TEMPO/Win protocol
configuration file for the protocol.  The .PCF file is created by
TEMPO/Win with the CSAVE command.  The protocol is loaded by using
CLOAD to load the .PCF file.

Some of these protocols were converted from TEMPO/Dos and have a
.CFG file which is the protocol configuration file for TEMPO/Dos.
The .CFG file is not used by TEMPO/Win and is provided for the
convenience of TEMPO/Dos users.

Protocol File           Description
--------------          ----------------------------------------------------------
acquire.pro             Excellent example of a complete protocol
bigger.pro              Change size of Animated Graph objects             
bothcom.pro             How to use both serial ports
bounce.pro              Bounces a rectangle on Wordplay by redrawing
bounce1.pro             Bounces a rectangle on Wordplay by page flipping
catmouse.pro            Simple moving of objects on VideoSYNC and Animated Graphs
checker.pro             Alternate a checkboard using page flipping
ciotest.pro             Basic tests for CIO-DAS08 (KCD) kernel
cosine.pro              Example of using PCL arrays to compute sine/cosine
d1600.pro               Basic tests for CIO-DAS1602 (KBTD) kernel
d6400.pro               Basic tests for kernels with cio-das6402 board
dactest.pro             Basic analog output tests for kernels with cio-DAS16/12 boards
demo.pro                Simple bar-press protocol
dim.pro                 DIM task (unstabilized stimulus) simple version
dim5.pro                DIM task (unstabilized stimulus) more complex
dimcal.pro              DIM task (retina stabilization) with calibration
diotest.pro             Basic examples of using digital (DIO) PCL functions
eight.pro               Simple example of presenting eight targets
example.pro             Simple, complete protocol example
eyecal.pro              Eye coil calibration
eyecalm.pro             Calibration parameters for EYECAL.PRO
fieldmap.pro            Receptive field mapping with VideoSYNC
grate.pro               Vertical grating with horizontal pan (example 2)
grate1.pro              Vertical grating with horizontal pan (example 1)
grateup.pro             Horizontal grating with vertical pan
grow.pro                Changing size of Animated Graph objects
hopen.pro               How to create databases from within your protocol
journal.pro             How to write messages to a text file
learn.pro               Example protocol that adapts parameters to subject
match.pro               Simple match to sample task
match1.pro              Event definitions for MATCH.PRO
miotest.pro             Basic tests for KERNELs that use the AT-MIO16 board
mouse.pro               How to use PCL's mouse functions
p16.pro                 Basic tests for kernels with PCI-DAS1602 board
pcx.pro                 How to display PCX images on VideoSYNC
pcxflip.pro             How to page flip multiple PCX images
portio.pro              How to write bytes to printer port
recorder.pro            How to stream data to disk
sequence.pro            A simple sequence task
sound.pro               How to use VideoSYNC's sound functions
spike2.pro              How to trigger a database from an external TTL
sqrt.pro                How to calculate square root with an array
stable.pro              DIM task with retina stabilization
stream.pro              How to stream data to disk
testfile.pro            How to determine if a file exists from within your protocol.
textfont.pro            How to display large fonts & icons with VideoSYNC
visual0.pro             How to move Animated objects based on analog inputs
visual1.pro             Moving Animated objects based on analog inputs (more complex)
voice.pro               How to collect voice data from analog inputs
vsbounce.pro            Bouncing a sprite on VideoSYNC
vsmacro.pro             Example of VideoSYNC macros for smooth pursuit tasks
vspursue.pro            A simple smooth pursuit task
vstest1.pro             Controlling a VideoSYNC cursor from a protocol #1
vstest2.pro             Controlling a VideoSYNC cursor from a protocol #2
vstest3.pro             Two moving cursors, one is the controlled by mouse
vswordep.pro            Word evoked potentials protocol
