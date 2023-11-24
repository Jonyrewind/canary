local config = {
	monsterName = "Guard Captain Quaid",
	bossPosition = Position(33392, 32660, 3),
	centerPosition = Position(33392, 32660, 3),
	rangeX = 50,
	rangeY = 50,
	timer = configManager.getNumber(configKeys.RATE_SPAWN) * SCHEDULE_SPAWN_RATE,
}

local miniBoss = GlobalEvent("guard captain quaid")
function miniBoss.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

miniBoss:interval(15 * 60 * 1000 / config.timer)
miniBoss:register()
