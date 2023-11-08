local oramondSeacrest = MoveEvent()

function oramondSeacrest.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(33542, 31632, 14))
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You enter the seacrest ground.")
	return true
end

oramondSeacrest:type("stepin")
oramondSeacrest:uid(1110)
oramondSeacrest:register()
