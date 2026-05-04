local teleports = {
	{ position = Position(33552, 31628, 13), destination = Position(33397, 31808, 13) }, --the western teleport > Lost Mountains
	{ position = Position(33399, 31808, 13), destination = Position(33551, 31623, 13) }, --Lost Mountains > the western teleport
	{ position = Position(33558, 31628, 13), destination = Position(33558, 31775, 13) }, --the eastern teleport > Sunken City
	{ position = Position(33562, 31775, 13), destination = Position(33558, 31626, 13) }, --Sunken City > the eastern teleport
	{ position = Position(33555, 31624, 13), destination = Position(33421, 31664, 13) }, --the northern teleport > Birthing Grounds
	{ position = Position(33423, 31663, 13), destination = Position(33553, 31622, 13) }, --Birthing Grounds > the northern teleport
	{ position = Position(33545, 31859, 7), destination = Position(33542, 31632, 14) }, --Oramond > Seacrest Grounds
	{ position = Position(33555, 31632, 13), destination = Position(33545, 31861, 7) }, --Seacrest Grounds > Oramond
}
local oramondSeacrest = MoveEvent()

function oramondSeacrest.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for value in pairs(teleports) do
		if Position(teleports[value].position) == player:getPosition() then
			player:teleportTo(Position(teleports[value].destination), true)
			return true
		end
	end
end

oramondSeacrest:type("stepin")
for value in pairs(teleports) do
	oramondSeacrest:position(teleports[value].position)
end
oramondSeacrest:register()
