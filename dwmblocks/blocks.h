//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		  /*Update Interval*/	/*Update Signal*/
	{" 🔊 ", "/opt/dwmblocks/scripts/volume", 0,                    10},
	{" 🕑 ", "/opt/dwmblocks/scripts/clock",  60,                   0},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = "|";
static unsigned int delimLen = 5;

