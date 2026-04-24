-- ikemenversion: 1.0
--;===========================================================
--; RATIO MODE
--;===========================================================

local function normalizePath(path)
	return searchFile(path, {'', 'external/mods/ratio/', motif.def, 'data/'})
end

local ratio = {}
local configPath = 'external/mods/ratio/config.ini'
local config = loadIni(configPath, false)
local system = loadIni(normalizePath(config.Files.defaults), true, true)
local systemOverridePath = normalizePath(config.Files.system)
if systemOverridePath ~= '' then
	system = main.f_tableMerge(system, loadIni(systemOverridePath, true, true))
end

local sff = motif.Sff
local spr = normalizePath(config.Files.spr)
if normalizePath(motif.files.spr) ~= spr then
	sff = sffNew(spr)
end
local animTable = motif.AnimTable
if normalizePath(gameOption('Config.Motif')) ~= systemOverridePath then
	animTable = loadAnimTable(normalizePath(config.Files.air), sff)
end

main.f_appendItemname(motif.option_info.menu, 'menugame', 'menuratio', system.option_info.menu.itemname.menugame.menuratio, 'back')
main.f_appendItemname(motif.select_info.teammenu, 'default', 'ratio', system.select_info.teammenu.itemname.ratio)

--;===========================================================
--; COMMON HELPERS
--;===========================================================

-- Adds fallback arcade Ratio roster settings.
local function ensureDefaultRatioMatches()
	if main.t_selOptions.arcaderatiomatches == nil then
		main.t_selOptions.arcaderatiomatches = {
			{rmin = 1, rmax = 3, order = 1},
			{rmin = 3, rmax = 3, order = 1},
			{rmin = 2, rmax = 2, order = 1},
			{rmin = 2, rmax = 2, order = 1},
			{rmin = 1, rmax = 1, order = 2},
			{rmin = 3, rmax = 3, order = 1},
			{rmin = 1, rmax = 2, order = 3},
		}
	end
end

-- Maps Ratio preset number to per-member Ratio levels.
local t_ratioArray = {
	{2, 1, 1},
	{1, 2, 1},
	{1, 1, 2},
	{2, 2},
	{3, 1},
	{1, 3},
	{4}
}

-- Returns team size required by a Ratio preset.
local function ratioNumChars(numRatio)
	if numRatio == nil then
		return nil
	elseif numRatio <= 3 then
		return 3
	elseif numRatio <= 6 then
		return 2
	end
	return 1
end

-- Picks a valid random Ratio preset for a team size.
local function randomNumRatio(numChars)
	if numChars == 3 then
		return math.random(1, 3)
	elseif numChars == 2 then
		return math.random(4, 6)
	end
	return 7
end

-- Formats Ratio multipliers as percentage deltas.
local function ratioDisplay(value)
	local ret = tonumber(string.format('%.01f', (value - 1) * 100))
	if ret >= 0 then
		return '+' .. ret .. '%'
	end
	return ret .. '%'
end

-- Assigns Ratio level to a selected team member.
local function assignRatioLevel(side, member, entry)
	if entry == nil then
		return
	end
	if not start.p[side].ratio then
		entry.ratioLevel = nil
		return
	end
	if ratioNumChars(start.p[side].numRatio) ~= start.p[side].numChars then
		start.p[side].numRatio = randomNumRatio(start.p[side].numChars)
	end
	entry.ratioLevel = t_ratioArray[start.p[side].numRatio][member]
end

-- Parses select.def *.ratiomatches entries.
local function parseRatioMatches(targetKey, raw)
	main.t_selOptions[targetKey] = {}
	for _, c in ipairs(main.f_strsplit(',', raw:gsub('%s*(.-)%s*', '%1'))) do
		local rmin, rmax, order = c:match('^%s*([0-9]+)-?([0-9]*)%s*:%s*([0-9]+)%s*$')
		rmin = tonumber(rmin)
		rmax = tonumber(rmax) or rmin
		order = tonumber(order)
		if rmin == nil or order == nil or rmin < 1 or rmin > 4 or rmax < 1 or rmax > 4 or rmin > rmax then
			main.f_warning(system.warning_info.text.ratio.text, motif.title_info, motif.titlebgdef)
			main.t_selOptions[targetKey] = nil
			return
		end
		table.insert(main.t_selOptions[targetKey], {rmin = rmin, rmax = rmax, order = order})
	end
end

--;===========================================================
--; CHARACTER / SELECT.DEF HOOKS
--;===========================================================

