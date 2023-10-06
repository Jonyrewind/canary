local dpdoor = Action()

function dpdoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition().y == 32497 then
		player:teleportTo(Position(32392, 32495, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(Position(32392, 32497, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

dpdoor:aid(59606)
dpdoor:register()
