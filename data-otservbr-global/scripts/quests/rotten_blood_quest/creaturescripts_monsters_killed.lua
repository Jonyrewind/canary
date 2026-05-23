local bossesRottenBlood = CreatureEvent("RottenBloodBossDeath")
function bossesRottenBlood.onDeath(creature)
	local bossName = creature:getName():lower()
	if not table.contains({ "murcion", "chagorz", "ichgahal", "vemiath" }, bossName) then
		return false
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		local now = os.time()
		local kv = player:kv():scoped("rotten-blood-quest")
		local cooldown = kv:scoped(bossName):get("cooldown") or 0
		if cooldown <= now then
			kv:scoped(bossName):set("cooldown", now + 20 * 60 * 60)
			kv:set("taints", math.min(((kv:get("taints") or 0) + 1), 4))
		end
	end)

	return true
end

bossesRottenBlood:register()

-------------- Bakragore OnDeath --------------
local bakragoreOnDeath = CreatureEvent("RottenBloodBakragoreDeath")
function bakragoreOnDeath.onDeath(creature)
	local bossName = creature:getName():lower()
	if bossName ~= "bakragore" then
		return false
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		local kv = player:kv():scoped("rotten-blood-quest")
		local checkBoss = kv:get(bossName) or false
		if not checkBoss then
			kv:set(bossName, true)
			if not player:hasOutfit("1663") or not player:hasOutfit("1662") then
				player:addOutfitAddon("1663", 1)
				player:addOutfitAddon("1662", 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have won a Decaying Defender Outfit.")
			end
		end
		kv:set("taints", 0)
	end)

	return true
end

bakragoreOnDeath:register()

-------------- Rotten Blood Area Reward --------------
local rottenBloodAreaRewardMonsters = {
	["bloated man-maggot"] = true,
	["converter"] = true,
	["darklight construct"] = true,
	["darklight emitter"] = true,
	["darklight matter"] = true,
	["darklight source"] = true,
	["darklight striker"] = true,
	["meandering mushroom"] = true,
	["mycobiontic beetle"] = true,
	["oozing carcass"] = true,
	["oozing corpus"] = true,
	["rotten man-maggot"] = true,
	["sopping carcass"] = true,
	["sopping corpus"] = true,
	["walking pillar"] = true,
	["wandering pillar"] = true,
}

local rottenBloodAreaRewardItems = {
	43854, -- tainted heart
	43855, -- darklight heart
}

local rottenBloodAreaRewardBaseChance = 20 -- 1.00% at 1 taint and 1x loot rate

local rottenBloodAreaReward = CreatureEvent("RottenBloodAreaReward")
function rottenBloodAreaReward.onDeath(creature, corpse)
	if not rottenBloodAreaRewardMonsters[creature:getName():lower()] then
		return true
	end

	if not corpse or not corpse:isContainer() then
		return true
	end

	local rewardedPlayers = {}

	onDeathForDamagingPlayers(creature, function(_, player)
		local taints = player:kv():scoped("rotten-blood-quest"):get("taints") or 0
		if taints < 1 then
			return
		end

		if getLootRandom(taints) >= rottenBloodAreaRewardBaseChance then
			return
		end

		rewardedPlayers[#rewardedPlayers + 1] = player
	end)

	if #rewardedPlayers == 0 then
		return true
	end

	if not corpse:registerReward() then
		return true
	end

	local rewardId = corpse:getAttribute("date")
	if not rewardId or rewardId <= 0 then
		return true
	end

	for _, player in ipairs(rewardedPlayers) do
		local reward = player:getReward(rewardId, true)
		if reward then
			local rewardItemId = rottenBloodAreaRewardItems[math.random(#rottenBloodAreaRewardItems)]
			reward:addItem(rewardItemId, 1)
		end
	end

	return true
end

rottenBloodAreaReward:register()