-- Resolves optional character-specific ratio script path.
hook.add("main.f_addChar.files", "ratio", function(char)
	if char.ratiopath ~= nil and char.ratiopath ~= '' then
		char.ratiopath = searchFile(char.ratiopath, {char.dir, '', motif.def, 'data/'})
	end
end)

-- Parses *.ratiomatches entries from [Options] in select.def.
hook.add("main.selectDef.options", "ratio", function(t_selOptions, lineCase)
	if not lineCase:match('%.ratiomatches%s*=') then
		return
	end
	local rowName, raw = lineCase:match('^%s*(.-)%.ratiomatches%s*=%s*(.+)')
	if rowName == nil then
		return
	end
	rowName = rowName:gsub('%.', '_')
	parseRatioMatches(rowName .. 'ratiomatches', raw)
end)

-- Ensures default ratio roster settings exist after select.def is loaded.
hook.add("main.selectDef.defaults", "ratio", function(t_selOptions)
	ensureDefaultRatioMatches()
end)
ensureDefaultRatioMatches()

hook.add("launchFight", "ratio", function(common)
	if not (start.p[1].ratio or start.p[2].ratio) or type(config.Common) ~= 'table' then
		return
	end
	for k, values in pairs(config.Common) do
		local key = k:lower()
		if common[key] == nil then
			common[key] = {}
		end
		local existing = {}
		for _, v in ipairs(common[key]) do
			existing[v] = true
		end
		if type(values) == 'string' then
			if values ~= '' and not existing[values] then
				table.insert(common[key], values)
			end
		elseif type(values) == 'table' then
			for _, v in ipairs(values) do
				if v ~= '' and not existing[v] then
					table.insert(common[key], v)
					existing[v] = true
				end
			end
		end
	end
end)

--;===========================================================
--; MODE INTEGRATION
--;===========================================================

-- Enables Ratio team mode in supported game modes.
hook.add("main.t_itemname", "ratio", function(t, item)
	local itemname = t and t[item] and t[item].itemname or ''
	local mode = gameMode()
	if mode == 'arcade' and main.teamarcade then
		main.teamMenu[1].ratio = true
		main.teamMenu[2].ratio = true
	elseif mode == 'freebattle' or mode == 'netplayversus' or mode == 'survival' or mode == 'watch' or mode == 'timeattack' then
		main.teamMenu[1].ratio = true
		main.teamMenu[2].ratio = true
	elseif mode == 'training' then
		main.teamMenu[1].ratio = true
	elseif mode == 'teamcoop' or mode == 'netplayteamcoop' or mode == 'survivalcoop' or mode == 'netplaysurvivalcoop' then
		main.teamMenu[2].ratio = true
	elseif (mode == 'versus' or mode == 'challenger') and (itemname == 'teamversus' or main.teamarcade) then
		main.teamMenu[1].ratio = true
		main.teamMenu[2].ratio = true
	end
end)

--;===========================================================
--; ROSTER / AI RAMP OVERRIDES
--;===========================================================

-- Overrides arcade/teamcoop/netplayteamcoop/timeattack roster generation when
-- Ratio mode is selected for the opponent team.
local oldArcadeMakeRoster = start.t_makeRoster.arcade
start.t_makeRoster.arcade = function()
	if start.p[2].ratio then
		local matches = nil
		local p1 = start.p[1].t_selected[1]
		local char = p1 and start.f_getCharData(p1.ref) or nil
		local key = char and char.ratiomatches or nil
		if key ~= nil then
			matches = main.t_selOptions[key .. '_arcaderatiomatches']
		end
		matches = matches or main.t_selOptions.arcaderatiomatches
		if type(matches) == "table" then
			return matches, main.t_orderChars
		end
	end
	return oldArcadeMakeRoster()
end
start.t_makeRoster.teamcoop = start.t_makeRoster.arcade
start.t_makeRoster.netplayteamcoop = start.t_makeRoster.arcade
start.t_makeRoster.timeattack = start.t_makeRoster.arcade

-- Uses ratio-specific AI ramp settings when Ratio mode is selected.
local oldArcadeAiRamp = start.t_aiRampData.arcade
start.t_aiRampData.arcade = function()
	if start.p[2].ratio then
		return config.Arcade.ratio.AIramp.start[1], config.Arcade.ratio.AIramp.start[2], config.Arcade.ratio.AIramp['end'][1], config.Arcade.ratio.AIramp['end'][2]
	end
	return oldArcadeAiRamp()
