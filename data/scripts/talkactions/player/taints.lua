local function showTaints(player)
	local text = "Your current taints:\n\n"

	local soulWarTaintLevel = player:getTaintLevel()
	local soulWarTaintName = soulWarTaintLevel and player:getTaintNameByNumber(soulWarTaintLevel) or nil
	if soulWarTaintLevel and soulWarTaintName then
		text = text .. "Goshnar's Taints: " .. soulWarTaintLevel .. "\n"
	else
		text = text .. "Goshnar's Taints: None\n"
	end

	local rottenBloodTaints = player:kv():scoped("rotten-blood-quest"):get("taints") or 0
	text = text .. "Bakragore's Taints: " .. rottenBloodTaints

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, text)
	return true
end

local taint = TalkAction("!taint", "!taints")

function taint.onSay(player, words, param)
	return showTaints(player)
end

taint:setDescription("[Usage]: !taint or !taints - Shows your current Soul War and Rotten Blood taints")
taint:groupType("normal")
taint:register()
