local deeplingScoutKill = CreatureEvent("DeeplingScoutDeath")

function deeplingScoutKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(_creature, player)
		player:addAchievementProgress("Invader of the Deep", 300)
	end)

	return true
end

deeplingScoutKill:register()
