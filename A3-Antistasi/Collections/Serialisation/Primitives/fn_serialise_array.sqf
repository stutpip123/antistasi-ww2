/*
Function:
    Col_fnc_serialise_array

Description:
    Recursively serialises an array with the provided serialisation builder.
    This does NOT support self referencing arrays!

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <LOCATION> Serialisation builder.
    <ARRAY> Input array.

Returns:
    <ARRAY> Serialisation of Array;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialisation_builder",locationNull,[locationNull]],
    ["_array",[],[ [] ]]
];
[
    "ARRAY",
    _array apply {[_serialisation_builder,_x] call (_serialisation_builder getVariable [typeName _x, {["NIL",0]} ])}
];
