// SBLIVE.PRO
// 24Nov04 Test program for VideoSYNC with SoundBlaster Live 5.1 sound board.
//         It plays several test sound files while drawing random elipses on the screen.
//
// NOTE: Since the Create Lab drivers are too big to fit onto a diskette,
//       they must be stored on the hard drive or CDROM on the VideoSYNC
//       computer.
//
// NOTE: Creative Lab's drivers misbehave when network drivers are loaded.
//       So you should not enable network access and use sound.
//       (You can create two different TN configurations and two
//       VideoSYNC diskettes, one with networking and one with sound).
//
//       Also, on some computers, the sound drivers may conflict with the
//       CDROM driver. So if you have sound (.VOC) or image (.PCX) files
//       that you want to use with VideoSYNC, we recommend that you create
//       a FAT16 partition (for PC-DOS200) or FAT16 or FAT32 (for Win98)
//       on your hard drive and store the files there.
//
// Before using this protocol, these are required:
//
//  0. SETUPTN version 4.04 or later (version bottom left of COMPONENTS dialog)
//
//  1.  C:\SBLIVE on the VideoSYNC computer contain the contents
//      of the SBLIVE.ZIP file.
//      Please request this file from Reflective Computing.
//
//      On the VideoSYNC compouter, you must install a Creative Lab's
//      SoundBlaster Live 5.1 PCI board (Model SB0060US).
//
//  2. In SETUPTN, set the following parameter
//
//      VideoSYNC/Configuration/vsbat1=call c:\sblive\blaster
//
//     This causes the VideoSYNC diskette to load the sound driver
//     when it boots the VideoSYNC computer.
//
//  3. Remake your VideoSYNC diskette.
//
//  4. Boot the VideoSYNC computer with the newly made diskette.
//     You should see the sound driver load and PAUSE after displaying
//     sound driver details.  Press SPACE to continue.  VideoSYNC should
//     start.
//
//  5. CLOAD this protocol and START the clock.  Click the PLAY SOUND
//     button in the MAIN dialog.
//
// In general, you should leave the SBLIVE directory "virgin" (don't
// change anything.
//
// Please put your VOC sound files into another directory.

process MAIN() enabled
{
system("dialog MAIN");
dsendf("cl\n");
dsendf("mv 0,0\n");
dsendf("co 255\n");                         // White
dsendf("rf 100,100,200,200\n");
dsendf("tx Loading Sounds..\n");
dsendf("av 0,c:\\sblive\\charge.voc\n");
dsendf("av 1,c:\\sblive\\monkey.voc\n");
dsendf("av 2,c:\\sblive\\hello.voc\n");
dsendf("av 3,c:\\sblive\\whistle.voc\n");
dsendf("av 4,c:\\sblive\\brawk.voc\n");
dsendf("av 5,c:\\sblive\\porky.voc\n");
spawn RANDOMBOX();
spawn PLAY();
}

process PLAY()
{
printf("playing sounds..\n");
dsendf("tx playing sounds.. \n");
dsendf("as 0\n");
wait 1500;
dsendf("as 1\n");
wait 1500;
dsendf("as 2\n");
wait 1500;
dsendf("as 3\n");
wait 1500;
dsendf("as 4\n");
wait 1500;
dsendf("as 5\n");
}


// Assume VIDEO=261 (1024x768 x 256 colors)
// Draw while playing sounds.

process RANDOMBOX()
{
while (1)
    {
    x = random(1024);           // Assumed X and Y resolution on VideoSYNC
    y = random(768);
    dsendf("co %d\n", random(255) + 1);
    dsendf("ef %d,%d,%d,%d\n", x, y, x % 40 + 1, y % 30 + 1);
    wait 250;
    }
}