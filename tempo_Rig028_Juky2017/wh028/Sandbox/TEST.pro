#pragma declare = 1;

declare int Event_fifo_N = 1000;		// Lenght of strobed event buffer
declare int Event_fifo[Event_fifo_N];	// Global first in first out buffer for event codes
declare int Set_event = 0;              // Current index of Event_fifo buffer to set

#include C:/TEMPO/ProcLib/DIO.pro		// necessary for digital input output communication
#include C:/TEMPO/ProcLib/EVENTDEF.pro	// event code definitions
#include C:/TEMPO/ProcLib/QUE_TTL.pro	// makes a ring buffer for sending TTL events
#include C:/TEMPO/ProcLib/WATCHMTH.pro



declare MAIN();

process MAIN() enabled
	{
	
	spawn QUE_TTL();
	spawn WATCHMTH();
	
	}


	