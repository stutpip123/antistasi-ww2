/*
Function:
    Col_fnc_deserialiseSide

Description:
    Converts enum string into Side.
    There is no error checking if enum is out of range.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Deserialisation process is resource heavy.

Parameters:
    <ARRAY<STRING>> Serialisation of Side enum.

Returns:
    <SIDE> Side.

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialisation",0,[ 0 ]]
];
private _filename = "fn_deserialiseSide";
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
] # _serialisation;
