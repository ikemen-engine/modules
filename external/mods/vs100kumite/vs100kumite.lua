-- ikemenversion: 1.0
--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.vs100kumite = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.aiRamp = false
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.dropDefeated = false -- defeated members are not removed from team
	main.elimination = false -- single lose doesn't stop further lua execution
	main.exitSelect = true
	main.forceRosterSize = true -- roster size enforced even if there are not enough characters to fill it
	--main.lifebar.match = true
	--main.lifebar.p2ailevel = true
	main.persistLife = true -- life maintained after match
	main.persistMusic = true -- don't stop the previous music at the start of the match.
	main.persistRounds = true -- lifebar uses consecutive wins for round numbers
	main.makeRoster = true
	main.motif.continuescreen = false -- no continue screen after we lose the match
	main.motif.hiscore = true
	main.motif.losescreen = false -- no lose screen after we lose the match
	main.motif.winscreen = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.rotationChars = true
	main.stageMenu = true
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
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.vs100kumite)
	setGameMode('vs100kumite')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--;===========================================================
--; start.lua
--;===========================================================
-- start.t_makeRoster is a table storing functions returning table data used
-- by start.f_makeRoster function, depending on game mode.
start.t_makeRoster.vs100kumite = function()
	local t = {}
	local t_static = {main.t_randomChars}
	for i = 1, 100 do --generate ratiomatches style table for 100 matches
		table.insert(t, {['rmin'] = start.p[2].numChars, ['rmax'] = start.p[2].numChars, ['order'] = 1})
	end
	return t, t_static
end
