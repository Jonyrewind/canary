local config = {
	{ position = { x = 32398, y = 32510, z = 7 }, storage = Storage.Quest.U12_70.AdventuresOfGalthen.LostSatchel.Notes },
}

local notes = Action()
function notes.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for value in pairs(config) do
		if player:getStorageValue(config[value].storage) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Staring at the writing you begin to decipher a letter. Then another and another. The symbols seem to wriggle and move: VBOX")
			player:setStorageValue(config[value].storage, 1)
			return true
		end
	end
end

for value in pairs(config) do
	notes:position(config[value].position)
end
notes:register()
