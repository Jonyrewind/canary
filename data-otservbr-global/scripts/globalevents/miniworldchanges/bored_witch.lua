local getstorage = getGlobalStorage(GlobalStorage.BoredMiniWorldChange)
local storage = GlobalStorage.BoredMiniWorldChange

local config = {
	fromPosition = { x = 32728, y = 31970, z = 7 },
	toPosition = { x = 32753, y = 31989, z = 7 },
	monsters = {
		{ name = "Giant Spider Wyda" },
		{ name = "Giant Spider Wyda" },
	},
	respawntime = 90,
}

local BoredMiniWorldChangeEnabled = true
local BoredMiniWorldChangeChance = 15

local BoredMiniWorldChange = GlobalEvent("BoredMiniWorldChange")

function BoredMiniWorldChange.onStartup()
	if math.random(100) <= BoredMiniWorldChangeChance and getstorage ~= 1 then
		return false
	end

	logger.info("[MiniWorldChange] Bored Mini World Change active")
	setGlobalStorage(storage, 1) -- in case of an server crash
	setGlobalStorageValue(storage, 1)
	addEvent(function()
		respawnmonster(config)
	end, 30 * 1000)
	return true
end

BoredMiniWorldChange:register()