end
start.t_aiRampData.teamcoop = start.t_aiRampData.arcade
start.t_aiRampData.netplayteamcoop = start.t_aiRampData.arcade
start.t_aiRampData.timeattack = start.t_aiRampData.arcade

--;===========================================================
--; CHARACTER-SPECIFIC RATIO LUA PATH
--;===========================================================

-- Allows characters to redirect arcadepath to a ratio-specific lua script.
hook.add("start.f_selectMode.luaPath", "ratio", function(path)
	if not main.charparam.arcadepath or not start.p[2].ratio then
		return nil
	end
	local char = start.f_getCharData(start.p[1].t_selected[1].ref)
	if char ~= nil and char.ratiopath ~= nil and char.ratiopath ~= '' then
		return char.ratiopath
	end
end)

--;===========================================================
--; TEAM MENU INTEGRATION
--;===========================================================

-- Appends the Ratio entry to the team menu when enabled for the current side.
hook.add("start.selectScreen.teamMenu", "ratio", function(side, list, params, itemname_order)
	if not main.teamMenu[side].ratio then
		return
	end
	for _, name in ipairs(itemname_order) do
		if name == 'ratio' then
			table.insert(list, {itemname = 'ratio', displayname = params.ratio, mode = 2})
			break
		end
	end
end)

-- Handles left/right input while the Ratio entry is selected.
hook.add("start.f_teamMenu.input", "ratio", function(side, t, t_cmd)
	local cur = t[start.p[side].teamMenu]
	if cur == nil or cur.itemname ~= 'ratio' then
		return nil
	end
	if getInput(t_cmd, motif.select_info['p' .. side].teammenu.subtract.key) and main.selectMenu[side] then
		sndPlay(motif.Snd, motif.select_info['p' .. side].teammenu.value.snd[1], motif.select_info['p' .. side].teammenu.value.snd[2])
		if start.p[side].numRatio > 1 then
			start.p[side].numRatio = start.p[side].numRatio - 1
		else
			start.p[side].numRatio = 7
		end
		return true
	elseif getInput(t_cmd, motif.select_info['p' .. side].teammenu.add.key) and main.selectMenu[side] then
		sndPlay(motif.Snd, motif.select_info['p' .. side].teammenu.value.snd[1], motif.select_info['p' .. side].teammenu.value.snd[2])
		if start.p[side].numRatio < 7 then
			start.p[side].numRatio = start.p[side].numRatio + 1
		else
			start.p[side].numRatio = 1
		end
		return true
	end
end)

-- Draws the ratio icon corresponding to the currently selected ratio layout.
local function loadAnimData(data, side)
	local a
	if data.anim >= 0 then
		a = animNew(sff, animTable[data.anim])
	else
		a = animNew(sff, data.spr[1] .. ',' .. data.spr[2] .. ', 0,0, -1')
	end
	if data.localcoord ~= nil and data.localcoord ~= '' then
		animSetLocalcoord(a, data.localcoord[1], data.localcoord[2])
	else
		animSetLocalcoord(a, system.info.localcoord[1], system.info.localcoord[2])
	end
	
	local params = motif.select_info['p' .. side].teammenu
	animSetPos(a, params.pos[1] + params.item.offset[1] + data.offset[1], params.pos[2] + params.item.offset[2] + data.offset[2])
	animSetScale(a, data.scale[1], data.scale[2])
	animSetFacing(a, data.facing)
	animSetXShear(a, data.xshear)
	animSetAngle(a, data.angle)
	animSetXAngle(a, data.xangle)
	animSetYAngle(a, data.yangle)
	animSetProjection(a, data.projection)
	animSetFocalLength(a, data.focallength)
	animSetWindow(a, data.window[1], data.window[2], data.window[3], data.window[4])
	animSetLayerno(a, data.layerno)
	--animDebug(a)
	return a
end

hook.add("start.f_teamMenu.drawItemValue", "ratio", function(side, t, i, x, y)
	if t[i].itemname ~= 'ratio' or start.p[side].teamMenu ~= i or not main.selectMenu[side] then
		return nil
	end
	local icon = system.select_info['p' .. side].teammenu['ratio' .. start.p[side].numRatio].icon
	if icon.AnimData == nil then
		icon.AnimData = loadAnimData(icon, side)
	end
	main.f_animPosDraw(icon.AnimData, x, y)
	return true
end)

