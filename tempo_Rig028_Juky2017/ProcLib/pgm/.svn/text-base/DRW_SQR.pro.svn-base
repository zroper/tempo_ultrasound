//--------------------------------------------------------------------------------------------------
// process DRW_SQR(squareSize,squareAngle,squareAmp,squareColor,fill)
// Draw a square on the video sync screen
//
// INPUT
//	 squareSize         = how big do you want the square to be?  (must know your virtual coordiate system)
//	 squareAngle 		  = in cartesian coordinates
//   squareAmp = once again you must know your virtual coordiate system
//   squareColor        = squareColor of box (must know the current pallettes you are using)
//   fill         = 0 (no fill) or 1 (fill)
//   deg2pixX     = scaling factor to go between degrees and pixels (see SET_COOR.pro)
//   deg2pixY     = same as above
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare DRW_SQR(float squareSize, float squareAngle, float squareAmp, int squareColor, int fill, float conversion_X, float conversion_Y);

process DRW_SQR(float squareSize, float squareAngle, float squareAmp, int squareColor, int fill, float conversion_X, float conversion_Y)
	{
	declare hide float stim_ecc_x;
	declare hide float stim_ecc_y;
	declare hide float half_size;
	declare hide int ulx;
	declare hide int uly;
	declare hide int lrx;
	declare hide int lry;
	
	// find the center of the box in x and y space based on the squareAngle and squareAmp
	stim_ecc_x = cos(squareAngle) * squareAmp;
	stim_ecc_y = sin(squareAngle) * squareAmp;

	// find locations of upper left and lower right corners based on location of center and squareSize
	half_size = squareSize/2;
		ulx       = round((stim_ecc_x - half_size)*conversion_X);
		uly       = round((stim_ecc_y + half_size)*conversion_Y);
		lrx       = round((stim_ecc_x + half_size)*conversion_X);
		lry       = round((stim_ecc_y - half_size)*conversion_Y);

		//If the checkerboard serves as a target, the targets should be same squareSize as checkerboard
	// if (checkerIsTarg == 1)
		// {
		// half_size = iSquareSizePixels * nCheckerColumn / 2;
		// ulx       = round(stim_ecc_x*conversion_X - half_size);
		// uly       = round(stim_ecc_y *conversion_Y + half_size);
		// lrx       = round(stim_ecc_x*conversion_X + half_size);
		// lry       = round(stim_ecc_y*conversion_Y - half_size);
		// }

	
	// send video sync command to draw desired square
	dsendf("co %d;\n",squareColor);
	
	if(fill == 0)
		{
		dsendf("ru %d,%d,%d,%d;\n",ulx,uly,lrx,lry);
		}
	else
		{
		dsendf("rf %d,%d,%d,%d;\n",ulx,uly,lrx,lry);
		}

	}