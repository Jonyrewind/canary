local internalNpcName = "Suzy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = "a banker"
npcConfig.health = 100
npcConfig.maxHealth = 100
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 78,
	lookBody = 10,
	lookLegs = 115,
	lookFeet = 95,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Don't forget to deposit your money here in the Global Bank before you head out for adventure.", yell = false },
}

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

-- ✅ Bank Robbery Event Status using KV (Specific to Thais)
local function isBankRobberyActiveInThais()
	local data = KV.get("bankRobberyData")
	return data and data.active == 1 and data.completed == 0 and data.city == "Thais"
end

local function isBankRobberyCompletedInThais()
	local data = KV.get("bankRobberyData")
	return data and data.active == 1 and data.completed == 1 and data.city == "Thais"
end

-- ✅ Checks if the player has a stolen bag of gold
local function hasStolenGoldBag(player)
	return player:getItemCount(13429) > 0 -- Correct stolen bag ID
end

-- ✅ Modify NPC Voices Only If Thais Is Affected
if isBankRobberyActiveInThais() then
	table.insert(npcConfig.voices, { text = "Those filthy bank robbers!" })
end

-- ✅ Custom Player Greeting Based on Event Status
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if isBankRobberyActiveInAbdendriel() then
		if hasStolenGoldBag(player) then
			npcHandler:setMessage(MESSAGE_GREET, "I'm sorry, but we have been robb- hey, what's that bag? Have you hunted down the bank robbers?")
		else
			npcHandler:setMessage(MESSAGE_GREET, "HELP! We have been robbed! I can't give you any gold until the robber has been brought to justice or we have received a compensation from the king. I think the robbers ran towards the Ancient Temple.")
		end
	elseif isBankRobberyCompletedInAbdendriel() then
		npcHandler:setMessage(MESSAGE_GREET, "The filthy bank robber has been brought to justice and almost all gold has been returned. We are back in business!")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?", player)
	end
	return true
end

-- ✅ Handling Conversation & Rewards
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Handling Player Saying "yes" when asked about stolen gold bag
	if message:lower() == "yes" and npcHandler.topic[playerId] == 1 then
		if not player:removeItem(13429, 1) then
			npcHandler:say("You have no stolen goods.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		-- Reward & Reset Event
		npcHandler:say("Hey, awesome. Good job. Here's some platinum coins for all your work. Thanks to you we can open the bank again.", npc, creature)
		player:addItem(3035, 10) -- Reward: 10x Platinum Coins
		player:addAchievement("Honest Finder")
		player:addAchievementProgress("Goldhunter", 5)
		KV.set("bankRobberyData", { active = 1, completed = 1, city = "Thais" }) -- Mark robbery as completed for Thais
		npcHandler:setTopic(playerId, 0)
		return true
	end

	-- Handling Player Saying "no"
	if message:lower() == "no" and npcHandler.topic[playerId] == 1 then
		npcHandler:say("Oh. Sorry then. We still can't open the bank.", npc, creature)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end

	-- Normal bank operations (Only when robbery is NOT active in Thais)
	if not isBankRobberyActiveInThais() then
		npc:parseBank(message, npc, creature, npcHandler)
		npc:parseGuildBank(message, npc, creature, playerId, npcHandler)
		npc:parseBankMessages(message, npc, creature, npcHandler)
	end
	return true
end

-- ✅ Setup NPC Handlers
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- ✅ Register the NPC Configuration
npcType:register(npcConfig)
