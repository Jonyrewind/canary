local internalNpcName = "Para Norbet"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.speechBubble = 0

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 699,
	lookHead = 19,
	lookBody = 76,
	lookLegs = 77,
	lookFeet = 3,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false,
	pushable = false
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()
	local questline = player:getStorageValue(Storage.FeasterOfSouls.QuestLine)
	
	if questline <= 0 then
		npcHandler:setMessage(MESSAGE_GREET, 'Welcome adventurer! I\'m sensing some very unusual distortions in the fabric of reality recently. They are caused by an inactive portal right beside me. ... \z
		I found a way to activate it. Yet, to keep it open, I have to stay here, focusing on the {portal}. Thus I need you to\z
		go in there and uncover the true story behind those distortions. Can I count on you?')
		npcHandler:setTopic(playerId, 1)
		player:setStorageValue(questline, 0)
	elseif questline == 1 and player:getStorageValue(Storage.FeasterOfSouls.DeathKnell.Counter) < 3 and player:getStorageValue(Storage.FeasterOfSouls.DeathKnell.Potion) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, 'Fear not! Go ahead and {enter} the portal.')
		npcHandler:setTopic(playerId, 2)
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Leave me alone!')
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say("Thank you very much. In order to pass the invisible portal over there, you have to visit three places that are closely linked to death and {afterlife}. Sound this knell at each of the sites to infuse your aura with the ghostly energies there. ...\z
			The places you have to visit are: the cemetery east of Carlin, a sacrificial site beneath the Ghostlands and a skull-adorned altar underneath the Dark Cathedral. ...\z
			You also have to drink a special potion to pass the portal. Find {bone meal} and {grave flower extract} and mix them together to brew this potion. Once you drank the potion you will be able to pass the portal.")
			player:setStorageValue(questline, player:getStorageValue(questline) + 1)
			player:addItem(32582, 1)
			
		else
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "enter") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("In order to pass the invisible portal over there, you have to visit three places that are closely linked to death and {afterlife}. Sound this knell at each of the sites to infuse your aura with the ghostly energies there. ...\z
			The places you have to visit are: the cemetery east of Carlin, a sacrificial site beneath the Ghostlands and a skull-adorned altar underneath the Dark Cathedral. ...\z
			You also have to drink a special potion to pass the portal. Find {bone meal} and {grave flower extract} and mix them together to brew this potion. Once you drank the potion you will be able to pass the portal.")
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "afterlife") then
		npcHandler:say("It is the world of the dead. Many sages believe, that it is located below the world of the living. Yet some think, it lies within another dimension so that terms like above or beneath are inappropriate to describe it. ...\z
		There are some rumours that the descent to the Netherworld is difficult yet possible for those still living.", npc, creature)
	elseif MsgContains(message, "bone meal") then
		npcHandler:say("I guess, it should be made from a skull. Yes, grinding a skull into fine dust will do.", npc, creature)
	elseif MsgContains(message, "grave flower extract") then
		npcHandler:say("As the name implies, grave flowers grow on graves. Pick one and distil it to extract its essence.", npc, creature)
	elseif MsgContains(message, "portal") then
		npcHandler:say("It is right beside me. I have found it by using my magic devices.", npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, '')
npcHandler:setMessage(MESSAGE_FAREWELL, '')
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
