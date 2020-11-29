/*
Function:
    Col_fnc_map_gets

Description:
    Recommend when loading data from a save, settings array, deserialisation ect.
    Recommend to have saving and loading be in the same order to optimise speed.
    Searches for specified keys in a KeyPair map. Map is not modified
    If found, the element's the value returned in order. Otherwise default is returned. Performs strict value comparison.
    Option to sort first.

Parameters:
    <ARRAY<ANY,ANY>> Map with any type of key and values.
    <ARRAY
        <ANY> Key. Limitation: cannot be used to find nil keys in map.
        <ANY> Default.
    >

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
    ["_mapIn","",[ [] ]],
    ["_keyPairsIn", [],[ [] ]],
    ["_sortBothFirst",false,[false]]
];
private _filename = "fn_getKeyPairs";

private _map = +_mapIn;
private _keyPairs = +_keyPairsIn;
if (_sortBothFirst) then {
    _map sort true;
    _keyPairs sort true;
};

private _values = [];
for "_i" from 0 to (count _keyPairs -1) do {
    _values pushback [(_map deleteAt (_map findIf {_x#0 isEqualTo _keyPairs#_i#0}))#1] param [0, _keyPairs#_i#1];   // Integrated version of whats in fnc_remKeyPair to save performance.
};
_values;
