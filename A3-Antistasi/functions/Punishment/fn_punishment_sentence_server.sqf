/*
Function:
    A3A_fnc_punishment_sentence_server

Description:
    Organises the sentence and addActions of the detainee.
    Includes timer and release mechanism.
    Will release on remote sentence release time shorting.

Scope:
    <SERVER> Execute on server.

Environment:
    <SCHEDULED> For suspensions.

Parameters:
    <STRING> The UID of the detainee being sent to Ocean Gulag.
    <NUMBER> The time the detainee will be imprisoned.

Returns:
    <BOOLEAN> true if it hasn't crashed; false if invalid params; nil if it has crashed.

Examples:
    [_UID,_timeTotal] remoteExec ["A3A_fnc_punishment_sentence_server",2,false];

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params ["_UID","_timeTotal"];
private _filename = "fn_punishment_sentence_server.sqf";

_timeTotal = 5*(floor (_timeTotal/5)); // Rounds up so the loop lines up.
private _sentenceEndTime = (floor serverTime) + _timeTotal;
private _keyPairs = [["sentenceEndTime",_sentenceEndTime],["timeTotal",_timeTotal],["offenceTotal",1]];
[_UID,_keyPairs] call A3A_fnc_punishment_dataSet;


_keyPairs = [["name","NO NAME"],["player",objNull]];
private _data_instigator = [_UID,_keyPairs] call A3A_fnc_punishment_dataGet;
_data_instigator params ["_name","_detainee"];

[_UID] remoteExec ["A3A_fnc_punishment_notifyAdmin",0,false];

[_detainee,_UID,_name,_sentenceEndTime] spawn {
    params ["_detainee","_UID","_name","_sentenceEndTime"];
    private _filename = "fn_punishment_sentence_server.sqf/Loop";
    scriptName "fn_punishment_sentence_server.sqf/Loop";

    private _sentenceEndTime_old = _sentenceEndTime;
    private _disconnected = false;

    _keyPairs = [ ["sentenceEndTime",floor serverTime] ];
    while {(ceil serverTime) < _sentenceEndTime-1} do { // ceil and -1 if something doesn't sync up
        if (!isPlayer _detainee) exitWith {_disconnected=true};
        if ((admin owner _detainee > 0) || player isEqualTo _detainee) exitWith { // If local host, the server is the admin.
            [_UID,"forgive"] call A3A_fnc_punishment_release;
        };
        [_UID] remoteExec ["A3A_fnc_punishment_addActionForgive",0,false]; // Refreshes in case the admin logged in.
        [_detainee,_sentenceEndTime - (floor serverTime)] remoteExec ["A3A_fnc_punishment_sentence_client",_detainee,false];
        [_UID,"add"] call A3A_fnc_punishment_oceanGulag;
        uiSleep 5;
        _sentenceEndTime = ([_UID,_keyPairs] call A3A_fnc_punishment_dataGet)#0; // Polls for updates from admin forgive
    };
    if (_disconnected) then {
        _playerStats = format["Player: %1 [%2], _timeTotal: %3", _name, _UID, str _timeTotal];
        [2, format ["DISCONNECTED/DIED WHILE PUNISHED | %1", _playerStats], _filename] call A3A_fnc_log;
        systemChat format["FF: %1 disconnected/died while being punished.",_name];
        [_UID,"remove"] call A3A_fnc_punishment_oceanGulag;
    } else {
        [_UID,["punishment_warden_manual","punishment_warden"] select (_sentenceEndTime_old isEqualTo _sentenceEndTime)] call A3A_fnc_punishment_release;
    };
};
true;
