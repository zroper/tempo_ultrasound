// RDXTTL.PRO - Demonstrate use of some of the RDX TTL capabilities
//
// SYNOPSIS
//
//  This sample protocol demonstrates how to use the RDX TTL bits
//  so that VideoSYNC can tell the protocol when it has completed
//  execution of the commands that have been sent to VideoSYNC.
//
// WIRING
//  This protocol assumes you have VideoSYNC running.
//
// EDIT HISTORY
//  28Jun03 sh  Initial Edit
//  18Jun05 sh  Enhance documentation
//
// DESCRIPTION
//
// The RDX Communication link supports four TTL bits between the
// TEMPO Server and the VideoSYNC computer.  Two TTL bits are from TEMPO
// Server to VideoSYNC and two TTL bits are from VideoSYNC back to TEMPO
// Server.
//
//          TEMPO Server               VideoSYNC
//          -----------------        -------------
//          rdxSetTTLOut()  --------> rdxGetTTLIn()
//          rdxSetTTLOut2() --------> rdxGetTTLIn()
//
//          rdxGetTTLIn()   <-------- SO command
//          rdxGetTTLIn2()  <-------- SO command
//
// These four TTLs can be use to synchronize TEMPO and VideoSYNC.  For
// example, after VideoSYNC executes a command sequence, it can toggle
// (change state; 0->1 or 1->0) a TTL bit.  The protocol then knows
// that when the state changes, VideoSYNC has completed execution
// of the command sequence.
//
// Since VideoSYNC can wait for a vertical retrace (with the VW command),
// VideoSYNC can effective signal to the TEMPO protocol the time of the
// vertical retrace by executing a VW command followed by an SO command.
//
// This technique also be used with page flipping (see VP command) to
// have VideoSYNC inform the protocol when a video page is being
// displayed.
//
// The PCL functions related to getting and setting these RDX TLL bits
// are:
//
//   n = rdxGetTTLIN();                    Get RDX TEMPO Server's TTL IN bit0
//   n = rdxSetTTLOUT(n);                  Set RDX TEMPO Server's TTL OUT bit0
//   n = rdxGetTTLOUT();                   Get RDX TEMPO Server's TTL OUT bit0
//
//   n = rdxGetTTLIN2();                   Get TEMPO Server's RDX TTL IN bit1
//   n = rdxSetTTLOUT2(n);                 Set TEMPO Server's RDX TTL OUT bit1
//   n = rdxGetTTLOUT2();                  Get TEMPO Server's RDX TTL OUT bit1
//
//
// VideoSYNC also provides full support (input/output capability) for the
// four RDX TTL bits.
//
// The SO command sets VideoSYNC's two RDX TTL output bits.  The
// rdxGetTTLIN() and rdxGetTTLOUT() VideoSYNC functions are used
// in VideoSYNC expressions to retrieve VideoSYNC's RDX TTL bits.
//
// See the VideoSYNC Chapter in the TEMPO Reference Manual for more
// information on how to use the SO command and VideoSYNC expressions
// and functions.
//
// In this protocol example, we use both RDX TTL bits from VideoSYNC
// to the TEMPO server.  The WaitForVideoSYNC() process below is
// designed to make it easy for you to copy it and use it in your protocols.
//
// The comments for that process describe some ways you can enhance
// the WaitForVideoSYNC process.
//
// In this protocol, we access the RDX TTL bits from the TEMPO server to
// VideoSYNC only to show how they are accessed in PCL.  But we do
// not do anything with those bits on the VideoSYNC side (ie: we don't
// show here the use of VideoSYNC's rdxGetTTLIN() and rdxGetTTLOUT()
// functions.  However, it should be clear that the two TTL bits from
// TEMPO Server to VideoSYNC can be used to communicate to VideoSYNC
// when to start executing a command sequence (i.e., VideoSYNC can wait
// for the bits to change with a WH statement then perform a sequence
// of commands).
//
//-----------------------------------------------------------------------


declare MAIN(), DRAW(), WaitForVideoSYNC();

declare constant int SIZE = 20;     // Size of each box

declare int DELAY = 0;              // # of ms between commands


