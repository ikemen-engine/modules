-- ikemenversion: 1.0
--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.bossrush = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.aiRamp = false
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.elimination = true
	main.exitSelect = true
	--main.lifebar.match = true
	--main.lifebar.p2ailevel = true
	main.makeRoster = true
	main.motif.hiscore = true
	main.motif.losescreen = true
	main.motif.victoryscreen = true
	main.motif.winscreen = true
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.rotationChars = true
	main.storyboard.credits = true
	main.storyboard.gameover = true
	main.teamMenu[1].ratio = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].single = true
	main.teamMenu[1].tag = true
	main.teamMenu[1].turns = true
	main.teamMenu[2].ratio = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].single = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.bossrush)
	setGameMode('bossrush')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_bossChars = {}
for _, v in ipairs(main.t_selChars) do
	if v.boss ~= nil and v.boss == 1 then
		if main.t_bossChars[v.order] == nil then
			main.t_bossChars[v.order] = {}
		end
		table.insert(main.t_bossChars[v.order], v.char_ref)
	end
end

if main.t_selOptions.bossrushmaxmatches == nil or #main.t_selOptions.bossrushmaxmatches == 0 then
	local size = 1
	for k, _ in pairs(main.t_bossChars) do if k > size then size = k end end
	main.t_selOptions.bossrushmaxmatches = {}
	for i = 1, size do
		table.insert(main.t_selOptions.bossrushmaxmatches, 0)
	end	
	for k, v in pairs(main.t_bossChars) do
		main.t_selOptions.bossrushmaxmatches[k] = #v
	end
end

--;===========================================================
--; start.lua
--;===========================================================
-- start.t_makeRoster is a table storing functions returning table data used
-- by start.f_makeRoster function, depending on game mode.
start.t_makeRoster.bossrush = function()
	return start.f_unifySettings(main.t_selOptions.bossrushmaxmatches, main.t_bossChars), main.t_bossChars
end

if main.debugLog then
	main.f_printTable(main.t_bossChars, "debug/t_bossChars.txt")
end
