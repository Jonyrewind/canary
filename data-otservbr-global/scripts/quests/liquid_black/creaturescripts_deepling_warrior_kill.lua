local deeplingWarriorKill = CreatureEvent("DeeplingWarriorDeath")

function deeplingWarriorKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(_creature, player)
		player:addAchievementProgress("Depth Dwellers", 300)
	end)

	return true
end

deeplingWarriorKill:register()
