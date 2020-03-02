/*
 * File: fn_loadout_addHelmet.sqf
 * Author: Spoffy
 * Description:
 *    Adds a helmet to a unit loadout
 * Params:
 *    _loadout - Loadout to add vest to
 *    _helmet - Helmet class to add
 * Returns:
 *    Modified loadout array
 * Example Usage:
 *    [_loadout, "H_HelmetSpecB_blk"] call A3A_fnc_addVest
 */

params ["_loadout", "_helmet"];

_loadout set [ 6,
	_helmet
];

_loadout