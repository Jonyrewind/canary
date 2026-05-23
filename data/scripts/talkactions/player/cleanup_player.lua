-- Multipurpose cleanup talkactions
-- Usage:
--   "!cleanpouch" - remove all items from your gold/loot pouch.
--   "!cleanrewardchest" - remove ALL reward containers (and their loot) from your reward chest.
--   "!clean [pouch|rewardchest|all]" - cleanup one or both.
-- NOTE: !cleanrewardchest empties the reward chest completely.

local function removePouchContents(pouch)
	local removedCount = 0
	-- gold pouch is a container, so it supports getItems(true) like Store Inbox
	local items = pouch:getItems(true) or {}
	for _, item in ipairs(items) do
		-- remove all contents (coins/loot entries) from pouch
		item:remove()
		removedCount = removedCount + 1
	end
	return removedCount
end

local function cleanRewardChestEmptyOnly(player)
	-- Safe mode: only remove EMPTY reward containers.
	local removedCount = 0

	local rewardChest = player:getRewardChest()
	if not rewardChest then
		return 0
	end

	local rewardIds = player:getRewardList() or {}
	for _, rewardId in ipairs(rewardIds) do
		local reward = player:getReward(rewardId, false)
		if reward and reward:empty() then
			rewardChest:removeItem(reward)
			player:removeReward(rewardId)
			removedCount = removedCount + 1
		end
	end

	return removedCount
end

local function clearRewardChestAll(player)
	-- Full mode: remove ALL reward containers (even non-empty).
	local removedCount = 0

	local rewardChest = player:getRewardChest()
	if not rewardChest then
		return 0
	end

	local rewardIds = player:getRewardList() or {}
	for _, rewardId in ipairs(rewardIds) do
		local reward = player:getReward(rewardId, false)
		if reward then
			rewardChest:removeItem(reward)
			player:removeReward(rewardId)
			removedCount = removedCount + 1
		end
	end

	return removedCount
end

local function sendNonNilText(player, text)
	if text and text ~= "" then
		player:sendTextMessage(MESSAGE_LOOK, text)
	end
end

-- !cleanpouch
local cleanGoldPouch = TalkAction("!cleanpouch")

function cleanGoldPouch.onSay(player, words, param)
	local pouch = player:getItemById(ITEM_GOLD_POUCH, true)
	if not pouch then
		player:sendTextMessage(MESSAGE_LOOK, "You don't have a pouch.")
		return true
	end

	if not pouch:isContainer() then
		player:sendTextMessage(MESSAGE_LOOK, "Your pouch is not a container.")
		return true
	end

	local removedCount = removePouchContents(pouch)
	if removedCount == 0 then
		player:sendTextMessage(MESSAGE_LOOK, "Your pouch is already empty.")
	else
		player:sendTextMessage(MESSAGE_LOOK, string.format("Removed %i item(s) from your pouch.", removedCount))
	end

	return true
end

-- !cleanrewardchest
local clearRewardChestAction = TalkAction("!cleanrewardchest")

function clearRewardChestAction.onSay(player, words, param)
	local removedCount = clearRewardChestAll(player)

	if removedCount == 0 then
		sendNonNilText(player, "Your reward chest is already empty.")
	else
		sendNonNilText(player, string.format("Removed %i reward container(s) from your reward chest.", removedCount))
	end

	return true
end

-- !clean [pouch|rewardchest|all]
local cleanAll = TalkAction("!clean")

function cleanAll.onSay(player, words, param)
	local target = (param or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
	if target == "" then
		target = "all"
	end

	local totalPouchRemoved = 0
	local totalRewardRemoved = 0

	if target == "pouch" then
		local pouch = player:getItemById(ITEM_GOLD_POUCH, true)
		if not pouch or not pouch:isContainer() then
			sendNonNilText(player, "You don't have a pouch (or it is not a container).")
			return true
		end
		totalPouchRemoved = removePouchContents(pouch)
	elseif target == "rewardchest" or target == "reward" or target == "chest" then
		-- For !cleanrewardchest we clear everything.
		-- For !clean rewardchest we keep it safe and empty-only.
		totalRewardRemoved = cleanRewardChestEmptyOnly(player)
	elseif target == "all" then
		-- pouch cleanup
		local pouch = player:getItemById(ITEM_GOLD_POUCH, true)
		if pouch and pouch:isContainer() then
			totalPouchRemoved = removePouchContents(pouch)
		end
		-- reward cleanup (empty-only for !clean all)
		totalRewardRemoved = cleanRewardChestEmptyOnly(player)
	else
		sendNonNilText(player, "Usage: !cleanpouch | !cleanrewardchest | !clean [pouch|rewardchest|all]")
		return true
	end

	if target == "pouch" then
		if totalPouchRemoved == 0 then
			sendNonNilText(player, "Your pouch is already empty.")
		else
			sendNonNilText(player, string.format("Removed %i item(s) from your pouch.", totalPouchRemoved))
		end
	elseif target == "rewardchest" or target == "reward" or target == "chest" then
		if totalRewardRemoved == 0 then
			sendNonNilText(player, "Your reward chest has no empty reward containers to remove.")
		else
			sendNonNilText(player, string.format("Removed %i empty reward container(s) from your reward chest.", totalRewardRemoved))
		end
	else
		local pouchMsg = ""
		if totalPouchRemoved == 0 then
			pouchMsg = "Pouch: already empty."
		else
			pouchMsg = string.format("Pouch: removed %i item(s).", totalPouchRemoved)
		end

		local chestMsg = ""
		if totalRewardRemoved == 0 then
			chestMsg = "Reward chest: no empty containers."
		else
			chestMsg = string.format("Reward chest: removed %i empty container(s).", totalRewardRemoved)
		end

		sendNonNilText(player, pouchMsg .. " " .. chestMsg)
	end

	return true
end

-- registrations
cleanGoldPouch:separator(" ")
cleanGoldPouch:groupType("normal")
cleanGoldPouch:register()

clearRewardChestAction:separator(" ")
clearRewardChestAction:groupType("normal")
clearRewardChestAction:register()

cleanAll:separator(" ")
cleanAll:groupType("normal")
cleanAll:register()
