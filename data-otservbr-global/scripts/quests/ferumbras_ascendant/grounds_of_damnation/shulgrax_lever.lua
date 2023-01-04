local config = {
	centerRoom = Position(33485, 32786, 13),
	BossPosition = Position(33485, 32786, 13),
	playerPositions = {
		Position(33434, 32785, 13),
		Position(33434, 32786, 13),
		Position(33434, 32787, 13),
		Position(33434, 32788, 13),
		Position(33434, 32789, 13)
	},
	newPosition = Position(33485, 32790, 13)
}

local ferumbrasAscendantShulgraxLever = Action()
function ferumbrasAscendantShulgraxLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(33434, 32785, 13) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Shulgrax.")
				return true
			end
		end
		Game.createMonster("Shulgrax", config.BossPosition, true, true)
		for y = 32785, 32789 do
			local playerTile = Tile(Position(33434, y, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		Game.setStorageValue(GlobalStorage.FerumbrasAscendant.ShulgraxTimer, 1)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33473, 32776, 13), Position(33496, 32798, 13), Position(33319, 32318, 13), GlobalStorage.FerumbrasAscendant.ShulgraxTimer)
		item:transform(8912)
	elseif item.itemid == 8912 then
		item:transform(8911)
	end
	return true
end

ferumbrasAscendantShulgraxLever:uid(1028)
ferumbrasAscendantShulgraxLever:register()


local shulgraxLever = MoveEvent()

function shulgraxLever.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.FlowerPuzzleTimer) >= 1 then
		player:teleportTo(Position(33436, 32800, 13))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(Storage.FerumbrasAscension.Puzzle, 1)
	else
		local pos = position
		pos.y = pos.y + 1
		player:teleportTo(pos)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have not proven your worth. There is no escape for you here.")
		item:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

shulgraxLever:type("stepin")
shulgraxLever:aid(34301)
shulgraxLever:register()