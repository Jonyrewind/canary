local setting = {
	leverPosition = {
		lever1 = Position(32723, 32972, 15),
		lever2 = Position(32563, 32940, 15),
		lever3 = Position(32728, 32913, 15),
		lever4 = Position(32618, 32908, 15),
		lever5 = Position(33848, 31994, 10),
	},
	looktypes = { 1693, 1694, 1695, 1696, 1698 },
	playersPositions = {
		lever1 = {
			{ fromPos = { x = 32723, y = 32973, z = 15 }, toPos = { x = 32693, y = 32987, z = 14 } },
			{ fromPos = { x = 32723, y = 32974, z = 15 }, toPos = { x = 32693, y = 32987, z = 14 } },
			{ fromPos = { x = 32723, y = 32975, z = 15 }, toPos = { x = 32693, y = 32987, z = 14 } },
			{ fromPos = { x = 32723, y = 32976, z = 15 }, toPos = { x = 32693, y = 32987, z = 14 } },
			{ fromPos = { x = 32723, y = 32977, z = 15 }, toPos = { x = 32693, y = 32987, z = 14 } },
		},
		lever2 = {
			{ fromPos = { x = 32563, y = 32941, z = 15 }, toPos = { x = 32541, y = 32938, z = 15 } },
			{ fromPos = { x = 32563, y = 32942, z = 15 }, toPos = { x = 32541, y = 32938, z = 15 } },
			{ fromPos = { x = 32563, y = 32943, z = 15 }, toPos = { x = 32541, y = 32938, z = 15 } },
			{ fromPos = { x = 32563, y = 32944, z = 15 }, toPos = { x = 32541, y = 32938, z = 15 } },
			{ fromPos = { x = 32563, y = 32945, z = 15 }, toPos = { x = 32541, y = 32938, z = 15 } },
		},
		lever3 = {
			{ fromPos = { x = 32728, y = 32914, z = 15 }, toPos = { x = 32689, y = 32904, z = 15 } },
			{ fromPos = { x = 32728, y = 32915, z = 15 }, toPos = { x = 32689, y = 32904, z = 15 } },
			{ fromPos = { x = 32728, y = 32916, z = 15 }, toPos = { x = 32689, y = 32904, z = 15 } },
			{ fromPos = { x = 32728, y = 32917, z = 15 }, toPos = { x = 32689, y = 32904, z = 15 } },
			{ fromPos = { x = 32728, y = 32918, z = 15 }, toPos = { x = 32689, y = 32904, z = 15 } },
		},
		lever4 = {
			{ fromPos = { x = 32618, y = 32909, z = 15 }, toPos = { x = 32618, y = 32941, z = 15 } },
			{ fromPos = { x = 32618, y = 32910, z = 15 }, toPos = { x = 32618, y = 32941, z = 15 } },
			{ fromPos = { x = 32618, y = 32911, z = 15 }, toPos = { x = 32618, y = 32941, z = 15 } },
			{ fromPos = { x = 32618, y = 32912, z = 15 }, toPos = { x = 32618, y = 32941, z = 15 } },
			{ fromPos = { x = 32618, y = 32913, z = 15 }, toPos = { x = 32618, y = 32941, z = 15 } },
		},
	},
}

local helm = Action()

function helm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for key, leverPos in pairs(setting.leverPosition) do
		if fromPosition == leverPos then  -- Ensure correct position comparison
			if key == "lever5" then  -- Special action for helm1
				if player:getPosition().y == 31993 then
					player:teleportTo(Position(33848, 31995, 10))
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				else
					player:teleportTo(Position(33848, 31993, 10))
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
			local positions = setting.playersPositions[key] -- Get corresponding player positions
			if positions then
				for _, pos in ipairs(positions) do
					local creature = Tile(pos.fromPos):getTopCreature()
					if creature and creature:isPlayer() then
						creature:teleportTo(pos.toPos)
					end
				end
			end
			return true
		end
	end
	return false
end

-- Register all helm positions
for _, pos in pairs(setting.leverPosition) do
    helm:position(pos)
end
helm:register()