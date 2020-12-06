/*
Author: Caleb Serafin
    Allows easy and efficient overwriting of default serialisers.

    Serialisation tables:
    localNamespace >> "Collections" >> "serialisation_builder" >> _uniqueID >> "primitive" >> [...]
    localNamespace >> "Collections" >> "serialisation_builder" >> _uniqueID >> "object" >> [...]

Arguments:
    <STRING> Unique string.

Return Value:
    <LOCATION> serialisationTable;

Exceptions:
    ["uniqueIDAlreadyInUse",_details] If the desired uniqueIDAlreadyInUse of a new serialization builder already exists.
    ["notImplementedYet",_details] If _support_objects is true.

Scope: Local.
Environment: Scheduled, Recommended as it could recurse over an entire sub-tree. Could be resource heavy.
Public: Yes

Example:

*/
params [
    "_uniqueID","",[""],
    ["_support_objects",false,[false]]
];
if (locationNull isEqualType ([localNamespace,"Collections","serialisation_builder", _uniqueID, false] call Col_fnc_nestLoc_get)) exitWith {
    throw ["uniqueIDAlreadyInUse",["UniqueID '",_uniqueID,"' already exists for serialisation builder."] joinString ""];
};

private _serialise_builder = [localNamespace,"Collections","serialisation_builder", _uniqueID,[false] call A3A_fnc_createNamespace] call Col_fnc_nestLoc_set;
private _primitive = _serialise_builder setVariable ["primitive",[false] call A3A_fnc_createNamespace];

{
    _primitive setVariable [_x#0,_x#1];
} forEach (call Col_fnc_serialise_primitive_defaults);

if (_support_objects) then {
    throw ["notImplementedYet","Object serialisation is not supported yet."];
};
