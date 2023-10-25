local worldBoard = Action()

	if getGlobalStorage(65015) == 1 then
		text = "Avoid the Ankhramun tar pits!"
	elseif getGlobalStorage(65015) == 2 then
		text = "Avoid the river near Drefia!"
	elseif getGlobalStorage(65015) == 3 then
		text = "Avoid the northernmost coast!"
	end

local communicates = {
	-- Fury Gates
	[1] = {
		globalStorage = 65000,
		communicate = "A fiery fury gate has opened near one of the major cities somewhere in Tibia.",
	},
	-- Yasir
	[2] = {
		globalStorage = 65014,
		communicate = "Oriental ships sighted! A trader for exotic creature products may currently be visiting Carlin, Ankrahmun or Liberty Bay.",
	},
	-- Nightmare Isle
	[3] = {
		globalStorage = 65015,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. " ..text,

	},
}

function worldBoard.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, value in pairs(communicates) do
		if getGlobalStorage(value.globalStorage) > 0  then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.communicate)
		end
	end
	return true
end

worldBoard:id(19236)
worldBoard:register()
