local function clearMonstersAndTeleportPlayers()
	local leverRoomFromPos = Position(33549, 31902, 8)
	local leverRoomToPos = Position(33566, 31908, 8)
	local bossRoomFromPos = Position(33532, 31864, 8)
	local bossRoomToPos = Position(33600, 31908, 8)
	local exitPos = Position(33557, 31914, 8)
	local destinationPos = Position(33556, 31895, 8)

	for x = leverRoomFromPos.x, leverRoomToPos.x do
		for y = leverRoomFromPos.y, leverRoomToPos.y do
			for z = leverRoomFromPos.z, leverRoomToPos.z do
				local currentTile = Tile(Position({ x = x, y = y, z = z }))
				if currentTile then
					local topCreature = currentTile:getTopCreature()
					if topCreature and topCreature:isPlayer() then
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						topCreature:teleportTo(exitPos)
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		end
	end

	for x = bossRoomFromPos.x, bossRoomToPos.x do
		for y = bossRoomFromPos.y, bossRoomToPos.y do
			for z = bossRoomFromPos.z, bossRoomToPos.z do
				local currentTile = Tile(Position({ x = x, y = y, z = z }))
				if currentTile then
					local topCreature = currentTile:getTopCreature()
					if topCreature and topCreature:isMonster() then
						topCreature:remove()
					end
				end
			end
		end
	end

	for x = bossRoomFromPos.x, bossRoomToPos.x do
		for y = bossRoomFromPos.y, bossRoomToPos.y do
			for z = bossRoomFromPos.z, bossRoomToPos.z do
				local currentTile = Tile(Position({ x = x, y = y, z = z }))
				if currentTile then
					local topCreature = currentTile:getTopCreature()
					if topCreature and topCreature:isPlayer() then
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						topCreature:teleportTo(destinationPos)
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		end
	end

	Game.createMonster("Lisa", Position(33561, 31876, 8), false, true)
end

local gloothFairyLever = Action()

function gloothFairyLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.LisaTimer) >= os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait 15 minutes to use again.")
		return true
	end

	player:say("Everyone in this place will be teleported into Lisa's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
	Game.setStorageValue(GlobalStorage.LisaTimer, os.time() + 15 * 60)
	addEvent(clearMonstersAndTeleportPlayers, 60 * 1000)
	return true
end

gloothFairyLever:uid(1023)
gloothFairyLever:register()
