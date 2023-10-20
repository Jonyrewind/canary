local count = 0

local sacrificialPlate = Action()

function sacrificialPlate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.actionid == 10200 and item.itemid == 43891 then
		if player:getStorageValue(Storage.Quest.U13_20.RottenBlood.Access.SacrificialPlate) <= 0 then
			if player:getItemCount(32594) < 2 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Find the keeper of sanguine tears and offer his life fluids to the sanguine master of this realm.")
				return true
			end
			if count == 0 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reinforce your sacrefice of a bloody tear to the sanguine master of this realm to seal this trade.")
				count = count + 1
				return true
			end
			if count == 1 then
				if player:removeItem(32594, 1) then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your sacrefice has been accepted by the sanguine master of this realm.")
					count = count + 1
					return true
				end
			end
			if count == 2 then
				if player:removeItem(32594, 1) then
					player:setStorageValue(Storage.Quest.U13_20.RottenBlood.Access.SacrificialPlate, 1)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your sacrefice has been accepted by the sanguine master of this realm. Go forth and bedew your root with the waters of life.")
					return true
				end
			end			
		end
	end
	return true
end

sacrificialPlate:aid(10200)
sacrificialPlate:register()
