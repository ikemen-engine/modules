# VS 100 Kumite (Ikemen GO module)

VS 100 Kumite is a mode where the player tries to defeat as many opponents as possible across 100 consecutive matches.

## Installation

### 1) Install the module
Copy the entire `vs100kumite` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add this entry to your main `data/system.def` under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus). Without this, the mode won't show up in-game.

```ini
[Title Info]
menu.itemname.vs100kumite = "VS 100 KUMITE"
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p mugen1 motif**.

* You can leave these defaults in the module.
* To override them, copy the relevant sections into your main screenpack `system.def`.

This also allows distributing a screenpack with the full mode support **without bundling the module** (copy the needed sections into your screenpack's `system.def`).
