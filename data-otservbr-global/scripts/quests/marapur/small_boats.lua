local boats = {
	[1] = {
		boatPosition = Position(33633, 32770, 7),
		toPosition = Position(33778, 32661, 7),
		message = "The small boat sails you eastward, along the coastline of marapur.",
	},
	[2] = {
		boatPosition = Position(33777, 32660, 7),
		toPosition = Position(33904, 32760, 7),
		message = "The small boat sails you southward, along the coastline of marapur.",
	},
	[3] = {
		boatPosition = Position(33903, 32759, 7),
		toPosition = Position(33790, 32868, 7),
		message = "The small boat sails you westward, along the coastline of marapur.",
	},
	[4] = {
		boatPosition = Position(33789, 32868, 7),
		toPosition = Position(33634, 32770, 7),
		message = "The small boat sails you northward, along the coastline of marapur.",
	},
}

local actions_marapur_boats = Action()

function actions_marapur_boats.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, p in pairs(boats) do
		local boat = p.boatPosition
		local toPos = p.toPosition
		local message = p.message
		if item:getPosition() == boat then
			player:teleportTo(toPos, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
		end
	end
	return true
end

for _, p in pairs(boats) do
	actions_marapur_boats:position(p.boatPosition)
end
actions_marapur_boats:register()
