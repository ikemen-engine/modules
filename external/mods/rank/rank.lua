--;===========================================================
--; motif.lua
--;===========================================================
-- Here we're expanding motif table with default values that will be used if
-- these parameters are not overridden by system.def parameter assignment.
-- (dots should not be used in variable names, so they have been changed to _)
local t_base = {
	enabled = 0,
	bars_display = 0,
	snd_time = 0,
	snd = {-1, 0},
	p1_pos = {0, 0},
	p2_pos = {0, 0},
	p1_score_offset = {0, 0},
	p1_score_font = {-1, 0, 0, 255, 255, 255, -1},
	p1_score_scale = {1.0, 1.0},
	p1_score_text = '%s',
	p1_score_displaytime = 0,
	p2_score_offset = {0, 0},
	p2_score_font = {-1, 0, 0, 255, 255, 255, -1},
	p2_score_scale = {1.0, 1.0},
	p2_score_text = '%s',
	p2_score_displaytime = 0,
	p1_bg_anim = -1,
	p1_bg_spr = {},
	p1_bg_offset = {0, 0},
	p1_bg_facing = 1,
	p1_bg_scale = {1.0, 1.0},
	p1_bg_displaytime = 0,
	p2_bg_anim = -1,
	p2_bg_spr = {},
	p2_bg_offset = {0, 0},
	p2_bg_facing = 1,
	p2_bg_scale = {1.0, 1.0},
	p2_bg_displaytime = 0,
	p1_gauge_displaytime = 0,
	p2_gauge_displaytime = 0,
	p1_rank_displaytime = 0,
	p2_rank_displaytime = 0,
	p1_icon_displaytime = 0,
	p2_icon_displaytime = 0,
	p1_icon_spacing = {0, 0},
	p2_icon_spacing = {0, 0},
	--p<pn>_gauge_<type>_anim = -1,
	--p<pn>_gauge_<type>_spr = {},
	--p<pn>_gauge_<type>_offset  = {0, 0},
	--p<pn>_gauge_<type>_facing = 1,
	--p<pn>_gauge_<type>_scale = {1.0, 1.0},
	--p<pn>_gauge_<type>_window = {},
	--p<pn>_gauge_<type>_ticks = 0,
	--p<pn>_gauge_<type>_max = 0,
	--p<pn>_icon_<icon>_anim = -1,
	--p<pn>_icon_<icon>_spr = {},
	--p<pn>_icon_<icon>_offset  = {0, 0},
	--p<pn>_icon_<icon>_facing = 1,
	--p<pn>_icon_<icon>_scale = {1.0, 1.0},
	--p<pn>_rank_<num>_anim = -1,
	--p<pn>_rank_<num>_spr = {},
	--p<pn>_rank_<num>_offset  = {0, 0},
	--p<pn>_rank_<num>_facing = 1,
	--p<pn>_rank_<num>_scale = {1.0, 1.0},
}
if motif.rank_info == nil then
	motif.rank_info = {}
end
motif.rank_info = main.f_tableMerge(t_base, motif.rank_info)

-- Gauge, icon, rank spr/anim data generation.
local t_rankParams = {}
motif.rank_info.gauge = {}
motif.rank_info.icon = {}
motif.rank_info.rank = {}
for k, _ in pairs(motif.rank_info) do
	local ok = false
	if k:match('^p[1-2].+_anim$') then
		t_rankParams[k:gsub('anim$', '')] = k:match('^p([1-2])')
		ok = true
	elseif k:match('^p[1-2].+_spr$') then
		t_rankParams[k:gsub('spr$', '')] = k:match('^p([1-2])')
		ok = true
	end
	if ok then
		for _, v in ipairs({'gauge', 'icon', 'rank'}) do
			if k:match('^p[1-2]_' .. v .. '_.+_[^_]+$') then
				motif.rank_info[v][k:match('^p[1-2]_' .. v .. '_(.+)_[^_]+$')] = true
				break
			end
		end
	end
end
for k, v in pairs(t_rankParams) do
	motif.f_loadSprData(motif.rank_info, {s = k, x = motif.rank_info['p' .. v .. '_pos'][1], y = motif.rank_info['p' .. v .. '_pos'][2]})
end

-- Score font data generation.
local txt_rank_p1_score = main.f_createTextImg(motif.rank_info, 'p1_score', {x = motif.rank_info.p1_pos[1], y = motif.rank_info.p1_pos[2]})
local txt_rank_p2_score = main.f_createTextImg(motif.rank_info, 'p2_score', {x = motif.rank_info.p2_pos[1], y = motif.rank_info.p2_pos[2]})

