# Time Challenge (Ikemen GO module)

**Time Challenge** is a mode where the player fights a selected opponent and tries to beat their previous best time.

## Installation

### 1) Install the module
Copy the entire `timechallenge` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add this entry to your main `data/system.def` under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus). Without this, the mode won't show up in-game.

```ini
[Title Info]
menu.itemname.timechallenge = "TIME CHALLENGE"
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p mugen1 motif**.

* You can leave these defaults in the module.
* To override them, copy the relevant sections into your main screenpack `system.def`.

This also allows distributing a screenpack with the full mode support **without bundling the module** (copy the needed sections into your screenpack's `system.def`).
