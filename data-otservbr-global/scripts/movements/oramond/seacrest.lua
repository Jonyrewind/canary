local teleports = {
	{ position = Position(33552, 31628, 13), destination = Position(33397, 31808, 13) }, --the western teleport > Lost Mountains
	{ position = Position(33399, 31808, 13), destination = Position(33551, 31623, 13) }, --Lost Mountains > the western teleport
	{ position = Position(33558, 31628, 13), destination = Position(33558, 31775, 13) }, --the eastern teleport > Sunken City
	{ position = Position(33562, 31775, 13), destination = Position(33558, 31626, 13) }, --Sunken City > the eastern teleport
	{ position = Position(33555, 31624, 13), destination = Position(33421, 31664, 13) }, --the northern teleport > Birthing Grounds
	{ position = Position(33423, 31663, 13), destination = Position(33553, 31622, 13) }, --Birthing Grounds > the northern teleport
	{ position = Position(33545, 31859, 7), destination = Position(33542, 31632, 14), delayOutfitRefresh = true }, --Oramond > Seacrest Grounds
	{ position = Position(33555, 31632, 13), destination = Position(33545, 31861, 7) }, --Seacrest Grounds > Oramond
	{ position = Position(33553, 31624, 15), destination = Position(33569, 31626, 15) }, --North West TP >
	{ position = Position(33567, 31624, 15), destination = Position(33552, 31626, 15) }, --North West TP <
}

local verticalTeleports = {
	{ itemid = 21741, zOffset = -1 },
	{ itemid = 21740, zOffset = 1 },
}

local seacrestArea = {
	fromPosition = Position(33362, 31611, 13),
	toPosition = Position(33595, 31912, 15),
}

local function handleSeacrestTeleport(creature, item, position)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for _, teleport in ipairs(teleports) do
		if teleport.position and position == teleport.position then
			player:teleportTo(teleport.destination, true)

			if teleport.delayOutfitRefresh then
				addEvent(function(playerId)
					local delayedPlayer = Player(playerId)
					if not delayedPlayer then
						return
					end

					delayedPlayer:removeCondition(CONDITION_OUTFIT)
					delayedPlayer:setOutfit(delayedPlayer:getOutfit())
					logger.info("[seacrest] delayed outfit refresh applied")
				end, 50, player:getId())
			end

			return true
		end
	end

	if position.x < seacrestArea.fromPosition.x or position.x > seacrestArea.toPosition.x or position.y < seacrestArea.fromPosition.y or position.y > seacrestArea.toPosition.y or position.z < seacrestArea.fromPosition.z or position.z > seacrestArea.toPosition.z then
		return true
	end

	for _, teleport in ipairs(verticalTeleports) do
		if item.itemid == teleport.itemid then
			local destination = Position(position.x, position.y, position.z)
			destination.z = destination.z + teleport.zOffset
			player:teleportTo(destination, true)
			return true
		end
	end

	return true
end

local oramondSeacrestPosition = MoveEvent()

function oramondSeacrestPosition.onStepIn(creature, item, position, fromPosition)
	return handleSeacrestTeleport(creature, item, position)
end

oramondSeacrestPosition:type("stepin")
for value in pairs(teleports) do
	if teleports[value].position then
		oramondSeacrestPosition:position(teleports[value].position)
	end
end
oramondSeacrestPosition:register()

local oramondSeacrestVertical = MoveEvent()

function oramondSeacrestVertical.onStepIn(creature, item, position, fromPosition)
	return handleSeacrestTeleport(creature, item, position)
end

oramondSeacrestVertical:type("stepin")
for value in pairs(verticalTeleports) do
	if verticalTeleports[value].itemid then
		oramondSeacrestVertical:id(verticalTeleports[value].itemid)
	end
end
oramondSeacrestVertical:register()
