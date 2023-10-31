local internalNpcName = "Rokyn"
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

if getGlobalStorage(storage.Town) == 4 then
	table.insert(npcConfig.voices, { text = "Those lousy treehuggers! By Durin's beard!" })
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
	local player = Player(creature)
	local playerId = player:getId()

	if getGlobalStorage(storage.Town) == 4 then
		if player:getItemCount(13429) > 0 then
			npcHandler:setMessage(MESSAGE_GREET, "Those Shadowthorn elves have - wait a minute. Is that the missing gold?")
		else
			npcHandler:setMessage(MESSAGE_GREET, "Those Shadowthorn elves have gone too far this time! A whole crowd of them stormed the bank, and even though I fought them back the best I could, I was outnumbered by dozens. ...")
		end
	elseif getGlobalStorage(storage.Activated) > 0 and getGlobalStorage(storage.Returnedgoods) >= 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Ha, those lousy elves got what they deserved. All the robbed money has been returned to the bank. What can I do for you?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?")
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

		npcHandler:say("Thank you! Maybe you humans aren't all too bad. Here's a little something for your effort. We can open the bank again!", npc, creature)
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

	if getGlobalStorage(storage.Town) ~= 4 then
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
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
-- npcType registering the npcConfig table
npcType:register(npcConfig)