//-----------------------------------------------------------------------
process MAIN() enabled
{
    int     TTLOUTnew;

DELAY = mspercycle();               // Default to one process cycle

dsend("cl");                        // Clear screen
spawn DRAW();                       // Start drawing

// Load RDX TTLs into protocol variables and keep changing
// the RDX TTL outputs from the server to VideoSYNC.  We don't
// have VideoSYNC do anything with these bits in this protocol.
//
// With the SHOW V status page, you can see the values of these
// variables.
    
TTLOUTnew = 0;
while (1)
    {
    TTLOUTnew = (TTLOUTnew + 1) & 0x3;  
    rdxSetTTLOUT(TTLOUTnew);
    
    TTLOUT = rdxGetTTLOUT();        // Gets our RDX TTL output bits
    TTLIN = rdxGetTTLIN();          // Gets our RDX TTL input bits
    
    nexttick;
    }
}


//-----------------------------------------------------------------------
// Process DRAW - draw boxes on the VideoSYNC screen as fast as it can draw.
// Have VideoSYNC use the RDX TTL bits to tell the protocol when it has
// completed a draw operation.  In this way, VideoSYNC paces the TEMPO
// protocol's sending of more commands.

process DRAW()
{
    int     x, y;
    
nRDXOutputBufMax = 0;                   // Reset

while (1)
    {
    x = x + 2 * (SIZE+2);
    if (x > 1000)
        {
        x = 0;
        y = y + 2 * (SIZE+2);
        
        if (y > 700)
            {
            y = 0;
            //dsend("cl");
            }
        }
        
    // Set current color to a random value
    // then draw inner portion of rectangle.

    dsendf("CO%d;RF %d,%d,%d,%d\n",
        1 + random(15),
        x+1, y+1, x+SIZE-1, y + SIZE-1);
        
    // Set color to white then draw outline of rectangle    
        
    dsendf("CO15;RU %d,%d,%d,%d\n",
        x, y, x+SIZE, y + SIZE);        
        
    // Keep track of just how full our transmit buffer
    // is so you can see that we're not flooding VideoSYNC
    // with commands.
        
    nRDXOutputBuf = dsend();                // Get current transmit buffer count
    
    if (nRDXOutputBufMax < nRDXOutputBuf)   // New high water mark?
        nRDXOutputBufMax = nRDXOutputBuf;   // ..Remember high water mark
        
    //dsend("WM 220");                      // Make VideoSYNC take a long time
    
    start = time();                         // Remember starting time
    spawnwait WaitForVideoSYNC();           // Wait for VideoSYNC to finish
    VSdelay = time() - start;               // This is how long VideoSYNC took.
    
    // Wait before sending out another command.
    //
    // This wait is not necessary!  But it allows you to change DELAY
    // while the protocol is running to play around with timing.
    // With DELAY == 0 (the default), the protocol does not wait.
    
    wait DELAY;
    }
}


//-----------------------------------------------------------------------
// PROCESS WaitForVideoSYNC - Wait for all commands to be executed by VideoSYNC.
//
//  The protocol uses WaitForVideoSYNC() like this:
//
//      dsend() or dsendf() ...         // Send a command sequence to VideoSYNC
//      spawnwait WaitForVideoSYNC;     // Wait for all commands to complete
//      // At this point, all commands were executed by VideoSYNC.
//      ...
//      
// We utilize the new (as of 24Jun03) RDX TTL feature where there are two TTL
// bits in each direction (VideoSYNC to server and server to VideoSYNC) that
// are now supported by the TEMPO server as well as VideoSYNC.  The two
// features we use are:
//
//      o VideoSYNC's SO command (which sets VideoSYNC's RDX TTL outputs)
//      o PCL's rdxGetTTLIN() and rdxSetTTLIN() functions, which get and
//        set the TEMPO server's RDX TTL outputs.
//
// In particular, we use the RDX TTL bits from VideoSYNC to the TEMPO server
// to have VideoSYNC tell us when it is finished executing all previously
// sent (via dsend/dsendf) commands.  We to this by telling VideoSYNC to set
// its RDX TTL output bits (by sending the SO VideoSYNC command) to a new value
// each time the WaitForVideoSYNC process is spawned.  We then watch the
// incoming RDX TTL bits until we see the value we expect.
//
// There are two enhancements that could be made to this process, which are left
// to the reader to implement.
//
// 1. Use only one TTL bit instead of 2.  This frees up one bit from VideoSYNC
//    to the TEMPO server for other uses by the protocol.
//
// 2. Add a timeout (in ms) argument that causes WaitForVideoSYNC to return
//    after so many milliseconds.  WaitForVideoSYNC would also set a global
//    variable indicating whether the wait was successful or, if no, what the
//    reason was.  Possible status codes are:
//
//          0. Success.  VideoSYNC executed the commands within the requested
//             timeframe.
//          1. timeout waiting for our transmit buffer to empty.  This
//             error indicates that VideoSYNC (or the RDX reader isn't
//             running)
//          2. timeout waiting for VideoSYNC to finish executing commands.
//             This indicates that either VideoSYNC is too slow to execute
//             the commands in the requested time or that the RDX receiver
//             hasn't implemented the SO command.

