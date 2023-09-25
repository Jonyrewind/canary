--configuration table
local config = {
    cooldownTime = 72000, --time in seconds that player will be Exhausted
    cooldownStorage = 43000, --storage to hold the cooldown of Exhaustion
    pearlRewards = {281, 282}, --table with itemIds of the possible rewards
    closedShellItemId = 197, --closed shell itemId
    openShellItemId = 198, --open shell itemId
}

local largeSeashell = Action()

function largeSeashell.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == config.closedShellItemId then
        if player:getStorageValue(config.cooldownStorage) <= os.time() then --Check if player has Exhaustion and itemid is a closed shell itemid
            local chance = math.random(100)--get a random number from 1 to 100
            local msg = ""
            if chance <= 16 then --finger 16% chance
                player:addHealth(-200)
                msg = "Ouch! You squeezed your fingers."
            elseif chance > 16 and chance <= 64 then --pearl 48% chance
                --select a random reward from pearlRewards table, looking from 1 index to last index
                local selectedReward = math.random(config.pearlRewards[1], config.pearlRewards[#config.pearlRewards])
                Game.createItem(selectedReward, 1, player:getPosition()) --create the selected reward at player position
                msg = "You found a beautiful pearl."
            else --nothing remaning 36% chance
                msg = "Nothing is inside."
            end
            player:say(msg, TALKTYPE_MONSTER_SAY, false, player, item:getPosition())
            item:transform(config.openShellItemId) --transform the closed shell in a open shell
			item:decay()
            player:setStorageValue(config.cooldownStorage, os.time() + config.cooldownTime) --set Exhaustion to player
            item:getPosition():sendMagicEffect(CONST_ME_BUBBLES) --for bubble effects
            return true
        else
			player:say("You have already opened a shell today.", TALKTYPE_MONSTER_SAY, false, player, item:getPosition())
--            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already opened a shell today.")
            return false
        end
    end
    return false
end

largeSeashell:id(197)
largeSeashell:register()