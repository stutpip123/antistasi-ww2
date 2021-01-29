/*
Function:
    Col_fnc_deserialiseAll

Description:
    Converts serialisation into Object of type All.

Environment:
    <SCHEDULED> Recommended, not required. Deserialisation process is resource heavy.

Parameters:
    <ARRAY> Serialisation of Object of type All.

Returns:
    <Object> Object from BIS_fnc_createSimpleObject.

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialisation",[],[ [] ]]
];
private _filename = "fn_deserialiseAll";

private _object = objNull;
try {
    private _attributes = +_serialisation;

    private _simpleObjectData = [_attributes,"simpleObjectData",[]] call Col_fnc_map_remGet;
    private _positionASL = [_attributes,"positionASL",[0,0,0]] call Col_fnc_map_remGet;
    _object = [_simpleObjectData, _attributes] call BIS_fnc_createSimpleObject;
} catch {
    [1, _exception joinString " | ", _filename] remoteExecCall ["A3A_fnc_log",2,false];
    if !(isNull _object) then {
        deleteVehicle _object;
    };
    _object = objNull;
};
_object;