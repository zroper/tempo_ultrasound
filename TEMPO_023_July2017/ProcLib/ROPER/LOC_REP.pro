//--------------------------------------------------------------------------------------------
// This code selects REPEATED array locations 
// 
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013


//declare hide int 	pos_jitter = 10;   //  1-15 pixels position jitter 
declare hide int	numAngles = 12;
declare hide int	numEcc = 12; 

//Move to ALLVARS.pro
	declare R1_targ_angle;
	declare R1_d1_angle;
	declare R1_d2_angle;
	declare R1_d3_angle;
	declare R1_d4_angle;
	declare R1_d5_angle;
	declare R1_d6_angle;
	declare R1_d7_angle;
	declare R1_d8_angle;
	declare R1_d9_angle;
	declare R1_d10_angle;
	declare R1_d11_angle;
	
	declare R1_targ_ecc;
	declare R1_d1_ecc;
	declare R1_d2_ecc;
	declare R1_d3_ecc;
	declare R1_d4_ecc;
	declare R1_d5_ecc;
	declare R1_d6_ecc;
	declare R1_d7_ecc;
	declare R1_d8_ecc;
	declare R1_d9_ecc;
	declare R1_d10_ecc;
	declare R1_d11_ecc;
	
	declare R2_targ_angle;
	declare R2_d1_angle;
	declare R2_d2_angle;
	declare R2_d3_angle;
	declare R2_d4_angle;
	declare R2_d5_angle;
	declare R2_d6_angle;
	declare R2_d7_angle;
	declare R2_d8_angle;
	declare R2_d9_angle;
	declare R2_d10_angle;
	declare R2_d11_angle;

	declare R2_targ_ecc;
	declare R2_d1_ecc;
	declare R2_d2_ecc;
	declare R2_d3_ecc;
	declare R2_d4_ecc;
	declare R2_d5_ecc;
	declare R2_d6_ecc;
	declare R2_d7_ecc;
	declare R2_d8_ecc;
	declare R2_d9_ecc;
	declare R2_d10_ecc;
	declare R2_d11_ecc;	
	
	declare R3_targ_angle;
	declare R3_d1_angle;
	declare R3_d2_angle;
	declare R3_d3_angle;
	declare R3_d4_angle;
	declare R3_d5_angle;
	declare R3_d6_angle;
	declare R3_d7_angle;
	declare R3_d8_angle;
	declare R3_d9_angle;
	declare R3_d10_angle;
	declare R3_d11_angle;
	
	declare R3_targ_ecc;
	declare R3_d1_ecc;
	declare R3_d2_ecc;
	declare R3_d3_ecc;
	declare R3_d4_ecc;
	declare R3_d5_ecc;
	declare R3_d6_ecc;
	declare R3_d7_ecc;
	declare R3_d8_ecc;
	declare R3_d9_ecc;
	declare R3_d10_ecc;
	declare R3_d11_ecc;	
 	
	declare R4_targ_angle;
	declare R4_d1_angle;
	declare R4_d2_angle;
	declare R4_d3_angle;
	declare R4_d4_angle;
	declare R4_d5_angle;
	declare R4_d6_angle;
	declare R4_d7_angle;
	declare R4_d8_angle;
	declare R4_d9_angle;
	declare R4_d10_angle;
	declare R4_d11_angle;	

	declare R4_targ_ecc;
	declare R4_d1_ecc;
	declare R4_d2_ecc;
	declare R4_d3_ecc;
	declare R4_d4_ecc;
	declare R4_d5_ecc;
	declare R4_d6_ecc;
	declare R4_d7_ecc;
	declare R4_d8_ecc;
	declare R4_d9_ecc;
	declare R4_d10_ecc;
	declare R4_d11_ecc;
	
	declare R5_targ_angle;
	declare R5_d1_angle;
	declare R5_d2_angle;
	declare R5_d3_angle;
	declare R5_d4_angle;
	declare R5_d5_angle;
	declare R5_d6_angle;
	declare R5_d7_angle;
	declare R5_d8_angle;
	declare R5_d9_angle;
	declare R5_d10_angle;
	declare R5_d11_angle;
	
	declare R5_targ_ecc;
	declare R5_d1_ecc;
	declare R5_d2_ecc;
	declare R5_d3_ecc;
	declare R5_d4_ecc;
	declare R5_d5_ecc;
	declare R5_d6_ecc;
	declare R5_d7_ecc;
	declare R5_d8_ecc;
	declare R5_d9_ecc;
	declare R5_d10_ecc;
	declare R5_d11_ecc;

	declare R6_targ_angle;
	declare R6_d1_angle;
	declare R6_d2_angle;
	declare R6_d3_angle;
	declare R6_d4_angle;
	declare R6_d5_angle;
	declare R6_d6_angle;
	declare R6_d7_angle;
	declare R6_d8_angle;
	declare R6_d9_angle;
	declare R6_d10_angle;
	declare R6_d11_angle;
	
	declare R6_targ_ecc;
	declare R6_d1_ecc;
	declare R6_d2_ecc;
	declare R6_d3_ecc;
	declare R6_d4_ecc;
	declare R6_d5_ecc;
	declare R6_d6_ecc;
	declare R6_d7_ecc;
	declare R6_d8_ecc;
	declare R6_d9_ecc;
	declare R6_d10_ecc;
	declare R6_d11_ecc;

