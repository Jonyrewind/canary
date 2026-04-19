local config = {
	maxGemBreak = 10,
	fragmentGems = {
		small = { ids = { 44602, 44605, 44608, 44611, 49371 }, fragment = 46625, range = { 1, 4 } },
		medium = { ids = { 44603, 44606, 44609, 44612, 49372 }, fragment = 46625, range = { 2, 8 } },
		great = { ids = { 44604, 44607, 44610, 44613, 49373 }, fragment = 46626, range = { 1, 4 } },
	},
	rewardBagItems = {
		ids = {
			34082, 34083, 34084, 34085, 34086, 34087, 34088, 34089, 34090, 34091, 34092, 34093, 34094, 34095, 34096, 34097, 34098, 34099, 39147, 39148, 39149, 39150, 39151, 39152, 39153, 39154, 39177, 39180, 39183, 39186, 43864, 43866, 43868, 43870, 43872, 43874, 43876, 43877, 43879, 43881, 43882, 43884, 43885, 43887, 50146, 50147, 50150, 50157, 50159, 50188, 50240, 50254,
		},
		fragment = 46625,
		range = { 1, 3 },
		bonusFragment = {
			id = 46626,
			chance = 5,
			count = 1,
		},
	},
}

local function getGemData(gemId)
	for _, gemData in pairs(config.fragmentGems) do
		if table.contains(gemData.ids, gemId) then
			return gemData
		end
	end

	if table.contains(config.rewardBagItems.ids, gemId) then
		return config.rewardBagItems
	end

	return nil
end

local function getSuccessMessage(gemData)
	if gemData == config.rewardBagItems then
		return "You have crushed the item into fragments."
	end

	return "You have broken the gem into fragments."
end

local amberCrusher = Action()

function amberCrusher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() or target:getId() == item:getId() or player:getItemCount(target:getId()) <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the crusher on a valid gem in your inventory.")
		return true
	end

	local gemData = getGemData(target:getId())
	if not gemData then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item can't be broken into fragments.")
		return true
	end

	local breakAmount = (target:getCount() >= config.maxGemBreak) and config.maxGemBreak or 1
	target:remove(breakAmount)

	for _ = 1, breakAmount do
		player:addItem(gemData.fragment, math.random(gemData.range[1], gemData.range[2]))

		if gemData.bonusFragment and math.random(100) <= gemData.bonusFragment.chance then
			player:addItem(gemData.bonusFragment.id, gemData.bonusFragment.count)
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, getSuccessMessage(gemData))
	return true
end

amberCrusher:id(46628)
amberCrusher:register()

local crusher = Action()

function crusher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() or target:getId() == item:getId() or player:getItemCount(target:getId()) <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the crusher on a valid gem in your inventory.")
		return true
	end

	local gemData = getGemData(target:getId())
	if not gemData then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item can't be broken into fragments.")
		return true
	end

	local crusherCharges = item:getAttribute(ITEM_ATTRIBUTE_CHARGES)
	if not crusherCharges or crusherCharges <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your crusher has no more charges.")
		return true
	end

	target:remove(1)
	player:addItem(gemData.fragment, math.random(gemData.range[1], gemData.range[2]))

	if gemData.bonusFragment and math.random(100) <= gemData.bonusFragment.chance then
		player:addItem(gemData.bonusFragment.id, gemData.bonusFragment.count)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, getSuccessMessage(gemData))

	crusherCharges = crusherCharges - 1
	if crusherCharges > 0 then
		local container = item:getParent()
		item:setAttribute(ITEM_ATTRIBUTE_CHARGES, crusherCharges)
		if container:isContainer() then
			player:sendUpdateContainer(container)
		end
	else
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your crusher has been consumed.")
	end
	return true
end

crusher:id(46627)
crusher:register()
