/*
 * File: fn_loadFaction.sqf
 * Author: Spoffy
 * Description:
 *    Loads a faction definition file
 * Params:
 *    _file - Faction definition file path
 * Returns:
 *    Namespace containing faction information
 * Example Usage:
 */

params ["_file"];

//Create a global namespace to store faction data in.
private _dataStore = true call A3A_fnc_createNamespace;

private _fnc_saveToTemplate = {
	params ["_name", "_data"];

	_dataStore setVariable [_name, _data, true];
};

private _fnc_getFromTemplate = {
	params ["_name"];

	_dataStore getVariable _name;
};

call preprocessFileLineNumbers _file;

_dataStore