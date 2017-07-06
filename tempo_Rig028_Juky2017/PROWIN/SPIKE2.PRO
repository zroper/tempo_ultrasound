/* SPIKE2.PRO - Trigger database collection by toggling a TTL port.
 *
 * This protocol triggers a database collection when ever a TTL port
 * is toggled high.  Each of four database tags are triggered in sequence.
 * This effectively lets you use TEMPO as a passive data collection
 * mechanism while some other system drives the experiment.  For people
 * who are just starting out, it is a useful way to verify that data
 * collected by TEMPO matches the data collected on your old system.
 * 
 * Attach a TTL to MIO TTL input channel 1 (see MIO manual
 * for pinouts, its pin 26.  The 4 MIO TTL inputs are "firmwired"
 * by TEMPO to status bits 0x1000 0000, 0x2000 0000, ... 0x8000 0000.
 * You may need a pullup/down resistor (10k) on some MIO cards
 * (See MIO manual, "Digital I/O Connections")
 * To test your connection, after you start TEMPO, when you toggle
 * the TTL, you should see TEMPO's "status" bits change in the
 * upper right corner of the monochrome monitor.
 * We'll assume the bit is 0 when the TTL is low and the 1 when
 * the TTL is high (if yours is reversed, change the protocol
 * WSON to WSOF and WSOF to WSON).
 *
 * This protocol waits for TTL high (=1) and triggers one of
 * four databases.  The databases are sequenced through 1,2,3,4.
 */

HIDE HEX ttl = 0x10000000;          // TTL bit in status

process MAIN enabled
    {
    print("A database is triggered each time TTL0 is toggled");
    print("Four databases are cycled through.");

    trial_type = 1;                 // trial_types will be 1..4

    while (1)
        {
        WSON    ttl;                // Wait for TTL off-to-on

        TRIGGER trial_type;         // Collect into one of 4 databases

        trial_type = trial_type + 1;
        if (trial_type > 4)
            trial_type = 1;

        WSOF    ttl;                // Wait for TTL on-to-off
        }
    }
