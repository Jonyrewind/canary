local boats = {
	[1] = {
		boatPosition = Position(33892, 31568, 7),
		toPosition = Position(33916, 31655, 7),
	},
	[2] = {
		boatPosition = Position(33915, 31655, 7),
		toPosition = Position(33892, 31567, 7),
	},
	[3] = {
		boatPosition = Position(33809, 31506, 7),
		toPosition = Position(33783, 31683, 7),
	},
	[4] = {
		boatPosition = Position(33783, 31682, 7),
		toPosition = Position(33809, 31505, 7),
	},
}


local actions_boat_shortcuts = Action()

function actions_boat_shortcuts.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getActionId() == 4925 then
		for _, p in pairs(boats) do
			local boat = p.boatPosition
--			local value = p.value
			local toPos = p.toPosition
--			local message = p.message
			if item:getPosition() == boat then
--				if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses) >= value then
					player:teleportTo(toPos, true)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
--					if message then
--						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
--					end
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this boat yet.")
--				end
			end
		end
	end
	return true
end

actions_boat_shortcuts:aid(4925)
actions_boat_shortcuts:register()
