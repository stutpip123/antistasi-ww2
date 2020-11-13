/*
Function:
    A3A_fnc_stringChunks

Description:
    String is cut into chunks with maximum size of on _maxStringLength.

Parameters:
    <STRING> Input.
    <INTEGER> Max string chunk length. [DEFAULT=1 000 000]
    <INTEGER> Max chunks, will throw exception if this is exceeded. [DEFAULT=1 000 000]

Returns:
    <ARRAY<STRING>> String chunks.

Exceptions:
    ["TooManyChunks",_message];

Examples:
    private _serialisation = "[""Hello World!"",""Hello Program!""]";
    [_serialisation,7] call A3A_fnc_stringChunks;  // ["[""Hello"," World!",""",""Hell","o Progr","am!""]"]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialisation","",[""]],
    ["_maxStringLength",1000000,[0]],
    ["_maxChunks",1000000,[0]]
];
private _filename = "fn_stringChunks";

private _chunks = [];
private _last = count _serialisation - 1;
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
_chunks;
