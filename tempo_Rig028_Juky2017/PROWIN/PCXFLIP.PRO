/*  PCXFLIP.PRO - Demonstrate video page flipping with multiple PCX images
**  
**  SYNOPSIS
**  
**  This protocol demonstrates how to display multiple PCX images
**  quickly with VideoSYNC.  VideoSYNC is set to video mode 274
**  (640x480x16m) true color mode.  We then load IMAGE1.PCX and
**  IMAGE2.PCX (256 color images) using the IL command.  Then we use the
**  RW command to copy them to the video page 1 while video page 0 is
**  displayed (empty screen) to the subject.
**  
**  In a single vertical refresh, we use the VP command to "flip" video
**  pages so that video page 1 is displayed.  This presents the two
**  images (using their original colors) in a single vertical retrace.
**  
**  Note that two different 256 color PCX images are displayed
**  simultaneously. This is possible only in "true color" (16M color)
**  modes.  By using a true color mode, you avoid the difficulties
**  of presenting multiple 16-color or 256-color images simultaneously
**  where each image has a its own, unique color palette.  With true
**  color modes, no color palette mapping is required because each
**  pixel in video ram holds the RGB values (instead of using the hardware
**  color palette to hold RGB values, as is done with 16 and 256 color modes).
**  
**  FAST PRESENTATION OF IMAGES
**  
**  The key to displaying images quickly (without having the subject see
**  the drawing operation) is 
**  
**      1. preload all the images from disk.  This can take some time
**         due to disk latencies, the size of the images and the CPU
**         speed.  Use the IL command to preload images from disk to
**         CPU ram.
**  
**      2. copy images to an unseen video page.  This can take some
**         time depending on the speed of the CPU, video ram and the
**         size of the image.  Use the RW command to select which
**         video page you want to draw to.  The drawing takes place
**         while the subject views a different page so the subject
**         does not see the drawing of the image.
**         
**      3. present the image(s) in a single retrace with the VP command.
**  
**  REQUIREMENTS
**  
**  1. This protocol requires that the video card on the VideoSYNC
**  computer have enough video ram to support two video pages in the
**  selected video mode.
**  
**  2. It also requires that the video card support "true color" (16 M
**  color) mode 274.
**  
**  3. The IMAGE1.PCX and IMAGE2.PCX files must be on the VideoSYNC
**  computer in the directory in which VideoSYNC was started.
**  
**  WIRING
**  
**  This protocol requires VideoSYNC to be running and connected to
**  the server computer via the RDX cable.
**
**  SEE ALSO
**
**  The PCXFLIP.VS contains a VideoSYNC command file that does a similar
**  thing as this protocol.
**
**  To use this protocol with WORDPLAY, change all "dsend(" to "send("
**  and all "dsendf(" to "sendf(".
**  
**  EDIT HISTORY
**  
**  19Apr00 sh  Initial edit
*/

#pragma declare=1                       // Force diligence in declarations

process MAIN enabled
{
// Set VideoSYNC video mode to a true color mode and reset all setting
// This can take a little while to do so we wait a few seconds.
// If you set VIDEO=274 in your VS.CFG file, you can skip this step.

dsend("vi 274; ca");                    // Set video mode and reset VideoSYNC
wait 5000;                              // Wait for CA to complete

// Load images from disk into VideoSYNC memory
// Loading images from disk can take some time (longer than a single vertical
// retrace) due to disk latency.  The size of the image also affects load time.
// The smaller the image, the faster it will load.
// Load times can also depend on the speed of the CPU.

dsend("il 1,image1.pcx");               // Load IMAGE1.PCX from disk to VideoSYNC memory
dsend("il 2,image2.pcx");               // Load IMAGE2.PCX from disk to VideoSYNC memory

// Now load the video ram pages with the images we want.
// Write to video page 1 while the subject views video page 0 (default).
// Depending on the size and resolution of the images, copying images
// to video ram can take some time (longer than a single vertical retrace).
// The smaller the image, the faster it will copy.
// Copy times can also depend on the speed of the CPU.

dsend("rw 1,1");                        // Write to video page 1
dsend("ip 1,0,0");                      // Copy IMAGE1 to (0,0) in video ram
dsend("ip 2,160,100");                  // Copy IMAGE2 to (160,100) in video ram

// Reset drawing operations to write to video page 0

dsend("rw 0,0");                        // Set read-write page to video page 0

// Alternate display of video pages to show how quickly the images can
// be presented to the subject.

while (1)
    {
    print("Displaying images..");
    dsend("vp 1");                      // Display video page 1 (with images)
    wait 1000;                          // Wait (in ms)
    
    print("Displaying blank screen..");
    dsend("vp 0");                      // Display video page 0 (blank page)
    wait 1000;                          // Wait (in ms)
    }
}