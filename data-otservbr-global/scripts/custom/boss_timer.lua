local bosstimer = {
	-- Config
	mainTitle = "Boss Eye",
	mainMsg = "Status dos boss",
}

local bosstimer = TalkAction("!boss")

function bosstimer.onSay(player, words, param)
    player:sendBossWindow(bosstimer)
    return true
end	

bosstimer:register()