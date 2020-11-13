/*
Function:
    A3A_fnc_serialiseCode

Description:
    Converts Code into strings.
    Multiple strings are produced if the set string limit is exceeded.
    External curly braces are trimmed so that compile does not add an extra pair in output code.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <CODE> Compiled code or function.
    <INTEGER> Max string chunk length. [DEFAULT=1 000 000]
    <INTEGER> Max chunks, will throw exception if this is exceeded. [DEFAULT=1 000 000]

Returns:
    <ARRAY<STRING>> Serialisation of Code;

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

private _chunks = [];
try {
    private _serialisation = str _code;
    private _last = count _serialisation - 3;  // extra -2 as it includes the two trimmed braces.
    _serialisation = _serialisation select [1,_last + 2];  // Trims outer curly braces
    private _i = 0;
    for "_i" from 0 to _last-_maxStringLength+1 step _maxStringLength do {
        _chunks pushBack (_serialisation select [_i, _maxStringLength]);
    };
    private _remainingLength = (_last+1) % _maxStringLength;
    if !(_remainingLength isEqualTo 0) then {
        _chunks pushBack (_serialisation select [_last - _remainingLength + 1, _remainingLength]);
    };
    if (count _chunks > _maxChunks) then {
        throw ["TooManyChunks",[str count _chunks," > ",str _maxChunks] joinString ""];
    };
} catch {
    [1, str _exception, _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _chunks = [];
};
_chunks;
