local internalNpcName = "Burner"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 97,
	lookBody = 77,
	lookLegs = 87,
	lookFeet = 115,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.shop = { -- Sellable items
	{ itemName = "gold token", clientId = 22721, buy = 5000000 },
	{ itemName = "silver token", clientId = 22516, buy = 2500000 },
}

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

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

-- Basic Keywords
keywordHandler:addKeyword({ "sell" }, StdModule.say, { npcHandler = npcHandler, text = "Just ask me for a {trade} to see what I buy from you." })
keywordHandler:addKeyword({ "stuff" }, StdModule.say, { npcHandler = npcHandler, text = "Just ask me for a {trade} to see my offers." })
keywordHandler:addAliasKeyword({ "wares" })
keywordHandler:addAliasKeyword({ "offer" })
keywordHandler:addAliasKeyword({ "buy" })


npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Take a look in the trade window to your left.")
npcHandler:setMessage(MESSAGE_GREET, {
	"Hello, hello, |PLAYERNAME|! Please come in, look, and buy! Just ask me for a {trade} to see my offers!",
})

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
