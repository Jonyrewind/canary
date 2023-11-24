local config = {
	monsterName = "Preceptor Lazare",
	bossPosition = Position(33373, 31348, 3),
	centerPosition = Position(33373, 31348, 3),
	rangeX = 50,
	rangeY = 50,
	timer = configManager.getNumber(configKeys.RATE_SPAWN) * SCHEDULE_SPAWN_RATE,
}

local preceptorLazare = GlobalEvent("preceptor lazare")
function preceptorLazare.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

preceptorLazare:interval(15 * 60 * 1000 / config.timer)
preceptorLazare:register()
