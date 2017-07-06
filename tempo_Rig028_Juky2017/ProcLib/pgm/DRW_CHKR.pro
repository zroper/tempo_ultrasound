//-----------------------------------------------------------------------------------
// process DRW_CHKR(int changeStimulus);

// Prepares a checkered stimulus for each trial. The stimulus is comprised of blue and red
// checkered squares. The proportion of blue (and thus red) squares is randomly selected from
// an array of possible proportions (see BlueProportionArray in DEFAULT.pro), and the blue
// squares are randomly placed within the checkered stimulus. The target gets defined by
// whether the proportion of Blue squares is over or under 0.5.


// define constants
declare float 	CheckerWidthDegrees, CheckerHeightDegrees;
	
declare DRW_CHKR(int changeStimulus);

process DRW_CHKR(int changeStimulus)
	{
	
	// stimtest variables
	declare int 	iSquare, iLevel, iRow, iColumn;
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
	declare int 	nTarg1Square, nTarg2Square;
	declare float 	checkerOffsetX, checkerOffsetY;
	declare float 	checkerSizePixels;
	declare hide int r_, g_, b_;
	declare int		largeSquareColorR, largeSquareColorG, largeSquareColorB;
	declare int		smallSquareColorR, smallSquareColorG, smallSquareColorB;
	declare int 	iSquareColor[3]; //
	declare int 	iChecker, nTarg2, nTarg1; //
	declare int		majorityColor, minorityColor; 
	declare float   nMinority, nRowRemain, nMax, nMin;
	declare int 	randInsert, nInsert;
	declare float 	minorityP;
	
	r_ = 0; g_ = 1; b_ = 2;			
		
	// Where on the screen is the stimulus in x,y coordinates (in pixels)?
	checkerOffsetX = checkerAmp * cos(checkerAngle) * Deg2Pix_X;
	checkerOffsety = checkerAmp * sin(checkerAngle) * Deg2Pix_Y;
	checkerSizePixels = iSquareSizePixels * nCheckerColumn;
	CheckerWidthDegrees = checkerSizePixels / Deg2Pix_X;
	CheckerHeightDegrees = checkerSizePixels / Deg2Pix_Y;
	
	// oMove(object_checker, checkerOffsetX*deg2pix_X, checkerOffsety*deg2pix_Y);								// ...and move the animated graph object there.
	// oSetAttribute(object_checker, aSIZE, checkerSizePixels/deg2pix_x, checkerSizePixels/deg2pix_y);							// while we are at it, resize fixation object on animated graph

	
	if (changeStimulus == 1)
		{

		// TO MINIMIZE THE AMOUNT OF INFO SENT TO VIDEOSYNC, IF THE CHECKER STIMULUS
		// IS MOSTLY Targ2, START WITH A BIG Targ2 SQUARE AND DRAW SMALL Targ1-targColor SQUARES.
		// LIKEWISE, IF THE CHECKER STIMULUS IS MOSTLY Targ1, START WITH A BIG Targ1-targColor 
		// SQUARE AND DRAW SMALL Targ2-targColor SQUARES
		
		// *************   USE THE FOLLOWING LINES OF CODE WITH CHKRSTIM.PRO TO TEST LUMINANCE, ETC    **********
		// targIndex = Targ1;  // for testing
		// proportionIndex = 0;  // Use this with target1ProportionArrya for testing luminance
		// targIndex = Targ2;  // for testing
		// proportionIndex = 1;  // Use this with target1ProportionArrya for testing luminance
		// **************************************************************************************************************
		if (targIndex == Targ1 || targIndex == Targ1+2)
			{
			majorityColor = 0;
			minorityColor = 1;
			minorityP     = 1.0 - targ1PropArray[proportionIndex];
			// Set the large and small square colors:
			largeSquareColorR = Targ1SquareColor[0];
			largeSquareColorG = Targ1SquareColor[1];
			largeSquareColorB = Targ1SquareColor[2];
			smallSquareColorR = Targ2SquareColor[0];
			smallSquareColorG = Targ2SquareColor[1];
			smallSquareColorB = Targ2SquareColor[2];
			}
		else if (targIndex == Targ2 || targIndex == Targ2+2)
			{
			majorityColor = 1;
			minorityColor = 0;
			minorityP     = targ1PropArray[proportionIndex];
			// Set the large and small square colors:
			smallSquareColorR = Targ1SquareColor[0];
			smallSquareColorG = Targ1SquareColor[1];
			smallSquareColorB = Targ1SquareColor[2];
			largeSquareColorR = Targ2SquareColor[0];
			largeSquareColorG = Targ2SquareColor[1];
			largeSquareColorB = Targ2SquareColor[2];
			}
			
		// Initialize all checkers to majority (target) color
		iSquare = 0;
		while (iSquare < nSquare)
			{
			checkerboardArray[iSquare] = majorityColor;
			iSquare = iSquare + 1;			
			}
		
		nRowRemain = nCheckerRow;
		nMinority = round(minorityP * nSquare);
		nMax = ceil(nMinority / nRowRemain);
		nMin = floor(nMinority / nRowRemain);
		
		iRow = 1;
		while (iRow <= nCheckerRow)
			{
			
			// Choose the number of minority color checkers to insert in the row
			randInsert = random(2);
			if (randInsert == 0)
				nInsert = nMax;
			else if (randInsert == 1)
				nInsert = nMin;
				
			// Fill row with minority checkers	
			iColumn = 1;
			while (iColumn <= nInsert)
				{
				iSquare = (iRow-1) * nCheckerColumn + (iColumn-1);
				checkerboardArray[iSquare] = minorityColor;
				iColumn = iColumn + 1;
				}
			// Randomly shuffle the ones and zeros within the row
			iColumn = 1;
			while (iColumn <= nCheckerColumn)
				{
				iSquare = (iRow-1) * nCheckerColumn + (iColumn-1);
				tempIndex = (iRow-1) * nCheckerColumn + random(nCheckerColumn);
				tempColor = checkerboardArray[tempIndex];
				checkerboardArray[tempIndex] = checkerboardArray[iSquare];
				checkerboardArray[iSquare] = tempColor;
				iColumn = iColumn + 1;
				}
			// Update the variables used to caclulate how many minority color checkers will go into the next row
			nRowRemain = nRowRemain - 1;
			nMinority = nMinority - nInsert;
			nMax = ceil(nMinority / nRowRemain);
			nMin = floor(nMinority / nRowRemain);
			
			iRow = iRow + 1;
			}
			
			
			
		/*	
			// Re-set all the squares to Targ2 (ones) each trial
			iSquare = 0;
			while (iSquare < nSquare)
				{
				checkerboardArray[iSquare] = Targ2;
				iSquare = iSquare + 1;			
				}
			// Calculate how many squares will be Targ1 on this trial
			nTarg1Square = round(targ1PropArray[proportionIndex] * nSquare);
			nTarg2Square = round((1 - targ1PropArray[proportionIndex]) * nSquare);
	// printf("      nTarg1 nTarg2:  = %d \t %d\n", nTarg1Square, nTarg2Square);

			// Fill checkerboardArray with as many zeros as there will be Targ1 squares
			iSquare = 0;
			while (iSquare < nTarg1Square)
				{
				checkerboardArray[iSquare] = Targ1;
				iSquare = iSquare + 1;			
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

				
			
		if (targIndex == Targ1 || targIndex == Targ1+2)
			{
			// Set the large and small square colors:
			largeSquareColorR = Targ1SquareColor[0];
			largeSquareColorG = Targ1SquareColor[1];
			largeSquareColorB = Targ1SquareColor[2];
			smallSquareColorR = Targ2SquareColor[0];
			smallSquareColorG = Targ2SquareColor[1];
			smallSquareColorB = Targ2SquareColor[2];
			
			// Re-set all the squares to Targ1 (zeros) each trial
			iSquare = 0;
			while (iSquare < nSquare)
				{
				checkerboardArray[iSquare] = Targ1;
				iSquare = iSquare + 1;			
				}
			// Calculate how many squares will be Targ2 on this trial
			nTarg1Square = round(targ1PropArray[proportionIndex] * nSquare);
			nTarg2Square = round((1 - targ1PropArray[proportionIndex]) * nSquare);
	// printf("      nTarg1 nTarg2:  = %d \t %d\n", nTarg1Square, nTarg2Square);

			// Fill checkerboardArray with as many ones as there will be Targ2 squares
			iSquare = 0;
			while (iSquare < nTarg2Square)
				{
				checkerboardArray[iSquare] = Targ2;
				iSquare = iSquare + 1;			
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
		*/						
		}
	


	
	// We have an array (checkerboardArray) with a proportional number Targ1 (0's) and Targ2 (1's) squares
	// Now we want to:
	// 1. Draw a large square the targSize of the whole checkered stimulus, the targColor of the correct target direction
	// 2. Loop through and draw small Targ1 squares in their randomized positions, the targColor of the incorrect target direction
	
	// 1. Draw a large square the targSize of the whole stimulus	
	// Determine the upper left and lower right of the large square
	checkerULX = checkerOffsetX - checkerSizePixels/2;
	checkerULY = checkerOffsetY + checkerSizePixels/2;
	checkerLRX = checkerOffsetX + checkerSizePixels/2 - 1;
	checkerLRY = checkerOffsetY - checkerSizePixels/2 + 1;
			
	// Draw the large square
	iSquareColor[0] = largeSquareColorR;
	iSquareColor[1] = largeSquareColorG;
	iSquareColor[2] = largeSquareColorB;
	dsendf("cm 100 %d %d %d;\n",					// set the targColor of the large square to 100
	iSquareColor[r_],			
	iSquareColor[g_],
	iSquareColor[b_]);
	iSquareColorChannel = 100;
	dsendf("co %d;\n", iSquareColorChannel);
	dsendf("rf %d,%d,%d,%d;\n", checkerULX, checkerULY, checkerLRX, checkerLRY);
	nexttick;

	
	
	
	// 2. Loop through and draw small minority color squares in their randomized positions
	iRow = 1;
	while (iRow <= nCheckerRow)
		{
		iColumn = 1;
		while (iColumn <= nCheckerColumn)
			{
			// Which targColor is the current square?
			iSquareIndex = iColumn + (nCheckerColumn * (iRow - 1)) - 1;
			// printf("iSquareIndex: %d   blueRed: %d   \n", iSquareIndex, checkerboardArray[iSquareIndex]);
			// if (targIndex == Targ2 || targIndex == Targ2+2)
				// {
				if (checkerboardArray[iSquareIndex] == minorityColor)
					{
					iSquareColor[0] = smallSquareColorR;
					iSquareColor[1] = smallSquareColorG;
					iSquareColor[2] = smallSquareColorB;
					dsendf("cm 101 %d %d %d;\n",					// set the targColor of the small Targ1 squares to 101
					iSquareColor[r_],			
					iSquareColor[g_],
					iSquareColor[b_]);
					iSquareColorChannel = 101;
					
					// Determine upper left and lower right coordinates of small Targ1 iSquare
					iSquareULX = checkerULX + iSquareSizePixels * (iColumn - 1);
					iSquareULY = checkerULY - iSquareSizePixels * (iRow - 1); 
					iSquareLRX = iSquareULX + (iSquareSizePixels - 1);
					iSquareLRY = iSquareULY - (iSquareSizePixels - 1);
				
					// Draw the current iSquare				
					dsendf("co %d;\n", iSquareColorChannel);
					dsendf("rf %d,%d,%d,%d;\n", iSquareULX, iSquareULY, iSquareLRX, iSquareLRY);
					}
/*				}
			else if (targIndex == Targ1)
				{
				if (checkerboardArray[iSquareIndex] == Targ2 || checkerboardArray[iSquareIndex]  == Targ2+2)
					{
					iSquareColor[0] = smallSquareColorR;
					iSquareColor[1] = smallSquareColorG;
					iSquareColor[2] = smallSquareColorB;
					dsendf("cm 101 %d %d %d;\n",					// set the targColor of the small Targ1 squares to 101
					iSquareColor[r_],			
					iSquareColor[g_],
					iSquareColor[b_]);
					iSquareColorChannel = 101;
					
					// Determine upper left and lower right coordinates of small Targ1 iSquare
					iSquareULX = checkerULX + iSquareSizePixels * (iColumn - 1);
					iSquareULY = checkerULY - iSquareSizePixels * (iRow - 1); 
					iSquareLRX = iSquareULX + (iSquareSizePixels - 1);
					iSquareLRY = iSquareULY - (iSquareSizePixels - 1);
				
					// Draw the current iSquare				
					dsendf("co %d;\n", iSquareColorChannel);
					dsendf("rf %d,%d,%d,%d;\n", iSquareULX, iSquareULY, iSquareLRX, iSquareLRY);
					}
				} */
			iColumn = iColumn + 1;								
			nexttick 2;				
			}
		iRow = iRow + 1;
		nexttick 2;
		}
		

	}

