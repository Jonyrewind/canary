local createMonster = TalkAction("/m")

function createMonster.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	-- Usage: "/m monstername, fiendish" for create a fiendish monster (/m rat, fiendish)
	-- Usage: "/m monstername, [1-5]" for create a influenced monster with specific level (/m rat, 2)
	if param == "" then
		player:sendCancelMessage("/m monstername, [1-5] for influenced or fiendish or c,[number]")
		logger.error("[createMonster.onSay] - Monster name param not found.")
		return true
	end

	local split = param:split(",")
	local monsterName = split[1]
	local count = split[3]
	local monsterForge = nil
	if split[2] then
		split[2] = split[2]:gsub("^%s*(.-)$", "%1") --Trim left
		monsterForge = split[2]
	end
	if type(monsterForge) == "string" and monsterForge == "c" then
		count = math.abs(tonumber(count) or 1)
		local playerPos = player:getPosition()
		for i = 1, count do
			if not Game.createMonster(monsterName, playerPos, true) then
				player:sendCancelMessage(i == 1 and ("There is not enough room.") or string.format("Could not spawn %u monsters.", count-i+1))
				playerPos:sendMagicEffect(CONST_ME_POFF)
				break
			end
		end
		return true
	end
	-- Check dust level
	local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(monsterForge, player)

	local position = player:getPosition()
	local monster = Game.createMonster(monsterName, position)
	if monster then
		if not monster:isForgeable() then
			player:sendCancelMessage("Only allowed monsters can be fiendish or influenced.")
			return true
		end
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)

		local monsterType = monster:getType()
		if canSetFiendish then
			SetFiendish(monsterType, position, player, monster)
		end
		if canSetInfluenced then
			SetInfluenced(monsterType, monster, player, influencedLevel)
		end
	else
		player:sendCancelMessage("There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

createMonster:separator(" ")
createMonster:groupType("god")
createMonster:register()
