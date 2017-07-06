/*  .title  TEXTFONT.PRO - VideoSYNC/WORDPLAY large TEXT font features
**
** DESCRIPTION
**
**  This protocol shows you how to use various features associated with
**  displaying large fonts.  Refer to your TEMPO Reference manual for
**  more information about how to set up VideoSYNC to display large fonts.
**
**  This protocol is written for VideoSYNC.  WORDPLAY also supports
**  the displaying of large fonts.  In order to use this protocol with
**  WORDPLAY, you will need to change all call to dsendf(..) to sendf(..).
**
**  The VideoSYNC command demonstrated here are:
**
**      TT font,text        Display large text using a specific font
**      TS xbox,ybox        Set size of a box used to display font
**      TC fore,back        Set foreground, background color of font
**
**  NOTE: The WD command is not demonstrated here.
**
**  To use this protocol, move mouse and left click to display text.
**  To change size, modify xbox & ybox and SPAWN SIZE.
**  To change color, modify fore & back and SPAWN COLORS.
**
**
** VIDEOSYNC/WORDPLAY
**
**  This protocol requires SETUPTN's VideoSYNC/WordList/vsfont0= be set to
**  an font file.  The ASCII.FON file comes with VideoSYNC (it is in WORDLIST.ZIP).
**
**  To install ASCII.FON, do the following:
**
**      1. Create a directory on your client C: drive and unzip
**         WORDLIST.ZIP into it.  For instance, in a Command Window, type:
**
**              mkdir c:\vdosync
**              cd \vdosync
**              pkunzip c:\tempo\vdosync\wordlist.zip
**
**         You should see the following files in C:\VDOSYNC:
**
**              ascii.fon            4,996  12:32.14 20Nov91 Archv
**              list0.wrd               69  13:10.03 15Nov94 Archv
**              list1.wrd               82  13:11.17 15Nov94 Archv
**              wordlist.wrd            74  10:47.25 24Sep97 Archv
**
**      2. Run SETUPTN and set the following parameters:
**
**              VideoSYNC/Configuration/vsCdir=c:\vdosync
**              VideoSYNC/WordList/vsfont0=ascii.fon
**              VideoSYNC/WordList/vsword0=wordlist.wrd
**              VideoSYNC/WordList/vsbox=2,2
**              VideoSYNC/WordList/vsfcolor=14,3
**
**         Then remake the VideoSYNC diskette.
**          
**      3. Boot the VideoSYNC computer with the newly made diskette.
**
**      4. Run TEMPOW, CLOAD the  TEXTFONT.PCF file and START the clock.
**
**
** EDIT HISTORY
**  05Sep97 sh  Initial edit
**  08Apr08 sh  Print the commands that are being sent.
**              Document how to set up ASCII.FON
**              Randomize x,y, box size, colors
*/

declare int font = 0;                   // Font number to display

declare int XMAX    = 1024;
declare int YMAX    = 768;

process MAIN enabled
    {
    dsendf("CL; VC 0,%d,0,%d\n", XMAX, YMAX);
    while (1)
        {
        wait 1000;

        dsendf("CL\n");
        spawn SIZE(2 + random(4), 2 + random(4));
        spawn COLORS(1 + random(14), random(15));
        spawn DRAW(random(XMAX - 64), random(YMAX - 64));
        nexttick;
        }
    }

process DRAW(int x, int y)
    {
    printf("MV %d,%d; TT %d,Tempo!\n", x, y, font);

    dsendf("mv %d,%d\n", x, y);         // Upper left corner of first character
    dsendf("tt %d,Tempo!\n", font);     // Display the text
    }

process SIZE(int xbox, int ybox)
    {
    printf("TS %d,%d..\n", xbox, ybox);
    dsendf("ts %d,%d\n", xbox, ybox);   // Note sizes are in virtual coordinates
    }

process COLORS(int fore, int back)
    {
    printf("TC %d,%d..\n", fore, back);
    dsendf("tc %d,%d\n", fore, back);   // Note fore/back are color indexes (0, 1, ..)
    }
