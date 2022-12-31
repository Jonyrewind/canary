local ferumbrasAscendantHabitatLever = Action()
function ferumbrasAscendantHabitatLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FerumbrasAscension.HabitatsAccess) >= 1 then
		return false
	end

	if item.itemid == 9125 then
			player:setStorageValue(Storage.FerumbrasAscension.HabitatsAccess, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "In another room south of this one, something just made a loud booming sound.")
			toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
		item:transform(9126)
	elseif item.itemid == 9126 then
		item:transform(9125)
	end
	return true
end

ferumbrasAscendantHabitatLever:aid(34324)
ferumbrasAscendantHabitatLever:register()