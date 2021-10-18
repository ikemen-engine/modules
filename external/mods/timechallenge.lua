-- Last tested on Ikemen GO v0.98
-- This external module implements TIME CHALLENGE game mode (defeat selected
-- opponent beating previous time record). Up to release 0.97 this mode was part
-- of the default scripts distributed with engine, now it's used as a showcase
-- how to implement full fledged mode with Ikemen GO external modules feature,
-- without conflicting with default scripts. More info:
-- https://github.com/K4thos/Ikemen_GO/wiki/Miscellaneous-Info#lua_modules
-- This mode is detectable by GameMode trigger as timechallenge

--[[
; Example system.def parameters assignments

[Title Info]
menu.itemname.timechallenge = "TIME CHALLENGE"

[Select Info]
record.timechallenge.text = "- BEST RECORD -\n%c %m:%s.%x: %n"

[Time Challenge Results Screen]
enabled = 1
sounds.enabled = 1

fadein.time = 0
fadein.col = 0, 0, 0
fadein.anim = -1
fadeout.time = 64
fadeout.col = 0, 0, 0
fadeout.anim = -1
show.time = 300

winstext.text = "Clear Time: %m:%s.%x"
winstext.offset = 159,70
winstext.font = 3, 0, 0
winstext.font.scale = 1.0, 1.0
winstext.font.height = -1
winstext.displaytime = 0
winstext.layerno = 2

;overlay.window = 0, 0, 320, 240
overlay.col = 0, 0, 0
overlay.alpha = 20, 100

p1.state.win = 180
p1.state.lose = 175, 170
p2.state.win = 
p2.state.lose = 
p1.teammate.state.win = 
p1.teammate.state.lose = 
p2.teammate.state.win = 
p2.teammate.state.lose = 

[TimeChallengeResultsBGdef]
; left blank (character and stage not covered)
]]

--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.timechallenge = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.hiscoreScreen = true
	--main.lifebar.p2aiLevel = true
	--main.lifebar.timer = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.rankDisplay = true
	main.rankingCondition = true
	main.resultsTable = motif.time_challenge_results_screen
	if main.roundTime == -1 then
		main.roundTime = 99
	end
	main.selectMenu[2] = true
	main.stageMenu = true
	main.teamMenu[1].single = true
	main.teamMenu[2].single = true
	main.versusScreen = true
	main.txt_mainSelect:update({text = motif.select_info.title_timechallenge_text})
	setGameMode('timechallenge')
	return start.f_selectMode
end

--;===========================================================
--; motif.lua
--;===========================================================
-- Here we're expanding motif table with default values that will be used if
-- these parameters are not overridden by system.def parameter assignment.
-- (dots should not be used in variable names, so they have been changed to _)

-- [Select Info] default parameters. Displayed in select screen.
if motif.select_info.title_timechallenge_text == nil then
	motif.select_info.title_timechallenge_text = 'Time Challenge'
end
if motif.select_info.record_timechallenge_text == nil then
	motif.select_info.record_timechallenge_text = '- BEST RECORD -\n%c %m:%s.%x: %n'
end

-- [Time Challenge Results Screen] default parameters. Works similarly to
-- [Win Screen] (used for rendering mode results screen after last match)
local t_base = {
	enabled = 1,
	sounds_enabled = 1,
	fadein_time = 0,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	fadeout_time = 64,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	show_time = 300,
	winstext_text = 'Clear Time: %m:%s.%x',
	winstext_offset = {159, 70},
	winstext_font = {'jg.fnt', 0, 0, 255, 255, 255},
	winstext_font_scale = {1.0, 1.0},
	winstext_font_height = -1,
	winstext_displaytime = 0,
	winstext_layerno = 2,
	overlay_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	overlay_col = {0, 0, 0},
	overlay_alpha = {20, 100},
	p1_state_win = {180},
	p1_state_lose = {175, 170},
	p2_state_win = {},
	p2_state_lose = {},
	p1_teammate_state_win = {},
	p1_teammate_state_lose = {},
	p2_teammate_state_win = {},
	p2_teammate_state_lose = {},
}
if motif.time_challenge_results_screen == nil then
	motif.time_challenge_results_screen = {}
end
motif.time_challenge_results_screen = main.f_tableMerge(t_base, motif.time_challenge_results_screen)

-- If not defined, [TimeChallengeBGdef] group defaults to [WinBGdef].
if motif.timechallengeresultsbgdef == nil then
	motif.timechallengeresultsbgdef = motif.winbgdef
end

-- This code creates data out of optional [TimeChallengeBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.timechallengeresultsbgdef.spr ~= nil and motif.timechallengeresultsbgdef.spr ~= '' then
	motif.timechallengeresultsbgdef.spr = searchFile(motif.timechallengeresultsbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.timechallengeresultsbgdef.spr_data = sffNew(motif.timechallengeresultsbgdef.spr)
else
	motif.timechallengeresultsbgdef.spr = motif.files.spr
	motif.timechallengeresultsbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.timechallengeresultsbgdef.bg = bgNew(motif.timechallengeresultsbgdef.spr_data, motif.def, 'timechallengeresultsbg')

-- fadein/fadeout anim data generation.
if motif.time_challenge_results_screen.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.time_challenge_results_screen, {s = 'fadein_'})
end
if motif.time_challenge_results_screen.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.time_challenge_results_screen, {s = 'fadeout_'})
end

--;===========================================================
--; start.lua
--;===========================================================
-- start.t_sortRanking is a table storing functions with ranking sorting logic
-- used by start.f_storeStats function, depending on game mode. Here we're
-- reusing logic already declared for timeattack mode (refer to start.lua)
start.t_sortRanking.timechallenge = start.t_sortRanking.timeattack

-- as above but the functions return if game mode should be considered "cleared"
start.t_clearCondition.timechallenge = function() return winnerteam() == 1 end

-- start.t_resultData is a table storing functions used for setting variables
-- stored in start.t_result table, returning boolean depending on various
-- factors. It's used by start.f_resultInit function, depending on game mode.
local txt_resultTimeChallenge = main.f_createTextImg(motif.time_challenge_results_screen, 'winstext')
start.t_resultData.timechallenge = function()
	if winnerteam() ~= 1 or motif.time_challenge_results_screen.enabled == 0 then
		return false
	end
	start.t_result.resultText = main.f_extractText(start.f_clearTimeText(main.resultsTable[start.t_result.prefix .. '_text'], timetotal() / 60))
	start.t_result.txt = txt_resultTimeChallenge
	start.t_result.bgdef = 'timechallengeresultsbgdef'
	if matchtime() / 60 >= start.f_lowestRankingData('time') then
		start.t_result.stateType = '_lose'
		start.t_result.winBgm = false
	else
		start.t_result.stateType = '_win'
	end
	return true
end

--;===========================================================
--; main.lua
--;===========================================================
-- Table storing data used by functions related to hiscore rendering and saving.
main.t_hiscoreData.timechallenge = {mode = 'timechallenge', data = 'time', title = motif.select_info.title_timechallenge_text}
