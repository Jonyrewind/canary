local configDemonYala = {
	{ name = "Demons Left", position = Position(32863, 31062, 9) },
	{ name = "Demons Right", position = Position(32884, 31042, 9) },
}

local customDemonYala = MoveEvent()

function customDemonYala.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local window = ModalWindow({
		title = "Banuta",
		message = "Which Floor would you like to Hunt?",
	})
	for i, info in pairs(configDemonYala) do
		window:addChoice(string.format("%s", info.name), function(player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
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

customDemonYala:type("stepin")
customDemonYala:aid(4121)
customDemonYala:register()

local configBanuta = {
	{ name = "Ground Floor", position = Position(32893, 32631, 11) },
	{ name = "Floor -1", position = Position(32807, 32639, 11) },
	{ name = "Floor -2", position = Position(32783, 32565, 13) },
	{ name = "Floor -3", position = Position(32784, 32612, 14) },
	{ name = "Floor -4", position = Position(32732, 32645, 15) },
}

local customBanuta = MoveEvent()

function customBanuta.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local window = ModalWindow({
		title = "Banuta",
		message = "Which Floor would you like to Hunt?",
	})
	for i, info in pairs(configBanuta) do
		window:addChoice(string.format("%s", info.name), function(player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
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

customBanuta:type("stepin")
customBanuta:aid(4120)
customBanuta:register()
