/*
Function:
	A3A_fnc_punishment_checkStatus

Description:
	Checks if the UID is should be in ocean gulag. If guilty, player is punished.

Scope:
	<SERVER> Execute on server.

Environment:
	<UNSCHEDULED>

Parameters:
	<STRING> If adding EH to AI, passing a reference is required: Otherwise vanilla EH will be added to the machine it's local on.

Returns:
	<BOOLEAN> true if it hasn't crashed; false if something is wrong disabled; nil if it has crashed.

Examples:
	[_UID] remoteExec ["A3A_fnc_punishment_checkStatus",2,false];

	// Unit Test
	private _UID = getPlayerUID player;
	private _keyPairs = [["timeTotal",10],["offenceTotal",1]];
	([_UID,_keyPairs] call A3A_fnc_punishment_dataSet) params ["_timeTotal","_offenceTotal"];
	[_UID] remoteExec ["A3A_fnc_punishment_checkStatus",2,false];
	allVariables [missionNamespace,"A3A_FFPun",_UID,locationNull] call A3A_fnc_getNestedObject;

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [["_UID","",[""]]];
private _fileName = "fn_punishment_checkStatus";

if ((!tkPunish) || {_UID isEqualTo ""}) exitWith {false;};

private _offenceTotal = [missionNamespace,"A3A_FFPun",_UID,"_offenceTotal",0] call A3A_fnc_getNestedObject;

if (_offenceTotal >= 1) then {
	_instigator = [_UID] call BIS_fnc_getUnitByUid;
	if (!isPlayer _instigator) exitWith {};
	[missionNamespace,"A3A_FFPun",_UID,"lastOffenceTime",nil] call A3A_fnc_setNestedObject;  // CLears any sort of depreciation that would gather over time away from server.
	[_instigator, 0, 0] remoteExecCall ["A3A_fnc_punishment",2,false];
};
true;
