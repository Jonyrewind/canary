local internalNpcName = "Alternative Rock"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 13414,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Heeey there." },
	{ text = "Wanna talk?" },
	{ text = "How are you?" },
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, "help") then
		if getPlayerStorageValue(creature, Storage.Navigator) < 1 then
			npcHandler:say("Yeah yeah, you can help me actually. You know, I feel some bad vibes coming out of the earth, recently. I think there's something wrong with the creatures of the deep. Care to join me?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Great, great. There is something going on, you know? I can feel it in my bones. There really are some bad spirits down there. ...",
				"See, a long time ago I acquired these nets. They are called soul nets. Do you know what they can do? Neither do I. ...",
				"What I know is they vibrate when evil is near. Yeah, vibration man. ...",
				"They also let evil glow in a deep red. Glowing red stuff. So next time you go down there, just take one with you and when you find evil spirits - catch them with the net. ...",
				"They will vanish in an instant. But - you will have to take care that all bad spirits in the near vicinity vanish almost instantaneously or they will regenerate. ...",
				"So you might need some help down there, my friend. Ready to do this?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.Quest.U9_4.LiquidBlack.SoulNet) > os.time() then
				npcHandler:say({ "Give me more time!", }, npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say({
					"Good, I hope this will help you keeping the spirits away.",	
				}, npc, creature)
				player:addItem(14020, 1)
				player:setStorageValue(Storage.Quest.U9_4.LiquidBlack.SoulNet, os.time() + 12 * 60 * 60)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET,"Hello there! Are you really here to {help} us, friend? Need the latest news on what's going on on this island?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
