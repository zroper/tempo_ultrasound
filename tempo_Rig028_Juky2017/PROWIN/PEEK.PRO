// PEEK.PRO - Test peek/poke PCL functions

constant int system_timer = 0x0040006C;

process MAIN enabled
{
    int ticks, seconds, hour, minute, second;

i = 0;    
while (i < 10)
    {
    wait 1000;
    ticks = peek32(system_timer);
    tick8 = peek8(system_timer + 2);
    tick16 = peek16(system_timer + 1);
    
    seconds = ticks / (1193180.0 / 65536);
    hour = (seconds) / (60 * 60);
    minute = ((seconds) / 60) % 60;
    second = seconds % 60;
    printf("Seconds=%d  %02d:%02d.%02d    tick32=%x tick16=%x tick8=%x\n",
        seconds, hour, minute, second,
        ticks, tick16, tick8);
    i = i + 1;
    }
    
//ticks = peek32(system_timer);
//
//poke32(system_timer, 0x66543321);
//printf("prev=%x  poke32=%x\n", ticks, peek32(system_timer));    
//
//poke16(system_timer, 0x12345252);
//printf("prev=%x  poke16=%x\n", ticks, peek32(system_timer));
//
//
//poke8(system_timer, 0x37474313);
//printf("prev=%x  poke=%x\n", ticks, peek32(system_timer));    
//
//
//poke32(system_timer, ticks);
//printf("Corrected=%x\n", peek32(system_timer));
//
//printf("CMD returned.\n");
}