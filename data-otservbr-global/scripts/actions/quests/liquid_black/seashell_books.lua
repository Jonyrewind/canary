local books = {
	[14173] = { -- first large book
		storage = Storage.LiquidBlackQuest.Books,
		value = { need = 0, fail = 0, succes = 0, done = 3 },
		message = { fail = "Fail", succes = "The book seems to be part of a trilogy written by Lagatos. His words are precise and extremely dark." },
	},
	[14174] = { -- second large book
		storage = Storage.LiquidBlackQuest.Books,
		value = { need = 0, fail = 0, succes = 0, done = 3 },
		message = { fail = "Fail", succes = "The book seems to be part of a trilogy written by Lagatos. His words are precise and extremely dark." },
	},
	[14175] = { -- third large book
		storage = Storage.LiquidBlackQuest.Books,
		value = { need = 0, fail = 0, succes = 0, done = 3 },
		message = { fail = "Fail", succes = "The book seems to be part of a trilogy written by Lagatos. His words are precise and extremely dark." },
	},
}

local book = Action()

function book.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local book = item:getId()
	local data = books[book]
	if not data then
		return false
	end

	if player:getStorageValue(data.storage) <= data.value.done then
		if player:getStorageValue(data.storage + book) ~= 1 then
			player:setStorageValue(data.storage + book, 1)
			player:setStorageValue(data.storage, player:getStorageValue(data.storage) + 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, data.message.succes)
		end
	end
	return true
end

for id, data in pairs(books) do
	book:id(id)
end

book:register()
