# Random Test (Ikemen GO module)

*Random Test** is a mode where the game runs endless AI vs AI matches, with a random character roster and a random stage selected each time.

## Installation

### 1) Install the module
Copy the entire `randomtest` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add this entry to your main `data/system.def` under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus). Without this, the mode won't show up in-game.

```ini
[Title Info]
;menu.itemname.randomtest = "RANDOM TEST"
````
