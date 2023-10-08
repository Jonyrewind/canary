local cracklerTransform = CreatureEvent("CracklerTransform")
function cracklerTransform.onThink(creature)
	if creature:getName():lower() ~= "crackler" then
		return true
	end

	if cracklerTransform == true then
		local monster = Game.createMonster("depolarized crackler", creature:getPosition(), false, true)
		monster:addHealth(-monster:getHealth() + creature:getHealth(), COMBAT_PHYSICALDAMAGE)
		creature:remove()
	end
	return true
end

cracklerTransform:register()

local depolarizedTransform = CreatureEvent("DepolarizedTransform")
function depolarizedTransform.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	if cracklerTransform == false then
		local monster = Game.createMonster("Crackler", creature:getPosition(), false, true)
		monster:addHealth(-monster:getHealth() + creature:getHealth(), COMBAT_PHYSICALDAMAGE)
		creature:remove()
	end
	return true
end

depolarizedTransform:register()

local positions1 = {
	{ x = 32197, y = 31322, z = 14 },
	{ x = 32202, y = 31328, z = 14 },
	{ x = 32208, y = 31324, z = 14 },
	{ x = 32210, y = 31334, z = 14 },
}

local positions2 = {
	{ x = 32202, y = 31325, z = 14 },
	{ x = 32201, y = 31334, z = 14 },
	{ x = 32215, y = 31332, z = 14 },
	{ x = 32208, y = 31320, z = 14 },
}

local positions3 = {
	{ x = 32199, y = 31329, z = 14 },
	{ x = 32207, y = 31335, z = 14 },
	{ x = 32208, y = 31327, z = 14 },
	{ x = 32213, y = 31322, z = 14 },
}

local positions4 = {
	{ x = 32203, y = 31319, z = 14 },
	{ x = 32205, y = 31325, z = 14 },
	{ x = 32212, y = 31330, z = 14 },
	{ x = 32219, y = 31328, z = 14 },
}

local vortexCrackler = MoveEvent()

function vortexCrackler.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.itemid == 23471 then
		if vortexPositions == 1 then
			local storePlayers = {}
			for i = 1, #positions1 do
				local tile = Tile(Position(positions1[i]))
				if tile then
					local playerTile = tile:getTopCreature()
					if playerTile and playerTile:isPlayer() then
						storePlayers[#storePlayers + 1] = playerTile
					end
				end
			end
			if #storePlayers > 0 then
				cracklerTransform = true
			end
		elseif vortexPositions == 2 then
			local storePlayers = {}
			for i = 1, #positions2 do
				local tile = Tile(Position(positions2[i]))
				if tile then
					local playerTile = tile:getTopCreature()
					if playerTile and playerTile:isPlayer() then
						storePlayers[#storePlayers + 1] = playerTile
					end
				end
			end
			if #storePlayers > 0 then
				cracklerTransform = true
			end
		elseif vortexPositions == 3 then
			local storePlayers = {}
			for i = 1, #positions3 do
				local tile = Tile(Position(positions3[i]))
				if tile then
					local playerTile = tile:getTopCreature()
					if playerTile and playerTile:isPlayer() then
						storePlayers[#storePlayers + 1] = playerTile
					end
				end
			end
			if #storePlayers > 0 then
				cracklerTransform = true
			end
		elseif vortexPositions == 0 then
			local storePlayers = {}
			for i = 1, #positions4 do
				local tile = Tile(Position(positions4[i]))
				if tile then
					local playerTile = tile:getTopCreature()
					if playerTile and playerTile:isPlayer() then
						storePlayers[#storePlayers + 1] = playerTile
					end
				end
			end
			if #storePlayers > 0 then
				cracklerTransform = true
			end
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your presence begins to polarize the area!")
		player:getPosition():sendMagicEffect(48)
	end
	return true
end

vortexCrackler:type("stepin")
vortexCrackler:id(23471)
vortexCrackler:register()

vortexCrackler = MoveEvent()

function vortexCrackler.onStepOut(creature, item, position, fromPosition)
	cracklerTransform = false
	return true
end

vortexCrackler:type("stepout")
vortexCrackler:id(23471)
vortexCrackler:register()
