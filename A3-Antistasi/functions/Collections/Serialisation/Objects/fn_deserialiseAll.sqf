/*
Function:
    A3A_fnc_deserialiseAll

Description:
    Converts string into Object of type All.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Deserialisation process is resource heavy.

Parameters:
    <ARRAY<STRING>> Serialisation of Object of type All.

Returns:
    <Object> Object from BIS_fnc_createSimpleObject.

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_chunks",[],[ [] ]]
];
private _filename = "fn_deserialiseAll";

private _object = objNull;
try {
    private _attributes = parseSimpleArray (_chunks joinString "");
    private _simpleObjectData = [_attributes,"simpleObjectData",[]] call A3A_fnc_remKeyPair;
    private _positionASL = [_attributes,"positionASL",[0,0,0]] call A3A_fnc_remKeyPair;
    _object = [_simpleObjectData, _positionASL] call BIS_fnc_createSimpleObject;
} catch {
    [1, str _exception, _filename] remoteExecCall ["A3A_fnc_log",2,false];
    if !(isNull _object) then {
        deleteVehicle _object;
    };
    _object = objNull;
};
_object;