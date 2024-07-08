# Universal Trials Mode
> Last tested on Ikemen GO v0.99

> Module developed by two4teezee
---
This external module offers a universal solution for Trials Mode. This markdown file is best viewed in Github or your favorite markdown file viewer.

## Installation
1. Extract archive content into "./external/mods/trials" directory
2. Add DEF code to your screenpack's `system.def`. Use the sample DEF code additions from this file to your `system.def`.
3. Add sprites to system.sff, or alternatively, create a `trials.sff`.
4. Add sounds to system.snd.
5. Create new trials for your favorite characters and share them with others! As a starting point, you can use the templates found in this file to create a `trials.def` file and edit `kfmZ.def`, both in "./chars/kfmZ". You can follow the instructions in the template to create trials for any character you would like. I also have created some trials and am sharing them on Github.

## General info
The Trials mode 

## system.def Template and Customization
Using this external module allows full customization of the trials mode in system.def, with sprites in system.sff OR in `trials.sff`, if so desired. If you are using `trials.sff`, make sure you point to it in the system.def's [Files] section as `trialsbgdef = trials.sff`.

The universal trials mode supports both vertical trials readouts, and horizontal readouts as seen in KOF XIV, among other games. The sample `system.def` included in this file can be configured to support either layouts, but as shown, it is configured to work exclusively with default assets (only uses fonts and stock glyphs, for instance).

