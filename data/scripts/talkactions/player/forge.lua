local forge = TalkAction("!forge")

function forge.onSay(player, words, param)
	return player:openForge()
end

forge:groupType("normal")
forge:register()