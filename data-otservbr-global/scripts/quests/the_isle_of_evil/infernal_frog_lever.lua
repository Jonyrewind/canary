local infernalfrogLever = Action()
function infernalfrogLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		player:teleportTo(Position(32755, 31469, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say(
			"What a cunning and devious death trap!\z
		Rapanaio has not warned you about a\z
		mastermind for nothing!",
			TALKTYPE_MONSTER_SAY
		)
		return true
	end
end

infernalfrogLever:aid(8050)
infernalfrogLever:register()
