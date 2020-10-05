/*
Function:
	A3A_fnc_punishment

Description:
	Punishes the player given for FF.
	Doesn't do the checking itself, refer to A3A_fnc_punishment_FF.

Scope:
	<SERVER>

Environment:
	<UNSCHEDULED> Suspension may cause simultaneous read then write of the players FF stats, leading to the last call taking preference.

Parameters:
	<OBJECT> Player that is being verified for FF.
	<NUMBER> The amount of time to add to the players total sentence time.
	<NUMBER> Raise the player's total offence level by this percentage. (100% total = Ocean Gulag).
	<OBJECT> [OPTIONAL] The victim of the player's FF.

Returns:
	<STRING> Either an exemption type or a return from fn_punishment.sqf.

Examples:
	[_instigator,_timeAdded,_offenceAdded,_victim] remoteExec ["A3A_fnc_punishment",2,false]; // How it should be called from another A3A_fnc_punishment_FF.
	// Unit Tests:
	[cursorObject, 0, 0] remoteExec ["A3A_fnc_punishment",2];                                 // Ping with FF Warning
	[cursorObject,120, 1] remoteExec ["A3A_fnc_punishment",2];                                // Punish, 120 additional seconds
	[player,10, 1] remoteExec ["A3A_fnc_punishment",2];                                       // Test Self Punish, 10 additional seconds
	// Function that goes hand-in-hand
	[cursorObject,"forgive"] remoteExec [A3A_fnc_punishment_release,2]; // Forgive all sins

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params ["_instigator","_timeAdded","_offenceAdded",["_victim",objNull],["_customMessage",""]];
private _filename = "fn_punishment.sqf";

//////////////////Settings//////////////////
private _depreciationCoef = 0.75;	// Modifies the drop-off curve of the punishment score; a higher number drops off quicker, a lower number lingers longer.
private _overheadPercent = 0.3;		// Percentage of _offenceAdded that does not get depreciated.

//////////Fetches punishment values/////////
private _originalBody = _instigator getVariable ["owner",_instigator];
private _UID = getPlayerUID _instigator;
private _name = name _instigator;
private _currentTime = (floor serverTime);
private _keyPairs = [["timeTotal",0],["offenceTotal",0],["lastOffenceTime",_currentTime],["overhead",0]];
([_UID,_keyPairs] call A3A_fnc_punishment_dataGet) params ["_timeTotal","_offenceTotal","_lastTime","_overhead"];

///////////////Data validation//////////////
_lastTime = (0 max _lastTime) min _currentTime;
_overhead = (0 max _overhead) min 1;
_offenceAdded = 0 max _offenceAdded;
_offenceTotal = (0 max _offenceTotal) min 2;
_timeAdded = 0 max _timeAdded;
_timeTotal = 0 max _timeTotal;

//////////////FF score addition/////////////
private _periodDelta = _currentTime - _lastTime;
_offenceTotal = _offenceTotal - _overhead;                                                      // _overhead is removed to exclude it from depreciation calculation.
_overhead = (_overhead + _offenceAdded * _overheadPercent) min 1;

_offenceTotal = _offenceTotal * (1-_depreciationCoef*(1-(_offenceTotal))) ^(_periodDelta/300);  // Special Depreciation formula, slow curve -> exponential drop -> slow curve ‾‾\__

_offenceTotal = (_offenceTotal + _offenceAdded * (1-_overheadPercent)) min 1;                   // New offence is added here. However, the amount of additional offence that was taken for overhead: is now excluded.
_offenceTotal = _offenceTotal + _overhead;                                                      // Maximum sum is capped at two as they were capped at one before this addition.

_timeTotal = _timeTotal * (1-_depreciationCoef) ^(_periodDelta/3000);                           // Simpler depreciation formula, larger time is used as their is no overhead system to stop it from becoming mere milliseconds after an hour.
_timeTotal = _timeTotal + _timeAdded;

//////////Saves data to instigator//////////
private _keyPairs = [["timeTotal",_timeTotal],["offenceTotal",_offenceTotal],["lastOffenceTime",_currentTime],["overhead",_overhead],["name",_name],["player",_originalBody]];
[_UID,_keyPairs] call A3A_fnc_punishment_dataSet;

///////////////Victim Notifier//////////////
private _injuredComrade = "";
private _victimStats = " system punished";
if (_victim isKindOf "Man") then {
	_injuredComrade = ["Injured comrade: ",name _victim] joinString "";
	["FF Notification", [_name," hurt you!"] joinString ""] remoteExec ["A3A_fnc_customHint", _victim, false];
	private _UIDVictim = ["AI", getPlayerUID _victim] select (isPlayer _victim);
	_victimStats = ["damaged ",name _victim," [",_UIDVictim,"]"] joinString "";
};

/////////////Instigator Notifier////////////
private _playerStats = ["Total-time: ",str _timeTotal," (incl. +",str _timeAdded,"), Offence+Overhead: ",str _offenceTotal," [",str (_offenceTotal-_overhead),"+",str _overhead,"] (incl. +",str _offenceAdded,")"] joinString "";
[2, [["WARNING","GUILTY"] select (_offenceTotal >= 1)," | ",_name," [",_UID,"] ",_victimStats,", ",_playerStats] joinString " | ", _filename] call A3A_fnc_log;

["FF Warning", ["Watch your fire!",_injuredComrade,_customMessage] joinString "<br/>"] remoteExec ["A3A_fnc_customHint", _originalBody, false];

if (_offenceTotal < 1) exitWith {"WARNING";};

////////Exit Remote Control (if any)////////
if (_instigator isEqualTo _originalBody) then {
	[_UID,_timeTotal] spawn A3A_fnc_punishment_sentence_server;  // Scope is within unscheduled space.
} else {
	(units group _originalBody) joinSilent group _originalBody;  // Refer to controlunit.sqf for source of this *function*
	group _instigator selectLeader _originalBody;
	["Control Unit", "Returned to original Unit due to FF."] remoteExec ["A3A_fnc_customHint",_instigator,false];
	[_originalBody] remoteExec ["selectPlayer",_instigator,false];

	[_instigator,_originalBody,_UID,_timeTotal,_name] spawn {  // Waits for player to control original body. This will be relocated to sentence_client in the future allowing for snappy execution server-side.
		params ["_instigator","_originalBody","_UID","_timeTotal","_name"];
		private _timeOut = serverTime + 20;
		waitUntil {_instigator isEqualTo _originalBody || _timeOut < serverTime};
		if (!(_instigator isEqualTo _originalBody)) exitWith {
			[1, ["TIMED-OUT | Gave up waiting for ",_name," [",_UID,"] to exit remote control."] joinString "", "fn_punishment.sqf/RemoteControlSpawn"] call A3A_fnc_log;
		};
		[_UID,_timeTotal] call A3A_fnc_punishment_sentence_server; // Scope is within scheduled space.
	};
};
"GUILTY";
