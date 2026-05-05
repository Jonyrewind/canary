local internalNpcName = "Agiota"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 1

npcConfig.outfit = {
	lookType = 146,
	lookHead = 95,
	lookBody = 9,
	lookLegs = 12,
	lookFeet = 123,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

-- Price settings
local config = {
	updateInterval = 15 * 60 * 1000, -- Updates every 15 minutes
}

-- Greedy NPC Settings
local MIN_BUY = 1500 -- lowest the NPC will ever buy
local MAX_BUY = 5000 -- highest the NPC will ever buy
local MIN_SELL = 200000 -- lowest the NPC will ever sell
local MAX_SELL = 250000 -- highest the NPC will ever sell

local currentBuyPrice = 3000
local currentSellPrice = 225000
local lastUpdate = os.time()

-- Format numbers with commas
local function formatNumber(num)
	local formatted = tostring(num)
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

-- Get player's total money (backpack + bank)
local function getPlayerTotalMoney(player)
	return player:getMoney() + player:getBankBalance()
end

-- Remove money from player (prioritize backpack, then bank)
local function removePlayerMoney(player, amount)
	local backpackMoney = player:getMoney()
	if backpackMoney >= amount then
		player:removeMoney(amount)
		return true
	else
		player:removeMoney(backpackMoney)
		local remaining = amount - backpackMoney
		if player:getBankBalance() >= remaining then
			player:setBankBalance(player:getBankBalance() - remaining)
			return true
		end
	end
	return false
end

-- Calculate dynamic prices
local function calculatePrices()
	currentBuyPrice = math.random(MIN_BUY, MAX_BUY)
	currentSellPrice = math.random(MIN_SELL, MAX_SELL)

	lastUpdate = os.time()
	print("[Agiota] Prices updated - BUY: " .. currentBuyPrice .. " | SELL: " .. currentSellPrice)
end

-- Schedule price updates
local function schedulePriceUpdate()
	calculatePrices()
	addEvent(schedulePriceUpdate, config.updateInterval)
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- Greeting
local function greetCallback(npc, creature)
	local player = Player(creature)
	if not player then
		return false
	end

	npcHandler:setMessage(MESSAGE_GREET, string.format("Hello %s! I buy Tibia Coins for %s gp and sell for %s gp. Say {sell} or {buy} to trade.", player:getName(), formatNumber(currentBuyPrice), formatNumber(currentSellPrice)))
	return true
end

-- Conversation flow
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player then
		return false
	end

	local playerId = player:getId()
	local lowerMsg = message:lower()

	-- Sell flow
	if npcHandler:getTopic(playerId) == 0 and lowerMsg == "sell" then
		npcHandler:say("How many Tibia Coins do you want to sell? You can say {all} to sell everything.", npc, creature)
		npcHandler:setTopic(playerId, 1)
		return true
	elseif npcHandler:getTopic(playerId) == 1 then
		if lowerMsg == "all" then
			local tcCount = player:getTransferableCoins()
			if tcCount <= 0 then
				npcHandler:say("You don't have any Tibia Coins to sell.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			local totalGold = tcCount * currentBuyPrice
			npcHandler:say(string.format("Would you like to sell all %d Tibia Coins for %s gold coins? (say {yes} or {no})", tcCount, formatNumber(totalGold)), npc, creature)
			player:setStorageValue(1001, tcCount)
			npcHandler:setTopic(playerId, 2)
			return true
		else
			local amount = tonumber(lowerMsg)
			if not amount or amount <= 0 then
				npcHandler:say("Please tell me a valid amount.", npc, creature)
				return true
			end
			if player:getTransferableCoins() < amount then
				npcHandler:say("You don't have that many Tibia Coins.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			local totalGold = amount * currentBuyPrice
			npcHandler:say(string.format("Would you like to sell %d Tibia Coins for %s gold coins? (say {yes} or {no})", amount, formatNumber(totalGold)), npc, creature)
			player:setStorageValue(1001, amount)
			npcHandler:setTopic(playerId, 2)
			return true
		end

		-- Buy flow
	elseif npcHandler:getTopic(playerId) == 0 and lowerMsg == "buy" then
		npcHandler:say("How many Tibia Coins do you want to buy? You can say {all} to buy as many as you can afford.", npc, creature)
		npcHandler:setTopic(playerId, 3)
		return true
	elseif npcHandler:getTopic(playerId) == 3 then
		if lowerMsg == "all" then
			local totalMoney = getPlayerTotalMoney(player)
			local maxTC = math.floor(totalMoney / currentSellPrice)
			if maxTC <= 0 then
				npcHandler:say("You don't have enough gold coins to buy any Tibia Coins.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			local totalCost = maxTC * currentSellPrice
			npcHandler:say(string.format("Would you like to buy %d Tibia Coins for %s gold coins? (say {yes} or {no})", maxTC, formatNumber(totalCost)), npc, creature)
			player:setStorageValue(1001, maxTC)
			npcHandler:setTopic(playerId, 4)
			return true
		else
			local amount = tonumber(lowerMsg)
			if not amount or amount <= 0 then
				npcHandler:say("Please tell me a valid amount.", npc, creature)
				return true
			end
			local totalCost = amount * currentSellPrice
			if getPlayerTotalMoney(player) < totalCost then
				npcHandler:say("You don't have enough gold coins for that many Tibia Coins.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			npcHandler:say(string.format("Would you like to buy %d Tibia Coins for %s gold coins? (say {yes} or {no})", amount, formatNumber(totalCost)), npc, creature)
			player:setStorageValue(1001, amount)
			npcHandler:setTopic(playerId, 4)
			return true
		end

		-- Confirm sell
	elseif npcHandler:getTopic(playerId) == 2 and lowerMsg == "yes" then
		local amount = player:getStorageValue(1001)
		if amount <= 0 then
			npcHandler:say("Transaction cancelled.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end
		if player:getTransferableCoins() < amount then
			npcHandler:say("You don't have that many Tibia Coins anymore.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end
		local totalGold = amount * currentBuyPrice
		player:removeTransferableCoins(amount)
		player:addMoney(totalGold) -- Adds to backpack only
		npcHandler:say(string.format("You sold %d Tibia Coins for %s gold coins.", amount, formatNumber(totalGold)), npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		npcHandler:setTopic(playerId, 0)
		return true

		-- Confirm buy
	elseif npcHandler:getTopic(playerId) == 4 and lowerMsg == "yes" then
		local amount = player:getStorageValue(1001)
		if amount <= 0 then
			npcHandler:say("Transaction cancelled.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end
		local totalCost = amount * currentSellPrice
		if not removePlayerMoney(player, totalCost) then
			npcHandler:say("You don't have enough gold coins anymore.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end
		player:addTransferableCoins(amount)
		npcHandler:say(string.format("You bought %d Tibia Coins for %s gold coins.", amount, formatNumber(totalCost)), npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		npcHandler:setTopic(playerId, 0)
		return true

		-- Cancel any transaction
	elseif (npcHandler:getTopic(playerId) == 2 or npcHandler:getTopic(playerId) == 4) and lowerMsg == "no" then
		npcHandler:say("Transaction cancelled.", npc, creature)
		npcHandler:setTopic(playerId, 0)
		return true
	end

	return false
end

-- NPC configuration
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

-- Initialization
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Come back anytime!")

-- Start price update system
calculatePrices()
schedulePriceUpdate()

npcConfig.shop = {
	{ itemName = "Tibia Coins", clientId = 22118, buy = math.random(200000, 250000) },
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

npcType:register(npcConfig)
