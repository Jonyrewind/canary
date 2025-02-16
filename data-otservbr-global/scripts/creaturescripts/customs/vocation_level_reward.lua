local rewards = {
	[{ 1, 5 }] = {
		[10] = { items = { { itemid = 32711, count = 1 } }, kv_key = "reward_10", msg = "You won a luminescent crystal pickaxe for reaching level 10!" },
		[20] = { items = { { itemid = 3043, count = 50 } }, kv_key = "reward_20", msg = "You won 50k crystal coins for reaching level 20!" },
		[33] = { items = { { itemid = 3071, count = 1 }, { itemid = 3210, count = 1 }, { itemid = 8043, count = 1 }, { itemid = 645, count = 1 } }, kv_key = "reward_33", msg = "You won some items for reaching level 33!" },
		[65] = { items = { { itemid = 16096, count = 1 } }, kv_key = "reward_65", msg = "You won a wand of defiance for reaching level 65!" },
		[80] = { items = { { itemid = 25700, count = 1 } }, kv_key = "reward_80", msg = "You won a dream blossom staff for reaching level 80!" },
		[200] = { items = { { itemid = 27457, count = 1 } }, kv_key = "reward_200", msg = "You won a wand of destruction for reaching level 200!" },
	},
	[{ 2, 6 }] = {
		[10] = { items = { { itemid = 32711, count = 1 } }, kv_key = "reward_10", msg = "You won a luminescent crystal pickaxe for reaching level 10!" },
		[20] = { items = { { itemid = 3043, count = 50 } }, kv_key = "reward_20", msg = "You won 50k crystal coins for reaching level 20!" },
		[33] = { items = { { itemid = 3067, count = 1 }, { itemid = 3210, count = 1 }, { itemid = 8043, count = 1 }, { itemid = 645, count = 1 } }, kv_key = "reward_33", msg = "You won some items for reaching level 33!" },
		[65] = { items = { { itemid = 16118, count = 1 } }, kv_key = "reward_65", msg = "You won a glacial rod for reaching level 65!" },
		[80] = { items = { { itemid = 25700, count = 1 } }, kv_key = "reward_80", msg = "You won a dream blossom staff for reaching level 80!" },
		[200] = { items = { { itemid = 27458, count = 1 } }, kv_key = "reward_200", msg = "You won a rod of destruction for reaching level 200!" },
	},
	[{ 3, 7 }] = {
		[10] = { items = { { itemid = 32711, count = 1 } }, kv_key = "reward_10", msg = "You won a luminescent crystal pickaxe for reaching level 10!" },
		[20] = { items = { { itemid = 3043, count = 50 } }, kv_key = "reward_20", msg = "You won 50k crystal coins for reaching level 20!" },
		[33] = { items = { { itemid = 5741, count = 1 }, { itemid = 3386, count = 1 }, { itemid = 3382, count = 1 }, { itemid = 3420, count = 1 }, { itemid = 19362, count = 1 } }, kv_key = "reward_33", msg = "You won some items for reaching level 33!" },
		[50] = { items = { { itemid = 8027, count = 1 }, { itemid = 14247, count = 1 } }, kv_key = "reward_50", msg = "You won a composite hornbow and a ornate crossbow for reaching level 50!" },
		[85] = { items = { { itemid = 14246, count = 1 }, { itemid = 8025, count = 1 } }, kv_key = "reward_85", msg = "You won a hive bow and the ironworker for reaching level 85!" },
		[200] = { items = { { itemid = 27455, count = 1 }, { itemid = 27456, count = 1 } }, kv_key = "reward_200", msg = "You won a bow of destruction and a crossbow of destruction for reaching level 200!" },
	},
	[{ 4, 8 }] = {
		[10] = { items = { { itemid = 32711, count = 1 } }, kv_key = "reward_10", msg = "You won a luminescent crystal pickaxe for reaching level 10!" },
		[20] = { items = { { itemid = 3043, count = 50 } }, kv_key = "reward_20", msg = "You won 50k crystal coins for reaching level 20!" },
		[33] = { items = { { itemid = 5741, count = 1 }, { itemid = 3386, count = 1 }, { itemid = 3382, count = 1 }, { itemid = 3420, count = 1 }, { itemid = 7454, count = 1 }, { itemid = 7452, count = 1 }, { itemid = 7407, count = 1 } }, kv_key = "reward_33", msg = "You won some items for reaching level 33!" },
		[60] = { items = { { itemid = 10388, count = 1 }, { itemid = 21173, count = 1 }, { itemid = 7382, count = 1 } }, kv_key = "reward_60", msg = "You won some new weapons for reaching level 60!" },
		[120] = { items = { { itemid = 16161, count = 1 }, { itemid = 8099, count = 1 }, { itemid = 16175, count = 1 } }, kv_key = "reward_120", msg = "You won some new weapons for reaching level 120!" },
		[200] = { items = { { itemid = 27452, count = 1 }, { itemid = 27454, count = 1 }, { itemid = 27450, count = 1 } }, kv_key = "reward_200", msg = "You won some new weapons for reaching level 200!" },
	},
}

local rewardLevel = CreatureEvent("RewardLevel")

function rewardLevel.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	local playerKV = player:kv() -- Create KV storage scope

	for voc, x in pairs(rewards) do
		if isInArray(voc, player:getVocation():getId()) then
			for level, z in pairs(x) do
				if newLevel >= level and playerKV:get(z.kv_key) ~= 1 then
					for _, item in ipairs(z.items) do
						player:addItem(item.itemid, item.count)
					end
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, z.msg)
					playerKV:set(z.kv_key, 1) -- Store the reward as claimed
				end
			end
			player:save()
			return true
		end
	end
end

rewardLevel:register()