--;===========================================================
--; Functions
--;===========================================================

-- Called by f_getRank function to update table data based on character Maps.
local function f_readMaps(t, side)
	-- For each gauge type (default: tech, guard, attack, life)
	for k, _ in pairs(motif.rank_info.gauge) do
		-- Sum collected rank points (capped with max value for this gauge)
		t.values[k] = math.min(motif.rank_info['p' .. side .. '_gauge_' .. k .. '_max'], (t.values[k] or 0) + map('_iksys_rank' .. k .. 'value'))
	end
	-- For each icon type (default: fa, p, sf, hf)
	for k, _ in pairs(motif.rank_info.icon) do
		-- Append icon entry if Map is set and the icon was not appended yet
		if not main.f_tableHasValue(t.icons, k) and map('_iksys_rankicon' .. k) ~= 0 then
			table.insert(t.icons, k)
		end
	end
end

-- This function generates a table with information about total amount of rank
-- points collected during match and icons that should be rendered. This data
-- is read from all team members Maps assigned during match via via rank.zss.
local function f_getRank(side)
	local t = {values = {}, icons = {}}
	player(side)
	f_readMaps(t, side)
	for i = 1, numpartner() do
		partner(i - 1)
		f_readMaps(t, side)
	end
	return t
end

local active = false
local rankInit = false
local counter = 0
local t_rank = {{}, {}}

-- Called by f_rank function to set initial values used during rank screen.
local function f_rankInit()
	if rankInit then
		return active
	end
	rankInit = true
	counter = 0
	if motif.rank_info.enabled == 0 or not main.rankDisplay then
		return false
	end
	-- Skip execution if any of the characters has select.def rankdisplay flag set to 0
	for side = 1, 2 do
		for _, v in ipairs(start.p[side].t_selected) do
			if start.f_getCharData(v.ref).rankdisplay == 0 then
				return false
			end
		end
	end
	for side = 1, 2 do
		-- Reset gauge, icon, rank spr/anim data
		animReset(motif.rank_info['p' .. side .. '_bg_data'])
		animUpdate(motif.rank_info['p' .. side .. '_bg_data'])
		for _, v in ipairs({'gauge', 'icon', 'rank'}) do
			for k, _ in pairs(motif.rank_info[v]) do
				if motif.rank_info['p' .. side .. '_' .. v .. '_' .. k .. '_data'] ~= nil then
					animReset(motif.rank_info['p' .. side .. '_' .. v .. '_' .. k .. '_data'])
					animUpdate(motif.rank_info['p' .. side .. '_' .. v .. '_' .. k .. '_data'])
				end
			end
		end
		-- Calculate rank
		t_rank[side].rank = f_getRank(side)
		local total = 0
		for _, v in pairs(t_rank[side].rank.values) do
			total = total + v
		end
		t_rank[side].rank.total = total
		t_rank[side].rank.grade = math.max(1, math.min(main.f_tableLength(motif.rank_info.rank), math.floor(total / 8)))
		-- Assign gauge table entries with data how much meter should be filled
		for k, _ in pairs(motif.rank_info.gauge) do
			t_rank[side]['gauge_' .. k] = {
				ratio = (t_rank[side].rank.values[k] or 0) / motif.rank_info['p' .. side .. '_gauge_' .. k .. '_max'],
				temp = 0,
			}
		end
	end
	if motif.rank_info.bars_display == 0 then
		setLifebarElements({bars = false})
	end
	active = true
	return false
end

