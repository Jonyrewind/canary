local ActionTable = {
	[3260] = {
		newPos = {x = 32403, y = 32496, z = 10}
	},
	[3261] = {
		newPos = {x = 32425, y = 32498, z = 10}
	}
}

local entranceTeleport = MoveEvent()

function entranceTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local setting = ActionTable[item.actionid]
	if not setting then
		return true
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(setting.newPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	if item.actionid == 3260 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The fringe of an eerie forest of decrepid and deformed trees opens up befor you...")
	end
	return true
end

for index, value in pairs(ActionTable) do
	entranceTeleport:aid(index)
end

entranceTeleport:register()