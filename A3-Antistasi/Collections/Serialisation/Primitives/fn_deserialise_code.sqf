/*
Function:
    Col_fnc_deserialiseCode

Description:
    Converts string into compiled Code.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Deserialisation process is resource heavy.

Parameters:
    <LOCATION> Serialisation builder.
    <STRING> Serialisation of Code.

Returns:
    <CODE> Compiled code or function;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialise_builder",locationNull,[locationNull]],
    ["_serialisation","",[ "" ]]
];
compile _serialisation;
