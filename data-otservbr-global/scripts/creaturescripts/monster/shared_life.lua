local sharedLife = CreatureEvent("SharedLife")
function sharedLife.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local normalizedPrimaryDamage = math.abs(primaryDamage)
	local normalizedSecondaryDamage = math.abs(secondaryDamage)

	local killer = false
	-- Monster.onReceivDamageSL(self, damage, tp)
	if primaryType == COMBAT_HEALING then
		creature:onReceivDamageSL(normalizedPrimaryDamage, "healing", killer)
	else
		if creature:getHealth() - normalizedPrimaryDamage <= 0 then
			killer = true
		end
		creature:onReceivDamageSL(normalizedPrimaryDamage, "damage", killer)
	end

	killer = false
	if secondaryType == COMBAT_HEALING then
		creature:onReceivDamageSL(normalizedSecondaryDamage, "healing", killer)
	else
		if creature:getHealth() - normalizedSecondaryDamage <= 0 then
			killer = true
		end
		creature:onReceivDamageSL(normalizedSecondaryDamage, "damage", killer)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

sharedLife:register()
