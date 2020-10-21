private _filename = "fn_pvpCheck";

params ["_unit"];

private _friendlyPlayers = ({(side group _x == teamPlayer)} count (call A3A_fnc_playableUnits));
private _enemyPlayers = count (call A3A_fnc_playableUnits) - _friendlyPlayers;

// Player checks to prevent them logging into PvP for whatever reason.
switch (true) do {
	case (!_isJip): {
		["noJip",false,1,false,false] call BIS_fnc_endMission;
		[2,format [localize "STR_antistasi_mission_end_noJip"],_filename] call A3A_fnc_log;
	};

	case (!pvpEnabled): {
		["noPvP",false,1,false,false] call BIS_fnc_endMission;
		[2,format [localize "STR_antistasi_mission_end_noPvP"],_filename] call A3A_fnc_log;
	};

	case (!([_unit] call A3A_fnc_isMember)): {
		["pvpMem",false,1,false,false] call BIS_fnc_endMission;
		[2,format [localize "STR_antistasi_mission_end_pvpMem"],_filename] call A3A_fnc_log;
	};

	case (_enemyPlayers > _friendlyPlayers): {
		["pvpCount",false,1,false,false] call BIS_fnc_endMission;
		[2,format [localize "STR_antistasi_mission_end_pvpCount"],_filename] call A3A_fnc_log;
	};

	case (_friendlyPlayers < minPlayersRequiredforPVP): {
		["pvpCount",false,1,false,false] call BIS_fnc_endMission;
		[2,format [localize "STR_antistasi_mission_end_pvpCount"],_filename] call A3A_fnc_log;
	};

	case (isnil "theBoss" || {isNull theBoss}): {
		["BossMiss",false,1,false,false] call BIS_fnc_endMission;
		[2,format [localize "STR_antistasi_mission_end_theBoss"],_filename] call A3A_fnc_log;
	};

	default {
		[2,format [localize "STR_antistasi_mission_end_Default"],_filename] call A3A_fnc_log;
		[_unit] remoteExec ["A3A_fnc_playerHasBeenPvPCheck",2];
	};
};
