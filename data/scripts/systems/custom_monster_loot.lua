-- Drops custom loot for all monsters
local allLootConfig = {
	{ id = 22118, chance = 50, minCount = 1, maxCount = 5 }, -- Example of loot (100% chance)
}

-- Custom loot for specific monsters (this has the same usage options as normal monster loot)
local customLootConfig = {
	["Dragon"] = { items = {
		{ name = "platinum coin", chance = 1000, maxCount = 1 },
	} },
}

-- Boss-only custom loot (registered based on mType:bossRace())
local bossLootConfig = {
	{ id = 22118, chance = 30000, minCount = 5, maxCount = 10 },
}

local customMonsterLoot = GlobalEvent("CreateCustomMonsterLoot")

function customMonsterLoot.onStartup()
	for monsterName, lootTable in pairs(customLootConfig) do
		local mtype = Game.getMonsterTypeByName(monsterName)
		if mtype then
			if lootTable and lootTable.items and #lootTable.items > 0 then
				mtype:createLoot(lootTable.items)
				logger.debug("[customMonsterLoot.onStartup] - Custom loot registered for monster: {}", mtype:getName())
			end
		else
			logger.error("[customMonsterLoot.onStartup] - Monster type not found: {}", monsterName)
		end
	end

	if #allLootConfig > 0 then
		for monsterName, mtype in pairs(Game.getMonsterTypes()) do
			mtype:createLoot(allLootConfig)

			local category = nil
			local race = (mtype:bossRace() or ""):lower()

			if race == "archfoe" or race == "bane" or race == "nemesis" then
				category = "archfoe"
			end

			if category == "archfoe" then
				if bossLootConfig and #bossLootConfig > 0 then
					mtype:createLoot(bossLootConfig)
					logger.debug("[customMonsterLoot.onStartup] - Boss loot registered for monster: {}", mtype:getName())
				end
			end

			logger.debug("[customMonsterLoot.onStartup] - Global loot registered for monster: {}", mtype:getName())
		end
	end
end

customMonsterLoot:register()
