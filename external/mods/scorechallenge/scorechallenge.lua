-- ikemenversion: 1.0
--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.scorechallenge = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	--main.lifebar.p1score = true
	--main.lifebar.p2ailevel = true
	main.motif.hiscore = true
	main.motif.losescreen = true
	main.motif.versusscreen = true
	main.motif.victoryscreen = true
	main.motif.winscreen = true
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.selectMenu[2] = true
	main.stageMenu = true
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
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.scorechallenge)
	setGameMode('scorechallenge')
	hook.run("main.t_itemname")
	return start.f_selectMode
end
