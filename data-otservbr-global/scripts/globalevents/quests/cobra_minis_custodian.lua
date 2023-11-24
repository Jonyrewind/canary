local config = {
	monsterName = "Custodian",
	bossPosition = Position(33376, 32825, 8),
	centerPosition = Position(33376, 32825, 8),
	rangeX = 50,
	rangeY = 50,
	timer = configManager.getNumber(configKeys.RATE_SPAWN) * SCHEDULE_SPAWN_RATE,
}

local miniBoss = GlobalEvent("custodian")
function miniBoss.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

miniBoss:interval(15 * 60 * 1000 / config.timer)
miniBoss:register()
