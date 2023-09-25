local spawns = {
	{ position = Position(32611, 32670, 7), monster = "filth toad" },
	{ position = Position(32601, 32676, 7), monster = "filth toad" },
	{ position = Position(32593, 32662, 7), monster = "filth toad" },
	{ position = Position(32597, 32651, 7), monster = "filth toad" },
	{ position = Position(32612, 32637, 7), monster = "filth toad" },
	{ position = Position(32629, 32640, 7), monster = "filth toad" },
	{ position = Position(32637, 32654, 7), monster = "filth toad" },
	{ position = Position(32628, 32664, 7), monster = "filth toad" },
	{ position = Position(32639, 32670, 7), monster = "filth toad" },
	{ position = Position(32622, 32674, 7), monster = "bog frog" },
	{ position = Position(32618, 32665, 7), monster = "bog frog" },
	{ position = Position(32633, 32656, 7), monster = "bog frog" },
	{ position = Position(32618, 32644, 7), monster = "bog frog" },
	{ position = Position(32603, 32640, 7), monster = "bog frog" },
	{ position = Position(32598, 32658, 7), monster = "bog frog" },
	{ position = Position(32593, 32667, 7), monster = "bog frog" },
	{ position = Position(32593, 32673, 7), monster = "bog frog" },
	{ position = Position(32585, 32671, 7), monster = "bog frog" },
	{ position = Position(32640, 32646, 7), monster = "swamp troll" },
	{ position = Position(32602, 32636, 7), monster = "swamp troll" },
	{ position = Position(32583, 32658, 7), monster = "swamp troll" },
	{ position = Position(32615, 32682, 7), monster = "swamp troll" },
	rangeX = 4,
	rangeY = 4,
}

local TwistedWatersEnabled = false
local TwistedWatersChance = 10

local TwistedWaters = GlobalEvent("TwistedWaters")
function TwistedWaters.onStartup()
	if TwistedWatersEnabled then
		if math.random(100) <= TwistedWatersChance then
			logger.info("[WorldChanges] Twisted Waters loaded: twisted_waters.otbm")
			Game.loadMap("data-otservbr-global/world/world_changes/twisted_waters/twisted_waters.otbm")
		end
	end
	return true
end

--[[local function checkBoss(centerPosition, rangeX, rangeY, bossName)
	local spectators, spec = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spec = spectators[i]
		if spec:isMonster() then
			if spec:getName() == bossName then
				return true
			end
		end
	end
	return false
end

local monsters = GlobalEvent("TwistedWaters")
function monsters.onThink(interval, lastExecution)
	for i = 1, #spawns do
		spawn = spawns[i]
		if checkBoss(spawn.position, spawn.rangeX, spawn.rangeY, spawn.monster) then
			return true
		end

		local monster = Game.createMonster(spawn.monster, spawn.position, true, true)
		return true
	end
end

monsters:interval(30 * 1000)
monsters:register()]]--
TwistedWaters:register()