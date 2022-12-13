local teleports = {
	[4701] = {x = 34010, y = 31014, z = 9}, --Claustrophobic Inferno
	[4702] = {x = 33972, y = 31040, z = 11}, -- Rotten Wasteland
	[4703] = {x = 33892, y = 31019, z = 8}, -- Ebb and Flow
	[4704] = {x = 33858, y = 31831, z = 3}, -- Furious Crater
	[4705] = {x = 33886, y = 31188, z = 10}, -- Mirrored Nightmare
	[4710] = {x = 33831, y = 31881, z = 4}, --Furious Crater TPS	
	[4711] = {x = 33856, y = 31888, z = 5} --Furious Crater TPS
	
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:teleportTo(Position(teleports[item.uid]))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleport:type("stepin")

for index, value in pairs(teleports) do
	teleport:uid(index)
end

teleport:register()