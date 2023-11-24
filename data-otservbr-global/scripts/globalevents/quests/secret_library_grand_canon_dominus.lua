local config = {
	monsterName = "Grand Canon Dominus",
	bossPosition = Position(33384, 31282, 6),
	centerPosition = Position(33384, 31282, 6),
	rangeX = 50,
	rangeY = 50,
	timer = configManager.getNumber(configKeys.RATE_SPAWN) * SCHEDULE_SPAWN_RATE,
}

local canonDominus = GlobalEvent("canon dominus")
function canonDominus.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

canonDominus:interval(15 * 60 * 1000 / config.timer)
canonDominus:register()
