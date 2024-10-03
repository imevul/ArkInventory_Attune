# ArkInventory

Customized version of ArkInventory that adds support for showing Synastria attunment information.
Also adds additional rules.

## Installation

1. Download the [latest release](https://github.com/imevul/ArkInventory_Attune/releases)
2. Extract to Interface/AddOns and enable the addon in-game

## ArkInventoryRules_Misc

Misc useful rule functions for ArkInventory:
- `vanilla()`
- `tbc()`
- `wotlk()`
- `empty()`

## ArkInventoryRules_Attunables

Adds useful rule functions for ArkInventory for handling attunable items:
- `isValid()`: Is the item attunable by the current character
- `attunable()`: `isValid()` + Current variant not yet attuned
- `attunablebyme()`: Same as `attunable()`
- `attunableatall()`: Is the item attunable by anyone (no matter class or level)
- `attuned()`: Is the current variant of the item attuned by me
- `partiallyattuned()`: Is any variant of the item attuned
- `fullyattuned()`: Is every variant of the item attuned
- `attuneprogress()`: Does the current variant of the item have attunement progress
