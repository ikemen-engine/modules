-- IKEMEN GO TRIALS MODE EXTERNAL MODULE --------------------------------
-- Last tested on Ikemen GO v0.99
-- Module developed by two4teezee
-------------------------------------------------------------------------
-- This external module implements TRIALS game mode (defeat all opponents
-- that are consider bosses). Features full screenpack integration via 
-- system.def, ability to create and read trails for any character, and a 
-- trials menu option, as well as a timer for the speed demons out there. 
-- The trials mode and verification thresholds can be modified to suit your
-- custome game if needed. For more info on lua external modules:
-- https://github.com/K4thos/Ikemen_GO/wiki/Miscellaneous-Info#lua_modules
-- This mode is detectable by GameMode trigger as trials.
-- Only characters with a trials.def in their character folder will have
-- trials available for them. Documentation on how to create a trials.def 
-- can be found in this file.
-------------------------------------------------------------------------
--[[
; system.def customization
;
; Using this external module allows full customization of the trials mode
; in system.def, with sprites in system.sff OR in trials.sff, if so 
; desired. If you are using trials.sff, make sure you point to it in the
; system.def's [Files] section as "trialsbgdef = trials.sff"

[Trials Info] ;VERTICAL EXAMPLE
	pos 				= 100,250				;Coords to show
	spacing 			= 0,20					;Spacing between trial steps
	window				= 100,250, 1180,550 	;X1,Y1,X2,Y2: display window for trials--will create automated scrolling or line returns, depending on the trial layout of choice

	resetonsuccess		= 0 	;set to 1 to reset character position after each trial success (except the final one)--currently doesn't work
	trialslayout 		= 0		;set to 0 for vertical, 1 for horizontal--affects scrolling logic, as stated above, also enables dynamic step width

	; Overall background element for all trial steps
	;bg.layerno 		= 2
	;bg.offset 			= 0,0
	;bg.anim 			= 1
	;bg.scale 			= 1.5,1.5
	;bg.spr 			= 399,0

	; Trial text that displays current trial number and total number of trials
	trialcounter.offset 		= 486,-206
	trialcounter.font 			= 4,0,-1
	trialcounter.font.scale		= 1,1
	;trialcounter.font.height	=
	trialcounter.text			= "Trial %s of %t"

	; Trial stopwatch can display the total time spent in the trial mode, as well as the time spent in the current trial
	totaltrialtimer.offset 			= 686,-186
	totaltrialtimer.font 			= 4,0,-1
	totaltrialtimer.font.scale		= 1,1
	;totaltrialtimer.font.height	=
	totaltrialtimer.text			= "Total Trial Time: %s"
	currenttrialtimer.offset 		= 686,-216
	currenttrialtimer.font 			= 4,0,-1
	currenttrialtimer.font.scale		= 1,1
	;currenttrialtimer.font.height	=
	currenttrialtimer.text			= "Current Trial Time: %s"

	; Text and background element for all upcoming trial steps
	upcomingstep.text.offset 		= 0,0
	upcomingstep.text.font 			= 2,0,1
	upcomingstep.text.font.scale	= 1,1
	;upcomingstep.text.font.height	=
	upcomingstep.bg.offset 			= -10,-6
	;upcomingstep.bg.anim 			= 609
	upcomingstep.bg.spr 			= 701,1
	;upcomingstep.bg.scale			= 1,1
	;upcomingstep.bg.displaytime	= -1

	; Text and background element for current trial step
	currentstep.text.offset 		= 0,0
	currentstep.text.font 			= 2,0,1
	currentstep.text.font.scale 	= 1,1
	;currentstep.text.font.height	=
	currentstep.bg.offset 			= -10,-6
	;currentstep.bg.anim 			= -1
	currentstep.bg.spr 				= 701,0
	currentstep.bg.scale 			= 1,1
	currentstep.bg.facing			= 1
	;currentstep.bg.displaytime		= -1

	; Text and background element for all completed trial steps
	completedstep.text.offset		= 0,0
	completedstep.text.font 		= 2,0,1
	completedstep.text.font.scale 	= 1,1
	;completedstep.text.font.height = 
	completedstep.bg.offset 		= -10,-6
	completedstep.bg.spr 			= 701,2
	;completedstep.bg.anim 			= 2
	;completedstep.bg.scale 		= 1,1

	; Glyphs information
	glyphs.offset		= 144,5
	glyphs.scale		= 2,2
	glyphs.spacing		= 0,0
	glyphs.align		= -1

	; Success positioning, sound, text, and animation (bg and front elements)
	; Displayed after each completed trial except the final one
	success.pos					= 300,250
	success.snd					= 600,0 
	;success.text.text			=
	;success.text.offset 		= 0,0
	;success.text.font 			= 4,0,1
	;success.text.font.scale 	= 
	;success.text.font.height	=
	success.bg.offset 			= 0,0
	success.bg.anim 			= 650
	;success.bg.scale 			= 1,1
	;success.bg.spr 			= 701,0
	;success.bg.displaytime		= -1
	success.front.offset 		= 0,0
	success.front.anim 			= 651
	;success.front.scale 		= 1,1
	;success.front.spr 			= 701,0
	;success.front.displaytime	= -1

	; All Clear positioning, sound, text, and animation (bg and front elements)
	; Displayed after completing the final trial
	allclear.pos				= 300,250
	allclear.snd				= 900,0
	;allclear.text.text			=
	;allclear.text.offset 		= 0,0
	;allclear.text.font 		= 4,0,1
	;allclear.text.font.scale 	= 
	;allclear.text.font.height	=
	allclear.bg.offset 			= 0,0
	allclear.bg.anim 			= 650
	;allclear.bg.scale 			= 1,1
	;allclear.bg.spr 			= 701,0
	allclear.front.offset 		= 0,0
	allclear.front.anim 		= 652
	;allclear.front.scale 		= 1,1
	;allclear.front.spr 		= 701,0
	
	; https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features/#submenus
	menu.itemname.back 						= "Continue"
	menu.itemname.menutrials 				= "Trials Menu"
	menu.itemname.menutrials.trialslist 	= "Trials List"
	menu.itemname.menutrials.back 		= "Back"
	menu.itemname.menuinput 				= "Button Config"
	menu.itemname.menuinput.keyboard 		= "Key Config"
	menu.itemname.menuinput.gamepad 		= "Joystick Config"
	menu.itemname.menuinput.empty 			= ""
	menu.itemname.menuinput.inputdefault 	= "Default"
	menu.itemname.menuinput.back 			= "Back"
	menu.itemname.commandlist 				= "Command List"
	menu.itemname.characterchange 			= "Character Change"
	menu.itemname.exit 						= "Exit"
]]

-----------------------------------------------------------------

