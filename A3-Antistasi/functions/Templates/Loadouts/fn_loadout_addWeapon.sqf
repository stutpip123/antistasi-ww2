/*
 * File: fn_loadout_addWeapon.sqf
 * Author: Spoffy
 * Description:
 *    Adds a weapon to a unit loadout
 * Params:
 *    _loadout - Loadout to add backpack to
 *    _slot - "PRIMARY", "LAUNCHER" or "HANDGUN"
 *    _weapon - Weapon to add. Either a class "arifle_MXC_F" or an array ["arifle_MXC_F", "muzzle", "pointer", "optic", "bipod"]
 *    _magazineType - (Optional) - Type of magazine to load into the gun. Autodetected if not provided.
 * Returns:
 *    Modified loadout array
 * Example Usage:
 *    [_loadout, "PRIMARY", "arifle_MXC_F"] call A3A_fnc_addWeapon
 *    [_loadout, "PRIMARY", ["arifle_MXC_F", "", "", ""], "30Rnd_65x39_caseless_mag"] call A3A_fnc_addWeapon
 */

params ["_loadout", "_slot", "_weapon", ["_magazineType", ""]];

private _weaponArray = [];

if (_weapon isEqualType []) then {
	_weapon params ["_weaponClass", ["_muzzle", ""], ["_pointer", ""], ["_optic", ""], ["_bipod", ""]];
	_weaponArray = [_weaponClass, _muzzle, _pointer, _optic, [], [], _bipod];
} else {
	_weaponArray = [_weapon, "", "", "", [], [], ""];
};

//Find out which magazine we should add to the gun.
private _mag = [];

if (_magazineType isEqualTo "") then {
	_magazines = getArray (configFile >> "CfgWeapons" >> (_weaponArray select 0) >> "Magazines");
	if (count _magazines > 0) then {
		_magazineType = _magazines select 0;
	};
};

if !(_magazineType isEqualTo "") then {
	_mag = [_magazineType, getNumber (configFile >> "CfgMagazines" >> _magazineType >> "count")];
};

_weaponArray set [ 4, _mag ];

if (_slot == "PRIMARY") then {
	_loadout set [ 0, _weaponArray ];
};

if (_slot == "LAUNCHER") then {
	_loadout set [ 1, _weaponArray ];
};

if (_slot == "HANDGUN") then {
	_loadout set [ 2, _weaponArray ];
};

_loadout