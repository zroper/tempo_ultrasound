// PCX.PRO - Demonstrate display of PCX files with VideoSYNC
//
// This protocol requires that you load the REDBRAIN.PCX and MONKEY.PCX
// files on the VideoSYNC computer.
//
// In general, in order to display PCX images with VideoSYNC, VideoSYNC
// needs to be able to access them.  The VideoSYNC diskette can be used
// to transfer images to the VideoSYNC computer but there is limited
// space on the VideoSYNC diskette (about 300 kb).
//
// Here are several methods for providing PCX files to VideoSYNC.
// You need to decide which method is best for you.
//
// When the VideoSYNC computer boots with the VideoSYNC diskette,
// the boot sequence creates a 6 mb RAM drive and copies all the
// files on the VideoSYNC diskette into this RAM drive.
//
// NTFS partitions on the hard drive are not accessible but FAT32
// partitions on the hard drive are accessible by VideoSYNC.  They
// are automatically assigned drive letters by DOS.  It is also
// possible to configure VideoSYNC to access a CDROM and to access
// a network share on a remote computer.
//
// Here is a list of methods you can use for providing VideoSYNC
// access to PCX images.
// 
//
//      1. Include them on the VideoSYNC diskette
//         See SETUPTN's parameter for more information:
//
//              /VideoSYNC/Configuration/vsCdir=c:\vdosync
//  
//         The instructions below provide a step by step example
//         of this technique.
//
//
//      2. Create a FAT32 partition on VideoSYNC's hard drive
//         and copy the images to that partition.  In the IL
//         command, include the drive letter and path
//         to the PCX file.
//
//
//      3. Create a CDROM with your PCX files.  Configure
//         VideoSYNC to access the CDROM.  In the IL command
//         specify the drive letter of the CDROM.
//
//         For more information, see SETUPTN's parameter:
//
//              /VideoSYNC/Configuration/vscdrom
//
//
//      4. Install NetBEUI networking for VideoSYNC.  Create
//         a network share on a remote computer.  Have VideoSYNC
//         map that network share.  In the IL command, you
//         then specify VideoSYNC's drive letter for that
//         network share.
//         
//         For more information, see SETUPTN's parameter:
//
//              /VideoSYNC/Configuration/vsbat1
//              /VideoSYNC/Configuration/vsbat2
//              /VideoSYNC/Configuration/vsbat3
//              /VideoSYNC/Configuration/vsbat4
//              /VideoSYNC/Configuration/vsbat5
//              /VideoSYNC/Network/vsethernet
//
//
//
// Example of Technique #1:
//
// Here is one way to have SETUPTN copy the MONKEY.PCX and REDBRAIN.PCX files
// zipped to the VideoSYNC diskette.  This technique works only because
// IMAGES.ZIP is a small file and because there is enough
// room for it on the VideoSYNC diskette.
//
// Please do the following on the client computer:
// 
// 1. Create C:\VDOSYNC directory
// 
// 2. Extract from IMAGES.ZIP the MONKEY.PCX files from
//    \TEMPO\VDOSYNC\IMAGES.ZIP and copy MONKEY.PCX and REDBRAIN.PCX
//    files to C:\VDOSYNC directory.
//    
// 3. Run SETUPTN and set:
// 
//         /VideoSYNC/Configuration/vsCdir=c:\vdosync
//         
//    By setting this parameter, SETUPTN will create A:\USERS.ZIP
//    file by using PKZIP on the files in the C:\VDOSYNC
//    directory.
//    
//    It is important that USERS.ZIP be small enough to fit
//    on the VideoSYNC diskette or SETUPTN will fail to create
//    it when you remake the VideoSYNC diskette.  The VideoSYNC
//    diskette has approximately 300 kb available for USERS.ZIP.
//    
// 4. Remake the VideoSYNC diskette.  SETUPTN will create
//    the USERS.ZIP file on the diskette from the files
//    in C:\VDOSYNC (MONKEY.PCX and REDBRAIN.PCX).
// 
// 5. Now reboot the VideoSYNC computer with the new VS diskette.
//    The boot sequence will unzip USERS.ZIP so that the
//    MONKEY.PCX and REDBRAIN.PCX files are on the RAM drive
//    where VideoSYNC will look for them using the IL commands below.
//    
//    
// Now run TEMPOW and CLOAD PCX.PRO then START the clock.
// The MONKEY.PCX file should display on the VideoSYNC computer.
// When you move the TEMPONET server mouse, the image should move
// on the VideoSYNC computer.
//
//
// 01Apr09
//  NOTE that PCX.PRO uses the LM and PA commands.  Not all video
//  controllers support these low level hardware commands.  Because there
//  are no video standards, VideoSYNC can not determine if these features
//  are available so it assumes they are.  If they are unavailable, using
//  them can cause VideoSYNC to fail.
//
//  See MONKEY.PRO for displaying PCX images without using LM or PA.
//
//
// EDIT HISTORY
//
// 30Mar09 sh   Add documentation on how to provide VideoSYNC with
//              access to PCX images. 

declare MAIN();

process MAIN enabled
    {
    dsend("vi 261");                // 261=1024x768x256
    dsend("ca");                    // Clear all
    wait 5000;                      // Give VideoSYNC a chance to reset
    dsend("il 0,redbrain.pcx");     // image 0 
    dsend("ip 0,0,0");              // Display at (0,0)
    dsend("il 1,monkey.pcx");       // image 1
    dsend("ip 1,440,450");          // Display at (1,1)
    }

