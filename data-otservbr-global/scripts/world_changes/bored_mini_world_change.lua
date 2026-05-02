config = {
	enable = true,
	startChance = 100,
	wydaPosition = Position(32719, 31983, 7),
	spawnRadius = 10,
	spawnAmount = 3,
	spawnMonsterName = "Giant Spider Wyda",
	monsterDeathEvent = "GiantSpiderWyda",
	kv = KV.scoped("worldchanges"):scoped("bored"),
	isActive = function()
		return config.kv:get("active")
	end,
	setActive = function(value)
		config.kv:set("active", value)
	end,
}

local function getRandomSpawnPosition(centerPosition, radius)
	local offsetX = math.random(-radius, radius)
	local offsetY = math.random(-radius, radius)
	return Position(centerPosition.x + offsetX, centerPosition.y + offsetY, centerPosition.z)
end

local function canSpawnAt(position)
	local tile = Tile(position)
	if not tile or tile:hasProperty(CONST_PROP_BLOCKSOLID) or tile:getTopCreature() then
		return false
	end

	return true
end

local function spawnFakeGiantSpider(position)
	local monster = Game.createMonster(config.spawnMonsterName, position, true, true)
	if not monster then
		logger.info("[MiniWorldChange] Failed to spawn {} at {}", config.spawnMonsterName, position)
		return false
	end

	monster:registerEvent(config.monsterDeathEvent)
	monster:setSpawnPosition()
	monster:remove()

	logger.info("[MiniWorldChange] Spawned {} at {}", config.spawnMonsterName, position)
	return true
end

local function spawnBoredMiniWorldChange()
	if not config.enable then
		logger.info("[MiniWorldChange] Bored Mini World Change disabled in config")
		return true
	end

	if not config.isActive() then
		logger.info("[MiniWorldChange] Bored Mini World Change inactive on spawn")
		return true
	end

	local spawnedCount = 0
	local attemptedCount = 0

	for _ = 1, config.spawnAmount do
		attemptedCount = attemptedCount + 1
		local spawnPosition = getRandomSpawnPosition(config.wydaPosition, config.spawnRadius)
		if canSpawnAt(spawnPosition) then
			if spawnFakeGiantSpider(spawnPosition) then
				spawnedCount = spawnedCount + 1
			end
		else
			logger.info("[MiniWorldChange] Spawn blocked at {}", spawnPosition)
		end
	end

	logger.info("[MiniWorldChange] Bored spawn finished: {} spawned out of {} attempts around {} with radius {}", spawnedCount, attemptedCount, config.wydaPosition, config.spawnRadius)
	return true
end

local boredMiniWorldChangeStartUp = GlobalEvent("Bored Mini World Change StartUp")

function boredMiniWorldChangeStartUp.onStartup()
	local currentStatus = config.isActive()
	logger.info("[MiniWorldChange] Startup status value is {}", tostring(currentStatus))

	if not config.isActive() then
		local rolledActive = math.random(100) <= config.startChance
		logger.info("[MiniWorldChange] No status stored, rolling start chance {}% -> {}", config.startChance, tostring(rolledActive))
		config.setActive(true)
		logger.info("[MiniWorldChange] Status after startup roll is {}", config.isActive())
	end

	return spawnBoredMiniWorldChange()
end

boredMiniWorldChangeStartUp:register()

local globalServerSave = GlobalEvent("boredMiniWorldChangeGlobalServerSave")

function globalServerSave.onGlobalServerSave()
	config.setActive(false)
	return true
end

globalServerSave:register()
