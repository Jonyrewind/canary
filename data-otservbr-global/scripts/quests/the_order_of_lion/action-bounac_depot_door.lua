local depotdoorBounacAction = Action()

local POS_A = Position(32392, 32495, 7)  -- one side
local POS_B = Position(32392, 32497, 7)  -- other side

function depotdoorBounacAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not player:isPlayer() then return false end

    local currentY = player:getPosition().y

    if currentY == POS_B.y then
        player:teleportTo(POS_A)
    else
        player:teleportTo(POS_B)
    end

    return true
end

depotdoorBounacAction:aid(59606)
depotdoorBounacAction:register()
