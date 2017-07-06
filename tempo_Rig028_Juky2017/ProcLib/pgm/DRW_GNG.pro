//-----------------------------------------------------------------------------------
// process DRW_GNG(int changeStimulus);

// Prepares a checkered stimulus for each trial. The stimulus is comprised of 2 colors of
// checkered squares. The proportion of Go squares is randomly selected from
// an array of possible proportions (see goPropArray in DEFAULT.pro), and the Go
// squares are randomly placed within the checkered stimulus. The target gets defined by
// whether the proportion of Go squares is over or under 0.5.


// define constants
declare int		GoNoGoFlag;
declare int		Go = 0;
declare int		Nogo = 1;
declare float 	CheckerWidthDegrees, CheckerHeightDegrees;
	
declare DRW_GNG(int changeStimulus);

process DRW_GNG(int changeStimulus)
	{
	
	// stimtest variables
	declare int 	iSquare, iLevel, iGoSquare, iNoGoSquare, iRow, iColumn;
	declare int 	tempIndex, tempColor;
	declare int 	iSquareIndex;
	declare int 	iSquareColorChannel;
	declare int 	iSquareCenterX;
	declare int 	iSquareCenterY;
	declare int 	iSquareEccentricity;	
	declare int 	iSquareAngle;
	declare float 	iSquareULX, checkerULX;
	declare float 	iSquareULY, checkerULY;
	declare float 	iSquareLRX, checkerLRX;
	declare float 	iSquareLRY, checkerLRY;
	declare float 	nGoSquare, nNoGoSquare;
	declare float 	checkerOffsetX, checkerOffsetY;
	declare float 	checkerSizePixels;
	declare hide int r_, g_, b_;
	declare int		largeSquareColorR, largeSquareColorG, largeSquareColorB;
	declare int		smallSquareColorR, smallSquareColorG, smallSquareColorB;
	declare int 	iSquareColor[3]; //
	r_ = 0; g_ = 1; b_ = 2;			
		
	// Where on the screen is the stimulus in x,y coordinates (in pixels)?
	checkerOffsetX = checkerAmp * cos(checkerAngle) * Deg2Pix_X;
	checkerOffsety = checkerAmp * sin(checkerAngle) * Deg2Pix_Y;
	checkerSizePixels = iSquareSizePixels * nCheckerColumn;
	CheckerWidthDegrees = checkerSizePixels / Deg2Pix_X;
	CheckerHeightDegrees = checkerSizePixels / Deg2Pix_Y;
	
	// Calculate the dimensions of each checker square
	// iSquareWidthPixels = round(iSquareWidthDegrees * Deg2Pix_X);
	// iSquareHeightPixels = round(iSquareWidthDegrees * Deg2Pix_Y);
	
	
	if (changeStimulus == 1)
		{


		
		// TO MINIMIZE THE AMOUNT OF INFO SENT TO VIDEOSYNC, IF THE CHECKER STIMULUS
		// IS MOSTLY RED, START WITH A BIG RED SQUARE AND DRAW SMALL BLUE SQUARES.
		// LIKEWISE, IF THE CHECKER STIMULUS IS MOSTLY BLUE, START WITH A BIG BLUE 
		// SQUARE AND DRAW SMALL RED SQUARES
		
		
		if (GoNoGoFlag == NoGo)
			{
			// Set the large and small square colors:
			largeSquareColorR = NoGoSquareColor[0];
			largeSquareColorG = NoGoSquareColor[1];
			largeSquareColorB = NoGoSquareColor[2];
			smallSquareColorR = GoSquareColor[0];
			smallSquareColorG = GoSquareColor[1];
			smallSquareColorB = GoSquareColor[2];
			
			// Re-set all the squares to NoGo (zeros) each trial
			iSquare = 0;
			while (iSquare < nSquare)
				{
				checkerboardArray[iSquare] = NoGo;
				iSquare = iSquare + 1;			
				}
			// Calculate how many squares will be go on this trial
			nGoSquare = goPropArray[proportionIndex] * nSquare;
			
			// Fill checkerboardArray with as many ones as there will be go squares
			iNoGoSquare = 0;
			while (iNoGoSquare < nGoSquare)
				{
				checkerboardArray[iNoGoSquare] = go;
				iNoGoSquare = iNoGoSquare + 1;			
				}
			
			// Now randomly suffle sort the ones and zeros in the array
			iSquare = 0;
			while (iSquare < nSquare)
				{
				tempIndex = random(nSquare);
				tempColor = checkerboardArray[tempIndex];
				checkerboardArray[tempIndex] = checkerboardArray[iSquare];
				checkerboardArray[iSquare] = tempColor;
				iSquare = iSquare + 1;
				}
			}	
			
			
		if (GoNoGoFlag == Go)
			{
			// Set the large and small square colors:
			largeSquareColorR = GoSquareColor[0];
			largeSquareColorG = GoSquareColor[1];
			largeSquareColorB = GoSquareColor[2];
			smallSquareColorR = NoGoSquareColor[0];
			smallSquareColorG = NoGoSquareColor[1];
			smallSquareColorB = NoGoSquareColor[2];
			
			// Re-set all the squares to go (ones) each trial
			iSquare = 0;
			while (iSquare < nSquare)
				{
				checkerboardArray[iSquare] = Go;
				iSquare = iSquare + 1;			
				}
			// Calculate how many squares will be nogo on this trial
			nNoGoSquare = (1 - goPropArray[proportionIndex]) * nSquare;
			
			// Fill checkerboardArray with as many zeros as there will be go squares
			iGoSquare = 0;
			while (iGoSquare < nNoGoSquare)
				{
				checkerboardArray[iGoSquare] = NoGo;
				iGoSquare = iGoSquare + 1;			
				}
			
			// Now randomly suffle sort the ones and zeros in the array
			iSquare = 0;
			while (iSquare < nSquare)
				{
				tempIndex = random(nSquare);
				tempColor = checkerboardArray[tempIndex];
				checkerboardArray[tempIndex] = checkerboardArray[iSquare];
				checkerboardArray[iSquare] = tempColor;
				iSquare = iSquare + 1;
				}
			}	
								
		}
	


	
	// We have an array (checkerboardArray) with a proportional number go (1's) and nogo (0's) squares
	// Now we want to:
	// 1. Draw a large nogo square the targSize of the whole checkered stimulus
	// 2. Loop through and draw small go squares in their randomized positions
	
	// 1. Draw a large nogo square the targSize of the whole stimulus	
	// Determine the upper left and lower right of the large nogo square
	checkerULX = checkerOffsetX - checkerSizePixels/2;
	checkerULY = checkerOffsetY + checkerSizePixels/2;
	checkerLRX = checkerOffsetX + checkerSizePixels/2 - 1;
	checkerLRY = checkerOffsetY - checkerSizePixels/2 + 1;
			
	// Draw the large nogo iSquare
	iSquareColor[0] = largeSquareColorR;
	iSquareColor[1] = largeSquareColorG;
	iSquareColor[2] = largeSquareColorB;
	dsendf("cm 100 %d %d %d;\n",					// set the targColor of the large nogo square to 254
	iSquareColor[r_],			
	iSquareColor[g_],
	iSquareColor[b_]);
	iSquareColorChannel = 100;
	dsendf("co %d;\n", iSquareColorChannel);
	dsendf("rf %d,%d,%d,%d;\n", checkerULX, checkerULY, checkerLRX, checkerLRY);
	nexttick;

	
	
	
	// 2. Loop through and draw small go squares in their randomized positions
	iRow = 1;
	while (iRow <= nCheckerRow)
		{
		iColumn = 1;
		while (iColumn <= nCheckerColumn)
			{
			// Which targColor is the current square?
			iSquareIndex = iColumn + (nCheckerColumn * (iRow - 1)) - 1;
			// printf("iSquareIndex: %d   goNoGo: %d   %d   %d\n", iSquareIndex, checkerboardArray[iSquareIndex], m, n);
			if (GoNoGoFlag == NoGo)
				{
				if (checkerboardArray[iSquareIndex] == Go)
					{
					iSquareColor[0] = smallSquareColorR;
					iSquareColor[1] = smallSquareColorG;
					iSquareColor[2] = smallSquareColorB;
					dsendf("cm 101 %d %d %d;\n",					// set the targColor of the small go squares to 255
					iSquareColor[r_],			
					iSquareColor[g_],
					iSquareColor[b_]);
					iSquareColorChannel = 101;
					
					// Determine upper left and lower right coordinates of small go iSquare
					iSquareULX = checkerULX + iSquareSizePixels * (iColumn - 1);
					iSquareULY = checkerULY - iSquareSizePixels * (iRow - 1); 
					iSquareLRX = iSquareULX + (iSquareSizePixels - 1);
					iSquareLRY = iSquareULY - (iSquareSizePixels - 1);
				
					// Draw the current iSquare				
					dsendf("co %d;\n", iSquareColorChannel);
					dsendf("rf %d,%d,%d,%d;\n", iSquareULX, iSquareULY, iSquareLRX, iSquareLRY);
					}
				}
			else if (GoNoGoFlag == Go)
				{
				if (checkerboardArray[iSquareIndex] == NoGo)
					{
					iSquareColor[0] = smallSquareColorR;
					iSquareColor[1] = smallSquareColorG;
					iSquareColor[2] = smallSquareColorB;
					dsendf("cm 101 %d %d %d;\n",					// set the targColor of the small go squares to 255
					iSquareColor[r_],			
					iSquareColor[g_],
					iSquareColor[b_]);
					iSquareColorChannel = 101;
					
					// Determine upper left and lower right coordinates of small go iSquare
					iSquareULX = checkerULX + iSquareSizePixels * (iColumn - 1);
					iSquareULY = checkerULY - iSquareSizePixels * (iRow - 1); 
					iSquareLRX = iSquareULX + (iSquareSizePixels - 1);
					iSquareLRY = iSquareULY - (iSquareSizePixels - 1);
				
					// Draw the current iSquare				
					dsendf("co %d;\n", iSquareColorChannel);
					dsendf("rf %d,%d,%d,%d;\n", iSquareULX, iSquareULY, iSquareLRX, iSquareLRY);
					}
				}
			iColumn = iColumn + 1;								
			nexttick;				
			}
		iRow = iRow + 1;
		nexttick;
		}
		

	}

