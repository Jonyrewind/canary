local soulforgedLantern = Action()

function soulforgedLantern.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		logger.warn("[PaleWorm][Lantern] onUse called without a player.")
		return false
	end

	if item.itemid ~= 32591 then
		logger.warn("[PaleWorm][Lantern] Wrong item used. Expected 32591, got {}.", item.itemid)
		return false
	end

	if not player:getCondition(CONDITION_INTENSEHEX) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not affected by Greater Hex.")
		return true
	end

	removePaleWormGreaterHex(player)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Soulforged Lantern burns away the Greater Hex.")

	if math.random(100) <= 20 then
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Soulforged Lantern breaks.")
	end

	return true
end

soulforgedLantern:id(32591)
soulforgedLantern:register()
