// VSRANDOM.PRO - Test random number generation on videoSYNC
//
// VideoSYNC has a random number generator which can be
// used in VideoSYNC expressions.  This protocol exercises these
// random() and seed() functions.
//
// What you should see on the VideoSYNC screen is a number of
// randomly positioned and colored boxes.  There should be no apparent
// pattern to them.
//
// VideoSYNC's random() function is a pseduo-random number generator
// that produces uniformly distributed random numbers from [0..n) where
// n is the argument to the random() function.
//
// VideoSYNC's internal random number generator uses a "seed" value to
// control the sequence of numbers it produces.  The Seed()
// function allows the user to a set different seed value at any time.
//
// Different seed values produce different sequences of random numbers.
//
// If you set the seed to the current time, the random sequence will
// vary each time the seed is set.  If you set the seeds to a constant
// or don't set them at all, the sequence of numbers produces by
// random() will be the same each time VideoSYNC is run.
//
// 03Apr08 sh   Initial edit


#pragma declare=1

declare MAIN();

// This protocol assumes a 256 color palette (ie mode 261).
// For true colors, generate random R,G,B values in the range [0..255]
    
int     XMAX = 1024;                    // VideoSYNC's # of pixels wide
int     YMAX = 768;                     // VideoSYNC's # of pixels high
int     NCOLORS = 256;                  // VideoSYNC's # of colors

int     nBoxes;                         // # of boxed drawn


//-------------------------------------------------------
process MAIN() enabled
{
    int     boxWidth = 20;              // Box width
    int     boxHeight = 20;             // Box height
    
    int     boxColor;                   // Box color
    int     boxX, boxY;                 // Box position

dsendf("cl\n");                         // Clear VideoSYNC's screen
wait 2000;                              // Give VS a chance to catch up

dsendf("vc 0,%d,0,%d\n", XMAX, YMAX);   // Set VideoSYNC's virtual coordinates

// The following is optional and sets the initial seed for VideoSYNC's random
// number generator.

dsendf("sv s1 = seed(%d)\n", timeUS()); // Initialize Seed for VS's random number generator


// Define a VS macro, BOX, which draws a box
// using our boxWidth and boxHeight.  The X,Y position and color
// are chosen randomly by VideoSYNC's random number generator.

dsendf("dm BOX()\n");
dsendf("    sv x = random(%d)\n", XMAX - boxWidth);    // [0..XMAX-boxWidth)
dsendf("    sv y = random(%d)\n", YMAX - boxHeight);   // [0..YMAX-boxHeight)
dsendf("    co random(%d)\n", NCOLORS);                // [0..NCOLORS)
dsendf("    rf x, y, x+%d, y+%d\n", boxWidth, boxHeight);
dsendf("em\n");


while (1)
    {
    // The size of the colored box is determined by our protocol's
    // boxWidth and boxHeight.
    //
    // The placement of the box on the VS screen is random in both X and Y.
    
        // Control position and color with the random() function
        // on the VideoSYNC computer.
        
    dsendf("xm box()\n");           // Draw a random box

    nBoxes = nBoxes + 1;

    printf("Box %d drawn by VideoSYNC\n", nBoxes);
    
    wait 100;
    }
}
















