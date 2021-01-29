/*
Function:
    Col_fnc_map_rem

Description:
    If found, the map element is deleted and the keyPair is returned. Performs strict value comparison.

Parameters:
    <ARRAY<ANY,ANY>> Map with any type of key and values.
    <ANY> Key. Limitation: cannot be used to find nil keys in map.

Returns:
    <ARRAY<KEY,VALUE>> Whole keyPair that was removed || <nil> if not found.

Examples:
    private _objectReference = player;
    private _map = [["name","jim"],[2,true],[_objectReference,west]];
    [_map,player] call Col_fnc_map_rem;  // [player,west]
    _map;  // [["name","jim"],[2,true]]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_map","",[ [] ]],
    ["_key",nil]
];

_map deleteAt (_map findIf {_x#0 isEqualTo _key});


/*
private _mapMaster = [];
_mapMaster resize 1000000;
for "_i" from 0 to 999999 do {
    _mapMaster set [_i, [str _i,["value",str _i] joinString ""]];
};
private _key = "0";  // Result: 1.75781ms
//private _key = "499999";  // Result: 568.555ms
//private _key = "999999";  // Result: 1102.15ms
//private _key = "notExist";  // Result: 1123.14ms
private _default = "none";

private _totalTime = 0;
private _startTime = 0;
private _loops = 10;
for "_i" from 1 to _loops do {
    private _map = +_mapMaster;
    _startTime = diag_tickTime;
    [(_map # (_map findIf {_x#0 isEqualTo _key}))#1] param [0, _default];
    _totalTime = _totalTime + diag_tickTime - _startTime;
};
[str (1000*(_totalTime/_loops)),"ms"] joinString "";
*/
