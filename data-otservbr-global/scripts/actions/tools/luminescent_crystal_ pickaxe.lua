local items = { 34082, 34083, 34084, 34085, 34086, 34087, 34088, 34089, 34090, 34091, 34092, 34093, 34094, 34095, 34096, 34097, 34098, 34099, 39147, 39148, 39149, 39150, 39151, 39152, 39153, 39154, 39177, 39180, 39183, 39186, 43864, 43866, 43868, 43870, 43872, 43874, 43876, 43877, 43879, 43881, 43882, 43884, 43885, 43887 }

local specialItem = 37110 -- The special item that has a small chance to drop
local specialChance = 0.10 -- 5% chance (adjust as needed)

local crystalPickaxe = Action()

function crystalPickaxe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local totalDusts = player:getForgeDusts()
	local limitDusts = player:getForgeDustLevel()
	local amount = 30

	if table.contains(items, target.itemid) then
		if totalDusts < limitDusts then
			local dustToAdd = math.min(amount, limitDusts - totalDusts)
			player:addForgeDusts(dustToAdd)
			target:remove(1) -- Only remove the item if the player receives dust

			local actualTotalDusts = player:getForgeDusts()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received " .. dustToAdd .. " dust for the Exaltation Forge. You now have " .. actualTotalDusts .. " out of a maximum of " .. limitDusts .. " dusts.")

			-- Roll for special item drop
			if math.random() < specialChance then
				player:addItem(specialItem, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have also found a exalted core!")
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not receive any dust for the Exaltation Forge because you have already reached the maximum of " .. limitDusts .. " dust.")
		end
		return true
	end
end

crystalPickaxe:id(32711)
crystalPickaxe:register()
