local teleports = {
	[3270] = Position(33618, 32544, 13), --tp to haunted house	
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	
	local hauntedhouse = teleports[item.actionid]

	player:teleportTo(hauntedhouse)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end


teleport:type("stepin")

for index, value in pairs(teleports) do
	teleport:aid(index)
end

teleport:register()


local tdcdoor = Action()

function tdcdoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = player:getPosition()
	if position.y == toPosition.y then
		return false
	end

	toPosition.y = position.y > toPosition.y and toPosition.y - 1 or toPosition.y + 1
	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

tdcdoor:aid(3271)
tdcdoor:register()