--[[
; Creating Trials
; 
; The trials.def needs to be identified in the character's main 
; .def under the [Files] section as follows:
; trialslist = trials.def 	;Ikemen feature: Trials Mode Definition
;
; Below you'll find a trials.def example for kfmZ. All "Optional" 
; definitions can be left blank or unspecified. The first trial
; is fully populated with commenting. Follow-up trials are written 
; without Optional parameter definitions if they are not required.
; In the example below, note the syntax. Each trial is preceeded
; by a [TrialDef] section header. Then, parameters that affect the
; entire trial are written out as 'trial.TRIALNUMBER.parameter'
; and parameters specfic to each step of that trial are written
; out as 'trial.TRIALNUMBER.STEPNUMBER.parameter'.

; KFMZ TRIALS LIST ---------------------------

[TrialDef]
trial.1.steps 		= 1                 ;Mandatory - states the number of steps in this trial. If you do not define it, the number of steps will be determined automatically.
trial.1.name 		= KFM's First Trial ;Optional - overall name for the trial. I recommend always defining this.
trial.1.dummymode	= stand				;Optional - valid options are stand (default), crouch, jump, wjump. 
trial.1.guardmode	= none				;Optional - valid options are none (default), auto.
trial.1.dummybuttonjam = none			;Optional - valid options are none (default), a, b, c, x, y, z, start, d, w.

trial.1.1.text 		= Strong KF Palm	;Mandatory - name for trial step (only displayed in vertical trials layout). I recommend always defining this.
trial.1.1.glyphs 	= _QDF^Y  	        ;Mandatory - same syntax as movelist glyphs. Glyphs are displayed in vertical and horizontal trials layouts. I recommend always defining this.
trial.1.1.stateno 	= 1010				;Mandatory - state to be checked to pass trial.
trial.1.1.anim		=					;Optional - identifies animno to be checked to pass trial. Useful in certain cases.
trial.1.1.projid	= 					;Optional - identifies projectile ID to be checked to pass trial.
trial.1.1.isthrow 	= 					;Optional - (0 or 1), will default to 0 if not included or defined. Identifies whether the trial step is a throw. 
trial.1.1.ishelper	= 					;Optional - (0 or 1), will default to 0 if not included or defined. Identifies whether the trial step is a helper. 
trial.1.1.specialbool 	=				;Optional - valid argument is 0 or 1. Can be used for custom games as required.
trial.1.1.specialvar	=				;Optional - valid argument is any numerical value. Can be used for custom games as required.
trial.1.1.specialstr	=				;Optional - valid argument is any string. Can be used for custom games as required.

;---------------------------------------------

[TrialDef]
trial.2.steps 		= 1
trial.2.name		= Kung Fu Throw

trial.2.1.text 		= Kung Fu Throw
trial.2.1.glyphs 	= [_B/_F]_+^Y
trial.2.1.stateno 	= 810
trial.2.1.isthrow	= 1

;---------------------------------------------

[TrialDef]
trial.3.steps 		= 2
trial.3.name		= Standing Punch Chain

trial.3.1.text 		= Standing Light Punch
trial.3.1.glyphs 	= ^X
trial.3.1.stateno 	= 200

trial.3.2.text 		= Standing Strong Punch
trial.3.2.glyphs 	= ^Y
trial.3.2.stateno 	= 210

;---------------------------------------------

[TrialDef]
trial.4.steps 		= 4
trial.4.name		= Kung Fu Fist Four Piece

trial.4.1.text 		= Jumping Strong Punch
trial.4.1.glyphs 	= _AIR^Y
trial.4.1.stateno 	= 610

trial.4.2.text 		= Standing Light Punch
trial.4.2.glyphs 	= ^X
trial.4.2.stateno 	= 200

trial.4.3.text 		= Standing Strong Punch
trial.4.3.glyphs 	= ^Y
trial.4.3.stateno 	= 210

trial.4.4.text 		= Strong Kung Fu Palm
trial.4.4.glyphs 	= _QDF^Y
trial.4.4.stateno 	= 1010

;---------------------------------------------

[TrialDef]
trial.5.steps 		= 5
trial.5.name 		= Kung Fu Super Cancel

trial.5.1.text 		= Jumping Strong Kick
trial.5.1.glyphs 	= _AIR^B
trial.5.1.stateno 	= 640

trial.5.2.text 		= Standing Light Kick
trial.5.2.glyphs 	= ^A
trial.5.2.stateno 	= 230

trial.5.3.text 		= Standing Strong Kick
trial.5.3.glyphs 	= ^B
trial.5.3.stateno 	= 240

trial.5.4.text 		= Fast Kung Fu Zankou
trial.5.4.glyphs 	= _QDF^A^B
trial.5.4.stateno 	= 1420

trial.5.5.text 		= Triple Kung Fu Palm
trial.5.5.glyphs 	= _QDF_QDF^P
trial.5.5.stateno 	= 3000

]]

--;===========================================================
--; main.lua
--;===========================================================
main.t_itemname.trials = function()
	setHomeTeam(1)
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	if main.t_charDef[config.TrainingChar:lower()] ~= nil then
		main.forceChar[2] = {main.t_charDef[config.TrainingChar:lower()]}
	end
	--main.lifebar.p1score = false
	--main.lifebar.p2aiLevel = true
	main.roundTime = -1
	main.selectMenu[2] = true
	main.stageMenu = true
	main.teamMenu[1].ratio = false
	main.teamMenu[1].simul = false
	main.teamMenu[1].single = true
	main.teamMenu[1].tag = false
	main.teamMenu[1].turns = false
	main.teamMenu[2].single = true
	main.txt_mainSelect:update({text = motif.select_info.title_trials_text})
	setGameMode('trials')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--;===========================================================
--; motif.lua
--;===========================================================
-- [Select Info] default parameters. Displayed in select screen.
if motif.select_info.title_trials_text == nil then
	motif.select_info.title_trials_text = 'Trials'
end

