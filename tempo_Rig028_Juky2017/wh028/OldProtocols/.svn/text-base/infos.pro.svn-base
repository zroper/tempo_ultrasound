
process WRITE_PARAMS_TEMPO()

///// SEND EVENTS TO TEMPO DATA BASE

{

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																													 //
//																													 //
//											            INFOS														 //
//																													 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 20 Columns...... and number of line = number of trials

 //1 NPOS Number of stimulus position 

 event_set(1,0,2721);
 nexttick;
 event_set(1,0,npos);
 nexttick;

  
 //2 Current POS of stimulus 

 event_set(1,0,2722);
 nexttick;
 event_set(1,0,trials[i]);
 nexttick;

 //// we could put here more information about the stimulus location

 //3 Flag wether use an acoustic stop signal (0 or 1) 0 by default 

 
 event_set(1,0,2723);
 nexttick;
 event_set(1,0,SOUND_S);
 nexttick;

  //4 Flag wether the current trial is no NOGO trial // Electrical stim parameter 


 event_set(1,0,2724);
 nexttick;
 event_set(1,0,ISNOT_NOGO);
 nexttick;
     
//5 Empty


 //6 Flag wether trigger is changed of color or not (0 = no by default) 

 event_set(1,0,2726);
 nexttick;
 event_set(1,0,TRIG_CHANGE);
 nexttick;

 //8 Fraction of rewarded trial 

 event_set(1,0,2728);
 nexttick;
 event_set(1,0,REWARD_RATIO);
 nexttick;

		  
 //9 fraction of NoGO trial  1/NOGO_RATIO = ratio of nogo e.g NOGO_RATIO=3 0.33 of STOP Trials

 event_set(1,0,2729);
 nexttick;
 event_set(1,0,NOGO_RATIO);
 nexttick;
	
 
 //10 Flag wether the current trial is a NOGO trial 1= GO 2=NOGO we added -1 to send 0 or 1 (conform to PDP coding)

 event_set(1,0,2730);
 nexttick;
 event_set(1,0,types[j]);
 nexttick;
		     
 //11 Time relative to the cue to Stim (+ or - time) we defined 700 as the origin (we can no send a negative number 

 event_set(1,0,2731);
 nexttick;
 event_set(1,0,npos);
 nexttick;
	   
 //12 Duration of the electric stimulation  

 event_set(1,0,2732);
 nexttick;
 event_set(1,0,npos);
 nexttick;
	

 //13 Flad wether retangular (0) or exponential (1) hold distribution  

 event_set(1,0,2733);
 nexttick;
 event_set(1,0,npos);
 nexttick;


 //14 Delay between TARGET ON and FIXATION OFF (=0 by default) 

 event_set(1,0,2734);
 nexttick;
 event_set(1,0,holdtime);
 nexttick;
		 
 //15 Hold time Jitter % of the total holdtime  

 event_set(1,0,2735);
 nexttick;
 event_set(1,0,frac_hold_jitter);
 nexttick;


 // 16 empty   

 //17 SOA of the current trial SSD 

 event_set(1,0,2737);
 nexttick;
 event_set(1,0,stop[s]);
 nexttick;
	 		  
 //18 Maximum SOA between the GO and NOGO cue 

 event_set(1,0,2738);
 nexttick;
 event_set(1,0,SSD_max);
 nexttick;

 
 //19 Minimum SOA between the GO and NOGO cue 

 event_set(1,0,2739);
 nexttick;
 event_set(1,0,SSD_min);
 nexttick;

	
 //20 SOA intervalls

 event_set(1,0,2740);
 nexttick;
 event_set(1,0,SSD_Step);
 nexttick;
			  
 //21 FixWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)  ATTENTION : we considered here that the fixation windows were placed in the center of the screen

 event_set(1,0,2770);
 nexttick;

	
//////////////// Lower left corner H coordinates
 
 event_set(1,0,abs(-Fix_H/2));
 nexttick;
 event_set(1,0,0);
 nexttick;

 	  
//////////////// Lower left corner V coordinates
 
 event_set(1,0,abs(-Fix_V/2));
 nexttick;
 event_set(1,0,0);
 nexttick;
		  	
 //////////////// Upper right corner H coordinates
 
 event_set(1,0,Fix_H/2);
 nexttick;
 event_set(1,0,2);
 nexttick;


//////////////// Upper right corner V coordinates
 
event_set(1,0,Fix_V/2);
nexttick;
event_set(1,0,2);
nexttick;
 		   

 //22 TARGWINDOW  Corner lower left (X,Y)... and Upper right (X,Y)

event_set(1,0,2771);
nexttick;
   

//////////////// Lower left corner H coordinates
 
event_set(1,0,abs((TARH-(Targ_H/2))));
nexttick;
 if ((TARH-(Targ_H/2))>=0)
 {
 
event_set(1,0,2);
nexttick;

 }
 if ((TARH-(Targ_H/2))<0)
 {
event_set(1,0,0);
nexttick;
 }


 
event_set(1,0,abs((TARH-(Targ_H/2))));
nexttick; 
if ((TARH-(Targ_H/2))>=0)
 {
event_set(1,0,2);
nexttick;
 }
 if ((TARH-(Targ_H/2))<0)
 {
event_set(1,0,0);
nexttick;
 }



//////////////// Lower left corner V coordinates
 
event_set(1,0,abs((TARV-(Targ_V/2))));
nexttick; 
 
 if ((TARV-(Targ_V/2))>=0)
 {
event_set(1,0,2);
nexttick;
 }
 if ((TARV-(Targ_V/2))<0)
 {
event_set(1,0,0);
nexttick; }

//////////////// Lower left corner H coordinates
 
 

 event_set(1,0,abs((TARH+(Targ_H/2))));
 nexttick;
 
 if ((TARH+(Targ_H/2))>=0)
 {
event_set(1,0,2);
nexttick;
 }
 if ((TARH+(Targ_H/2))<0)
 {
event_set(1,0,0);
nexttick;
 }
	
//////////////// Lower left corner V coordinates
 
 event_set(1,0,abs((TARV+(Targ_V/2))));
 nexttick;
    
if ((TARV+(Targ_V/2))>=0)
 {
event_set(1,0,2);
nexttick;
 }
 if ((TARV+(Targ_V/2))<0)
 {
event_set(1,0,0);
nexttick;
 } 


   
}


  // End of write parameters (TEMPO)

 
