local teleports = {
	{ position = Position(33036, 32737, 2), destination = Position(33842, 32854, 7) }, --Port Hope to Marapur
	{ position = Position(33842, 32852, 7), destination = Position(33036, 32739, 2) }, --Marapur to Port Hope
}

local marapur = MoveEvent()

function marapur.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for c = 1, #teleports do
		if teleports[c].position then
			if player:getPosition() == Position(teleports[c].position) then
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(teleports[c].destination)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		elseif teleports[c].positions then
			for d = 1, #teleports[c].positions do
				if player:getPosition() == Position(teleports[c].positions[d]) then
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:teleportTo(teleports[c].destination)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
	end
end

for a = 1, #teleports do
	if teleports[a].position then
		marapur:position(teleports[a].position)
	elseif teleports[a].positions then
		for b = 1, #teleports[a].positions do
			marapur:position(teleports[a].positions[b])
		end
	end
end
marapur:register()