local waterIds = { 622, 629, 630, 631, 632, 633, 634, 4597, 4598, 4599, 4600, 4601, 4602, 4609, 4610, 4611, 4612, 4613, 4614, 7236, 9582, 13988, 13989, 21414 }
local dirtywaterIds = { 12558, 12559, 12560, 12561, 12562, 12563 }

local elementals = {
	chances = {
		{ from = 0, to = 500, itemId = 3026 }, -- white pearl
		{ from = 501, to = 801, itemId = 3029 }, -- small sapphire
		{ from = 802, to = 1002, itemId = 3032 }, -- small emerald
		{ from = 1003, to = 1053, itemId = 281 }, -- giant shimmering pearl (green)
		{ from = 1054, to = 1104, itemId = 282 }, -- giant shimmering pearl (brown)
		{ from = 1105, to = 1115, itemId = 9303 }, -- leviathan's amulet
	},
}

local useWorms = true
local storage = GlobalStorage.TwistedWatersWorldChange
local ShimmerCaught = Storage.Quest.U9_1.TwistedWatersWorldChange.ShimmerCaught

local function refreeIceHole(position)
	local iceHole = Tile(position):getItemById(7237)
	if iceHole then
		iceHole:transform(7200)
	end
end

local fishing = Action()

function fishing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains(waterIds, target.itemid) and not table.contains(dirtywaterIds, target.itemid) then
		return false
	end

	if getGlobalStorage(storage.ShimmerFishbonesCaught) > 1000 and table.contains(dirtywaterIds, target.itemid) then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	if math.random(100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_fishingTwistedWaters) - 10) * 0.597, 10), 50) and table.contains(dirtywaterIds, target.itemid) then
		if useWorms and not player:removeItem("worm", 1) then
			return true
		end

		if player:getItemCount(3492) > 0 then
			player:addSkillTries(SKILL_fishingTwistedWaters, 1, true)
		end

		if getGlobalStorage(storage.ShimmerFishbonesCaught) >= 1000 then
			setGlobalStorage(storage.TwistedWatersActive, 0)
			setGlobalStorage(storage.Status, 3)
			logger.info("Twisted Waters World Change Ended. Lake Equivocolao will revert after next Server Save")
		end

		if table.contains(dirtywaterIds, target.itemid) then
			local rareChance = math.random(100)
			local container = Container(item:getParent().uid)
			if fromPosition.x == CONTAINER_POSITION and container:getEmptySlots() ~= 0 then
				if rareChance == 1 then
					if player:getStorageValue(ShimmerCaught) < os.time() then
						container:addItem(12557, 1)
						player:sendTextMessage(MESSAGE_FAILURE, "A Shimmer Swimmer! It is said that this rare creature only appears once each day in the murkiest of waters!")
						player:addAchievementProgress("Biodegradable", 50)
						player:setStorageValue(ShimmerCaught, os.time() + 20 * 60 * 60) -- 20 hours
						setGlobalStorage(storage.ShimmerFishbonesCaught, getGlobalStorage(storage.ShimmerFishbonesCaught) + 1)
					end
				else
					container:addItem(3111, 1)
					setGlobalStorage(storage.ShimmerFishbonesCaught, getGlobalStorage(storage.ShimmerFishbonesCaught) + 1)
				end
			else
				if rareChance == 1 then
					if player:getStorageValue(ShimmerCaught) < os.time() then
						container:addItem(12557, 1)
						player:sendTextMessage(MESSAGE_FAILURE, "A Shimmer Swimmer! It is said that this rare creature only appears once each day in the murkiest of waters!")
						player:addAchievementProgress("Biodegradable", 50)
						player:setStorageValue(ShimmerCaught, os.time() + 20 * 60 * 60) -- 20 hours
						setGlobalStorage(storage.ShimmerFishbonesCaught, getGlobalStorage(storage.ShimmerFishbonesCaught) + 1)
					end
				else
					player:addItem(3111, 1, true, CONST_SLOT_WHEREEVER)
					setGlobalStorage(storage.ShimmerFishbonesCaught, getGlobalStorage(storage.ShimmerFishbonesCaught) + 1)
				end
			end
		end
		return true
	end

	local targetId = target.itemid
	if targetId == 9582 then -- water elemental
		local owner = target:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
		if owner ~= 0 and owner ~= player.uid then
			player:sendTextMessage(MESSAGE_FAILURE, "You are not the owner.")
			return true
		end

		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
		target:transform(target.itemid + 1)

		local chance = math.random(10000)
		for i = 1, #elementals.chances do
			local randomItem = elementals.chances[i]
			if chance >= randomItem.from and chance <= randomItem.to then
				player:addItem(randomItem.itemId, 1)
			end
			if chance > 1115 then
				player:say("There was just rubbish in it.", TALKTYPE_MONSTER_SAY)
				return true
			end
		end
	end

	if targetId ~= 7236 then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
	end

	if targetId == 622 or targetId == 13989 then
		return true
	end

	if useWorms and targetId == 21414 and player:removeItem("worm", 1) then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) == 2 then
			if math.random(100) >= 97 then
				player:addItem(21402, 1)
				player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 3)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "With a giant splash, you heave an enormous fish out of the water.")
				return true
			end
		elseif math.random(100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
			player:addItem(3578, 1)
		end
	end

	if player:getItemCount(3492) > 0 then
		player:addSkillTries(SKILL_FISHING, 1, true)
	end

	if math.random(100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
		if useWorms and not player:removeItem("worm", 1) then
			return true
		end

		if targetId == 13988 then
			target:transform(targetId + 1)
			target:decay()

			if math.random(100) >= 97 then
				player:addItem(13992, 1)
				return true
			end
		elseif targetId == 7236 then
			target:transform(7237)
			local position = target:getPosition()
			addEvent(refreeIceHole, 1000 * 60 * 15, position)
			local rareChance = math.random(100)
			if rareChance == 1 then
				player:addItem(7158, 1)
				return true
			elseif rareChance <= 4 then
				player:addItem(3580, 1)
				return true
			elseif rareChance <= 10 then
				player:addItem(7159, 1)
				return true
			end
		end
		player:addItem(3578, 1)
	end
	return true
end

fishing:id(3483)
fishing:allowFarUse(true)
fishing:register()