local t_base = {
    pos = {0, 0}, --Ikemen feature
    spacing = {0, 0}, --Ikemen feature
    window = {0,0,0,0}, --Ikemen feature
    resetonsuccess = 0, --Ikemen feature
    trialslayout = 0, --Ikemen feature
    trialcounter_offset = {0,0}, --Ikemen feature
    trialcounter_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    trialcounter_font_scale = {1.0, 1.0}, --Ikemen feature
    trialcounter_font_height = -1, --Ikemen feature
    trialcounter_text = '', --Ikemen feature
	totaltrialtimer_offset = {0,0}, --Ikemen feature
    totaltrialtimer_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    totaltrialtimer_font_scale = {1.0, 1.0}, --Ikemen feature
    totaltrialtimer_font_height = -1, --Ikemen feature
    totaltrialtimer_text = '', --Ikemen feature
    currenttrialtimer_offset = {0,0}, --Ikemen feature
    currenttrialtimer_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    currenttrialtimer_font_scale = {1.0, 1.0}, --Ikemen feature
    currenttrialtimer_font_height = -1, --Ikemen feature
    currenttrialtimer_text = '', --Ikemen feature
    bg_anim = -1, --Ikemen feature
    bg_spr = {}, --Ikemen feature
    bg_offset = {0, 0}, --Ikemen feature
    bg_facing = 1, --Ikemen feature
    bg_scale = {1.0, 1.0}, --Ikemen feature
    bg_displaytime = 0, --Ikemen feature
    upcomingstep_text_offset = {0,0}, --Ikemen feature
    upcomingstep_text_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    upcomingstep_text_font_scale = {1.0, 1.0}, --Ikemen feature
    upcomingstep_text_font_height = -1, --Ikemen feature
    upcomingstep_text_text = '', --Ikemen feature
    upcomingstep_bg_anim = -1, --Ikemen feature
    upcomingstep_bg_spr = {}, --Ikemen feature
    upcomingstep_bg_offset = {0, 0}, --Ikemen feature
    upcomingstep_bg_facing = 1, --Ikemen feature
    upcomingstep_bg_scale = {1.0, 1.0}, --Ikemen feature
    upcomingstep_bg_displaytime = -1, --Ikemen feature
    upcomingstep_bginc_anim = -1, --Ikemen feature
    upcomingstep_bginc_spr = {}, --Ikemen feature
    upcomingstep_bginc_offset = {0, 0}, --Ikemen feature
    upcomingstep_bginc_facing = 1, --Ikemen feature
    upcomingstep_bginc_scale = {1.0, 1.0}, --Ikemen feature
    currentstep_text_offset = {0,0}, --Ikemen feature
    currentstep_text_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    currentstep_text_font_scale = {1.0, 1.0}, --Ikemen feature
    currentstep_text_font_height = -1, --Ikemen feature
    currentstep_text_text = '', --Ikemen feature
    currentstep_bg_anim = -1, --Ikemen feature
    currentstep_bg_spr = {}, --Ikemen feature
    currentstep_bg_offset = {0, 0}, --Ikemen feature
    currentstep_bg_facing = 1, --Ikemen feature
    currentstep_bg_scale = {1.0, 1.0}, --Ikemen feature
    currentstep_bg_displaytime = -1, --Ikemen feature
    currentstep_bginc_anim = -1, --Ikemen feature
    currentstep_bginc_spr = {}, --Ikemen feature
    currentstep_bginc_offset = {0, 0}, --Ikemen feature
    currentstep_bginc_facing = 1, --Ikemen feature
    currentstep_bginc_scale = {1.0, 1.0}, --Ikemen feature
    completedstep_text_offset = {0,0}, --Ikemen feature
    completedstep_text_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    completedstep_text_font_scale = {1.0, 1.0}, --Ikemen feature
    completedstep_text_font_height = -1, --Ikemen feature
    completedstep_text_text = '', --Ikemen feature
    completedstep_bg_anim = -1, --Ikemen feature
    completedstep_bg_spr = {}, --Ikemen feature
    completedstep_bg_offset = {0, 0}, --Ikemen feature
    completedstep_bg_facing = 1, --Ikemen feature
    completedstep_bg_scale = {1.0, 1.0}, --Ikemen feature
    completedstep_bg_displaytime = -1, --Ikemen feature
    completedstep_bginc_anim = -1, --Ikemen feature
    completedstep_bginc_spr = {}, --Ikemen feature
    completedstep_bginc_offset = {0, 0}, --Ikemen feature
    completedstep_bginc_facing = 1, --Ikemen feature
    completedstep_bginc_scale = {1.0, 1.0}, --Ikemen feature
    completedstep_bginctocts_anim = -1, --Ikemen feature
    completedstep_bginctocts_spr = {}, --Ikemen feature
    completedstep_bginctocts_offset = {0, 0}, --Ikemen feature
    completedstep_bginctocts_facing = 1, --Ikemen feature
    completedstep_bginctocts_scale = {1.0, 1.0}, --Ikemen feature
    glyphs_offset = {0, 0}, --Ikemen feature
    glyphs_scale = {1.0,1.0}, --Ikemen feature
    glyphs_spacing = {0,0}, --Ikemen feature
    glyphs_align = 1, --Ikemen feature
    success_pos = {0, 0}, --Ikemen feature
    success_snd = {-1, 0}, --Ikemen feature
    success_bg_anim = -1, --Ikemen feature
    success_bg_spr = {}, --Ikemen feature
    success_bg_offset = {0, 0}, --Ikemen feature
    success_bg_facing = 1, --Ikemen feature
    success_bg_scale = {1.0, 1.0}, --Ikemen feature
    success_bg_displaytime = -1, --Ikemen feature
    success_front_anim = -1, --Ikemen feature
    success_front_spr = {}, --Ikemen feature
    success_front_offset = {0, 0}, --Ikemen feature
    success_front_facing = 1, --Ikemen feature
    success_front_scale = {1.0, 1.0}, --Ikemen feature
    success_front_displaytime = -1, --Ikemen feature
    success_text_offset = {0,0}, --Ikemen feature
    success_text_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    success_text_font_scale = {1.0, 1.0}, --Ikemen feature
    success_text_font_height = -1, --Ikemen feature
    success_text_text = '', --Ikemen feature
    allclear_pos = {0, 0}, --Ikemen feature
    allclear_snd = {-1, 0}, --Ikemen feature
    allclear_bg_anim = -1, --Ikemen feature
    allclear_bg_spr = {}, --Ikemen feature
    allclear_bg_offset = {0, 0}, --Ikemen feature
    allclear_bg_facing = 1, --Ikemen feature
    allclear_bg_scale = {1.0, 1.0}, --Ikemen feature
    allclear_bg_displaytime = -1, --Ikemen feature
    allclear_front_anim = -1, --Ikemen feature
    allclear_front_spr = {}, --Ikemen feature
    allclear_front_offset = {0, 0}, --Ikemen feature
    allclear_front_facing = 1, --Ikemen feature
    allclear_front_scale = {1.0, 1.0}, --Ikemen feature
    allclear_front_displaytime = -1, --Ikemen feature
    allclear_text_offset = {0,0}, --Ikemen feature
    allclear_text_font = {'f-6x9.def', 0, 1, 255, 255, 255}, --Ikemen feature
    allclear_text_font_scale = {1.0, 1.0}, --Ikemen feature
    allclear_text_font_height = -1, --Ikemen feature
    allclear_text_text = '', --Ikemen feature
}

-- Merge trials data into table
if motif.trials_info == nil then
	motif.trials_info = {}
end
motif.trials_info = main.f_tableMerge(t_base, motif.trials_info)

if motif.trialsbgdef == nil then
    motif.trialsbgdef = {
        spr = '', --Ikemen feature
        bgclearcolor = {0, 0, 0}, --Ikemen feature
    }
end

-- This code creates data out of optional [trialsbgdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.trialsbgdef.spr ~= nil and motif.trialsbgdef.spr ~= '' then
	motif.trialsbgdef.spr = searchFile(motif.trialsbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.trialsbgdef.spr_data = sffNew(motif.trialsbgdef.spr)
else
	motif.trialsbgdef.spr = motif.files.spr
	motif.trialsbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.trialsbgdef.bg = bgNew(motif.trialsbgdef.spr_data, motif.def, 'trialsbg')

--trials spr/anim data
local tr_pos = motif.trials_info
for _, v in ipairs({
	{s = 'bg_',							x = tr_pos.pos[1] + tr_pos.bg_offset[1],						y = tr_pos.pos[2] + tr_pos.bg_offset[2],						},
	{s = 'success_bg_',    				x = tr_pos.success_pos[1] + tr_pos.success_bg_offset[1],		y = tr_pos.success_pos[2] + tr_pos.success_bg_offset[2],		},
	{s = 'allclear_bg_',	   			x = tr_pos.allclear_pos[1] + tr_pos.allclear_bg_offset[1],		y = tr_pos.allclear_pos[2] + tr_pos.allclear_bg_offset[2],		},
	{s = 'success_front_',    			x = tr_pos.success_pos[1] + tr_pos.success_front_offset[1],		y = tr_pos.success_pos[2] + tr_pos.success_front_offset[2],		},
	{s = 'allclear_front_',   			x = tr_pos.allclear_pos[1] + tr_pos.allclear_front_offset[1],	y = tr_pos.allclear_pos[2] + tr_pos.allclear_front_offset[2],	},
	{s = 'upcomingstep_bg_',			x = 0,															y = 0,															},
	{s = 'upcomingstep_bginc_',			x = 0,															y = 0,															},
	{s = 'currentstep_bg_',				x = 0,															y = 0,															},
	{s = 'currentstep_bginc_',			x = 0,															y = 0,															},
	{s = 'completedstep_bg_',			x = 0,															y = 0,															},
	{s = 'completedstep_bginc_',		x = 0,															y = 0,															},
	{s = 'completedstep_bginctocts_',	x = 0,															y = 0,															},

}) do
	if motif.files.trials ~= nil and motif.files.trials ~= '' then
	 	motif.files.trials_data = sffNew(searchFile(motif.files.trials, {motif.fileDir, '', 'data/'}))
	 	main.f_loadingRefresh()
	 	motif.f_loadSprData(motif.trials_info, v, motif.files.trials_data)
	elseif main.f_fileExists('external/mods/trials/trials.sff') then
		motif.files.trials_data = sffNew(searchFile('external/mods/trials/trials.sff', {motif.fileDir, '', 'data/'}))
	 	main.f_loadingRefresh()
	 	motif.f_loadSprData(motif.trials_info, v, motif.files.trials_data)
	else
	 	motif.f_loadSprData(motif.trials_info, v)
	end
end

-- fadein/fadeout anim data generation.
if motif.trials_info.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.trials_info, {s = 'fadein_'}, motif.files.spr_data)
end
if motif.trials_info.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.trials_info, {s = 'fadeout_'}, motif.files.spr_data)
end