declare RandomizeAngles();
declare RandomizeEccentricities();

declare REP1_LOC();
declare REP2_LOC();
declare REP3_LOC();
declare REP4_LOC();
declare REP5_LOC();
declare REP6_LOC();
// declare REP7_LOC();
// declare REP8_LOC();


declare LOC_REP();


	
process LOC_REP
	{
	spawn RandomizeAngles;
	spawn RandomizeEccentricities;
	spawn REP1_LOC;
	spawn REP2_LOC;
	spawn REP3_LOC;
	spawn REP4_LOC;
	spawn REP5_LOC;
	spawn REP6_LOC;
	}

process RandomizeAngles() 
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numAngles)			//Run loop while i < total # items in locX array
		{
		j = random(numAngles) ; 			//randomly select one of six positions in X location array
		temp = Ang_list[i];			//stick one of the other locations in temp
		Ang_list[i] = Ang_list[j];
		Ang_list[j] = temp;
		i = i + 1;
		}
	}	

process RandomizeEccentricities()	
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numEcc)			//Run loop while i < total # items in locX array
		{
		j = random(numEcc); 			//randomly select one of six positions in X location array
		temp = Ecc_list[i];			//stick one of the other locations in temp
		Ecc_list[i] = Ecc_list[j];
		Ecc_list[j] = temp;
		i = i + 1;
		}
	}	
		


		
		
	process REP1_LOC  // Select repeated array 1 locations
		{ 	
			
		spawn RandomizeAngles;                         // Runs RandomizeXLocations
		waitforprocess RandomizeAngles;                // Waits for it to finish
		
		spawn RandomizeEccentricities;                         // Runs RandomizeYLocations
		waitforprocess RandomizeEccentricities;                // Waits for it to finish
		
		
		R1_targ_angle = Ang_list[0];					
		R1_d1_angle = Ang_list[1];
		R1_d2_angle = Ang_list[2];
		R1_d3_angle = Ang_list[3];
		R1_d4_angle = Ang_list[4];
		R1_d5_angle = Ang_list[5];
		R1_d6_angle = Ang_list[6];
		R1_d7_angle = Ang_list[7];
		R1_d8_angle = Ang_list[8];
		R1_d9_angle = Ang_list[9];
		R1_d10_angle = Ang_list[10];
		R1_d11_angle = Ang_list[11];
		
		
		R1_targ_ecc = Ecc_List[0];
		R1_d1_ecc = Ecc_List[1];
		R1_d2_ecc = Ecc_List[2];
		R1_d3_ecc = Ecc_List[3];
		R1_d4_ecc = Ecc_List[4];
		R1_d5_ecc = Ecc_List[5];
		R1_d6_ecc = Ecc_List[6];
		R1_d7_ecc = Ecc_List[7];
		R1_d8_ecc = Ecc_List[8];
		R1_d9_ecc = Ecc_List[9];
		R1_d10_ecc = Ecc_List[10];
		R1_d11_ecc = Ecc_List[11];
		
		}	

	process REP2_LOC
		{ 
		
		spawn RandomizeAngles;                         // Runs RandomizeXLocations
		waitforprocess RandomizeAngles;                // Waits for it to finish
		
		spawn RandomizeEccentricities;                         // Runs RandomizeYLocations
		waitforprocess RandomizeEccentricities;                // Waits for it to finish
		
		
		R2_targ_angle = Ang_list[0];					
		R2_d1_angle = Ang_list[1];
		R2_d2_angle = Ang_list[2];
		R2_d3_angle = Ang_list[3];
		R2_d4_angle = Ang_list[4];
		R2_d5_angle = Ang_list[5];
		R2_d6_angle = Ang_list[6];
		R2_d7_angle = Ang_list[7];
		R2_d8_angle = Ang_list[8];
		R2_d9_angle = Ang_list[9];
		R2_d10_angle = Ang_list[10];
		R2_d11_angle = Ang_list[11];
		
		
		R2_targ_ecc = Ecc_List[0];
		R2_d1_ecc = Ecc_List[1];
		R2_d2_ecc = Ecc_List[2];
		R2_d3_ecc = Ecc_List[3];
		R2_d4_ecc = Ecc_List[4];
		R2_d5_ecc = Ecc_List[5];
		R2_d6_ecc = Ecc_List[6];
		R2_d7_ecc = Ecc_List[7];
		R2_d8_ecc = Ecc_List[8];
		R2_d9_ecc = Ecc_List[9];
		R2_d10_ecc = Ecc_List[10];
		R2_d11_ecc = Ecc_List[11];
		
		
		}	

	process REP3_LOC
		{

		spawn RandomizeAngles;                         // Runs RandomizeXLocations
		waitforprocess RandomizeAngles;                // Waits for it to finish
		
		spawn RandomizeEccentricities;                         // Runs RandomizeYLocations
		waitforprocess RandomizeEccentricities;                // Waits for it to finish
		
		
		R3_targ_angle = Ang_list[0];					
		R3_d1_angle = Ang_list[1];
		R3_d2_angle = Ang_list[2];
		R3_d3_angle = Ang_list[3];
		R3_d4_angle = Ang_list[4];
		R3_d5_angle = Ang_list[5];
		R3_d6_angle = Ang_list[6];
		R3_d7_angle = Ang_list[7];
		R3_d8_angle = Ang_list[8];
		R3_d9_angle = Ang_list[9];
		R3_d10_angle = Ang_list[10];
		R3_d11_angle = Ang_list[11];
		
		R3_targ_ecc = Ecc_List[0];
		R3_d1_ecc = Ecc_List[1];
		R3_d2_ecc = Ecc_List[2];
		R3_d3_ecc = Ecc_List[3];
		R3_d4_ecc = Ecc_List[4];
		R3_d5_ecc = Ecc_List[5];
		R3_d6_ecc = Ecc_List[6];
		R3_d7_ecc = Ecc_List[7];
		R3_d8_ecc = Ecc_List[8];
		R3_d9_ecc = Ecc_List[9];
		R3_d10_ecc = Ecc_List[10];
		R3_d11_ecc = Ecc_List[11];
		
		}	
		
	process REP4_LOC
		{ 

		spawn RandomizeAngles;                         // Runs RandomizeXLocations
		waitforprocess RandomizeAngles;                // Waits for it to finish
		
		spawn RandomizeEccentricities;                         // Runs RandomizeYLocations
		waitforprocess RandomizeEccentricities;                // Waits for it to finish
		
		
		R4_targ_angle = Ang_list[0];					
		R4_d1_angle = Ang_list[1];
		R4_d2_angle = Ang_list[2];
		R4_d3_angle = Ang_list[3];
		R4_d4_angle = Ang_list[4];
		R4_d5_angle = Ang_list[5];
		R4_d6_angle = Ang_list[6];
		R4_d7_angle = Ang_list[7];
		R4_d8_angle = Ang_list[8];
		R4_d9_angle = Ang_list[9];
		R4_d10_angle = Ang_list[10];
		R4_d11_angle = Ang_list[11];
		
		
		R4_targ_ecc = Ecc_List[0];
		R4_d1_ecc = Ecc_List[1];
		R4_d2_ecc = Ecc_List[2];
		R4_d3_ecc = Ecc_List[3];
		R4_d4_ecc = Ecc_List[4];
		R4_d5_ecc = Ecc_List[5];
		R4_d6_ecc = Ecc_List[6];
		R4_d7_ecc = Ecc_List[7];
		R4_d8_ecc = Ecc_List[8];
		R4_d9_ecc = Ecc_List[9];
		R4_d10_ecc = Ecc_List[10];
		R4_d11_ecc = Ecc_List[11];
		
		}	
		
	process REP5_LOC
		{ 
		
		spawn RandomizeAngles;                         // Runs RandomizeXLocations
		waitforprocess RandomizeAngles;                // Waits for it to finish
		
		spawn RandomizeEccentricities;                         // Runs RandomizeYLocations
		waitforprocess RandomizeEccentricities;                // Waits for it to finish
		
		
		R5_targ_angle = Ang_list[0];					
		R5_d1_angle = Ang_list[1];
		R5_d2_angle = Ang_list[2];
		R5_d3_angle = Ang_list[3];
		R5_d4_angle = Ang_list[4];
		R5_d5_angle = Ang_list[5];
		R5_d6_angle = Ang_list[6];
		R5_d7_angle = Ang_list[7];
		R5_d8_angle = Ang_list[8];
		R5_d9_angle = Ang_list[9];
		R5_d10_angle = Ang_list[10];
		R5_d11_angle = Ang_list[11];
		
		R5_targ_ecc = Ecc_List[0];
		R5_d1_ecc = Ecc_List[1];
		R5_d2_ecc = Ecc_List[2];
		R5_d3_ecc = Ecc_List[3];
		R5_d4_ecc = Ecc_List[4];
		R5_d5_ecc = Ecc_List[5];
		R5_d6_ecc = Ecc_List[6];
		R5_d7_ecc = Ecc_List[7];
		R5_d8_ecc = Ecc_List[8];
		R5_d9_ecc = Ecc_List[9];
		R5_d10_ecc = Ecc_List[10];
		R5_d11_ecc = Ecc_List[11];
		
		}	
		
	process REP6_LOC
		{ 	
		

		
		spawn RandomizeAngles;                         // Runs RandomizeXLocations
		waitforprocess RandomizeAngles;                // Waits for it to finish
		
		spawn RandomizeEccentricities;                         // Runs RandomizeYLocations
		waitforprocess RandomizeEccentricities;                // Waits for it to finish
		
		
		R6_targ_angle = Ang_list[0];					
		R6_d1_angle = Ang_list[1];
		R6_d2_angle = Ang_list[2];
		R6_d3_angle = Ang_list[3];
		R6_d4_angle = Ang_list[4];
		R6_d5_angle = Ang_list[5];
		R6_d6_angle = Ang_list[6];
		R6_d7_angle = Ang_list[7];
		R6_d8_angle = Ang_list[8];
		R6_d9_angle = Ang_list[9];
		R6_d10_angle = Ang_list[10];
		R6_d11_angle = Ang_list[11];
		
		R6_targ_ecc = Ecc_List[0];
		R6_d1_ecc = Ecc_List[1];
		R6_d2_ecc = Ecc_List[2];
		R6_d3_ecc = Ecc_List[3];
		R6_d4_ecc = Ecc_List[4];
		R6_d5_ecc = Ecc_List[5];
		R6_d6_ecc = Ecc_List[6];
		R6_d7_ecc = Ecc_List[7];
		R6_d8_ecc = Ecc_List[8];
		R6_d9_ecc = Ecc_List[9];
		R6_d10_ecc = Ecc_List[10];
		R6_d11_ecc = Ecc_List[11];
		
		}		

	
	
	
	