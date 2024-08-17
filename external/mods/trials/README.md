# Universal Trials Mode
> Last tested on Ikemen GO v0.99

> Module developed by two4teezee
---
This external module offers a universal solution for Trials Mode. This markdown file is best viewed in Github or your favorite markdown file viewer.

## Installation
1. Extract archive content into "./external/mods/trials" directory
2. Add DEF code to your screenpack's `system.def`. Use the sample DEF code additions from this file to your `system.def`.
3. Add "external/mods/trials/trials.zss" to `CommonStates` in "./save/config.json".
4. Add sprites to system.sff, or alternatively, create a `trials.sff`, as required.
5. Add sounds to system.snd, as required.
6. Create new trials for your character(s). As a starting point, you can use the templates found in this file to create a `trials.def` file and edit `kfmZ.def`, both in "./chars/kfmZ". You can follow the instructions in the template to create trials for any character you would like. I also have created some trials and am sharing them on Github.
7. Share your trials definition files with others!

## General info
The Trials Mode provides new screenpack features and engine features so that creators can create trials for their character creations, and fully customize the way the trials are presented. The Trials Mode ships with several options for display of trials data inside the game mode, a variety of pause menu options to navigate the trials for each character, and the ability to apply palfx to character portraits in the Select Screen to easily convey which characters have valid Trials definition files.

## system.def Template and Customization
Using this external module allows full customization of the trials mode in system.def, with sprites in `system.sff` or in `trials.sff`, if so desired. If you are using `trials.sff`, make sure you point to it in the system.def's [Files] section as `trialsbgdef = trials.sff`.

The universal trials mode supports **vertical** trials readouts, and **horizontal** readouts as seen in KOF XIV, among other games. The sample `system.def` included in this file can be configured to support either layouts, but as shown, it is configured to work exclusively with default assets (only uses fonts and stock glyphs, for instance). Below you'll find a brief summary of screenpack features supported by trials mode. For more detail, please consult the example `system.def` templates provided in this file for both vertical and horizontal layouts.

You can make the trials mode look as fancy or as basic as you want. The default trials mode example shipped with this module leverage "stock" Ikemen fonts and sprites in the most minimal way possible.

- A window must be specified in which the trial steps are drawn. This feature enables long trial lists that need to scroll (for vertical layouts) or have line returns and potentially scrolling (for horizontal layouts).
- The trial title name can optionally be displayed. Text and two background elements (bg and front) can be specified.
- Trial steps come in three flavors: upcoming, current, and completed. Text and background elements can be specified for each type. 
	- For horizontal layouts, the background elements are handled differently. Background elements are tiled dynamically to fit the width and height of the glyphs and desired padding around the glyph for that step.
    - Additionally, each trial step type has an "incrementor" background element. This incrementor is displayed between trial steps (for instance, as an arrow). Upcoming and current step both have incrementors, while completed steps have incrementors to other completed step, as well as an incrementor to the current step (since they could be formatted differently, for instance).
	- Note that trial step text is not displayed in horizontal layouts.
- A static or animated background can be displayed for all trial steps. This background is independent of all trial step backgrounds, and is only displayed when a trial is active.
- Glyphs can be automatically scaled according to the font used (especially useful for vertical layouts).
	- Glyphs are optional for vertical layouts, but they are mandatory for horizontal layouts as text is not displayed in horizontal layouts.
- For Success and All Clear events, text and sound elements, as well as two background elements (bg and front) can be specified.
- Two timers are available: one keeps track of the entire time spent on the trials, while the other keeps track of the time spent on the current trial. Display of the timers is optional. Utilization of the various pause menu functions (such as skipping to the nex trial) will void the total timer, for instance.
- A text string that shows the current trial can optionally be displayed.

