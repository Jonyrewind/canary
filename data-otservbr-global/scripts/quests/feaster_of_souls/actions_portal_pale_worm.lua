local storagesTable = {
	{ storage = Storage.Quest.U12_30.FeasterOfSouls.FearFeasterKilled, bossName = "The Fear Feaster" },
	{ storage = Storage.Quest.U12_30.FeasterOfSouls.DreadMaidenKilled, bossName = "The Dread Maiden" },
	{ storage = Storage.Quest.U12_30.FeasterOfSouls.UnwelcomeKilled, bossName = "The Unwelcome" },
}

local portalPaleWorm = MoveEvent()
function portalPaleWorm.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local text = ""
	for value in pairs(storagesTable) do
		if player:getStorageValue(storagesTable[value].storage) < 0 then
			text = text .. "\n" .. storagesTable[value].bossName
		end
	end

	if text == "" then
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You still need to defeat:" .. text)
	player:teleportTo(fromPosition, true)
	return false
end

portalPaleWorm:type("stepin")
portalPaleWorm:position({ x = 33570, y = 31444, z = 10 })
portalPaleWorm:register()

local paleWormExitPortal = MoveEvent()

local function isInsidePaleWormEncounter(position)
	if not position then
		return false
	end

	local bossRoomCenter = Position(33805, 31504, 14)
	local lowerRoomCenter = Position(33805, 31504, 15)
	local rangeX, rangeY = 12, 12

	local function inRange(center)
		return position.z == center.z
			and math.abs(position.x - center.x) <= rangeX
			and math.abs(position.y - center.y) <= rangeY
	end

	return inRange(bossRoomCenter) or inRange(lowerRoomCenter)
end

local function removePaleWormHex(player)
	removePaleWormGreaterHex(player)
end

function paleWormExitPortal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if isInsidePaleWormEncounter(fromPosition) then
		removePaleWormHex(player)
	end

	return true
end

paleWormExitPortal:type("stepin")
paleWormExitPortal:position({ x = 33809, y = 31515, z = 14 })
paleWormExitPortal:register()
