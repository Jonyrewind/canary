local config = {
	centerPosition = Position(33710, 31634, 14),
	rangeX = 11,
	rangeY = 11,
}

local GoshnarsMegalomania = CreatureEvent("megalomaniaDeath")

function GoshnarsMegalomania.onPrepareDeath(creature)
	local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, specCreature in pairs(spectators) do
		if specCreature:isPlayer() then
			if specCreature:getStorageValue(Storage.Quest.U12_40.RevenantOutfits.Received) == -1 then
				specCreature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Revenant Outfit.")
				specCreature:addOutfit(1322, 0)
				specCreature:addOutfit(1323, 0)
				specCreature:setStorageValue(Storage.Quest.U12_40.RevenantOutfits.Received, 1)
			end
		end
	end

	return true
end

GoshnarsMegalomania:register()
