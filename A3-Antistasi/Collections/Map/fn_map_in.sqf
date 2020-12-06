/*
Function:
    Col_fnc_map_in

Description:
    Searches for specified key in a KeyPair map.
    If found, the reference array's index 0 is set to value. Otherwise no modification. Performs strict value comparison.

Parameters:
    <ARRAY<ANY,ANY>> Map with any type of key and values.
    <ANY> Key. Limitation: cannot be used to find nil keys in map.
    <ARRAY> Array reference.

Returns:
    <BOOLEAN> true if found, false if not found.

Examples:
    private _ref = ["00000000000000000"];
    if ([_namesAndUids,"dave",_ref] call Col_fnc_map_in) then {hint "We found Dave."};
    _ref#0; // Dave's UID or default.
Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_map","",[ [] ]],
    ["_key",nil],
    ["_reference",[false],[ [] ],[1]]
];
private _i = _map findIf {_x#0 isEqualTo _key};
if (_i isEqualTo -1) then {
    false;
} else {
    _reference set [0, _map#_i#1];
    true
};