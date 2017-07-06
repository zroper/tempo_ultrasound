// DELAY.PRO - Test Delay process which waits for a number of uSec
// Demonstrates how to toggle a TTL for a short period of time,
// (ie a few microseconds).

#include    DIO.PRO

int usec = 100;

process MAIN enabled
{
dioSetMode(0, PORTA | PORTB | PORTC);   // Set all ports to output 

while (1)
    {
    wait 1000;
    
    dioSetA(0, 0x1);
    
    spawn delay(usec);
    waitforprocess delay;
    
    //spawn delay(usec);
    //waitforprocess delay;
    
    dioSetA(0, 0x0);
    
    wait 1000;
    }
}

process Delay(int uSeconds)
        {
        int start, duration;
        int ticks;

        ticks = uSeconds * 1.193180;     // Convert uSec to 1193180 Hz ticks
        start = timeus();
        duration = 0;
        while (duration < ticks)
                {
                duration = (timeus() - start) & 0xFFFF;
                }
        printf("duration=%d ticks=%d\n", duration, ticks);
        }

