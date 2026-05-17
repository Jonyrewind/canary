local Podzilla = {
	storage = Storage.Quest.U13_40.Podzilla.TheRiseofPodzilla,
	leverPos = Position(33860, 32012, 5),
	lookType = { 1693, 1698 },
	playerPositions = {
		{ pos = Position(33861, 32012, 5), teleport = Position(33873, 31999, 4), effect = CONST_ME_BIGCLOUDS },
		{ pos = Position(33862, 32012, 5), teleport = Position(33873, 31999, 4), effect = CONST_ME_BIGCLOUDS },
		{ pos = Position(33863, 32012, 5), teleport = Position(33873, 31999, 4), effect = CONST_ME_BIGCLOUDS },
		{ pos = Position(33864, 32012, 5), teleport = Position(33873, 31999, 4), effect = CONST_ME_BIGCLOUDS },
		{ pos = Position(33865, 32012, 5), teleport = Position(33873, 31999, 4), effect = CONST_ME_BIGCLOUDS },
	},
}

local shipADangerousJourney = Action()

function shipADangerousJourney.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cooldown = Podzilla.storage
	local firstSlot = Podzilla.playerPositions[1]
	local now = os.time()

	local teleportSeconds = 10 * 60

	-- Only the player standing on the first tile can pull the lever.
	local playerPos = player:getPosition()
	if playerPos ~= firstSlot.pos then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only the first crew member can pull the lever.")
		return false
	end

	-- Teleport everyone standing on the configured tiles, and lock them for 10 minutes.
	for _, slot in ipairs(Podzilla.playerPositions) do
		local spectators = Game.getSpectators(slot.pos, false, true, 0, 0, 0, 0)
		for _, spectator in ipairs(spectators) do
			if spectator and spectator:isPlayer() then
				if spectator:getStorageValue(cooldown.NextTry) > now then
					spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone in the crew isn't ready yet.")
				else
					spectator:setStorageValue(cooldown.NextTry, now + teleportSeconds)
					spectator:teleportTo(slot.teleport, true)

					local lookType = math.random(Podzilla.lookType[1], Podzilla.lookType[2])
					spectator:removeCondition(CONDITION_OUTFIT)
					local conditionOutfit = Condition(CONDITION_OUTFIT)
					conditionOutfit:setOutfit({ lookType = lookType })
					conditionOutfit:setTicks(-1)
					spectator:addCondition(conditionOutfit)
					spectator:setIcon("podzilla-a-dangerous-journey", CreatureIconCategory_Quests, CreatureIconQuests_GreenShield, 100)

					spectator:say("You have boarded your ships. The sea is getting restless, watch out!", TALKTYPE_MONSTER_SAY)
					spectator:getPosition():sendMagicEffect(slot.effect)
					spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "What's that huge shadow in the distance, an island?")
				end
			end
		end
	end
	return true
end

shipADangerousJourney:position(Podzilla.leverPos)
shipADangerousJourney:register()

local demoRoot = Action()

function demoRoot.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local drunk = Condition(CONDITION_DRUNK)
	drunk:setParameter(CONDITION_PARAM_TICKS, 60000)
	player:addCondition(drunk)
	player:removeItem(48510, 1)
	player:say("ngh...!", TALKTYPE_MONSTER_SAY)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel countless tiny roots burrowing into your brain!")
	player:setStorageValue(Podzilla.storage.Rooteaten, 1)
	player:setStorageValue(Podzilla.storage.Teleports, 2)
	player:setStorageValue(Podzilla.storage.Questline, 4)
	return true
end

demoRoot:id(48510)
demoRoot:register()

local globeTP = Action()

function globeTP.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local POS_A = Position(33848, 31993, 10)
	local POS_B = Position(33848, 31995, 10)

	if not player:isPlayer() then
		return false
	end

	local currentY = player:getPosition().y

	if currentY == POS_B.y then
		player:teleportTo(POS_A)
	else
		player:teleportTo(POS_B)
	end
	return true
end

globeTP:position(Position(33848, 31994, 10))
globeTP:register()
