local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
combat:setArea(createCombatArea(AREA_WAVE4, AREADIAGONAL_WAVE4))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 3) + (maglevel * 0.3) + 2
	local max = (level / 3) + (maglevel * 0.6) + 4
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(178)
spell:name("Scorch")
spell:words("exevo infir flam hur")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SCORCH)
spell:level(1)
spell:mana(8)
spell:isAggressive(true)
spell:isPremium(false)
spell:needDirection(true)
spell:cooldown(1.5 * 1000)
spell:groupCooldown(1 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
