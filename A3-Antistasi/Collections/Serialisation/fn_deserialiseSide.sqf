/*
Function:
    Col_fnc_deserialiseSide

Description:
    Converts enum string into Side.

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
    ["_chunks",[],[ [] ]]
];
private _filename = "fn_deserialiseSide";
private _side = sideUnknown;
try {
    _side = [
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
    ] # (parseNumber (_chunks#0));
} catch {
    [1, str _exception, _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _side = sideUnknown;
};
_side;
