taskOptions = {
	bonusReward = 65001, -- storage bonus reward
	bonusRate = 2, -- rate bonus reward
	taskBoardPositions = {
        {x = 32378, y = 32239, z = 7},
        {x = 1052, y = 799, z = 15},
    },
	selectLanguage = 2, -- options: 1 = pt_br or 2 = english
	uniqueTask = false, -- do one task at a time
	uniqueTaskStorage = 65002
}

task_pt_br = {
	exitButton = "Fechar",
	confirmButton = "Validar",
	cancelButton = "Anular",
	returnButton = "Voltar",
	title = "Quadro De Missões",
	missionError = "Missão esta em andamento ou ela já foi concluida.",
	uniqueMissionError = "Você só pode fazer uma missão por vez.",
	missionErrorTwo = "Você concluiu a missão",
	missionErrorTwoo = "\nAqui estão suas recompensas:",
	choiceText = "- Experiência: ",
	messageAcceptedText = "Você aceitou essa missão!",
	messageDetailsText = "Detalhes da missão:",
	choiceMonsterName = "Missão: ",
	choiceMonsterRace = "Raças: ",
	choiceMonsterKill = "Abates: ",
	choiceEveryDay = "Repetição: Todos os dias",
	choiceRepeatable = "Repetição: Sempre",
	choiceOnce = "Repetição: Apenas uma vez",
	choiceReward = "Recompensas:",
	messageAlreadyCompleteTask = "Você já concluiu essa missão.",
	choiceCancelTask = "Você cancelou essa missão",
	choiceCancelTaskError = "Você não pode cancelar essa missão, porque ela já foi concluída ou não foi iniciada.",
	choiceBoardText = "Escolha uma missão e use os botões abaixo:",
	choiceRewardOnHold = "Resgatar Prêmio",
	choiceDailyConclued = "Diária Concluída",
	choiceConclued = "Concluída",
	messageTaskBoardError = "O quadro de missões esta muito longe ou esse não é o quadro de missões correto.",
	messageCompleteTask = "Você terminou essa missão! \nRetorne para o quadro de missões e pegue sua recompensa.",
}

