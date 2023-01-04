local ferumbrasAscendantStatue = Action()
function ferumbrasAscendantStatue.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Tile(Position(33415, 32379, 12)):getItemById(22163) or player:getStorageValue(Storage.FerumbrasAscension.Fount) < 4 or player:getStorageValue(Storage.FerumbrasAscension.Statue) >= 1 then
		return false
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You douse the sacred statue\'s flame. The room darkens.')
	player:setStorageValue(Storage.FerumbrasAscension.Statue, 1)
	item:transform(22163)
	return true
end

ferumbrasAscendantStatue:id(22161)
ferumbrasAscendantStatue:register()