function motif.setBaseTrialsInfo()
	motif.trials_info.menu_itemname_back = "Continue"
	motif.trials_info.menu_itemname_trialslist = "Active Trial"
	motif.trials_info.menu_itemname_menuinput = "Button Config"
	motif.trials_info.menu_itemname_menuinput_keyboard = "Key Config"
	motif.trials_info.menu_itemname_menuinput_gamepad = "Joystick Config"
	motif.trials_info.menu_itemname_menuinput_empty = ""
	motif.trials_info.menu_itemname_menuinput_inputdefault = "Default"
	motif.trials_info.menu_itemname_menuinput_back = "Back"
	--motif.trials_info.menu_itemname_reset = "Round Reset"
	--motif.trials_info.menu_itemname_reload = "Rematch"
	motif.trials_info.menu_itemname_commandlist = "Command List"
	motif.trials_info.menu_itemname_characterchange = "Character Change"
	motif.trials_info.menu_itemname_exit = "Exit"
	if main.t_sort.trials_info == nil then
		main.t_sort.trials_info = {}
	end
	main.t_sort.trials_info.menu = {
		"back",
		"trialslist",
		"menuinput",
		"menuinput_keyboard",
		"menuinput_gamepad",
		"menuinput_empty",
		"menuinput_inputdefault",
		"menuinput_back",
		--"reset",
		--"reload",
		"commandlist",
		"characterchange",
		"exit",
	}
	hook.run("motif.setBaseTrialsInfo")
end

--;===========================================================
--; start.lua
--;===========================================================

