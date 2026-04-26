local infernalfrogLever = Action()
function infernalfrogLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local leverpos = Position(32756, 31469, 6)
	if leverpos then
		player:teleportTo(Position(32755, 31469, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say(
			"What a cunning and devious death trap!\z
		Rapanaio has not warned you about a\z
		mastermind for nothing!",
			TALKTYPE_MONSTER_SAY
		)
		item:transform(item.itemid == 2772 and 2773 or 2772)
		return true
	end
end

infernalfrogLever:position(Position(32756, 31469, 6))
infernalfrogLever:register()
