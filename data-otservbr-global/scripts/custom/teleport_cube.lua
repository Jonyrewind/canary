local supremeCube = Action()

local config = {
    price = 500,
    storage = 9007,
    cooldown = 0, -- seconds

    towns = {
		{ name = "Ab'Dendriel", teleport = Position(32732, 31634, 7) },
        { name = "Ankrahmun", teleport = Position(33194, 32853, 8) },
        { name = "Candia", teleport = Position(33338, 32125, 7) },
        { name = "Carlin", teleport = Position(32360, 31782, 7) },
        { name = "Darashia", teleport = Position(33213, 32454, 1) },
        { name = "Edron", teleport = Position(33217, 31814, 8) },
        { name = "Farmine", teleport = Position(33023, 31521, 11) },
        { name = "Feyrist", teleport = Position(33490, 32221, 7) },
        { name = "Forge", teleport = Position(31646, 32043, 8) },
        { name = "Gray Beach", teleport = Position(33447, 31323, 9) },
        { name = "Gnomprona", teleport = Position(33517, 32856, 14) },
        { name = "Issavi", teleport = Position(33921, 31477, 5) },
        { name = "Kazordoon", teleport = Position(32649, 31925, 11) },
        { name = "Krailos", teleport = Position(33657, 31665, 8) },
        { name = "Liberty Bay", teleport = Position(32317, 32826, 7) },
        { name = "Marapur", teleport = Position(33842, 32853, 7) },
        { name = "Moonfall", teleport = Position(33776, 32842, 7) },
        { name = "Port Hope", teleport = Position(32594, 32745, 7) },
        { name = "Rathleton", teleport = Position(33594, 31899, 6) },
        { name = "Roshamuul", teleport = Position(33513, 32363, 6) },
        { name = "Silvertides", teleport = Position(33776, 32842, 7) },
        { name = "Svargrond", teleport = Position(32212, 31132, 7) },
        { name = "Thais", teleport = Position(32369, 32241, 7) },
        { name = "Venore", teleport = Position(32957, 32076, 7) },
        { name = "Yalahar", teleport = Position(32787, 31276, 7) },
    },

    bosses = {
        { name = "Abyssador", teleport = Position(33016, 31902, 9) },
--        { name = "Adventurer Group", teleport = Position( , , ) },
        { name = "Ahau", teleport = Position(34040, 31724, 10) },
        { name = "Amenef the Burning", teleport = Position(33821, 31773, 10) },
        { name = "Anomaly", teleport = Position(32100, 31328, 12) },
        { name = "Ascending Ferumbras", teleport = Position(33268, 31474, 14) },
        { name = "Bakragore", teleport = Position(34108, 32052, 13) },
--        { name = "Bibby Bloodbath", teleport = Position( , , ) },
        { name = "Black Vixen", teleport = Position(33441, 32052, 9) },
--        { name = "Blight Mariner", teleport = Position( , , ) },
        { name = "Bloodback", teleport = Position(33168, 31978, 8) },
--        { name = "Bone Overlord", teleport = Position( , , ) },
        { name = "Bragrumol", teleport = Position(33774, 31596, 8) },
        { name = "Brain Head", teleport = Position(31972, 32324, 10) },
        { name = "Brokul", teleport = Position(33522, 31468, 15) },
--        { name = "Brother Chill", teleport = Position( , , ) },
--        { name = "Brother Freeze", teleport = Position( , , ) },
        { name = "Bullwark", teleport = Position(33703, 31856, 7) },
        { name = "Chagorz", teleport = Position(33071, 32370, 15) },
        { name = "Count Vlarkorth", teleport = Position(33458, 31406, 13) },
        { name = "Darkfang", teleport = Position(33054, 31911, 9) },
        { name = "Deathstrike", teleport = Position(33016, 31880, 9) },
--        { name = "Destabilized Ferumbras", teleport = Position( , , ) },
        { name = "Drume", teleport = Position(32459, 32507, 8) },
        { name = "Duke Krule", teleport = Position(3456, 31499, 13) },
        { name = "Earl Osam", teleport = Position(33519, 31439, 13) },
--        { name = "Ekatrix", teleport = Position( , , ) },
--        { name = "Eldritch Dragon Lord", teleport = Position( , , ) },
--        { name = "Enusat the Onyx Wing", teleport = Position( , , ) },
        { name = "Eradicator", teleport = Position(32219, 31375, 14) },
        { name = "Essence of Malice", teleport = Position(33090, 31963, 15) },
        { name = "Faceless Bane", teleport = Position(33619, 32520, 15) },
--        { name = "Ferumbras Mortal Shell", teleport = Position( , , ) },
        { name = "Gelidrazah the Frozen", teleport = Position(32278, 31368, 4) },
        { name = "Ghulosh", teleport = Position(32664, 32711, 13) },
        { name = "Glooth Fairy", teleport = Position(33653, 31939, 9) },
        { name = "Gnomevil", teleport = Position(33023, 31886, 9) },
        { name = "Gorzindel", teleport = Position(32662, 32738, 12) },
        { name = "Goshnar's Cruelty", teleport = Position(33858, 31851, 6) },
        { name = "Goshnar's Greed", teleport = Position(33782, 31663, 14) },
        { name = "Goshnar's Hatred", teleport = Position(33780, 31599, 14) },
        { name = "Goshnar's Malice", teleport = Position(33685, 31597, 14) },
        { name = "Goshnar's Megalomania", teleport = Position(33682, 31632, 14) },
--        { name = "Goshnar's Megalomania (Annihilation)", teleport = Position( , , ) },
--        { name = "Goshnar's Megalomania (Vulnerable)", teleport = Position( , , ) },
        { name = "Goshnar's Spite", teleport = Position(33781, 31632, 14) },
        { name = "Grand Master Oberon", teleport = Position(33363, 31341, 9) },
--        { name = "Herald of Fire", teleport = Position( , , ) },
--        { name = "Ice Horror", teleport = Position( , , ) },
        { name = "Ichgahal", teleport = Position(32971, 32336, 15) },
--        { name = "Inkwing", teleport = Position( , , ) },
        { name = "Irgix the Flimsy", teleport = Position(33490, 31395, 8) },
        { name = "Kalyassa", teleport = Position(33161, 31322, 5) },
        { name = "Katex Blood Tongue", teleport = Position(33116, 32250, 12) },
        { name = "King Zelos", teleport = Position(33491, 31546, 13) },
        { name = "Kroazur", teleport = Position(33620, 32306, 9) },
--        { name = "Kusuma", teleport = Position( , , ) },
        { name = "Lady Tenebris", teleport = Position(32903, 31630, 14) },
--        { name = "Last Planegazer", teleport = Position( , , ) },
        { name = "Lisa", teleport = Position(33557, 31914, 8) },
--        { name = "Lizard Gate Guardian", teleport = Position( , , ) },
        { name = "Lloyd", teleport = Position(32760, 32875, 14) },
        { name = "Lokathmor", teleport = Position(32462, 32652, 12) },
        { name = "Lord Azaram", teleport = Position(33425, 31499, 13) },
--        { name = "Lord Retro", teleport = Position( , , ) },
        { name = "Lord of the Elements", teleport = Position(33270, 31832, 10) },
        { name = "Magma Bubble", teleport = Position(33663, 32897, 14) },
        { name = "Mazoran", teleport = Position(33593, 32658, 14) },
        { name = "Mazzinor", teleport = Position(32617, 32527, 13) },
        { name = "Megasylvan Yselda", teleport = Position(32580, 32501, 12) },
        { name = "Melting Frozen Horror", teleport = Position(32303, 31096, 14) },
        { name = "Murcion", teleport = Position(32971, 32368, 15) },
        { name = "Neferi the Spy", teleport = Position(33888, 31479, 6) },
        { name = "Outburst", teleport = Position(32207, 31373, 14) },
        { name = "Plagirath", teleport = Position(33228, 31493, 13) },
        { name = "Ragiaz", teleport = Position(33451, 32357, 13) },
        { name = "Ratmiral Blackwhiskers", teleport = Position(33899, 31389, 15) },
        { name = "Ravenous Hunger", teleport = Position(33121, 31951, 15) },
        { name = "Razzagorn", teleport = Position(33381, 32453, 14) },
        { name = "Realityquake", teleport = Position(32228, 31358, 11) },
        { name = "Rupture", teleport = Position(32079, 31320, 13) },
        { name = "Scarlett Etzel", teleport = Position(33394, 32669, 6) },
        { name = "Shadowpelt", teleport = Position(33403, 32096, 9) },
        { name = "Sharpclaw", teleport = Position(33129, 31972, 9) },
        { name = "Shulgrax", teleport = Position(33436, 32800, 13) },
        { name = "Sir Baeloc", teleport = Position(33428, 31406, 13) },
--        { name = "Sir Leonard", teleport = Position( , , ) },
--        { name = "Sir Nictros", teleport = Position( , , ) },
        { name = "Sister Hetai", teleport = Position(33881, 31468, 9) },
        { name = "Soul of Dragonking Zyrtarch", teleport = Position(33410, 31169, 10) },
        { name = "Srezz Yellow Eyes", teleport = Position(33129, 32250, 12) },
        { name = "Sugar Daddy", teleport = Position(33399, 32202, 9) },
        { name = "Tarbaz", teleport = Position(33418, 32840, 11) },
        { name = "Tazhadur", teleport = Position(33236, 32275, 12) },
        { name = "Tentugly's Head", teleport = Position(33800, 31383, 7) },
--        { name = "Thaian", teleport = Position( , , ) },
        { name = "The Baron from Below", teleport = Position(33828, 32179, 14) },
        { name = "The Blazing Rose", teleport = Position(32855, 32738, 10) },
        { name = "The Brainstealer", teleport = Position(32537, 31120, 15) },
        { name = "The Count of the Core", teleport = Position(33776, 32197, 14) },
--        { name = "The Devourer of Secrets", teleport = Position( , , ) },
        { name = "The Diamond Blossom", teleport = Position(32857, 32767, 10) },
        { name = "The Dread Maiden", teleport = Position(33746, 31504, 14) },
        { name = "The Duke of the Depths", teleport = Position(33833, 32127, 14) },
        { name = "The Enraged Thorn Knight", teleport = Position(32678, 32886, 14) },
        { name = "The False God", teleport = Position(33180, 31894, 15) },
        { name = "The Fear Feaster", teleport = Position(33742, 31469, 14) },
        { name = "The First Dragon", teleport = Position(33597, 30993, 14) },
--        { name = "The Flaming Orchid", teleport = Position( , , ) },
--        { name = "The Gravedigger", teleport = Position( , , ) },
        { name = "The Last Lore Keeper", teleport = Position(32035, 32857, 14) },
        { name = "The Lily of Night", teleport = Position(32817, 32781, 11) },
--        { name = "The Mega Magmaoid", teleport = Position( , , ) },
--        { name = "The Moonlight Aster", teleport = Position( , , ) },
        { name = "The Nightmare Beast", teleport = Position(32212, 32075, 15) },
        { name = "The Pale Worm", teleport = Position(33781, 31502, 14) },
--        { name = "The Percht Queen", teleport = Position( , , ) },
        { name = "The Sandking", teleport = Position(33461, 32266, 10) },
--        { name = "The Scion of Havoc", teleport = Position( , , ) },
        { name = "The Scourge of Oblivion", teleport = Position(32674, 32738, 11) },
        { name = "The Souldespoiler", teleport = Position(33109, 31887, 15) },
        { name = "The Source of Corruption", teleport = Position(33072, 31868, 15) },
        { name = "The Time Guardian", teleport = Position(33011, 31668, 14) },
        { name = "The Unarmored Voidborn", teleport = Position(33179, 31840, 15) },
        { name = "The Unwelcome", teleport = Position(33745, 31535, 14) },
--        { name = "The Winter Bloom", teleport = Position( , , ) },
        { name = "Timira the Many-Headed", teleport = Position(33805, 32699, 8) },
--        { name = "Tropical Desolator", teleport = Position( , , ) },
        { name = "Unaz the Mean", teleport = Position(33568, 31477, 8) },
        { name = "Urmahlullu the Weakened", teleport = Position(33922, 31609, 8) },
        { name = "Utua Stone Sting", teleport = Position(33125, 32263, 12) },
        { name = "Vemiath", teleport = Position(33071, 32336, 15) },
--        { name = "Vladrukh", teleport = Position( , , ) },
        { name = "Vok the Freakish", teleport = Position(33509, 31451, 9) },
        { name = "World Devourer", teleport = Position(32213, 31381, 14) },
        { name = "Xogixath", teleport = Position(33792, 31478, 7) },
        { name = "Yirkas Blue Scales", teleport = Position(33121, 32237, 12) },
        { name = "Zamulosh", teleport = Position(33683, 32735, 11) },
        { name = "Zorvorax", teleport = Position(33004, 31594, 11) },
    },

    hunts = {
        { name = "Abandoned Sewers", teleport = Position(33526, 32023, 10) },
        { name = "Asura Palace", teleport = Position(32950, 32689, 7) },
        { name = "Asura Vaults", teleport = Position(32810, 32752, 9) },
        { name = "Barren Drift", teleport = Position(33887, 31785, 8) },
        { name = "Bounac", teleport = Position(32404, 32492, 7) },
        { name = "Bounacean Lion", teleport = Position(32471, 32491, 8) },
        { name = "Brain Grounds", teleport = Position(31915, 32359, 8) },
        { name = "Bulltaur Lair", teleport = Position(32875, 32375, 8) },
        { name = "Buried Cathedral", teleport = Position(32723, 32267, 8) },
        { name = "Claustrophobic Inferno", teleport = Position(34012, 31013, 9) },
        { name = "Cobra Bastion", teleport = Position(33393, 32676, 6) },
        { name = "Deep Desert", teleport = Position(33111, 32386, 7) },
        { name = "Ebb and Flow", teleport = Position(33893, 31019, 8) },
        { name = "Falcon Bastion", teleport = Position(33346, 31347, 7) },
        { name = "Forest of Life", teleport = Position(32401, 32495, 10) },
        { name = "Furious Crater", teleport = Position(33858, 31831, 3) },
        { name = "Great Pearl Fan Reef", teleport = Position(33746, 32780, 7) },
        { name = "Green Belt", teleport = Position(33938, 31548, 6) },
        { name = "Grotto of the Lost", teleport = Position(32191, 31412, 14) },
        { name = "Grounds of Damnation", teleport = Position(33417, 32684, 13) },
        { name = "Grounds of Deceit", teleport = Position(33643, 32688, 11) },
        { name = "Grounds of Despair", teleport = Position(33464, 32799, 8) },
        { name = "Grounds of Destruction", teleport = Position(33428, 32446, 13) },
        { name = "Grounds of Fire", teleport = Position(33614, 32631, 14) },
        { name = "Grounds of Plague", teleport = Position(33233, 31441, 11) },
        { name = "Grounds of Undeath", teleport = Position(33384, 32347, 11) },
        { name = "Halls of Ascension", teleport = Position(33294, 31454, 12) },
        { name = "Iksupan", teleport = Position(32727, 32879, 7) },
    }
}

