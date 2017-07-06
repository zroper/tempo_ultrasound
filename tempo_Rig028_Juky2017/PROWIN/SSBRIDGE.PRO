/*  SSBRIDGE.PRO - Send commands to a Symphony Node
;+
; DESCRIPTION
;   This protocol example shows how to send command strings to a Symphony Node
;   from within a TEMPO protocol.
;
;   Please refer to the SSBRIDGE.C Symphony Node for more details.
;
; SEE ALSO
;   ssBridge.c, ssBridge.lc, exampleT.c, TEMPOW's SS Commands.
;
; EDIT HISTORY
;   25May07 sh  Initial edit
;-
*/
int hex    lcidHigh;
int hex    lcidLow;

int sHandle;                    // Symphony socket handle
int tgerr;                      // A TGERR_xxx status

declare int MAIN(), OPEN_CONNECTION(), SEND_MESSAGES(), CLOSE_CONNECTION();


//---------------------------------------------------
// MAIN - This is the main control flow for the protocol

process MAIN() enabled
{
while (1)
    {
    spawnwait OPEN_CONNECTION;
    if (sHandle > 0)
        {
        spawnwait SEND_MESSAGES;
        spawnwait CLOSE_CONNECTION;
        }
    }
}



//---------------------------------------------------
// OPEN_CONNECTION - Wait for our LCID then open a Symphony Socket

process OPEN_CONNECTION()
{
lcidHigh = 0;
lcidLow = 0;
printf("OPEN_CONNECTION: waiting for LCID from SSBRIDGE.C..\n");

while (!lcidHigh || !lcidLow) nexttick;

printf("OPEN_CONNECTION: LCID IS SET TO %x,%x\n", lcidHigh, lcidLow);

printf("OPEN_CONNECTION: Opening Symphony socket..\n");

systemf("ss open sHandle, %d, %d, SSBRIDGE\n", lcidHigh, lcidLow);
while (systemf()) nexttick;

if (sHandle <= 0)
    {
    printf("OPEN_CONNECTION: Error %d opening Symphony socket for LCID %x,%x\n", sHandle, lcidHigh, lcidLow);
    }
else
    {
    printf("OPEN_CONNECTION: Successfully opened Symphony socket handle %x\n", sHandle);
    }
}


    
//---------------------------------------------------
// SEND_MESSAGES - Send a bunch of messages to the node and check for errors.

process SEND_MESSAGES()
{
printf("SEND_MESSAGES: Sending strings to SSBRIDGE..\n");

systemf("ss send %d, 'test line 1'\n", sHandle);
systemf("ss send %d, 'test line 2'\n", sHandle);
systemf("ss send %d, 'test line 3'\n", sHandle);
while(systemf()) nexttick;

printf("SEND_MESSAGES: Strings have been sent.  Checking error status..\n");

tgerr = 0;
systemf("ss geterr %d, TGERR, tgerr\n", sHandle);
while(systemf()) nexttick;

if (tgerr)
    printf("SEND_MESSAGES: TGERR ERROR is %d\n", tgerr);
else
    printf("SEND_MESSAGES: Strings were sent successfully.\n");
}


//---------------------------------------------------
// CLOSE_CONNECTION - Close the Symphony Socket

process CLOSE_CONNECTION()
{        
printf("CLOSE_CONNECTION: Closing Symphony Socket..\n");
systemf("ss close %d\n", sHandle);
while(systemf()) nexttick;
sHandle = 0;
printf("CLOSE_CONNECTION: Symphony socket handle has been closed.\n");
}

