local internalNpcName = "Lorek"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 19,
	lookBody = 10,
	lookLegs = 38,
	lookFeet = 95,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
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

-- Travel
local function addTravelKeyword(keyword, text, cost, destination, condition)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. (text or keyword:titleCase()) .. ' for |TRAVELCOST|?', cost = cost})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Maybe another time.', reset = true})
end

addTravelKeyword('west', 'the west end of Port Hope', 7, Position(32558, 32780, 7))
addTravelKeyword('centre', 'the centre of Port Hope', 7, Position(32628, 32771, 7))
addTravelKeyword('darama', 'darama' , 30, Position(32987, 32729, 7))
addTravelKeyword('center', 'the center of Port Hope', 0, Position(32628, 32771, 7))
addTravelKeyword('chor', 'chor' , 30, Position(32968, 32799, 7))
addTravelKeyword('banuta', 'banuta' , 30, Position(32826, 32631, 7))
addTravelKeyword('mountain', 'mountain' , 30, Position(32987, 32729, 7))
addTravelKeyword('mountain pass', 'mountain pass' , 30, Position(32987, 32729, 7))
-- Basic
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = "I heard he is some scary magician or so."})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'I can travel you to {west}, {center}, {darama}, {chor} or {banuta}.'})

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, |PLAYERNAME| do you seek a {passage} ?')
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
