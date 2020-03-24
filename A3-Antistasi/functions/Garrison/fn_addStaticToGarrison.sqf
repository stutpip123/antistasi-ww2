params ["_staticWeapon", "_marker"];

/*  Adds a static weapon to the given marker
*/

//Cannot add statics to markers which not belong to the rebels
if (sidesX getVariable [_marker, sideUnknown] != teamPlayer) exitWith {};

//Save static as static
private _statics = garrison getVariable [format ["%1_statics", _marker], []];
_statics pushBack [[getPosATL _staticWeapon, getDir _staticWeapon, typeOf _staticWeapon], -1];
garrison setVariable [format ["%1_statics", _marker], _statics, true];

//Save static as vehicle
private _vehicles = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
_vehicles pushBack [_staticWeapon, [12, -1]];
spawner setVariable [format ["%1_vehicles", _marker], _vehicles, true];

[_staticWeapon, _marker, teamPlayer] call A3A_fnc_staticInit;

_staticWeapon setVariable ["StaticMarker", _marker];

[_marker, _staticWeapon] call A3A_fnc_manStaticOnAssembly;
