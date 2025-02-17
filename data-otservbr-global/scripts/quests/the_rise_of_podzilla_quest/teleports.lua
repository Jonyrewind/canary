local entrances = {
	{ position = Position(33829, 32025, 7), destination = Position(33826, 32001, 8) },
	{ position = Position(33825, 32000, 8), destination = Position(33830, 32024, 7) },
	{ position = Position(33848, 32058, 8), destination = Position(33858, 32066, 8) },
	{ position = Position(33836, 31982, 6), destination = Position(33847, 32060, 8) },
	{ position = Position(33857, 32068, 8), destination = Position(33847, 32060, 8) },
	{ position = Position(32720, 32969, 15), destination = Position(33834, 31984, 6) },
	{ position = Position(32694, 32989, 14), destination = Position(33834, 31984, 6) },
	{ position = Position(33820, 31999, 9), destination = Position(32719, 32971, 15) },
	{ position = Position(32558, 32941, 15), destination = Position(33818, 32001, 9) },
	{ position = Position(32543, 32936, 15), destination = Position(33818, 32001, 9) },
	{ position = Position(33848, 31986, 10), destination = Position(32724, 32919, 15) },
	{ position = Position(32726, 32922, 15), destination = Position(33848, 31990, 10) },
	{ position = Position(32688, 32908, 15), destination = Position(33848, 31990, 10) },
	{ position = Position(33855, 31984, 11), destination = Position(32621, 32906, 15) },
	{ position = Position(32616, 32917, 15), destination = Position(33852, 31983, 11) },
	{ position = Position(32620, 32936, 15), destination = Position(33852, 31983, 11) },
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
			position:sendMagicEffect(CONST_ME_WATERSPLASH)
			entrance.destination:sendMagicEffect(CONST_ME_WATERSPLASH)
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
