--[[local setting = {
	["Monday"] = Position(31254, 32604, 9), --Minos
	["Tuesday"] = Position(33459, 31715, 9), --Catacombs
	["Wednesday"]  = Position(31061, 32605, 9), --Golem
	["Thursday"] = Position(33459, 31715, 9), --Catacombs
	["Friday"]  = Position(33459, 31715, 9), --Catacombs
	["Saturday"] = Position(31254, 32604, 9), --Minos
	["Sunday"] = Position(33459, 31715, 9) --Catacombs
}

local votingOramond = MoveEvent()

function votingOramond.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = setting[os.date("%A")]
	if teleport then
		player:teleportTo(teleport)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
	end
	return true
end

votingOramond:type("stepin")
votingOramond:aid(42628)
votingOramond:register()]]--

local config = {
	[1] = {name = 'Minos', action =
		function(playerId)
			local player = Player(playerId)
			if not player then
				return true
			end

			player:teleportTo(Position(31254, 32604, 9))
			player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
		end
	},
	[2] = {name = 'Catacombs', action =
		function(playerId)
			local player = Player(playerId)
			if not player then
				return true
			end

			player:teleportTo(Position(33459, 31715, 9))
			player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
		end
	},
	[3] = {name = 'Golem', action =
		function(playerId)
			local player = Player(playerId)
			if not player then
				return true
			end

			player:teleportTo(Position(31061, 32605, 9))
			player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
		end
	},
}

local votingOramond = MoveEvent()

function votingOramond.onStepIn(creature, item, position, fromPosition)
	creature:teleportTo(fromPosition)
	local self = creature:getPlayer()
	if not self then
		return true
	end

	local cid = self:getId()
	local window = ModalWindow {
		title = "Teleport",
		message = "Where would you like to be teleported to?",
	}

	for index, choice in ipairs(config) do
		local name = string.format("%s", choice.name)
		local choice = window:addChoice(name)

        choice.index = index
	end

	window:addButton('Close')
	window:addButton('Choose',
		function(button, choice)
			local self = Player(cid)
			if self and choice then
				local tmpChoice = config[choice.index]
				if tmpChoice then
					tmpChoice.action(cid)
				end
			end
		end
	)

    window:setDefaultEnterButton('Close')
    window:setDefaultEscapeButton('Choose')
	window:sendToPlayer(self)
	return true
end

votingOramond:type("stepin")
votingOramond:aid(42628)
votingOramond:register()