local area = createCombatArea({
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 3, 1, 1 },
	{ 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0 },
})

local wandOfDimensions = Weapon(WEAPON_WAND)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_HOLY)

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)
combat2:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_EXPLOSION)

local combat3 = Combat()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEATTACK)
combat3:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ICE)

function onGetFormulaValues()
	local min = 80
	local max = 100
	return -min, -max
end

function onGetFormulaValues2()
	local min = 80
	local max = 100
	return -min, -max
end

function onGetFormulaValues3()
	local min = 80
	local max = 100
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues2")
combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues3")

wandOfDimensions.onUseWeapon = function(player, variant)
	combat:execute(player, variant)
	combat2:execute(player, variant)
	combat3:execute(player, variant)
	return true
end

wandOfDimensions:id(12603)
wandOfDimensions:mana(60)
wandOfDimensions:range(6)
wandOfDimensions:register()
