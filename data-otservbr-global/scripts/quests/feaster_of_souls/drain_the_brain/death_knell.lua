local locations = {
	carlin = {from = Position(32408, 31780, 7), to = Position(32410, 31782, 7), storage = Storage.FeasterOfSouls.DeathKnell.Graveyard}, -- Carlin Graveyard
	ghostlands = {from = Position(32176, 31836, 8), to = Position(32178, 31838, 8), storage = Storage.FeasterOfSouls.DeathKnell.Ghostland}, -- Ghostlands
	cathedral = {from = Position(32628, 32415, 9), to = Position(32630, 32417, 9), storage = Storage.FeasterOfSouls.DeathKnell.DarkCathedral} -- Dark Cathedral
}

local counter = Storage.FeasterOfSouls.DeathKnell.Counter

local deathKnell = Action()

function deathKnell.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, location in pairs(locations) do
	
		if player:getStorageValue(counter) < 0 then
			player:setStorageValue(counter, 0)
		end		
		if index == "carlin" and player:getStorageValue(location.storage) <= 0 and player:getPosition():isInRange(location.from, location.to) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Ring!')
			player:getPosition():sendMagicEffect(CONST_ME_GHOST_SMOKE)
			player:setStorageValue(location.storage, 1)
			player:setStorageValue(counter, player:getStorageValue(counter) + 1)
		elseif index == "ghostlands" and player:getStorageValue(location.storage) <= 0 and player:getPosition():isInRange(location.from, location.to) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Ring!')
			player:getPosition():sendMagicEffect(CONST_ME_GHOST_SMOKE)
			player:setStorageValue(location.storage, 1)
			player:setStorageValue(counter, player:getStorageValue(counter) + 1)
		elseif index == "cathedral" and player:getStorageValue(location.storage) <= 0 and player:getPosition():isInRange(location.from, location.to) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Ring!')
			player:getPosition():sendMagicEffect(CONST_ME_GHOST_SMOKE)
				player:setStorageValue(location.storage, 1)
				player:setStorageValue(counter, player:getStorageValue(counter) + 1)
		end
			
		if not player:getPosition():isInRange(locations.carlin.from, locations.carlin.to) and not player:getPosition():isInRange(locations.ghostlands.from, locations.ghostlands.to) and not player:getPosition():isInRange(locations.cathedral.from, locations.cathedral.to) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Ring!')
			player:getPosition():sendMagicEffect(CONST_ME_SOUND_WHITE)
			return false
		end
	end
	return true
end

deathKnell:id(32582)
deathKnell:register()