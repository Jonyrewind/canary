local function clearMonstersAndTeleportPlayers()
    local leverRoomFromPos = Position(33658, 31934, 9)
    local leverRoomToPos   = Position(33670, 31940, 9)
    local bossRoomFromPos  = Position(33678, 31922, 9)
    local bossRoomToPos    = Position(33699, 31943, 9)

    local exitPos        = Position(33657, 31943, 9)
    local bossDestination = Position(33684, 31932, 9)
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
    Game.createMonster("Glooth Fairy", Position(33688, 31937, 9), false, true)
end

local gloothFairyLever = Action()

function gloothFairyLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.GloothFairyTimer) >= os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait 15 minutes to use again.")
		return true
	end

	player:say("Everyone in this place will be teleported into Glooth Fairy's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
	Game.setStorageValue(GlobalStorage.GloothFairyTimer, os.time() + 15 * 60)
	addEvent(clearMonstersAndTeleportPlayers, 60 * 1000)
	return true
end

gloothFairyLever:uid(1020)
gloothFairyLever:register()
