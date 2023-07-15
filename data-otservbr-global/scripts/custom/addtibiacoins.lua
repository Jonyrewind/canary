local storeCoin = Action()

function storeCoin.onUse(player, item, fromPosition, target, toPosition, isHotkey)
        local storeCoin = Player(cid)
        local storeCoin = item:getCount()
        player:getPosition():sendMagicEffect(15)
        item:remove()
        player:addTibiaCoins(storeCoin)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, ""..storeCoin.." Tibia Coin" .. (storeCoin > 1 and "s" or "") .. " " .. (storeCoin > 1 and "were" or "was") .. " added to you Balance.")
    end

storeCoin:id(22118)
storeCoin:register()