function start.f_trialsBuilder()
	if not start.trialsInit then
		--This function will initialize once to build all the trial tables based on the motif information and the trials information loaded when the char was selected
		start.trialsInit = true
		--Pre-populate trialsdata table
		start.trialsdata = {
			active = false,
			trialspresent = gettrialinfo('trialspresent'),
			numoftrials = gettrialinfo('numoftrials'),
			currenttrial = 1,
			currenttrialstep = 1,
			maxsteps = 0,
			starttick = tickcount(),
			elapsedtime = 0,
			trial = {},
		}
		--Populate background elements information
		start.trialsdata.bgelemdata = {
			currentbgsize = animGetSpriteInfo(motif.trials_info.currentstep_bg_data),
			upcomingbgsize = animGetSpriteInfo(motif.trials_info.upcomingstep_bg_data),
			completedbgsize = animGetSpriteInfo(motif.trials_info.completedstep_bg_data),
			currentbgincwidth = animGetSpriteInfo(motif.trials_info.currentstep_bginc_data),
			upcomingbgincwidth = animGetSpriteInfo(motif.trials_info.upcomingstep_bginc_data),
			completedbgincwidth = animGetSpriteInfo(motif.trials_info.completedstep_bginc_data),
		}

		--Obtain all of the trials information, to include the offset positions based on whether the display layout is horizontal or vertical
		for i = 1, start.trialsdata.numoftrials, 1 do
			start.trialsdata.trial[i] = {
				name = gettrialinfo('currenttrialname',i-1),
				numsteps = gettrialinfo('currenttrialnumofsteps',i-1),
				dummymode = gettrialinfo('currenttrialdummymode',i-1),
				guardmode = gettrialinfo('currenttrialguardmode',i-1),
				buttonjam = gettrialinfo('currenttrialdummybuttonjam',i-1),
				active = false,
				complete = false,
				elapsedtime = 0,
				starttick = tickcount(),
				text = {},
				glyphs = {},
				stateno = {},
				animno = {},
				isthrow = {},
				isnohit = {},
				ishelper = {},
				stateledger = {},
				helperIDledger = {},
				helperfound = {},
				projid = {},
				projcheck = {},
				counterhitcheck = {},
				specialbool = {},
				specialstr = {},
				specialval = {},
				glyphline = {},
			}
			if start.trialsdata.trial[i].numsteps > start.trialsdata.maxsteps then
				start.trialsdata.maxsteps = start.trialsdata.trial[i].numsteps
			end
			for j = 1, start.trialsdata.trial[i].numsteps, 1 do
				start.trialsdata.trial[i].text[j] = gettrialinfo('currenttrialtext',i-1,j-1)
				start.trialsdata.trial[i].glyphs[j] = gettrialinfo('currenttrialglyphs',i-1,j-1)
				start.trialsdata.trial[i].stateno[j] = gettrialinfo('currenttrialstateno',i-1,j-1)
				start.trialsdata.trial[i].animno[j] = gettrialinfo('currenttrialanimno',i-1,j-1)
				start.trialsdata.trial[i].isthrow[j] = gettrialinfo('currenttrialisthrow',i-1,j-1)
				start.trialsdata.trial[i].isnohit[j] = gettrialinfo('currenttrialisnohit',i-1,j-1)
				start.trialsdata.trial[i].ishelper[j] = gettrialinfo('currenttrialishelper',i-1,j-1)
				start.trialsdata.trial[i].stateledger[j] = {}
				start.trialsdata.trial[i].helperIDledger[j] = {}
				start.trialsdata.trial[i].helperfound[j] = false
				start.trialsdata.trial[i].projid[j] = gettrialinfo('currenttrialprojid',i-1,j-1)
				start.trialsdata.trial[i].specialbool[j] = gettrialinfo('currenttrialspecialbool',i-1,j-1)
				start.trialsdata.trial[i].specialstr[j] = gettrialinfo('currenttrialspecialstr',i-1,j-1)
				start.trialsdata.trial[i].specialval[j] = gettrialinfo('currenttrialspecialval',i-1,j-1)
				start.trialsdata.trial[i].projcheck[j] = false
				start.trialsdata.trial[i].counterhitcheck[j] = gettrialinfo('currenttrialiscounterhit',i-1,j-1)
				start.trialsdata.trial[i].glyphline[j] = {
					glyph = {},
					pos = {},
					width = {},
					alignOffset = {},
					lengthOffset = {},
					scale = {}
				}
				if start.trialsdata.trial[i].projid[j] ~= -2147483648 then 
					start.trialsdata.trial[i].projcheck[j] = true 
				else
					start.trialsdata.trial[i].projid[j] = 0
				end
				local movelistline = start.trialsdata.trial[i].glyphs[j]
				for k, v in main.f_sortKeys(motif.glyphs, function(t, a, b) return string.len(a) > string.len(b) end) do
					movelistline = movelistline:gsub(main.f_escapePattern(k), '<' .. numberToRune(v[1] + 0xe000) .. '>')
				end
				movelistline = movelistline:gsub('%s+$', '')
				for moves in movelistline:gmatch('(	*[^	]+)') do
					moves = moves .. '<#>'
					tempglyphs = {}
					for m1, m2 in moves:gmatch('(.-)<([^%g <>]+)>') do
						if not m2:match('^#[A-Za-z0-9]+$') and not m2:match('^/$') and not m2:match('^#$') then
							tempglyphs[#tempglyphs+1] = m2
						end
					end
					if motif.trials_info.glyphs_align == -1 then
						for ii = #tempglyphs, 1, -1 do
							start.trialsdata.trial[i].glyphline[j].glyph[#start.trialsdata.trial[i].glyphline[j].glyph+1] = tempglyphs[ii]
							start.trialsdata.trial[i].glyphline[j].pos[#start.trialsdata.trial[i].glyphline[j].glyph+1] = {0,0}
							start.trialsdata.trial[i].glyphline[j].width[#start.trialsdata.trial[i].glyphline[j].glyph+1] = 0
							start.trialsdata.trial[i].glyphline[j].alignOffset[#start.trialsdata.trial[i].glyphline[j].glyph+1] = 0
							start.trialsdata.trial[i].glyphline[j].lengthOffset[#start.trialsdata.trial[i].glyphline[j].glyph+1] = 0
							start.trialsdata.trial[i].glyphline[j].scale[#start.trialsdata.trial[i].glyphline[j].glyph+1] = {1,1}
						end
					else
						for ii = 1, #tempglyphs do
							start.trialsdata.trial[i].glyphline[j].glyph[ii] = tempglyphs[ii]
							start.trialsdata.trial[i].glyphline[j].pos[ii] = {0,0}
							start.trialsdata.trial[i].glyphline[j].width[ii] = 0
							start.trialsdata.trial[i].glyphline[j].alignOffset[ii] = 0
							start.trialsdata.trial[i].glyphline[j].lengthOffset[ii] = 0
							start.trialsdata.trial[i].glyphline[j].scale[ii] = {1,1}
						end
					end
				end
				--This glyphs section is more or less wholesale borrowed from the movelist section with minor tweaks
				local lengthOffset = 0
				local alignOffset = 0
				local align = 1
				local width = 0
				local font_def = main.font_def[motif.trials_info.currentstep_text_font[1] .. motif.trials_info.currentstep_text_font_height] 
				for m in pairs(start.trialsdata.trial[i].glyphline[j].glyph) do
					if motif.glyphs_data[start.trialsdata.trial[i].glyphline[j].glyph[m]] ~= nil then
						if motif.trials_info.trialslayout == 0 then
							if motif.trials_info.glyphs_align == 0 then --center align
								alignOffset = motif.trials_info.glyphs_offset[1] * 0.5
							elseif motif.trials_info.glyphs_align == -1 then --right align
								alignOffset = motif.trials_info.glyphs_offset[1]
							end
							if motif.trials_info.glyphs_align ~= align then
								lengthOffset = 0
								align = motif.trials_info.glyphs_align
							end
						end
						local scaleX = motif.trials_info.glyphs_scale[1]
						local scaleY = motif.trials_info.glyphs_scale[2]
						if motif.trials_info.trialslayout == 0 then
							scaleX = font_def.Size[2] * motif.trials_info.currentstep_text_font_scale[2] / motif.glyphs_data[start.trialsdata.trial[i].glyphline[j].glyph[m]].info.Size[2] * motif.trials_info.glyphs_scale[1]
							scaleY = font_def.Size[2] * motif.trials_info.currentstep_text_font_scale[2] / motif.glyphs_data[start.trialsdata.trial[i].glyphline[j].glyph[m]].info.Size[2] * motif.trials_info.glyphs_scale[2]
						end
						if motif.trials_info.glyphs_align == -1 then
							alignOffset = alignOffset - motif.glyphs_data[start.trialsdata.trial[i].glyphline[j].glyph[m]].info.Size[1] * scaleX
						end
						start.trialsdata.trial[i].glyphline[j].alignOffset[m] = alignOffset
						start.trialsdata.trial[i].glyphline[j].scale[m] = {scaleX, scaleY}
						start.trialsdata.trial[i].glyphline[j].pos[m] = {
							math.floor(motif.trials_info.pos[1] + motif.trials_info.glyphs_offset[1] + alignOffset + lengthOffset),
							motif.trials_info.pos[2] + motif.trials_info.glyphs_offset[2]
						}
						start.trialsdata.trial[i].glyphline[j].width[m] = math.floor(motif.glyphs_data[start.trialsdata.trial[i].glyphline[j].glyph[m]].info.Size[1] * scaleX + motif.trials_info.glyphs_spacing[1])
						if motif.trials_info.glyphs_align == 1 then
							lengthOffset = lengthOffset + start.trialsdata.trial[i].glyphline[j].width[m]
						elseif motif.trials_info.glyphs_align == -1 then
							lengthOffset = lengthOffset - start.trialsdata.trial[i].glyphline[j].width[m]
						else
							lengthOffset = lengthOffset + start.trialsdata.trial[i].glyphline[j].width[m] / 2
						end
						start.trialsdata.trial[i].glyphline[j].lengthOffset[m] = lengthOffset
					end
				end
			end
		end
		--Pre-populate the draw table so that each trial
		start.trialsdata.draw = {
			upcomingtextline = {},
			currenttextline = {},
			completedtextline = {},
			success = 0,
			allclear = math.max(animGetLength(motif.trials_info.allclear_front_data), animGetLength(motif.trials_info.allclear_bg_data)),
			trialcounter = main.f_createTextImg(motif.trials_info, 'trialcounter'),
			totaltrialtimer = main.f_createTextImg(motif.trials_info, 'totaltrialtimer'),
			currenttrialtimer = main.f_createTextImg(motif.trials_info, 'currenttrialtimer'),
			windowXrange = motif.trials_info.window[3] - motif.trials_info.window[1],
			windowYrange = motif.trials_info.window[4] - motif.trials_info.window[2],
		}
		start.trialsdata.draw.trialcounter:update({x = motif.trials_info.pos[1]+motif.trials_info.trialcounter_offset[1], y = motif.trials_info.pos[2]+motif.trials_info.trialcounter_offset[2],})
		start.trialsdata.draw.totaltrialtimer:update({x = motif.trials_info.pos[1]+motif.trials_info.totaltrialtimer_offset[1], y = motif.trials_info.pos[2]+motif.trials_info.totaltrialtimer_offset[2],})
		start.trialsdata.draw.currenttrialtimer:update({x = motif.trials_info.pos[1]+motif.trials_info.currenttrialtimer_offset[1], y = motif.trials_info.pos[2]+motif.trials_info.currenttrialtimer_offset[2],})
		for i = 1, start.trialsdata.maxsteps, 1 do
			start.trialsdata.draw.upcomingtextline[i] = main.f_createTextImg(motif.trials_info, 'upcomingstep_text')
			start.trialsdata.draw.currenttextline[i] = main.f_createTextImg(motif.trials_info, 'currentstep_text')
			start.trialsdata.draw.completedtextline[i] = main.f_createTextImg(motif.trials_info, 'completedstep_text')
		end
	end
end

function start.f_trialsSetup()
	--If the trials initializer was successful and the round animation is completed, we will start drawing trials on the screen
	player(2)
	setAILevel(0)
	player(1)
	charMapSet(2, '_iksys_trainingDummyControl', 0)
	start.trialsdata.active = true
		
	if not start.trialsdata.trial[start.trialsdata.numoftrials].complete and not start.trialsdata.trial[start.trialsdata.currenttrial].active and start.trialsdata.active then
		if start.trialsdata.trial[start.trialsdata.currenttrial].dummymode == 'stand' then
			charMapSet(2, '_iksys_trainingDummyMode', 0)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].dummymode == 'crouch' then
			charMapSet(2, '_iksys_trainingDummyMode', 1)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].dummymode == 'jump' then
			charMapSet(2, '_iksys_trainingDummyMode', 2)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].dummymode == 'wjump' then
			charMapSet(2, '_iksys_trainingDummyMode', 3)
		end

		if start.trialsdata.trial[start.trialsdata.currenttrial].guardmode == 'none' then
			charMapSet(2, '_iksys_trainingGuardMode', 0)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].guardmode == 'auto' then
			charMapSet(2, '_iksys_trainingGuardMode', 1)
		end		

		if start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'none' then
			charMapSet(2, '_iksys_trainingButtonJam', 0)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'a' then
			charMapSet(2, '_iksys_trainingButtonJam', 1)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'b' then
			charMapSet(2, '_iksys_trainingButtonJam', 2)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'c' then
			charMapSet(2, '_iksys_trainingButtonJam', 3)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'x' then
			charMapSet(2, '_iksys_trainingButtonJam', 4)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'y' then
			charMapSet(2, '_iksys_trainingButtonJam', 5)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'z' then
			charMapSet(2, '_iksys_trainingButtonJam', 6)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'start' then
			charMapSet(2, '_iksys_trainingButtonJam', 7)
		elseif start.trialsdata.trial[start.trialsdata.currenttrial].buttonjam == 'd' then
			charMapSet(2, '_iksys_trainingButtonJam', 8)
		elseif start.trialsdata.trial[cstart.trialsdata.currenttrialt].buttonjam == 'w' then
			charMapSet(2, '_iksys_trainingButtonJam', 9)
		end

		start.trialsdata.trial[start.trialsdata.currenttrial].active = true

	elseif start.trialsdata.trial[start.trialsdata.numoftrials].complete then
		print("reseting now")
		menu.f_trialsReset()
	end

end

local function f_timeConvert(value)
	local totalSec = value / 60
	local h = tostring(math.floor(totalSec / 3600))
	local m = tostring(math.floor((totalSec / 3600 - h) * 60))
	local s = tostring(math.floor(((totalSec / 3600 - h) * 60 - m) * 60))
	local x = tostring(math.floor((((totalSec / 3600 - h) * 60 - m) * 60 - s) *100))

	if string.len(m) < 2 then
		m = 0 .. m
	end
	if string.len(s) < 2 then
		s = 0 .. s
	end
	if string.len(x) < 2 then
		x = 0 .. x
	end
	return m, s, x
end

function start.f_trialsDrawer()
	if start.trialsInit and roundstate() == 2 and not start.trialsdata.active then
		start.f_trialsSetup()
	end

	local accwidth = 0
	local addrow = 0
	ct = start.trialsdata.currenttrial
	cts = start.trialsdata.currenttrialstep

	if start.trialsdata.active then 
		if ct <= start.trialsdata.numoftrials and start.trialsdata.draw.success == 0 then
			--According to motif instructions, draw trials counter on screen
			local trtext = motif.trials_info.trialcounter_text
			trtext = trtext:gsub('%%s', tostring(ct)):gsub('%%t', tostring(start.trialsdata.numoftrials))
			start.trialsdata.draw.trialcounter:update({text = trtext})
			start.trialsdata.draw.trialcounter:draw()
			animUpdate(motif.trials_info.bg_data)
			animDraw(motif.trials_info.bg_data)

			--Logic for the stopwatches: total time spent in trial, and time spent on this current trial
			local totaltimertext = motif.trials_info.totaltrialtimer_text
			start.trialsdata.elapsedtime = tickcount() - start.trialsdata.starttick
			local m, s, x = f_timeConvert(start.trialsdata.elapsedtime)
			totaltimertext = totaltimertext:gsub('%%s', m .. ":" .. s .. ":" .. x)
			start.trialsdata.draw.totaltrialtimer:update({text = totaltimertext})
			start.trialsdata.draw.totaltrialtimer:draw()
			animUpdate(motif.trials_info.bg_data)
			animDraw(motif.trials_info.bg_data)

			local currenttimertext = motif.trials_info.currenttrialtimer_text
			start.trialsdata.trial[ct].elapsedtime = tickcount() - start.trialsdata.trial[ct].starttick
			local m, s, x = f_timeConvert(start.trialsdata.trial[ct].elapsedtime)
			currenttimertext = currenttimertext:gsub('%%s', m .. ":" .. s .. ":" .. x)
			start.trialsdata.draw.currenttrialtimer:update({text = currenttimertext})
			start.trialsdata.draw.currenttrialtimer:draw()
			animUpdate(motif.trials_info.bg_data)
			animDraw(motif.trials_info.bg_data)

			local startonstep = 1
			local drawtothisstep = start.trialsdata.trial[ct].numsteps
			
			--For vertical trial layouts, determine if all assets will be drawn within the trials window range, or if scrolling needs to be enabled. For horizontal layouts, we will figure it out
			--when we determine glyph and incrementor widths (see notes below). We do this step outside of the draw loop to speed things up.
			if start.trialsdata.trial[ct].numsteps*motif.trials_info.spacing[2] > start.trialsdata.draw.windowYrange and motif.trials_info.trialslayout == 0 then
				startonstep = math.max(cts-2, 1)
				if (drawtothisstep - startonstep)*motif.trials_info.spacing[2] > start.trialsdata.draw.windowYrange then
					drawtothisstep = math.min(startonstep+math.floor(start.trialsdata.draw.windowYrange/motif.trials_info.spacing[2]),start.trialsdata.trialnumsteps[ct])
				end
			end

			--This is the draw loop
			for i = startonstep, drawtothisstep, 1 do
				local tempoffset = {motif.trials_info.spacing[1]*(i-startonstep),motif.trials_info.spacing[2]*(i-startonstep)}
				sub = 'current'
				if i < cts then
					sub = 'completed'
				elseif i == cts then
					sub = 'current'
				else
					sub = 'upcoming'
				end
				local bgtargetscale = {1,1}
				local bgtargetpos = {0,0}
				local padding = 0
				local totaloffset = 0
				local bgincwidth = 0 --only used for horizontal layouts
				if motif.trials_info.trialslayout == 0 then
					--Vertical layouts are the simplest - they have a constant width sprite or anim that the text is drawn on top of, and the glyphs are displayed wherever specified. 
					--The vertical layouts do NOT support incrementors (see notes below for horizontal layout).
					animSetPos(
						motif.trials_info[sub .. 'step_bg_data'], 
						motif.trials_info.pos[1] + motif.trials_info[sub .. 'step_bg_offset'][1] + tempoffset[1], 
						motif.trials_info.pos[2] + motif.trials_info[sub .. 'step_bg_offset'][2] + tempoffset[2]
					)
					animUpdate(motif.trials_info[sub .. 'step_bg_data'])
					animDraw(motif.trials_info[sub .. 'step_bg_data'])
					start.trialsdata.draw[sub .. 'textline'][i]:update({
						x = motif.trials_info.pos[1]+motif.trials_info.upcomingstep_text_offset[1]+motif.trials_info.spacing[1]*(i-startonstep), 
						y = motif.trials_info.pos[2]+motif.trials_info.upcomingstep_text_offset[2]+motif.trials_info.spacing[2]*(i-startonstep),
						text = start.trialsdata.trial[ct].text[i]
					})
					start.trialsdata.draw[sub .. 'textline'][i]:draw()
				elseif motif.trials_info.trialslayout == 1 then
					--Horizontal layouts are much more complicated. Text is not drawn in horizontal mode, instead we only display the glyphs. A small sprite is dynamically tiled to the width of the 
					--glyphs, and an optional background element called an incrementor (bginc) can be used to link the pieces together (think of an arrow where the body of the arrow is where the 
					--glyphs are being drawn and that's the dynamically sized part, and the head of the arrow is the incrementor which is a fixed width sprite). There's quite a bit more work that 
					--goes into displaying the horizontal layouts because the code needs to figure out the window size, and determine when it needs to "go to the next line" and create a return so 
					--that trials can be displayed dynamically. Back to the arrow analogy, you always want an arrow body to have an arrow head, so the incrementor width is added to the glyphs length 
					--and the padding factor specified in the motif data, it's all added together until the window width is met or exceeded, then a line return occurs and the next line is drawn.
					local bgsize = {0,0}
					if start.trialsdata.bgelemdata[sub .. 'bgincwidth'] ~= nil then bgincwidth = math.floor(start.trialsdata.bgelemdata[sub .. 'bgincwidth'].Size[1]) end
					if start.trialsdata.bgelemdata[sub .. 'bgsize'] ~= nil then bgsize = start.trialsdata.bgelemdata[sub .. 'bgsize'].Size end
					totaloffset = start.trialsdata.trial[ct].glyphline[i].lengthOffset[#start.trialsdata.trial[ct].glyphline[i].lengthOffset]
					padding = motif.trials_info.spacing[1]
					accwidth = accwidth + totaloffset + padding + bgincwidth + padding
					if accwidth - motif.trials_info.spacing[1] > start.trialsdata.draw.windowXrange then
						accwidth = 0
						accwidth = accwidth + totaloffset + padding + bgincwidth + padding
						addrow = addrow + 1
					end
					tempoffset[2] = motif.trials_info.spacing[2]*(addrow)
					local gpoffset = 0
					for m in pairs(start.trialsdata.trial[ct].glyphline[i].glyph) do
						if m > 1 then gpoffset = start.trialsdata.trial[ct].glyphline[i].lengthOffset[m-1] end
						start.trialsdata.trial[ct].glyphline[i].pos[m][1] = motif.trials_info.pos[1] + start.trialsdata.trial[ct].glyphline[i].alignOffset[m] + (accwidth-totaloffset-bgincwidth-padding) + gpoffset-- + start.trialsdata.glyphline[ct][i][m].lengthOffset --+ motif.trials_info.spacing[1]*(i-1)),
					end
					bgtargetscale = {
						(padding + totaloffset + padding)/bgsize[1],
						1
					}
					bgtargetpos = {
						motif.trials_info.pos[1] + motif.trials_info[sub .. 'step_bg_offset'][1] + start.trialsdata.trial[ct].glyphline[i].alignOffset[1] + (accwidth-totaloffset-bgincwidth-2*padding), -- + start.trialsdata.glyphline[ct][i][m].lengthOffset),
						start.trialsdata.trial[ct].glyphline[i].pos[1][2] + motif.trials_info[sub .. 'step_bg_offset'][2] + tempoffset[2]
					}
					animSetScale(motif.trials_info[sub .. 'step_bg_data'], bgtargetscale[1], bgtargetscale[2])
					animSetPos(motif.trials_info[sub .. 'step_bg_data'], bgtargetpos[1], bgtargetpos[2])
					animUpdate(motif.trials_info[sub .. 'step_bg_data'])
					animDraw(motif.trials_info[sub .. 'step_bg_data'])
					if i ~= start.trialsdata.trial[ct].numsteps then
						local suffix = 'step_bginc_'
						if i == cts - 1 then suffix = 'step_bginctocts_' end -- -1 added for cts
						animSetPos(
							motif.trials_info[sub .. suffix .. 'data'], 
							motif.trials_info.pos[1] + motif.trials_info[sub .. suffix .. 'offset'][1] + start.trialsdata.trial[ct].glyphline[i].alignOffset[1] + (accwidth-bgincwidth), -- + start.trialsdata.glyphline[ct][i][m].lengthOffset),
							start.trialsdata.trial[ct].glyphline[i].pos[1][2] + motif.trials_info[sub .. suffix .. 'offset'][2] + tempoffset[2]
						)
						animUpdate(motif.trials_info[sub .. suffix .. 'data'])
						animDraw(motif.trials_info[sub .. suffix .. 'data'])
					end
				end
				for m in pairs(start.trialsdata.trial[ct].glyphline[i].glyph) do
					animSetScale(motif.glyphs_data[start.trialsdata.trial[ct].glyphline[i].glyph[m]].anim, start.trialsdata.trial[ct].glyphline[i].scale[m][1], start.trialsdata.trial[ct].glyphline[i].scale[m][2])
					animSetPos(motif.glyphs_data[start.trialsdata.trial[ct].glyphline[i].glyph[m]].anim, start.trialsdata.trial[ct].glyphline[i].pos[m][1], start.trialsdata.trial[ct].glyphline[i].pos[m][2]+tempoffset[2])
					animDraw(motif.glyphs_data[start.trialsdata.trial[ct].glyphline[i].glyph[m]].anim)
				end
			end
		elseif ct > start.trialsdata.numoftrials then
			-- All trials have been completed, draw the all clear and freeze the timer
			if start.trialsdata.draw.allclear ~= 0 then
				start.f_trialsSuccess('allclear', ct-1)
				main.f_createTextImg(motif.trials_info, 'allclear_text')
			end
			start.trialsdata.draw.success = 0
			start.trialsdata.draw.trialcounter:update({text = 'All Trials Clear'})
			start.trialsdata.draw.trialcounter:draw()

			local totaltimertext = motif.trials_info.totaltrialtimer_text
			local m, s, x = f_timeConvert(start.trialsdata.elapsedtime)
			totaltimertext = totaltimertext:gsub('%%s', m .. ":" .. s .. ":" .. x)
			start.trialsdata.draw.totaltrialtimer:update({text = totaltimertext})
			start.trialsdata.draw.totaltrialtimer:draw()

			local currenttimertext = motif.trials_info.currenttrialtimer_text
			local m, s, x = f_timeConvert(start.trialsdata.trial[ct-1].elapsedtime)
			currenttimertext = currenttimertext:gsub('%%s', m .. ":" .. s .. ":" .. x)
			start.trialsdata.draw.currenttrialtimer:update({text = currenttimertext})
			start.trialsdata.draw.currenttrialtimer:draw()
		end
	end
end

function start.f_trialsChecker()
	--This function sets dummy actions according to the character trials info and validates trials attempts
	--To help follow along, ct = current trial, cts = current trial step, ncts = next current trial step

	if ct <= start.trialsdata.numoftrials and start.trialsdata.draw.success == 0 and start.trialsdata.active then
		if start.trialsdata.trial[ct].ishelper[cts] and not start.trialsdata.trial[ct].helperfound[cts] then
			start.trialsdata.trial[ct].helperIDledger[cts] = id()
			start.trialsdata.trial[ct].stateledger[cts] = stateno(start.trialsdata.trial[ct].helperIDledger[cts])
			if start.trialsdata.trial[ct].stateledger[cts] == start.trialsdata.trial[ct].stateno[cts] then
				start.trialsdata.trial[ct].helperfound[cts]  = true
			end
		end

		-- Gating Criteria for Passing a Trial Step:
		-- You'll want to change this if you're doing something out of the ordinary with your game, but I've taken every step possible to 
		-- create the most universal trials checker possible. That said, this 'if' statement clause is what you'll want to change if you 
		-- need to modify the trials check logic. Here is the order of operation as shipped:
		-- 1) IF:
		-- 		a) stateno matches desired trials stateno AND
		-- 		b) optional animcheck matches the desired trials animno 
		-- 		OR
		--		c) projectile is trial step and projectile ID is matched to desired trials projID
		-- 		OR
		--		d) helper is trial step and the right helper was found and helper state matches trials stateno
		-- AND
		-- 2) IF: 
		--		a) move hit and we are NOT looking for a counterhit
		--		OR 
		--		b) move hit and we ARE looking for a counterhit and it is a counterhit
		--		OR
		--		c) is a throw
		--		OR
		--		d) is NOT a move that hits

		-- That's all you should have to change!

		if (stateno() == start.trialsdata.trial[ct].stateno[cts] and not(projcheck) and not(helpercheck) and (anim() == start.trialsdata.trial[ct].animno[cts] or start.trialsdata.trial[ct].animno[cts] == -2147483648) and ((hitpausetime() > 1 and movehit()) or start.trialsdata.trial[ct].isthrow[cts])) or --stateno and NOT projectile and NOT helper
		(projhittime(start.trialsdata.trial[ct].projid[cts]) == 0 and start.trialsdata.trial[ct].projcheck[cts]) then -- or --when we have a projectile, or
		--  --when we have a taunt
			ncts = cts + 1
			if ncts >= 1 and (combocount() > 0 or start.trialsdata.trial[ct].isnohit[cts]) then
				if ncts >= start.trialsdata.trial[ct].numsteps + 1 then
					start.trialsdata.currenttrial = ct + 1
					start.trialsdata.currenttrialstep = 1
					if ct < start.trialsdata.numoftrials then 
						if (motif.trials_info.success_front_displaytime == -1) and (motif.trials_info.success_bg_displaytime == -1) then
							start.trialsdata.draw.success = math.max(animGetLength(motif.trials_info.success_front_data), animGetLength(motif.trials_info.success_bg_data)) 
						else 
							start.trialsdata.draw.success = math.max(motif.trials_info.success_front_displaytime, motif.trials_info.success_bg_displaytime) 
						end
					end
				else
					start.trialsdata.currenttrialstep = ncts
					start.trialsdata.trial[ct].helperfound[cts]  = false
				end
			elseif ncts > 1 and combocount() == 0 and not start.trialsdata.trial[ct].isnohit[cts] then
				start.trialsdata.currenttrialstep = 1
				start.trialsdata.trial[ct].helperfound[cts]  = false
			end
		elseif combocount() == 0 and not start.trialsdata.trial[ct].isnohit[cts] then
			start.trialsdata.currenttrialstep = 1
			start.trialsdata.trial[ct].helperfound[cts]  = false
		end
	end

	--If the trial was completed successfully, draw the trials success
	if start.trialsdata.draw.success > 0 then
		start.f_trialsSuccess('success', ct)
		if start.trialsdata.draw.success == 0 and motif.trials_info.resetonsuccess == 1 then
			main.f_bgReset(motif.trialsbgdef.bg)
			main.f_fadeReset('fadein', motif.trials_info)
			-- this doesn't work the way i'm intending it to
		end
	end
