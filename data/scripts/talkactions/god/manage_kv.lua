local getBossCooldown = TalkAction("/getboss")

function getBossCooldown.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local target
	local split = param:split(",")
	local name = split[1]
	local bossNameOrId = split[2]
	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: /getboss <player name>, <bossName>")
		return true
	else
		target = Player(name)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, " " .. name .. "'s Boss Cooldown for " .. bossNameOrId .. " = " .. target:getBossCooldown(bossNameOrId) .. " ")
end

getBossCooldown:separator(" ")
getBossCooldown:groupType("god")
getBossCooldown:register()

function Player.setBossCooldownTalkaction(self, param)
	if not HasValidTalkActionParams(self, param, "/setboss <bossName>, <value>, <player name>") then
		return true
	end

	local split = param:split(",")
	local value = 0
	local bossName = split[1]
	if split[2] then
		value = tonumber(split[2])
	end

	if split[2] then
		local targetPlayer = Player(string.trim(split[3]))
		if not targetPlayer then
			self:sendCancelMessage("Player not found.")
			return true
		else
			local message = "" .. split[3] .. "'s Boss Cooldown for" .. bossName .. " was set to " .. value .. "."
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			targetPlayer:setBossCooldown(bossName, value)
			--			targetPlayer:setBossCooldown(bossName, 0)
			targetPlayer:save()
			return true
		end
	end
	return true
end

local setBossCooldown = TalkAction("/setboss")

function setBossCooldown.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)
	return player:setBossCooldownTalkaction(param)
end
setBossCooldown:separator(" ")
setBossCooldown:groupType("god")
setBossCooldown:register()

local storageGet = TalkAction("/getkv")

function storageGet.onSay(player, words, param)
	local value = kv.get(param)
	if value then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. param .. "]: " .. PrettyString(value))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Key " .. param .. " not found.")
	end
end

storageGet:separator(" ")
storageGet:groupType("god")
storageGet:register()

local talkaction = TalkAction("/setkv")

local function splitFirst(str, delimiter)
	local start, finish = string.find(str, delimiter)
	if start == nil then
		return str, nil
	end
	local firstPart = string.sub(str, 1, start - 1)
	local secondPart = string.sub(str, finish + 1)
	return firstPart, secondPart
end

function talkaction.onSay(player, words, param)
	local key, value = splitFirst(param, " ")
	value = load("return " .. value)()
	kv.set(key, value)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. key .. "] = " .. PrettyString(value))
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()
