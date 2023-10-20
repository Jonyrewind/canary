--[[local setting = {
	["Monday"] = Position(31254, 32604, 9), --Minos
	["Tuesday"] = Position(33459, 31715, 9), --Catacombs
	["Wednesday"] = Position(31061, 32605, 9), --Golem
	["Thursday"] = Position(33459, 31715, 9), --Catacombs
	["Friday"] = Position(33459, 31715, 9), --Catacombs
	["Saturday"] = Position(31254, 32604, 9), --Minos
	["Sunday"] = Position(33459, 31715, 9), --Catacombs
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
votingOramond:register()
]]--

local config = {
	{ name = "Golem", position = Position(31062, 32612, 9) },
	{ name = "Catacombs", position = Position(33460, 31722, 9) },
	{ name = "Minos", position = Position(31255, 32611, 9) },
}

local votingOramond = MoveEvent()

function votingOramond.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local window = ModalWindow({
		title = "Dungeons",
		message = "Where would you like to Hunt?",
	})
	for i, info in pairs(config) do
		window:addChoice(string.format("%s", info.name), function(player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
			fromPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
			player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
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

votingOramond:type("stepin")
votingOramond:aid(42628)
votingOramond:register()