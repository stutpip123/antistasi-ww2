/*
Function:
    Col_fnc_deserialise_array

Description:
    Recursively serialises an array serialisation with the provided deserialisation builder.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <LOCATION> Deserialisation builder.
    <ARRAY> Input array serialisation.

Returns:
    <ARRAY> Output array;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_deserialisation_builder",locationNull,[locationNull]],
    ["_serialisation",[],[ [] ]]
];
private _array = [];
_serialisation apply {
    if (_x isEqualType _array) then {
        [_deserialisation_builder,_x#1] call (_deserialisation_builder getVariable [_x#0, {nil} ])
    } else {
        _x
    };
};
