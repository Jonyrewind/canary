local config = {
	questScope = "feaster-of-souls",
	bossName = "The Pale Worm",
	greedWormName = "Greed Worm",
	hungerWormName = "Hunger Worm",
	weakSpotName = "A Weak Spot",
	holeItemId = 385,
	holeLifetime = 10 * 1000,
	weakSpotPosition = Position(33805, 31505, 15),
	bossRoomCenter = Position(33805, 31504, 14),
	lowerRoomCenter = Position(33805, 31504, 15),
	roomRangeX = 12,
	roomRangeY = 12,
	spawnRadius = 4,
	initialGreedWorms = 2,
	greedWormSpawnMinInterval = 4 * 1000,
	greedWormSpawnMaxInterval = 10 * 1000,
	greedWormSpawnLimit = 6,
	bossRoomGreedWormCountKey = "boss-room-greed-worms",
	lowerRoomGreedWormCountKey = "lower-room-greed-worms",
	hungerWormDamageMin = 5000,
	hungerWormDamageMax = 9000,
	hungerWormDamageAccumulatorKey = "hunger-worm-damage-accumulator",
	hungerWormNextThresholdKey = "hunger-worm-next-threshold",
	lowerRoomTriggeredKey = "lower-room-triggered",
	lowerRoomDeathDamageBase = 250,
	lowerRoomDeathDamageInterval = 3 * 1000,
	lowerRoomDeathDamageEffect = CONST_ME_SMALLCLOUDS,
}

local holeGroundIds = {}
local paleWormOriginalMaxHealth = {}

local function questKV()
	return kv:scoped(config.questScope):scoped("pale-worm")
end

local function getKVValue(key, defaultValue)
	local value = questKV():get(key)
	if value == nil then
		return defaultValue
	end

	if type(value) == "table" and value.getNumber then
		return value:getNumber()
	end

	return value
end

local function setKVValue(key, value)
	questKV():set(key, value)
end

local function removeKVValue(key)
	questKV():remove(key)
end

local function isNamedMonster(creature, name)
	return creature and creature:isMonster() and creature:getName():lower() == name:lower()
end

local function isPaleWorm(creature)
	return isNamedMonster(creature, config.bossName)
end

local function isHungerWorm(creature)
	return isNamedMonster(creature, config.hungerWormName)
end

local function getBoss()
	local bossAreas = {
		config.bossRoomCenter,
		config.lowerRoomCenter,
	}

	for _, center in ipairs(bossAreas) do
		local spectators = Game.getSpectators(center, false, false, config.roomRangeX, config.roomRangeX, config.roomRangeY, config.roomRangeY)
		for _, creature in ipairs(spectators) do
			if isPaleWorm(creature) then
				return creature
			end
		end
	end

	return nil
end

local function getBossPhase()
	return tonumber(getKVValue("phase", 0)) or 0
end

local function setBossPhase(phase)
	setKVValue("phase", phase)
end

local function isInitialized()
	return getKVValue("initialized", false) == true
end

local function setInitialized(value)
	setKVValue("initialized", value and true or false)
end

local function getSpawnedGreedWorms(countKey)
	return tonumber(getKVValue(countKey, 0)) or 0
end

local function setSpawnedGreedWorms(countKey, count)
	setKVValue(countKey, count)
end

local function getGreedWormCountKey(position)
	if position and position.z == config.lowerRoomCenter.z then
		return config.lowerRoomGreedWormCountKey
	end

	return config.bossRoomGreedWormCountKey
end

function decreaseSpawnedGreedWorms(position)
	local countKey = getGreedWormCountKey(position)
	local current = getSpawnedGreedWorms(countKey)
	if current <= 0 then
		setSpawnedGreedWorms(countKey, 0)
		return 0
	end

	local updated = current - 1
	setSpawnedGreedWorms(countKey, updated)
	return updated
end

local function getHungerWormDamageAccumulator()
	return tonumber(getKVValue(config.hungerWormDamageAccumulatorKey, 0)) or 0
end

local function setHungerWormDamageAccumulator(value)
	setKVValue(config.hungerWormDamageAccumulatorKey, value)
end

local function getNextHungerWormThreshold()
	local threshold = tonumber(getKVValue(config.hungerWormNextThresholdKey, 0)) or 0
	if threshold < config.hungerWormDamageMin or threshold > config.hungerWormDamageMax then
		threshold = math.random(config.hungerWormDamageMin, config.hungerWormDamageMax)
		setKVValue(config.hungerWormNextThresholdKey, threshold)
	end

	return threshold
end

local function setNextHungerWormThreshold(value)
	setKVValue(config.hungerWormNextThresholdKey, value)
