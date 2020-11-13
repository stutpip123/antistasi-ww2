/*
Function:
    A3A_fnc_remKeyPair

Description:
    Recommend when loading data from a save, settings array, deserialisation ect.
    Recommend to have saving and loading be in the same order to optimise speed.
    Searches for specified key in a KeyPair map. NB: IT IS PASSED AS A REFERENCE, ELEMENTS WILL BE DELETED!
    If found, the element is deleted and the value returned. Otherwise default is returned. Performs strict value comparison.
    Tn = 0.0011*n + 1.7566 (Tn is milliseconds; n is elements irritated; First element is quick, last is slow).

Parameters:
    <ARRAY<ANY,ANY>> Map with any type of key and values.
    <ANY> Key. Limitation: cannot be used to find nils in map.
    <ANY> Default.

Returns:
    <ANY> Value or default.

Examples:
    private _objectReference = player;
    private _map = [["name","jim"],[2,true],[_objectReference,west]];
    [player,sideUnknown] call A3A_fnc_remKeyPair;  // west
    _map;  // [["name","jim"],[2,true]]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_map","",[ [] ]],
    ["_key",nil],
    ["_default",nil]
];
private _filename = "fn_remKeyPair";

[(_map deleteAt (_map findIf {_x#0 isEqualTo _key}))#1] param [0, _default];


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
