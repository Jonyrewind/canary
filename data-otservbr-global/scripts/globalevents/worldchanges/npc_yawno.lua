local function spawnyawno(position)
	local npc = Game.createNpc("yawno", position)
	if npc then
		npc:setMasterPos(position)
	end
end

local yawno = GlobalEvent("yawno")

function yawno.onStartup()
	local yawnoPosition = Position(32614, 32651, 7)
	addEvent(spawnyawno, 5000, yawnoPosition)
end

yawno:register()
