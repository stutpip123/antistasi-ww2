/*
Function:
    Col_fnc_serialise

Description:
    Serialises a variable with the provided deserialisation builder.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <LOCATION> Serialisation builder.
    <ANY> Input.

Returns:
    <ANY> Serialisation of var;

Examples:
    sb = ["123"] call Col_fnc_serialisation_builder;
    dsb = ["123"] call Col_fnc_deserialisation_builder;

    _a = ["hello", ["key",1], fireX, [player,resistance], 4, {hint "call me!";}];
    _as = [sb,_a] call Col_fnc_serialise;
    _a2 = [dsb,_as] call Col_fnc_deserialise;
    _a2; // ["hello",["key",1],any,[any,GUER],4,{hint "call me!";}]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialisation_builder",locationNull,[locationNull]],
    "_var"
];
[_serialisation_builder,_var] call (_serialisation_builder getVariable [typeName _var, {["NIL",0]} ]);
