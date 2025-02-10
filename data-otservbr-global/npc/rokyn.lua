local internalNpcName = "Rokyn"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = 100
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 58,
	lookBody = 87,
	lookLegs = 57,
	lookFeet = 114,
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

-- ✅ **Bank Robbery Event Status Check for Ab'Dendriel**
local function isBankRobberyActiveInVenore()
    local data = KV.get("bankRobberyData")
    return data and data.active == 1 and data.completed == 0 and data.city == "Venore"
end

local function isBankRobberyCompletedInAbdendriel()
    local data = KV.get("bankRobberyData")
    return data and data.active == 1 and data.completed == 1 and data.city == "Venore"
end

-- ✅ **Checks if the player has a stolen bag of gold**
local function hasStolenGoldBag(creature)
    local player = Player(creature)
    return player:getItemCount(13429) > 0 -- Stolen gold bag item ID
end

-- ✅ **Modify NPC Voices Only If Ab'Dendriel Is Affected**
if isBankRobberyActiveInVenore() then
	table.insert(npcConfig.voices, { text = "Those lousy treehuggers! By Durin's beard!" })
end

-- ✅ **Greeting Callback with Dynamic Responses**
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = creature:getId()

	if isBankRobberyActiveInVenore() then
		if hasStolenGoldBag(player) then
			npcHandler:setMessage(MESSAGE_GREET, "Those Shadowthorn elves have - wait a minute. Is that the missing gold?")
		else
			npcHandler:setMessage(MESSAGE_GREET, {
			"Those Shadowthorn elves have gone too far this time! A whole crowd of them stormed the bank, and even though I fought them back the best I could, I was outnumbered by dozens. ...",
			"I fear the gold is gone, kid. The merchants here will help us pay the debts, but not before tomorrow. Unless someone finds and kills those elves I can't do anything for you.",
		})
		end
	elseif isBankRobberyCompletedInAbdendriel() then
		npcHandler:setMessage(MESSAGE_GREET, "Ha, those lousy elves got what they deserved. All the robbed money has been returned to the bank. What can I do for you?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?")
	end
	return true
end

-- ✅ **Handling Conversation & Reward Giving**
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Handling Player Saying "yes" when asked about stolen gold bag
	if message:lower() == "yes" and isBankRobberyActiveInVenore() then
		if not player:removeItem(13429, 1) then
			npcHandler:say("You have no stolen goods.", npc, creature)
			return true
		end

		-- ✅ **Reward Player & Update Event**
		npcHandler:say("Thank you! Maybe you humans aren't all too bad. Here's a little something for your effort. We can open the bank again!", npc, creature)
		player:addItem(3035, 10) -- Reward: 10x Platinum Coins
		player:addAchievement("Honest Finder")
		player:addAchievementProgress("Goldhunter", 5)
		KV.set("bankRobberyData", { active = 1, completed = 1, city = "Venore" }) -- Mark robbery as completed for Venore
		return true
	end

	-- Handling Player Saying "no"
	if message:lower() == "no" and isBankRobberyActiveInVenore() then
		npcHandler:say("Oh. Sorry then. We still can't open the bank.", npc, creature)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end

	-- ✅ **Normal bank operations (Only when robbery is NOT active in Ab'Dendriel)**
	if not isBankRobberyActiveInVenore() then
		npc:parseBank(message, npc, creature, npcHandler)
		npc:parseGuildBank(message, npc, creature, playerId, npcHandler)
		npc:parseBankMessages(message, npc, creature, npcHandler)
	end
	return true
end

-- ✅ **Setup NPC Handlers**
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- ✅ **Register the NPC Configuration**
npcType:register(npcConfig)
