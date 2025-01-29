-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 8,
		multiplier = 250,
	},
	{
		minlevel = 9,
		maxlevel = 100,
		multiplier = 120,
	},
	{
		minlevel = 101,
		maxlevel = 300,
		multiplier = 70,
	},
	{
		minlevel = 301,
		maxlevel = 600,
		multiplier = 40,
	},
	{
		minlevel = 601,
		maxlevel = 800,
		multiplier = 15,
	},
	{
		minlevel = 801,
		multiplier = 8,
	},
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 60,
		multiplier = 30,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 20,
	},
	{
		minlevel = 81,
		maxlevel = 110,
		multiplier = 12,
	},
	{
		minlevel = 111,
		maxlevel = 125,
		multiplier = 8,
	},
	{
		minlevel = 126,
		multiplier = 4,
	},
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 60,
		multiplier = 20,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 14,
	},
	{
		minlevel = 81,
		maxlevel = 100,
		multiplier = 10,
	},
	{
		minlevel = 101,
		maxlevel = 110,
		multiplier = 8,
	},
	{
		minlevel = 111,
		maxlevel = 125,
		multiplier = 6,
	},
	{
		minlevel = 126,
		multiplier = 4,
	},
}
