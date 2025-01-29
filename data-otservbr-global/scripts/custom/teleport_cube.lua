local config = {
	{ name = "Hunts", position = Position(1055, 799, 15) },
	{ name = "Temple", position = Position(32369, 32241, 7) },
	{ name = "NPC Room", position = Position(994, 1030, 6) },
	{ name = "Trainer", position = Position(1116, 1094, 7) },
    { name = "Citys" },
    { name = "Bosses" },
}

local citys = {
    { name="Thais", position = Position(32369, 32241, 7) },
    { name="Edron", position = Position(33217, 31814, 8) },
    { name="Carlin", position = Position(32360, 31782, 7) },
    { name="Venore", position = Position(32957, 32076, 7) },
    { name="Ab'Dendriel", position = Position(32732, 31634, 7) },
    { name="Port Hope", position = Position(32594, 32745, 7) },
    { name="Yalahar", position = Position(32787, 31276, 7) },
    { name="Kazordoon", position = Position(32649, 31925, 11) },
    { name="Darashia", position = Position(33213, 32454, 1) },
    { name="Rathleton", position = Position(33594, 31899, 6) },
    { name="Svargrond", position = Position(32212, 31132, 7) },
    { name="Farmine", position = Position(33023, 31521, 11) },
    { name="Ankrahmun", position = Position(33194, 32853, 8) },
    { name="Liberty Bay", position = Position(32317, 32826, 7) },
    { name="Roshamuul", position = Position(33513, 32363, 6) },
    { name="Gray beach", position = Position(33447, 31323, 9) },
    { name="Issavi", position = Position(33921, 31477, 5) },
    { name="Krailos", position = Position(33655, 31666, 8) },
}

