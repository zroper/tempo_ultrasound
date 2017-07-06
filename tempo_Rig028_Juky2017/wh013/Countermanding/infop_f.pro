///// SEND EVENTS TO PLEXON  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																													 //
//																													 //
//											            INFOS														 //
//																													 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFIED 05-30-07 EEE
// 		ADDED THE OPTION OF USING PERIPHERAL STOP SIGNAL			   
//		it is the value of the 2nd strobed event after 2723
//		spawn SendTTLToRemoteSystem(curr_vis_SS); // 0 IF FOVEAL STOP, 1 IF PERIPHERAL
//
//MODIFIED: 3-22-07 EEE
//		MADE VALUE FOR STOPZAP IN CMANDING uSTIM GREATER THAN 0 BY ADDING
//		+1 TO THE VALUE IN THE EVENT THAT 0 WAS THE STIM_OFFSET.		
//	
//MODIFIED: 2-26-07 EEE
// 		ADDED EVENT CODE FOR MICROSTIM MAP TASK
//
//MODIFIED: 01-04-2007 EEE
//		ADDED TRIAL NUMBER FOR TrialType_ variable in _m file to WRITE_PARAMS()
// 		EVENT # 2928
// 		THE NEXT EVENT IS THE VALUE OF THE TRIAL COUNTER NOTE THE TRIAL COUNTER RESETS
// 		TO 0 AT THE BEGINNING OF EACH BLOCK
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
process WRITE_PARAMS()
{
	// MODIFIED: 2-26-07 EEE
	// 	ADDED EVENT CODE FOR MICROSTIM MAP TASK
	// CHANGED : 
	//spawn SendTTLToRemoteSystem(1501);		
	// nexttick;
	// TO THE FOLLOWING...
	

	if (Task==1)
	{
    		spawn SendTTLToRemoteSystem(1501); /// Task_type here Countermanding					   
 			nexttick;
	}

	if (Task==3)
	{
		spawn SendTTLToRemoteSystem(1503);/// Task_type here Map					   
		nexttick;
	}
   	// END MOD

	// Infos_ : 20 Columns...... and number of lines = number of trials

	//1 NPOS Number of stimulus position 
	spawn SendTTLToRemoteSystem(2721);			   
	spawn SendTTLToRemoteSystem(npos);			   
	nexttick;

	//2 Current POS of stimulus 
	spawn SendTTLToRemoteSystem(2722);			   
	spawn SendTTLToRemoteSystem(trials[i]);
	if (DR1)
	{
		spawn SendTTLToRemoteSystem(DR1_current_reward_target);
	}
	nexttick;

	//3 Flag wether use an acoustic stop signal (0 or 1) 0 by default 
	spawn SendTTLToRemoteSystem(2723);			   
	spawn SendTTLToRemoteSystem(SOUND_S);
	// MODIFIED 05-30-07 EEE
	// 		ADDED THE OPTION OF USING PERIPHERAL STOP SIGNAL			   
	//spawn SendTTLToRemoteSystem(curr_vis_SS); // 0 IF FOVEAL STOP, 1 IF PERIPHERAL
	nexttick;

	//4 Flag wether the current trial is no NOGO trial // Electrical stim parameter 
	spawn SendTTLToRemoteSystem(2724); 
	spawn SendTTLToRemoteSystem(ISNOT_NOGO);
	nexttick;

	//5 Empty
	spawn SendTTLToRemoteSystem(2725); 
	spawn SendTTLToRemoteSystem(BIG_REWARD);
	nexttick;
	
	//6 Flag wether trigger is changed of color or not (0 = no by default) 
	spawn SendTTLToRemoteSystem(2726);			   
	spawn SendTTLToRemoteSystem(TRIG_CHANGE);	 
	nexttick;

	//8 Fraction of rewarded trial 
	spawn SendTTLToRemoteSystem(2728);			   
	spawn SendTTLToRemoteSystem(REWARD_RATIO);			   
	nexttick;

	//9 fraction of NoGO trial  1/NOGO_RATIO = ratio of nogo e.g NOGO_RATIO=3 0.33 of STOP Trials
	spawn SendTTLToRemoteSystem(2729);			   
	spawn SendTTLToRemoteSystem(NOGO_RATIO);			   
	nexttick;
		
	//10 Flag wether the current trial is a NOGO trial 1= GO 2=NOGO we added -1 to send 0 or 1 (conform to PDP coding)
	spawn SendTTLToRemoteSystem(2730);
	if (Task != 3)
	{
		spawn SendTTLToRemoteSystem(types[j]);
		spawn SendTTLToRemoteSystem(Stimu[s]);
	}
	else
	{
		spawn SendTTLToRemoteSystem(1);
	}
	nexttick;

	//11 Time relative to the cue to Stim (+ or - time) we defined 700 as the origin (we can no send a negative number 
	spawn SendTTLToRemoteSystem(2731);			   
	spawn SendTTLToRemoteSystem(STOPZAP);			   
	STOPZAP =0;		

	//12 Duration of the electric stimulation  
	spawn SendTTLToRemoteSystem(2732);			   
	spawn SendTTLToRemoteSystem(60);			   
	nexttick;

	//13 Flag wether retangular (0) or exponential (1) hold distribution  
	spawn SendTTLToRemoteSystem(2733);			   
	spawn SendTTLToRemoteSystem(EXPO_JITTER);			   
		
	//14 Delay between TARGET ON and FIXATION OFF (=0 by default) 
	spawn SendTTLToRemoteSystem(2734);			   
	spawn SendTTLToRemoteSystem(GO_DELAY);			   	
	nexttick;

	//15 Hold time Jitter % of the total holdtime  
	spawn SendTTLToRemoteSystem(2735);			   
	spawn SendTTLToRemoteSystem(frac_hold_jitter);			   

	// 16 empty	   //MWL 10/25/06 this column now contains max response time
	spawn SendTTLToRemoteSystem(2736);			   
	spawn SendTTLToRemoteSystem(fix_targ_maxT);		

	 //17 SOA of the current trial SSD 
	spawn SendTTLToRemoteSystem(2737);			   
	spawn SendTTLToRemoteSystem(stop[s]);			   
	nexttick;

	//18 Maximum SOA between the GO and NOGO cue 
	spawn SendTTLToRemoteSystem(2738);			   
	spawn SendTTLToRemoteSystem(SSD_max);			   
		
	//19 Minimum SOA between the GO and NOGO cue 
	spawn SendTTLToRemoteSystem(2739);			   
	spawn SendTTLToRemoteSystem(SSD_min);			   
			
	//20 SOA intervalls
	spawn SendTTLToRemoteSystem(2740);			   	
	spawn SendTTLToRemoteSystem(SSD_Step);			   	
	nexttick;

	//21 FixWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)
	spawn SendTTLToRemoteSystem(2770);			   
	nexttick;
	//////////////// Lower left corner H coordinates
	//// 3000 added just to be different than potential events
	Volt_Fix_H_1 = 3000 + abs( (-Fix_H/2)* (XMAX / XGAIN) - H_OFFSET );
	spawn SendTTLToRemoteSystem(Volt_Fix_H_1);			   
	// +1 = sign of voltage
	if ( ((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)>=0)
	{
		spawn SendTTLToRemoteSystem(2);			   
	 	Sign_Volt_Fix_H_1=1;
	}
	if (((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)<0)
	{
		spawn SendTTLToRemoteSystem(0);			   
	 	Sign_Volt_Fix_H_1=-1;
	}
	nexttick;
	
	//////////////// Lower left corner V coordinates	 
	Volt_Fix_V_1 = 3000 + abs( (-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET );
	spawn SendTTLToRemoteSystem(Volt_Fix_V_1);		  
	if (  ( (-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET )>=0  )
	{																						
		spawn SendTTLToRemoteSystem(2);			   
		Sign_Volt_Fix_V_1=1;
	}
	if (((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)<0)
	{
		spawn SendTTLToRemoteSystem(0);			   
		Sign_Volt_Fix_V_1=-1;
	}
	nexttick;

	//////////////// Upper right corner H coordinates 
	Volt_Fix_H_2 = 3000 + abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET);
	spawn SendTTLToRemoteSystem(Volt_Fix_H_2);	   
	if ( ((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)>=0)
	{
		spawn SendTTLToRemoteSystem(2);			   
	 	Sign_Volt_Fix_H_2=1;
	}
	if ( ((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)<0)
	{
		spawn SendTTLToRemoteSystem(0);			   
		Sign_Volt_Fix_H_2=-1;
	}
	nexttick;

	//////////////// Upper right corner V coordinates
	Volt_Fix_V_2 = 3000 + abs((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET);
	// Volt_Fix_H_2 = 3000 + abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET);	 
	spawn SendTTLToRemoteSystem(Volt_Fix_V_2);		   
	 
	 if ( ((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)>=0)
	 {
		spawn SendTTLToRemoteSystem(2);			   
	 	Sign_Volt_Fix_V_2=1;
	 }
	 if ( ((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)<0)
	 {
		spawn SendTTLToRemoteSystem(0);			   
	 	Sign_Volt_Fix_V_2=-1;
	 }

	 

	//22 TARGWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)
	spawn SendTTLToRemoteSystem(2771);			   
	nexttick;
	//////////////// Lower left corner H coordinates
	Volt_Targ_H_1 = 3000 + abs(((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET); 
	spawn SendTTLToRemoteSystem(Volt_Targ_H_1);	  

	if ((((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)>=0)
	{
		spawn SendTTLToRemoteSystem(2);			   
	}
	if ((((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)<0)
	{
		spawn SendTTLToRemoteSystem(0);			   
	}
	nexttick;
	
	//23 tracking
	spawn SendTTLToRemoteSystem(2772);			   
	nexttick;
	spawn SendTTLToRemoteSystem(staircase+1);
	
	//24 negative feedback
	spawn SendTTLToRemoteSystem(2773);			   
	nexttick;
	spawn SendTTLToRemoteSystem(neg_2reinforcement+1);
	
	//25 negative feedback
	spawn SendTTLToRemoteSystem(2774);			   
	nexttick;
	spawn SendTTLToRemoteSystem(feedback+1);
	
	
	//////////////// Lower left corner V coordinates
	Volt_Targ_V_1 = 3000 + abs(((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET);
	spawn SendTTLToRemoteSystem(Volt_Targ_V_1);	 	   

	if ((((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)>=0)
	{
		spawn SendTTLToRemoteSystem(2);			   
	}
	if ((((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)<0)
	{
		spawn SendTTLToRemoteSystem(0);			   
	}
	nexttick;

	//////////////// upper right corner H coordinates 
	Volt_Targ_H_2 = 3000 + abs(((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET); 
	spawn SendTTLToRemoteSystem(Volt_Targ_H_2);			   
	 	
	if ((((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)>=0)
	{
		spawn SendTTLToRemoteSystem(2);			   
	}
	if ((((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)<0)
	{
		spawn SendTTLToRemoteSystem(0);			   
	}
	nexttick;

	//////////////// upper right corner V coordinates 
	Volt_Targ_V_2 = 3000 + abs(((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET);
	spawn SendTTLToRemoteSystem(Volt_Targ_V_2);	   

	if ((((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)>=0)
	{
		spawn SendTTLToRemoteSystem(2);			   
	}
	if ((((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)<0)
	{
	spawn SendTTLToRemoteSystem(0);			   
	}
	nexttick;
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
	nexttick;

	Volt_Fix_H_1real = abs((-Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)-3000;
	Volt_Fix_H_1real = (Volt_Fix_H_1real* 0.0003052) + 0.0000916;	

	Volt_Fix_V_1real = abs((-Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)-3000;
	Volt_Fix_V_1real = (Volt_Fix_V_1real* 0.0003052) + 0.0000916;	

	Volt_Fix_H_2real = abs((Fix_H/2)* (XMAX/XGAIN) - H_OFFSET)-3000;
	Volt_Fix_H_2real = (Volt_Fix_H_2real* 0.0003052) + 0.0000916;	

	Volt_Fix_V_2real = abs((Fix_V/2)* (YMAX/YGAIN) - V_OFFSET)-3000;
	Volt_Fix_V_2real = (Volt_Fix_V_2real* 0.0003052) + 0.0000916;	

	 
	nexttick;
	Volt_Targ_H_1real = abs(((TarH-(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)-3000;	//lower left H
	Volt_Targ_H_1real = (Volt_Targ_H_1real* 0.0003052) + 0.0000916; //this should be the actual voltage

	Volt_Targ_V_1real = abs(((TarV-(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)-3000;//lower left V
	Volt_Targ_V_1real = (Volt_Targ_V_1real* 0.0003052) + 0.0000916; //this should be the actual voltage

	Volt_Targ_H_2real = abs(((TarH+(Targ_H/2)))* (XMAX/XGAIN) - H_OFFSET)-3000;//upper right H
	Volt_Targ_H_2real = (Volt_Targ_H_2real* 0.0003052) + 0.0000916; //this should be the actual voltage

	Volt_Targ_V_2real = abs(((TarV+(Targ_V/2)))* (YMAX/YGAIN) - V_OFFSET)-3000;//upper right V
	Volt_Targ_V_2real = (Volt_Targ_V_2real* 0.0003052) + 0.0000916; //this should be the actual voltage
	nexttick;

	if ((Volt_Fix_H_1real > 5) || (Volt_Fix_V_1real > 5) ||  (Volt_Fix_H_2real > 5) || (Volt_Fix_V_2real > 5) || (Volt_Targ_H_1real > 5) || (Volt_Targ_V_1real > 5) ||  (Volt_Targ_H_2real > 5) || (Volt_Targ_V_2real > 5))
	{
		 print("VOLTAGE OUT OF RANGE");
		 print("VOLTAGE OUT OF RANGE");
		 print("fix and target window values must be < 5V");
	}
	//MWL

	nexttick;
	/////////////////// 

	spawn SendTTLToRemoteSystem(2927);			   
	spawn SendTTLToRemoteSystem(REWARD_SIZE);			   
	nexttick;

	/////////////////////////////////////////////////////////
	//MODIFIED: 01-04-2007 EEE
	//		ADDED TRIAL NUMBER FOR TrialType_ variable in _m file to WRITE_PARAMS()
	// 		EVENT # 2928
	// 		THE NEXT EVENT IS THE VALUE OF THE TRIAL COUNTER NOTE THE TRIAL COUNTER RESETS
	// 		TO 0 AT THE BEGINNING OF EACH BLOCK
		spawn SendTTLToRemoteSystem(2928);			    
		spawn SendTTLToRemoteSystem(i);			   
	  	nexttick;
	/////////////////////////////////////////////////////////

	///////////////////////stimfile values //change by eee 06/30/05
	spawn SendTTLToRemoteSystem(7000);			    
	spawn SendTTLToRemoteSystem(eccen_Deg);  // 1
	spawn SendTTLToRemoteSystem(eccen_1);// 2   //MWL 10/5/06
	spawn SendTTLToRemoteSystem(eccen_2);// 3   //MWL 10/5/06
	spawn SendTTLToRemoteSystem(eccen_3);
	nexttick;
	spawn SendTTLToRemoteSystem(ang);   // 4
	spawn SendTTLToRemoteSystem(ang_2); // 5
	spawn SendTTLToRemoteSystem(ang_3); // 6
	//spawn SendTTLToRemoteSystem(eccen_1);// 7
	nexttick;
	
	// send penetration Info
	spawn SendTTLToRemoteSystem (2929);
	spawn SendTTLToRemoteSystem (GridEdge);
	spawn SendTTLToRemoteSystem (Dura);
	spawn SendTTLToRemoteSystem (Nchs);
	nexttick;
	if (Nchs>0)
	{
		spawn SendTTLToRemoteSystem (Impedance1);
		spawn SendTTLToRemoteSystem (ML1+8);
		spawn SendTTLToRemoteSystem (AP1+8);
		spawn SendTTLToRemoteSystem (Depth);
		nexttick;	
	}

	if (Nchs>1)
	{
		spawn SendTTLToRemoteSystem (Impedance2);
		spawn SendTTLToRemoteSystem (ML2+8);
		spawn SendTTLToRemoteSystem (AP2+8);
		spawn SendTTLToRemoteSystem (Depth);
		nexttick;
	}
	
	if (Nchs>2)
	{
		spawn SendTTLToRemoteSystem (Impedance3);
		spawn SendTTLToRemoteSystem (ML3+8);
		spawn SendTTLToRemoteSystem (AP3+8);
		spawn SendTTLToRemoteSystem (Depth);
		nexttick;
	}
	
	if (Nchs>3)
	{
		spawn SendTTLToRemoteSystem (Impedance4);
		spawn SendTTLToRemoteSystem (ML4+8);
		spawn SendTTLToRemoteSystem (AP4+8);
		spawn SendTTLToRemoteSystem (Depth);
		nexttick;
	}
	
	
}