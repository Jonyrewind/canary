local carpets = {
	{ clickPos = { x = 32953, y = 31466, z = 6 }, id = 8706, transformto = 8707 },
	{ clickPos = { x = 32953, y = 31465, z = 6 }, id = 8708, transformto = 8709 },
}

local carpet = Action()

function carpet.onUse(player, item, fromPosition, itemEx, toPosition)
	for b = 1, #carpets do
		local carpets = carpets[b]
		if item:getPosition() == Position(carpets.clickPos) then
			if item.itemid == carpets.id then
				item:transform(carpets.transformto)
				addEvent(function(pos)
					local tile = Tile(pos)
					if tile then
						local item = tile:getItemById(carpets.transformto)
						if item then
							item:transform(carpets.id)
						end
					end
				end, 5 * 1000, item:getPosition())
				return true
			end
		end
	end
end

for a = 1, #carpets do
	carpet:position(carpets[a].clickPos)
end
carpet:register()