```
[Trials Mode]
; resetonsuccess: set to "true" to reset character positions after each trial success (except the final one). Can optionally specify fadein and fadeout parameters - will default to shown values.
; trialslayout: "vertical" or "horizontal" are the only valid values. Defaults to "vertical" if not specified. Affects scrolling logic, as stated above, also enables dynamic step width
; ==========================
resetonsuccess = "false"
trialslayout = "vertical"

; selscreenpalfx: sets specified palfx color to character portraits WITHOUT trials files in the trials select screen. See definition for palfx for different fields and options.
; ==========================
selscreenpalfx.color = 0
; selscreenpalfx.invertall = 0
; selscreenpalfx.sinadd = 0, 0, 0, 0
; selscreenpalfx.mul = 0, 0, 0
; selscreenpalfx.add = 0, 0, 0

; fadein/fadeout: used when "resetonsuccess" is set to true; defaults to the commented values below.
; fadein.time = 40, --Ikemen feature
; fadein.col = {0, 0, 0}, --Ikemen feature
; fadein.anim = -1, --Ikemen feature
; fadeout.time = 40, --Ikemen feature
; fadeout.col = {0, 0, 0}, --Ikemen feature
; fadeout.anim = -1, --Ikemen feature

; trialsteps.pos: local origin from which trial steps are drawn. Other elements have their own origin specifications.
; trialsteps.spacing: spacing between trial steps.
; trialsteps.window: X1,Y1,X2,Y2: display window for trials--will create automated scrolling or line returns, depending on the trial layout of choice
; ==========================
trialsteps.pos = 42,40
trialsteps.spacing = 0,11
trialsteps.window = 40,40, 320,240

; upcomingstep: text and background elements, shown for all upcoming trial steps
; ==========================
upcomingstep.text.offset = 0,0
upcomingstep.text.font = 1, 0, 1, 255, 255, 255
upcomingstep.text.scale	= 1,1
; upcomingstep.text.font.height	=
; upcomingstep.bg.offset = -10,-6
; upcomingstep.bg.anim = 609
; upcomingstep.bg.spr = 701,1
; upcomingstep.bg.scale = 1,1
; upcomingstep.bg.displaytime = -1
; upcomingstep.bg.palfx.color = 256
; upcomingstep.bg.palfx.invertall = 0
; upcomingstep.bg.palfx.sinadd = 0, 0, 0, 0
; upcomingstep.bg.palfx.mul = 0, 0, 0
; upcomingstep.bg.palfx.add = 0, 0, 0
; upcomingstep.glyphs.palfx.color = 256
; upcomingstep.glyphs.palfx.invertall = 0
; upcomingstep.glyphs.palfx.sinadd = 0, 0, 0, 0
; upcomingstep.glyphs.palfx.mul = 0, 0, 0
; upcomingstep.glyphs.palfx.add = 0, 0, 0

; upcomingstep.bginc: ONLY FOR HORIZONTAL LAYOUTS - background element for an increment separator between upcoming horizontal steps
; ==========================
; upcomingstep.bginc.offset = 0,-14
; upcomingstep.bginc.anim = -1
; upcomingstep.bginc.spr = 702,4
; upcomingstep.bginc.scale = 1,1
; upcomingstep.bginc.facing = 1

; currentstep: text and background elements, shown for current trial step
; ==========================
currentstep.text.offset = 0,0
currentstep.text.font = 1, 0, 1, 255, 255, 0
currentstep.text.scale = 1,1
; currentstep.text.font.height =
currentstep.bg.offset = -2,0
; currentstep.bg.anim = -1
currentstep.bg.spr = 190,0
currentstep.bg.scale = .8,.8
currentstep.bg.facing = -1
; currentstep.bg.displaytime = -1
; currentstep.bg.palfx.color = 256
; currentstep.bg.palfx.invertall = 0
; currentstep.bg.palfx.sinadd = 0, 0, 0, 0
; currentstep.bg.palfx.mul = 0, 0, 0
; currentstep.bg.palfx.add = 0, 0, 0
; currentstep.glyphs.palfx.color = 256
; currentstep.glyphs.palfx.invertall = 0
; currentstep.glyphs.palfx.sinadd = 0, 0, 0, 0
; currentstep.glyphs.palfx.mul = 0, 0, 0
; currentstep.glyphs.palfx.add = 0, 0, 0

; currentstep.bginc: ONLY FOR HORIZONTAL LAYOUTS - background element for an increment separator between current horizontal steps
; ==========================
; currentstep.bginc.offset = 0,-14
; currentstep.bginc.anim = -1
; currentstep.bginc.spr = 702,2
; currentstep.bginc.scale = 1,1
; currentstep.bginc.facing = 1

; completedstep: text and background elements, shown for completed trial steps
; ==========================
completedstep.text.offset = 0,0
completedstep.text.font = 1, 0, 1, 100, 100, 100
completedstep.text.scale = 1,1
; completedstep.text.font.height = 
; completedstep.bg.offset = -10,-6
; completedstep.bg.spr = 701,2
; completedstep.bg.anim = 2
; completedstep.bg.scale = 1,1
; completedstep.bg.facing = 1
; completedstep.bg.displaytime = -1
; completedstep.bg.palfx.color = 256
; completedstep.bg.palfx.invertall = 0
; completedstep.bg.palfx.sinadd = 0, 0, 0, 0
; completedstep.bg.palfx.mul = 0, 0, 0
; completedstep.bg.palfx.add = 0, 0, 0
completedstep.glyphs.palfx.color = 0
; completedstep.glyphs.palfx.invertall = 0
; completedstep.glyphs.palfx.sinadd = 0, 0, 0, 0
; completedstep.glyphs.palfx.mul = 0, 0, 0
; completedstep.glyphs.palfx.add = 0, 0, 0

; completedstep.bginc: ONLY FOR HORIZONTAL LAYOUTS - background element for an increment separator between completed horizontal steps
; completedstep.bginctoCTS: ONLY FOR HORIZONTAL LAYOUTS - background element for an increment separator between horizontal steps (latest completed step to the current trial step)
; ==========================
; completedstep.bginc.offset = 0,-14
; completedstep.bginc.anim = -1
; completedstep.bginc.spr = 702,0
; completedstep.bginc.scale = 1,1
; completedstep.bginc.facing = 1
; completedstep.bginctoCTS.offset = 0,-14
; completedstep.bginctoCTS.anim = -1
; completedstep.bginctoCTS.spr = 702,6
; completedstep.bginctoCTS.scale = 1,1
; completedstep.bginctoCTS.facing = 1

; glyphs: defines glyphs offset from respective trial step, as well as scale and alignment
; ==========================
glyphs.offset = 100,2
glyphs.scale = 0.125,0.125
glyphs.scalewithtext = "false" 	; Scales glyph height with respect to the font height. Only works for vertical trial layouts.
glyphs.spacing = 0,0
glyphs.align = 1

; bg: A background element can be specified to be displayed during all trials.
; ==========================
; bg.layerno = 2
; bg.offset = 0,0
; bg.anim = 1
; bg.scale = 1.5,1.5
; bg.spr = 399,0

; trialcounter: text element, displays current trial number and total number of trials
; Can display a different string when all trials are clear, or when no trials data is found when loading the character
; ==========================
trialcounter.pos = 10,235
trialcounter.font = 1,0,1
trialcounter.text.scale	= 1,1
; trialcounter.font.height	=
trialcounter.text = "Trial %s of %t"
trialcounter.allclear.text = "All Trials Clear"
trialcounter.notrialsdata.text = "No Trials Data Found"

; totaltrialtimer: text element, stopwatch can display the total time spent in the trial mode
; ==========================
totaltrialtimer.pos	= 310,228
totaltrialtimer.font = 1,0,-1
totaltrialtimer.text.scale	= 1,1
; totaltrialtimer.font.height =
totaltrialtimer.text = "Trial Timer: %s"

; currenttrialtimer: text element, stopwatch that shows time spent on current trial step
; ==========================
currenttrialtimer.pos = 310,235
currenttrialtimer.font = 1,0,-1
currenttrialtimer.text.scale = 1,1
; currenttrialtimer.font.height	=
currenttrialtimer.text = "Current Trial: %s"

; trialtitle: positioning, text, and animation (bg and front elements) for trial title. Displayed while trial is active.
; ==========================
trialtitle.pos = 42,40
trialtitle.text.offset = 0,-7
trialtitle.text.font = 1,0,1, 255, 100, 100
; trialtitle.text.text = "Trial: %s"
; trialtitle.text.scale = 
; trialtitle.text.font.height	=
; trialtitle.bg.offset = -11,-11
; trialtitle.bg.anim = 301
; trialtitle.bg.scale = 1,1
; trialtitle.bg.spr = 701,4
; trialtitle.bg.displaytime = -1
; trialtitle.front.offset = 0,0
; trialtitle.front.anim = 651
; trialtitle.front.scale = 1,1
; trialtitle.front.spr = 701,0
; trialtitle.front.displaytime = -1

; success: positioning, sound, text, and animation (bg and front elements) upon trial success. Displayed after each completed trial except the final one.
; ==========================
success.pos	= 160,120
success.snd	= 600,0 
success.text.text = "SUCCESS!"
success.text.offset = 0,0
success.text.font = 2,0,0, 255, 100, 100
success.text.displaytime = 70
success.text.scale = 4,4
; success.text.font.height =
; success.bg.offset = 0,0
; success.bg.anim = 650
; success.bg.scale = 1,1
; success.bg.spr = 701,0
; success.bg.displaytime = -1
; success.front.offset = 0,0
; success.front.anim = 651
; success.front.scale = 1,1
; success.front.spr = 701,0
; success.front.displaytime	= -1

; allclear: positioning, sound, text, and animation (bg and front elements) upon final trial success. Displayed after completing the final trial.
; ==========================
allclear.pos = 160,120
allclear.snd = 900,0
allclear.text.text = "ALL CLEAR!"
allclear.text.offset = 0,0
allclear.text.font = 2,0,0, 255, 100, 100
allclear.text.displaytime	= 70
allclear.text.scale	= 4,4
; allclear.text.font.height	=
; allclear.bg.offset = 0,0
; allclear.bg.anim = 650
; allclear.bg.scale = 1,1
; allclear.bg.spr = 701,0
; allclear.front.offset = 0,0
; allclear.front.anim = 652
; allclear.front.scale = 1,1
; allclear.front.spr = 701,0

[TrialsBgDef] ;Ikemen feature
	spr = ""
	bgclearcolor = 0, 0, 0
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
; trial.showforvarvalpairs	= 

trialstep.1.text 		    = Strong Kung Fu Palm
trialstep.1.glyphs 		    = _QDF^Y
; trialstep.1.validforvarvalpairs = 

trialstep.1.stateno 		= 1010
; trialstep.1.anim			=
; trialstep.1.numofhits		=
; trialstep.1.isthrow 		=
; trialstep.1.isnohit		=
; trialstep.1.iscounterhit	=
; trialstep.1.ishelper		=
; trialstep.1.isproj		=
; trialstep.1.validuntilnexthit = 

; TrialDef Parameter Descriptions
; ===============================
; [TriafDef, TrialTitle] - [TrialDef] mandatory - trial title after the comma is optional.

; trial.dummymode - optional - valid options are stand (default), crouch, jump, wjump. Defaults to stand if unspecified.
; trial.guardmode - optional - valid options are none, auto. Defaults to none if unspecified.
; trial.dummybuttonjam - optional - valid options are none, a, b, c, x, y, z, start, d, w. Defaults to none if unspecified.
; trial.showvarvalpairs - optional - (comma-separated integers, specified in pairs, can specify 0..n pairs). Used to determine whether a trial should be displayed based on the specified variable and value pair(s) in this field. Useful if a trial should only be displayed when character has a specific variable/value pair set, such as being in a specific groove or mode. If specified, the trial will only be displayed if all variable-value pairs return true. These variable-value pairs should only be for the character (not for helpers).

; dummymode, guardmode, and dummybuttonjam are defined once per trial. The other parameters can be defined for each trial step - notice the syntax, where X is the trial number.

; trialstep.X.text - optional - (string). Text for trial step (only displayed in vertical trials layout).
; trialstep.X.glyphs - optional - (string, see Glyph documentation [https://github.com/ikemen-engine/Ikemen-GO/wiki/Miscellaneous-info#movelists] for syntax). Same syntax as movelist glyphs. Glyphs are displayed in vertical and horizontal trials layouts.
; trialstep.X.validforvarvalpairs - optional - (comma-separated integers, specified in pairs, can specify 0..n pairs). Sister functionality to "showforvarvalpairs". These variable-value pairs are used to optionally check a trial step. Useful if you are forcing the trial step to be completed when certain var-val pairs are met (for instance, while in a custom combo state). Variable-value pairs are considered valid for entire trial step (regardless if the trial step is specified using condensed terminology).

; trialstep.X.stateno - mandatory - (integer or comma-separated integers). State to be checked to pass trial. This is the state whether it's the main character, a helper, or even a projectile.
; trialstep.X.anim - optional - (integer or comma-separated integers). Identifies animno to be checked to pass trial. Useful in certain cases.
; trialstep.X.numofhits - optional - (integer or comma-separated integers), will default to 1 if not defined. In some instances, you might want to specify a trial step to meet a multi-hit criteria before proceeding to the next trial step.
; trialstep.X.isthrow - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a throw. Should be 'true' is trial step is a throw.
; trialstep.X.isnohit - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step does not hit the opponent, or does not increase the combo counter.
; trialstep.X.iscounterhit - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step should be a counter hit. Typically does not work with helpers or projectiles.
; trialstep.X.ishelper - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a helper. Should be 'true' is trial step is a hit from a helper.
; trialstep.X.isproj - optional - (true or false, or comma-separated true/false), will default to false if not defined. Identifies whether the trial step is a projectile. Should be 'true' is trial step is a hit from a projectile.
; trialstep.X.validuntilnexthit - optional (true or false, or comma-separate true/false), will default to false if not defined. Makes the trials checking logic pause until the next hit is registered.

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
; The next two trials show examples of condensed trial steps which check a series of parameters sequentially by using comma separated values as part of a single trial step. In other words, think of being able to specify multiple trial steps in a single step.
; For instance, this trial is the same as the previous, but the two steps are condensed into one.
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

## Pause Menu Options

Trials Mode ships with the several pause menu options. Customizing the pause menu must be done by editing the `motif.setBaseTrialsInfo()` in `trials.lua`.
- **Next Trial**: advance to the next trial
- **Previous Trial**: return to the previous trial
- **Trials List**: view a list of the trials, and select the one to activate
- **Trial Advancement**: toggles between either Auto-Advance or Repeat, allows the player to play a single trial on repeat if desired