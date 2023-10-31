local storage = GlobalStorage.TwistedWatersWorldChange

local corpse = MoveEvent()

function corpse.onAddItem(moveitem, tileitem, position)
	local corpse = ItemType(moveitem:getId()):isCorpse()
	if not corpse or getGlobalStorage(storage.TwistedWatersActive) == 1 then
		return true
	end

	setGlobalStorage(storage.CorpseCount, getGlobalStorage(storage.CorpseCount) + 1)
	if getGlobalStorage(storage.CorpseCount) >= 5 then
		setGlobalStorage(storage.TwistedWatersActive, 1)
		setGlobalStorage(storage.Status, 1)
		logger.info("Twisted Waters World Change Started. Lake Equivocolao will become murky after next Server Save")
	end
	return true
end

corpse:aid(2200)
corpse:register()
