//------------------------------------------------------------------------
// process JUICE(int juice_channel, int juice_duration)
// Deliver a juice reward to the animal
// INPUT
//	 juice_channel  = rig specific TTL channel connected to solenoid
//	 juice_duration = amount of time (in ms assuming speed == 1000) to leave solenoid open

process JUICE(int juice_channel, int juice_duration)
	{
	declare int open   = 1;							// TTL open is 1
	declare int closed = 0;							// TTL closed is 0
	
	mio_dig_set(juice_channel,open);				// Start sending the TTL
	wait(juice_duration);							// Wait for user defined period of time (ms)
	mio_dig_set(juice_channel,closed);				// Stop sending the TTL
	nexttick;
	
	}