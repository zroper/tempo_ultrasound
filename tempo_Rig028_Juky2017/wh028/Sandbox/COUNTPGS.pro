#pragma declare = 1;

declare int curr_target = 0;
declare float fixation_size = 3.0;
declare int stop_sig_color = 14;
declare int distract_color = 13;
declare int i = 0;
declare int pg_num = 1;

#include C:/TEMPO/ProcLib/RIGSETUP.pro
#include C:/TEMPO/ProcLib/SET_COOR.pro
#include C:/TEMPO/ProcLib/TONE.pro
#include C:/TEMPO/ProcLib/DRW_SQR.pro
#include C:/TEMPO/ProcLib/CMD_PGS.pro


declare MAIN();

declare SETUP_PAGES(int numPages);

process MAIN() enabled
	{
	int numPages,currentPage;
	
	numPages = 8;
	currentPage = 0;
	
	// set to video mode
	dsend("vi 256;");
	
	dsend("ca");
	wait 5000; //it can take up to 5 seconds to clear all vdo sync memory (pg 7-37)
	spawnwait SET_COOR(scr_width, scr_height, subj_dist);
	
	spawnwait SETUP_PAGES(numPages);

	
	// set visible page to page 0
	dsendf("vp 0\n");
	
	while(1)
		{
				dsendf("vp %d;\n",currentPage);
				printf("viewing page %d\n",currentPage);
				currentPage = currentPage + 1;
				if (currentPage == numPages)
				{
					currentPage = 0;
				}
				nexttick;
				wait 1000;
		}
	}

	
	process SETUP_PAGES(int numPages)
	{
		int thisPageNum;
		
		thisPageNum = 0;
		
		while (thisPageNum < numPages)
		{
			// set read write page
			dsendf("rw %d,%d;\n",thisPageNum,thisPageNum);
			
			// clear page
			dsendf("cl;\n");
			
			// set color
			dsendf("co %d;\n",thisPageNum + 1);
			
			// draw a filled rect
			dsendf("rf 0,0,100,100;\n",thisPageNum);
			
			printf("setup page num %d\n",thisPageNum);
			
			thisPageNum = thisPageNum + 1;
			
			nexttick;
		}
	}