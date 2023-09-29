local config = {
	boss = {
		name = "Brokul",
		position = Position(33483, 31434, 15),
	},
	requiredLevel = 150,

	playerPositions = {
		{ pos = Position(33520, 31465, 15), teleport = Position(33483, 31445, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33521, 31465, 15), teleport = Position(33483, 31445, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33522, 31465, 15), teleport = Position(33483, 31445, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33523, 31465, 15), teleport = Position(33483, 31445, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33524, 31465, 15), teleport = Position(33483, 31445, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33471, 31430, 13),
		to = Position(33497, 31455, 13),
	},
	exit = Position(33522, 31468, 15),
	storage = Storage.Quest.U11_80.TheSecretLibrary.BrokulTimer,
}

local lever = BossLever(config)
lever:aid(34000)
lever:register()