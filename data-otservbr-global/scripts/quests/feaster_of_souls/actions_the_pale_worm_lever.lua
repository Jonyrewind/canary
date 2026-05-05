local BOSS_POSITION = Position(33805, 31504, 14)
local BOSS_ROOM_CENTER = Position(33805, 31504, 14)
local LOWER_ROOM_CENTER = Position(33805, 31504, 15)
local WEAK_SPOT_POSITION = Position(33805, 31505, 15)
local WEAK_SPOT_NAME = "A Weak Spot"
local ENCOUNTER_RANGE_X = 12
local ENCOUNTER_RANGE_Y = 12
local ENCOUNTER_HOLE_ID = 385
local QUEST_SCOPE = "feaster-of-souls"
local PALE_WORM_SCOPE = "pale-worm"

local function encounterKV()
	return kv:scoped(QUEST_SCOPE):scoped(PALE_WORM_SCOPE)
end

local function cleanupRoom(center, rangeX, rangeY)
	local searchRangeX = rangeX or ENCOUNTER_RANGE_X
	local searchRangeY = rangeY or ENCOUNTER_RANGE_Y

	local spectators = Game.getSpectators(center, false, false, searchRangeX, searchRangeX, searchRangeY, searchRangeY)
	for _, creature in ipairs(spectators) do
		if creature:isMonster() then
			local name = creature:getName():lower()
			if name == "the pale worm" or name == "greed worm" or name == "hunger worm" or name == "a weak spot" then
				creature:remove()
			end
		end
	end

	for x = center.x - searchRangeX, center.x + searchRangeX do
		for y = center.y - searchRangeY, center.y + searchRangeY do
			local tile = Tile(Position(x, y, center.z))
			if tile then
				local hole = tile:getItemById(ENCOUNTER_HOLE_ID)
				if hole then
					hole:remove()
				end
			end
		end
	end
end

function spawnPaleWormWeakSpot(boss)
	if not boss then
		return false
	end

	local weakSpot = Game.createMonster(WEAK_SPOT_NAME, WEAK_SPOT_POSITION)
	if not weakSpot then
		return false
	end

	local id = os.time()
	weakSpot:beginSharedLife(id)
	weakSpot:registerEvent("SharedLife")
	WEAK_SPOT_POSITION:sendMagicEffect(CONST_ME_TELEPORT)

	return true
end

local function resetPaleWormEncounter()
	cleanupRoom(BOSS_ROOM_CENTER)
	cleanupRoom(LOWER_ROOM_CENTER, ENCOUNTER_RANGE_X + 4, ENCOUNTER_RANGE_Y + 4)

	encounterKV():remove("initialized")
	encounterKV():remove("phase")
	encounterKV():remove("damage-tick")
	encounterKV():remove("lower-room-damage-running")
	encounterKV():remove("lower-room-triggered")
	encounterKV():remove("shared-life-id")
	encounterKV():remove("spawned-greed-worms")
	encounterKV():remove("hunger-worm-triggered")
	encounterKV():remove("hunger-worm-damage-accumulator")
	encounterKV():remove("hunger-worm-next-threshold")
end

local config = {
	boss = {
		name = "The Pale Worm",
		createFunction = function()
			local paleWorm = Game.createMonster("The Pale Worm", BOSS_POSITION, true, true)
			if not paleWorm then
				logger.warn("[PaleWorm] Failed to spawn The Pale Worm.")
				return false
			end

			local id = os.time()
			paleWorm:beginSharedLife(id)
			paleWorm:registerEvent("SharedLife")

			initializePaleWormEncounter(paleWorm)
			spawnPaleWormWeakSpot(paleWorm)
			BOSS_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end,
	},
	requiredLevel = 250,
	timeToDefeat = 25 * 60,
	playerPositions = {
		{ pos = Position(33772, 31504, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33773, 31504, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33774, 31504, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33775, 31504, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33773, 31503, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33774, 31503, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33775, 31503, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33773, 31505, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33774, 31505, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33775, 31505, 14), teleport = Position(33808, 31513, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33793, 31496, 14),
		to = Position(33816, 31515, 14),
	},
	exit = Position(33572, 31451, 10),
	onUseExtra = function(creature, infoPositions)
		resetPaleWormEncounter()

		local affectedPlayers = 0
		local participants = infoPositions or {}

		for _, posInfo in ipairs(participants) do
			local targetCreature = posInfo.creature
			local targetPlayer = targetCreature and targetCreature:getPlayer()
			if targetPlayer then
				if applyPaleWormGreaterHex(targetPlayer) then
					affectedPlayers = affectedPlayers + 1
				end
			end
		end
	end,
}

local lever = BossLever(config)
lever:position({ x = 33771, y = 31504, z = 14 })
lever:register()
