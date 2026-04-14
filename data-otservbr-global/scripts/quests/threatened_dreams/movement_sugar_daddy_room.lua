local config = {
	[25030] = {
		bossName = "Sugar Daddy", -- boss name
		bossPos = Position(33369, 32221, 9), -- Boss Position
		centerPos = Position(33372, 32227, 9), -- Boss Room Center
		newPos = Position(33372, 32240, 9), -- Where to teleport player when entering the room
		exitPos = Position(33397, 32201, 9), -- Exit Position
		rangeX = 20, -- Range in X
		rangeY = 20, -- Range in Y
		time = 10, -- time in minutes to remove the player
	},
}

local suggarDaddyRoom = MoveEvent()

function suggarDaddyRoom.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local room = config[item.actionid]
	if not room then
		return
	end

	if player:getPosition() == Position(33372, 32241, 9) then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(room.exitPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if not player:canFightBoss(room.bossName) then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You have to wait to challenge this enemy again!", TALKTYPE_MONSTER_SAY)
		return true
	end

	if roomIsOccupied(room.centerPos, false, room.rangeX, room.rangeY) then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("Someone is fighting against the boss! You need wait awhile.", TALKTYPE_MONSTER_SAY)
		return true
	end

	clearRoom(room.centerPos, room.rangeX, room.rangeY)
	local monster = Game.createMonster(room.bossName, room.bossPos, true, true)
	if not monster then
		return true
	end

	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(room.newPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say("You have ten minutes to kill and loot this boss, else you will lose that chance and will be kicked out.", TALKTYPE_MONSTER_SAY)
	addEvent(clearBossRoom, 60 * room.time * 1000, player.uid, room.centerPos, false, room.rangeX, room.rangeY, room.exitPos)
	player:setBossCooldown(room.bossName, os.time() + 2 * 3600)
	return true
end

suggarDaddyRoom:type("stepin")
suggarDaddyRoom:aid(25030)
suggarDaddyRoom:register()