taskConfiguration = {
{name = "Minotaur", missionId = 11, color = 40, total = 800, type = "daily", storage = 190000, storagecount = 190001,
	rewards = {
	{22118, 50},
	{"exp", 1000000},
	},
	races = {
		"Minotaur",
		"Minotaur Archer",
		"Minotaur Mage",
	},
},

{name = "Dragon", missionId = 12, color = 40, total = 1000, type = "daily", storage = 190002, storagecount = 190003,
	rewards = {
	{22118, 100},
	{"exp", 1500000},
	},
	races = {
		"Dragon",
		"Dragon Lord",
		"Dragon Hatchling",
		"Dragon Lord Hatchling",
	},
},

{name = "Dragon Lord", missionId = 13, color = 40, total = 700, type = "daily", storage = 190004, storagecount = 190005,
	rewards = {
	{22118, 100},
	{"exp", 1500000},
	},
	races = {
		"Dragon Lord",
		"Dragon Lord Hatchling",
	},
},

{name = "Rotworm", missionId = 14, color = 40, total = 150, type = "daily", storage = 190006, storagecount = 190007, 
	rewards = {
	{22118, 20},
	{"exp", 100000},
	},
	races = {
		"Rotworm",
		"Carrion Worm",
		"White Pale",
		"Rotworm Queen",
	},
},

{name = "Amazon", missionId = 15, color = 40, total = 200, type = "daily", storage = 190008, storagecount = 190009, 
	rewards = { 
	{"exp", 1500000},
	{22118, 25},
	},
	races = {
		"Amazon",
		"Valkyrie",
		"Xenia",
	},
},

{name = "Valkyrie", missionId = 16, color = 40, total = 300, type = "daily", storage = 190010, storagecount = 190011, 
	rewards = { 
	{"exp", 1500000},
	{22118, 30},
	},
	races = {
		"Amazon",
		"Valkyrie",
		"Xenia",
	},
},

{name = "Frazzlemaws", missionId = 17, color = 40, total = 1500, type = "daily", storage = 190012, storagecount = 190013, 
	rewards = { 
	{"exp", 1500000},
	{22118, 150},
	},
	races = {
		"Frazzlemaw",
		"Guzzlemaw",
	},
},

{name = "Enfeebled Silencer", missionId = 18, color = 40, total = 1000, type = "daily", storage = 190014, storagecount = 190015, 
	rewards = { 
	{"exp", 1500000},
	{22118, 100},
	},
	races = {
		"Enfeebled Silencer",
	},
},

{name = "Deepling", missionId = 19, color = 40, total = 1000, type = "daily", storage = 190016, storagecount = 190017, 
	rewards = { 
	{22118, 150},
	{"exp", 10000000},
	},
	races = {
		"Deepling Guard",
		"Deepling Warrior",
		"Deepling Scout",
	},
},

{name = "Silencer", missionId = 20, color = 40, total = 1000, type = "daily", storage = 190018, storagecount = 190019, 
	rewards = { 
	{"exp", 1500000},
	{22118, 100},
	},
	races = {
		"Silencer",
	},
},

{name = "Lower Banuta", missionId = 21, color = 40, total = 1500, type = "daily", storage = 190020, storagecount = 190021, 
	rewards = { 
	{"exp", 1500000},
	{22118, 150},
	},
	races = {
		"Medusa",
		"Hydra",
		"Serpent Spawn",
	},
},

{name = "Demon", missionId = 22, color = 40, total = 4000, type = "repeatable", storage = 190022, storagecount = 190023, 
	rewards = { 
	{"exp", 1500000},
	{22118, 500},
	},
	races = {
		"Demon",
	},
},

{name = "Hero", missionId = 23, color = 40, total = 800, type = "daily", storage = 190024, storagecount = 190025, 
	rewards = { 
	{"exp", 1500000},
	{22118, 100},
	},
	races = {
		"Hero",
	},
},

{name = "Spectres", missionId = 24, color = 40, total = 1000, type = "daily", storage = 190026, storagecount = 190027, 
	rewards = { 
	{"exp", 30000000},
	{22118, 150},
	},
	races = {
		"Burster Spectre",
		"Gazer Spectre",
		"Ripper Spectre",
	},
},

{name = "Soul War Rotten Wasteland", missionId = 25, color = 40, total = 2500, type = "daily", storage = 190028, storagecount = 190029, 
	rewards = { 
	{"exp", 300000000},
	{22118, 400},
	},
	races = {
		"Branchy Crawler",
		"Mould Phantom",
		"Rotten Golem",
	},
},

{name = "Soul War Furious Crater", missionId = 26, color = 40, total = 2500, type = "daily", storage = 190030, storagecount = 190031, 
	rewards = { 
	{"exp", 300000000},
	{22118, 400},
	},
	races = {
		 "Cloak of Terror",
		 "Vibrant Phantom",
		 "Courage Leech",
	},
},

{name = "Soul War Ebb and Flow", missionId = 27, color = 40, total = 2500, type = "daily", storage = 190032, storagecount = 190033, 
	rewards = { 
	{"exp", 300000000},
	{22118, 400},
	},
	races = {
		 "Bony Sea Devil",
		 "Capricious Phantom",
		 "Hazardous Phantom",
		 "Turbulent Elemental",
	},
},

{name = "Soul War Mirrored Nightmare", missionId = 28, color = 40, total = 2500, type = "daily", storage = 190034, storagecount = 190035, 
	rewards = { 
	{"exp", 300000000},
	{22118, 400},
	},
	races = {
		"Many Faces",
		"Distorted Phantom",
		"Druid's Apparition",
		"Knight's Apparition",
		"Paladin's Apparition",
		"Sorcerer's Apparition",
	},
},

{name = "Soul War Claustrophobic Inferno", missionId = 29, color = 40, total = 2500, type = "daily", storage = 190036, storagecount = 190037, 
	rewards = { 
	{"exp", 300000000},
	{22118, 400},
	},
	races = {
		 "Brachiodemon",
		 "Infernal Demon",
		 "Infernal Phantom",
	},
},

{name = "Juggernaut", missionId = 30, color = 40, total = 2000, type = "repeatable", storage = 190038, storagecount = 190039, 
	rewards = { 
	{22118, 500},
	},
	races = {
		"Juggernaut",
	},
},

{name = "Asura", missionId = 31, color = 40, total = 2000, type = "daily", storage = 190040, storagecount = 190041, 
	rewards = { 
	{"exp", 20000000},
	{22118, 300},
	},
	races = {
		"Dawnfire Asura",
		"Midnight Asura",
		"Frost Flower Asura",
		"True Dawnfire Asura",
		"True Midnight Asura",
	},
},

{name = "Girtablilu Warrior", missionId = 32, color = 40, total = 3000, type = "repeatable", storage = 190042, storagecount = 190043, 
	rewards = {   
	{"exp", 100000000},
	{22118, 300},
	},
	races = {
		"Girtablilu Warrior",
	},
},

{name = "Dark Carnisylvan", missionId = 33, color = 40, total = 3000, type = "repeatable", storage = 190044, storagecount = 190045, 
	rewards = { 
	{"exp", 100000000},
	{22118, 300},
	},
	races = {
		"Dark Carnisylvan",
	},
},

{name = "Oramond Dungeon", missionId = 34, color = 40, total = 3000, type = "daily", storage = 190046, storagecount = 190047, 
	rewards = { 
	{"exp", 100000000},
	{22118, 350},
	},
	races = {
		"Demon",
		"Destroyer",
		"Hellspawn",
		"Dark Torturer",
		"Hellhound",
		"Juggernaut",
	},
},

{name = "Nightmare", missionId = 35, color = 40, total = 500, type = "daily", storage = 190048, storagecount = 190049, 
	rewards = { 
	{"exp", 10000000},
	{22118, 150},
	},
	races = {
		"Nightmare",
		"Nightmare Scion",
	},
},

{name = "Lion Sanctum", missionId = 36, color = 40, total = 1000, type = "daily", storage = 190050, storagecount = 190051, 
	rewards = { 
	{"exp", 10000000},
	{22118, 200},
	},
	races = {
		"White Lion",
		"Werelion",
		"Werelioness",
	},
},

{name = "Falcons", missionId = 37, color = 40, total = 1000, type = "daily", storage = 190052, storagecount = 190053, 
	rewards = { 
	{"exp", 10000000},
	{22118, 150},
	},
	races = {
		"Falcon Paladin",
		"Falcon Knight",
	},
},

{name = "Cobras", missionId = 38, color = 40, total = 1500, type = "daily", storage = 190054, storagecount = 190055, 
	rewards = { 
	{"exp", 10000000},
	{22118, 150},
	},
	races = {
		"Cobra Scout",
		"Cobra Assassin",
		"Cobra Vizier",
	},
},

{name = "Drakens", missionId = 39, color = 40, total = 1500, type = "daily", storage = 190056, storagecount = 190057, 
	rewards = { 
	{"exp", 10000000},
	{22118, 150},
	},
	races = {
		"Draken Abomination",
		"Draken Elite",
		"Draken Spellweaver",
		"Draken Warmaster",
	},
},

{name = "High Class Lizards", missionId = 40, color = 40, total = 2000, type = "daily", storage = 190058, storagecount = 190059, 
	rewards = { 
	{"exp", 10000000},
	{22118, 600},
	},
	races = {
		"Eternal Guardian",
		"Lizard Chosen",
		"Lizard Dragon Priest",
		"Lizard High Guard",
		"Lizard Legionnaire",
		"Lizard Magistratus",
		"Lizard Noble",
		"Lizard Zaogun",
	},
},

{name = "Yielothax", missionId = 41, color = 40, total = 1000, type = "daily", storage = 190060, storagecount = 190061, 
	rewards = { 
	{"exp", 1000000},
	{22118, 100},
	},
	races = {
		"Yielothax",
	},
},

{name = "Grim Reapers", missionId = 42, color = 40, total = 1200, type = "daily", storage = 190062, storagecount = 190063, 
	rewards = { 
	{"exp", 1000000},
	{22118, 200},
	},
	races = {
		"Grim Reaper",
	},
},

{name = "Exotics", missionId = 43, color = 40, total = 800, type = "daily", storage = 190064, storagecount = 190065, 
	rewards = { 
	{"exp", 100000},
	{22118, 80},
	},
	races = {
		"Exotic Bat",
		"Exotic Cave Spider",
	},
},

{name = "Bashmu", missionId = 44, color = 40, total = 1300, type = "daily", storage = 190066, storagecount = 190067, 
	rewards = { 
	{"exp", 1000000},
	{22118, 200},
	},
	races = {
		"Bashmu",
		"Juvenile Bashmu",
	},
},

{name = "Girtablilu", missionId = 45, color = 40, total = 1500, type = "daily", storage = 190068, storagecount = 190070, 
	rewards = { 
	{"exp", 1000000},
	{22118, 300},
	},
	races = {
		"Girtablilu Warrior",
		"Venerable Girtablilu",
	},
},

{name = "Rotten Blood Jaded Roots", missionId = 46, color = 40, total = 2000, type = "daily", storage = 190071, storagecount = 190072, 
	rewards = { 
	{"exp", 10000000},
	{22118, 400},
	},
	races = {
		"Sopping Corpus",
		"Oozing Corpus",
		"Mycobiontic Beetle",
		"Bloated Man-Maggot",
	},
},

{name = "Rotten Blood Darklight Core", missionId = 47, color = 40, total = 2000, type = "daily", storage = 190073, storagecount = 190074, 
	rewards = { 
	{"exp", 10000000},
	{22118, 400},
	},
	races = {
		"Walking Pillar",
		"Darklight Matter",
		"Darklight Source",
		"Darklight Striker",
	},
},

{name = "Rotten Blood Gloom Pillars", missionId = 48, color = 40, total = 2000, type = "daily", storage = 190075, storagecount = 190076, 
	rewards = { 
	{"exp", 10000000},
	{22118, 400},
	},
	races = {
		"Darklight Emitter",
		"Darklight Construct",
		"Wandering Pillar",
		"Converter",
	},
},

{name = "Rotten Blood Putrefactory", missionId = 49, color = 40, total = 2000, type = "daily", storage = 190077, storagecount = 190078, 
	rewards = { 
	{"exp", 10000000},
	{22118, 400},
	},
	races = {
		"Oozing Carcass",
		"Sopping Carcass",
		"Rotten Man-Maggot",
		"Meandering Mushroom",
	},
},

{name = "Gnomprona Monster Graveyard", missionId = 50, color = 40, total = 2000, type = "daily", storage = 190079, storagecount = 190080, 
	rewards = { 
	{"exp", 10000000},
	{22118, 400},
	},
	races = {
		"Sulphider",
		"Sulphur Spouter",
		"Nighthunter",
		"Stalking Stalk",
		"Undertaker",
	},
},

{name = "Gnomprona Crystal Enigma", missionId = 51, color = 40, total = 2000, type = "daily", storage = 190081, storagecount = 190082, 
	rewards = { 
	{"exp", 10000000},
	{22118, 400},
	},
	races = {
		"Headpecker",
		"Mantosaurus",
		"Mercurial Menace",
		"Noxious Ripptor",
		"Shrieking Cry-Stal",
	},
},

{name = "Gnomprona Sparkling Pools", missionId = 52, color = 40, total = 2000, type = "daily", storage = 190083, storagecount = 190084, 
	rewards = { 
	{"exp", 10000000},
	{22118, 400},
	},
	races = {
		"Emerald Tortoise",
		"Gore Horn",
		"Gorerilla",
		"Hulking Prehemoth",
		"Sabretooth",
	},
},
}

