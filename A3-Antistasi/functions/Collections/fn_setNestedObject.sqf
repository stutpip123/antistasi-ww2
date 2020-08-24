/*
Function:
    A3A_fnc_setNestedObject

Description:
    Exactly the same as nesting getVariables to find final object to set variable on.
    Allows something similar in effect to a dynamic config.
    missionNamespace > "A3A_UIDPlayers" > "1234567890123456" > "equipment" > "weapon".
    Will create tree as it works towards final value.
    DO NOT CREATE SELF REFERENCING OBJECTS.

Scope:
    <LOCAL> Interacts with many objects. Should not be networked.

Environment:
    <UNSCHEDULED> Recommended as it queries global data. | <SCHEDULED> Not recommended.

Parameters:
    <VARSPACE/OBJECT> Parent variable space
    <STRING> Names of nested objects {0 ≤ repeat this param < ∞}
    ...
    <STRING> Name of variable.
    <ANY> Default value.

Returns:
    <BOOLEAN> true if success; false is failure; nil if crashed;

Examples:
    [player, "lootBoxesOpened", 5] call A3A_fnc_setNestedObject;
        // is equal to player setVariable ["lootBoxesOpened", 5, false];

    [missionNamespace, "A3A_UIDPlayers", "1234567890123456", "equipment", "weapon", "SMG_02_F"] call A3A_fnc_setNestedObject;
        // Is almost Equal to:    (* creates namespaces if not already defined)
        // _1 = missionNamespace getVariable ["A3A_UIDPlayers", *];
        // _2 = _1 getVariable ["1234567890123456", *];
        // _3 = _2 getVariable ["equipment", *];
        // _3 setVariable ["weapon", "SMG_02_F"];

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
private _args = _this;
private _filename = "Collections\fn_setNestedObject.sqf";

private _count = count _args;
if (_count isEqualTo 3) then {
    _args#0 setVariable [_args#1, _args#2];
} else {
    private _varSpace = _args#0 getVariable [_args#1, false];
    if (!(_varSpace isEqualType locationNull) || {isNull _varSpace}) then {
        _varSpace = [false] call A3A_fnc_createNamespace;
        _args#0 setVariable [_args#1,_varSpace];
    };
    ([_varSpace] + (_args select [2,_count-2])) call A3A_fnc_setNestedObject;
};
true;
