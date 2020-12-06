/*
Function:
    Col_fnc_serialiseSide

Description:
    Converts Side into enum scalar.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <LOCATION> Serialisation builder.
    <SIDE> A side.

Returns:
    <ARRAY<STRING>> Serialisation of Code;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialise_builder",locationNull,[locationNull]],
    ["_side",sideUnknown,[sideUnknown]]
];
[
    "SIDE",
    [
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
    ] find _side
];
