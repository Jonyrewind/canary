local internalNpcName = "Torkada"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1243,
	lookHead = 59,
	lookBody = 77,
	lookLegs = 88,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "This is most peculiar." },
	{ text = "My superiors must learn about this." },
	{ text = "These are dark times." },
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
	local playerId = creature:getId()
	local player = Player(creature)

	npcHandler:setMessage(MESSAGE_GREET, "Greetings! This isn't the {time} to chitchat though.")
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	local player, storage = Player(creature), Storage.Quest.U13_20.RottenBlood.Access.Door
	if MsgContains(message, "mission") and npcHandler:getTopic(playerId) == 0 then
		if player:getStorageValue(storage) <= 0 then
			npcHandler:say("Are you willing, to bring the fury of the inquisition to that foul place and eradicate all evil you find? Speak, {yes} or {no}?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("Suspicious, but that's your decision of course.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"So hereby receive the blessings of the gods, provided by me as the voice of the inquisition! ...",
				"Go now and search the ancient temple in the north-west part of the drefian ruins. Slay the evil that lurks there and cleanse the foul place from its taint!",
			}, npc, creature, 500)
			player:setStorageValue(storage, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Suspicious, but that's your decision of course.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "expedition") then
		npcHandler:say({
			"Some nosy adventurers dug up more than they could chew, while exploring the drefian ruins. They discovered the entrance of some sort of temple of evil. ...",
			"Now, places of evil is what this whole wretched place of {Drefia} consists of, yet this temple was foul, even for drefian standards. The adventurers returned .. twisted and tainted. ...",
			"We couldn't save them but had to .. cleanse them in a permanent way. However by studying them we could create appropriate wards that should keep the corruption of the temple at bay .. for a time at least.",
		}, npc, creature, 500)
	elseif MsgContains(message, "heresy") then
		npcHandler:say({
			"You shouldn't concern yourself with such topics. Their filth might stick and taint. ...",
			"Live a pious life and heed the teachings of the {gods} of good! Stay away from heretics and report them to the {inquisition}. We will handle them one by one and cleanse the world of their rot!",
		}, npc, creature, 500)
	elseif MsgContains(message, "job") then
		npcHandler:say({
			"For long years I served the {inquisition} as high judge and advisor. I compiled books about the sacred laws and rooting out of heretics. ...",
			"But our ranks are stretched thin in these times and I took it upon me to return to rather mundane field duties like this. ...\z
	It might not be the most glorious task at hand but it has to be done and I'm up to it.",
		}, npc, creature, 500)
	end
	return true
end

keywordHandler:addKeyword({ "time" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "This {expedition} is here on an important {mission} for the {inquisition}.",
})
keywordHandler:addKeyword({ "inquisition" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Most operations of the {inquisition} are classified information. But rest assured we are busy in all parts of the world. And we have to as these are dire times and {heresy} is on the rise!",
})
keywordHandler:addKeyword({ "drefia", "Drefia" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "A vile place indeed. Yet it serves us as a constant reminder where demon worship and depravity will ultimately lead to.",
})
keywordHandler:addKeyword({ "gods" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "For sure you already know about the good gods. I am not a preacher but a man of action!",
})

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
