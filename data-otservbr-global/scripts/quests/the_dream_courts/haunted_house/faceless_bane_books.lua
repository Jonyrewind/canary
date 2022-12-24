local teleports = {
	[3273] = { --book about spells
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Books,
		value = {need = 4, succes = 4, done = 4},
		message = {fail = "The book tells you about a spell that draws its wielder towards the most energetic being next to him.", succes = "All chants have been sung in the right order, you are deemed worthy. You are transported away..."},
		newPos = Position({x = 33640, y = 32560, z = 13})
	},
	[3274] = { -- first large book
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Books,
		value = {need = 0, fail = 0, succes = 1, done = 4},
		message = {fail = "Fail", succes = "The chants in this book ofthen contain the word 'O'kteth'."}
	},
	[3275] = { -- second large book
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Books,
		value = {need = 1, fail = 0, succes = 2, done = 4},
		message = {fail = "Fail", succes = "The chants in this book ofthen contain the word 'O'kteth'."}
	},
	[3276] = { -- third large book
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Books,
		value = {need = 2, fail = 0, succes = 3, done = 4},
		message = {fail = "Fail", succes = "The chants in this book ofthen contain the word 'O'kteth'."}
	},
	[3277] = { -- fourth large book
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Books,
		value = {need = 3, fail = 0, succes = 4, done = 4},
		message = {fail = "Fail", succes = "All chants have been sung in the right order, you are deemed worthy. You are transported away..."},
		newPos = Position({x = 33640, y = 32560, z = 13})
	},
}


local book = Action()

function book.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	
	local aid = item:getActionId()
	local data = teleports[aid]
	if not data then
		return false
	end	
	
	if player:getStorageValue(data.storage) == data.value.need then
		if aid == 3273 or aid == 3277 then
			player:teleportTo(data.newPos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, data.message.succes)
			player:setStorageValue(data.storage, data.value.succes)
				print(""..data.value.need.." bb "..player:getStorageValue(data.storage).."")
	elseif player:getStorageValue(data.storage) < data.value.done then
		player:setStorageValue(data.storage, data.value.fail)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, data.message.fail)
		print(""..data.value.need.." aa "..player:getStorageValue(data.storage).."")
	end
	return true
end


for id, data in pairs(teleports) do
	book:aid(id)
end

book:register()