local othersGraveFlower = Action()
function othersGraveFlower.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 3661 and isInArray({5468,5469}, target.itemid) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'With the aid of the device you create a vial of grave flower distillate.')
		target:getPosition():sendMagicEffect(CONST_ME_PURPLESMOKE)
		player:addItem(32603, 1)
		item:remove(1)
	end
	
	local statue = Tile(Position(33415, 32379, 12)):getItemById(22163)
	if not target.actionid == 53805 or statue or player:getStorageValue(Storage.FerumbrasAscension.Fount) >= 4 then
		return false
	end

	if player:getStorageValue(Storage.FerumbrasAscension.Fount) < 0 then
	player:setStorageValue(Storage.FerumbrasAscension.Fount, 0)
	end
	
	if item.itemid == 3661 then
		if player:getStorageValue(Storage.FerumbrasAscension.Flower) >= 1 then
			player:say('You already put the grave flower into the dried well.', TALKTYPE_MONSTER_SAY)
			return true
		end
		player:setStorageValue(Storage.FerumbrasAscension.Flower, 1)
		text = "You put a grave flower into the dried well.\z
				It withers instantly."
		player:setStorageValue(Storage.FerumbrasAscension.Fount, player:getStorageValue(Storage.FerumbrasAscension.Fount) + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '' ..text.. '')
		toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
		item:remove(1)
	end
	return false
end

othersGraveFlower:id(3661)
othersGraveFlower:register()