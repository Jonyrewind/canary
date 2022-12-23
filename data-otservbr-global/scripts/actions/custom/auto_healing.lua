local lastUpdate = "29/08/2019"

local MESSAGE_ERROR_NO_HEALTH_SPELLS = "You do not have any healing spells."
local MESSAGE_ERROR_NO_MANA_ITEMS = "Your vocation is not allowed to use mana recover items."
local MESSAGE_ERROR_NO_HEALTH_ITEMS = "Your vocation is not allowed to use health recover items."

local spellTable = {
    Knight = {
        ["exura ico"] = {id = 3},
        ["exura gran ico"] = {id = 7}
    },
    Paladin = {
        ["exura"] = {id = 1},
        ["exura san"] = {id = 4},
        ["exura gran san"] = {id = 6},
    },
    Sorcerer = {
        ["exura"] = {id = 1},
        ["exura gran"] = {id = 2},   
        ["exura vita"] = {id = 5},
    },   
    Druid = {
        ["exura"] = {id = 1},
        ["exura gran"] = {id = 2},   
        ["exura vita"] = {id = 5},
        ["exura gran mas res"] = {id = 8},
        ["exura sio"] = {id = 9}
    }
}

local itemTable = {
    Health = {
        Knight = {
            [1] = {itemid = 7618, itemname = "health potion"},
            [2] = {itemid = 7588, itemname= "strong health potion"},
            [3] = {itemid = 7591, itemname= "great health potion"},
            [4] = {itemid = 8473, itemname= "ultimate health potion"},
            [5] = {itemid = 26031, itemname= "supreme health potion"},
        },
        Paladin = {
            [1] = {itemid = 7618, itemname = "health potion"},
            [2] = {itemid = 7588, itemname= "strong health potion"},
            [3] = {itemid = 8472, itemname= "great spirit potion"},
            [4] = {itemid = 26030, itemname= "ultimate spirit potion"}
        },
        Mage = {
            [1] = {itemid = 7618, itemname = "health potion"},
        },
        None = {
            [1] = {itemid = 7618, itemname = "health potion"},
        }
    },
    Mana = {
        Mage = {
            [1] = {itemid = 7620, itemname = "mana potion"},
            [2] = {itemid = 7589, itemname= "strong mana potion"},
            [3] = {itemid = 7590, itemname= "great mana potion"},
            [4] = {itemid = 26029, itemname= "ultimate mana potion"}
        },
        Paladin = {
            [1] = {itemid = 7620, itemname = "mana potion"},
            [2] = {itemid = 7590, itemname= "great mana potion"},
        },
        Knight = {
            [1] = {itemid = 7620, itemname = "mana potion"},
        },
        None = {
            [1] = {itemid = 7620, itemname = "mana potion"},
        }
    }
}

local options = {
    [1] = {name = 'Health', action =
		function(playerId)
			local player = Player(playerId)
			if not player then
				return true
			end
			
			player:sendModalautoHealOptions()
		end
	},
    [2] = {name = 'Mana', action =
		function(playerId)
			local player = Player(playerId)
			if not player then
				return true
			end
			
			player:sendModalautoHealOptions()
		end
	},
    [3] = {name = 'About', action =
		function(playerId)
			local player = Player(playerId)
			if not player then
				return true
			end

			player:sendModalautoHealOptions()
		end
	},
}

local healthOptions = {
    [1] = {name = 'Spell List', action =
		function(playerId)
			local player = Player(playerid)
			if not player then
				return true
			end
			
			player:sendModalautoHealSpells()
		end
	},
    [2] = {name = 'Item List', action =
		function(playerId)
			local player = Player(playerid)
			if not player then
				return true
			end
			
			player:sendModalautoHealOptions()
		end
	},
}

local j = {}
local choiceCount
 
function Player:sendModalautoHealSpells()
	local cid = self:getId()
	local vNumber = self:getVocation():getId()
    local spellName = ""
	local window = ModalWindow {
		title = 'Healing Spells',
		message = "Choose a spell to heal yourself",
	}

	for index, choice in ipairs(healthOptions) do
		local name = string.format("%s", choice.name)
		local choice = window:addChoice(name)

        choice.index = index
	end	

	window:addButton('Next',
		function(button, choice)
			local self  = Player(cid)
			if self and choice then
				local tmpChoice = healthOptions[choice.index]
				if tmpChoice then
					tmpChoice.action(cid)
				end
			end
		end
	)
	window:addButton('Close')
	window:setDefaultEnterButton('Next')
	window:setDefaultEscapeButton('Close')
	window:sendToPlayer(self)
end

function Player:sendModalautoHealOptions()
	local cid = self:getId()
	local vNumber = self:getVocation():getId()
    local spellName = ""
	local window = ModalWindow {
		title = 'Choose a method',
		message = "Choose the way that you want to be healed",
	}

	for index, choice in ipairs(healthOptions) do
		local name = string.format("%s", choice.name)
		local choice = window:addChoice(name)

        choice.index = index
	end	

	window:addButton('Next',
		function(button, choice)
			local self  = Player(cid)
			if self and choice then
				local tmpChoice = healthOptions[choice.index]
				if tmpChoice then
					tmpChoice.action(cid)
				end
			end
		end
	)
	window:addButton('Close')
	window:setDefaultEnterButton('Next')
	window:setDefaultEscapeButton('Close')
	window:sendToPlayer(self)
end

function Player:sendMainModalautohealing()
	local cid = self:getId()
	local vNumber = self:getVocation():getId()
    local spellName = ""
	local window = ModalWindow {
		title = '-- Auto Heal --',
		message = "Choose an option below:",
	}
	
	for index, choice in ipairs(options) do
		local name = string.format("%s", choice.name)
		local choice = window:addChoice(name)

        choice.index = index
	end
	
	window:addButton('Next',
		function(button, choice)
			local self  = Player(cid)
			if self and choice then
				local tmpChoice = options[choice.index]
				if tmpChoice then
					tmpChoice.action(cid)
				end
			end
		end
	)
	
	window:addButton('Close')
	window:setDefaultEnterButton('Next')
	window:setDefaultEscapeButton('Close')
	window:sendToPlayer(self)
end

local autohealing = TalkAction("!heal")

function autohealing.onSay(player, words, param, type)

--if player:getStorageValue(Storage.Exaust.tempo) >= os.time() then
	--player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You are exausted.')
	--return true
    --end
	
	if player:getStorageValue(9817997) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot use this item during the event.")
		return true
	end
	
if player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) and not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot use this item while in battle.")
		return true
	end
	
---	player:setStorageValue(Storage.Exaust.tempo, os.time())
	player:sendMainModalautohealing()

    return true
end


autohealing:separator(" ")
autohealing:register()