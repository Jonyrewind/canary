local function removeBosst(fromArea1, fromArea2, bossName)
	for x = fromArea1.x, fromArea2.x do
		for y = fromArea1.y, fromArea2.y do
			for z = fromArea1.z, fromArea2.z do
				if getTopCreature({ x = x, y = y, z = z, stackpos = 255 }).uid > 0 then
					if isMonster(getTopCreature({ x = x, y = y, z = z, stackpos = 255 }).uid) then
						if string.lower(getCreatureName(getTopCreature({ x = x, y = y, z = z, stackpos = 255 }).uid)) == bossName then
							doRemoveCreature(getTopCreature({ x = x, y = y, z = z, stackpos = 255 }).uid)
						end
					end
				end
			end
		end
	end
	return true
end

local function teleportAllPlayersFromAreat(fromArea1, fromArea2, toPos)
	for x = fromArea1.x, fromArea2.x do
		for y = fromArea1.y, fromArea2.y do
			for z = fromArea1.z, fromArea2.z do
				local tile = Tile(Position({ x = x, y = y, z = z }))
				if tile then
					local player = tile:getTopCreature()
					if player and player:isPlayer() then
						player:teleportTo(toPos)
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		end
	end
	return true
end

local function PrepareEnter()
	removeBosst({ x = 33691, y = 31816, z = 7 }, { x = 33713, y = 31840, z = 7 }, "bullwark")
	teleportAllPlayersFromAreat({ x = 33697, y = 31840, z = 7 }, { x = 33710, y = 31851, z = 7 }, { x = 33699, y = 31835, z = 7 })
	Game.createMonster("Bullwark", { x = 33697, y = 31820, z = 7 })
end

local oramondBullwarkLever = Action()
function oramondBullwarkLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8913 then
		if getGlobalStorageValue(15561) >= os.time() then
			doPlayerSendTextMessage(player, 19, "You need to wait 15 minutes to use again.")
			return true
		end

		local specs, spec = Game.getSpectators({ x = 33702, y = 31828, z = 7 }, false, false, 13, 13, 13, 13)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
				return true
			end
			spec:remove()
		end
		setGlobalStorageValue(15561, os.time() + 5 * 60)
		player:say("Everyone in this place will be teleported into Glooth Fairy's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
		addEvent(PrepareEnter, 15 * 1000)
	end

	item:transform(item.itemid == 8913 and 8914 or 8913)
	return true
end

oramondBullwarkLever:uid(1112)
oramondBullwarkLever:register()