end

function start.f_trialsSuccess(successstring, index)
	-- This function is responsible for drawing the Success banner after a trial is completed successfully.
	--
	-- charMapSet(2, '_iksys_trainingDummyMode', 0)
	-- charMapSet(2, '_iksys_trainingGuardMode', 0)
	-- charMapSet(2, '_iksys_trainingButtonJam', 0)
	sndPlay(motif.files.snd_data, motif.trials_info[successstring .. '_snd'][1], motif.trials_info[successstring .. '_snd'][2])
	animUpdate(motif.trials_info[successstring .. '_bg_data'])
	animDraw(motif.trials_info[successstring .. '_bg_data'])
	animUpdate(motif.trials_info[successstring .. '_front_data'])
	animDraw(motif.trials_info[successstring .. '_front_data'])
	start.trialsdata.draw[successstring] = start.trialsdata.draw[successstring] - 1
	main.f_createTextImg(motif.trials_info, successstring .. '_text')
	start.trialsdata.trial[index].complete = true
	start.trialsdata.trial[index].active = false
	if index ~= start.trialsdata.numoftrials then
		start.trialsdata.trial[index+1].starttick = tickcount()
	end
end

--;===========================================================
--; menu.lua
--;===========================================================
-- Build trials list for Trials pause menu

function menu.f_trialslistParse()
	pauseMenuTrialslist = {}
	for i = 1, start.trialsdata.numoftrials, 1 do
		pauseMenuTrialslist[i] = {itemname = i, displayname = start.trialsdata.trial[i].name}
	end
	return pauseMenuTrialslist
