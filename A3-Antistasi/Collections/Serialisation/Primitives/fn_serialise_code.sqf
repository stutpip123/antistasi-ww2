/*
Function:
    Col_fnc_serialiseCode

Description:
    Converts Code into string.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <LOCATION> Serialisation builder.
    <CODE> Compiled code or function.

Returns:
    <STRING> Serialisation of Code;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialise_builder",locationNull,[locationNull]],
    ["_code",{false},[{false}]]
];
private _serialisation = str _code;
[
    "CODE",
    _serialisation select [1,count _serialisation -2 ]  // Trims outer curly braces
];
