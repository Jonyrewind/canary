local cracklerTransformEvent = CreatureEvent("CracklerTransform")

function cracklerTransformEvent.onThink(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	-- Use the global flag `cracklerTransform`
	if cracklerTransform then
		local monster = Game.createMonster("Depolarized Crackler", creature:getPosition(), false, true)
		if monster then
			monster:addHealth(-monster:getHealth() + creature:getHealth(), COMBAT_PHYSICALDAMAGE)
			creature:remove()
		end
	end

	return true
end

cracklerTransformEvent:register()
