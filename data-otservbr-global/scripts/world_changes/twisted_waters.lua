local TwistedWaters = GlobalEvent("TwistedWaters")

function TwistedWaters.onCustomMapStartup()
	Game.loadCustomMaps("data-otservbr-global/world/world_changes/twisted_waters/")
	return true
end

TwistedWaters:register()