local function showMainMenu(player)
    local window = ModalWindow({
        title = "Supreme Cube",
        message = "Select a category - Price: " .. config.price .. " gold.",
    })

    window:addChoice("Towns", function(p, btn, choice)
        if btn.name == "Select" then showTownsMenu(p) end
    end)

    window:addChoice("Bosses", function(p, btn, choice)
        if btn.name == "Select" then showBossesMenu(p) end
    end)

    window:addChoice("Hunts", function(p, btn, choice)
        if btn.name == "Select" then showHuntsMenu(p) end
    end)

    window:addChoice("House", function(p, btn, choice)
        if btn.name == "Select" then
            local house = p:getHouse()
            if house then
                p:teleportTo(house:getExitPosition(), true)
                p:removeMoneyBank(config.price)
                p:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to your house.")
                p:setStorageValue(config.storage, os.time() + config.cooldown)
            else
                p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have a house.")
                p:getPosition():sendMagicEffect(CONST_ME_POFF)
            end
        end
    end)

    window:addButton("Select")
    window:addButton("Close")
    window:setDefaultEnterButton(0)
    window:setDefaultEscapeButton(1)
    window:sendToPlayer(player)
end

-- Towns Submenu
local function showTownsMenu(player)
    local window = ModalWindow({ title = "Supreme Cube - Towns", message = "Choose your destination:" })
    for _, town in ipairs(config.towns) do
        window:addChoice(town.name, function(p, btn)
            if btn.name == "Select" then
                p:teleportTo(town.teleport, true)
                p:removeMoneyBank(config.price)
                p:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to " .. town.name .. "!")
                p:setStorageValue(config.storage, os.time() + config.cooldown)
            end
        end)
    end
    window:addButton("Select")
    window:addButton("Back", function(p) showMainMenu(p) end)
    window:addButton("Close")
    window:sendToPlayer(player)
