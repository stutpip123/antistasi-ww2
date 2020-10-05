/*
Function:
    A3A_fnc_getAdmin

Description:
    Returns unit object of online admin or objNull.
    Does not work in SP. Must be on Local Host / Dedicated Multiplayer.

Scope:
    <ANY>

Environment:
    <ANY>

Returns:
    <OBJECT> Admin unit if online/Local Host

Examples:
    [] call A3A_fnc_getAdmin;

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/

private _filename = "fn_getAdmin";

if (isNil "A3A_lastAdmin") then {A3A_lastAdmin = objNull};
if (admin owner A3A_lastAdmin isEqualTo 0) then {
    if (isDedicated) then {
        private _allPlayers = (allUnits + allDeadMen);
        private _adminIndex = _allPlayers findIf {!(admin owner _x isEqualTo 0)};
        if !(_adminIndex isEqualTo -1) then { A3A_lastAdmin = _allPlayers # _adminIndex };
    } else {
        A3A_lastAdmin = player;
    };
};
A3A_lastAdmin;
