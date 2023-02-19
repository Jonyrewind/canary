local slimeFungus = MoveEvent()

function slimeFungus.onStepIn(creature, item, position, fromPosition)
	if player:getStorageValue(Storage.FeasterOfSouls.BrainHead.Kill) >= 1 then
		return false
	end
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local chance = math.random(100)
	local damage = player:getMaxHealth() * 0.15
	if chance <= 10 then
		if player:getStorageValue(Storage.FeasterOfSouls.TissueSamples.Done) < 0 and player:getStorageValue(Storage.FeasterOfSouls.Fungus) >= 1 then
			local item = math.random(32173, 32174, 32175)
			Game.createItem(item, 1, position)
			addEvent(function()
			local ulcer = Tile(position):getItemById(item)
			ulcer:remove()
			end, 15 * 1000)
		end
		doTargetCombatHealth(0, player, COMBAT_POISONDAMAGE, -damage, -damage, CONST_ME_HITBYPOISON)
	end
	return true
end

slimeFungus:type("stepin")
slimeFungus:aid(3311)
slimeFungus:register()

local slimeFungus = MoveEvent()

function slimeFungus.onStepIn(creature, item, position, fromPosition)
	if player:getStorageValue(Storage.FeasterOfSouls.BrainHead.Kill) >= 1 then
		return false
	end
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local chance = math.random(1000)
	local damage = player:getMaxHealth() * 0.20
	if chance <= 10 then
		doTargetCombatHealth(0, player, COMBAT_POISONDAMAGE, -damage, -damage, CONST_ME_HITBYPOISON)
	end
	return true
end

slimeFungus:type("stepin")
slimeFungus:aid(3312)
slimeFungus:register()

local slimeFungus = MoveEvent()

function slimeFungus.onStepIn(creature, item, position, fromPosition)
	if player:getStorageValue(Storage.FeasterOfSouls.BrainHead.Kill) >= 1 then
		return false
	end
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local chance = math.random(1000)
	local damage = player:getMaxHealth() * 0.25
	if chance <= 10 then
		doTargetCombatHealth(0, player, COMBAT_POISONDAMAGE, -damage, -damage, CONST_ME_HITBYPOISON)
	end
	return true
end

slimeFungus:type("stepin")
slimeFungus:aid(3313)
slimeFungus:register()