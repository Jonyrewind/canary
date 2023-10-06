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
	removeBosst({ x = 33535, y = 31863, z = 8 }, { x = 33600, y = 31910, z = 8 }, "lisa")
	teleportAllPlayersFromAreat({ x = 33549, y = 31902, z = 8 }, { x = 33566, y = 31908, z = 8 }, { x = 33556, y = 31895, z = 8 })
	Game.createMonster("Lisa", { x = 33561, y = 31876, z = 8 })
end

local oramondLisaLever = Action()
function oramondLisaLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8913 then
		if getGlobalStorageValue(15562) >= os.time() then
			doPlayerSendTextMessage(player, 19, "You need to wait 15 minutes to use again.")
			return true
		end

		local specs, spec = Game.getSpectators({ x = 33565, y = 31884, z = 8 }, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
				return true
			end
			spec:remove()
		end
		setGlobalStorageValue(15562, os.time() + 15 * 60)
		player:say("Everyone in this place will be teleported into Glooth Fairy's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
		addEvent(PrepareEnter, 60 * 1000)
	end

	item:transform(item.itemid == 8913 and 8914 or 8913)
	return true
end

oramondLisaLever:uid(1113)
oramondLisaLever:register()