-- Repeatedly called by f_loop function during RoundState = 4
local function f_rank()
	if not f_rankInit() then
		return
	end
	if indialogue() then
		active = false
		return
	end
	for side = 1, 2 do
		player(side) --assign sys.debugWC to player 1 or 2
		if win() or drawgame() then
			-- Draw bg
			if counter >= motif.rank_info['p' .. side .. '_bg_displaytime'] then
				animUpdate(motif.rank_info['p' .. side .. '_bg_data'])
				animDraw(motif.rank_info['p' .. side .. '_bg_data'])
			end
			-- Draw score
			local txt = {}
			if side == 1 then
				txt = txt_rank_p1_score
			else
				txt = txt_rank_p2_score
			end
			if counter >= motif.rank_info['p' .. side .. '_score_displaytime'] then
				local score = math.min(scoretotal(), scoretotal() - score() + math.ceil(score() / math.max(1, 90 - counter - motif.rank_info['p' .. side .. '_score_displaytime'])))
				txt:update({text = motif.rank_info['p' .. side .. '_score_text']:gsub('%%s', tostring(score))})
				txt:draw()
			end
			-- Draw rank grade
			if counter >= motif.rank_info['p' .. side .. '_rank_displaytime'] and motif.rank_info['p' .. side .. '_rank_' .. t_rank[side].rank.grade .. '_data'] ~= nil then
				animUpdate(motif.rank_info['p' .. side .. '_rank_' .. t_rank[side].rank.grade .. '_data'])
				animDraw(motif.rank_info['p' .. side .. '_rank_' .. t_rank[side].rank.grade .. '_data'])
			end
			-- Draw gauges
			if counter >= motif.rank_info['p' .. side .. '_gauge_displaytime'] then
				for k, _ in pairs(motif.rank_info.gauge) do
					local v = 'p' .. side .. '_gauge_' .. k
					local t = t_rank[side]['gauge_' .. k]
					if not paused() then
						t.temp = math.min(t.ratio, t.temp + t.ratio / (motif.rank_info[v .. '_ticks'] or 30))
					end
					local window = motif.rank_info[v .. '_window'] or {0, 0, 0, 0}
					local length = window[3] - window[1]
					if motif.rank_info[v .. '_facing'] == -1 then
						animSetWindow(
							motif.rank_info[v .. '_data'],
							window[1] + (1 - t.temp) * length + (t.ratio - t.temp) * length - 1,
							window[2],
							t.temp * length,
							window[4] - window[2]
						)
					else
						animSetWindow(
							motif.rank_info[v .. '_data'],
							window[1],
							window[2],
							t.temp * length,
							window[4] - window[2]
						)
					end
					animUpdate(motif.rank_info[v .. '_data'])
					animDraw(motif.rank_info[v .. '_data'])
				end
			end
			-- Draw icons
			if counter >= motif.rank_info['p' .. side .. '_icon_displaytime'] then
				local i = 1
				for k, _ in pairs(motif.rank_info.icon) do
					if main.f_tableHasValue(t_rank[side].rank.icons, k) then
						main.f_animPosDraw(
							motif.rank_info['p' .. side .. '_icon_' .. k .. '_data'],
							(i - 1) * motif.rank_info['p' .. side .. '_icon_spacing'][1],
							(i - 1) * motif.rank_info['p' .. side .. '_icon_spacing'][2],
							motif.rank_info['p' .. side .. '_icon_' .. k .. '_facing'],
							true
						)
						i = i + 1
					end
				end
			end
			break
		end
	end
	if not paused() then
		if counter == motif.rank_info.snd_time then
			sndPlay(motif.files.snd_data, motif.rank_info.snd[1], motif.rank_info.snd[2])
		end
		counter = counter + 1
	end
	return
end

--;===========================================================
--; Hooks
--;===========================================================
-- Lua Hook System allows hooking additional code into existing functions, from
-- within external modules, without having to worry as much about your code
-- being removed by engine update.

-- Hooked into global.lua loop() function (looping each frame during match)
local function f_loop()
	if roundstart() then
		rankInit = false
	elseif winnerteam() ~= -1 and player(winnerteam()) and roundstate() == 4 then
		f_rank()
	end
end
hook.add("loop", "rankHook1", f_loop)

-- Hooked into main.lua functions stored as main.t_itemname table entries
local function f_rankDisplay()
	-- main.rankDisplay boolean flag controls if rank screen should show up in
	-- particular game modes. It's possible to assign this flag directly (e.g.
	-- in order to make some external module cross compatible with rank module).
	-- Here we're adding flag assignment into existing main.t_itemname entries
	-- via hooking feature (flag is set to true)
	main.rankDisplay = main.rankDisplay or gamemode("arcade") or gamemode("bossrush") or gamemode("freebattle") or gamemode("netplaysurvivalcoop") or gamemode("netplayteamcoop") or gamemode("netplayversus") or gamemode("survival") or gamemode("survivalcoop") or gamemode("teamcoop") or gamemode("timeattack") or gamemode("versus") or gamemode("versuscoop") or gamemode("watch")
end
hook.add("main.t_itemname", "rankHook2", f_rankDisplay)

-- Hooked into main.lua main.f_default function (called before selecting mode)
local function f_rankReset()
	main.rankDisplay = false
end
hook.add("main.f_default", "rankHook3", f_rankReset)
