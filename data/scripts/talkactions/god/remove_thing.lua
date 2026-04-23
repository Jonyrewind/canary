local removeThing = TalkAction("/r")

local AOE_DEFAULT_RADIUS = 2

local function removeTileItems(tile, player)
	if not tile then
		return
	end

	local ground = tile:getGround()
	local items = tile:getItems()
	if not items then
		return
	end

	for i = #items, 1, -1 do
		local item = items[i]
		if item and item ~= ground then
			item:remove()
		end
	end
end

local function removeItemsInArea(centerPosition, radius, player)
	for x = -radius, radius do
		for y = -radius, radius do
			local pos = Position(centerPosition.x + x, centerPosition.y + y, centerPosition.z)
			removeTileItems(Tile(pos), player)
		end
	end
end

function removeThing.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local cleanParam = param:trim()
	local lowerParam = cleanParam:lower()

	if lowerParam:sub(1, 3) == "aoe" then
		local radius = tonumber(cleanParam:match("^aoe%s+(%d+)$")) or AOE_DEFAULT_RADIUS
		if radius < 0 then
			radius = AOE_DEFAULT_RADIUS
		end

		removeItemsInArea(player:getPosition(), radius, player)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	end

	local tile = Tile(position)
	if not tile then
		player:sendCancelMessage("Object not found.")
		return true
	end

	local thing = tile:getTopVisibleThing(player)
	if not thing then
		player:sendCancelMessage("Thing not found.")
		return true
	end

	if thing:isCreature() then
		thing:remove()
	elseif thing:isItem() then
		if thing == tile:getGround() then
			player:sendCancelMessage("You may not remove a ground tile.")
			return true
		end
		if cleanParam == "all" then
			removeTileItems(tile, player)
		else
			thing:remove(tonumber(cleanParam) or -1)
		end
	end

	position:sendMagicEffect(CONST_ME_MAGIC_RED)
	return true
end

removeThing:separator(" ")
removeThing:groupType("god")
removeThing:register()
