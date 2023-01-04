local ferumbrasAscendantSacrifice = Action()
function ferumbrasAscendantSacrifice.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local statue = Tile(Position(33415, 32379, 12)):getItemById(22163)
	if not target.actionid == 53805 or statue or player:getStorageValue(Storage.FerumbrasAscension.Fount) >= 4 then
		return false
	end
	if item.itemid == 22158 then
		if player:getStorageValue(Storage.FerumbrasAscension.Bone) >= 1 then
			player:say('You already put the kingly bones into the dried well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Bone, 1)
		text = "You put the kingly bones into the dried well.\z
				They crumble to dust instantly as if devoured by the well."
	elseif item.itemid == 22170 then
		if player:getStorageValue(Storage.FerumbrasAscension.Ring2) >= 1 then
			player:say('You already put the signet ring into the dried well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Ring2, 1)
		text = "You put the signet ring into the dried well.\z
				It's silver blackens immediately."
	elseif item.itemid == 9685 then
		if player:getStorageValue(Storage.FerumbrasAscension.Vampire) >= 1 then
			player:say('You already put the vampire teeth into the dried well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Vampire, 1)
		text = "You put the vampire teeth into the dried well.\z
				They are clacking softly as they're falling down."
	elseif item.itemid == 3661 then
		if player:getStorageValue(Storage.FerumbrasAscension.Flower) >= 1 then
			player:say('You already put the grave flower into the dried well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Flower, 1)
		text = "You put a grave flower into the dried well.\z
				It withers instantly."
	end
	if player:getStorageValue(Storage.FerumbrasAscension.Fount) == 3 then
		local statue1 = Tile(Position(33415, 32379, 12)):getItemById(22163)
		if statue1 then
			statue1:transform(22161)
		end
	end
	
	if player:getStorageValue(Storage.FerumbrasAscension.Fount) < 0 then
	player:setStorageValue(Storage.FerumbrasAscension.Fount, 0)
	end
	player:setStorageValue(Storage.FerumbrasAscension.Fount, player:getStorageValue(Storage.FerumbrasAscension.Fount) + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '' ..text.. '')
	toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
	item:remove(1)
	return true
end

ferumbrasAscendantSacrifice:id(3661,9685,22158,22170)
ferumbrasAscendantSacrifice:register()