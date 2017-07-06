//------------------------------------------------------------------------
// process STIM(int channel, int duration)
// Deliver a STIM reward to the animal
// INPUT
//	 channel  = rig specific TTL channel connected to solenoid (channel 9 in 028)
//	 duration = amount of time (in ms) to leave solenoid open
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare STIM(int channel, int duration);

process STIM(int channel, int duration)
	{
	declare hide int open   = 1;	
	declare hide int closed = 0;	
	
	mio_dig_set(channel,open);		// Start sending the TTL
	wait(duration);					// Wait for user defined period of time (ms)
	mio_dig_set(channel,closed);	// Stop sending the TTL

			printf("STIMULATION\n");						// ...tell the user whats up...
	Event_fifo[Set_event] = Stimulation_;		// queue strobe, and ...
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	}