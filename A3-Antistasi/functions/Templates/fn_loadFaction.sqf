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

//Keep track of loadout namespaces so we can delete them when we're done.
private _loadoutNamespaces = [];
private _fnc_createLoadoutData = {
	private _namespace = false call A3A_fnc_createNamespace;
	_loadoutNamespaces pushBack _namespace;
	_namespace
};

private _fnc_copyLoadoutData = {
	params ["_sourceNamespace"];
	private _newNamespace = call _fnc_createLoadoutData;
	{
		_newNamespace setVariable [_x, _sourceNamespace getVariable _x];
	} forEach allVariables _sourceNamespace;
	_newNamespace
};

call compile preprocessFileLineNumbers _file;

//Clear up used loadout namespaces.
{
	[_x] call A3A_fnc_deleteNamespace;
} forEach _loadoutNamespaces;

_dataStore