local internalNpcName = "Eva"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = 100
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 96,
	lookBody = 98,
	lookLegs = 95,
	lookFeet = 0,
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

-- ✅ Check if Carlin is affected by the robbery
local function isBankRobberyActiveInCarlin()
    local data = KV.get("bankRobberyData")
    return data and data.active == 1 and data.completed == 0 and data.city == "Carlin"
end

local function isBankRobberyCompletedInCarlin()
    local data = KV.get("bankRobberyData")
    return data and data.active == 1 and data.completed == 1 and data.city == "Carlin"
end

-- ✅ Checks if the player has a stolen bag of gold
local function hasStolenGoldBag(player)
    return player:getItemCount(13429) > 0 -- Correct stolen bag ID
end

-- ✅ Modify NPC Voices If Carlin is Affected
if isBankRobberyActiveInCarlin() then
	table.insert(npcConfig.voices, { text = "HELP! HELP! We've been robbed!!" })
end

-- ✅ Custom Greeting Behavior
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = creature:getId()

	if isBankRobberyActiveInCarlin() then
		if hasStolenGoldBag(player) then
			npcHandler:setMessage(MESSAGE_GREET, "*Sob*... *sniff*... Ohhhh!! All that shiny glittering gold! Have you caught the bank robbers?")
		else
			npcHandler:setMessage(MESSAGE_GREET, {
			"*Sob*... I'm still in shock. A man just came up to the counter and he... he... forced me to fork over all of the gold. I'm really sorry, but I can't serve you right now. ...",
			"The queen has been informed, but it won't be until tomorrow that she will compensate the losses. Maybe you can help find the robber? He ran off into the direction of the ghostlands.",
		})
		end
	elseif isBankRobberyCompletedInCarlin() then
		npcHandler:setMessage(MESSAGE_GREET, "I can't believe it - the bank robber has actually been caught and the gold been returned. I'm so relieved. How may I serve you?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?")
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
	if message:lower() == "yes" and isBankRobberyActiveInCarlin() then
		if not player:removeItem(13429, 1) then
			npcHandler:say("You have no stolen goods.", npc, creature)
			return true
		end

		-- Reward & Reset Event
		npcHandler:say("Thank you so much! I feel much safer now knowing those robbers have been caught. Here's a little something for your effort. We can open the {bank} again!", npc, creature)
		player:addItem(3035, 10) -- Reward: 10x Platinum Coins
		player:addAchievement("Honest Finder")
		player:addAchievementProgress("Goldhunter", 5)
		KV.set("bankRobberyData", { active = 1, completed = 1, city = "Carlin" }) -- Mark robbery as completed for Carlin
		return true
	end

	-- Handling Player Saying "no"
	if message:lower() == "no" and isBankRobberyActiveInCarlin() then
		npcHandler:say("Oh. Sorry then. We still can't open the bank.", npc, creature)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end

	-- Normal bank operations (Only when robbery is NOT active in Carlin)
	if not isBankRobberyActiveInCarlin() then
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
