local getstorage = getGlobalStorage(GlobalStorage.BoredMiniWorldChange)
local storage = GlobalStorage.BoredMiniWorldChange

local from = { x = 32720, y = 31969, z = 7 }
local to = { x = 32751, y =  31989, z = 7 }

local positions = {
	{monster = "giant spider wyda" ,pos = Position(math.random(from.x, to.x), math.random(from.y, to.y), math.random(from.z, to.z)), spawntime = 10, status = true},
	{monster = "giant spider wyda" ,pos = Position(math.random(from.x, to.x), math.random(from.y, to.y), math.random(from.z, to.z)), spawntime = 10, status = true},
}

local spawn = Spawn()

local BoredMiniWorldChangeEnabled = true
local BoredMiniWorldChangeChance = 0

local BoredMiniWorldChange = GlobalEvent("BoredMiniWorldChange")

function BoredMiniWorldChange.onStartup()
	if math.random(100) <= BoredMiniWorldChangeChance then
		setGlobalStorage(storage, 0) -- incase of an server crash
		return false
	end
	if BoredMiniWorldChangeEnabled and getstorage <= 0 then
		logger.info("[WorldChanges] Bored Mini World Change active")
		setGlobalStorage(storage, 2) -- incase of an server crash
		setGlobalStorageValue(storage, 1)
		addEvent(function()
			spawn:setPositions(positions)
			spawn:executeSpawn()
		end, 30 * 1000)
	else
		logger.info("[WorldChanges] Bored Mini World Change active")
		setGlobalStorageValue(storage, 1)
		addEvent(function()
			spawn:setPositions(positions)
			spawn:executeSpawn()
		end, 30 * 1000)
	end
	return true
end

BoredMiniWorldChange:register()