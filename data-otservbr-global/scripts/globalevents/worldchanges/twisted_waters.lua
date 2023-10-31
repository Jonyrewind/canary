local storage = GlobalStorage.TwistedWatersWorldChange

local config = {
	fromPosition = { x = 32592, y = 32632, z = 7 },
	toPosition = { x = 32639, y = 32673, z = 7 },
	monsters = {
		{ name = "Swamp Troll" },
		{ name = "Swamp Troll" },
		{ name = "Swamp Troll" },
		{ name = "Swamp Troll" },
		{ name = "Swamp Troll" },
		{ name = "Bog Frog" },
		{ name = "Bog Frog" },
		{ name = "Bog Frog" },
		{ name = "Bog Frog" },
		{ name = "Bog Frog" },
		{ name = "Filth Toad" },
		{ name = "Filth Toad" },
		{ name = "Filth Toad" },
		{ name = "Filth Toad" },
		{ name = "Filth Toad" },
		{ name = "Filth Toad" },
		{ name = "Bog Frog" },
		{ name = "Swamp Troll" },
	},
	respawntime = 60,
}

local TwistedWaters = GlobalEvent("TwistedWaters")
function TwistedWaters.onStartup()
	if getGlobalStorage(storage.TwistedWatersActive) == 1 then
		logger.info("[WorldChanges] Twisted Waters loaded: twisted_waters.otbm")
		Game.loadMap("data-otservbr-global/world/world_changes/twisted_waters/twisted_waters.otbm")
		setGlobalStorage(storage.Status, 2)
		addEvent(function()
			respawnmonster(config)
			logger.info("Twisted Waters Event Started")
		end, 30 * 1000)
	end
	return true
end
