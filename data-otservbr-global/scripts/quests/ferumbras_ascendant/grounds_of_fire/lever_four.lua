local config = {
	toPosition = Position(33593, 32658, 14),
	backPosition = Position(33675, 32690, 13),
	bloodPosition = Position(33671, 32689, 13),
	grassPosition = Position(33672, 32689, 13),
	icePosition = Position(33673, 32689, 13),
	color = Storage.FerumbrasAscension.Elements,
	timer = Storage.FerumbrasAscension.TarbazTimer
}

local ferumbrasAscendantLevelFour = Action()
function ferumbrasAscendantLevelFour.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(config.color) >= 4 then
		if player:getPosition() == Position(config.bloodPosition) and player:getStorageValue(config.color) == 4 then
			if player:getStorageValue(config.timer) < os.time() then
				player:teleportTo(config.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
				return true
			end
		elseif player:getPosition() == Position(config.grassPosition) and player:getStorageValue(config.color) == 5 then
			if player:getStorageValue(config.timer) < os.time() then
				player:teleportTo(config.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
				return true
			end
		elseif player:getPosition() == Position(config.icePosition) and player:getStorageValue(config.color) == 6 then
			if player:getStorageValue(config.timer) < os.time() then
				player:teleportTo(config.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
				return true
			end
		else
			player:say('You have to stand in the right position!', TALKTYPE_MONSTER_SAY)
				return true
		end
	return true
	end
	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Active) < 1 then
		return false
	end
	if item.itemid == 9110 then
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done) < 4 then
			local spectators = Game.getSpectators(item:getPosition(), false, false, 9, 9, 6, 6)
			for i = 1, #spectators do
				if spectators[i]:isPlayer() then
					local spec = spectators[i]
					spec:teleportTo(Position(33646, 32654, 14))
					spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
			revertStorages()
			return true
		end
			
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done) >= 4 then
			Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done, 4)
		end
	end
	return true
end

ferumbrasAscendantLevelFour:aid(53824)
ferumbrasAscendantLevelFour:register()