-- Confirms Ratio menu selection and converts it to proper team mode data.
hook.add("start.f_teamMenu.confirm", "ratio", function(side, t)
	local cur = t[start.p[side].teamMenu]
	if cur == nil or cur.itemname ~= 'ratio' then
		return nil
	end
	local numChars = 1
	if start.p[side].numRatio <= 3 then
		numChars = 3
	elseif start.p[side].numRatio <= 6 then
		numChars = 2
	end
	return {teamMode = cur.mode, numChars = numChars, ratio = true}
end)

--;===========================================================
--; SELECT STATE PERSISTENCE
--;===========================================================

-- Initializes Ratio-related select state.
hook.add("start.f_selectReset.side", "ratio", function(side, hardReset, preserveProgress, state)
	if hardReset then
		state.numRatio = 1
	end
	state.ratio = false
end)

-- Preserves ratio selection after challenger takeover.
hook.add("start.f_selectChallenger.resume", "ratio", function(resume, winnerSide, challengerState)
	local srcSide = challengerState.p and challengerState.p[winnerSide] or nil
	if srcSide == nil then
		return
	end
	resume.p[1].numRatio = srcSide.numRatio
end)

--;===========================================================
--; SELECT / LAUNCH HOOKS
--;===========================================================

-- Assign ratio levels while characters are being selected.
hook.add("start.f_selectMenu.selected", "ratio", function(side, member, entry)
	assignRatioLevel(side, member, entry)
end)

-- Assign ratio levels for characters injected directly through launchFight().
hook.add("start.launchFight.selected", "ratio", function(side, member, entry)
	assignRatioLevel(side, member, entry)
end)

-- Exposes Ratio data through per-player maps.
hook.add("start.f_selectLoading.member", "ratio", function(v)
	local lifeRatio, attackRatio
	if v.ratioLevel then
		lifeRatio = config.Options.Ratio['Level' .. v.ratioLevel].Life
		attackRatio = config.Options.Ratio['Level' .. v.ratioLevel].Attack
	end
	if v.maps == nil then
		v.maps = {}
	end
	v.maps.ratiolevel = v.ratioLevel
	v.maps.liferatio = v.lifeRatio or lifeRatio
	v.maps.attackratio = v.attackRatio or attackRatio
end)

--;===========================================================
--; LIFE RECOVERY
--;===========================================================

-- Overrides default between-match recovery for Ratio mode members.
hook.add("start.f_lifeRecovery", "ratio", function(lifeMax, fighter)
	local ratioLevel = fighter and fighter.RatioLevel or 0
	if ratioLevel <= 0 then
		return nil
	end
	local bonus = lifeMax * config.Options.Ratio.Recovery.Bonus / 100
	local base = lifeMax * config.Options.Ratio.Recovery.Base / 100
	return base + main.f_round(timeRemaining() / (timeRemaining() + timeElapsed()) * bonus)
end)

--;===========================================================
--; DEFAULT RATIO OPTIONS
--;===========================================================

-- Restores default ratio gameplay settings when the player chooses
-- "Default Values" in Options.
hook.add("options.default", "ratio", function()
	config.Options.Ratio.Recovery.Base = 0
	config.Options.Ratio.Recovery.Bonus = 20
	config.Options.Ratio.Level1.Attack = 0.82
	config.Options.Ratio.Level2.Attack = 1.0
	config.Options.Ratio.Level3.Attack = 1.17
	config.Options.Ratio.Level4.Attack = 1.30
	config.Options.Ratio.Level1.Life = 0.80
	config.Options.Ratio.Level2.Life = 1.0
	config.Options.Ratio.Level3.Life = 1.17
	config.Options.Ratio.Level4.Life = 1.40
	options.modified = true
end)

hook.add("options.save", "ratio", function()
	saveIni(config, configPath)
end)

--;===========================================================
--; OPTIONS MENU HANDLERS
--;===========================================================

-- Ratio attack option handlers.
options.t_itemname['ratio1attack'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level1.Attack = config.Options.Ratio.Level1.Attack + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level1.Attack)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level1.Attack > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level1.Attack = config.Options.Ratio.Level1.Attack - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level1.Attack)
		options.modified = true
	end
	return true
end
options.t_itemname['ratio2attack'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level2.Attack = config.Options.Ratio.Level2.Attack + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level2.Attack)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level2.Attack > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level2.Attack = config.Options.Ratio.Level2.Attack - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level2.Attack)
		options.modified = true
	end
	return true
