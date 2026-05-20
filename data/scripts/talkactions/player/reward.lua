local config = {
	items = {
		{ id = 35284, charges = 64400 },
		{ id = 35279, charges = 64400 },
		{ id = 35281, charges = 64400 },
		{ id = 35283, charges = 64400 },
		{ id = 35282, charges = 64400 },
		{ id = 35280, charges = 64400 },
		{ id = 44066, charges = 64400 },
		{ id = 50294, charges = 64400 },
	},
	storage = tonumber(Storage.PlayerWeaponReward), -- storage key, player can claim once per 24h
}

local function sendExerciseRewardModal(player)
	local window = ModalWindow({
		title = "Exercise Reward",
		message = "choose a item",
	})
	for _, it in pairs(config.items) do
		local iType = ItemType(it.id)
		if iType then
			window:addChoice(iType:getName(), function(player, button, choice)
				if button.name ~= "Select" then
					return true
				end

				local inbox = player:getStoreInbox()
				local inboxItems = inbox:getItems()
				if inbox and #inboxItems < inbox:getMaxCapacity() and player:getFreeCapacity() >= iType:getWeight() then
					local item = inbox:addItem(it.id, it.charges)
					if item then
						item:setActionId(IMMOVABLE_ACTION_ID)
						item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
						item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, string.format("You won this exercise weapon as a reward to be a %s player. Use it in a dummy!\nHave a nice game..", configManager.getString(configKeys.SERVER_NAME)))
					else
						player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
						return
					end
					player:sendTextMessage(MESSAGE_LOOK, string.format("Congratulations, you received a %s with %i charges in your store inbox.", iType:getName(), it.charges))
					player:setStorageValue(config.storage, systemTime())
				else
					player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
				end
			end)
		end
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
end

local exerciseRewardModal = TalkAction("!reward")
function exerciseRewardModal.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.TOGGLE_RECEIVE_REWARD) or player:getTown():getId() < TOWNS_LIST.AB_DENDRIEL then
		return true
	end
	local lastRewardTime = player:getStorageValue(config.storage)
	local now = systemTime()
	local rewardCooldown = 24 * 60 * 60

	if lastRewardTime > 0 and (now - lastRewardTime) < rewardCooldown then
		player:sendTextMessage(MESSAGE_LOOK, string.format("You already received your exercise weapon reward. Come back in %i hours.", math.ceil((rewardCooldown - (now - lastRewardTime)) / 3600)))
		return true
	end

	sendExerciseRewardModal(player)
	return true
end

exerciseRewardModal:separator(" ")
exerciseRewardModal:groupType("normal")
exerciseRewardModal:register()
