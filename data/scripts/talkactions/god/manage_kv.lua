local get = TalkAction("/getkv")

function get.onSay(player, words, param)
	local key, playerName = string.splitFirst(param, ",")
	if not playerName then
		playerName = player:getName()
	end

	local targetPlayer = Player(playerName)
	if not targetPlayer then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not found.")
		return
	end

	local value = targetPlayer:kv():get(key)
	if value then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. key .. "] for " .. playerName .. ": " .. PrettyString(value))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Key " .. key .. " not found for " .. playerName .. ".")
	end
end

get:separator(" ")
get:groupType("god")
get:register()

local getAllKV = TalkAction("/getallkv")

function getAllKV.onSay(player, words, param)
	local playerName = param
	if not playerName or playerName == "" then
		playerName = player:getName()
	end

	local targetPlayer = Player(playerName)
	if not targetPlayer then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not found.")
		return
	end

	local kv = targetPlayer:kv()
	if not kv then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Error: target player does not have a KV instance.")
		return
	end

	local found = false
	local keys = kv:keys()
	if not keys then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No keys found.")
		return
	end

	table.sort(keys, function(a, b)
		return tostring(a):lower() < tostring(b):lower()
	end)

	for _, key in ipairs(keys) do
		local value = kv:get(key)
		if type(value) == "number" and value >= 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. key .. "] = " .. PrettyString(value))
			found = true
		end
	end

	if not found then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No KV found with value >= 0 for " .. playerName .. ".")
	end
end

getAllKV:separator(" ")
getAllKV:groupType("god")
getAllKV:register()

local set = TalkAction("/setkv")

function set.onSay(player, words, param)
	local key, rest = string.splitFirst(param, ",")
	if not key or not rest then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: /setkv <key>,<value>[,<playerName>]")
		return false
	end

	local value, playerName = string.splitFirst(rest, ",")
	local targetPlayer = player
	if playerName then
		local creature = Creature(playerName)
		if creature and creature:isPlayer() then
			targetPlayer = creature:getPlayer()
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player '" .. playerName .. "' not found or is not a valid player.")
			return false
		end
	end
	local success, parsedValue = pcall(load("return " .. value))
	if not success then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid value format.")
		return false
	end
	local kv = targetPlayer:kv()
	if not kv then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Error: target player does not have a KV instance.")
		return false
	end
	kv:set(key, parsedValue)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "KV: [" .. key .. "] = " .. PrettyString(parsedValue) .. " set for " .. targetPlayer:getName())
	return true
end

set:separator(" ")
set:groupType("god")
set:register()

local bossCooldown = TalkAction("/clearcooldown")

function bossCooldown.onSay(player, words, param)
	local boss, playerName = string.splitFirst(param, ",")
	if not playerName then
		playerName = player:getName()
	end
	local targetPlayer = Player(playerName)
	if not targetPlayer then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not found.")
		return
	end
	targetPlayer:setBossCooldown(boss, 0)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Boss cooldown for " .. playerName .. " cleared.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Boss cooldown for " .. boss .. " cleared.")
end

bossCooldown:separator(" ")
bossCooldown:groupType("god")
bossCooldown:register()

local clearBossCooldowns = TalkAction("/clearallcooldowns")

function clearBossCooldowns.onSay(player, words, param)
    local targetName = param:trim()
    if targetName == "" then
        targetName = player:getName()
    end

    local targetPlayer = Player(targetName)
    if not targetPlayer then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player '" .. targetName .. "' not found.")
        return false
    end

    local kv = targetPlayer:kv()
    local count = 0

    local allKeys = kv:keys()

    if allKeys then
        for _, key in pairs(allKeys) do
            if type(key) == "string" and key:find("^boss%.cooldown%.") then
                local currentValue = kv:get(key) or 0
                if currentValue ~= 0 then
                    kv:set(key, 0)
                    count = count + 1
                end
            end
        end
    end
    targetPlayer:sendBosstiaryCooldownTimer()

    if count == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            "No active boss cooldowns to clear for " .. targetPlayer:getName() .. ".")
    else
        local msg = string.format("Successfully cleared %d boss cooldown(s) for %s.",
            count, targetPlayer:getName())

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            "All your boss cooldowns have been cleared.")

        -- Log to console for admin tracking
        print(string.format("[ClearBossCD] %s cleared %d boss cooldown(s) for %s",
            player:getName(), count, targetPlayer:getName()))
    end

    return false
end

clearBossCooldowns:separator(" ")
clearBossCooldowns:groupType("god")
clearBossCooldowns:register()