process WaitForVideoSYNC()
    {
    int     newBits;                    // =0,1,2,3
    
    // WAIT FOR ALL PREVIOUS COMMAND TO GET SENT
    // This insures that we are in sync up to this point.
    
    while (dsend()) nexttick;
    
    // Now read the current TTL setting and advance by 1.
    // We are using both of RDX's TTL bits from VideoSYNC
    // to us.  But this is not necessary.  We could just
    // use one of the bits, leaving the other free for
    // other uses.

    newBits = (rdxGetTTLIN() + 1) % 4;  // Advance one MOD 4
    
    // Tell VideoSYNC to increment the sequence count
    // .. by setting its local OOB bits on the RDX link
    // We assume we are the only process sending the SO command.
    // If SO is sent by any other process, it will mess us up
    // and cause us to wait, possibly indefinitely, for our bits.
    
    dsendf("SO%d\n", newBits);

    // WAIT FOR VIDEOSYNC TO ACTUALLY EXECUTE THE SO COMMAND ABOVE.
    // When it does, it will set its "local" bits to newBits.
    // We will see that change here when we get the "remote" bits.

    while (rdxGetTTLIN() != newBits)    // Wait for the bits we expect
        nexttick;
    }


// Here is an alternative to the above WaitForVideoSYNC() process.
// The advantage here is that you can wait for a specific period
// of time (timeout).  To wait forever, set msTimeout to 0.
//
// I haven't tested this pseduo code.
// For this to work successfully, this must be the only
// process in your protocol that writes to the low RDX TTL bit.
// 
// int vs_duration;            // =1 iff VideoSYNC timed out
//                             // ..after calling this process
// 
// process WaitForVideoSYNC(int msTimeout)
//     {
//     int     startTime;
//     int     endTime;
//     int     ttl;
//     
//     vs_duration = 0;             // Duration of time to RDX ttl change
//     startTime = time();
//
//     if (msTimeout <= 0)
//         msTimeout = 1000000000;  // Wait "forever"
//
//     endTime = startTime + msTimeout;
//     
//     while (time() < endTime && dsend() > 0)
//         nexttick;           // Wait for RDX output buf to empty
//         
//     // At this point, we either timed out waiting for RDX transmit
//     // buffer to empty or its now empty.
//     
//     if (time() < endTime)   // Any time left?
//         {
//         // Our RDX transmit buffer is empty.  This means that VS has
//         // received all the commands.  It does _not_ mean that VS has
//         // processed all those commands!  So we send the SO command
//         // to VideoSYNC to toggle the low RDX ttl bit, then wait
//         // (with timeout) for this low RDX TTL bit to flip.
//     
//         ttl = rdxGetTTLIN() & 0x1;
//         dsendf("SO %d\n", 1 - ttl);     // Tell VS to flip low bit
// 
//         while (time() < endTime &&
//                ttl == (rdxGetTTLIN() & 0x1))
//             {
//             nexttick;
//             }
//         }
//     
//     
//     // This is the duration of time (in ms) that we waited.
//     // If this is < msTimeout 
//     
//     vs_duration = time() - startTime;    // # of ms to execution
//     }
// 
// then in your protocol you can do this to wait:
// 
//     int msTimeout;
//     
//     
//     dsendf(...);
//     dsendf(...);
//     dsendf(...);
//     dsendf(...);
//     
//     msTimeout = 500;
//     spawnwait WaitForVideoSYNC(msTimeout);
//     if (vs_timeout < msTimeout)
//         {
//         // VS completed all previous commands within our time limit.
//         }
//     else
//         {
//         // VS did not complete all previous commands within our time limit.
//         }
// 
// 
// This method insures:
//
//      1) your protocol knows that VideoSYNC executed all commands, and
//      2) VS does so within your predefined time period.
// 
// Also, what's kind of nice about this is that the rest of your
// protocol doesn't need to fuss with the RDX ttls.  All the details are
// encapsulated in the WaitForVideoSYNC() process.


