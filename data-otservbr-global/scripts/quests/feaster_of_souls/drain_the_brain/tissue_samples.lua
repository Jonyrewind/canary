local items = {
	scalpel = 32225,
	ulcer = {32173, 32174, 32175},
	probe = 32197
}

local tissueSample = Action()

function tissueSample.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(Storage.FeasterOfSouls.TissueSamples.Done) >= 1 or player:getStorageValue(Storage.FeasterOfSouls.TissueSamples.Status) >= 20 then
		return false
	end
	if player:getStorageValue(Storage.FeasterOfSouls.TissueSamples.Status) < 0 then
		player:setStorageValue(Storage.FeasterOfSouls.TissueSamples.Status, 0)
	end
	if player:getStorageValue(Storage.FeasterOfSouls.TissueSamples.Status) == 19 then
		player:say('You collected all tissue samples.', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(Storage.FeasterOfSouls.TissueSamples.Done, 1)
	end
	if item.itemid == items.scalpel and isInArray(items.ulcer, target.itemid) then
		player:setStorageValue(Storage.FeasterOfSouls.TissueSamples.Status, player:getStorageValue(Storage.FeasterOfSouls.TissueSamples.Status) + 1)
		toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
		player:addItem(items.probe, 1)
	end
	return true
end

tissueSample:id(items.scalpel)
tissueSample:register()