end

-- Bosses Submenu
local function showBossesMenu(player)
    local window = ModalWindow({ title = "Supreme Cube - Bosses", message = "Choose your boss:" })
    for _, boss in ipairs(config.bosses) do
        window:addChoice(boss.name, function(p, btn)
            if btn.name == "Select" then
                p:teleportTo(boss.teleport, true)
                p:removeMoneyBank(config.price)
                p:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Teleported to " .. boss.name)
                p:setStorageValue(config.storage, os.time() + config.cooldown)
            end
        end)
    end
    window:addButton("Select")
    window:addButton("Back", function(p) showMainMenu(p) end)
    window:addButton("Close")
    window:sendToPlayer(player)
end

-- Hunts Submenu
local function showHuntsMenu(player)
    local window = ModalWindow({ title = "Supreme Cube - Hunts", message = "Choose your hunting place:" })
    for _, hunt in ipairs(config.hunts) do
        window:addChoice(hunt.name, function(p, btn)
            if btn.name == "Select" then
                p:teleportTo(hunt.teleport, true)
                p:removeMoneyBank(config.price)
                p:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Teleported to " .. hunt.name)
                p:setStorageValue(config.storage, os.time() + config.cooldown)
            end
        end)
    end
    window:addButton("Select")
    window:addButton("Back", function(p) showMainMenu(p) end)
    window:addButton("Close")
    window:sendToPlayer(player)
end

function supremeCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getTile():hasFlag(TILESTATE_PROTECTIONZONE) == false and (player:isPzLocked() or player:getCondition(CONDITION_INFIGHT)) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can't use this while in fight.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    if player:getMoney() + player:getBankBalance() < config.price then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have enough money.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    if player:getStorageValue(config.storage) > os.time() then
        local remaining = player:getStorageValue(config.storage) - os.time()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can use the Supreme Cube again in " .. remaining .. " seconds.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    showMainMenu(player)
    return true
end

supremeCube:id(31633)
supremeCube:register()
