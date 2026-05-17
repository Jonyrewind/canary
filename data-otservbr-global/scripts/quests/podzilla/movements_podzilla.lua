local Podzilla = {
	storage = Storage.Quest.U13_40.Podzilla.TheRiseofPodzilla,
	exitPositions = {
		{ pos = Position(33805, 31994, 4), teleport = Position(33850, 32011, 6) },
		{ pos = Position(33805, 31995, 4), teleport = Position(33850, 32011, 6) },
		{ pos = Position(33805, 31996, 4), teleport = Position(33850, 32011, 6) },
	},
	teleports = {
		{ pos = Position(33829, 32025, 7), teleport = Position(33826, 32001, 8), value = 1, effect = CONST_ME_WATERSPLASH },
		{ pos = Position(33825, 32000, 8), teleport = Position(33830, 32023, 7), value = 1, effect = CONST_ME_WATERSPLASH },
		{ pos = Position(33815, 31997, 7), teleport = Position(33819, 32000, 7), value = 2, effect = CONST_ME_ENERGYHIT },
		{ pos = Position(33817, 31998, 7), teleport = Position(33813, 31995, 7), value = 2, effect = CONST_ME_ENERGYHIT },
		{ pos = Position(33848, 32058, 8), teleport = Position(33858, 32066, 8), value = 3, effect = CONST_ME_WATERSPLASH },
		{ pos = Position(33857, 32068, 8), teleport = Position(33848, 32060, 8), value = 3, effect = CONST_ME_WATERSPLASH },
		{ pos = Position(33836, 31982, 6), teleport = Position(32719, 32971, 15), value = 0, effect = CONST_ME_TELEPORT },
		{ pos = Position(32720, 32969, 15), teleport = Position(33834, 31984, 6), value = 0, effect = CONST_ME_TELEPORT },
		{ pos = Position(33820, 31999, 9), teleport = Position(32559, 32943, 15), value = 0, effect = CONST_ME_TELEPORT },
		{ pos = Position(32558, 32941, 15), teleport = Position(33818, 32002, 9), value = 0, effect = CONST_ME_TELEPORT },
		{ pos = Position(33848, 31986, 10), teleport = Position(32724, 32919, 15), value = 0, effect = CONST_ME_TELEPORT },
		{ pos = Position(32726, 32922, 15), teleport = Position(33848, 31990, 10), value = 0, effect = CONST_ME_TELEPORT },
		{ pos = Position(33855, 31984, 11), teleport = Position(32621, 32906, 15), value = 0, effect = CONST_ME_TELEPORT },
		{ pos = Position(32616, 32917, 15), teleport = Position(33852, 31983, 11), value = 0, effect = CONST_ME_TELEPORT },
	},
}

local shipADangerousJourneyExit = MoveEvent()

function shipADangerousJourneyExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for _, data in ipairs(Podzilla.exitPositions) do
		if position == data.pos then
			player:teleportTo(data.teleport)
			player:removeIcon("podzilla-a-dangerous-journey")
			player:removeCondition(CONDITION_OUTFIT)
			player:setStorageValue(Podzilla.storage.Shortcut, 1)
			player:setStorageValue(Podzilla.storage.Questline, 3)
		end
	end

	return true
end

shipADangerousJourneyExit:type("stepin")

for _, data in ipairs(Podzilla.exitPositions) do
	shipADangerousJourneyExit:position(data.pos)
end
shipADangerousJourneyExit:register()

local teleports = MoveEvent()

function teleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for _, data in ipairs(Podzilla.teleports) do
		if position == data.pos then
			if player:getStorageValue(Podzilla.storage.Teleports) >= data.value then
				player:getPosition():sendMagicEffect(data.effect)
				player:teleportTo(data.teleport, true)
				player:getPosition():sendMagicEffect(data.effect)
			else
				player:teleportTo(fromPosition, true)
				player:getPosition():sendMagicEffect(data.effect)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this yet.")
			end
		end
	end

	return true
end

teleports:type("stepin")

for _, data in ipairs(Podzilla.teleports) do
	teleports:position(data.pos)
end
teleports:register()
