// TESTFILE.PRO - Test if a file exists.
// REQUIRES TESTFILE.BAT:
//
// if exist %1 goto EXISTS
// echo fileExists=0 >TESTFILE.TPO
// goto EXIT
// 
// :EXISTS
// echo fileExists=1 >TESTFILE.TPO
// :EXIT
//
// This protocol checks if a file, TEST.HTB, exists.
// It does this by running the TESTFILE.BAT file.
// TESTFILE.BAT checks for the file and writes one
// line to TESTFILE.TPO.  TESTFILE.PRO then "executes"
// the TESTFILE.TPO command fine which sets/clears
// the fileExists protocol variable.

declare fileExists = 0;                 // Set by TESTFILE.TPO
                                        // 0= file doesn't exist
                                        // 1= file does exist

process TestFile enabled
{
fileExists = 0;                         // Assume it doesn't exist
systemf("dosx TESTFILE.BAT TEST.HTB\n");
systemf("cmd TESTFILE.TPO\n");
while(system()) nexttick;               // Wait for commands to finish

if (fileExists)
    printf("TEST.HTB exists\n");
else
    printf("TEST.HTB does not exist\n");

}

