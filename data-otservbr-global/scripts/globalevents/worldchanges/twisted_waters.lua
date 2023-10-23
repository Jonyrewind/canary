local storage = GlobalStorage.TwistedWatersWorldChange

local encounter = "Twisted Waters"

local spawnZone = Zone("fight.spawn")
-- central area where monsters/boss spawns
spawnZone:addArea({ x = 32592, y = 32632, z = 7 }, { x = 32639, y = 32673, z = 7 })

local encounter = Encounter("Twisted Waters", {
	zone = spawnZone,
	spawnZone = spawnZone,
	timeToSpawnMonsters = "3s",
})

encounter:addSpawnMonsters({
	{
		name = "Swamp Troll",
		amount = 8,
	},
	{
		name = "Bog Frog",
		amount = 8,
	},
	{
		name = "Filth Toad",
		amount = 8,
	},
})

encounter:register()

local TwistedWaters = GlobalEvent("TwistedWaters")
function TwistedWaters.onStartup()
	if getGlobalStorage(storage.TwistedWatersActive) == 1 then
		logger.info("[WorldChanges] Twisted Waters loaded: twisted_waters.otbm")
		Game.loadMap("data-otservbr-global/world/world_changes/twisted_waters/twisted_waters.otbm")
		setGlobalStorage(storage.Status, 2)
		addEvent(function()
			encounter:start()
			logger.info("Twisted Waters Event Started")
		end, 30 * 1000)
	end
	return true
end

local spawnMobs = GlobalEvent("TwistedWaters.onThink")
function spawnMobs.onThink(interval, lastExecution)
	if TwistedWatersEnabled then
		local monster1 = encounter:countMonsters("Swamp Troll")
		local monster2 = encounter:countMonsters("Bog Frog")
		local monster3 = encounter:countMonsters("Filth Toad")
		count1 = 8 - encounter:countMonsters("Swamp Troll")
		count2 = 8 - encounter:countMonsters("Bog Frog")
		count3 = 8 - encounter:countMonsters("Filth Toad")
		if monster1 < 8 then
			encounter:spawnMonsters({ name = "Swamp Troll", amount = count1 })
		end
		if monster2 < 8 then
			encounter:spawnMonsters({ name = "Bog Frog", amount = count2 })
		end
		if monster3 < 8 then
			encounter:spawnMonsters({ name = "Filth Toad", amount = count3 })
		end
	end
	return true
end

spawnMobs:interval(30000)
spawnMobs:register()

TwistedWaters:register()