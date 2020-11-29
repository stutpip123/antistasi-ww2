/*
Function:
    Col_fnc_remKeyPairs

Description:
    Recommend when loading data from a save, settings array, deserialisation ect.
    Recommend to have saving and loading be in the same order to optimise speed.
    Searches for specified keys in a KeyPair map. NB: IT IS PASSED AS A REFERENCE, ELEMENTS WILL BE DELETED!
    If found, the element is deleted and the value returned. Otherwise default is returned. Performs strict value comparison.
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
    ] call Col_fnc_remKeyPairs params ["two","name","whyTho"];  // [true,"missing",west]
    _map;  // [["Whoops",0]]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_map","",[ [] ]],
    ["_keyPairs", [],[ [] ]],
    ["_sortBothFirst",false,[false]]
];
private _filename = "fn_remKeyPairs";

if (_sortBothFirst) then {
    _map sort true;
    _keyPairs sort true;
};

private _values = [];
for "_i" from 0 to (count _keyPairs -1) do {
    _values pushback [(_map deleteAt (_map findIf {_x#0 isEqualTo _keyPairs#_i#0}))#1] param [0, _keyPairs#_i#1];   // Integrated version of whats in fnc_remKeyPair to save performance.
};
_values;
