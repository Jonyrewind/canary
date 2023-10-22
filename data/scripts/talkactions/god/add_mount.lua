--[[
	/addmount playername, mount
	/removemount playername, mount
]]

local printConsole = true

local addMount = TalkAction("/addmount")

function addMount.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	local name = split[1]

	local target = Player(name)
	if target then
		local mount = tonumber(split[2])
		target:addMount(mount)
		target:sendTextMessage(MESSAGE_ADMINISTRADOR, "" .. player:getName() .. " has added a new mount for you.")
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "You have sucessfull added mount " .. mount .. " to the player " .. target:getName() .. ".")
		if printConsole then
			logger.info("[addMount.onSay] - Player: {} has added mount: {} to the player: {}", player:getName(), mount, target:getName())
		end
		return true
	end
	player:sendCancelMessage("Player not found.")
	return true
end

addMount:separator(" ")
addMount:groupType("god")
addMount:register()

local removeMount = TalkAction("/removemount")

function removeMount.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	local name = split[1]

	local target = Player(name)
	if target then
		local mount = tonumber(split[2])
		target:removeMount(mount)
		target:sendTextMessage(MESSAGE_ADMINISTRADOR, "" .. player:getName() .. " has removed a mount from you.")
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "You have sucessfull removed mount " .. mount .. " from the player " .. target:getName() .. ".")
		if printConsole then
			logger.info("[removeMount.onSay] - Player: {} has removed mount: {} from the player: {}", player:getName(), mount, target:getName())
		end
		return true
	end
	player:sendCancelMessage("Player not found.")
	return true
end

removeMount:separator(" ")
removeMount:groupType("god")
removeMount:register()
