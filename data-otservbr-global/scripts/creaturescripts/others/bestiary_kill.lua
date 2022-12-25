local bestiaryOnKill = CreatureEvent("BestiaryOnKill")
function bestiaryOnKill.onKill(player, creature, lastHit)
	if not player:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
		return true
	end

	for cid, damage in pairs(creature:getDamageMap()) do
		local participant = Player(cid)
		local monsterType = creature:getType()
		if participant and participant:isPlayer() then
			local bestAmount = 10 --(default=1) how much will increase after kill a monter in bestiary
			for i = bestAmount, 1, -1 do 
			participant:addBestiaryKill(monsterType:getTypeName():lower())
			end
		end
	end

	return true
end
bestiaryOnKill:register()
