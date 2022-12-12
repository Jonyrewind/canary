local bestiaryOnKill = CreatureEvent("BestiaryOnKill")
function bestiaryOnKill.onKill(player, creature, lastHit)
	if not player:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
		return true
	end

	for cid, damage in pairs(creature:getDamageMap()) do
		local participant = Player(cid)
		if participant and participant:isPlayer() then
			local bestAmount = 6 --(default=1) how much will increase after kill a monter in bestiary
			for i = bestAmount, 1, -1 do 
			participant:addBestiaryKill(creature:getName())		
			end
		end
	end

	return true
end
bestiaryOnKill:register()