end

function menu.f_trialsMenu()
	menu.t_valuename.trialslist = {
		menu.f_trialslistParse()
	}	

	if main.t_sort.trials_info == nil or main.t_sort.trials_info.menu == nil or #main.t_sort.trials_info.menu == 0 then
		motif.setBaseTrialsInfo()
	end

	table.insert(menu.t_menus, {id = 'trials', section = 'trials_info', bgdef = 'trialsbgdef', txt_title = 'txt_title_trials', movelist = true})

	menu.t_itemname.trialslist = function()
		if main.f_input(main.t_players, {'pal', 's'}) then
			sndPlay(motif.files.snd_data, motif[section].cursor_done_snd[1], motif[section].cursor_done_snd[2])
			menu.f_trialslistParse()
			menu.itemname = t.items[item].itemname
		end
		return true
	end

	menu.t_vardisplay.trialslist = function()
		return menu.t_valuename.trialslist[menu.trialslist or 1].displayname
	end

	-- hook.run("menu.menu.loop")
end

function menu.f_trialsReset()
	for k, _ in pairs(menu.t_valuename) do
		menu[k] = 1
	end
	menu.ailevel = config.Difficulty
	for _, v in ipairs(menu.t_vardisplayPointers) do
		v.vardisplay = menu.f_vardisplay(v.itemname)
	end
	player(2)
	setAILevel(0)
	charMapSet(2, '_iksys_trainingDummyControl', 0)
	charMapSet(2, '_iksys_trainingDummyMode', 0)
	charMapSet(2, '_iksys_trainingGuardMode', 0)
	charMapSet(2, '_iksys_trainingFallRecovery', 0)
	charMapSet(2, '_iksys_trainingDistance', 0)
	charMapSet(2, '_iksys_trainingButtonJam', 0)
	start.trialsdata.currenttrial = 1
	start.trialsdata.currenttrialstep = 1
