/*
Function:
    A3A_fnc_serialiseAll

Description:
    Converts Object of type All into string.
    Multiple strings are produced if the set string limit is exceeded.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <OBJECT> Object of type All.
    <INTEGER> Max string chunk length. [DEFAULT=1 000 000]
    <INTEGER> Max chunks, will throw exception if this is exceeded. [DEFAULT=1 000 000]

Returns:
    <ARRAY<STRING>> Serialisation of Object of type All;

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

private _chunks = [];
try {
    private _attributes = [
        ["simpleObjectData", [_object] call BIS_fnc_simpleObjectData],
        ["positionASL", getPosASL _object]
    ];
    _chunks = [str _attributes,_maxStringLength,_maxChunks] call A3A_fnc_stringChunks;
} catch {
    [1, str _exception, _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _chunks = [];
};
_chunks;
