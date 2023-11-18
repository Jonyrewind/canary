local closeServer = TalkAction("/closeserver")

function closeServer.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "shutdown" then
		Game.setGameState(GAME_STATE_SHUTDOWN)
		Webhook.sendMessage("Server Shutdown", "Server was shutdown by: " .. player:getName(), WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	elseif param == "save" then
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
	elseif param == "maintainance" then
		Game.setGameState(GAME_STATE_MAINTAIN)
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is set to maintenance mode.")
	else
		Game.setGameState(GAME_STATE_CLOSED)
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is now closed.")
		Webhook.sendMessage("Server Closed", "Server was closed by: " .. player:getName(), WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	end
	return true
end

closeServer:separator(" ")
closeServer:groupType("god")
closeServer:register()