local bosses = {
	{ name = "Count Vlarkorth", position = Position(33456, 31408, 13) },
	{ name = "Lord Azaram", position = Position(33423, 31497, 13) },
	{ name = "Earl Osam", position = Position(33517, 31440, 13) },
	{ name = "Sir Baeloc-Nictros", position = Position(33426, 31408, 13) },
	{ name = "Duke Krule", position = Position(33456, 31497, 13) },
	{ name = "KingZelos", position = Position(33489, 31546, 13) },
	{ name = "Gaffir", position = Position(33393, 32674, 4) },
	{ name = "Custodian", position = Position(33378, 32825, 8) },
	{ name = "Guard Captain Quaid", position = Position(33397, 32658, 3) },
	{ name = "Scarlett Etzel", position = Position(33395, 32662, 6) },
	{ name = "Lady Tenebris", position = Position(32902, 31628, 14) },
	{ name = "Lloyd", position = Position(32759, 32873, 14) },
	{ name = "Thorn Knight", position = Position(32657, 32882, 14) },
	{ name = "Dragonking Zyrtarch", position = Position(33391, 31183, 10) },
	{ name = "Frozen Horror", position = Position(32302, 31093, 14) },
	{ name = "Time Guardian", position = Position(33010, 31665, 14) },
	{ name = "Last Lore Keeper", position = Position(32019, 32849, 14) },
	{ name = "Brain Head", position = Position(31973, 32325, 10) },
	{ name = "Unaz the Mean", position = Position(33566, 31477, 8) },
	{ name = "Irgix the Flimsy", position = Position(33492, 31400, 8) },
	{ name = "Vok the Freakish", position = Position(33509, 31452, 9) },
	{ name = "Dread Maiden", position = Position(33744, 31506, 14) },
	{ name = "Unwelcome", position = Position(33741, 31537, 14) },
	{ name = "Fear Feaster", position = Position(33739, 31471, 14) },
	{ name = "Pale Worm", position = Position(33776, 31504, 14) },
	{ name = "Goshnar Malice", position = Position(33684, 31599, 14) },
	{ name = "Goshnar Hatred", position = Position(33778, 31601, 14) },
	{ name = "Goshnar Spite", position = Position(33779, 31634, 14) },
	{ name = "Goshnar Cruelty", position = Position(33859, 31854, 6) },
	{ name = "Goshnar Greed", position = Position(33781, 31665, 14) },
	{ name = "Goshnar Megalomania", position = Position(33681, 31634, 14) },
	{ name = "Lion Sanctum", position = Position(33123, 32236, 12) },
	{ name = "Shadowpelt", position = Position(33403, 32097, 9) },
	{ name = "Black Vixen", position = Position(33442, 32052, 9) },
	{ name = "Sharpclaw", position = Position(33128, 31972, 9) },
	{ name = "Darkfang", position = Position(33055, 31911, 9) },
	{ name = "Bloodback", position = Position(33167, 31978, 8) },
	{ name = "Timira", position = Position(33804, 32702, 8) },
	{ name = "The Primal Menace", position = Position(33553, 32752, 14) },
	{ name = "Magma Bubble", position = Position(33669, 32931, 15) },
	{ name = "Kroazur", position = Position(33619, 32305, 9) },
	{ name = "Drume", position = Position(32458, 32507, 6) },
	{ name = "Urmahlullu", position = Position(33920, 31623, 8) },
	{ name = "Bragrumol", position = Position(33772, 31595, 8) },
	{ name = "Xogixath - Not Save!", position = Position(33788, 31476, 7) },
	{ name = "Mozradek", position = Position(33955, 31465, 7) },
	{ name = "Vengoth Castle Bosses", position = Position(32952, 31482, 6) },
	{ name = "Omruc", position = Position(33206, 32979, 14) },
	{ name = "Thalas", position = Position(33365, 32805, 14) },
	{ name = "Dipthrah", position = Position(33072, 32605, 15) },
	{ name = "Mahrdis", position = Position(33182, 32755, 15) },
	{ name = "Vashresamun", position = Position(33180, 32663, 15) },
	{ name = "Morguthis", position = Position(33264, 32671, 13) },
	{ name = "Rahemos", position = Position(33118, 32810, 15) },
	{ name = "Ashmunrah", position = Position(33191, 32906, 11) },
	{ name = "Brokul", position = Position(33523, 31462, 15) },
	{ name = "Ravenous Hunger", position = Position(33121, 31951, 15) },
	{ name = "The Souldespoiler", position = Position(33109, 31887, 15) },
	{ name = "The Unarmored Voidborn", position = Position(33178, 31840, 15) },
	{ name = "The Sandking", position = Position(33458, 32269, 10) },
	{ name = "The False God", position = Position(33181, 31894, 15) },
	{ name = "Essence of Malice", position = Position(33090, 31963, 15) },
	{ name = "The Source of Corruption", position = Position(33072, 31867, 15) },
	{ name = "Lokathmor", position = Position(32719, 32746, 10) },
	{ name = "Mazzinor", position = Position(32719, 32770, 10) },
	{ name = "Ghulosh", position = Position(32745, 32770, 10) },
	{ name = "Gorzindel", position = Position(32745, 32746, 10) },
	{ name = "Scourge of Oblivion", position = Position(32673, 32738, 11) },
	{ name = "Lisa", position = Position(33558, 31912, 8) },
	{ name = "Gloth Fairy", position = Position(33653, 31937, 9) },
	{ name = "Bullwark", position = Position(33700, 31855, 7) },
	{ name = "Heart of Destruction", position = Position(32213, 31376, 14) },
	{ name = "Oberon", position = Position(33326, 31331, 9) },
}

function citysModalWindow(player)
	local window = ModalWindow{
		title = "Teleport Modal",
		message = "Citys",
	}
	for i, info in pairs(citys) do
		window:addChoice(string.format("%s", info.name), function(player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. info.name)
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end)
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
end

function bossesModalWindow(player)
	local window = ModalWindow{
		title = "Teleport Modal",
		message = "Bosses",
	}
	for i, info in pairs(bosses) do
		window:addChoice(string.format("%s", info.name), function(player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. info.name)
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end)
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
end

local teleportCube = Action()

function teleportCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local window = ModalWindow({
		title = "Teleport Modal",
		message = "Locations",
	})
	for i, info in pairs(config) do
		window:addChoice(string.format("%s", info.name), function(player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			if info.name == "Citys" then
				citysModalWindow(player)
				return true
			end
			if info.name == "Bosses" then
				bossesModalWindow(player)
				return true
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. info.name)
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end)
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
	return true
end

teleportCube:id(31633)
teleportCube:register()
