/*
Function:
    Col_fnc_serialiseCode

Description:
    Converts Code into string.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <CODE> Compiled code or function.
    <INTEGER> Max string chunk length. [DEFAULT=1 000 000]
    <INTEGER> Max chunks, will throw exception if this is exceeded. [DEFAULT=1 000 000]

Returns:
    <STRING> Serialisation of Code;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_code",{false},[{false}]],
    ["_maxStringLength",1000000,[0]],
    ["_maxChunks",1000000,[0]]
];
private _filename = "fn_serialiseCode";

private _serialisation = "";
try {
    private _serialisation = str _code;
    private _last = count _serialisation - 3;  // extra -2 as it includes the two trimmed braces.
    _serialisation = _serialisation select [1,_last + 2];  // Trims outer curly braces
} catch {
    [1, str _exception, _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _serialisation = "";
};
_serialisation;