squareWaitTime = 5000
taskQuestLog = 65000 -- A storage so you get the quest log
dailyTaskWaitTime = 20 * 60 * 60 

function Player.getCustomActiveTasksName(self)
local player = self
	if not player then
		return false
	end
local tasks = {}
	for i, data in pairs(taskConfiguration) do
		if player:getStorageValue(data.storagecount) ~= -1 then
		tasks[#tasks + 1] = data.name
		end
	end
	return #tasks > 0 and tasks or false
end


function getTaskByStorage(storage)
	for i, data in pairs(taskConfiguration) do
		if data.storage == tonumber(storage) then
			return data
		end
	end
	return false
end

function getTaskByMonsterName(name)
	for i, data in pairs(taskConfiguration) do
		for _, dataList in ipairs(data.races) do
		if dataList:lower() == name:lower() then
			return data
		end
		end
	end
	return false
end

function Player.startTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if player:getStorageValue(taskQuestLog) == -1 then
		player:setStorageValue(taskQuestLog, 1)
	end
	player:setStorageValue(storage, player:getStorageValue(storage) + 1)
	player:setStorageValue(data.storagecount, 0)
	return true
end

function Player.canStartCustomTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if data.type == "daily" then
		return os.time() >= player:getStorageValue(storage)
	elseif data.type == "once" then
		return player:getStorageValue(storage) == -1
	elseif data.type[1] == "repeatable" and data.type[2] ~= -1 then
		return player:getStorageValue(storage) < (data.type[2] - 1)
	else
		return true
	end
end

function Player.endTask(self, storage, prematurely)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
end
	if prematurely then
		if data.type == "daily" then
			player:setStorageValue(storage, -1)
		else
			player:setStorageValue(storage, player:getStorageValue(storage) - 1)
	end
	else
		if data.type == "daily" then
			player:setStorageValue(storage, os.time() + dailyTaskWaitTime)
		end
	end
	player:setStorageValue(data.storagecount, -1)
	return true
end

function Player.hasStartedTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	return player:getStorageValue(data.storagecount) ~= -1
end


function Player.getTaskKills(self, storage)
local player = self
	if not player then
		return false
	end
	return player:getStorageValue(storage)
end

function Player.addTaskKill(self, storage, count)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	local kills = player:getTaskKills(data.storagecount)
	if kills >= data.total then
		return false
	end
	if kills + count >= data.total then
		if taskOptions.selectLanguage == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, task_pt_br.messageCompleteTask)
		else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] You have finished this task! To claim your rewards, return to the quest board and claim your reward.")
		player:updateTrackedMissionByMissionId(data.missionId)
		end
		player:setStorageValue(data.storagecount, data.total)
		return player:updateTrackedMissionByMissionId(data.missionId)
	end
--		player:say('Task: '..data.name ..' - ['.. kills + count .. '/'.. data.total ..']', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(data.storagecount, kills + count)
		return player:updateTrackedMissionByMissionId(data.missionId)
end