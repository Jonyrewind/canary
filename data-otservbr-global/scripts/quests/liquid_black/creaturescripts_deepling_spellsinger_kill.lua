local deeplingSpellsingerKill = CreatureEvent("DeeplingSpellsingerDeath")

function deeplingSpellsingerKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(_creature, player)
		player:addAchievementProgress("Death Song", 300)
	end)

	return true
end

deeplingSpellsingerKill:register()
