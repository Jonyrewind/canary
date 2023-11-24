local config = {
	monsterName = "Gaffir",
	bossPosition = Position(33394, 32674, 4),
	centerPosition = Position(33394, 32674, 4),
	rangeX = 50,
	rangeY = 50,
	timer = configManager.getNumber(configKeys.RATE_SPAWN) * SCHEDULE_SPAWN_RATE,
}

local miniBoss = GlobalEvent("gaffir")
function miniBoss.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

miniBoss:interval(15 * 60 * 1000 / config.timer)
miniBoss:register()
