// This sets all of the colors up which will be needed for the protocol based on user input
// specified elsewhere
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare SET_CLRS();

process SET_CLRS()
	{
	declare hide int color_num, r_, g_, b_;
	r_ = 0; g_ = 1; b_ = 2;
	
	color_num = 0;
	while (color_num <=  8)				// set each target targColor to the matching targColor number 
		{
		dsendf("cm %d %d %d %d;\n",
						color_num + 1,				// 0 remains black
						targColorArray[color_num,r_],	// GLOBAL ALERT; targColorArray is an array so it cannot be passed
						targColorArray[color_num,g_],
						targColorArray[color_num,b_]);
		color_num = color_num + 1;
		nexttick;									// if we have a large number of targets we don't want to overflow the buffer
		}
	
	dsendf("cm 255 %d %d %d;\n",					// set the targColor of the fixation point to 255 (leaves room for many target colors)
						fixColorArray[r_],			// GLOBAL ALERT; fixColorArray is an array so it cannot be passed
	                    fixColorArray[g_],
						fixColorArray[b_]);
	
	dsendf("cm 254 %d %d %d;\n",					// set the targColor of the stop signal to 254 (leaves room for many target colors)
						stopColorArray[r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    stopColorArray[g_],
						stopColorArray[b_]);
	
	dsendf("cm 253 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						ignoreColorArray[r_],		// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    ignoreColorArray[g_],
						ignoreColorArray[b_]);

	dsendf("cm 252 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						maskColorArray[r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    maskColorArray[g_],
						maskColorArray[b_]);

	dsendf("cm 251 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						highBetColorArray[r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    highBetColorArray[g_],
						highBetColorArray[b_]);

	dsendf("cm 250 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						lowBetColorArray[r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    lowBetColorArray[g_],
						lowBetColorArray[b_]);

	dsendf("cm 249 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						betFixColorArray[r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    betFixColorArray[g_],
						betFixColorArray[b_]);

	dsendf("cm 248 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						proFixColorArray[r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    proFixColorArray[g_],
						proFixColorArray[b_]);
	//vwm				
	dsendf("cm 247 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[0,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[0,g_],
						vwmColorArray[0,b_]);	
	
	dsendf("cm 246 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[1,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[1,g_],
						vwmColorArray[1,b_]);	
	dsendf("cm 245 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[2,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[2,g_],
						vwmColorArray[2,b_]);	
	dsendf("cm 244 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[3,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[3,g_],
						vwmColorArray[3,b_]);	
	dsendf("cm 243 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[4,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[4,g_],
						vwmColorArray[4,b_]);	
	dsendf("cm 242 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[5,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[5,g_],
						vwmColorArray[5,b_]);	
	dsendf("cm 241 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[6,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[6,g_],
						vwmColorArray[6,b_]);	
	dsendf("cm 240 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[7,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[7,g_],
						vwmColorArray[7,b_]);
						
	dsendf("cm 239 %d %d %d;\n",					// set the targColor of the ignore signal to 253 (leaves room for many target colors)
						vwmColorArray[8,r_],			// GLOBAL ALERT; fixColor is an array so it cannot be passed
	                    vwmColorArray[8,g_],
						vwmColorArray[8,b_]);
	}