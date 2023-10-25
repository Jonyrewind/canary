local storage = getGlobalStorage(GlobalStorage.BoredMiniWorldChange)

local spawn = {
	position = { fromPosition = Position(32722, 31970, 7), toPosition = Position(32753, 31989, 7) },
}

local monsters = {}

function Game.createRandom(position)
	local tile = Tile(position)
	if not tile or Tile(position):getItemById(595) or Tile(position):getItemById(593) then
		return false
	end

	local ground = tile:getGround()
	if not ground or ground:hasProperty(CONST_PROP_BLOCKSOLID) or tile:getTopCreature() then
		return false
	end
	local monsterName = monsters[math.random(#monsters)]
	local monster = Game.createMonster(monsterName, position)
	if monster then
		monster:setSpawnPosition()
		monster:remove()
	end
	return true
end

local BoredMiniWorldChangeEnabled = true
local BoredMiniWorldChangeChance = 100

local BoredMiniWorldChange = GlobalEvent("BoredMiniWorldChange")

function BoredMiniWorldChange.onStartup()
	if BoredMiniWorldChangeEnabled and storage <= 0 then
		if math.random(100) <= BoredMiniWorldChangeChance then
			logger.info("[WorldChanges] Bored Mini World Change active")
			setGlobalStorage(storage, 2) -- incase of an server crash
			setGlobalStorageValue(storage, 1)
			table.insert(monsters, "giant spider wyda")
			table.insert(monsters, "giant spider wyda")
			for x = spawn.position.fromPosition.x, spawn.position.toPosition.x do
				for y = spawn.position.fromPosition.y, spawn.position.toPosition.y do
					if Game.createRandom(Position(x, y, 7)) then
						return
					end
				end
			end
		end
	elseif storage == 2 then
		logger.info("[WorldChanges] Bored Mini World Change active")
		setGlobalStorageValue(storage, 1)
		table.insert(monsters, "giant spider wyda")
		table.insert(monsters, "giant spider wyda")
		for x = spawn.position.fromPosition.x, spawn.position.toPosition.x do
			for y = spawn.position.fromPosition.y, spawn.position.toPosition.y do
				if Game.createRandom(Position(x, y, 7)) then
					return
				end
			end
		end
	end
	return true
end

BoredMiniWorldChange:register()