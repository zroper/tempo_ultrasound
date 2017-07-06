/* SPRITEPG.PRO - Display a sprite on different video pages
;+
; DESCRIPTION
;   This example protocol shows how to create a sprite then
;   display it on different video pages.
;
;   It provides an example of
;       - creating a sprite
;       - drawing on multiple video pages
;       - interaction between sprite drawing and page flipping
;       - use of RW and VP to draw on and view different video pages
;
;   Each video page is initialied with a green box in a slightly
;   different location.  Each page is displayed for a few seconds.
;
;   A red sprite (elipse) is created.  On each page, the sprite
;   is displayed and moved from the center of the green box in that page
;   towards the right until it is 1/2 way out of the green box.
;
;   Once this sequence is complete, use the following keys on
;   the client computer to view each video page:
;
;       F1      View previous page
;       F2      View next page
;
;   The sprite should end up on the last video page.
;
;   Thus, if you want to use sprites with multiple video pages, you
;   when you use RW to draw on a new video page, you should first
;   use OH to hide visible sprites.  This allows VideoSYNC to
;   restore the image under the sprite on the old video page.
;
;   Then use RW to change the drawing page.
;
;   Then use OS to restore the sprite(s) on the new video page.
;
; HARDWARE
;   This protocol assumes that the current Video mode supports 4
;   video pages.  If you have fewer video pages, change vs_kMaxPageNo
;   below.
;
;   It also assumes 256 color mode.
;
;   The recommended video mode to run this in is VIDEO=261.
;
; EDIT HISTORY
;   28Oct03 sh  Initial edit
;-
*/

int nPages = 4;                         // Total Number of VideoSYNC pages

int line = 0;                           // Y coordinate of next text line
int p;                                  // Current video page number


PROCESS TestPageFlipping() enabled
{

dsendf("ca\n");                         // Start from scratch
wait(8000);                             // Give VideoSYNC time to do CA

// This code draws a rectangle in different positions on each of the video pages.
// Tests drawing on all pages.

line = 0;                               // Line to display text on each page
p = 0;
while (p < nPages)
    {
    dsendf("rw %d,%d\n", p, p);         // Set drawing page
    dsendf("cl\n");                     // Clear drawing page

    dsendf("co %d\n", 10);              // Set drawing color to light green
    
    x = 100 + p * 30;
    y = 100 + p * 30;                   // location of box
    dsendf("rf %d,%d,%d,%d\n", x, y, x+50, y+50);       // Draw box

    dsendf("co 15; mv 0,%d; tx PAGE %d;\n", line, p);   // Draw text
    p = p + 1;                          // next page
    }

line = line + 15;                       // Text will go on next line

while (dsendf()) nexttick;              // Wait till all commands have been sent


// This code displays each video page one by one to confirm that:
//
//    1. draw on any video page.
//    2. display any video page.

p = 0;
while (p < nPages)
    {
    dsendf("rw %d,%d\n", p, p);         // Set drawing page
    dsendf("co 15; mv 0, %d; tx Page %d: display all pages - rectangle should move.;\n", line, p);
    
    dsendf("vp %d\n", p);               // Display video page p
    wait 2000;                          // Give user a chance to view the pages
    p = p + 1;                          // next page
    }
line = line + 15;                       // All text on next line of each page

// Create the sprite

dsendf("oc 0, 5\n");                    // elipse
dsendf("ow 0, 20, 20\n");               // size
dsendf("oi 0, 12\n");                   // light red
dsendf("of 0\n");                       // filled

// Uncomment out the following line to see the difference between XOR and REPLACE
// drawing mode for sprites.

//dsendf("ol 0, 3\n");                  // Set draw logic: 0=replace, 3=xor

p = 0;                                  // Loop thru video pages.
while (p < nPages)
    {
    dsendf("oh 0\n");                   // Hide sprite before changing drawing page
                                        // This allows the sprite to be erased, if visible,
                                        // on the previous page it was drawn on.
    
    dsendf("rw %d,%d\n", p, p);         // Set drawing page
    dsendf("co15; mv 0, %d; tx Page %d: drawing sprite;\n", line, p);
    
    dsendf("vp %d\n", p);               // Display video page p

    // Move sprite to center of rectangle on current drawing page and show it.
    
    x = 100 + p * 30;                   // Upper left corner of box
    y = 100 + p * 30;
    
    // At the beginning of this loop, the sprite is hidden.
    // In the first iteration, we set its location then show it.
    // It will remain visible until it is hidden (just before we
    // 
    
    i = 0;
    while (i < 10)                      // Loop to move the sprite
        {
        dsendf("om 0,%d,%d\n",          // Position sprite at new location
             x + 10, y + 10);           // ..inside box

        if (i == 0)
            dsendf("os 0\n");           // Show sprite first time
                                        // It will be shown on the current
                                        // drawing page.
            
        x = x + 4;                      // Move it to the right a little
        wait 250;                       // not too fast
        i = i + 1;
        }

    // Wait so user can observe change then increment loop counter.

    wait 2000;                          // Give the user time to look at the page
    p = p + 1;
    }
line = line + 15;                   // All text on next line of each page

// We're done.  Remind the user that they can use F1 and F2 to
// flip through the video pages.
    
printf("Use the F1 (page up) and F2 (page down) keys on the client to view each video page.\n");
}

//---------------------------------------------
// Display Previous Video Page.
// This is spawned when the user types the F1 key

process PgUp()
{
p = p - 1;
if (p < 0)
    p = 0;
else if (p > nPages - 1)
    p = nPages - 1;
    
dsendf("vp %d\n", p);
}

//---------------------------------------------
// Display Next Video Page.
// This is spawned when the user types the F2 key

process PgDn()
{
p = p + 1;
if (p < 0)
    p = 0;
else if (p > nPages - 1)
    p = nPages - 1;
    
dsendf("vp %d\n", p);
}
