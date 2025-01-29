local oramondSeacrest = MoveEvent()

function oramondSeacrest.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local headItem = player:getSlotItem(CONST_SLOT_HEAD)
	if headItem and table.contains({ 5460, 11585, 13995 }, headItem.itemid) then
		player:teleportTo(Position(33542, 31632, 14))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You enter the seacrest ground.")
	else
		player:teleportTo(Position(33545, 31860, 7))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wear an underwater exploration helmet in order to dive.")
	end
	return true
end

oramondSeacrest:type("stepin")
oramondSeacrest:uid(1110)
oramondSeacrest:register()