end

local function resetHungerWormDamageState()
	setHungerWormDamageAccumulator(0)
	setNextHungerWormThreshold(math.random(config.hungerWormDamageMin, config.hungerWormDamageMax))
end

local function getGreedWormSpawnDelay()
	return math.random(config.greedWormSpawnMinInterval, config.greedWormSpawnMaxInterval)
end

local function getLowerRoomPlayers()
	local players = {}
	local spectators = Game.getSpectators(config.lowerRoomCenter, false, false, config.roomRangeX, config.roomRangeX, config.roomRangeY, config.roomRangeY)
	for _, creature in ipairs(spectators) do
		if creature:isPlayer() then
			players[#players + 1] = creature
		end
	end

	return players
end

local function getLowerRoomDeathDamageTick()
	return math.max(1, tonumber(getKVValue("damage-tick", 1)) or 1)
end

local function setLowerRoomDeathDamageTick(tick)
	setKVValue("damage-tick", tick)
end

local function getLowerRoomDeathDamage(tick)
	if tick <= 6 then
		return config.lowerRoomDeathDamageBase + ((tick - 1) * 50)
	end

	if tick <= 12 then
		return 500 + ((tick - 6) * 100)
	end

	local extraTicks = tick - 12
	return 1100 + (1000 * ((2 ^ extraTicks) - 1))
end

local function clearLowerRoomDeathDamage()
	removeKVValue("damage-tick")
	removeKVValue("lower-room-damage-running")
end

local function lowerRoomDeathDamageTick()
	if not isInitialized() or getBossPhase() ~= 3 then
		clearLowerRoomDeathDamage()
		return
	end

	local players = getLowerRoomPlayers()
	if #players == 0 then
		setLowerRoomDeathDamageTick(1)
		addEvent(lowerRoomDeathDamageTick, config.lowerRoomDeathDamageInterval)
		return
	end

	local tick = getLowerRoomDeathDamageTick()
	local damage = getLowerRoomDeathDamage(tick)

	for _, player in ipairs(players) do
		player:addHealth(-damage, COMBAT_DEATHDAMAGE)
		player:getPosition():sendMagicEffect(config.lowerRoomDeathDamageEffect)
	end

	setLowerRoomDeathDamageTick(tick + 1)
	addEvent(lowerRoomDeathDamageTick, config.lowerRoomDeathDamageInterval)
end

local function startLowerRoomDeathDamage()
	if getKVValue("lower-room-damage-running", false) == true then
		return
	end

	setKVValue("lower-room-damage-running", true)
	setLowerRoomDeathDamageTick(1)
	lowerRoomDeathDamageTick()
end

local function getSpawnPositions(center, radius)
	local positions = {}
	for x = -radius, radius do
		for y = -radius, radius do
			positions[#positions + 1] = Position(center.x + x, center.y + y, center.z)
		end
	end

	for i = #positions, 2, -1 do
		local j = math.random(i)
		positions[i], positions[j] = positions[j], positions[i]
	end

	return positions
end

local function findSpawnPosition(center, radius)
	for _, position in ipairs(getSpawnPositions(center, radius)) do
		local monster = Game.createMonster("Rat", position, true, true)
		if monster then
			monster:remove()
			return position
		end
	end

	return center
end

local function spawnMonsters(name, center, amount, radius)
	local spawned = 0
	for _ = 1, amount do
		local position = findSpawnPosition(center, radius)
		local monster = Game.createMonster(name, position)
		if monster then
			spawned = spawned + 1
			position:sendMagicEffect(CONST_ME_MORTAREA)
		end
	end

	return spawned
end

local function spawnGreedWormAtPosition(position, roomLabel)
	if not position then
		logger.warn("[PaleWorm] spawnGreedWormAtPosition called without a position for {}.", roomLabel)
		return false
	end

	local spawnPosition = findSpawnPosition(position, config.spawnRadius)
	local monster = Game.createMonster(config.greedWormName, spawnPosition)
	if monster then
		spawnPosition:sendMagicEffect(CONST_ME_MORTAREA)
		return true
	end

	logger.warn("[PaleWorm] Failed to spawn Greed Worm in {} at {}.", roomLabel, spawnPosition:toString())
	return false
end

local function scheduleGreedWormSpawn(roomLabel, centerProvider, countKey)
	if not isInitialized() then
		return
	end

	addEvent(function()
		if not isInitialized() then
			return
		end

		local center = centerProvider()
		if center then
			local spawned = getSpawnedGreedWorms(countKey)
			if spawned < config.greedWormSpawnLimit then
				if spawnGreedWormAtPosition(center, roomLabel) then
					setSpawnedGreedWorms(countKey, spawned + 1)
				end
			end
		else
			logger.warn("[PaleWorm] Greed Worm spawn tick skipped because {} center could not be resolved.", roomLabel)
		end

		scheduleGreedWormSpawn(roomLabel, centerProvider, countKey)
	end, getGreedWormSpawnDelay())
end

local function spawnHungerWorm(boss)
	if not boss then
		logger.warn("[PaleWorm] spawnHungerWorm called without a boss reference.")
		return
	end

	local position = findSpawnPosition(boss:getPosition(), config.spawnRadius)

	local monster = Game.createMonster(config.hungerWormName, position)
	if monster then
		position:sendMagicEffect(CONST_ME_MORTAREA)
	else
		logger.warn("[PaleWorm] Failed to spawn Hunger Worm at {}.", position:toString())
	end
end

local function openHole(position)
	local tile = Tile(position)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if not ground then
		return false
	end

	local positionKey = position:toString()
	holeGroundIds[positionKey] = ground:getId()
	ground:transform(config.holeItemId)
	return true
end

local function removeHole(position)
	local tile = Tile(position)
	if not tile then
		return
	end

	local ground = tile:getGround()
	if not ground then
		return
	end

	local positionKey = position:toString()
	local originalGroundId = holeGroundIds[positionKey]
	if originalGroundId then
		ground:transform(originalGroundId)
		holeGroundIds[positionKey] = nil
	end
end

local function setPaleWormOriginalMaxHealth(player, maxHealth)
	if player then
		paleWormOriginalMaxHealth[player:getGuid()] = maxHealth
	end
end

local function getPaleWormOriginalMaxHealth(player)
	if not player then
		return nil
	end

	return paleWormOriginalMaxHealth[player:getGuid()]
end

local function clearPaleWormOriginalMaxHealth(player)
	if player then
		paleWormOriginalMaxHealth[player:getGuid()] = nil
	end
end

local function clearAllPaleWormOriginalMaxHealth()
	for guid in pairs(paleWormOriginalMaxHealth) do
		paleWormOriginalMaxHealth[guid] = nil
	end
end

local function cleanupRoom(center, rangeX, rangeY)
	local spectators = Game.getSpectators(center, false, false, rangeX, rangeX, rangeY, rangeY)
	for _, creature in ipairs(spectators) do
		if creature:isPlayer() then
			removePaleWormGreaterHex(creature)
		elseif creature:isMonster() then
			local name = creature:getName():lower()
			if name == config.bossName:lower() or name == config.greedWormName:lower() or name == config.hungerWormName:lower() or name == config.weakSpotName:lower() then
				creature:remove()
			end
		end
	end

	for x = center.x - rangeX, center.x + rangeX do
		for y = center.y - rangeY, center.y + rangeY do
			removeHole(Position(x, y, center.z))
		end
	end
end

function applyPaleWormGreaterHex(player, durationTicks)
	if not player then
		logger.warn("[PaleWorm] applyPaleWormGreaterHex called without a player.")
		return false
	end

	if player:getCondition(CONDITION_INTENSEHEX) then
		return false
	end

	local originalMaxHealth = player:getBaseMaxHealth()
	setPaleWormOriginalMaxHealth(player, originalMaxHealth)

	local reducedHealth = math.max(1, math.floor(originalMaxHealth * 0.4))

	local condition = Condition(CONDITION_INTENSEHEX)
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 50)
	condition:setParameter(CONDITION_PARAM_BUFF_HEALINGRECEIVED, 50)
	condition:setParameter(CONDITION_PARAM_TICKS, durationTicks or 25 * 60 * 1000)
	player:addCondition(condition)

	player:setMaxHealth(reducedHealth)
	player:setHealth(math.min(player:getHealth(), reducedHealth))
	player:getPosition():sendMagicEffect(CONST_ME_LOSEENERGY)

	return true
end

function removePaleWormGreaterHex(player)
	if not player then
		logger.warn("[PaleWorm] removePaleWormGreaterHex called without a player.")
		return false
	end

	local hadHex = player:getCondition(CONDITION_INTENSEHEX) ~= nil
	if hadHex then
		player:removeCondition(CONDITION_INTENSEHEX)
	end

	local restoredMaxHealth = getPaleWormOriginalMaxHealth(player)
	if restoredMaxHealth and restoredMaxHealth > 0 then
		player:setMaxHealth(restoredMaxHealth)
		player:setHealth(math.min(player:getHealth(), restoredMaxHealth))
		clearPaleWormOriginalMaxHealth(player)
		return true
	end

	if hadHex then
		logger.warn("[PaleWorm] {} had Greater Hex removed but no stored max health snapshot was available to restore.", player:getName())
		return true
	end
	return false
end

function initializePaleWormEncounter(boss)
	if isInitialized() then
		return true
	end

	local encounterBoss = boss or getBoss()
	if not encounterBoss then
		logger.warn("[PaleWorm] initializePaleWormEncounter could not find The Pale Worm.")
		return false
	end

	setInitialized(true)
	setBossPhase(1)
	setSpawnedGreedWorms(config.bossRoomGreedWormCountKey, 0)
	setSpawnedGreedWorms(config.lowerRoomGreedWormCountKey, 0)
	resetHungerWormDamageState()
	removeKVValue(config.lowerRoomTriggeredKey)

	local spawned = spawnMonsters(config.greedWormName, encounterBoss:getPosition(), config.initialGreedWorms, config.spawnRadius)
	setSpawnedGreedWorms(config.bossRoomGreedWormCountKey, spawned)
	scheduleGreedWormSpawn("boss room", function()
		local boss = getBoss()
		return boss and boss:getPosition() or nil
	end, config.bossRoomGreedWormCountKey)
	return true
end

local paleWormPhase = CreatureEvent("PaleWormPhase")
function paleWormPhase.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not isPaleWorm(creature) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if not isInitialized() then
		initializePaleWormEncounter(creature)
	end

	local phase = getBossPhase()
	local totalDamage = math.abs(primaryDamage) + math.abs(secondaryDamage)
	if totalDamage > 0 then
		local accumulatedDamage = getHungerWormDamageAccumulator() + totalDamage
		local nextThreshold = getNextHungerWormThreshold()
		local spawnedHungerWorm = false

		while accumulatedDamage >= nextThreshold do
			spawnHungerWorm(creature)
			spawnedHungerWorm = true
			accumulatedDamage = accumulatedDamage - nextThreshold
			nextThreshold = math.random(config.hungerWormDamageMin, config.hungerWormDamageMax)
		end

		setHungerWormDamageAccumulator(accumulatedDamage)
		setNextHungerWormThreshold(nextThreshold)

		if spawnedHungerWorm and phase == 1 then
			setBossPhase(2)
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

paleWormPhase:register()

local hungerWormDeath = CreatureEvent("HungerWormDeath")
function hungerWormDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not isHungerWorm(creature) then
		return true
	end

	local boss = getBoss()
	if not boss then
		logger.warn("[PaleWorm] Hunger Worm died but The Pale Worm could not be found.")
		return true
	end

	local holePosition = creature:getPosition()
	openHole(holePosition)
	addEvent(removeHole, config.holeLifetime, holePosition)

	if getKVValue(config.lowerRoomTriggeredKey, false) == true then
		return true
	end

	setKVValue(config.lowerRoomTriggeredKey, true)

	local weakSpotPosition = config.weakSpotPosition
	local lowerSpawned = spawnMonsters(config.greedWormName, weakSpotPosition, config.initialGreedWorms, config.spawnRadius)
	setSpawnedGreedWorms(config.lowerRoomGreedWormCountKey, lowerSpawned)
	scheduleGreedWormSpawn("lower room", function()
		return config.weakSpotPosition
	end, config.lowerRoomGreedWormCountKey)
	setBossPhase(3)
	startLowerRoomDeathDamage()

	return true
end

hungerWormDeath:register()


local paleWormCleanup = CreatureEvent("PaleWormCleanup")
function paleWormCleanup.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not isPaleWorm(creature) then
		return true
	end

	cleanupRoom(config.bossRoomCenter, config.roomRangeX, config.roomRangeY)
	cleanupRoom(config.lowerRoomCenter, config.roomRangeX, config.roomRangeY)

	clearAllPaleWormOriginalMaxHealth()
	clearLowerRoomDeathDamage()
	setInitialized(false)
	setBossPhase(0)
	setSpawnedGreedWorms(config.bossRoomGreedWormCountKey, 0)
	setSpawnedGreedWorms(config.lowerRoomGreedWormCountKey, 0)
	removeKVValue("initialized")
	removeKVValue("phase")
	removeKVValue("spawned-greed-worms")
	removeKVValue(config.bossRoomGreedWormCountKey)
	removeKVValue(config.lowerRoomGreedWormCountKey)
	removeKVValue(config.hungerWormDamageAccumulatorKey)
	removeKVValue(config.hungerWormNextThresholdKey)
	removeKVValue(config.lowerRoomTriggeredKey)
	removeKVValue("shared-life-id")

	return true
end

paleWormCleanup:register()
