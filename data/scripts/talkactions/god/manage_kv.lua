local get = TalkAction("/getkv")

function get.onSay(player, words, param)
	local value = kv.get(param)
	if value then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. param .. "]: " .. PrettyString(value))
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Key " .. param .. " not found.")
	end
end

get:separator(" ")
get:groupType("god")
get:register()

local set = TalkAction("/setkv")

function set.onSay(player, words, param)
	local key, value = string.splitFirst(param, ",") -- With a space some KV's are not able to be edited due to spaces within the key names, changed to a comma (,) to overcome this issue
	value = load("return " .. value)()
	kv.set(key, value)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "kv[" .. key .. "] = " .. PrettyString(value))
end

set:separator(" ")
set:groupType("god")
set:register()

local bossCooldown = TalkAction("/clearcooldown")

-- Load boss list from external file
local knownBosses = dofile(debug.getinfo(1).source:match("@?(.*/)") .. "bosses_list.lua")

function bossCooldown.onSay(player, words, param)
    local playerName, boss = string.splitFirst(param, ",")

    -- Ensure playerName is provided
    if not playerName or playerName == "" then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: /clearcooldown <playerName>, <bossName (optional)>")
        return
    end

    local targetPlayer = Player(playerName)
    if not targetPlayer then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not found.")
        return
    end

    if boss and boss ~= "" then
        -- Check if the specified boss is in our external list
        if not table.find(knownBosses, boss) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Boss '" .. boss .. "' does not have a cooldown.")
            return
        end

        -- Clear cooldown for the specified boss
        targetPlayer:setBossCooldown(boss, 0)

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Cooldown for boss '" .. boss .. "' cleared for " .. playerName .. ".")
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your cooldown for '" .. boss .. "' has been cleared.")
    else
        -- Clear cooldowns for all manually defined bosses
        for _, bossName in pairs(knownBosses) do
            targetPlayer:setBossCooldown(bossName, 0)
        end

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All applicable boss cooldowns for " .. playerName .. " have been cleared.")
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All applicable boss cooldowns have been cleared.")
    end
end

bossCooldown:separator(" ")
bossCooldown:groupType("god")
bossCooldown:register()

local clearKV = TalkAction("/clearkv")

function clearKV.onSay(player, words, param)
    if not param or param == "" then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: /clearkv <key>")
        return false
    end

    -- ✅ Properly remove the key from KV storage
    kv.remove(param)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "KV [" .. param .. "] has been cleared.")
    return true
end

clearKV:separator(" ")
clearKV:groupType("god")
clearKV:register()
