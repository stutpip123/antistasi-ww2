/*
Function:
    A3A_fnc_deserialiseCode

Description:
    Converts strings into compiled Code.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Deserialisation process is resource heavy.

Parameters:
    <STRING> Serialisation of Code.

Returns:
    <CODE> Compiled code or function;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialisation",[],[ [] ]]
];
private _filename = "fn_deserialiseCode";

private _code = {};
try {
    _code = compile _serialisation;
} catch {
    [1, _exception joinString " | ", _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _code = {};
};
_code;
