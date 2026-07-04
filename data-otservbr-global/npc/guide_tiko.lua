local internalNpcName = "Guide Tiko"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 133,
	lookHead = 96,
	lookBody = 78,
	lookLegs = 101,
	lookFeet = 116,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "banker",
}
npcConfig.speechBubble = SPEECHBUBBLE_BANKER

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Free escort to the depot for newcomers!" },
	{ text = "Hello, is this your first visit to Port Hope? I can show you around a little." },
	{ text = "Talk to me if you need directions." },
	{ text = "Ask me if you want to know something about the world status!" },
	{ text = "Need some help finding your way through Port Hope? Let me assist you." },
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

local configMarks = {
	{ mark = "depot", position = Position(32631, 32742, 7), markId = MAPMARK_LOCK, description = "Depot" },
	{ mark = "temple", position = Position(32594, 32745, 7), markId = MAPMARK_TEMPLE, description = "Temple" },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if table.contains({ "map", "marks" }, message) then
		npcHandler:say("Would you like me to mark locations like - for example - the {depot}, {bank} and {shops} on your map?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Here you go.", npc, creature)
		local mark
		for i = 1, #configMarks do
			mark = configMarks[i]
			player:addMapMark(mark.position, mark.markId, mark.description)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) >= 1 then
		npcHandler:say("Well, nothing wrong about exploring the {town} on your own. Let me know if you need something!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif not MsgContains(message, "information") and not MsgContains(message, "map") and not MsgContains(message, "marks") then
		npcHandler:say("Well, you seem to know your way around. Take care!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({ "information" }, StdModule.say, { npcHandler = npcHandler, text = "Currently, I can tell you all about the {town}, its {temple}, the {bank}, {shops}, {spell trainers} and the {depot}, as well as about the {world status}." })
keywordHandler:addKeyword({ "temple" }, StdModule.say, { npcHandler = npcHandler, text = "The {temple} is in the north-eastern part of {town}, left of the {depot}. The priest there has a little alcohol problem, though. It's sad." })
keywordHandler:addKeyword({ "bank" }, StdModule.say, { npcHandler = npcHandler, text = "Our {bank} can be found one floor above the {depot}. Just talk to Ferks." })
keywordHandler:addKeyword({ "shops" }, StdModule.say, { npcHandler = npcHandler, text = "The {shops} here are very close to one another. I can mark them for you if you'd like." })
keywordHandler:addKeyword({ "spell trainers" }, StdModule.say, { npcHandler = npcHandler, text = "You can buy {spells} from {Uso} just under the {tavern}. It's located in the north-western part of {town}, leftmost of the {depot}." })
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
keywordHandler:addKeyword({ "weapons" }, StdModule.say, { npcHandler = npcHandler, text = "Brengus sells {weapons} and {armor} one floor above the {depot}. {Perod} sells {distance weapons} and {ammunition} one floor higher." })
keywordHandler:addKeyword({ "armor" }, StdModule.say, { npcHandler = npcHandler, text = "Brengus sells {weapons} and {armor} one floor above the {depot}." })
keywordHandler:addKeyword({ "tools" }, StdModule.say, { npcHandler = npcHandler, text = "General goods like {ropes} and {shovels} can be bought in {Perod}'s shop two floors over the {depot}." })
keywordHandler:addKeyword({ "gems" }, StdModule.say, { npcHandler = npcHandler, text = "You can buy {gems} from {Gail} one floor above the {depot}." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "{Magical equipment} like {runes} and {potions} can be bought at {Tandros}'s. His shop is two floors above the {depot}." })
keywordHandler:addKeyword({ "furniture" }, StdModule.say, { npcHandler = npcHandler, text = "You can buy {furniture} from {Zaidal}. His shop is two floors above the {depot}." })
keywordHandler:addKeyword({ "food" }, StdModule.say, { npcHandler = npcHandler, text = "Your best bet for {food} is {Clyde} in the {tavern}. It's located in the north-western part of {town}, leftmost of the {depot}." })
keywordHandler:addKeyword({ "harbour" }, StdModule.say, { npcHandler = npcHandler, text = "That's where we are standing right now. You can travel between the Tibian settlements using this ship if you have a premium account, that is." })
keywordHandler:addKeyword({ "post" }, StdModule.say, { npcHandler = npcHandler, text = "The {post office} is one floor above the {depot}. {Ray} is our {postman}." })
keywordHandler:addKeyword({ "blessings" }, StdModule.say, { npcHandler = npcHandler, text = "{Blessings} reduce the death penalty, meaning that if you should die, you will lose less {experience}, fewer {skill points} and fewer to no items, if you have all five {blessings}." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "It's " .. os.date("%I:%M %p") .. " right now. Any other information that you require?" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'll help you not to get lost in {Port Hope}. I can mark important locations on your map and give you some information about the {town} and the {world status}." })
keywordHandler:addKeyword({ "town" }, StdModule.say, { npcHandler = npcHandler, text = "The inhabitants of {Port Hope} are bravely facing the constant threat from the {jungle}. The {town} is built on pile dwellings and most {shops} are close to each other." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm {Tiko} and your guide today. Have a good day!" })

npcHandler:setMessage(MESSAGE_GREET, "Hello there, and welcome to {Port Hope}! Would you like some {information} and a {map guide}?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and enjoy your stay in Port Hope, |PLAYERNAME|")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
