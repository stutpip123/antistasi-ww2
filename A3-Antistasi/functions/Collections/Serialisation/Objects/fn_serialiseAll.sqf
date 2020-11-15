/*
Function:
    A3A_fnc_serialiseAll

Description:
    Converts Object of type All into primitive array.

Environment:
    <SCHEDULED> Recommended, not required. Serialisation process is resource heavy.

Parameters:
    <OBJECT> Object of type All.

Returns:
    <ARRAY> Serialisation of Object of type All;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_object",objNull,[objNull]],
    ["_maxStringLength",1000000,[0]],
    ["_maxChunks",1000000,[0]]
];
private _filename = "fn_serialiseAll";

private _serialisation = [];
try {
    _serialisation = [
        ["simpleObjectData", [_object] call BIS_fnc_simpleObjectData],
        ["positionASL", getPosASL _object]
    ];
} catch {
    [1, _exception joinString " | ", _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _serialisation = [];
};
_serialisation;
