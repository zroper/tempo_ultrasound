//Experiment Parameter setup!
//It sets up importatnt stimuli parameters (e.g. locations and colors)
//For the experiment

declare VWMParam();

declare Color_Selection();			    /* Choose color values */
declare SameDiff_Selection();			    /* Choose color values */
declare Location_Selection();			    /* Choose location values */
declare Setsize_Selection();			    /* Choose Setsize values */

declare setsize = 0;
declare samediff = 0;
declare tlocs[8,2];
declare tcolors[7];

process VWMParam
	{
	spawn Setsize_Selection;
	nexttick;
	spawn SameDiff_Selection;
	nexttick;
	spawn Location_Selection;
	nexttick;
	spawn Color_Selection;
	nexttick;
	
	}
	
//Component Processes!////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

process Location_Selection
	{
	//Set Stimulus Locations Declaration comes first!!!!!!!!!!!!!!!!!!!
	declare loc_indecies[8];
	declare loc_index = 0;
	declare temp_loc = 0;
	declare norepetition = 1;
	declare loc = 0;
	
	
	//initialize the array!

	loc_indecies[0] = 99;
	loc_indecies[1] = 99;
	loc_indecies[2] = 99;
	loc_indecies[3] = 99;
	loc_indecies[4] = 99;
	loc_indecies[5] = 99;
	loc_indecies[6] = 99;
	loc_indecies[7] = 99;
	
	
	loc = 0;
	while (loc <numLocs)
		{
		loc_index = random(4);//original was 8
		temp_loc = 0;
		norepetition = 1;
		
		while (temp_loc <numLocs)
			{
			if (loc_index ==loc_indecies[temp_loc])
				{
				norepetition = 0;
				}
			temp_loc = temp_loc+1;
			}
		if (norepetition == 1)
			{
			loc_indecies[loc]=loc_index;
			//tlocs[loc,0]= Locs[loc_index,0];
			//tlocs[loc,1]= Locs[loc_index,1];
			loc = loc+1;
			}
		
		}
	nexttick; 
	}
	


process Setsize_Selection
	{
	//declare setsizes[5]={1,2,3,4,6};
	declare setsizes[5]={1,1,1,1,1};
	declare setsize_index;
	
	
	//initialize the array!
	setsizes[0] = 1;
	setsizes[1] = 1;
	setsizes[2] = 1;
	setsizes[3] = 1;
	setsizes[4] = 1;
	setsize_index = random(5);
	//printf("setsize=%d\n",setsize_index);
	setsize = setsizes[setsize_index];
	}
	
process SameDiff_Selection
	{
	declare samediffs[2] = {1,2};
	declare samediff_index;
	samediff_index = random(2);
	samediff = samediffs[samediff_index];
	}
		

		

	
process Color_Selection
	{
	//Set Stimulus COlors
	declare color_indecies[7] = {99,99,99,99,99,99,99};
	declare color_index = 0;
	declare temp_color = 0;
	declare norepetition = 1;
	declare color = 0;

	//initialize the array!
	color_indecies[0] = 99;
	color_indecies[1] = 99;
	color_indecies[2] = 99;
	color_indecies[3] = 99;
	color_indecies[4] = 99;
	color_indecies[5] = 99;
	color_indecies[6] = 99;
	
	color = 0;
	while (color < numColors)
		{
		color_index = random(7);
		temp_color = 0;
		norepetition = 1;
		while (temp_color < numColors)
			{
			if (color_index ==color_indecies[temp_color])
				{
				norepetition = 0;
				}
			temp_color = temp_color+1;
			}
		if (norepetition == 1)
			{
			color_indecies[color]=color_index;
			tcolors[color]= Colors[color_index];
			color = color+1;
			}
		
		}
	nexttick; 
	}
