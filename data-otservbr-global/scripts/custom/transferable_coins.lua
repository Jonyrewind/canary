local transferableCoin = Action()

function transferableCoin.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	local count = item:getCount()
	item:remove()
	player:addTransferableCoins(count)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have added " .. count .. " tibia coins to your balance. Your total is now " .. player:getTransferableCoins() .. ".")
end

transferableCoin:id(ITEM_STORE_COIN)
transferableCoin:register()