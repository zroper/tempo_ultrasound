/* PORTIO.PRO - Demonstrate port access
; SYNOPSIS
;   This protocol shows how to use the inp/outp routines to access
;   an i/o port on the computer.  I/O port access is useful when special
;   purpose cards are used in conjunction with TEMPO (such as digitizing
;   pads, quadrature cards, and other complex controllers.
;
;   IBM ports may be read or written to 8 bits or 16 bits at a time.
;   There are four PCL functions available for accessing i/o ports:
;
;   value8 = inp(port)          - read 8 bits
;   outp(port, value8)          - write 8 bits
;   value16 = inpw(port)        - read 16 bits
;   outpw(port, value16)        - write 8 bits
;
;   It is crutial that you understand how a particular port responds
;   to reads and writes - it is all too easy to crash the machine if
;   you do not adhere to the conventions of the card you are accessing.
;
;   This demonstration program sends a string of characters to the
;   printer port on the monochrome card.  If your monochrome card
;   does not have a printer port or it is disabled, select another
;   port for the test.
;
;   You must not modify the DMA controller or PIC interrupt controller
;   as this will surely crash the system.  Since TEMPO manages the a/d
;   card, the TIO card, the digital i/o card(s) and the COM ports, you
;   must not access ports releated to these, either.
*/
declare astring[9] = {'T', 'E', 'M', 'P', 'O', '!', '\r', '\n', 0};

constant hex port1 = 0x3BC;         // parallel port on HERC card
constant hex port2 = 0x378;         // first parallel port         
constant hex port3 = 0x278;         // second parallel port

hex port = port1;                   // Assume we send to HERC printer

process MAIN enabled
    {
    i = 0;
    while (astring[i])
        {
        spawn PRINT_C(astring[i]);  // Print next character
        waitforprocess PRINT_C;     // Wait for completion
        i = i + 1;                  // Look a the next character
        }
    print("All done");
    }

process PRINT_C(C)                  // Print one character
    {
    outp(port, C);                  // Put character onto data lines
    status = inp(port+2);           // Get printer status
    status = status & ~1;           // Set STROBE to 0
    outp(port+2, status);           // ..Tell printer character is ready
    nexttick;                       // for a short time (>1 microsec)
    status = status | 1;            // Set STROBE to 1
    outp(port+2, status);           // ..Tell printer no more data

    while (inp(port+1) & 0x80 == 0) // Wait for..
        nexttick;                   // ..ACK from printer
    }
