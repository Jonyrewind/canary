local spawn = {
	[1] = { transformid = 13667, pos = Position(33564, 31208, 14), revert = 14167 },
	[2] = { transformid = 13667, pos = Position(33571, 31217, 14), revert = 14167 },
	[3] = { transformid = 13667, pos = Position(33561, 31221, 14), revert = 14167 },
	[4] = { transformid = 13667, pos = Position(33561, 31230, 14), revert = 14167 },
	[5] = { transformid = 13667, pos = Position(33575, 31242, 14), revert = 14167 },
	[6] = { transformid = 13667, pos = Position(33575, 31246, 14), revert = 14167 },
	[7] = { transformid = 13667, pos = Position(33580, 31259, 14), revert = 14167 },
	[8] = { transformid = 13667, pos = Position(33578, 31277, 14), revert = 14167 },
	[9] = { transformid = 13667, pos = Position(33581, 31299, 14), revert = 14167 },
	[10] = { transformid = 13667, pos = Position(33567, 31295, 14), revert = 14167 },
	[11] = { transformid = 13667, pos = Position(33556, 31299, 14), revert = 14167 },
	[12] = { transformid = 13667, pos = Position(33553, 31295, 14), revert = 14167 },
	[13] = { transformid = 13667, pos = Position(33559, 31283, 14), revert = 14167 },
	[14] = { transformid = 13667, pos = Position(33553, 31269, 14), revert = 14167 },
	[15] = { transformid = 13667, pos = Position(33536, 31261, 14), revert = 14167 },
	[16] = { transformid = 13667, pos = Position(33535, 31255, 14), revert = 14167 },
	[17] = { transformid = 13667, pos = Position(33531, 31239, 14), revert = 14167 },
	[18] = { transformid = 13667, pos = Position(33536, 31237, 14), revert = 14167 },
	[19] = { transformid = 13667, pos = Position(33540, 31244, 14), revert = 14167 },
	[20] = { transformid = 13667, pos = Position(33545, 31238, 14), revert = 14167 },
	[21] = { transformid = 13667, pos = Position(33556, 31248, 14), revert = 14167 },
	[22] = { transformid = 13667, pos = Position(33557, 31251, 14), revert = 14167 },
}

local function revert(position, itemId, transformId)
	for i = 1, #spawn do
		local spawn = spawn[i]
		local spawns = Tile(spawn.pos):getItemById(spawn.transformid)
		if spawns then
			spawns:transform(spawn.revert)
			setGlobalStorage(GlobalStorage.DeeplingSpawn, 0)
		end
	end
end

local FishNet = Action()

function FishNet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 28574 and target.itemid == 14167 then
		local spectators = Game.getSpectators(Position(33563, 31264, 14), false, true, 42, 25, 56, 56)
		for _, spectator in pairs(spectators) do
			local playerSpectator = spectator
			if getGlobalStorage(GlobalStorage.DeeplingSpawn) >= 22 then
				return false
			end
			if getGlobalStorage(GlobalStorage.DeeplingSpawn) < 0 then
				setGlobalStorage(GlobalStorage.DeeplingSpawn, 0)
			end
			if getGlobalStorage(GlobalStorage.DeeplingSpawn) == 21 then
				target:transform(13667)
				setGlobalStorage(GlobalStorage.DeeplingSpawn, getGlobalStorage(GlobalStorage.DeeplingSpawn) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You spread the net over the spawn and the darkness surrounding the hatch seems to dissolve.")
				playerSpectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The curse on the spawn has been lifted. All remaining evil spirits have fled from this place.")
				addEvent(revert, 2 * 60 * 1000, toPosition, 13667, 14167)
				if math.random(0, 100) >= 65 then
					playerSpectator:addItem(14019)
					playerSpectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Suddenly a small anchor seems to materialize inside the net. It looks like a keepsake from a long dead sailor.")
				end
				return true
			end
			target:transform(13667)
			setGlobalStorage(GlobalStorage.DeeplingSpawn, getGlobalStorage(GlobalStorage.DeeplingSpawn) + 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You spread the net over the spawn and the darkness surrounding the hatch seems to dissolve.")
			return true
		end
	elseif target.itemid == 13667 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The spirits have still not returned, the soul net has no effect yet")
	end
end

FishNet:id(14020)
FishNet:register()
