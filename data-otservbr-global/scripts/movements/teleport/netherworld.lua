local teleports = {
	{position = {x = 33544, y = 31444, z = 8}, destination = Position(33533, 31444, 8)},
	{position = {x = 33535, y = 31444, z = 8}, destination = Position(33329, 31332, 9)},
	{position = {x = 33484, y = 31435, z = 8}, destination = Position(33483, 31451, 9)},
	{position = {x = 33481, y = 31452, z = 9}, destination = Position(33486, 31435, 8)},	
	{position = {x = 33570, y = 31467, z = 9}, destination = Position(33572, 31465, 9)},
	{position = {x = 33558, y = 31467, z = 9}, destination = Position(33556, 31469, 9)}
}

local netherworld = MoveEvent()

function netherworld.onStepIn(creature, item, position, fromPosition)
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
		netherworld:position(teleports[a].position)
	elseif teleports[a].positions then
		for b = 1, #teleports[a].positions do
			netherworld:position(teleports[a].positions[b])
		end
	end
end
netherworld:register()