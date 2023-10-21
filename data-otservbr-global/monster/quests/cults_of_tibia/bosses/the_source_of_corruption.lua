local mType = Game.createMonsterType("The Source of Corruption")
local monster = {}

monster.description = "The Source Of Corruption"
monster.experience = 0
monster.outfit = {
	lookType = 979,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1500,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "undead"
monster.corpse = 23567
monster.speed = 60
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 200 },
	{ name = "platinum coin", chance = 95000, maxCount = 30 },
	{ name = "piece of hell steel", chance = 95000, maxCount = 5 },
	{ name = "magic sulphur", chance = 95000, maxCount = 3 },
	{ name = "gold token", chance = 95000, maxCount = 4 },
	{ name = "silver token", chance = 95000, maxCount = 3 },
	{ name = "onyx chip", chance = 95000 },
	{ name = "ancient stone", chance = 100000 },
	{ name = "solid rage", chance = 72000, maxCount = 11 },
	{ name = "great mana potion", chance = 60000, maxCount = 5 },
	{ name = "ultimate health potion", chance = 60000, maxCount = 5 },
	{ name = "crystallized anger", chance = 52000, maxCount = 10 },
	{ name = "great spirit potion", chance = 44000, maxCount = 8 },
	{ name = "small ruby", chance = 32000, maxCount = 20 },
	{ name = "gold ingot", chance = 32000 },
	{ name = "yellow gem", chance = 32000 },
	{ name = "small topaz", chance = 24000, maxCount = 20 },
	{ name = "small amethyst", chance = 20000, maxCount = 20 },
	{ id = 3039, chance = 20000 }, -- red gem
	{ id = 282, chance = 20000 }, -- giant shimmering pearl (brown)
	{ name = "sapphire hammer", chance = 20000 },
	{ name = "blue gem", chance = 20000 },
	{ name = "violet gem", chance = 16000 },
	{ name = "gemmed figurine", chance = 16000 },
	{ name = "small emerald", chance = 12000, maxCount = 23 },
	{ name = "white piece of cloth", chance = 12000, maxCount = 4 },
	{ name = "opal", chance = 12000, maxCount = 2 },
	{ name = "green gem", chance = 12000 },
	{ name = "silkweaver bow", chance = 12000 },
	{ name = "small sapphire", chance = 8000, maxCount = 20 },
	{ id = 5526, chance = 8000 }, -- demon dust
	{ name = "enchanted chicken wing", chance = 8000 },
	{ id = 23533, chance = 8000 }, -- ring of red plasma
	{ name = "violet crystal shard", chance = 4000, maxCount = 7 },
	{ name = "devil helmet", chance = 4000 },
	{ name = "yalahari figurine", chance = 4000 },
	{ name = "crude umbral slayer", chance = 4000 },
	{ name = "strong health potion", chance = 3000, maxCount = 2 },
	{ name = "great health potion", chance = 3000, maxCount = 3 },
	{ name = "skull staff", chance = 2800 },
	{ name = "heavy mace", chance = 2800 },
	{ name = "demonwing axe", chance = 2400 },
	{ name = "nightmare blade", chance = 2000 },
	{ name = "umbral slayer", chance = 1500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1500 },
	{ name = "source of corruption wave", interval = 2000, chance = 15, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 15 },
	{ type = COMBAT_MANADRAIN, percent = 15 },
	{ type = COMBAT_DROWNDAMAGE, percent = 15 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
