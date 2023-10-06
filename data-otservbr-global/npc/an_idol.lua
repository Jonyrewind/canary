local internalNpcName = "An Idol"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookTypeEx = 15894,
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

local config = {
	{ position = { x = 32398, y = 32510, z = 7 }, destination = { x = 32366, y = 32531, z = 8 }, storage = Storage.Quest.U12_70.AdventuresOfGalthen.LostSatchel.Notes },
}

local function farewellCallback(creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getSex() == PLAYERSEX_FEMALE then
		npcHandler:setMessage(MESSAGE_FAREWELL, "")
	else
		npcHandler:setMessage(MESSAGE_FAREWELL, "")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)

	if not npcHandler:checkInteraction(npc, creature) then
		for value in pairs(config) do
			if MsgContains(message, "vbox") and player:getStorageValue(config[value].storage) == 1 and player:getPosition() == Position(config[value].position) then
				npcHandler:setInteraction(npc, player)
				npcHandler:setMessage(MESSAGE_GREET, "J-T B^C J^BXT°")
				player:teleportTo(Position(config[value].destination))
				addEvent(function()
					player:teleportTo(Position(32396, 32520, 7))
					player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
				end, 15000)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_FAREWELL, farewellCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, "")

npcHandler:addModule(FocusModule:new(), npcConfig.name, false, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
