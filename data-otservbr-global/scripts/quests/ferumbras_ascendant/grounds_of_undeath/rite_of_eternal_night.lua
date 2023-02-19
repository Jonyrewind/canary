local fount = {
	[1] = {transformid = 22166, pos = Position(33421, 32383, 12), revert = 2094},
	[2] = {transformid = 22167, pos = Position(33422, 32383, 12), revert = 2095},
	[3] = {transformid = 22168, pos = Position(33421, 32384, 12), revert = 2096},
	[4] = {transformid = 22169, pos = Position(33422, 32384, 12), revert = 2097}
}

local range = {
	from = Position(33420, 32382, 12),
	to = Position(33423, 32385, 12)
}

local ferumbrasAscendantrite = Action()
function ferumbrasAscendantrite.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FerumbrasAscension.Rite) >= 1 or player:getStorageValue(Storage.FerumbrasAscension.Statue) < 1 then
		return false
	end
	if item.itemid == 22160 then
		if player:getPosition():isInRange(range.from, range.to) then
			player:setStorageValue(Storage.FerumbrasAscension.Rite, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'As you recite the Rite of Eternal Night fresh blood begins to pour into the dried well. The gate to the lower tunnels is open.')
			for i = 1, #fount do
			local fount = fount[i]
			local founts = Tile(fount.pos):getItemById(fount.revert)
			local fountsreverse = Tile(fount.pos):getItemById(fount.transformid)
				if founts then
					founts:transform(fount.transformid)
					founts:setActionId(53805)
				end
			end
			toPosition:sendMagicEffect(CONST_ME_BATS)
			item:remove(1)
			addEvent(function()
				for i = 1, #fount do
					local fount = fount[i]
					local founts = Tile(fount.pos):getItemById(fount.transformid)
					founts:transform(fount.revert)
					founts:setActionId(53805)
				end
			end, 15 * 1000)
			return true
		end
	return true
	end
end

ferumbrasAscendantrite:id(22160)
ferumbrasAscendantrite:register()