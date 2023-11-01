local internalNpcName = "Yawno"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookTypeEx = 4240,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "One of them... I just saw... *yawn* one of them..." },
	{ text = "Mmhnmnmnmmmh... no, nooo...! Lemme sleep... I don't wanna go to school..." },
	{ text = "The secrets... too many... sleep..." },
	{ text = "It... *yawn* will show up... sooner or later... *yaaawn*" },
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	local storage = getGlobalStorage(GlobalStorage.TwistedWatersWorldChange.Status)
	if MsgContains(message, "fish") or MsgContains(message, "fishing") then
		if storage == 0 then
			npcHandler:say({
				"Well, just between the two of us - the {lake} is still crystal clear right now. Ya know, it's TOO CLEAN. That ain't attract no shimmer {swimmer}, it doesn't. ...",
				"The {lake} needs to be dirtier, filthier, murkier yupp. An' I bet ya don't know the secret, eh? How to get it real dirty? {Corpses}. Loads of {corpses}. Piles of 'em. Throw 'em into the water, eh. You'll see.",
			}, npc, creature, 500)
			npcHandler:setTopic(playerId, 0)
		elseif storage == 1 then
			npcHandler:say({
				"Hmmmgh.... fhsh... what? WHAT? It becomes dirty! All will be dirty! Yes! That's enough! That... that surely... *yawn*... surely will attract the shimmer {swimmer}... but... I need to rest... at first. To be ready... when ...",
				"...oh but be careful!",
			}, npc, creature, 500)
			npcHandler:setTopic(playerId, 0)
		elseif storage == 2 then
			npcHandler:say({
				"Hmmnfgfhsh... eh - WHAT!! FISH? Where!! Did ya see it? Did ya see a shimmer {swimmer}? This lake ya know, is the one an' only place in the whole world of Tibia where ya can find one!",
			}, npc, creature, 500)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "swimmer") or MsgContains(message, "shimmer swimmer") then
		npcHandler:say({
			"It is the rarest of all fish! Hard to come by but worth every second... *yawn*... of time, ya invest. You only get a chance to catch him in extremely dirty water. ...",
			"And Lake {Equivocolao} is really the only place where it can be found. I am sure my old buddy Pemaret in Cormaya knows a thing or two about that bugger, too.",
		}, npc, creature, 500)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "equivocolao") or MsgContains(message, "lake") then
		npcHandler:say({
			"This {lake} is the only place shimmer {swimmers} can be caught. However, if the {lake} is too clean, they will not settle. My guess... *yawn* is that this {lake} has underground connections to... to... caves... *yawn*...",
		}, npc, creature, 500)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "news") then
		if storage == 2 then
			npcHandler:say({
				"Finally, now some shimmer swimmers should arrive... *yawn* as soon as I have taken my nap... I will... start... to...",
			}, npc, creature, 500)
			npcHandler:setTopic(playerId, 0)
		elseif storage == 0 then
			npcHandler:say({
				"A... aaah... *yawn* maybe a shimmer {swimmer} will... appear... if... enough... *yawn*",
			}, npc, creature, 500)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "corpses") and storage == 0 then
		npcHandler:say({
			"Throwing corpses into the water is the fastest way to make it dirty and murky - just perfect to attract shimmer {swimmers}. It doesn't even matter what kind of corpse, heh.",
		}, npc, creature, 500)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "job") then
		npcHandler:say({
			"...hmf ...",
			"Hm - what? What? Did I... *yawn* well, what was ya question? Ah job, yes. ...",
			"Well... I'm a fisherman. Obviously. Can't ya see? I'm fishin' 'ere! Oh and now please be quiet, quiet *whisper* really quiet... ...",
			"...and maybe MOVE AWAY A LITTLE! THANKS. Ya're SCARING AWAY the... the... fish. *yawn* hmmnmnf...",
		}, npc, creature, 500)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "name") then
		npcHandler:say({
			"The name's Yawno, providing the finest... fish in the whole... world... *yawn* of Tibia.",
		}, npc, creature, 500)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Mmhmn... eh? Ahm, so what is it... *yawn* Ya here for the {fish}, too? Or are you just here for some... *yawn* {news}?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yeah, yeah... bye, erm... *yawn*")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, yeah... bye, erm... *yawn*")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
