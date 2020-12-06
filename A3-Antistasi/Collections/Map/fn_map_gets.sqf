/*
Function:
    Col_fnc_map_gets

Description:
    Recommend when loading data from a save, settings array, deserialisation ect.
    Recommend to have saving and loading be in the same order to optimise speed.
    Searches for specified keys in a KeyPair map. Map is not modified
    If found, the element's the value returned in order. Otherwise default is returned. Performs strict value comparison.
    Heavily sorting the map or passing a sorted copy for extra performance.

Parameters:
    <ARRAY<ANY,ANY>> Map with any type of key and values.
    <ARRAY
        <ANY> Key. Limitation: cannot be used to find nil keys in map.
        <ANY> Default.
    >
    <BOOLEAN> Use experimental map traversing and array_remIndices for possible O(n) performance. And all keys to exist for it to reach O(n). Extra Speed boost if _sortBothFirst is false because map and keys already sorted. [DEFAULT=false]
    <BOOLEAN> Make true if map and keypairs are in same order. Performance boost if not all keys exist. It will rescan the skipped portions of the map looking for the key. [DEFAULT=_sortBothFirst]

Returns:
    <ANY> Value or default.

Examples:
    private _map = [["name","jim"],[2,true],["Whoops",0],[player,west]];
    [
        _map,
        [
            [2,0],
            ["name","missing"],
            [player,sideUnknown]
        ]
    ] call Col_fnc_map_gets params ["two","name","whyTho"];  // [true,"missing",west]
    _map;  // [["name","jim"],[2,true],["Whoops",0],[player,west]]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_map","",[ [] ]],
    ["_keyPairs", [],[ [] ]],
    ["_experimentalTraversal",false,[false]],
    ["_sorted",false,[false]]
];

if (_experimentalTraversal) exitWith {
    private _values = [];
    private _keyI = 0;
    private _mapSkipI = -1;  // The last successful key  found.
    private _countKeys = count _keyPairs;
    private _countMap = count _map;

    private _findIfI = -1;  // Used if unsorted.

    while {!(_keyI isEqualTo _countKeys)} do {
        for "_mapI" from _mapSkipI to _countMap -1 do {
            if (_map#_mapI#0 isEqualTo _keyPairs#_keyI#0) then {
                _mapSkipI = _mapI + 1;
                _values pushBack _map#_mapI#1;
                _keyI = _keyI +1;
            };
        };
        if (_keyI isEqualTo _countKeys) exitWith {};    // If all keys have been processed we done.

        if (_sorted) then {
            _values pushBack _keyPairs#_keyI#1;  // If the key was not found in the map. Add it's default
        } else {
            _findIfI = _map findIf {_x#0 isEqualTo _keyPairs#_keyI#0}
            if (_findIfI isEqualTo -1) then {
                _values pushBack _keyPairs#_keyI#1; // Will contain default.
            } else {
                _mapSkipI = _findIfI;  // We will be reducing _mapSkipI, in case other elements may have also been skipped due to the previous key being too early.
                _values pushBack _map#_findIfI#1;
            };
        };
        _keyI = _keyI +1;   // Will now Try find next key from last index found.
    };
    _values;
};

private _mapCopy = +_map;
private _values = [];
for "_i" from 0 to (count _keyPairs -1) do {
    _values pushback [(_mapCopy deleteAt (_mapCopy findIf {_x#0 isEqualTo _keyPairs#_i#0}))#1] param [0, _keyPairs#_i#1];   // Integrated version of whats in fnc_remKeyPair to save performance.
};
_values;
