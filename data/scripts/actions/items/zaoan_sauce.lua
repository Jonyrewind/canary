local meleeCondition = Condition(CONDITION_ATTRIBUTES)
meleeCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreMelee)
meleeCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
meleeCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
meleeCondition:setParameter(CONDITION_PARAM_SKILL_FIST, 10)
meleeCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local zaoanSauce = Action()

function zaoanSauce.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	player:updateFood(item:getId(), 3600)
	player:addCondition(meleeCondition)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your fist fighting skill increase for one hour.")
	player:say("Yum.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

zaoanSauce:id(50334)
zaoanSauce:register()
