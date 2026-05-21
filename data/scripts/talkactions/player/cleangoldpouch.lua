-- Usage talkaction: "!cleangoldpouch" to remove all items from your gold/loot pouch.
local cleanGoldPouch = TalkAction("!cleanpouch")

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

cleanGoldPouch:separator(" ")
cleanGoldPouch:groupType("normal")
cleanGoldPouch:register()
