local function sendBoostMessage(player, category, isIncreased)
	return player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, string.format("Event! %s is %screased. Happy Hunting!", category, isIncreased and "in" or "de"))
end

local function getExpectedLoginMaxHealth(player)
	if not player then
		return nil
	end

	local level = player:getLevel()
	if level <= 8 then
		return player:getBaseMaxHealth()
	end

	local vocation = player:getVocation()
	if not vocation then
		return nil
	end

	local health = 150

	if vocation:getId() == VOCATION.ID.NONE then
		local baseLevel = math.max(level - 1, 0)
		health = health + (baseLevel * vocation:getHealthGain())
	else
		local baseVocation = Vocation(VOCATION.ID.NONE)
		local baseLevel = 7
		local levelGain = math.max(level - 8, 0)
		health = health + (baseLevel * baseVocation:getHealthGain()) + (levelGain * vocation:getHealthGain())
	end

	return health
end

local function normalizeLoginHealth(player)
	if not player then
		return false
	end

	local expectedMaxHealth = getExpectedLoginMaxHealth(player)
	if not expectedMaxHealth then
		return false
	end

	local currentMaxHealth = player:getBaseMaxHealth()
	if currentMaxHealth ~= expectedMaxHealth then
		player:setMaxHealth(expectedMaxHealth)
		player:setHealth(math.min(player:getHealth(), expectedMaxHealth))
		logger.warn(
			"[Login] Normalized max health for {} from {} to {} on login.",
			player:getName(),
			currentMaxHealth,
			expectedMaxHealth
		)
		return true
	end

	return false
end

local playerLoginGlobal = CreatureEvent("PlayerLoginGlobal")

