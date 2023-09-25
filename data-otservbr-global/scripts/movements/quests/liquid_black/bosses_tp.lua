local tps = {
	[7900] = {
		storage = Storage.DeeplingBosses.TanjisTP,
		bossName = "Tanjis",
		centerPosition = Position({x = 33644, y = 31242, z = 11}), 
		newPos = Position({x = 33647, y = 31254, z = 11}), 
		kickPos = Position({x = 33647, y = 31262, z = 11}), 
		centerRangeX = 11, 
		centerRangeY = 14
	},
	[7901] = {exitPos = Position({x = 33647, y = 31262, z = 11})},

	[7902] = {
		storage = Storage.DeeplingBosses.JaulTP,
		bossName = "Jaul",
		centerPosition = Position({x = 33542, y = 31270, z = 11}), 
		newPos = Position({x = 33545, y = 31263, z = 11}), 
		kickPos = Position({x = 33558, y = 31283, z = 11}),
		centerRangeX = 13, 
		centerRangeY = 10
	},
	[7903] = {exitPos = Position({x = 33558, y = 31283, z = 11})},

	[7904] = {
		storage = Storage.DeeplingBosses.ObujosTP,
		bossName = "Obujos",
		centerPosition = Position({x = 33429, y = 31263, z = 11}),  
		newPos = Position({x = 33419, y = 31255, z = 11}), 
		kickPos = Position({x = 33438, y = 31249, z = 11}), 
		centerRangeX = 14, 
		centerRangeY = 10
	},
	[7905] = {exitPos = Position({x = 33438, y = 31249, z = 11})},
}
local miniBosses = MoveEvent()

function miniBosses.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local aid = item:getActionId()
	local data = tps[aid]
	if not data then
		player:teleportTo(fromPosition, true)
		return true
	end
	if data.exitPos then
		player:teleportTo(data.exitPos)
		data.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if player:getStorageValue(data.storage) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already fought with "..data.bossName..", the time of battle is over. Now go forth to collect your reward.")
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	position:sendMagicEffect(CONST_ME_TELEPORT)
	data.newPos:sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(data.newPos)
	addEvent(function(id)
		if not Player(id) then
			return false
		end
		local spec = Game.getSpectators(Position(data.centerPosition), false, true, data.centerRangeX, data.centerRangeX, data.centerRangeY, data.centerRangeY)
		for _, pid in pairs(spec) do
			if pid:getId() == id then
				pid:teleportTo(data.kickPos)
				data.kickPos:sendMagicEffect(CONST_ME_TELEPORT)
				player:setStorageValue(data.storage, 1)
				break		
			end
		end
			player:setStorageValue(data.storage, 1)
		end, 20 * 60 * 1000, player:getId())
	return true
end

miniBosses:type("stepin")
for id, data in pairs(tps) do
	miniBosses:aid(id)
end
miniBosses:register()