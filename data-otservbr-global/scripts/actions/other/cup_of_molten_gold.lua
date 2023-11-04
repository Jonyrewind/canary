local items = {
	[3614] = { id = 12550, count = 1, chance = 25, fail = "a fir cone you picked from the tree", succes = "finest fir cone you cold find on this tree."}, --fir tree
	[19111] = { id = 12550, count = 1, chance = 25, fail = "the fir cone", succes = "fir cone." }, --fir cone
}

local cupOfMoltenGold = Action()

function cupOfMoltenGold.onUse(player, item, fromPosition, target, toPosition)
	for index, value in pairs(items) do
		if target.itemid == index then
			doRemoveItem(item.uid, 1)
			if value.chance > math.random(1, 100) then
				player:addItem(value.id, value.count or 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Carefully you drizzle some of the gold on top of the %s", value.succes))
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Drizzling all over %s, the molten gold only covers about half of it - not enough.", value.fail))
			end
		end
	end
	return true
end

cupOfMoltenGold:id(12804)
cupOfMoltenGold:register()