/*
 * File: fn_loadout_createMedicLoadouts.sqf
 * Author: Spoffy
 * Description:
 *    Creates an array of medic loadouts.
 * Params:
 *    _quantity - Number of loadouts to create
 * Environment params:
 *    _uniforms - Array of uniform class names to use
 *    _vests - Array of vest class names to use
 *    _backpacks - Array of backpacks class names to use
 *    _helmets - Array of helmet class names to use
 *    _antiInfantryGrenades - Array of antiInfantryGrenade class names to use
 *    _antiTankGrenades - Array of antiTankGrenade class names to use
 *    _smokeGrenades - Array of smokeGrenade class names to use
 *    _atMines - Array of atMine class names to use
 *    _apMines - Array of apMine class names to use
 *    _lightExplosives - Array of lightExplosive class names to use
 *    _heavyExplosives - Array of heavyExplosive class names to use
 *    _primaryWeapons - Array of primaryWeapon class names to use
 *    _secondaryWeapons - Array of secondaryWeapon class names to use
 *    _handgunWeapons - Array of handgunWeapon class names to use
 * Returns:
 *    Array of loadout arrays
 * Example Usage:
 *    3 call A3A_fnc_loadout_createMedicLoadouts
 */

params ["_quantity"];

private _loadouts = [];

for "_i" from 1 to _quantity do {
	private _loadout = [selectRandom _uniforms] call A3A_fnc_loadout_createBase;

	if !(_helmets isEqualTo []) then {
		[_loadout, selectRandom _helmets] call A3A_fnc_loadout_addHelmet;
	};

	if !(_vests isEqualTo []) then {
		[_loadout, selectRandom _vests] call A3A_fnc_loadout_addVest;
	};

	if !(_backpacks isEqualTo []) then {
		[_loadout, selectRandom _backpacks] call A3A_fnc_loadout_addBackpack;
	};

	private _ammoItems = [];

	if !(_primaryWeapons isEqualTo []) then {
		private _weapon = selectRandom _primaryWeapons;
		[_loadout, "PRIMARY", _weapon] call A3A_fnc_loadout_addWeapon;
		private _magInfo = [_weapon] call A3A_fnc_loadout_defaultWeaponMag;
		if !(_magInfo isEqualTo []) then {
			_ammoItems pushBack [_magInfo select 0, 10, _magInfo select 1];
		};
	};

	if !(_handgunWeapons isEqualTo []) then {
		private _weapon = selectRandom _handgunWeapons;
		[_loadout, "HANDGUN", _weapon] call A3A_fnc_loadout_addWeapon;
		private _magInfo = [_weapon] call A3A_fnc_loadout_defaultWeaponMag;
		if !(_magInfo isEqualTo []) then {
			_ammoItems pushBack [_magInfo select 0, 2, _magInfo select 1];
		};
	};

	private _medicalSupplies = "MEDIC" call A3A_fnc_loadout_itemList_medicalSupplies;

	private _miscEssentials = call A3A_fnc_loadout_itemList_miscEssentials;
	private _grenades = [];
	
	if (count _antiInfantryGrenades > 0) then {
		_grenades pushBack [selectRandom _antiInfantryGrenades, 1, 1];
	}; 

	if (count _smokeGrenades > 0) then {
		_grenades pushBack [selectRandom _smokeGrenades, 2, 1];
	};

	[_loadout, [
		_ammoItems,
		_medicalSupplies,
		_miscEssentials,
		_grenades
	]] call A3A_fnc_loadout_addItems;

	[_loadout, ["MAP", "WATCH", "COMPASS", "RADIO"]] call A3A_fnc_loadout_addEquipment;

	_loadouts pushBack _loadout;
};

_loadouts