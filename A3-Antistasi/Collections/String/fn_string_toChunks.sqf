/*
Author: Caleb Serafin
    String is cut into chunks with maximum size of on _maxChunkSize.

Arguments:
    <STRING> Input.
    <INTEGER> Max string chunk length. [DEFAULT=1 000 000]
    <INTEGER> Max chunks, will throw exception if this is exceeded. [DEFAULT=1 000 000]

Return Value:
    <ARRAY<STRING>> Chunks of original string.

Scope: Any.
Environment: Any
Public: Yes

Exceptions:
    ["TooManyChunks",_message];

Example:
    private _string = "[""Hello World!"",""Hello Program!""]";
    [_string,7] call Col_fnc_string_toChunks;  // ["[""Hello"," World!",""",""Hell","o Progr","am!""]"]
*/
params [
    ["_string","",[""]],
    ["_maxChunkSize",1000000,[0]],
    ["_maxChunks",1000000,[0]]
];

private _numberOfChunks = ceil (count _string / 7) -1;
if (_numberOfChunks > _maxChunks) then {
    throw ["TooManyChunks",[str _numberOfChunks," > ",str _maxChunks] joinString ""];
    [];
};

private _chunks = [];
for "_i" from 0 to _maxChunkSize*_numberOfChunks step _maxChunkSize do {
    _chunks pushBack (_string select [_i, _maxChunkSize]);
};
_chunks;
