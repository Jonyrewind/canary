local function ServerSave()
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_CLEAN_MAP) then
		cleanMap()
	end
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_CLOSE) then
		Game.setGameState(GAME_STATE_CLOSED, true)
	end
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_SHUTDOWN) then
		Game.setGameState(GAME_STATE_SHUTDOWN, true)
	end
	-- Updating daily reward next server save.
	UpdateDailyRewardGlobalStorage(DailyReward.storages.lastServerSave, os.time())
	-- Reset gamestore exp boost count.
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 51052")
	-- Reset gray island bosses.
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 20075")
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 20076")
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 20077")
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 65018")
	-- Exercise Reward
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 30061")
	-- Reset Twisted Waters Corpse and fishing Counter
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 60170")
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 60171")
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 60173")
	-- Reset BoredMiniWorldChange
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 65020")
	-- Reset BankRobberyMiniWorldChange
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 65021")
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 65022")
	db.query("UPDATE `global_storage` SET `value` = 0 WHERE `global_storage`.`key` = 65023")
	Spdlog.info("storages reset")
end

local function ServerSaveWarning(time)
	-- minus one minutes
	local remainingTime = tonumber(time) - 60000
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_NOTIFY_MESSAGE) then
		local message = "Server is saving game in " .. (remainingTime / 60000) .. " minute(s). Please logout."
		Webhook.sendMessage(":floppy_disk: " .. message, announcementChannels["serverAnnouncements"])
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end
	-- if greater than one minute, schedule another warning
	-- else the next event will be the server save
	if remainingTime > 60000 then
		addEvent(ServerSaveWarning, 60000, remainingTime)
	else
		addEvent(ServerSave, 60000)
	end
end

-- Function that is called by the global events when it reaches the time configured
-- interval is the time between the event start and the the effective save, it will send an notify message every minute
local serverSaveEvent = GlobalEvent("serversave")
function serverSaveEvent.onTime(interval)
	local remainingTime = configManager.getNumber(configKeys.GLOBAL_SERVER_SAVE_NOTIFY_DURATION) * 60000
	if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_NOTIFY_MESSAGE) then
		local message = "Server is saving game in " .. (remainingTime / 60000) .. " minute(s). Please logout."
		Webhook.sendMessage(":floppy_disk: " .. message, announcementChannels["serverAnnouncements"])
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end
	addEvent(ServerSaveWarning, 60000, remainingTime) -- Schedule next event in 1 minute(60000)
	return not configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_SHUTDOWN)
end

serverSaveEvent:time(configManager.getString(configKeys.GLOBAL_SERVER_SAVE_TIME))
serverSaveEvent:register()
