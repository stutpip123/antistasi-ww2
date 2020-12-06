/*
Function:
    Col_fnc_map_rems

Description:
    Deletes elements from map.

Parameters:
    <ARRAY<ANY,ANY>> Map with any type of key and values.
    <ARRAY<ANY>> Keys. Limitation: cannot be used to find nil keys in map.
    <BOOLEAN> Use experimental map traversing and array_remIndices for possible O(n) performance. And all keys to exist for it to reach O(n). [DEFAULT=false]
    <BOOLEAN> Make true if map and keypairs are in same order. Performance boost if not all keys exist. It will rescan the skipped portions of the map looking for the key. [DEFAULT=false]

Returns:
    <ARRAY> Same map reference;

Examples:
    private _map = [["name","jim"],[2,true],["Whoops",0],[player,west]];
    [_map, [2,"name",player] ] call Col_fnc_map_rems params;
    _map;  // [["Whoops",0]]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_map","",[ [] ]],
    ["_keys", [],[ [] ]],
    ["_experimentalTraversal",false,[false]],
    ["_sorted",false,[false]]
];

if (_experimentalTraversal) exitWith {
    private _indices = [];
    private _keyI = 0;
    private _mapSkipI = -1;  // The last successful key  found.
    private _countKeys = count _keys;

    private _findIfI = -1;  // Used if unsorted.

    while {!(_keyI isEqualTo _countKeys)} do {
        for "_mapI" from _mapSkipI to count _map -1 do {
            if (_map#_mapI#0 isEqualTo _keys#_keyI) then {
                _indices pushBack _mapI;
                _mapSkipI = _mapI + 1;
                _keyI = _keyI +1;
            };
        };
        if (_keyI isEqualTo _countKeys) exitWith {};    // If all keys have been processed we done.

        if (!_sorted) then {
            _findIfI = _map findIf {_x#0 isEqualTo _keys#_keyI}
            if (!_findIfI isEqualTo -1) then {
                _mapSkipI = _findIfI;  // We will be reducing _mapSkipI, in case other elements may have also been skipped due to the previous key being too early.
                _indices pushBack _findIfI;
            };
        };
        _keyI = _keyI +1;   // Will now Try find next key from last index found.
    };

    if (_sorted) then {
        reverse _indices;
    } else {
        _indices sort false;
    }; // Needs to be descending order for remIndices to work without butchering the map.
    [_map,_indices,true] call Col_fnc_array_remIndices;
    _map;
};

for "_i" from 0 to (count _keys -1) do {
    _map deleteAt (_map findIf {_x#0 isEqualTo _keys#_i});   // Integrated version of whats in fnc_remKeyPair to save performance.
};
_map;
