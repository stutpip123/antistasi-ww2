/*
Function:
    Col_fnc_serialiseSide

Description:
    Converts Side into enum string.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <SIDE> Compiled code or function.
    <INTEGER> Ignored
    <INTEGER> Ignored

Returns:
    <ARRAY<STRING>> Serialisation of Code;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_side",sideUnknown,[sideUnknown]]
];
private _filename = "fn_serialiseSide";

[
    str([
        opfor,
        blufor,
        independent,
        civilian,
        sideUnknown,
        sideEnemy,
        sideFriendly,
        sideLogic,
        sideEmpty,
        sideAmbientLife
    ] find _side)
]
