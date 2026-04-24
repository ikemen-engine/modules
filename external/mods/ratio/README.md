# Ratio Team Mode (Ikemen GO module)

Ratio Team Mode restores the classic Ratio team mode, known from Capcom vs. SNK 2, as an external Lua module.

In Ratio mode, each team spends a fixed strength budget across 1 to 3 characters. Every selected character receives a Ratio level, which affects their attack and life multipliers. By default ratio 2 is the neutral baseline.

This module replaces the old built-in Ratio implementation that was previously part of the base engine.

## How it works

Each team has 4 total Ratio levels to distribute.

Possible team layouts are:

```txt
3 characters: 2-1-1, 1-2-1, 1-1-2
2 characters: 2-2, 3-1, 1-3
1 character:  4
```

On the team selection screen, when Ratio is highlighted, press Left or Right to cycle through the available Ratio layouts for that team size.

Default gameplay values are:

```txt
Ratio 1: Life -20%, Attack -18%
Ratio 2: Life  +0%, Attack  +0%
Ratio 3: Life +17%, Attack +17%
Ratio 4: Life +40%, Attack +30%
```

## Installation

Copy the entire `ratio` directory into:

```txt
Ikemen_GO/external/mods/
```

Ikemen GO will load the module automatically on startup.

No title menu item or `[Select Info] teammenu.itemname.ratio` entry has to be added manually. The module appends the Ratio team mode entry and Ratio options menu entries at runtime, without overwriting entries already defined by the screenpack.

## Configuration

The main configuration file is:

```txt
external/mods/ratio/config.ini
```

Gameplay defaults are stored in the `[Options]` section:

```ini
[Options]
Ratio.Level1.Attack  = 0.82
Ratio.Level1.Life    = 0.80
Ratio.Level2.Attack  = 1
Ratio.Level2.Life    = 1
Ratio.Level3.Attack  = 1.17
Ratio.Level3.Life    = 1.17
Ratio.Level4.Attack  = 1.3
Ratio.Level4.Life    = 1.4
Ratio.Recovery.Base  = 0
Ratio.Recovery.Bonus = 20
```

These values control Ratio attack, life, and between-match life recovery. Attack and life values are multipliers, so `1.17` means `+17%` and `0.82` means `-18%`.

Arcade AI ramping for Ratio mode is configured here:

```ini
[Arcade]
ratio.AIramp.start = 1, 0
ratio.AIramp.end   = 3, 2
```

The `[Common]` section lists files that should be loaded only for Ratio matches:

```ini
[Common]
Fx     = external/mods/ratio/ikemen1/fx.def
States = external/mods/ratio/ratio.zss
```

These files are injected automatically when Ratio mode is active. You do not need to add them manually to `save/config.ini`.

## Screenpack assets

The module uses the `[Files]` section in `external/mods/ratio/config.ini`:

```ini
[Files]
defaults = external/mods/ratio/system.def
system   = external/mods/ratio/ikemen1/system.def
air      = external/mods/ratio/ikemen1/system.air
spr      = external/mods/ratio/ikemen1/system.sff
```

`external/mods/ratio/system.def` contains generic defaults required by the module.

`external/mods/ratio/ikemen1/system.def` overrides those defaults for the included ikemen1 motif premade assets.

If your screenpack already has Ratio assets from older Ikemen GO versions, you can point the module to your screenpack files instead:

```ini
[Files]
defaults = external/mods/ratio/system.def
system   = data/system.def
air      = data/system.air
spr      = data/system.sff
```

Use the actual paths used by your motif.

Motifs may also ship their own standalone Ratio assets. In that case, update the `[Files]` paths in `external/mods/ratio/config.ini` to point to the motif-provided `def`, `air`, and `sff` files. The included `ikemen1` subfolder is an example of this layout.

## Overriding screenpack defaults

You can keep the bundled defaults, or provide your own screenpack-specific `system.def` and point `[Files] system` to it.

The module loads files in this order:

1. `defaults`
2. `system`

Values from `system` override values from `defaults`.

The module appends Ratio-related itemnames at runtime without overwriting existing screenpack entries.

## Options menu

The module adds Ratio settings to the game options menu.

When Ratio values are changed in-game and the Options menu is saved, the module writes the updated values back to:

```txt
external/mods/ratio/config.ini
```

## `select.def` support

Ratio mode supports `*.ratiomatches` entries in the `[Options]` section of `select.def`.

Unlike regular arcade mode, Ratio arcade mode can use uneven opponent team sizes between fights. It uses `*.ratiomatches` instead of `*.maxmatches`.

Example:

```ini
[Options]
arcade.ratiomatches = 1-3:1, 3:1, 2:1, 2:1, 1:2, 3:1, 1-2:3
```

Format:

```txt
chars_min-chars_max:order
```

`chars_max` is optional.

The value before `:` controls how many opponent characters may appear in that match. Valid character counts are `1` to `3`. A range chooses a random team size within that range.

The value after `:` is the character `order` value used to choose eligible opponents from `select.def`.

Examples:

```txt
1-3:1  ; 1 to 3 opponents with order = 1
3:1    ; exactly 3 opponents with order = 1
2:4    ; exactly 2 opponents with order = 4
```

Characters can also request custom Ratio arcade match settings from the `[Characters]` section:

```ini
[Characters]
chars/kfm/kfm.def, ratiomatches = boss
```

Then define the matching settings in the `[Options]` section:

```ini
[Options]
boss.arcade.ratiomatches = 3:1, 2-3:2, 1:3
```

If a character does not request custom Ratio match settings, `arcade.ratiomatches` is used.

## Character-specific Ratio arcade path

Characters may define a Ratio-specific Lua arcade path with `ratiopath`.

When defined in the character DEF file `[Arcade]` section, the path is relative to the character folder:

```ini
[Arcade]
arcadepath = arcade.lua
ratiopath = ratio.lua
```

When defined as a `select.def` character parameter, the path is relative to the game folder:

```ini
[Characters]
chars/kfm/kfm.def, ratiopath = chars/kfm/ratio.lua
```

When Ratio mode is selected for the opponent team, `ratiopath` is used instead of the regular `arcadepath`.

For other opponent team modes, `arcadepath` is used instead. If `ratiopath` is not assigned, Ratio arcade mode falls back to the matching `*.ratiomatches` settings.

## Compatibility notes

The old built-in `ratioLevel` trigger was removed from the engine.

This module exposes Ratio data through maps instead:

```txt
map(ratiolevel)
map(liferatio)
map(attackratio)
```

`map(ratiolevel)` returns the character's Ratio level from `1` to `4` when Ratio data is assigned, otherwise `0`.

The bundled `ratio.zss` uses these maps to apply Ratio behavior during matches.

Older content that depends on the removed `ratioLevel` trigger should be updated to use `map(ratiolevel)` instead.

Ratio mode runs on top of Turns-style team handling internally. For compatibility with older content, `TeamMode` checks should still be treated like Turns; use `map(ratiolevel)` when content specifically needs to detect Ratio data.

## Disabling the module

Remove or rename:

```txt
external/mods/ratio
```

Ratio team mode, Ratio options, and Ratio match-time common files will no longer be loaded.
