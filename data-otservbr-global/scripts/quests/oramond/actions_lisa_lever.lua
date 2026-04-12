local function clearMonstersAndTeleportPlayers()
	-- Areas
	local leverRoomFromPos = Position(33549, 31902, 8)
	local leverRoomToPos   = Position(33566, 31908, 8)

	local bossRoomFromPos  = Position(33532, 31864, 8)
	local bossRoomToPos    = Position(33600, 31908, 8)

	local exitPos         = Position(33557, 31914, 8)
	local bossDestination = Position(33556, 31895, 8)

	local bossZoneName = "boss.lisaroom"

	-- Helper: Check if position is inside lever room
	local function isInLeverRoom(pos)
		return pos.x >= leverRoomFromPos.x and pos.x <= leverRoomToPos.x and
		       pos.y >= leverRoomFromPos.y and pos.y <= leverRoomToPos.y and
		       pos.z == leverRoomFromPos.z
	end

	-- Step 1: Clear the boss area using rectangle + zone filter (only real boss tiles)
	for x = bossRoomFromPos.x, bossRoomToPos.x do
		for y = bossRoomFromPos.y, bossRoomToPos.y do
			for z = bossRoomFromPos.z, bossRoomToPos.z do
				local pos = Position(x, y, z)

				-- Only process tiles that belong to the actual boss zone
				if pos:isInZone(bossZoneName) then
					local tile = Tile(pos)
					if tile then
						local creature = tile:getTopCreature()
						if creature then
							if creature:isMonster() then
								creature:remove()
							elseif creature:isPlayer() and not isInLeverRoom(creature:getPosition()) then
								-- Kick players inside the boss zone (but not in lever room)
								creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
								creature:teleportTo(exitPos)
								creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
							end
						end
					end
				end
			end
		end
	end

	-- Step 2: Teleport players from lever room into the boss room
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

	-- Step 3: Spawn the boss
	Game.createMonster("Lisa", Position(33561, 31876, 8), false, true)
end

local lisaLever = Action()

function lisaLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.LisaTimer) >= os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait 15 minutes to use again.")
		return true
	end

	player:say("Everyone in this place will be teleported into Lisa's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
	Game.setStorageValue(GlobalStorage.LisaTimer, os.time() + 15 * 60)
	addEvent(clearMonstersAndTeleportPlayers, 60 * 1000)
	return true
end

lisaLever:uid(1023)
lisaLever:register()
