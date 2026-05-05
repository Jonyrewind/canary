local function clearMonstersAndTeleportPlayers()
	local leverRoomFromPos = Position(33697, 31841, 7)
	local leverRoomToPos = Position(33711, 31851, 7)
	local bossRoomFromPos = Position(33691, 31816, 7)
	local bossRoomToPos = Position(33715, 31840, 7)

	local exitPos = Position(33703, 31857, 7)
	local bossDestination = Position(33699, 31835, 7)
	for x = bossRoomFromPos.x, bossRoomToPos.x do
		for y = bossRoomFromPos.y, bossRoomToPos.y do
			for z = bossRoomFromPos.z, bossRoomToPos.z do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creature = tile:getTopCreature()
					if creature then
						if creature:isMonster() then
							creature:remove()
						elseif creature:isPlayer() then
							creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
							creature:teleportTo(exitPos)
							creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						end
					end
				end
			end
		end
	end
	for x = leverRoomFromPos.x, leverRoomToPos.x do
		for y = leverRoomFromPos.y, leverRoomToPos.y do
			for z = leverRoomFromPos.z, leverRoomToPos.z do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creature = tile:getTopCreature()
					if creature and creature:isPlayer() then
						creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						creature:teleportTo(bossDestination)
						creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		end
	end
	Game.createMonster("Bullwark", Position(33697, 31820, 7), false, true)
end

local bullwarkLever = Action()

function bullwarkLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.BullwarkTimer) >= os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait 15 minutes to use again.")
		return true
	end

	player:say("Everyone in this place will be teleported into Bullwark's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
	Game.setStorageValue(GlobalStorage.BullwarkTimer, os.time() + 15 * 60)
	addEvent(clearMonstersAndTeleportPlayers, 60 * 1000)
	return true
end

bullwarkLever:uid(1022)
bullwarkLever:register()
