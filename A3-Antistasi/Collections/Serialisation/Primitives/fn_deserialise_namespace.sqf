/*
Function:
    Col_fnc_deserialiseNamespace

Description:
    Converts enum string into Namespace.
    There is no error checking if enum is out of range.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Deserialisation process is resource heavy.

Parameters:
    <LOCATION> Serialisation builder.
    <SCALAR> Serialisation of Namespace enum.

Returns:
    <NAMESPACE> Namespace.

Examples:
    [locationNull,0] call Col_fnc_deserialise_namespace;  // missionNamespace (Note, the console uses str, so it will only print Namespace)

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialise_builder",locationNull,[locationNull]],
    ["_serialisation",0,[ 0 ]]
];
private _filename = "fn_deserialiseSide";
[
    missionNamespace,
    parsingNamespace,
    uiNamespace,
    profileNamespace,
    localNamespace
] # _serialisation;
