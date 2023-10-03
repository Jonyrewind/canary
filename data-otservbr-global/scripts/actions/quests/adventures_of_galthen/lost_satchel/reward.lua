local rewardLostSatchel = Action()

function rewardLostSatchel.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	
	if player:getStorageValue(Storage.Quest.U12_70.AdventuresOfGalthen.LostSatchel.Reward) < os.time() then
		local backpack = player:addItem(36813)
		if backpack then
			backpack:addItem(36810)
			local parchment = backpack:addItem(635)
			parchment:setText("Ancient notes from the knight Galthen, written specifically about disturbing events in and around the then young enclave of Bounac. A particularly long and detailed passage deals with the disappearance of a woman. Presumably due to a curse. The disappearance and heritage of the woman in great length with every clue known to Galthen at the time being meticulously recorded by the knight himself.")
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found Galthen's satchel.")
--		player:setStorageValue(Storage.Quest.U12_70.AdventuresOfGalthen.LostSatchel.Reward, os.time() + 360 * 60 * 60)
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait more time!")
		return false
	end
end

rewardLostSatchel:position({ x = 32366, y = 32542, z = 8 })
rewardLostSatchel:register()
