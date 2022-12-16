local teleports = {
	{position = {x = 33544, y = 31444, z = 8}, destination = Position(33533, 31444, 8)},
	{position = {x = 33535, y = 31444, z = 8}, destination = Position(33546, 31444, 8)},
	{position = {x = 33484, y = 31435, z = 8}, destination = Position(33482, 31452, 9)},
	{position = {x = 33481, y = 31452, z = 9}, destination = Position(33485, 31435, 8)},	
	{position = {x = 33570, y = 31467, z = 9}, destination = Position(33557, 31467, 9)},
	{position = {x = 33558, y = 31467, z = 9}, destination = Position(33571, 31467, 9)},
	{position = {x = 33539, y = 31440, z = 9}, destination = Position(33550, 31440, 9)},
	{position = {x = 33549, y = 31440, z = 9}, destination = Position(33538, 31440, 9)},
	{position = {x = 33531, y = 31410, z = 9}, destination = Position(33541, 31411, 9)},
	{position = {x = 33540, y = 31411, z = 9}, destination = Position(33530, 31410, 9)}	
	
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