TwistedWaters = {
	kv = KV.scoped("worldchanges"):scoped("twistedwaters"),
	corpseThreshold = 1000,
	fishThreshold = 1000,
	mapPath = "data-otservbr-global/world/world_changes/twisted_waters/",
}

local STATE_CLEAN = "clean"
local STATE_PENDING_DIRTY = "pending_dirty"
local STATE_DIRTY = "dirty"
local STATE_PENDING_CLEAN = "pending_clean"

local function getState()
	return TwistedWaters.kv:get("state") or STATE_CLEAN
end

local function setState(value)
	TwistedWaters.kv:set("state", value)
end

local function isState(value)
	return getState() == value
end

local function isClean()
	return isState(STATE_CLEAN)
end

local function isPendingDirty()
	return isState(STATE_PENDING_DIRTY)
end

local function isDirty()
	return isState(STATE_DIRTY)
end

local function isPendingClean()
	return isState(STATE_PENDING_CLEAN)
end

local function getCorpseCount()
	return TwistedWaters.kv:get("corpsecount") or 0
end

local function setCorpseCount(value)
	TwistedWaters.kv:set("corpsecount", math.max(0, value))
end

local function getFishCount()
	return TwistedWaters.kv:get("fishcount") or 0
end

local function setFishCount(value)
	TwistedWaters.kv:set("fishcount", math.max(0, value))
end

function TwistedWaters.markPendingClean()
	setState(STATE_PENDING_CLEAN)
	logger.info("[World Change] Twisted Waters reached fishing threshold. Lake Equivocolao will become clean after next server save.")
end

local function markPendingDirty()
	if isPendingDirty() or isDirty() then
		return
	end

	setState(STATE_PENDING_DIRTY)
	logger.info("[World Change] Twisted Waters reached corpse threshold. Lake Equivocolao will become dirty after next server save.")
end

local function promoteStateIfPending()
	if isPendingDirty() then
		setState(STATE_DIRTY)
		setCorpseCount(0)
		logger.info("[World Change] Twisted Waters promoted to DIRTY on server save.")
	elseif isPendingClean() then
		setState(STATE_CLEAN)
		setFishCount(0)
		logger.info("[World Change] Twisted Waters promoted to CLEAN on server save.")
	end
end

local function incrementCorpseCount()
	local newCount = getCorpseCount() + 1
	setCorpseCount(newCount)
	return newCount
end

local function incrementFishCount()
	local fishCount = getFishCount() + 1
	setFishCount(fishCount)
	if fishCount >= TwistedWaters.fishThreshold then
		TwistedWaters.markPendingClean()
	end
end

local function getPlayerTwistedWatersKv(player)
	return player:kv():scoped("worldchanges"):scoped("twistedwaters")
end

function TwistedWaters.tryFish(player, item, fromPosition, target, toPosition)
	if getState() ~= STATE_DIRTY then
		return false
	end

	toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)

	local rareChance = math.random(100)
	if rareChance == 1 then
		local playerKv = getPlayerTwistedWatersKv(player)
		local lastCatch = playerKv:get("fishing.shimmer-swimmer-last") or 0
		if os.time() - lastCatch < 20 * 60 * 60 then
			return true
		end

		playerKv:set("fishing.shimmer-swimmer-last", os.time())
		player:addItemContainer(12557, 1, fromPosition, item)
		player:sendTextMessage(MESSAGE_FAILURE, "A Shimmer Swimmer! It is said that this rare creature only appears once each day in the murkiest of waters!")
		player:addAchievementProgress("Biodegradable", 50)
		incrementFishCount()
		return true
	end

	player:addItemContainer(3111, 1, fromPosition, item)
	incrementFishCount()
	return true
end

local TwistedWatersStartUp = GlobalEvent("TwistedWatersStartUp")

function TwistedWatersStartUp.onCustomMapStartup()
	if isDirty() then
		Game.loadCustomMaps(TwistedWaters.mapPath)
		logger.info("[World Change] Twisted Waters dirty map loaded on startup.")
	end
	return true
end

TwistedWatersStartUp:register()

local TwistedWatersShutDown = GlobalEvent("TwistedWatersShutDown")

function TwistedWatersShutDown.onShutdown()
	promoteStateIfPending()
	return true
end

TwistedWatersShutDown:register()

local TwistedWatersCorpse = MoveEvent()

function TwistedWatersCorpse.onAddItem(moveitem, tileitem, position)
	if not ItemType(moveitem:getId()):isCorpse() then
		return true
	end

	if not isClean() and not isPendingDirty() then
		return true
	end

	position:sendMagicEffect(CONST_ME_WATERSPLASH)

	local corpseCount = incrementCorpseCount()
	if corpseCount < TwistedWaters.corpseThreshold then
		return true
	end

	markPendingDirty()
	return true
end

TwistedWatersCorpse:type("additem")
TwistedWatersCorpse:aid(2200)
TwistedWatersCorpse:register()
