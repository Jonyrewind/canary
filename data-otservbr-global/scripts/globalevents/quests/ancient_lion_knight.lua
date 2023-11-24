local config = {
	monsterName = "Ancient Lion Knight",
	bossPosition = Position(32456, 32495, 7),
	centerPosition = Position(32456, 32495, 7),
	rangeX = 50,
	rangeY = 50,
	timer = configManager.getNumber(configKeys.RATE_SPAWN) * SCHEDULE_SPAWN_RATE,
}

local lionKnight = GlobalEvent("ancient lion knight")
function lionKnight.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

lionKnight:interval(15 * 60 * 1000 / config.timer)
lionKnight:register()
