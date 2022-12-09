-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 300,
		multiplier = 700
	}, {
		minlevel = 301,
		maxlevel = 400,
		multiplier = 500
	}, {
		minlevel = 401,
		maxlevel = 500,
		multiplier = 400
	}, {
		minlevel = 501,
		maxlevel = 600,
		multiplier = 300
	}, {
		minlevel = 601,
		multiplier = 200
	}
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 60,
		multiplier = 150
	}, {
		minlevel = 61,
		maxlevel = 80,
		multiplier = 100
	}, {
		minlevel = 81,
		maxlevel = 110,
		multiplier = 12
	}, {
		minlevel = 111,
		maxlevel = 125,
		multiplier = 8
	}, {
		minlevel = 126,
		multiplier = 4
	}
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 60,
		multiplier = 100
	}, {
		minlevel = 61,
		maxlevel = 80,
		multiplier = 70
	}, {
		minlevel = 81,
		maxlevel = 100,
		multiplier = 10
	}, {
		minlevel = 101,
		maxlevel = 110,
		multiplier = 8
	}, {
		minlevel = 111,
		maxlevel = 125,
		multiplier = 6
	}, {
		minlevel = 126,
		multiplier = 4
	}
}
