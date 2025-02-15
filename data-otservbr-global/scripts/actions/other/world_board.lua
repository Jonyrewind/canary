local worldBoard = Action()

-- ✅ Function to Get All World Change Messages (From Storage + KV)
local function getWorldBoardMessages()
    local messages = {}

    -- ✅ Fetch static storage-based messages
    local worldChanges = {
        { text = "A fiery fury gate has opened near one of the major cities somewhere in Tibia.", storage = GlobalStorage.FuryGates },
        { text = "Oriental ships sighted! A trader for exotic creature products may currently be visiting Carlin, Ankrahmun or Liberty Bay.", storage = GlobalStorage.Yasir },
        { text = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the Ankrahmun tar pits!", storage = GlobalStorage.WorldBoard.NightmareIsle.AnkrahmunNorth },
        { text = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the northernmost coast!", storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaNorth },
        { text = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the river near Drefia!", storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaWest },
    }

    for _, change in pairs(worldChanges) do
        if Game.getStorageValue(change.storage) > 0 then
            table.insert(messages, change.text)
        end
    end

    -- ✅ Fetch dynamic KV-based messages (like bank robbery)
    if kvWorldChanges then
        for _, entry in ipairs(kvWorldChanges) do
            local msgData = entry.getMessages()
            if msgData and msgData.worldBoard then
                table.insert(messages, msgData.worldBoard)
            end
        end
    end

    return messages
end

-- ✅ Function That Runs When a Player Uses the World Board
function worldBoard.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local messages = getWorldBoardMessages()
    
    if #messages > 0 then
        for _, msg in ipairs(messages) do
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There is no news to report at the moment.")
    end

    return true
end

worldBoard:id(19236)
worldBoard:register()
