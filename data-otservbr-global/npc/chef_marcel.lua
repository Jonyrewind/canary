local internalNpcName = "Chef Marcel"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = "A talented chef who trades his secret recipes for Gold Tokens."

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 289,      -- Classic chef outfit
    lookHead = 114,
    lookBody = 114,
    lookLegs = 0,
    lookFeet = 114,
    lookAddons = 1,      -- Chef hat
}

npcConfig.flags = {
    floorchange = false,
}

npcConfig.voices = {
    interval = 15000,
    chance = 50,
    { text = "Freshly prepared dishes with special effects! Only for Gold Tokens." },
    { text = "Hungry for power? I have the best recipes in Tibia!" },
    { text = "My secret meals can make you faster, stronger or heal you completely." }
}

-- Currency: Gold Token
npcConfig.currency = 22721

-- ==================== SHOP WITH RANDOM PRICES (2 ~ 5) ====================
npcConfig.shop = {
    { name = "banana chocolate shake",      clientId = 9083,  buy = math.random(2, 5) },
    { name = "blessed acorn",               clientId = 26074, buy = math.random(2, 5) },
    { name = "blessed steak",               clientId = 9086,  buy = math.random(2, 5) },
    { name = "blueberry cupcake",           clientId = 28484, buy = math.random(2, 5) },
    { name = "carrion casserole",           clientId = 26076, buy = math.random(2, 5) },
    { name = "carrot cake",                 clientId = 9087,  buy = math.random(2, 5) },
    { name = "carrot pie",                  clientId = 29409, buy = math.random(2, 5) },
    { name = "chilli con carniphila",       clientId = 26075, buy = math.random(2, 5) },
    { name = "coconut shrimp bake",         clientId = 11584, buy = math.random(2, 5) },
    { name = "consecrated beef",            clientId = 26077, buy = math.random(2, 5) },
    { name = "delicatessen salad",          clientId = 29411, buy = math.random(2, 5) },
    { name = "demonic candy ball",          clientId = 26079, buy = math.random(2, 5) },
    { name = "filled jalapeño peppers",     clientId = 9085,  buy = math.random(2, 5) },
    { name = "hydra tongue salad",          clientId = 9080,  buy = math.random(2, 5) },
    { name = "lemon cupcake",               clientId = 28483, buy = math.random(2, 5) },
    { name = "northern fishburger",         clientId = 9088,  buy = math.random(2, 5) },
    { name = "overcooked noodles",          clientId = 29416, buy = math.random(2, 5) },
    { name = "pot of blackjack",            clientId = 26080, buy = math.random(2, 5) },
    { name = "roasted dragon wings",        clientId = 9081,  buy = math.random(2, 5) },
    { name = "roasted wyvern wings",        clientId = 29408, buy = math.random(2, 5) },
    { name = "rotworm stew",                clientId = 9089,  buy = math.random(2, 5) },
    { name = "strawberry cupcake",          clientId = 28482, buy = math.random(2, 5) },
    { name = "svargrond salmon filet",      clientId = 29413, buy = math.random(2, 5) },
    { name = "sweet mangonaise elixir",     clientId = 26081, buy = math.random(2, 5) },
    { name = "tropical fried terrorbird",   clientId = 9082,  buy = math.random(2, 5) },
    { name = "tropical marinated tiger",    clientId = 26078, buy = math.random(2, 5) },
    { name = "veggie casserole",            clientId = 9084,  buy = math.random(2, 5) },
    { name = "zaoan sauce",                 clientId = 26082, buy = math.random(2, 5) },
}

-- On buy / sell / check functions
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
    npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
    player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end

npcType.onCheckItem = function(npc, player, clientId, subType)
    -- You can leave this empty
end

-- ==================== NPC HANDLER ====================

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
    npcHandler:say("Greetings, |PLAYERNAME|! Are you hungry for something... special? I sell powerful dishes in exchange for {Gold Tokens}. Just say {trade}!", npc, creature)
    return true
end

keywordHandler:addKeyword({"trade"}, StdModule.say, {npcHandler = npcHandler, text = "Of course! Take a look at my special recipes."})
keywordHandler:addKeyword({"tokens"}, StdModule.say, {npcHandler = npcHandler, text = "Gold Tokens can be obtained from various bosses. I accept them in exchange for my exclusive meals."})

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(npc, creature, type, message)
    if MsgContains(message, "trade") or MsgContains(message, "buy") then
        npc:openShopWindow(creature)
        return true
    end
    return false
end)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
