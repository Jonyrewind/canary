local items = {
	skull = 3114,
	grinder = {21573, 1943, 1944, 1945, 1946},
	meal = 32602,
	flower = 3661,
	apparatus = {5468,5469},
	distilling = 5468,
	flowerextract = 32603,
	vial = 32584
}

local Vial = Action()

function Vial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FeasterOfSouls.Potion) < 1 then
		if item.itemid == items.skull and isInArray(items.grinder, target.itemid) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You grind the skull into fine dust.')
			target:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:addItem(items.meal, 1)
			item:remove(1)
		elseif item.itemid == items.meal and isInArray(items.flowerextract, target.itemid) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You pour the bone meal into the vial with grave flower extract.')
			target:getPosition():sendMagicEffect(CONST_ME_PURPLESMOKE)
			player:addItem(items.vial, 1)
			item:remove(1)
		elseif item.itemid == items.vial and player:getStorageValue(Storage.FeasterOfSouls.DeathKnell.Counter) == 3 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You drink the potion and suddenly you feel as if someone is walking over your grave.')
			target:getPosition():sendMagicEffect(CONST_ME_GHOST_SMOKE)
			player:addItem(items.vial, 1)
			item:remove(1)
			player:setStorageValue(Storage.FeasterOfSouls.Potion, 1)
			player:setStorageValue(Storage.FeasterOfSouls.BrainGroundsAccess, 1)
		end
	end
	return true
end

Vial:id(3114, 32602, 32584)
Vial:register()