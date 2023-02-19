local destination = {
	[3310] = Position(31912, 32354, 8), --Entrance to BrainGrounds
	[3316] = Position(33614, 31414, 8) --Entrance to Netherworld
}

local BrainGroundsAccess = MoveEvent()

function BrainGroundsAccess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = destination[item.actionid]
	if teleport and player:getStorageValue(Storage.FeasterOfSouls.BrainGroundsAccess) == 1 then
		player:teleportTo(teleport)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		teleport:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

BrainGroundsAccess:type("stepin")

for index, value in pairs(destination) do
	BrainGroundsAccess:aid(index)
end

BrainGroundsAccess:register()