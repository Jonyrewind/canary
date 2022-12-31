local internalNpcName = "..."
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = ""
npcConfig.description = "a mountain"
npcConfig.speechBubble = 0

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookTypeEx = 168
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
--[[Game.getStorageValue(GlobalStorage.FerumbrasAscendant.DesperateSoul) >= 1 and]]-- 
	if player:getStorageValue(Storage.FerumbrasAscension.TarbazNotes) >= 2 then
		npcHandler:setMessage(MESSAGE_GREET, 'H.... hello. Please don\'t hurt me! Leave me alone! You can\'t help me anyway!')
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

	if MsgContains(message, "mission") then
		npcHandler:say("My name! My name! I will never find my way back now that I lost it! ... \z
						I have nothing to give you but the key to the heart of despair! But please, please help me find my name!", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "tevon") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("That's it! Thats my name! Uh, I am so glad you have found it! Now there is hope for me. Ah yes, your reward, er... \z
						Well, the door to the heart of despair is open to you, you may go there - if you should wish anything as foolish as that. ...\z
						If anyone should ask you by what right you're here, just say 'Pass A38'. They're a sticker for protocal, it's horrible. ...\z
						Er. Well. Anyway, no sense in staying here. Goodbye!", npc, creature)
		player:setStorageValue(Storage.FerumbrasAscension.TarbazDoor, 1)
		npcHandler:setTopic(playerId, 0)
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
