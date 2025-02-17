local entrances = {
	{ position = Position(33574, 32222, 7), destination = Position(33338, 32126, 7) },
	{ position = Position(33575, 32222, 7), destination = Position(33339, 32126, 7) },
	{ position = Position(33338, 32125, 7), destination = Position(33574, 32223, 7) },
	{ position = Position(33339, 32125, 7), destination = Position(33575, 32223, 7) },
	{ position = Position(33372, 32241, 9), destination = Position(33397, 32201, 9) },
}

local teleportEvent = MoveEvent()

function teleportEvent.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for _, entrance in pairs(entrances) do
		if entrance.position == position then
			player:teleportTo(entrance.destination)
			player:getPosition():sendMagicEffect(CONST_ME_CANDY_FLOSS)
			break
		end
	end

	return true
end

teleportEvent:type("stepin")
for _, entrance in pairs(entrances) do
	teleportEvent:position(entrance.position)
end
teleportEvent:register()