```
[Trials Info] ;VERTICAL EXAMPLE
	trialsteps.pos 				= 40,40
	trialsteps.spacing 			= 0,7
	trialsteps.window			= 40,40, 320,240
	trialsteps.resetonsuccess	= 0
	trialsteps.trialslayout 	= 0
	; trialsteps.pos: local origin from which trial steps are drawn. Other elements have their own origin specifications.
    ; trialsteps.spacing: spacing between trial steps.
    ; trialsteps.window: X1,Y1,X2,Y2: display window for trials--will create automated scrolling or line returns, depending on the trial layout of choice
	; trialsteps.resetonsuccess: set to 1 to reset character position after each trial success (except the final one)--currently doesn't work
    ; trialsteps.trialslayout: "vertical" or "horizontal" are the only valid values. Defaults to "vertical" if not specified. Affects scrolling logic, as stated above, also enables dynamic step width

	upcomingstep.text.offset		= 0,0
	upcomingstep.text.font			= 1, 0, 1, 255, 255, 255
	upcomingstep.text.scale			= 1,1
	;upcomingstep.text.font.height	=
	;upcomingstep.bg.offset 		= -10,-6
	;upcomingstep.bg.anim			= 609
	;upcomingstep.bg.spr			= 701,1
	;upcomingstep.bg.scale			= 1,1
	;upcomingstep.bg.displaytime	= -1
	; upcomingstep: text and background elements, shown for all upcoming trial steps

	currentstep.text.offset 		= 0,0
	currentstep.text.font 			= 1, 0, 1, 255, 255, 0
	currentstep.text.scale 			= 1,1
	;currentstep.text.font.height	=
	;currentstep.bg.offset 			= -10,-6
	;currentstep.bg.anim 			= -1
	;currentstep.bg.spr 			= 701,0
	;currentstep.bg.scale			= 1,1
	;currentstep.bg.facing			= 1
	;currentstep.bg.displaytime		= -1
	; currentstep: text and background elements, shown for current trial step

	completedstep.text.offset		= 0,0
	completedstep.text.font 		= 1, 0, 1, 100, 100, 100
	completedstep.text.scale		= 1,1
	;completedstep.text.font.height = 
	;completedstep.bg.offset 		= -10,-6
	;completedstep.bg.spr 			= 701,2
	;completedstep.bg.anim 			= 2
	;completedstep.bg.scale 		= 1,1
	;completedstep.bg.facing		= 1
	;completedstep.bg.displaytime	= -1
	; completedstep: text and background elements, shown for completed trial steps

	glyphs.offset	= 80,2
	glyphs.scale	= 1,1
	glyphs.spacing	= 0,0
	glyphs.align	= 1
	; glyphs: defines glyphs offset from respective trial step, as well as scale and alignment

	;bg.layerno = 2
	;bg.offset 	= 0,0
	;bg.anim 	= 1
	;bg.scale 	= 1.5,1.5
	;bg.spr 	= 399,0
	; bg: A background element can be specified to be displayed during all trials.

	trialcounter.pos			= 10,235
	trialcounter.font			= 1,0,1
	trialcounter.text.scale		= 1,1
	;trialcounter.font.height	=
	trialcounter.text			= "Trial %s of %t"
  	trialcounter.allclear.text 	= "All Trials Complete"
	; trialcounter: text element, displays current trial number and total number of trials

	totaltrialtimer.pos			= 310,228
	totaltrialtimer.font		= 1,0,-1
	totaltrialtimer.text.scale	= 1,1
	;totaltrialtimer.font.height=
	totaltrialtimer.text		= "Trial Timer: %s"
	; totaltrialtimer: text element, stopwatch can display the total time spent in the trial mode

	currenttrialtimer.pos			= 310,235
	currenttrialtimer.font			= 1,0,-1
	currenttrialtimer.text.scale	= 1,1
	;currenttrialtimer.font.height	=
	currenttrialtimer.text			= "Current Trial: %s"
	; currenttrialtimer: text element, stopwatch that shows time spent on current trial step

	success.pos					= 120,80
	success.snd					= 600,0 
	success.text.text			= "SUCCESS!"
	success.text.offset 		= 0,0
	success.text.font			= 2,0,0, 255, 100, 100
  	success.text.displaytime	= 70
	success.text.scale 			= 5,5
	;success.text.font.height	=
	;success.bg.offset 			= 0,0
	;success.bg.anim 			= 650
	;success.bg.scale 			= 1,1
	;success.bg.spr 			= 701,0
	;success.bg.displaytime		= -1
	;success.front.offset 		= 0,0
	;success.front.anim 		= 651
	;success.front.scale 		= 1,1
	;success.front.spr 			= 701,0
	;success.front.displaytime	= -1
	; success: positioning, sound, text, and animation (bg and front elements) upon trial success.
	; Displayed after each completed trial except the final one.

	allclear.pos				= 120,80
	allclear.snd				= 900,0
	allclear.text.text			= "ALL CLEAR!"
	allclear.text.offset 		= 0,0
	allclear.text.font 			= 2,0,1, 255, 100, 100
  	allclear.text.displaytime	= 70
	;allclear.text.scale		= 2,2
	;allclear.text.font.height	=
	;allclear.bg.offset 		= 0,0
	;allclear.bg.anim 			= 650
	;allclear.bg.scale 			= 1,1
	;allclear.bg.spr 			= 701,0
	;allclear.front.offset 		= 0,0
	;allclear.front.anim 		= 652
	;allclear.front.scale 		= 1,1
	;allclear.front.spr 		= 701,0
	; allclear: positioning, sound, text, and animation (bg and front elements) upon final trial success.
	; Displayed after completing the final trial.
	
	; https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features/#submenus
	; If custom menu is not declared, following menu is loaded by default:
	;menu.itemname.back 					= "Continue"
	;menu.itemname.menutrials 				= "Trials Menu"
	;menu.itemname.menutrials.trialslist 	= "Trials List"
	;menu.itemname.menutraining.back 		= "Back"
	;menu.itemname.menuinput 				= "Button Config"
	;menu.itemname.menuinput.keyboard 		= "Key Config"
	;menu.itemname.menuinput.gamepad 		= "Joystick Config"
	;menu.itemname.menuinput.empty 			= ""
	;menu.itemname.menuinput.inputdefault 	= "Default"
	;menu.itemname.menuinput.back 			= "Back"
	;menu.itemname.commandlist 				= "Command List"
	;menu.itemname.characterchange 			= "Character Change"
	;menu.itemname.exit 					= "Exit"

[TrialsBgDef] ;Ikemen feature
	spr 			= ""
	bgclearcolor 	= 0, 0, 0
```

