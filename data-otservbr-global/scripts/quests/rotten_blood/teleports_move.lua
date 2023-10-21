local teleports = {
	{ pos = { x = 32953, y = 32398, z = 9 }, destination = Position(34070, 31976, 14), effect = CONST_ME_DRAWBLOOD, access = Storage.Quest.U13_20.RottenBlood.Access.SacrificialPlate, msg = { fail = "Your offerings to the sanguine master of this realm have been insufficient. You can not pass." }, damage = true }, -- Drefia to Blood Vestibule
	{ pos = { x = 34070, y = 31974, z = 14 }, destination = Position(32955, 32398, 9), msg = "The dark rot has left your body.", effect = CONST_ME_DRAWBLOOD }, -- Blood Vestibule Exit
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, fromPosition, itemEx, toPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for b = 1, #teleports do
		if teleports[b].pos then
			if player:getPosition() == Position(teleports[b].pos) then
				if teleports[b].access then
					if player:getStorageValue(teleports[b].access) == 1 then
						player:teleportTo(teleports[b].destination)
						player:getPosition():sendMagicEffect(teleports[b].effect)
						if teleports[b].msg.succes then
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, teleports[b].msg.succes)
						end
					else
						fromPosition.x = fromPosition.x + 2
						player:getPosition():sendMagicEffect(teleports[b].effect)
						player:teleportTo(fromPosition)
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
end

teleport:type("stepin")

for a = 1, #teleports do
	teleport:position(teleports[a].pos)
end
teleport:register()
