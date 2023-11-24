local config = {
	monsterName = "Grand Chaplain Gaunder",
	bossPosition = Position(33370, 31327, 5),
	centerPosition = Position(33370, 31327, 5),
	rangeX = 50,
	rangeY = 50,
	timer = configManager.getNumber(configKeys.RATE_SPAWN) * SCHEDULE_SPAWN_RATE,
}

local chaplaingaunder = GlobalEvent("chaplaingaunder")
function chaplaingaunder.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

chaplaingaunder:interval(15 * 60 * 1000 / config.timer)
chaplaingaunder:register()
