/* SOUND.PRO - Example of VideoSYNC's Sound Functions
**
** Synopsis
**  This protocol demonstrates:
**
**      o Use of VideoSYNC's sound commands (AV, AS, AP, AQ, AX)
**      o Sprite update on VideoSYNC's screen ("connected" to mouse)
**      o Several VOC sound files loaded on the VideoSYNC computer
**      o PCL's mouse functions (mouGetX, mouGetY, mouGetButtons)
**      o Use of mouse buttons (mouGetButtons)
**      o Sound played in the background (VideoSYNC continues to
**        update the sprite while sounds are being played)
**
** Requirements:    
**  VideoSYNC with sound card (SOUND=10 in VideoSYNC cfg file).
**  Various VOC sound files on VideoSYNC computer.
**  Mouse on TEMPO computer (MOUSE=yes in KERNEL cfg file).
**
** Edit History
**  28 Oct 94 sh    Initial edit
*/

DECLARE s;                              // Current sound (=0..NSOUND-1)
DECLARE loops;                          // # of times to play sound (0=infinite)

process main enabled
    {
    if (!initialized)
        {
        spawn   INIT;
        while   (!initialized) nexttick;
        }

    print("Testing PLAY, PAUSE and CONTINUE functions");
    s = 0;                              // Start with this sound
    loops = 0;                          // Infinite looping
    spawn   PLAY;

    wait    200;
    spawn   PAUSE;                      // Cut off in midstream

    wait    2000;
    spawn   CONTINUE;                   // Resume from cutoff

    wait    1000;
    spawn   QUIT;                       // Cut off for good

    print();                            // Clear TEMPO messages
    print("Test Complete.");
    print("Current sound = Left mouse button");
    print("Next sound    = Right mouse button");
    print("Sprite updated with mouse movement");
    loops = 1;                          // Only play once
    spawn   MOVER;
    }

process INIT                            // Load sound files
    {
    initialized = 0;
    dsend("ca");                         // Clear all
    dsend("vc -2048,2048,-2048,2048");   // Virtual coordinates
    dsend("oc 0,1");                     // Create box sprite
    dsend("ow 0,100,100");                 // sprite width, height
    dsend("oi 0,15");                    // sprite color (white=15)
    dsend("of 0");                       // filled

    dsend("AX *");                       // Clear memory allocated for sounds
    dsend("AV 0,hello.voc");             // Load VOC sound files
    dsend("AV 1,brawk.voc");
    dsend("AV 2,whistle.voc");
    dsend("AV 3,charge.voc");
    dsend("AV 4,porky.voc");
    NSOUNDS = 5;

    wait    1000;                       // Give disk a chance to finish
    print("Initialization complete.");
    initialized = 1;
    }

process PLAY
    {
    print("Playing sound ", s);
    dsendf("AS %d,%d\n", s, loops);
    }

process PAUSE
    {
    print("Pausing..");
    dsend("AP");
    }

process CONTINUE
    {
    print("Continuing..");
    dsend("AC");
    }

process QUIT
    {
    print("Stopping sound.");
    dsend("AQ");
    }

process MOVER                           // Move mouse around screen
    {
    DECLARE old_buttons, buttons;

    mouSetXY(0, 0);
    dsend("om 0,0");
    dsend("os 0");                       // show on screen
    while (1)
        {
        buttons = mouGetButtons();
        if (buttons != old_buttons)
            {
            if (buttons & 01)
                spawn PLAY;             // Left button Play last sound
            if (buttons & 02)
                {
                s = (s + 1) % NSOUNDS;  // Right button: Play next sound
                spawn PLAY;
                }
            old_buttons = buttons;
            }

        x = mouGetX();
        y = mouGetY();
        dsendf("om 0,%d,%d\n", x, y);
        wait    20;
        }
    }
