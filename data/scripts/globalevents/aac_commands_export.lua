-- AAC dynamic Commands export (Lua -> data/json/commands/commands.json)
-- Reads:  Game.getTalkActions()
-- Output:
--   { "commands": [ { "words": "...", "description": "..." }, ... ] }

local function escape_json_str(s)
	s = tostring(s or "")
	s = s:gsub('\\', '\\\\')
	s = s:gsub('"', '\\"')
	s = s:gsub('\r', '\\r')
	s = s:gsub('\n', '\\n')
	s = s:gsub('\t', '\\t')
	return s
end

local function ensureDir(dirPath)
	-- Works without extra Lua modules (lfs). Best-effort only.
	-- Windows:  package.config path separator is '\'
	-- *nix/mac: package.config path separator is '/'
	local sep = package.config:sub(1, 1)
	if sep == '\\' then
		-- mkdir dir >nul 2>nul
		os.execute('mkdir "' .. dirPath .. '" >NUL 2>NUL')
	else
		-- mkdir -p dir 2>/dev/null
		os.execute('mkdir -p "' .. dirPath .. '" 2>/dev/null')
	end
end

local function exportCommandsToAACFile()
	local sep = package.config:sub(1, 1)
	local outDir = "data/json/commands"
	if sep == '\\' then
		outDir = outDir:gsub("/", "\\")
	end
	local outPath = outDir .. sep .. "commands.json"

	ensureDir(outDir)

	local allTalkActions = Game.getTalkActions()
	local rows = {}

	-- Match the existing `!commands` intent:
	-- - Only include talkactions with a non-zero groupType
	-- - Your in-game page further filters by player group.
	--   Here we export broadly (<=255) so the website can display them.
	for _, talkaction in pairs(allTalkActions) do
		-- Normal players only:
		-- GroupType mapping (from C++ GroupType enum):
		--   normal = 1
		--   gamemaster = 4
		--   god = 6
		-- We only export GROUP_TYPE_NORMAL.
		if talkaction:getGroupType() == 1 then
			local words = talkaction:getName()
			if words and words ~= "" then
				local description = talkaction:getDescription()
				if description == nil then
					description = ""
				end

				rows[#rows + 1] = {
					words = words,
					description = description
				}
			end
		end
	end

	table.sort(rows, function(a, b)
		return tostring(a.words) < tostring(b.words)
	end)

	-- Build JSON manually (to avoid dependency on a json Lua module)
	local json = '{"commands":['
	for i = 1, #rows do
		local r = rows[i]
		json = json .. '{"words":"' .. escape_json_str(r.words) .. '","description":"' .. escape_json_str(r.description) .. '"}'
		if i < #rows then
			json = json .. ','
		end
	end
	json = json .. ']}'

	local f = io.open(outPath, 'w')
	if not f then
		logger.error("[AAC commands export] Failed to open output file: {}", outPath)
		return 0
	end

	f:write(json)
	f:close()

	logger.info("[AAC commands export] Wrote {} command rows to {}", #rows, outPath)
	return #rows
end

local aacCommandsExport = GlobalEvent("AAC Commands Export")

function aacCommandsExport.onStartup()
	-- Best effort: never hard-fail startup.
	exportCommandsToAACFile()
end

aacCommandsExport:register()

-- God-only manual trigger for live testing (no restart needed)
local exportCommandsGod = TalkAction("/aac_export_commands")

function exportCommandsGod.onSay(player, words, param)
	local count = exportCommandsToAACFile()
	if count and count > 0 then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "AAC commands export done. Rows: " .. count .. ".")
	else
		player:sendCancelMessage("AAC commands export failed (rows=0). Check server logs.")
	end
	return true
end

exportCommandsGod:setDescription("Exports normal-player AAC commands to data/json/commands/commands.json")
exportCommandsGod:groupType("god")
exportCommandsGod:register()