end

function start.f_trialsMode()
	-- This is the main function that gets hooked in when Trials mode is selected. Everything related to the trials mode branches off from this function.

	-- When the scene initializes in the trials game mode, a bool is set to initialize the trials data. If this bool exists, that means the player was doing some other trials run before and it has to be reset.
	-- The game mode looks for that bool. If it is false, it will call start.f_trialsBuilder and menu.f_trialsMenu.
	-- f_trialsBuilder is a function the pulls in all of the data from triggers built to share the contents of a trials.def. It builds a table that has all of the required information for each trial.
	-- f_trialsMenu builds the trials list such that the player can select whichever trial they want to attempt.
	-- Both of these functions are only invoked once. The bool created at game mode init is set to true.

	-- Once the player has control of the char, three functions run at every tick.
	-- f_trialsSetup is responsible for setting the dummy state. While it triggers every tick, it should only be setting the dummy state once per trial activation.
	-- f_trialsDrawer is responsible for displaying trials data on screen. As trial success is met, it updates graphic elements to communicate to the player progress in the trial.
	-- f_trialsChecker is responsible for checking what the current trial step is, whether it has been met, and whether the trial is successfully completed.

	if roundstart() and start.trialsInit == nil then
		start.trialsInit = false
	elseif roundstart() and start.trialsInit == true then
		-- this might break reset on success...
		start.trialsInit = false
		menu.f_trialsReset()
	end
	if gettrialinfo('trialspresent') then
		if not start.trialsInit then
			start.f_trialsBuilder()
			menu.f_trialsMenu()
		else
			start.f_trialsDrawer()
			start.f_trialsChecker()
		end
	end	
end

--;===========================================================
--; global.lua
--;===========================================================

hook.add("loop#trials", "f_trialsMode", start.f_trialsMode)
hook.add("menu.menu.loop", "f_trialsMenu", menu.f_trialsMenu)

-- Lua Hook System
-- Allows hooking additional code into existing functions, from within external
-- modules, without having to worry as much about your code being removed by
-- engine update.
-- * hook.run(list, ...): Runs all the functions within a certain list.
--   It won't do anything if the list doesn't exist or is empty. ... is any
--   number of arguments, which will be passed to every function in the list.
-- * hook.add(list, name, function): Adds a function to a hook list with a name.
--   It will replace anything in the list with the same name.
-- * hook.stop(list, name): Removes a hook from a list, if it's not needed.
-- Currently there are only few hooks available by default:
-- * loop: global.lua 'loop' function start (called by CommonLua)
-- * loop#[gamemode]: global.lua 'loop' function, limited to the gamemode
-- * main.f_commandLine: main.lua 'f_commandLine' function (before loading)
-- * main.f_default: main.lua 'f_default' function
-- * main.t_itemname: main.lua table entries (modes configuration)
-- * main.menu.loop: main.lua menu loop function (each submenu loop start)
-- * menu.menu.loop: menu.lua menu loop function (each submenu loop start)
-- * options.menu.loop: options.lua menu loop function (each submenu loop start)
-- * motif.setBaseTitleInfo: motif.lua default game mode items assignment
-- * motif.setBaseOptionInfo: motif.lua default option items assignment
-- * motif.setBaseMenuInfo: motif.lua default pause menu items assignment
-- * motif.setBaseTrainingInfo: motif.lua default training menu items assignment
-- * launchFight: start.lua 'launchFight' function (right before match starts)
-- * start.f_selectScreen: start.lua 'f_selectScreen' function (pre layerno=1)
-- * start.f_selectVersus: start.lua 'f_selectVersus' function (pre layerno=1)
-- * start.f_result: start.lua 'f_result' function (pre layerno=1)
-- * start.f_victory: start.lua 'f_victory' function (pre layerno=1)
-- * start.f_continue: start.lua 'f_continue' function (pre layerno=1)
-- * start.f_hiscore: start.lua 'f_hiscore' function (pre layerno=1)
-- * start.f_challenger: start.lua 'f_challenger' function (pre layerno=1)
-- * start.f_selectReset: start.lua 'f_selectReset' function (before returning)
-- More entry points may be added in future - let us know if your external
-- module needs to hook code in place where it's not allowed yet.