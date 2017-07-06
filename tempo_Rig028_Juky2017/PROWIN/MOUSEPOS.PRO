// MOUSEPOS.PRO - Test new mouse functions
//
// SYNOPSIS
//  The new mouse driver functions tested are mouGetDriverX(), mouGetDriverY(),
//  and mouSetDriverLimits().
//
//  These functions may be a useful alternative to using the mouGetX() and
//  mouGetY() which utilize the mouse driver's call to get the change in mickeys
//  since the previous call.
//
//  These new functions return the mouse driver's internal X,Y and set the internal
//  mouse driver's limits.  The range of values within the mouse driver is driver
//  dependent.  For the Microsoft Mouse driver, X is 0-632 and Y is 0-192 and the
//  mouSetDriverLimits() function doesn't appear to work properly.
//
// DIRECTIONS
//      0. Restart server & client
//
//      1. CLOAD this protocol
//         START the clock
//
//      2. Move mouse to upper left and lower right most position to obtain
//         current xmin,xmax and ymin,ymax values in the driver.  These are
//         the driver's default values.
//
//          driverX, driverY contains the mouse driver's X,Y mouse position.
//          tempoX,tempoY contain TEMPO's mouse position.
//
//      3. Set desired limits at TEMPO command line.  For example
//              xmin = -2047
//              xmax = 2048
//              ymin = -2047
//              ymax = 2048
//         SPAWN LIMITS  (set new limits)
//
//      4. Repeat step 3 to verify that the mouse driver is capable of
//         handling the new limits
//
// EDIT HISTORY
//  29Aug02 sh  Initial edit

#pragma declare = 1                 // Force strong checking

int tempoX, tempoY, driverX, driverY;

int xmin = -2047, xmax = 2048, ymin = -2047, ymax = 2048;

declare  MAIN(), LIMITS();


//--------------------------------------------------------------------
process MAIN() enabled
{
while (1)
    {
    tempoX = mouGetX();                 // TEMPO's mouse X position
    tempoY = mouGetY();                 // TEMPO's mouse Y position
    driverX = mouGetDriverX();          // Driver's mouse X position
    driverY = mouGetDriverY();          // Driver's mouse Y position
    nexttick;
    }
}

//--------------------------------------------------------------------
// After setting the limits on the TEMPO command line, spawn this process.
// In general, the limits must be within 16 signed bits.

process LIMITS()
{
    int     err;
    
err = mouSetDriverLimits(xmin, xmax, ymin, ymax);
printf("Limits set X:%d to %d Y:%d to %d  status %d\n", xmin, xmax, ymin, ymax, err);
}

//--------------------------------------------------------------------
process RESET
{
mouResetDriver();
}

