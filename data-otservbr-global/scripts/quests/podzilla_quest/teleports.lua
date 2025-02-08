local entrances = {
	{ position = Position(33829, 32025, 7), destination = Position(33826, 32001, 8) },
	{ position = Position(33825, 32000, 8), destination = Position(33830, 32024, 7) },
	{ position = Position(33848, 32058, 8), destination = Position(33858, 32066, 8) },
	{ position = Position(33857, 32068, 8), destination = Position(33847, 32060, 8) },
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
			player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
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
