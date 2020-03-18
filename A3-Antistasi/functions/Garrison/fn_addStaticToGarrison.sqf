params ["_staticWeapon", "_marker"];

//Cannot add statics to markers which not belong to the rebels
if (sidesX getVariable [_marker, sideUnknown] != teamPlayer) exitWith {};

private _statics = garrison getVariable [format ["%1_statics", _marker], []];
_statics pushBack [[getPosATL _staticWeapon, getDir _staticWeapon, typeOf _staticWeapon], -1];
garrison setVariable [format ["%1_statics", _marker], _statics, true];

[_marker, [_staticWeapon, [12, -1]], grpNull] call A3A_fnc_addToSpawnedArrays;
[_staticWeapon, _marker, teamPlayer] call A3A_fnc_staticInit;

_staticWeapon setVariable ["StaticMarker", _marker];

//TODO man static with militia here
