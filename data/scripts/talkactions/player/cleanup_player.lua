-- Multipurpose cleanup talkactions (pouch + reward chest only)
-- Usage:
--   "!cleanpouch" - remove all items from your gold/loot pouch.
--   "!cleanrewardchest" - remove ALL reward loot by emptying every reward container in your reward chest.

local function removePouchContents(pouch)
	local removedCount = 0
	local items = pouch:getItems(true) or {}
	for _, item in ipairs(items) do
		item:remove()
		removedCount = removedCount + 1
	end
	return removedCount
end

local function clearRewardChestAll(player)
	local rewardIds = player:getRewardList() or {}
	local emptiedCount = 0

	for _, rewardId in ipairs(rewardIds) do
		local reward = player:getReward(rewardId, true)
		if reward then
			local items = reward:getItems(true) or {}
			for _, item in ipairs(items) do
				item:remove()
			end
			emptiedCount = emptiedCount + 1
		end
	end

	return emptiedCount
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
	local emptiedCount = clearRewardChestAll(player)

	if emptiedCount == 0 then
		sendNonNilText(player, "Your reward chest is already empty.")
	else
		sendNonNilText(player, string.format("Emptied %i reward container(s) in your reward chest.", emptiedCount))
	end

	return true
end

-- registrations
cleanGoldPouch:setDescription("[Usage]: !cleanpouch - remove all items from your gold/loot pouch.")
cleanGoldPouch:separator(" ")
cleanGoldPouch:groupType("normal")
cleanGoldPouch:register()

clearRewardChestAction:setDescription("[Usage]: !cleanrewardchest - remove ALL reward loot by emptying every reward container in your reward chest.")
clearRewardChestAction:separator(" ")
clearRewardChestAction:groupType("normal")
clearRewardChestAction:register()
