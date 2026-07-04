local internalNpcName = "Guide Meruka"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1199,
	lookHead = 95,
	lookBody = 10,
	lookLegs = 74,
	lookFeet = 3,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

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

	if table.contains({ "map", "marks" }, message) then
		npcHandler:say("Would you like me to mark locations like - for example - the depot, bank and shops on your map?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Here you go.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) >= 1 then
		npcHandler:say("Well, nothing wrong about exploring the town on your own. Let me know if you need something!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({ "information" }, StdModule.say, { npcHandler = npcHandler, text = "Currently, I can tell you all about the {town}, its {temples}, the {bank}, {shops} and the {depot}, as well as about the {world status}." })
keywordHandler:addKeyword({ "temple" }, StdModule.say, { npcHandler = npcHandler, text = "The {temple} is in the north-east of the {city}. Just keep going past the {market place}." })
keywordHandler:addKeyword({ "bank" }, StdModule.say, { npcHandler = npcHandler, text = "The local {bank} clerk is called {Atur}. You can find him just behind the {southern gate}." })
keywordHandler:addKeyword({ "shops" }, StdModule.say, { npcHandler = npcHandler, text = "You can buy {distance weapons}, {gems}, {magical equipment} and {food} here." })
keywordHandler:addKeyword({ "depot" }, StdModule.say, { npcHandler = npcHandler, text = "The {depot} is a place where you can safely store your belongings. You are also protected against attacks there. I escort newcomers there." })

local function getTwistedWatersStatusText()
	if TwistedWatersState.isDirty() then
		local fishCount = TwistedWatersState.KV:get("fishcount") or 0
		if fishCount > 1000 then
			return "The {great lake} near {Port Hope} is {dirty}. No shimmer swimmers have been seen under the surface for quite some time now."
		end

		return "The {great lake} near {Port Hope} is {dirty}. Shimmer swimmers can be seen under the surface."
	elseif TwistedWatersState.isPendingDirty() then
		return "Corpses are piling up in the {great lake} near {Port Hope} and the water is about to become {dirty}."
	end

	return "The {great lake} near {Port Hope} is {clean}."
end

keywordHandler:addKeyword({ "world status" }, StdModule.say, { npcHandler = npcHandler, text = "If you'd like to know the status of this {world} just say the {keyword} for a {world change}." })
keywordHandler:addKeyword({ "keyword" }, StdModule.say, { npcHandler = npcHandler, text = "Valid {keywords} are: {Horestis}, {Mage Tower}, {Master's Voice}, {Swamp Fever}, {Thornfire}, {Twisted Waters}, {Awash}, {Steamship}, {Horses}, {Overhunting}, {Demon War}, {Sea Serpent}, {Deepling} or {Hive}." })
keywordHandler:addKeyword({ "change" }, StdModule.say, { npcHandler = npcHandler, text = "Valid {keywords} are: {Horestis}, {Mage Tower}, {Master's Voice}, {Swamp Fever}, {Thornfire}, {Twisted Waters}, {Awash}, {Steamship}, {Horses}, {Overhunting}, {Demon War}, {Sea Serpent}, {Deepling} or {Hive}." })
keywordHandler:addKeyword({ "twisted waters" }, StdModule.say, { npcHandler = npcHandler, text = getTwistedWatersStatusText() })
keywordHandler:addKeyword({ "town" }, StdModule.say, { npcHandler = npcHandler, text = "The city {Issavi} with its {shops} and magnificent buildings is built between two branches of the river {Nykri}. Remarkable buildings are the {palace}, the {temples}, the {Hanging Gardens} and the {great southern gate}. We also have a {theatre}." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm {Meruka}. Pleased to meet you." })

npcHandler:setMessage(MESSAGE_GREET, "Bastesh's blessings, |PLAYERNAME| and welcome to {Issavi}! Would you like some {information} and a {map} guide?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and enjoy your stay in {Issavi}, |PLAYERNAME|")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
