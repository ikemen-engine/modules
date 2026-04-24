# Ratio Team Mode (Ikemen GO module)

Ratio Team Mode restores the classic Ratio team mode, known from Capcom vs. SNK 2, as an external Lua module.

In Ratio mode, each team spends a fixed strength budget across 1 to 3 characters. Every selected character receives a Ratio level, which affects their attack and life multipliers.

This module replaces the old built-in Ratio implementation that was previously part of the base engine.

## Installation

Copy the entire `ratio` directory into:

```txt
Ikemen_GO/external/mods/
````

Ikemen GO will load the module automatically on startup.

No title menu item has to be added manually. The module appends the Ratio team mode entry and Ratio options menu entries at runtime, without overwriting entries already defined by the screenpack.

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

These values control Ratio attack, life, and between-match life recovery.

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

This is useful for motifs that already define Ratio icons, sprites, or animations and do not need the standalone assets bundled with this module.

Going forward, motif-specific Ratio assets should preferably be distributed with the motif itself. The included `ikemen1` subfolder in this module is an example of how a motif can provide its own Ratio definitions and FX data. Such motifs should instruct users to update the `[Files]` paths in `external/mods/ratio/config.ini` so they point to the dedicated, standalone files inside the motif directory.

## Overriding screenpack defaults

You can keep the bundled defaults, or provide your own screenpack-specific `system.def` and point `[Files] system` to it.

The module loads files in this order:

1. `defaults`
2. `system`

Values from `system` override values from `defaults`.

Existing screenpack menu entries are not overwritten when the module appends Ratio-related itemnames.

## Options menu

The module adds Ratio settings to the game options menu.

When Ratio values are changed in-game and the Options menu is saved, the module writes the updated values back to:

```txt
external/mods/ratio/config.ini
```

## `select.def` support

Ratio mode supports `*.ratiomatches` entries in the `[Options]` section of `select.def`.

Example:

```ini
[Options]
arcade.ratiomatches = 1-3:1, 3:1, 2:1, 2:1, 1:2, 3:1, 1-2:3
```

Format:

```txt
ratio_min-ratio_max:order
```

`ratio_max` is optional.

Examples:

```txt
1-3:1
3:1
4:2
```

Characters can also request custom Ratio arcade match settings:

```ini
[Characters]
chars/kfm/kfm.def, ratiomatches = boss
```

Then define the matching settings in `[Options]`:

```ini
[Options]
boss.arcade.ratiomatches = 4:1, 3-4:2, 4:3
```

## Character-specific Ratio arcade path

Characters may define a Ratio-specific Lua path:

```ini
[Characters]
chars/kfm/kfm.def, ratiopath = chars/kfm/ratio.lua
```

When Ratio mode is selected for the opponent team, `ratiopath` is used instead of the regular `arcadepath`.

## Compatibility notes

The old built-in `ratioLevel` trigger was removed from the engine.

This module exposes Ratio data through maps instead:

```txt
map(ratiolevel)
map(liferatio)
map(attackratio)
```

The bundled `ratio.zss` uses these maps to apply Ratio behavior during matches.

Older content that depends on the removed `ratioLevel` trigger should be updated to use `map(ratiolevel)` instead.

## Disabling the module

Remove or rename:

```txt
external/mods/ratio
```

Ratio team mode, Ratio options, and Ratio match-time common files will no longer be loaded.
