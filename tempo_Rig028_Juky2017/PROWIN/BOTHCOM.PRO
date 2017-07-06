// DUALCOM.PRO - Demonstrate use of both COM ports from TEMPO

hide waittime = 60;

// We must declare process names

DECLARE MAIN(), COM1(), COM2(), BOTH_COMS();

process main enabled
    {
    print("TEMPO can output characters simultaneously to two COM ports.");
    print("As an example, we assume WORDPLAY is running on two machines");
    print("each connected to the COM ports on this machine.");

    spawn   both_coms;
    }

process com1                        // Send to COM 1
    {
    send("VI 1");
    wait    3000;
    while (1)
        {
        x1 = random(500);
        y1 = random(300);
        send("RF", x1, y1, x1 + 100, y1 + 20); 
        send("MV", x1, y1);
        send("CO", x1 % 15);
        send("TX TEMPO COM1");
        wait    waittime;
        }
    }

process com2                        // Send to COM 2
    {
    send2("VI 1");
    wait    3000;
    while (1)
        {
        x2 = random(500);
        y2 = random(300);
        send2("RF", x2, y2, x2 + 100, y2 + 20); 
        send2("MV", x2, y2);
        send2("CO", x2 % 15);
        send2("TX TEMPO COM2");
        wait    waittime;
        }
    }

process both_coms           // Send to both COMs simultaneously
    {
    sendb("VI 1");
    wait    3000;
    while (1)
        {
        x3 = random(500);
        y3 = random(300);
        sendfb("RF %d %d %d %d\r\n", x3, y3, x3 + 100, y3 + 20); 
        sendb("MV", x3, y3);
        sendb("CO", x3 % 16);
        sendb("TX TEMPO BOTH COMs");
        wait    waittime;
        }
    }
