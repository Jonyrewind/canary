local doors = {
	{ closedDoor = 22506, openDoor = 22507 },
	{ closedDoor = 8259, openDoor = 8260 },
	{ closedDoor = 5131, openDoor = 5132 }
}

local door = Action()

function door.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, value in ipairs(doors) do
		if value.closedDoor == item.itemid then
			item:transform(value.openDoor)
			player:teleportTo(toPosition, true)
			return true
		end
	end

	if Creature.checkCreatureInsideDoor(player, toPosition) then
		return true
	end
	return true
end

door:uid(3250, 3251, 3252, 3253, 3254)
door:register()

local dpdoor = Action()

function dpdoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition().y == 32497 then
		player:teleportTo(Position(32392, 32495, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(Position(32392, 32497, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

dpdoor:aid(59606)
dpdoor:register()