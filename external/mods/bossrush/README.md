# Boss Rush (Ikemen GO module)

**Boss Rush** is a special challenge where player fight multiple bosses consecutively. Beating all bosses clears the mode.

## Installation

### 1) Install the module
Copy the entire `bossrush` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add this entry to your main `data/system.def` under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus). Without this, the mode won't show up in-game.

```ini
[Title Info]
menu.itemname.bossrush = "BOSS RUSH"
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p mugen1 motif**.

* You can leave these defaults in the module.
* To override them, copy the relevant sections into your main screenpack `system.def`.

This also allows distributing a screenpack with the full mode support **without bundling the module** (copy the needed sections into your screenpack's `system.def`).

## `select.def` customization

### Include characters as Boss Rush bosses

In `select.def`, under [Characters], set `boss = 1` parameter for any character you want included in Boss Rush.

At least one character must have `boss = 1` or Boss Rush won't appear in the mode selection.

### Limit the number of matches (optional)

Optionally set a maximum number of matches before Boss Rush ends:

```ini
[Options]
;IKEMEN feature: Maximum number of normal and ratio matches to fight before
;game ends in Boss Rush mode. Can be left empty, if player is meant to fight
;against all boss characters (in such case order parameter is still respected)

bossrush.maxmatches =
```

Leave it empty to fight **all** boss characters (the `order` parameter is still respected).
