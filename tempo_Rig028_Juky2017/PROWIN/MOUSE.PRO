// MOUSE.PRO
// This protocol demonstrates how to use PCL's mouse functions.  These
// functions require that you include MOUSE=yes in your KERNEL configuration
// file.
//
// TEMPO's animated object windows are used to show mouse position.
// VideoSYNC's sprites are also used to show mouse position on VideoSYNC's
// screen.  The sprite changes colors periodically (just for fun).
//
// Pressing the left mouse button hides the VideoSYNC sprite.  
// Pressing the right mouse button fills the VideoSYNC sprite.
// Pressing both mouse buttons tells VideoSYNC to display video timing
// information.
//
// When used with KDEMO, it collects data from analog channels 1 & 2
// to show that mouse activity is loaded into these channels.  To enable
// this, include MOUSE2ANALOG=yes in the your KERNEL configuration file.

#include object.pro

constant sprites = 1;                   // Set to 0 to disable sprites
constant mouse_sensitivity = 2000;      // 1000 is 1-1
constant maxcolor = 255;                // Maximum color index

process COLLECT enabled                 // Collect data in the background
    {
    while (1)
        {
        wait    1000;
        trigger 1;
        count = count + 1;
        if (count > 20)
            {
            count = 0;
            system("hzero *");
            wait 5000;
            }
        }
    }

process TRACKER enabled
    {
    oSetGraph(gLEFT, aRANGE, -2048, 2047, -2048, 2047);
    oMouse = oCREATE(tBOX, gLEFT, 100, 100);
    oSETATTRIBUTE(oMouse, aVISIBLE);

    if (sprites)
        {
        send("ca");
        send("vc -2048,2047,-2048,2047");
        send("oc 0,1");                     // Create box for object 0
        sendf("oi 0,%d\n", maxcolor);       // Set color WHITE
        send("ow 0,100,100");               // Set object width, height

        send("os 0");                       // show it
        }

    mouSetXY(0,0);                          // Put cursor in center
    mouSetMickeys(mouse_sensitivity);       // Adjust mouse sensitivity

    while (1)
        {
        x = mouGetX();
        y = mouGetY();
        buttons = mouGetButtons();
        if (buttons != prev_buttons) // buttons changed?
            {
            printf("Buttons = 0x%x\n", buttons);
            if (sprites)
                {
                if (buttons & 1)
                    send("oh 0");           // Hide object
                else
                    send("os 0");           // Show object
                
                if (buttons & 2)
                    send("of 0");           // Fill object
                else
                    send("OU 0");           // Object is unfilled
                
                if ((buttons & 3) == 3)
                    {
                    send("OH *");
                    send("WT 2");
                    send("CL");
                    send("O? 0");           // Display object info
                    send("OS *");
                    }
                }
            prev_buttons = buttons;
            }
        oMOVE(oMouse, x, y);
        if (prevx != x || prevy != y)
            {
            if (sprites)
                sendf("om 0,%d,%d\n", x, y);    // Move object
            prevx = x;
            prevy = y;
            }
        nexttick;
        }
    }

process COLORS
    {
    while (sprites)
        {
        wait  random(15000);
        color = random(maxcolor) + 1;
        sendf("oi 0,%d\n", color);
        }
    }
