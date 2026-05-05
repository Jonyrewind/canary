local rewards = {
	-- Sorcerer / Master Sorcerer
	[{ 1, 5 }] = {
		[33] = { items = { { itemid = 3071, count = 1 } }, kv = "reward_level_33", msg = "You won Wand of Inferno for reaching level 33!" },
		[42] = { items = { { itemid = 8094, count = 1 } }, kv = "reward_level_42", msg = "You won Wand of Voodoo for reaching level 42!" },
		[80] = { items = { { itemid = 25700, count = 1 } }, kv = "reward_level_80", msg = "You won Dream Blossom Staff for reaching level 80!" },
		[150] = { items = { { itemid = 35522, count = 1 } }, kv = "reward_level_150", msg = "You won Jungle Wand for reaching level 150!" },
	},
	-- Druid / Elder Druid
	[{ 2, 6 }] = {
		[33] = { items = { { itemid = 3067, count = 1 } }, kv = "reward_level_33", msg = "You won Hailstorm Rod for reaching level 33!" },
		[42] = { items = { { itemid = 8082, count = 1 } }, kv = "reward_level_42", msg = "You won Underworld Rod for reaching level 42!" },
		[80] = { items = { { itemid = 25700, count = 1 } }, kv = "reward_level_80", msg = "You won Dream Blossom Staff for reaching level 80!" },
		[150] = { items = { { itemid = 35521, count = 1 } }, kv = "reward_level_150", msg = "You won Jungle Rod for reaching level 150!" },
	},
	-- Paladin / Royal Paladin
	[{ 3, 7 }] = {
		[50] = { items = { { itemid = 8027, count = 1 } }, kv = "reward_level_50", msg = "You won Composite Hornbow for reaching level 50!" },
		[85] = { items = { { itemid = 14246, count = 1 } }, kv = "reward_level_85", msg = "You won Hive Bow for reaching level 85!" },
		[150] = { items = { { itemid = 35518, count = 1 } }, kv = "reward_level_150", msg = "You won Jungle Bow for reaching level 150!" },
	},
	-- Knight / Elite Knight
	[{ 4, 8 }] = {
		[45] = { items = { { itemid = 7412, count = 1 }, { itemid = 3312, count = 1 }, { itemid = 7402, count = 1 } }, kv = "reward_level_45", msg = "You won a new Weapon for reaching level 45!" },
		[75] = { items = { { itemid = 7434, count = 1 }, { itemid = 7429, count = 1 }, { itemid = 7390, count = 1 } }, kv = "reward_level_75", msg = "You won a new Weapon for reaching level 75!" },
		[120] = { items = { { itemid = 16161, count = 1 }, { itemid = 16162, count = 1 }, { itemid = 16175, count = 1 } }, kv = "reward_level_120", msg = "You won a new Weapon for reaching level 120!" },
	},
	-- Monk / Exalted Monk
	[{ 9, 10 }] = {
		[50] = { items = { { itemid = 50273, count = 1 } }, kv = "reward_level_50", msg = "You won a new Weapon for reaching level 50!" },
		[75] = { items = { { itemid = 50163, count = 1 } }, kv = "reward_level_75", msg = "You won a new Weapon for reaching level 75!" },
		[120] = { items = { { itemid = 50164, count = 1 } }, kv = "reward_level_120", msg = "You won a new Weapon for reaching level 120!" },
	},
}

local rewardLevel = CreatureEvent("RewardLevel")

function rewardLevel.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	local vocId = player:getVocation():getId()

	for vocGroup, rewardsTable in pairs(rewards) do
		if table.contains(vocGroup, vocId) then
			for reqLevel, data in pairs(rewardsTable) do
				if newLevel >= reqLevel then
					-- Check if player already received this reward using KV
					if player:kv():get(data.kv) ~= 1 then
						-- Give items
						for _, item in ipairs(data.items) do
							player:addItem(item.itemid, item.count)
						end

						-- Send message
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, data.msg)

						-- Mark as received
						player:kv():set(data.kv, 1)
					end
				end
			end

			player:save()
			return true
		end
	end

	return true
end

rewardLevel:register()
