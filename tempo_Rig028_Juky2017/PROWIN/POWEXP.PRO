/* POWEXP.PRO - Test execution time of exp() and pow() functions
;+
; SYNOPSIS
;   CLOAD powexp
;   START
;
; DESCRIPTION
;   This little protocol tests the timing of the pow() and exp() functions
;   for various random numbers.
;
;   New x,y values are chosen once per second.  The exp(x) and pow(x,y) functions
;   are called.  The function results are displayed along with the execution
;   time (in microseconds).
;
; EDIT HISTORY
;   02Sep05 sh  Initial edit
;-
*/

float y;				                // y= exp()
float z;                                // z = pow(x,y)
int startTimeUS, endTimeUS;		        // Execution times in uSec

declare Main();
declare testExp(float x);
declare testPow(float x, float y);


//-------------------------------------------------------
process Main() enabled
{
    float       x = 0;
    int         ms;
    
systemf("show p\n");
while (1)
	{
	x = random(10) + 1/(x+1);
	spawn testExp(x);
    ms = (endTimeUS - startTimeUS + 65536) % 65536; // corrects wraparound
	printf("%d uSec exp(%.5d) = %.5d\n", ms, x, y);
    
    y = random(8) + 1 / x;
    spawn testPow(x, y);
    ms = (endTimeUS - startTimeUS + 65536) % 65536; // corrects wraparound
	printf("%d uSec pow(%.5d,%.5d) = %.5d\n", ms, x, y, z);
    
	wait 1000;
	}
}


//-------------------------------------------------------
process testExp(float x)
{
startTimeUS = timeus();
y = exp(x);
endTimeUS = timeus();
}


//-------------------------------------------------------
process testPow(float x, float y)
{
startTimeUS = timeus();
z = pow(x, y);
endTimeUS = timeus();
}