## Creating a Character's Trials Definition File

Trials data is created on a per-character basis. To specify new trials for a character, you'll want to create a new file in the character's folder to hold the trials data. For the purposes of this tutorial, I name this file `trials.def`, but you can call it whatever you want. As mentioned before, each character gets its own `trials.def`. You can specify as many trials as you want, in any order you want.

A sample `trials.def` for kfmZ is provided below. The trials are presented to the player in the order in which they are listed in `trials.def`. Detailed information for each configurable parameter can be found in this template.

```
; KFMZ TRIALS LIST ---------------------------

[TrialDef, KFM's First Trial]

trial.dummymode			    = stand
trial.guardmode			    = none
trial.dummybuttonjam 	    = none

trialstep.1.text 		    = Strong Kung Fu Palm
trialstep.1.glyphs 		    = _QDF^Y

trialstep.1.stateno 		= 1010
; trialstep.1.anim			=
; trialstep.1.numofhits		=
; trialstep.1.isthrow 		=
; trialstep.1.isnohit		=
; trialstep.1.iscounterhit	=
; trialstep.1.ishelper		=
; trialstep.1.isproj		=
; trialstep.1.specialbool 	=
; trialstep.1.specialvar	=
; trialstep.1.specialstr	=

; TrialDef Parameter Descriptions

; [TriafDef, TrialTitle] - [TrialDef] mandatory - trial title after the comma is optional.

; trial.dummymode - optional - valid options are stand (default), crouch, jump, wjump. Defaults to stand if unspecified.
; trial.guardmode - optional - valid options are none, auto. Defaults to none if unspecified.
; trial.dummybuttonjam - optional - valid options are none, a, b, c, x, y, z, start, d, w. Defaults to none if unspecified.
; dummymode, guardmode, and dummybuttonjam are defined once per trial. The other parameters can be defined for each trial step - notice the syntax, where X is the trial number.

; trial.X.text - optional - (string). Text for trial step (only displayed in vertical trials layout).
; trial.X.glyphs - optional - (string, see Glyph documentation [https://github.com/ikemen-engine/Ikemen-GO/wiki/Miscellaneous-info#movelists] for syntax). same syntax as movelist glyphs. Glyphs are displayed in vertical and horizontal trials layouts.
; trialstep.X.stateno - mandatory - (integer or comma-separated integers). State to be checked to pass trial. This is the state whether it's the main character, a helper, or even a projectile.
; trialstep.X.anim - optional - (integer or comma-separated integers). Identifies animno to be checked to pass trial. Useful in certain cases.
; trialstep.X.numofhits - optional - (integer or comma-separated integers), will default to 1 if not defined. In some instances, you might want to specify a trial step to meet a multi-hit criteria before proceeding to the next trial step.
; trialstep.X.isthrow - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a throw. Should be 'true' is trial step is a throw.
; trialstep.X.isnohit - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step does not hit the opponent, or does not increase the combo counter.
; trialstep.X.iscounterhit - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step should be a counter hit. Typically does not work with helpers or projectiles.
; trialstep.X.ishelper - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a helper. Should be 'true' is trial step is a hit from a helper.
; trialstep.X.isproj - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a projectile. Should be 'true' is trial step is a hit from a projectile.
; trialstep.X.specialbool - optional - (true or false, or comma-separated true/false), will default to false if not defined. Can be used for custom games as required.
; trialstep.X.specialval - optional - (integer or comma-separated integers). Can be used for custom games as required.
; trialstep.X.specialstr - optional - (string, or comma-separated strings). Can be used for custom games as required.

;---------------------------------------------

[TrialDef, Kung Fu Throw]
trialstep.1.text 		= Kung Fu Throw
trialstep.1.glyphs 		= [_B/_F]_+^Y
trialstep.1.stateno 	= 810
trialstep.1.isthrow		= true

;---------------------------------------------

[TrialDef, Kung Fu Taunt]
trialstep.1.text 		= Kung Fu Taunt
trialstep.1.glyphs 		= ^S
trialstep.1.stateno 	= 195
trialstep.1.isnohit		= true

;---------------------------------------------

[TrialDef, Standing Punch Chain]
trialstep.1.text 		= Standing Light Punch
trialstep.1.glyphs 		= ^X
trialstep.1.stateno 	= 200

trialstep.2.text 		= Standing Strong Punch
trialstep.2.glyphs 		= ^Y
trialstep.2.stateno 	= 210

;---------------------------------------------

[TrialDef, Condensed Standing Punch Chain]
; The next two trials show examples ofcondensed trial steps which check a series of parameters sequentially by using comma separated values. In other words, think of being able to specify multiple trial steps in a single step.
; For instance, this trial is the same as the previous, but has two steps condensed into one.
; The next trial uses a combination of condensed steps and normal steps to provide a concise trial.
; Condensed steps can be very practical for multi-state moves where the trial step should only clear if all of the states are met, without having to create multiple trial steps.

trialstep.1.text 		= Standing Light to Strong Punch Chain		
trialstep.1.glyphs 		= ^X_-^Y			
trialstep.1.stateno 	= 200, 210		
trialstep.1.numofhits	= 1, 1

; When desired, you can collapsed multiple steps into a single one but using comma separated values in the following parameters:
; stateno, animno, numofhits, isthrow, iscounterhit, isnohit, ishelper, isproj, specialbool, specialvar, specialstr
; If one parameter on the trial step is defined using comma separated values, all parameters on that trial step must be defined similarly.

;---------------------------------------------

[TrialDef, Kung Fu Juggle Combo]
trialstep.1.text 		= Kung Fu Knee and Extra Kick
trialstep.1.glyphs 		= _F_F_+^K_.^K
trialstep.1.stateno 	= 1060, 1055

trialstep.2.text 		= Crouching Jab
trialstep.2.glyphs 		= _D_+^X
trialstep.2.stateno 	= 400

trialstep.3.text 		= Weak Kung Fu Palm
trialstep.3.glyphs 		= _QCF_+^X
trialstep.3.stateno 	= 1000

;---------------------------------------------

[TrialDef, Kung Fu Fist Four Piece]
trialstep.1.text 		= Jumping Strong Punch
trialstep.1.glyphs 		= _AIR^Y
trialstep.1.stateno 	= 610

trialstep.2.text 		= Standing Light Punch
trialstep.2.glyphs 		= ^X
trialstep.2.stateno 	= 200

trialstep.3.text 		= Standing Strong Punch
trialstep.3.glyphs 		= ^Y
trialstep.3.stateno 	= 210

trialstep.4.text 		= Strong Kung Fu Palm
trialstep.4.glyphs 		= _QDF^Y
trialstep.4.stateno 	= 1010

;---------------------------------------------

[TrialDef, Kung Fu Super Cancel]
trialstep.1.text 		= Jumping Strong Kick
trialstep.1.glyphs 		= _AIR^B
trialstep.1.stateno 	= 640

trialstep.2.text 		= Standing Light Kick
trialstep.2.glyphs 		= ^A
trialstep.2.stateno 	= 230

trialstep.3.text 		= Standing Strong Kick
trialstep.3.glyphs 		= ^B
trialstep.3.stateno 	= 240

trialstep.4.text 		= Fast Kung Fu Zankou
trialstep.4.glyphs 		= _QDF^A^B
trialstep.4.stateno 	= 1420

trialstep.5.text 		= Triple Kung Fu Palm
trialstep.5.glyphs 		= _QDF_QDF^P
trialstep.5.stateno 	= 3000
trialstep.5.numofhits   = 3
```

## Editing the Character's Def File

Finally, you'll want to modify the character's definition file so that Ikemen knows to read the trials data for that character. In the character's definition file (i.e. `kfmZ.def` for kfmZ), under `[Files]`, add the line `trials = trials.def`.

```
[Files]
trials = trials.def        ;Ikemen feature: Trials mode data
```