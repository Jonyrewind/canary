local achievements = TalkAction("!ach", "!achievements")

function achievements.onSay(player, words, param)
    local text = "All your Achievements"
    local menu = ModalWindow{
        title = "Achievement Points: " .. player:getAchievementPoints(),
        message = text
    }

	achievements = getAchievements()
	for a = 1, #achievements do
	achievement =  getAchievementInfoById(a)
		if player:hasAchievement(a) then
			menu:addChoice(" "..achievement.name.." ")
		end
	end

    menu:addButton("Close")

    menu:sendToPlayer(player)
    return true
end

achievements:groupType("normal")
achievements:register()