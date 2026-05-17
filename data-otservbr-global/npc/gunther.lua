local internalNpcName = "Gunther"

local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 3

npcConfig.outfit = {
	lookType = 128,
	lookHead = 39,
	lookBody = 79,
	lookLegs = 66,
	lookFeet = 68,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Oh my!" },
	{ text = "They have to believe me!" },
	{ text = "What a mess." },
}

-- Create keywordHandler and npcHandler
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- npc event hooks
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

npcType.onCloseChannel = function(npc, player)
	npcHandler:onCloseChannel(npc, player)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	local Podzilla = Storage.Quest.U13_40.Podzilla

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "adventurer") then
		npcHandler:say("I hoped to meet an adventurer such as you! No one is listening to me, they claim I am {mad}, but I am not!", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "mad") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Yes, YES! I've {seen} IT!", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "seen") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("It was a plant! On open seas!!! I swear! And it was {humongous}!", npc, creature)
		npcHandler:setTopic(playerId, 3)
	elseif MsgContains(message, "humongous") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say("It was as big as a castle! And that was only the part I could see over water! And it {moved}!!!", npc, creature)
		npcHandler:setTopic(playerId, 4)
	elseif MsgContains(message, "moved") and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say("Yes it was slowly but steadily heading straight for the {mainland}.", npc, creature)
		npcHandler:setTopic(playerId, 5)
	elseif MsgContains(message, "mainland") and npcHandler:getTopic(playerId) == 5 then
		npcHandler:say("I can't tell where or when it arrives at the shores. But somewhere at some point it will! And it will be a {disaster}!", npc, creature)
		npcHandler:setTopic(playerId, 6)
	elseif MsgContains(message, "disaster") and npcHandler:getTopic(playerId) == 6 then
		npcHandler:say("Can you imagine the damage a gigantic walking plant will cause? It will raze cities, stomp out armies! It has to be {stopped}!", npc, creature)
		npcHandler:setTopic(playerId, 7)
	elseif MsgContains(message, "stopped") and npcHandler:getTopic(playerId) == 7 then
		npcHandler:say({
			"I called in a few favours from the adventurer's guild and the explorer society to fund an expedition to seek out that monster. ...",
			"All I need now is some brave {souls} to man the ships and destroy that monster!",
		}, npc, creature)
		npcHandler:setTopic(playerId, 8)
	elseif MsgContains(message, "souls") then
		if player:getStorageValue(Podzilla.TheRiseofPodzilla.Gunther) >= 1 then
			npcHandler:say({ "I am so glad, you are taking care of this problem." }, npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say({ "Say, will you be one of the heroes to save the day? {yes} or {no}?" }, npc, creature)
			npcHandler:setTopic(playerId, 9)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 9 then
		player:setStorageValue(Podzilla.TheRiseofPodzilla.Gunther, 1)
		player:setStorageValue(Podzilla.TheRiseofPodzilla.Questline, 1)
		player:setStorageValue(Podzilla.Questline, 1)
		npcHandler:say({ "I knew you had it in you! Please hurry, talk to the captain and tell him Gunther sent you!" }, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 9 then
		npcHandler:say({ "I understand. But if that walking plant reaches the mainland... you may yet regret staying behind." }, npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({ "name" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My name is Gunther Holz.",
})

keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I am an overseas-trader by trade.",
})

keywordHandler:addKeyword({ "time" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Our time might be running out!",
})

npcHandler:setMessage(MESSAGE_GREET, "Greetings {adventurer}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, friend!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care, friend!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
