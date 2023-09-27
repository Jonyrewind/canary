local config = {
	teleportId = 1949,
	-- Tanjis
	[1] = {
		Position = Position(33648, 31261, 11),
		bossName = 'Tanjis',
		actionID = 7900,
		storage = 1
	},	
	-- Jaul
	[2] = {
		Position = Position(33558, 31282, 11),
		bossName = 'Jaul',
		actionID = 7902,
		storage = 2
	},	
	-- Obujos
	[3] = {
		Position = Position(33438, 31248, 11),
		bossName = 'Obujos',
		actionID = 7904,
		storage = 3
	},		
}

local storage = getGlobalStorage(GlobalStorage.DeeplingBossesTP)
local gray = GlobalEvent("gray island bosses")
function gray.onStartup()
	local randBoss = config[math.random(#config)]
	if storage > 0 then
		if storage == 1 then
			local item = Game.createItem(config.teleportId, 1, config[1].Position)
			item:setActionId(7900)
			logger.info("[WorldChanges] Gray Island Boss: still Tanjis")
		elseif storage == 2 then
			local item = Game.createItem(config.teleportId, 1, config[2].Position)
			item:setActionId(7902)
			logger.info("[WorldChanges] Gray Island Boss: still Jaul")
		elseif storage == 3 then
			local item = Game.createItem(config.teleportId, 1, config[3].Position)
			item:setActionId(7904)
			logger.info("[WorldChanges] Gray Island Boss: still Obujos")
		end
	else
		local item = Game.createItem(config.teleportId, 1, randBoss.Position)
		if not item:isTeleport() then
			item:remove()
			return false
		end	
		item:setActionId(randBoss.actionID)
		setGlobalStorage(GlobalStorage.DeeplingBossesTP, randBoss.storage)
		logger.info(string.format("[WorldChanges] Gray Island Boss: %s and storage is "..storage.."", randBoss.bossName))
	end
	return true
end

gray:register()
