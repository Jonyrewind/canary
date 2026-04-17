local config = {
	lesser = {
		names = {
			"lesser guardian gem",
			"lesser marksman gem",
			"lesser sage gem",
			"lesser mystic gem",
			"lesser spiritualist gem",
		},
		chance = {
			influenced = 9000,
			fiendish = 3000,
			archfoe = 1000,
		},
		maxCount = 4,
	},
	regular = {
		names = {
			"guardian gem",
			"marksman gem",
			"sage gem",
			"mystic gem",
			"spiritualist gem",
		},
		chance = {
			influenced = 1000,
			fiendish = 3000,
			archfoe = 9000,
		},
		maxCount = 3,
	},
	greater = {
		names = {
			"greater guardian gem",
			"greater marksman gem",
			"greater sage gem",
			"greater mystic gem",
			"greater spiritualist gem",
		},
		chance = {
			influenced = 1000,
			fiendish = 9000,
			archfoe = 3000,
		},
		maxCount = 2,
	},
}

function Monster:generateGemAtelierLoot()
	local mType = self:getType()
	if not mType then
		return {}
	end
	local category = "none"
	local forgeClassification = self:getMonsterForgeClassification()
	local race = (mType:bossRace() or ""):lower()
	if forgeClassification == FORGE_INFLUENCED_MONSTER then
		category = "influenced"
	elseif forgeClassification == FORGE_FIENDISH_MONSTER then
		category = "fiendish"
	elseif race == "archfoe" or race == "bane" or race == "nemesis" then
		category = "archfoe"
	end
	if category == "none" then
		return {}
	end

	local loot = {}
	for _, gemConfig in pairs(config) do
		local chance = gemConfig.chance[category] or 0
		local names = gemConfig.names
		local maxCount = gemConfig.maxCount
		if chance > 0 then
			for i = 1, maxCount do
				local roll = math.random(1, 50000)
				if roll > chance then
					goto continue
				end

				local name = names[math.random(1, #names)]
				local itemType = ItemType(name)
				if not itemType then
					goto continue
				end
				if loot[itemType:getId()] then
					loot[itemType:getId()].count = loot[itemType:getId()].count + 1
				else
					loot[itemType:getId()] = { count = 1 }
				end
			end
		end
		::continue::
	end
	return loot
end
