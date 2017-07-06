declare MAIN(), INCRIMENT()

process MAIN() enabled
	{
	spawn INCRIMENT
	{

process INCRIMENT
	{
	declare ii;
	ii = ii + 1;
	printf("%d",ii);
	}