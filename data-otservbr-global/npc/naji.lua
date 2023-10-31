local internalNpcName = "Naji"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}
local storage = GlobalStorage.BankRobberyMiniWorldChange

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 57,
	lookBody = 113,
	lookLegs = 95,
	lookFeet = 113,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "It's a wise idea to store your money in your bank account.", yell = false },
}

if getGlobalStorageValue(storage.Town) == 3 then
	table.insert(npcConfig.voices, { text = "Those filthy bank robbers!" })
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	local player = Player(creature)

	if getGlobalStorage(storage.Town) == 3 then
		if player:getItemCount(13429) > 0 then
			npcHandler:setMessage(MESSAGE_GREET, "I'm sorry, but we have been robb- hey, what's that bag? Have you hunted down the bank robbers?")
		else
			npcHandler:setMessage(MESSAGE_GREET, "HELP! We have been robbed! I can't give you any gold until the robber has been brought to justice or we have received a compensation from the king. I think the robbers ran towards the Ancient Temple.")
		end
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Tibian bank, |PLAYERNAME| What can I do for you?")
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "yes") then
		if not player:removeItem(13429, 1) then
			npcHandler:say("You have no stolen goods.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		npcHandler:say("Hey, awesome. Good job. Here's some gold for all your work. Thanks to you we can open the bank again.", npc, creature)
		setGlobalStorage(storage.Town, 0)
		setGlobalStorage(storage.Returnedgoods, 1)
		player:addAchievement("Honest Finder")
		player:addAchievementProgress("Goldhunter", 5)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") then
		npcHandler:say("Oh. Sorry then. We still can't open the bank.", npc, creature)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end

	if getGlobalStorage(storage.Town) ~= 3 then
		-- Parse bank
		npc:parseBank(message, npc, creature, npcHandler)
		-- Parse guild bank
		npc:parseGuildBank(message, npc, creature, playerId, npcHandler)
		-- Normal messages
		npc:parseBankMessages(message, npc, creature, npcHandler)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
