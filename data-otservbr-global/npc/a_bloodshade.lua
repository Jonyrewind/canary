local internalNpcName = "A Bloodshade"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1414,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
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

	npcHandler:setMessage(MESSAGE_GREET, "Mortal! If you are on a {quest} to serve the {blood god}, my master - be greeted!")
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local player, SacrificialPlate = Player(creature), Storage.Quest.U13_20.RottenBlood.Access.SacrificialPlate
	local player, Hunts = Player(creature), Storage.Quest.U13_20.RottenBlood.Access.Hunts

	if MsgContains(message, "quest") and npcHandler:getTopic(playerId) == 0 then
		if player:getStorageValue(SacrificialPlate) <= 0 then
			npcHandler:say({
				"To enter the realm of the sanguine master and destroy its spawn, a sufficient sacrifice is imperative. ...",
				"Find and slay the keeper of blooded tears and bring the nectar of his eyes before the blood god. Present your gift on the sacrificial altar. ...",
				"To enter the realm of the sanguine master and destroy its spawn, a sufficient sacrifice is imperative. ...",
				"After - and under no circumstances before - you have completed this procedure, you can enter the sacred fluid. You can, of course also take a slightly faster... \z
				{detour}.",
			}, npc, creature, 500)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(SacrificialPlate) == 1 and player:getStorageValue(Hunts) <= 0 then
			npcHandler:say({
				"First you must fight the two pairs of evil twins that lurk in the realm beyond here. ...",
				"Only when you are victorious over all four of them, your path to the source of vileness, the path to Bakragore will be opened. ...",
				"And even this victory will only be the beginning.",
			}, npc, creature, 500)
			player:setStorageValue(Hunts, 1)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say(" I can still sense the growing power within the putrid realms beyond. Go and end that threat once and for all.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "detour") and npcHandler:getTopic(playerId) == 0 then
		npcHandler:say({
			"Hm. I see. Well, I will be frank. Every blood sacrifice has its price. Blood money will please the blood god... just as well. ...",
			"The sum would be five million gold pieces and I... my master will be pleased. Are you prepared for a sacrifice such as this?",
		}, npc, creature, 500)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("You are willing to pay 5000000 gold pieces, then? There is no turning back after our... transaction is complete. Are you sure?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:removeMoney(5000000) then
				npcHandler:say("The bargain has been made, the business is done.", npc, creature)
				player:setStorageValue(SacrificialPlate, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You are not in the possession of this amount of gold. Do not take me or my master for a fool - begone!", npc, creature)
			end
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Waverer. Begone!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "blood god") then
		npcHandler:say({
			"The blood god's power has been corrupted and the spawn that festers in his former realms are a mockery of its grandeur. ...",
			"It has to be exterminated and the realm must be cleansed from the {festering} presence that came to dwell here!",
		}, npc, creature, 500)
	elseif MsgContains(message, "festering") then
		npcHandler:say({
			"After the fall of the blood {god} unclean things arose from his carcass. They festered on his remaining essence and devoured it. Claimed to be his descendants, claimed to carry his legacy. ...",
			"But to me it soon became obvious these abominable spawns were just parasites, maggots that desecrated the legacy of a true {god}. They have to be stopped once and for all. ...",
			"Their rampant growth and spread is an anathema to the {blood god}. They are not his descendants, they are just rot that feeds upon divine essence.",
		}, npc, creature, 500)
	elseif table.contains({ "essence", "demise" }, message) then
		npcHandler:say({
			"We all could constantly feel the presence of our {god} in our very own blood. Then, all of a sudden, his presence ceased to be, the connection was lost. ...",
			"For sure our lord has been slain by envious gods! But blood and slaughter are eternal. There is no end that can't be overcome by universal principle. He who has been slain will rise in slaughter once the time has come! ...",
			"However, first the cleansing of this place has to occur!",
		}, npc, creature, 500)
	elseif MsgContains(message, "twins") then
		npcHandler:say({
			"Two sets of {twins}. Two represent the rot that spreads, tarnishes and dissolves. ...",
			"The other pair represent the absence of light, the darkness that devours, the anti-light.",
		}, npc, creature, 500)
	elseif MsgContains(message, "bakragore") then
		npcHandler:say({
			"The {foul} thing must fall! Its presence and existence de-sanctifies the holy realm of blood. ...",
			"To be able to {challenge} that thing, however, you have to handle its spawn. Slay that brood and the way to Bakragore is wide open.",
		}, npc, creature, 500)
	elseif MsgContains(message, "challenge") then
		npcHandler:say({
			"You will have to defeat what calls itself Bakragore at least once to attack the core of its festering presence. You will be able to choose how much of the {foul} {taint} of Bakragore and its spawn you can endure. ...",
			"Yet the more {taint} you put onto you, the {harder} the battle will become, yet the rewards will be greater.",
		}, npc, creature, 500)
	elseif MsgContains(message, "foul") then
		npcHandler:say({
			"The scar and void, that the blood gods demise created, still radiated with its divine power. It became an entity of its own. ...",
			"A filthy thing of decay and rot. And it grew in power, unchecked. A malicious evil dwelt in its core, while it roamed the once holy grounds with all of its soiling presence. ...",
			"It shambled and devoured. Its sustenance were the worshippers of the {blood god}, dead or alive. None of them escaped the hunger. Eventually even the most mighty gave in. ...",
			"The most mighty of all were the dragons, magnificent species of their king. Dragons of might and the olden days. Not the pathetic shadows you know in these days. ...",
			"The thing .. infected them, overtook them, made them his and made them him. ...",
			"At some point, out of a conscious thought or raw instinct, perhaps even a physical necessity the thing gave birth to two sets of {twins}. ...",
			"Not in any physical sense though. It split aspects of his own, that had befallen some dragons and made them entities of their own. ...",
			"Thus, the {twins} of rot and the {twins} of 'the light that is not' came to be.",
		}, npc, creature, 500)
	elseif MsgContains(message, "taint") then
		npcHandler:say({
			"Though what is left of the powers, granted to me by my god and my extensive knowledge of his essence, I'm able to assist you in {managing} the {taint} that you obtained and you bear. ...",
			"Mind you, however, I can only remove the burden that you are bearing. Once done you will have to acquire the taints anew.",
		}, npc, creature, 500)
	elseif MsgContains(message, "cost") then
		npcHandler:say({
			"There are hindrances and weaknesses that come with the {taint}. ...",
			"You will experience that things won't get as easy as they used to be. Only as long as you are in the contaminated areas, but still.",
		}, npc, creature, 500)
	elseif MsgContains(message, "god") then
		npcHandler:say({
			"You are not worthy to learn of the blood gods teaching, neither to receive his {blessings}.",
		}, npc, creature, 500)
	end
	return true
end

keywordHandler:addKeyword({ "name" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I was once the greatest priest and prophet of the one true good of blood. I lead his followers through the dawn of our cult until the demise of our god.",
})
keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The quest, that requires my continued existence in this plane, is to eradicate the {festering} wound that defiles this place.",
})
keywordHandler:addKeyword({ "blessings" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Your body and your mind are not prepared to receive the {blessings} of the {blood god}.",
})
keywordHandler:addKeyword({ "managing" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "You are not tainted, mortal.",
})
keywordHandler:addKeyword({ "harder" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can help you with the {taint} that you wield. You just have to ask.",
})
keywordHandler:addKeyword({ "beginning" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "After your first victory, the healing of the place might slowly begin. Yet the wound that is Bakragore will still fester. More victories can weaken the festering even more, yet not without {sacrifice}.",
})
keywordHandler:addKeyword({ "sacrifice" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "You will acquire a {taint}, a certain corruption, a touch of {decay} when you kill the festering spawn and Bakragore, its source.",
})
keywordHandler:addKeyword({ "decay" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The {taint} of {decay} will wither and devour any lesser being. But you .. you might {prevail}.",
})
keywordHandler:addKeyword({ "prevail" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "You can't escape the {taint} entirely. Yet you can endure it - at a {cost}.",
})

npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
