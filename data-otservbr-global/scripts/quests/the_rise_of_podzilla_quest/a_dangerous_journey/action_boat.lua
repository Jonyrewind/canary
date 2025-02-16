local setting = {
	helmPosition = {
		helm1 = Position(33969, 31978, 8),
		helm2 = Position(33860, 32012, 5),
	},
	looktypes = { 1693, 1694, 1695, 1696, 1698 },
	playersPositions = {
		helm1 = {
			{ fromPos = { x = 33970, y = 31978, z = 8 }, toPos = { x = 33873, y = 31998, z = 4 } },
			{ fromPos = { x = 33971, y = 31978, z = 8 }, toPos = { x = 33873, y = 31998, z = 4 } },
			{ fromPos = { x = 33972, y = 31978, z = 8 }, toPos = { x = 33873, y = 31998, z = 4 } },
			{ fromPos = { x = 33973, y = 31978, z = 8 }, toPos = { x = 33873, y = 31998, z = 4 } },
			{ fromPos = { x = 33974, y = 31978, z = 8 }, toPos = { x = 33873, y = 31998, z = 4 } },
		},
		helm2 = {
			{ fromPos = { x = 33861, y = 32012, z = 5 }, toPos = { x = 33173, y = 31763, z = 6 } },
		},
	},
	plantPositions = {
		{ fromPos = Position(33803, 31996, 4), toPos = Position(33849, 32011, 6) },
		{ fromPos = Position(33803, 31995, 4), toPos = Position(33849, 32011, 6) },
		{ fromPos = Position(33803, 31994, 4), toPos = Position(33849, 32011, 6) },
		{ fromPos = Position(33803, 31993, 4), toPos = Position(33849, 32011, 6) },
	},
}

local helm = Action()

function helm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for key, helmPos in pairs(setting.helmPosition) do
		if fromPosition == helmPos then -- Ensure correct position comparison
			local positions = setting.playersPositions[key] -- Get corresponding player positions
			if positions then
				for _, pos in ipairs(positions) do
					local creature = Tile(pos.fromPos):getTopCreature()
					if creature and creature:isPlayer() then
						creature:teleportTo(pos.toPos)

						if key == "helm1" then -- Special action for helm1
							creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "What's that huge shadow in the distance, an island?")
							local randomLooktype = setting.looktypes[math.random(#setting.looktypes)]
							local condition = Condition(CONDITION_OUTFIT)
							condition:setOutfit({ lookType = randomLooktype })
							condition:setTicks(-1)
							creature:addCondition(condition)
							creature:say("You have boarded your ship. The sea is getting restless, watch out!", TALKTYPE_MONSTER_SAY)
						end
					end
				end
			end
			return true
		end
	end
	return false
end

-- Register all helm positions
for _, pos in pairs(setting.helmPosition) do
	helm:position(pos)
end
helm:register()

local plant = MoveEvent()

function plant.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	-- Find a matching plant teleport position
	for _, plantData in ipairs(setting.plantPositions) do
		if position == plantData.fromPos then
			player:teleportTo(plantData.toPos)
			player:removeCondition(CONDITION_OUTFIT) -- Ensure correct outfit removal
			player:kv():scoped("the-rise-of-podzilla-quest"):set("shortcut", 1)
			break
		end
	end
end

-- Register plant positions dynamically
for _, plantData in ipairs(setting.plantPositions) do
	plant:position(plantData.fromPos)
end
plant:register()
