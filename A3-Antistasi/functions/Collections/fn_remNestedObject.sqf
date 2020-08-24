/*
Function:
    A3A_fnc_remNestedObject

Description:
    Recursively deletes nested child objects.
    Doing this by hand may cause memory leaks.
    DO NOT DELETE SELF REFERENCING OBJECTS.

Scope:
    <LOCAL> Interacts with many objects. Should not be networked.

Environment:
    <SCHEDULED> Recurses over entire sub-tree.

Parameters:
    <VARSPACE/OBJECT> Parent variable space
    <BOOLEAN> Include parent? [DEFAULT=false]
    <BOOLEAN> Full object purge? Will delete objects as well. [DEFAULT=true]

Returns:
    <BOOLEAN> true if success; false if access denied; nil if crashed;

Examples:
    [player, "lootBoxesOpened", 5] call A3A_fnc_remNestedObject;
        // is equal to player setVariable ["lootBoxesOpened", 5, false];

    [missionNamespace, "A3A_UIDPlayers", "1234567890123456", "equipment", "weapon", "SMG_02_F"] call A3A_fnc_setNestedObject;
    [missionNamespace, "A3A_UIDPlayers", "1234567890123456", "equipment", "helmet", "H_Hat_grey"] call A3A_fnc_setNestedObject;
        // You now have missionNamespace > "A3A_UIDPlayers" > "1234567890123456" > "equipment" > [multiple end values]
    _varSpace = [missionNamespace, "A3A_UIDPlayers", locationNull] call A3A_fnc_getNestedObject; // returns a <location> that's referenced by "1234567890123456";
    [_varSpace,false] call A3A_fnc_remNestedObject;
        // You now have missionNamespace > "A3A_UIDPlayers" > []
    [_varSpace] call A3A_fnc_remNestedObject;
        // You now have missionNamespace > "A3A_UIDPlayers <LocationNull>"

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params ["_varSpace",["_incParent",true],["_purge",true]];
private _filename = "Collections\fn_remNestedObject.sqf";

[3, ["_varSpace: ",_varSpace] joinString "",_filename] call A3A_fnc_log;
[3, ["_incParent: ",_incParent] joinString "",_filename] call A3A_fnc_log;
[3, ["_purge: ",_purge] joinString "",_filename] call A3A_fnc_log;

if !(_varSpace isEqualType locationNull) exitWith {false}; // Deleting all missionNamespace contents will cause great trouble.
private _children = allVariables _varSpace;
private _item = false;
{
    _item = _varSpace getVariable [_x, false];
    if (_item isEqualType locationNull) then {
        [_item,true,_purge] call A3A_fnc_remNestedObject;
        _varSpace setVariable [_x,nil];
    } else {if (_purge && _item isEqualType objNull) then {
        deleteVehicle _item;
        _varSpace setVariable [_x,nil];
    };};
} forEach _children;
if (_incParent) then {
    deleteLocation _varSpace;
};
true;
