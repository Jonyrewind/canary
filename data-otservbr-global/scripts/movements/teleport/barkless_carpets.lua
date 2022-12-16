local teleports = {
	{position = {x = 32718, y = 31444, z = 8}, destination = Position(32715, 31444, 8)},
	{position = {x = 32737, y = 31451, z = 8}, destination = Position(32735, 31451, 8)}
	
}

local barkless = MoveEvent()

function barkless.onStepIn(creature, item, position, fromPosition)
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
		end
	end
end

for a = 1, #teleports do
	if teleports[a].position then
		barkless:position(teleports[a].position)
	elseif teleports[a].positions then
		for b = 1, #teleports[a].positions do
			barkless:position(teleports[a].positions[b])
		end
	end
end
barkless:register()