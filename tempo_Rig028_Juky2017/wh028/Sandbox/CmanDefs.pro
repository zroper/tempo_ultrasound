declare constant FixSpotOn_			= 2301,
declare constant Fixate_			= 2660,
declare constant Target_			= 2651, //Must Check to be sure.
declare constant FixSpotOff_		= 2300,
declare constant StopSignal_		= 2653,
declare constant TrialStart_		= 1666,
declare constant FixError_			= 2750, //Must Check to be sure.
declare constant GoSaccade_			= 2751, //Must Check to be sure.
declare constant GoError_			= 2752, //Must Check to be sure.
declare constant NOGOWrong_			= 2753; //Must Check to be sure.
declare constant GoTargFixError_	= 2754; //Must Check to be sure.
declare constant Abort_ 			= 2620;
declare constant Correct_ 			= 2600;
declare constant GOCorrect_ 		= 2755;
declare constant NOGOCorrect_ 		= 2756;
declare constant Reward_ 			= 2727;
//Note that reward SIZE is being sent after this as it's own pulse
declare constant ExtraReward_ 		= 2777;
//Note that reward SIZE is being sent after this as it's own pulse
declare constant SoundOnReward_ 	= 2778;
declare constant SoundNoReward_ 	= 2779;
declare constant Eot_ = 1667;
declare constant CmanHeader_ 		= 1501;
declare constant Stimulation_ 		= 666;
//Note that this is followed by a 1 or a 2 if MultElectrodeStimFlag is set depending on the stim channel
declare constant ZeroEyePosition_ 	= 2302;
declare constant VSyncSynced_		= 999; //This is a bit weird.  Looks like we are waiting to hear back from videosync that all commands are out of buffer?
declare constant Saccade_ 			= 2810;
//Note followed by another TTL == 2820 + trials[1] (looks like it classifies trial type)
declare constant Decide_ 			= 2811;
declare constant MouthBegin_ 		= 2655;
declare constant MouthEnd_ 			= 2656;
declare constant MapHeader_ 		= 1503;
declare constant FixWindow_ 		= 2770;

/* MUST CHECK ALL THAT FOLLOWS IN TRANSLATED VARIABLES (MY VERSION DIED WITHOUT NETWORK) */
declare constant Staircase_ 		= 2772;
declare constant Neg2Reinforcement_ = 2773; //?????
declare constant Feedback_ 			= 2774; //????? 
declare constant RewardSize_ 		= 2927;
declare constant TrialInBlock 		= 2928;
declare constant SendStimInfo_ 		= 7000;
declare constant SendPenatrInfo_ 	= 2929;
declare constant TargetPre_ 		= 2650; //?????
declare constant StopOn_ 			= 2654; //?????
declare constant StimFailed_ 		= 667;

//Infos_ variables (all actual strobed flags follow event codes)
	declare constant NPOS_ 			= 2721; // next strobe == # of possible target positions
	declare constant Pos_ 			= 2722; // next strobe == curr target position
	//Note that 1DR curr rewarded target is sent in raw form
	declare constant SOUND_ 		= 2723; //Accoustic Stop Sig (needs better naming convention in future)
	//Note that a flag for central or peripheral stop signal presentation is sent in raw form
	declare constant ISNOTNOGO_ 	= 2724; // next strobe == flag indicating an aborted(?) stimulated stop trial
	declare constant BIG_REWARD_ 	= 2725; // strobe follows
	declare constant TRIG_CHANGE_ 	= 2726;
	declare constant REWARD_RATIO_ 	= 2728;
	declare constant NOGO_RATIO_ 	= 2729;
	declare constant ISNOGO_ 		= 2730;
	declare constant STOP_ZAP_ 		= 2731;
	declare constant STIM_DUR_ 		= 2732;
	declare constant EXP_HOLDTIME_ 	= 2733;
	declare constant HOLDTIME_ 		= 2734; // Named incorrectly should be GAP_
	declare constant HOLD_JITTER_ 	= 2735; // Named incorrectly should be GAP_JITTER_
	declare constant MAX_RESP_TIME_ = 2736;
	declare constant SOA_ 			= 2737; //Named incorrectly should be SSD
	declare constant MAX_SOA_ 		= 2738; //Named incorrectly see above
	declare constant MIN_SOA_ 		= 2739; //Named incorrectly see above
	declare constant SOA_STEP_ 		= 2740; //Named incorrectly see above