function playerLoginGlobal.onLogin(player)
	-- Welcome
	local loginStr
	if player:getLastLoginSaved() == 0 then
		loginStr = "Please choose your outfit."
		player:sendOutfitWindow()
		local startStreakLevel = configManager.getNumber(configKeys.START_STREAK_LEVEL)
		if startStreakLevel > 0 then
			player:setStreakLevel(startStreakLevel)
		end

		db.query("UPDATE `players` SET `istutorial` = 0 WHERE `id` = " .. player:getGuid())
	else
		loginStr = string.format("Your last visit in %s: %s.", SERVER_NAME, os.date("%d %b %Y %X", player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_LOGIN, loginStr)

	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	if player:isPremium() then
		local hasPromotion = player:kv():get("promoted")
		if not player:isPromoted() and hasPromotion then
			player:setVocation(promotion)
		end
	elseif player:isPromoted() then
		player:setVocation(vocation:getDemotion())
	end

	if player:getGroup():getId() < GROUP_TYPE_GAMEMASTER then
		normalizeLoginHealth(player)
	end

	-- Boosted
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, string.format("Today's boosted creature: %s.", Game.getBoostedCreature()))
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, string.format("Today's boosted boss: %s.", Game.getBoostedBoss()))

	-- Rewards
	local rewards = #player:getRewardList()
	if rewards > 0 then
		player:sendTextMessage(MESSAGE_LOGIN, string.format("You have %d reward%s in your reward chest.", rewards, rewards > 1 and "s" or ""))
	end

	-- Rate events:
	if SCHEDULE_EXP_RATE ~= 100 then
		sendBoostMessage(player, "Exp Rate", SCHEDULE_EXP_RATE > 100)
	end

	if SCHEDULE_SPAWN_RATE ~= 100 then
		sendBoostMessage(player, "Spawn Rate", SCHEDULE_SPAWN_RATE > 100)
	end

	if SCHEDULE_LOOT_RATE ~= 100 then
		sendBoostMessage(player, "Loot Rate", SCHEDULE_LOOT_RATE > 100)
	end

	if SCHEDULE_BOSS_LOOT_RATE ~= 100 then
		sendBoostMessage(player, "Boss Loot Rate", SCHEDULE_BOSS_LOOT_RATE > 100)
	end

	if SCHEDULE_SKILL_RATE ~= 100 then
		sendBoostMessage(player, "Skill Rate", SCHEDULE_SKILL_RATE > 100)
	end

	-- Send Recruiter Outfit
	local resultId = db.storeQuery("SELECT `recruiter` FROM `accounts` WHERE `id`= " .. Game.getPlayerAccountId(getPlayerName(player)))
	if resultId then
		local recruiterStatus = Result.getNumber(resultId, "recruiter")
		local sex = player:getSex()
		local outfitId = (sex == 1) and 746 or 745
		for outfitAddOn = 0, 2 do
			if recruiterStatus >= outfitAddOn * 3 + 1 then
				if not player:hasOutfit(outfitId, outfitAddOn) then
					if outfitAddOn == 0 then
						player:addOutfit(outfitId)
					else
						player:addOutfitAddon(outfitId, outfitAddOn)
					end
				end
			end
		end
	end

	-- Send Client Exp Display
	if configManager.getBoolean(configKeys.XP_DISPLAY_MODE) then
		local baseRate = player:getFinalBaseRateExperience() * 100
		if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
			local vipBonusExp = configManager.getNumber(configKeys.VIP_BONUS_EXP)
			if vipBonusExp > 0 and player:isVip() then
				vipBonusExp = (vipBonusExp > 100 and 100) or vipBonusExp
				baseRate = baseRate * (1 + (vipBonusExp / 100))
				player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Normal base xp is: " .. baseRate .. "%, because you are VIP, bonus of " .. vipBonusExp .. "%")
			end
		end

		player:setBaseXpGain(baseRate)
	end

	player:setStaminaXpBoost(player:getFinalBonusStamina() * 100)
	player:getFinalLowLevelBonus()

	-- Updates the player's VIP status and executes corresponding actions if applicable.
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		local isCurrentlyVip = player:isVip()
		local hadVipStatus = player:kv():scoped("account"):get("vip-system") or false

		if hadVipStatus ~= isCurrentlyVip then
			if hadVipStatus then
				player:onRemoveVip()
			else
				player:onAddVip(player:getVipDays())
			end
		end

		if isCurrentlyVip then
			player:sendVipStatus()
		end
	end

	-- Set Ghost Mode
	if player:getGroup():getId() >= GROUP_TYPE_GAMEMASTER then
		player:setGhostMode(true)
	end

	-- Resets
	if _G.OnExerciseTraining[player:getId()] then
		stopEvent(_G.OnExerciseTraining[player:getId()].event)
		_G.OnExerciseTraining[player:getId()] = nil
		player:setTraining(false)
	end

	local playerId = player:getId()
	_G.NextUseStaminaTime[playerId] = 1
	_G.NextUseXpStamina[playerId] = 1
	_G.NextUseConcoctionTime[playerId] = 1
	DailyReward.init(playerId)

	local stats = player:inBossFight()
	if stats then
		stats.playerId = player:getId()
	end

	-- Remove Boss Time
	if GetDailyRewardLastServerSave() >= player:getLastLoginSaved() then
		player:setRemoveBossTime(1)
	end

	-- Change support outfit to a normal outfit to open customize character without crashes
	local playerOutfit = player:getOutfit()
	if table.contains({ 75, 266, 302 }, playerOutfit.lookType) and not player:getGroup():getAccess() then
		playerOutfit.lookType = player:getSex() == PLAYERSEX_FEMALE and 136 or 128
		playerOutfit.lookAddons = 0
		player:setOutfit(playerOutfit)
	end

	player:initializeLoyaltySystem()
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	player:registerEvent("BossParticipation")
	player:registerEvent("UpdatePlayerOnAdvancedLevel")

	if vocation and vocation:getBaseId() == VOCATION.BASE_ID.MONK then
		local kv = player:kv()
		if (kv:get("monk-basic-atk-bonus") or 0) < 10 then
			logger.info("Setting monk basic attack bonus 10 for player: {}.", player:getName())
			kv:set("monk-basic-atk-bonus", 10)
		end
	end
	return true
end

playerLoginGlobal:register()
