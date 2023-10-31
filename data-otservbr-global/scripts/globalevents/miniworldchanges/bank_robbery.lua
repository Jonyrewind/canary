local storage = GlobalStorage.BankRobberyMiniWorldChange

local towns = {
	[1] = {
		city = "Ab'dendriel",
		storage = 1,
		boss = "Elvira Hammerthrust",
		pos = Position(32531, 31926, 11),
		fromPosition = { x = 32528, y = 31923, z = 11 },
		toPosition = { x = 32532, y = 31928, z = 11 },
		monsters = {
			{ name = "Dwarf Guard" },
			{ name = "Dwarf Guard" },
			{ name = "Dwarf Soldier" },
			{ name = "Dwarf Soldier" },
		},
	},
	[2] = {
		city = "Carlin",
		storage = 2,
		boss = "Robby the Reckless",
		pos = Position(32200, 31808, 9),
		fromPosition = { x = 32194, y = 31806, z = 9 },
		toPosition = { x = 32204, y = 31814, z = 9 },
		monsters = {
			{ name = "Poacher" },
			{ name = "Poacher" },
			{ name = "Poacher" },
			{ name = "Poacher" },
		},
	},
	[3] = {
		city = "Thais",
		storage = 3,
		boss = "Jesse the Wicked",
		pos = Position(32371, 32220, 11),
		fromPosition = { x = 32366, y = 32218, z = 11 },
		toPosition = { x = 32380, y = 32228, z = 11 },
		monsters = {
			{ name = "Smuggler" },
			{ name = "Smuggler" },
			{ name = "Smuggler" },
			{ name = "Smuggler" },
		},
	},
	[4] = {
		city = "Venore",
		storage = 4,
		boss = "Mornenion",
		pos = Position(33086, 32158, 7),
		fromPosition = { x = 33081, y = 32156, z = 7 },
		toPosition = { x = 33091, y = 32164, z = 7 },
		monsters = {
			{ name = "Elf" },
			{ name = "Elf" },
			{ name = "Elf Scout" },
			{ name = "Elf Scout" },
		},
	},
}

local BankRobberyMiniWorldChangeEnabled = true
local BankRobberyMiniWorldChangeChance = 15

local BankRobberyMiniWorldChange = GlobalEvent("BankRobberyMiniWorldChange")

function BankRobberyMiniWorldChange.onThink(interval)
	if math.random(100) <= BankRobberyMiniWorldChangeChance or getGlobalStorage(storage.Activated) > 0 then
		return false
	end

	local town = math.random(1, 4)

	logger.info("[MiniWorldChange] Bank Robbery Mini World Change active in " .. towns[town].city)
	setGlobalStorage(storage.Activated, 1) -- only once per ss
	setGlobalStorage(storage.Town, towns[town].storage)
	local boss = Game.createMonster(towns[town].boss, towns[town].pos, true, true)
	for _, monster in pairs(towns[town].monsters) do
		::retry::
		local monster = Game.createMonster(monster.name, Position.getFreePosition(towns[town].fromPosition, towns[town].toPosition))
		if not monster then
			goto retry
		end
	end
	return true
end

BankRobberyMiniWorldChange:interval(math.random(60, 120) * 60 * 1000)
BankRobberyMiniWorldChange:register()
