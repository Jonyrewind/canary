local robberyCities = {
    {name = "Thais", boss = "Jesse the Wicked", position = Position(32374, 32220, 11)},
    {name = "Carlin", boss = "Robby the Reckless", position = Position(32198, 31809, 9)},
    {name = "Venore", boss = "Mornenion", position = Position(33087, 32158, 7)},
    {name = "Ab'Dendriel", boss = "Elvira Hammerthrust", position = Position(32511, 31909, 11)},
}

local eventKey = "bankRobberyData" -- Single KV key storing all data

-- Function to Get or Initialize Bank Robbery Data
local function getBankRobberyData()
    local data = KV.get(eventKey)
    if not data then
        data = {city = nil, active = 0, completed = 0}
        KV.set(eventKey, data)
    end
    return data
end

-- Function to Save Bank Robbery Data
local function saveBankRobberyData(data)
    KV.set(eventKey, data)
end

-- Event: Start Robbery Randomly on Startup or Restore If Active
local startupEvent = GlobalEvent("BankRobberyStartup")
function startupEvent.onStartup()
    local data = getBankRobberyData()
	
    -- ✅ Reset the daily server save flag
    KV.remove("isDailyServerSave")
	
    -- ✅ If the robbery was completed, reset the KV storage
    if data.active == 1 and data.completed == 1 then
        kv.remove(eventKey) -- Completely remove event data
        logger.info("[World Change] Previous Bank Robbery was completed. Resetting event data.")
    end

    -- ✅ If robbery was active but not completed, restore it
    if data.active == 1 and data.completed == 0 then
        for _, city in pairs(robberyCities) do
            if city.name == data.city then
				local spawnboss = Game.createMonster(selectedCity.boss),
                addEvent(spawnboss, 10000, selectedCity.position)
                logger.info("[World Change] Resuming Bank Robbery in {}! Thief: {}", city.name, city.boss)
                return true
            end
        end
    end

    -- ✅ Otherwise, start a new robbery with a 33% chance
    if math.random(1, 3) == 1 then
        local selectedCity = robberyCities[math.random(#robberyCities)]
        local newData = {city = selectedCity.name, active = 1, completed = 0}
        saveBankRobberyData(newData)

        -- Spawn the boss (thief)
		local spawnboss = Game.createMonster(selectedCity.boss),
		addEvent(spawnboss, 10000, selectedCity.position)

        -- Log the event
        logger.info("[World Change] Bank Robbery has started in {}! Thief: {}", selectedCity.name, selectedCity.boss)
    end
    return true
end
startupEvent:register()

-- Event: Cleanup KV Storage on Server Shutdown (ONLY if event was incomplete)
local cleanupEvent = GlobalEvent("BankRobberyCleanup")
function cleanupEvent.onShutdown()
    local data = getBankRobberyData()
    local isDailySave = KV.get("isDailyServerSave") -- Check if it was a scheduled daily save

    if isDailySave then
        -- ✅ Daily server save: Reset robbery event
        kv.remove(eventKey)
        KV.remove("isDailyServerSave")
        logger.info("[World Change] Daily Server Save detected. Resetting Bank Robbery event.")
    else
        -- ✅ Manual restart: Keep robbery event
        logger.info("[World Change] Manual restart detected. Keeping Bank Robbery event active.")
    end
    return true
end
cleanupEvent:register()


-- ✅ Ensure kvWorldChanges exists globally
if not kvWorldChanges then
    kvWorldChanges = {}
end

-- ✅ Insert Bank Robbery Messages into Global KV Table
table.insert(kvWorldChanges, {
    name = "bankRobbery",
    getMessages = function()
        local data = getBankRobberyData()
        if data.active == 1 and data.city then
            return {
                worldBoard = "Several banks in major coastal towns are being robbed! The thieves are still on the loose!",
                towncryer = "Hear ye! Hear ye! Stand and deliver! That's what they shout, robbing banks in " .. data.city .. " and then hide out. Catch the thieves and make us proud, bring back the gold to please the crowd!"
            }
        end
        return nil
    end
})
