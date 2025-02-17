monsters = {
	["Bloated Man-Maggot"] = true,
	["Converter"] = true,
	["Darklight Construct"] = true,
	["Darklight Emitter"] = true,
	["Darklight Matter"] = true,
	["Darklight Source"] = true,
	["Darklight Striker"] = true,
	["Meandering Mushroom"] = true,
	["Mycobiontic Beetle"] = true,
	["Oozing Carcass"] = true,
	["Oozing Corpus"] = true,
	["Rotten Man-Maggot"] = true,
	["Sopping Carcass"] = true,
	["Sopping Corpus"] = true,
	["Walking Pillar"] = true,
	["Wandering Pillar"] = true,
}

items = { 43855, 43854 }

local creatureevent = CreatureEvent("onDeath_rotten_blood_crimson_offering")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if not corpse then
		return true
	end

	local monsterName = creature:getName()
	if not monsters[monsterName] then
		return true
	end -- Only process if the monster is in the list

	local player = killer and killer:getPlayer() -- Ensure killer is a player
	if not player then
		return true
	end

	local taints = player:kv():scoped("rotten-blood-quest"):get("taints") or 0
	if taints > 0 then
		if corpse:getEmptySlots() > 0 then
			if math.random(100) <= 5 then -- 5% chance
				local randomItem = items[math.random(#items)] -- Pick a random item
				corpse:addItem(randomItem, 1) -- Add one of the item to the corpse
			end
		end
	end

	return true
end

creatureevent:register()

-- Function to register the death event when a monster spawns
function Monster:onSpawn(position)
	if monsters[self:getName()] then
		self:registerEvent("onDeath_rotten_blood_crimson_offering")
	end
end

local checkTaint = TalkAction("!rottentaint")

function checkTaint.onSay(player, words, param)
	local taintLevel = player:kv():scoped("rotten-blood-quest"):get("taints") or 0
	if taintLevel ~= nil then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current taint level is: " .. taintLevel)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You currently have no taint.")
	end

	return true
end

checkTaint:groupType("normal")
checkTaint:register()
