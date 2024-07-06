# Universal Trials Mode

This external module offers a universal solution for Trials Mode.

## Installation

1. Extract archive content into "./external/mods/trials" directory
2. Add DEF code to your screenpack `system.def`. Use the sample system.def additions from this file to your `system.def`.
3. Add sprites to system.sff, or alternatively, use `trials.sff`, found in "./external/mods/trials", included in this archive.
4. Add sounds to system.snd, or alternatively, use `trials.snd`, found in "./external/mods/trials", included in this archive.
5. Create new trials for your favorite characters. As a starting point, you can use the files found in "./external/mods/trials/kfmZ" and copy them into "./chars/kfmZ". Instructions for creating new trials are detailed in this file.

## General info


## system.def Customization
Using this external module allows full customization of the trials mode in system.def, with sprites in system.sff OR in `trials.sff`, if so desired. If you are using `trials.sff`, make sure you point to it in the system.def's [Files] section as `trialsbgdef = trials.sff`.

The universal trials mode supports both vertical trials readouts, and horizontal readouts made popular by KOF XIV, among others. The sample `system.def` included in this file 

```
[Trials Info]
    pos 				= 100,250				;Local coordinates for all Trials items
    spacing 			= 0,20					;Spacing between trial steps
    window				= 100,250, 1180,550 	;X1,Y1,X2,Y2: display window for trials--will create automated scrolling or line returns, depending on the trial layout of choice

    resetonsuccess		= 0 	;set to 1 to reset character position after each trial success (except the final one)--currently doesn't work
    trialslayout 		= 0		;set to 0 for vertical, 1 for horizontal--affects scrolling logic, as stated above, also enables dynamic step width

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
```

## Creating a Character's Trials Definition File

Trials data is created on a per-character basis. To specify new trials for a character, you'll want to create a new file in the character's folder to hold the trials data. For the purposes of this tutorial, I call this file `trials.def`, but you can call it whatever you want. As mentioned before, each character gets its own `trials.def`. You can specify as many trials as you want, in any order you want.

Each trial is preceeded by a header: `[TrialDef, Title]`, where `Title` is the name or title of the trial and is optional.


A sample `trials.def` for kfmZ is provided below.

```
; KFMZ TRIALS LIST ---------------------------

[TrialDef, KFM's First Trial] 				;Mandatory - [TriafDef] is required, the trial title after the comma is optional.
trial.dummymode			    = stand			;Optional - valid options are stand (default), crouch, jump, wjump. Defaults to stand if unspecified.
trial.guardmode			    = none			;Optional - valid options are none, auto. Defaults to none if unspecified.
trial.dummybuttonjam 	    = none			;Optional - valid options are none, a, b, c, x, y, z, start, d, w. Defaults to none if unspecified.

trialstep.1.text 		    = Strong Kung Fu Palm	;Optional - (string). Name for trial step (only displayed in vertical trials layout). I recommend always defining this.
trialstep.1.glyphs 		    = _QDF^Y  	            ;Optional - (string, see Glyph docs). same syntax as movelist glyphs. Glyphs are displayed in vertical and horizontal trials layouts. I recommend always defining this.

trialstep.1.stateno 		= 1010			;Mandatory - (integer or comma-separated integers). State to be checked to pass trial. This is the state whether it's the main character, a helper, or even a projectile.
trialstep.1.anim			=				;Optional - (integer or comma-separated integers). Identifies animno to be checked to pass trial. Useful in certain cases.
trialstep.1.numofhits		=				;Optional - (integer or comma-separated integers), will default to 1 if not defined. In some instances, you might want to specify a trial step to meet a multi-hit criteria before proceeding to the next trial step.
trialstep.1.isthrow 		= 				;Optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a throw. Should be 'true' is trial step is a throw.
trialstep.1.isnohit			= 				;Optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step does not hit the opponent, or does not increase the combo counter.
trialstep.1.iscounterhit	= 				;Optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step should be a counter hit. Typically does not work with helpers or projectiles.
trialstep.1.ishelper		= 				;Optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a helper. Should be 'true' is trial step is a hit from a helper.
trialstep.1.isproj			= 				;Optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a projectile. Should be 'true' is trial step is a hit from a projectile.
trialstep.1.specialbool 	=				;Optional - (true or false, or comma-separated true/false), will default to false if not defined. Can be used for custom games as required.
trialstep.1.specialvar		=				;Optional - (integer or comma-separated integers). Can be used for custom games as required.
trialstep.1.specialstr		=				;Optional - (string, or comma-separated strings). Can be used for custom games as required.

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
trialstep.1.glyphs 		= ^X_,^Y			; When desired, you can collapsed multiple steps into a single one but using comma separated values in the following parameters:
trialstep.1.stateno 	= 200, 210		; stateno, animno, numofhits, isthrow, iscounterhit, isnohit, ishelper, isproj, specialbool, specialvar, specialstr
trialstep.1.numofhits	= 1, 1			; If one parameter on the trial step is defined using comma separated values, all parameters on that trial step must be defined similarly.

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
; Files for the player
[Files]
cmd         = kfm.cmd           ;Command set
cns         = kfm.const         ;Constants
st          = kfm.zss           ;States
st2         = hits.zss
st3         = command.zss
st4         = AI.zss
stcommon    = common1.cns.zss   ;Common states (from data/ or motif)
sprite      = kfmZ.sff          ;Sprite
anim        = kfm.air           ;Animation
sound       = kfm.snd           ;Sound
ai          = kfm.ai            ;AI hints data (not used)
movelist    = movelist.dat      ;Ikemen feature: Movelist
trials      = trials.def        ;Ikemen feature: Trials mode data
```
