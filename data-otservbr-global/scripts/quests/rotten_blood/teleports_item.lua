local teleports = {
	{ pos = { x = 34092, y = 31978, z = 14 }, destination = Position(33842, 31652, 13), effect = CONST_ME_ENERGYHIT, access = Storage.Quest.U13_20.RottenBlood.Access.Hunts, msg = { fail = "You should pay respect to the Bloodshade guarding this realm befor entering", succes = "You begin to feel the dark power of the rot." } }, -- Jaded Roots Entrance
	{ pos = { x = 33842, y = 31650, z = 13 }, destination = Position(34094, 31980, 14), effect = CONST_ME_ENERGYHIT }, -- Jaded Roots Exit

	{ pos = { x = 34120, y = 31978, z = 14 }, destination = Position(34101, 31679, 13), effect = CONST_ME_ENERGYHIT, access = Storage.Quest.U13_20.RottenBlood.Access.Hunts, msg = { fail = "You should pay respect to the Bloodshade guarding this realm befor entering", succes = "You begin to feel the dark power of the rot." } }, -- Putrefactory Entrance
	{ pos = { x = 34101, y = 31677, z = 13 }, destination = Position(34120, 31980, 14), effect = CONST_ME_ENERGYHIT }, -- Putrefactory Exit

	{ pos = { x = 34093, y = 32009, z = 14 }, destination = Position(33809, 31816, 13), effect = CONST_ME_ENERGYHIT, access = Storage.Quest.U13_20.RottenBlood.Access.Hunts, msg = { fail = "You should pay respect to the Bloodshade guarding this realm befor entering", succes = "You begin to feel the dark power of the rot." } }, -- Gloom Pillars Entrance
	{ pos = { x = 33809, y = 31814, z = 13 }, destination = Position(34092, 32007, 14), effect = CONST_ME_ENERGYHIT }, -- Gloom Pillars Exit

	{ pos = { x = 34117, y = 32010, z = 15 }, destination = Position(34118, 31877, 14), effect = CONST_ME_ENERGYHIT, access = Storage.Quest.U13_20.RottenBlood.Access.Hunts, msg = { fail = "You should pay respect to the Bloodshade guarding this realm befor entering", succes = "You begin to feel the dark power of the rot." } }, -- Darklight Core Entrance
	{ pos = { x = 34119, y = 31875, z = 14 }, destination = Position(34119, 32009, 15), effect = CONST_ME_ENERGYHIT }, -- Darklight Core Exit
}

local teleport = Action()

function teleport.onUse(creature, item, fromPosition, itemEx, toPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for b = 1, #teleports do
		if item:getPosition() == Position(teleports[b].pos) then
			if teleports[b].access then
				if player:getStorageValue(teleports[b].access) == 1 then
					player:teleportTo(teleports[b].destination)
					player:getPosition():sendMagicEffect(teleports[b].effect)
					if teleports[b].msg.succes then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, teleports[b].msg.succes)
					end
				else
					if teleports[b].damage == true and player:getHealth() > 3 then
						local damage = player:getHealth() * 0.25
						doTargetCombatHealth(0, player, COMBAT_AGONYDAMAGE, -damage, -damage, CONST_ME_NONE)
					end
					if teleports[b].msg.fail then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, teleports[b].msg.fail)
					end
				end
			else
				player:teleportTo(teleports[b].destination)
				if teleports[b].msg then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, teleports[b].msg)
				end
				player:getPosition():sendMagicEffect(teleports[b].effect)
				return true
			end
		end
	end
end

for a = 1, #teleports do
	teleport:position(teleports[a].pos)
end
teleport:register()
