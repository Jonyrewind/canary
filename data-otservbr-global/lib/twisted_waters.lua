TwistedWatersState = {
	KV = KV.scoped("worldchanges"):scoped("twistedwaters"),
	CLEAN = "clean",
	PENDING_DIRTY = "pending_dirty",
	DIRTY = "dirty",
	PENDING_CLEAN = "pending_clean",
}

function TwistedWatersState.get()
	return TwistedWatersState.KV:get("state") or TwistedWatersState.CLEAN
end

function TwistedWatersState.set(value)
	TwistedWatersState.KV:set("state", value)
end

function TwistedWatersState.is(value)
	return TwistedWatersState.get() == value
end

function TwistedWatersState.isClean()
	return TwistedWatersState.is(TwistedWatersState.CLEAN)
end

function TwistedWatersState.isPendingDirty()
	return TwistedWatersState.is(TwistedWatersState.PENDING_DIRTY)
end

function TwistedWatersState.isDirty()
	return TwistedWatersState.is(TwistedWatersState.DIRTY)
end

function TwistedWatersState.isPendingClean()
	return TwistedWatersState.is(TwistedWatersState.PENDING_CLEAN)
end

function TwistedWatersState.markPendingDirty()
	if TwistedWatersState.isPendingDirty() or TwistedWatersState.isDirty() then
		return false
	end

	TwistedWatersState.set(TwistedWatersState.PENDING_DIRTY)
	return true
end

function TwistedWatersState.markPendingClean()
	if TwistedWatersState.isPendingClean() then
		return false
	end

	TwistedWatersState.set(TwistedWatersState.PENDING_CLEAN)
	return true
end

function TwistedWatersState.promotePendingState()
	if TwistedWatersState.isPendingDirty() then
		TwistedWatersState.set(TwistedWatersState.DIRTY)
		return TwistedWatersState.DIRTY
	elseif TwistedWatersState.isPendingClean() then
		TwistedWatersState.set(TwistedWatersState.CLEAN)
		return TwistedWatersState.CLEAN
	end

	return nil
end
