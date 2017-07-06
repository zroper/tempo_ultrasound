///// SEND EVENTS TO PLEXON  



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																													 //
//																													 //
//											            INFOS														 //
//																													 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

process WRITE_PARAMS()
{

WRITE_PARAMS_FLAG =1;
// 20 Columns...... and number of line = number of trials

 //1 NPOS Number of stimulus position 

 eventCode=2721;			   
 spawn queueEvent();	
 eventCode=npos;			   
 spawn queueEvent();	


 //2 Current POS of stimulus 

 eventCode=2722;			   
 spawn queueEvent();	
 eventCode=trials[i];			   
 spawn queueEvent();	   //// we could put here more information about the stimulus location

 //3 Flag wether use an acoustic stop signal (0 or 1) 0 by default 

 eventCode=2723;			   
 spawn queueEvent();	
 eventCode=SOUND_S;			   
 spawn queueEvent();	

 //4 Flag wether the current trial is no NOGO trial // Electrical stim parameter 

 eventCode=2724;			   
 spawn queueEvent();	
 eventCode=ISNOT_NOGO;			   
 spawn queueEvent();	

//5 Empty


 //6 Flag wether trigger is changed of color or not (0 = no by default) 

 eventCode=2726;			   
 spawn queueEvent();	
 eventCode=TRIG_CHANGE;			   
 spawn queueEvent();	


 //8 Fraction of rewarded trial 

 eventCode=2728;			   
 spawn queueEvent();	
 eventCode=REWARD_RATIO;			   
 spawn queueEvent();	

 //9 fraction of NoGO trial  1/NOGO_RATIO = ratio of nogo e.g NOGO_RATIO=3 0.33 of STOP Trials

 eventCode=2729;			   
 spawn queueEvent();	
 eventCode=NOGO_RATIO;			   
 spawn queueEvent();	

 //10 Flag wether the current trial is a NOGO trial 1= GO 2=NOGO we added -1 to send 0 or 1 (conform to PDP coding)

 eventCode=2730;			   
 spawn queueEvent();	
 eventCode=types[j];			   
 spawn queueEvent();	

 //11 Time relative to the cue to Stim (+ or - time) we defined 700 as the origin (we can no send a negative number 

 eventCode=2731;			   
 spawn queueEvent();	
 eventCode=STIM_OFFSET;			   
 spawn queueEvent();		

 //12 Duration of the electric stimulation  

 eventCode=2732;			   
 spawn queueEvent();	
 eventCode=60;			   
 spawn queueEvent();	

 //13 Flad wether retangular (0) or exponential (1) hold distribution  

 eventCode=2733;			   
 spawn queueEvent();	
 eventCode=EXPO_JITTER;			   
 spawn queueEvent();		

 //14 Delay between TARGET ON and FIXATION OFF (=0 by default) 

 eventCode=2734;			   
 spawn queueEvent();	
 eventCode=GO_DELAY;			   
 spawn queueEvent();		


 //15 Hold time Jitter % of the total holdtime  

 eventCode=2735;			   
 spawn queueEvent();	
 eventCode=frac_hold_jitter;			   
 spawn queueEvent();	

 // 16 empty		

 //17 SOA of the current trial SSD 

 eventCode=2737;			   
 spawn queueEvent();	
 eventCode=stop[s];			   
 spawn queueEvent();	

 //18 Maximum SOA between the GO and NOGO cue 

 eventCode=2738;			   
 spawn queueEvent();	
 eventCode=SSD_max;			   
 spawn queueEvent();		

 //19 Minimum SOA between the GO and NOGO cue 

 eventCode=2739;			   
 spawn queueEvent();	
 eventCode=SSD_min;			   
 spawn queueEvent();		

 //20 SOA intervalls

 eventCode=2740;			   
 spawn queueEvent();	
 eventCode=SSD_Step;			   
 spawn queueEvent();		

 //21 FixWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)

 eventCode=2770;			   
 spawn queueEvent();	



//////////////// Lower left corner H coordinates
	 //// 3000 added just to be different than potential events
Volt_Fix_H_1 = 3000 + abs(((-Fix_H/2)* XMAX / XGAIN) - H_OFFSET);


 eventCode= Volt_Fix_H_1;			   
 spawn queueEvent();

 if ( ((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
 eventCode=2;			   
 spawn queueEvent();
 Sign_Volt_Fix_H_1=1;
 }
 if (((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();
 Sign_Volt_Fix_H_1=-1;
 }

//////////////// Lower left corner V coordinates
 
Volt_Fix_V_1 = 3000 + abs((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET);

 
 eventCode= Volt_Fix_V_1;		  
 spawn queueEvent();
 if (((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)>=0)
 {																						
 eventCode=2;			   
 spawn queueEvent();
 Sign_Volt_Fix_V_1=1;
 }
 if (((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();
 Sign_Volt_Fix_V_1=-1;
 }

 //////////////// Upper right corner H coordinates
 
Volt_Fix_H_2 = 3000 + abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET);

 eventCode= Volt_Fix_H_2;	   
 spawn queueEvent();
 if ( ((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
 eventCode=2;			   
 spawn queueEvent();
 Sign_Volt_Fix_H_2=1;
 }
 if ( ((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();
 Sign_Volt_Fix_H_2=-1;
 }


//////////////// Upper right corner V coordinates
 Volt_Fix_V_2 = 3000 + abs((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET);
 Volt_Fix_H_2 = 3000 + abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET);
 
 eventCode= Volt_Fix_V_2;		   
 spawn queueEvent();
 
 if ( ((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)>=0)
 {
 eventCode=2;			   
 spawn queueEvent();
 Sign_Volt_Fix_V_2=1;
 }
 if ( ((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();
 Sign_Volt_Fix_V_2=-1;
 }



 //22 TARGWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)

 eventCode=2771;			   
 spawn queueEvent();	
  printf("trial[i]: %d\n", trials[i]);
  printf("TargH: %d\n", TarH);

//////////////// Lower left corner H coordinates
 Volt_Targ_H_1 = 3000 + abs(((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET);
 
 eventCode= Volt_Targ_H_1;	  
 spawn queueEvent();
 if ((((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
 eventCode=2;			   
 spawn queueEvent();

 }
 if ((((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();

 }



//////////////// Lower left corner V coordinates
 Volt_Targ_V_1 = 3000 + abs(((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET);
 
 eventCode= Volt_Targ_V_1;	 	   
 spawn queueEvent();
 if ((((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)>=0)
 {
 eventCode=2;			   
 spawn queueEvent();

 }
 if ((((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();

 }




  //////////////// upper right corner H coordinates
 
 Volt_Targ_H_2 = 3000 + abs(((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET);
 
 eventCode= Volt_Targ_H_2;			   
 spawn queueEvent();
 	
 if ((((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)>=0)
 {
 eventCode=2;			   
 spawn queueEvent();

 }
 if ((((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();

 }




//////////////// upper right corner V coordinates
 
 Volt_Targ_V_2 = 3000 + abs(((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET);


 eventCode= Volt_Targ_V_2;	   
 spawn queueEvent();
  if ((((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)>=0)
 {
 eventCode=2;			   
 spawn queueEvent();
 }
 if ((((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)<0)
 {
 eventCode=0;			   
 spawn queueEvent();
 }

////////////////////////  VOLTAGE RANGE ERROR  //////////////////////
// the Tempo analog board can accept voltages ranging from -10V to +10V
// but Plexon National Instruments card can only accept -5V to +5V (although
// NI measurement and automation explorer says the range is -10V to +10...this 
// is wrong).  So...everything can look fine in Tempo, but in fact Plexon is
// not recording eye movements that elicit voltages > abs(5).  Plexon 
// saturates in this case and reports of voltage of 5 or -5.  To make sure this
// doesn't happen we put in a warning signal when the target or fixation window
// values (which are also specified in voltages) are greater than 5V.	If this
// happens, reduce gain and change offset on tempo to stay within +/- 5V
// MWL 8/29/05

//MWL
Volt_Fix_H_1real = abs((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)-3000;
Volt_Fix_H_1real = (Volt_Fix_H_1real* 0.0003052) + 0.0000916;	

Volt_Fix_V_1real = abs((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)-3000;
Volt_Fix_V_1real = (Volt_Fix_V_1real* 0.0003052) + 0.0000916;	

Volt_Fix_H_2real = abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)-3000;
Volt_Fix_H_2real = (Volt_Fix_H_2real* 0.0003052) + 0.0000916;	

Volt_Fix_V_2real = abs((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)-3000;
Volt_Fix_V_2real = (Volt_Fix_V_2real* 0.0003052) + 0.0000916;	

 
Volt_Targ_H_1real = abs(((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)-3000;	//lower left H
Volt_Targ_H_1real = (Volt_Targ_H_1real* 0.0003052) + 0.0000916; //this should be the actual voltage

Volt_Targ_V_1real = abs(((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)-3000;//lower left V
Volt_Targ_V_1real = (Volt_Targ_V_1real* 0.0003052) + 0.0000916; //this should be the actual voltage

Volt_Targ_H_2real = abs(((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)-3000;//upper right H
Volt_Targ_H_2real = (Volt_Targ_H_2real* 0.0003052) + 0.0000916; //this should be the actual voltage

Volt_Targ_V_2real = abs(((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)-3000;//upper right V
Volt_Targ_V_2real = (Volt_Targ_V_2real* 0.0003052) + 0.0000916; //this should be the actual voltage


if ((Volt_Fix_H_1real > 5) || (Volt_Fix_V_1real > 5) ||  (Volt_Fix_H_2real > 5) || (Volt_Fix_V_2real > 5) || (Volt_Targ_H_1real > 5) || (Volt_Targ_V_1real > 5) ||  (Volt_Targ_H_2real > 5) || (Volt_Targ_V_2real > 5))
	{
	 print("VOLTAGE OUT OF RANGE");
	 print("VOLTAGE OUT OF RANGE");
	 print("fix and target window values must be < 5V");
	}
//MWL


/////////////////// 
 eventCode=2927;			   
 spawn queueEvent();	
 
 eventCode=REWARD_SIZE;			   
 spawn queueEvent();	
  
 ///////////////////////stimfile values //change by eee 06/30/05
 eventCode=7000;			   
 spawn queueEvent();	
 
 eventCode=eccen;			   
 spawn queueEvent();	

 eventCode=ang;
 spawn queueEvent();	

 eventCode=ang_2;
 spawn queueEvent();	

 eventCode=ang_3;
 spawn queueEvent();

WRITE_PARAMS_FLAG =0;
   }



