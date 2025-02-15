local bossName = "Bullwark" -- Boss Name
local kickEvent = nil -- Store the kickPlayersOut event ID

-- Boss room positions
local bossRoomFromPos = Position(33691, 31816, 7)
local bossRoomToPos = Position(33713, 31840, 7)

-- Lever room positions (excluded from boss room check)
local leverRoomFromPos = Position(33697, 31840, 7)
local leverRoomToPos = Position(33710, 31851, 7)

-- Exit position for players after time expires
local exitPos = Position(33701, 31858, 7)

-- Destination where players are teleported inside the boss room
local destinationPos = Position(33699, 31835, 7)

-- Utility function to iterate through all tiles in a given area
local function iterateTiles(fromPos, toPos, callback)
	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			for z = fromPos.z, toPos.z do
				local currentTile = Tile(Position({ x = x, y = y, z = z }))
				if currentTile then
					callback(currentTile)
				end
			end
		end
	end
end

-- Function to check if the boss room is occupied (excluding lever room overlap)
local function isBossRoomOccupied()
	local foundPlayer = false
	iterateTiles(bossRoomFromPos, bossRoomToPos, function(tile)
		local topCreature = tile:getTopCreature()
		if topCreature and topCreature:isPlayer() then
			-- Ensure we are not checking the lever room
			if not (tile:getPosition().x >= leverRoomFromPos.x and tile:getPosition().x <= leverRoomToPos.x and
			        tile:getPosition().y >= leverRoomFromPos.y and tile:getPosition().y <= leverRoomToPos.y) then
				foundPlayer = true
			end
		end
	end)
	return foundPlayer
end

-- Function to remove all players from the boss room
local function kickPlayersOut()
	iterateTiles(bossRoomFromPos, bossRoomToPos, function(tile)
		local topCreature = tile:getTopCreature()
		if topCreature and topCreature:isPlayer() then
			topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			topCreature:teleportTo(exitPos)
			topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			topCreature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been kicked out!")
		end
	end)
end

-- Boss death event that gives players 60 seconds to loot before kicking them out
local bullwarkBossDeath = CreatureEvent("BullwarkBossDeath")

function bullwarkBossDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if creature:getName() ~= bossName then
		return true
	end

	-- Cancel the 15-minute kickPlayersOut event
	if kickEvent then
		stopEvent(kickEvent)
		kickEvent = nil
	end

	-- Notify all players inside the boss room
	iterateTiles(bossRoomFromPos, bossRoomToPos, function(tile)
		local topCreature = tile:getTopCreature()
		if topCreature and topCreature:isPlayer() then
			topCreature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Bullwark has been defeated! You have 60 seconds to loot and leave.")
		end
	end)

	-- Schedule a final kick after 60 seconds
	kickEvent = addEvent(kickPlayersOut, 60 * 1000)

	return true
end

bullwarkBossDeath:register()

-- Function to clear the boss room, remove old monsters, and teleport players in
local function clearMonstersAndTeleportPlayers()
	-- Remove all monsters from the boss room BEFORE teleporting players
	iterateTiles(bossRoomFromPos, bossRoomToPos, function(tile)
		local topCreature = tile:getTopCreature()
		if topCreature and topCreature:isMonster() then
			topCreature:remove()
		end
	end)

	-- Teleport players from the lever room to the boss room
	iterateTiles(leverRoomFromPos, leverRoomToPos, function(tile)
		local topCreature = tile:getTopCreature()
		if topCreature and topCreature:isPlayer() then
			topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			topCreature:teleportTo(destinationPos)
			topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end)

	-- Spawn the boss AFTER teleporting the players
	local boss = Game.createMonster(bossName, Position(33697, 31820, 7), false, true)
	if boss then
		boss:registerEvent("BullwarkBossDeath") -- Register the death event
	end

	-- Start the 15-minute timer to check if players need to be kicked
	kickEvent = addEvent(kickPlayersOut, 15 * 60 * 1000)
end

-- Lever script to activate boss fight
local bullwarkLever = Action()

function bullwarkLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.BullwarkTimer) >= os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait 15 minutes to use again.")
		return true
	end

	-- Check if the boss room is occupied before activating the lever
	if isBossRoomOccupied() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There is a team fighting Bullwark right now!")
		return true -- Cancel the lever use
	end

	player:say("Everyone in this place will be teleported into Bullwark's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
	Game.setStorageValue(GlobalStorage.BullwarkTimer, os.time() + 15 * 60)
	addEvent(clearMonstersAndTeleportPlayers, 60 * 1000)
	return true
end

bullwarkLever:uid(1112)
bullwarkLever:register()