end
options.t_itemname['ratio3attack'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level3.Attack = config.Options.Ratio.Level3.Attack + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level3.Attack)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level3.Attack > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level3.Attack = config.Options.Ratio.Level3.Attack - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level3.Attack)
		options.modified = true
	end
	return true
end
options.t_itemname['ratio4attack'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level4.Attack = config.Options.Ratio.Level4.Attack + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level4.Attack)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level4.Attack > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level4.Attack = config.Options.Ratio.Level4.Attack - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level4.Attack)
		options.modified = true
	end
	return true
end

-- Ratio life option handlers.
options.t_itemname['ratio1life'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level1.Life = config.Options.Ratio.Level1.Life + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level1.Life)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level1.Life > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level1.Life = config.Options.Ratio.Level1.Life - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level1.Life)
		options.modified = true
	end
	return true
end
options.t_itemname['ratio2life'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level2.Life = config.Options.Ratio.Level2.Life + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level2.Life)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level2.Life > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level2.Life = config.Options.Ratio.Level2.Life - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level2.Life)
		options.modified = true
	end
	return true
end
options.t_itemname['ratio3life'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level3.Life = config.Options.Ratio.Level3.Life + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level3.Life)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level3.Life > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level3.Life = config.Options.Ratio.Level3.Life - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level3.Life)
		options.modified = true
	end
	return true
end
options.t_itemname['ratio4life'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level4.Life = config.Options.Ratio.Level4.Life + 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level4.Life)
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Level4.Life > 0.01 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Level4.Life = config.Options.Ratio.Level4.Life - 0.01
		t.items[item].vardisplay = ratioDisplay(config.Options.Ratio.Level4.Life)
		options.modified = true
	end
	return true
end

-- Ratio recovery option handlers.
options.t_itemname['ratiorecoverybase'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) and config.Options.Ratio.Recovery.Base < 100 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Recovery.Base = config.Options.Ratio.Recovery.Base + 0.5
		t.items[item].vardisplay = tostring(config.Options.Ratio.Recovery.Base) .. '%'
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Recovery.Base > 0 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Recovery.Base = config.Options.Ratio.Recovery.Base - 0.5
		t.items[item].vardisplay = tostring(config.Options.Ratio.Recovery.Base) .. '%'
		options.modified = true
	end
	return true
end
options.t_itemname['ratiorecoverybonus'] = function(t, item)
	if getInput(-1, motif.option_info.menu.add.key) and config.Options.Ratio.Recovery.Bonus < 100 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Recovery.Bonus = config.Options.Ratio.Recovery.Bonus + 0.5
		t.items[item].vardisplay = tostring(config.Options.Ratio.Recovery.Bonus) .. '%'
		options.modified = true
	elseif getInput(-1, motif.option_info.menu.subtract.key) and config.Options.Ratio.Recovery.Bonus > 0 then
		sndPlay(motif.Snd, motif.option_info.cursor.move.snd[1], motif.option_info.cursor.move.snd[2])
		config.Options.Ratio.Recovery.Bonus = config.Options.Ratio.Recovery.Bonus - 0.5
		t.items[item].vardisplay = tostring(config.Options.Ratio.Recovery.Bonus) .. '%'
		options.modified = true
	end
	return true
end

-- Ratio option value displays.
options.t_vardisplay['ratio1attack'] = function() return ratioDisplay(config.Options.Ratio.Level1.Attack) end
options.t_vardisplay['ratio2attack'] = function() return ratioDisplay(config.Options.Ratio.Level2.Attack) end
options.t_vardisplay['ratio3attack'] = function() return ratioDisplay(config.Options.Ratio.Level3.Attack) end
options.t_vardisplay['ratio4attack'] = function() return ratioDisplay(config.Options.Ratio.Level4.Attack) end
options.t_vardisplay['ratio1life'] = function() return ratioDisplay(config.Options.Ratio.Level1.Life) end
options.t_vardisplay['ratio2life'] = function() return ratioDisplay(config.Options.Ratio.Level2.Life) end
options.t_vardisplay['ratio3life'] = function() return ratioDisplay(config.Options.Ratio.Level3.Life) end
options.t_vardisplay['ratio4life'] = function() return ratioDisplay(config.Options.Ratio.Level4.Life) end
options.t_vardisplay['ratiorecoverybase'] = function() return tostring(config.Options.Ratio.Recovery.Base) .. '%' end
options.t_vardisplay['ratiorecoverybonus'] = function() return tostring(config.Options.Ratio.Recovery.Bonus) .. '%' end

return ratio
