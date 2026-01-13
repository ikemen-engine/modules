-- ikemenversion: 1.0

local randomtest = {}
--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.randomtest = function()
	setGameMode('randomtest')
	hook.run("main.t_itemname")
	return randomtest.run
end

local function getUniquePalette(ch, prev)
	local charData = start.f_getCharData(ch)
	local pals = charData and charData.pal or {1}
	if not prev or ch ~= prev.ch then
		return pals[sszRandom() % #pals + 1]
	end
	local available = {}
	for _, p in ipairs(pals) do
		if p ~= prev.pal then
			table.insert(available, p)
		end
	end
	if #available > 0 then
		return available[sszRandom() % #available + 1]
	else
		return prev.pal
	end
end

function randomtest.run()
	main.f_default()
	while true do
		for i = 1, 2 do
			setCom(i, 8)
			setTeamMode(i, 0, 1)
			local ch = main.t_randomChars[math.random(1, #main.t_randomChars)]
			local pal = getUniquePalette(ch, prev)
			selectChar(i, ch, pal)
			prev = {ch = ch, pal = pal}
		end
		start.f_setStage()
		loadStart()
		game()
		if winnerteam() == -1 then
			break
		end
	end
end
