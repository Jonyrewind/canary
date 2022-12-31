local levers = {
	{leverPos = {x = 33515, y = 31444, z = 13}, teleportTo = Position({x = 33489, y = 31441, z = 13}), bossName = "Earl Osam", bossPos = Position({x = 33488, y = 31435, z = 13}), centerRoom = Position({x = 33488, y = 31438, z = 13}), kickPos = Position({x = 33263, y = 31986, z = 8}), storage = Storage.GraveDanger.Bosses.EarlOsam.Time},--Cormaya
	{leverPos = {x = 33454, y = 31413, z = 13}, teleportTo = Position({x = 33457, y = 31442, z = 13}), bossName = "Count Vlarkorth", bossPos = Position({x = 33457, y = 31433, z = 13}), centerRoom = Position({x = 33456, y = 31438, z = 13}), kickPos = Position({x = 33198, y = 31692, z = 8}), storage = Storage.GraveDanger.Bosses.CountVlarkorth.Time},--Edron
	{leverPos = {x = 33421, y = 31493, z = 13}, teleportTo = Position({x = 33425, y = 31480, z = 13}), bossName = "Lord Azaram", bossPos = Position({x = 33425, y = 31466, z = 13}), centerRoom = Position({x = 33424, y = 31472, z = 13}), kickPos = Position({x = 32192, y = 31819, z = 8}), storage = Storage.GraveDanger.Bosses.LordAzaram.Time},--Ghostland
	{leverPos = {x = 33423, y = 31413, z = 13}, teleportTo = Position({x = 33425, y = 31431, z = 13}), bossNames = {"Sir Baeloc", "Sir Nictros"}, bossPos = {Position({x = 33422, y = 31428, z = 13}), Position({x = 33427, y = 31428, z = 13})}, centerRoom = Position({x = 33424, y = 31439, z = 13}), kickPos = Position({x = 33290, y = 32475, z = 9}), storage = Storage.GraveDanger.Bosses.SirBaelocandSirNictros.Time},--Darashia
	{leverPos = {x = 33454, y = 31493, z = 13}, teleportTo = Position({x = 33456, y = 31477, z = 13}), bossName = "Duke Krule", bossPos = Position({x = 33456, y = 31468, z = 13}), centerRoom = Position({x = 33456, y = 31472, z = 13}), kickPos = Position({x = 32347, y = 32166, z = 12}), storage = Storage.GraveDanger.Bosses.DukeKrule.Time},--Thais
	timeToFightAgain = 3, -- In hour
	timeToDefeatBoss = 20, -- In minutes
	daily = true,
	requiredLevel = 250,
	requiredPlayers = 1,
	range = 12
}

local function StartBattle(bossPos)
	local boss = Tile(bossPos):getTopCreature()
	if boss and boss:isMonster() then
		boss:teleportTo(Position({x = 33427, y = 31436, z = 13}))
	end
end

local lever = Action()
function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for b = 1, #levers do
		if item:getPosition() == Position(levers[b].leverPos) then
			local team, adventurer = {}
			for c = levers[b].leverPos.x + 1, levers[b].leverPos.x + 5 do
				adventurer = Tile(Position(c, levers[b].leverPos.y, levers[b].leverPos.z)):getTopCreature()

				if player:getPosition() ~=  Position(levers[b].leverPos.x + 1, levers[b].leverPos.y, levers[b].leverPos.z) then
					return false
				end

				if adventurer and adventurer:isPlayer() then
					if adventurer:getLevel() < levers.requiredLevel then
						player:getPosition():sendMagicEffect(CONST_ME_POFF)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level ".. levers.requiredLevel .." or higher.")
						return true
					end
					
					if levers.daily and adventurer:getStorageValue(levers[b].storage) > os.time() then
						player:getPosition():sendMagicEffect(CONST_ME_POFF)
						if levers[b].bossNames then
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait ".. levers.timeToFightAgain .."  hours to face "..levers[b].bossNames[1].." and "..levers[b].bossNames[2].." again!")
						else
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait ".. levers.timeToFightAgain .."  hours to face "..levers[b].bossName.." again!")
						end
						return true
					end
					team[#team +1] = adventurer
				end
			end

			if #team < levers.requiredPlayers then
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need "..levers.requiredPlayers.." players to fight this boss.")
				return true
			end

			if bossroomIsOccupied(levers[b].centerRoom, levers.range, levers.range) then
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting "..levers[b].bossName.."! You need to wait awhile.")
				return true
			end

			clearRoom(levers[b].centerRoom, levers.range, levers.range, fromPosition)
			
			if levers[b].bossNames then
				Game.createMonster(levers[b].bossNames[1], levers[b].bossPos[1]):registerEvent("SirBaelocThink")
				Game.createMonster(levers[b].bossNames[2], levers[b].bossPos[2]):registerEvent("SirNictrosThink")
				addEvent(StartBattle, 15 * 1000, levers[b].bossPos[2])
			else
				Game.createMonster(levers[b].bossName, levers[b].bossPos)
			end
			for i = 1, #team do
				team[i]:getPosition():sendMagicEffect(CONST_ME_POFF)
				team[i]:teleportTo(levers[b].teleportTo)
				team[i]:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have ".. levers.timeToDefeatBoss .." minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.")
				team[i]:setStorageValue(levers[b].storage, os.time() + levers.timeToFightAgain * 60 * 60)
				addEvent(function()
					local adventurers, adventurer = Game.getSpectators(levers[b].centerRoom, false, false, 14, 14, 13, 13)
						for i = 1, #adventurers do
							adventurer = adventurers[i]
							if adventurer:isPlayer() then
								adventurer:teleportTo(levers.kickPos)
								adventurer:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
								adventurer:say("Time out! You were teleported out by strange forces.", TALKTYPE_MONSTER_SAY)
							end
						end
				end, 60 * levers.timeToDefeatBoss * 1000)
			end
		end
	end
	return true
end

for a = 1, #levers do
	lever:position(levers[a].leverPos)
end
lever:register()
