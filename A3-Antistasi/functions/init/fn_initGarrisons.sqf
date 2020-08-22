//Original Author: Barbolani
//Edited and updated by the Antistasi Community Development Team
scriptName "fn_initGarrisons";
private _fileName = "initGarrisons";
[2,"InitGarrisons started",_fileName] call A3A_fnc_log;
["Init Garrison", "Creating marker and garrison for all locations!"] call A3A_fnc_customHint;

_fnc_initMarker =
{
	params ["_mrkCSAT", "_target", "_mrkType", "_mrkText", ["_useSideName", false]];

	{
		private _pos = getMarkerPos _x;
		private _mrk = createMarker [format ["Dum%1", _x], _pos];
		//TODO Multilanguage variable insted text
		_mrk setMarkerShape "ICON";

		if (_useSideName) then
		{
			killZones setVariable [_x, [], true];
			server setVariable [_x, 0, true];

			private _sideName = if (_x in _mrkCSAT) then {nameInvaders} else {nameOccupants};
			_mrk setMarkerText format [_mrkText, _sideName];
		}
		else
		{
			_mrk setMarkerText _mrkText;
		};

		if (_x in airportsX) then
		{
			private _flagType = if (_x in _mrkCSAT) then {flagCSATmrk} else {flagNATOmrk};
			_mrk setMarkerType _flagType;
		}
		else
		{
			_mrk setMarkerType _mrkType;
		};

		if (_x in _mrkCSAT) then
		{
			if !(_x in airportsX) then {_mrk setMarkerColor colorInvaders;} else {_mrk setMarkerColor "Default"};
			sidesX setVariable [_x, Invaders, true];
		}
		else
		{
			if !(_x in airportsX) then {_mrk setMarkerColor colorOccupants;} else {_mrk setMarkerColor "Default"};
			sidesX setVariable [_x, Occupants, true];
		};

		[_x] call A3A_fnc_createControls;
	} forEach _target;
};

private _mrkNATO = [];
private _mrkCSAT = [];
private _controlsNATO = [];
private _controlsCSAT = [];

if (debug) then
{
	diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | Setting Control Marks for Worldname: %2  .", servertime, worldName];
};

if (gameMode == 1) then
{
	_controlsNATO = controlsX;
	switch (toLower worldName) do {
		case "tanoa": {
			_mrkCSAT = ["airport_1", "seaport_5", "outpost_10", "control_20"];
			_controlsCSAT = ["control_20"];
		};
		case "altis": {
			_mrkCSAT = ["airport_2", "seaport_4", "outpost_5", "control_52", "control_33"];
			_controlsCSAT = ["control_52", "control_33"];
		};
		case "chernarus_summer": {
			_mrkCSAT = ["outpost_21"];
		};
		case "tem_anizay": {
			_mrkCSAT = ["outpost_8", "control_19", "control_44", "control_45"];
			_controlsCSAT = ["control_19", "control_44", "control_45"];
		};
		case "chernarus_winter": {
			_mrkCSAT = ["outpost_21", "control_30"];
			_controlsCSAT = ["control_30"];
		};
		case "kunduz": {
			_mrkCSAT = ["outpost"];
		};
		case "enoch": {
			_mrkCSAT = ["airport_3", "control_14"];
			_controlsCSAT = ["control_14"];
		};
		case "tembelan": {
			_mrkCSAT = ["airport_4"];
		};
		case "malden": {
			_mrkCSAT = ["airport", "seaport_7"];
		};
		case "tem_kujari": {
			_mrkCSAT = [];
		};
		case "vt7": {
			_mrkCSAT = ["airport_2", "control_25", "control_29", "control_30", "control_31", "control_32", "Seaport_1", "Outpost_3"];
			_controlsCSAT = ["control_25", "control_29", "control_30", "control_31", "control_32"];
		};
		case "stratis": {
			_mrkCSAT = ["outpost_3"];
		};
	};
    _controlsNATO = _controlsNATO - _controlsCSAT;
	_mrkNATO = markersX - _mrkCSAT - ["Synd_HQ"];

	if (debug) then {
		diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | _mrkCSAT: %2.", servertime, _mrkCSAT];
		diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | _mrkNATO: %2.", servertime, _mrkNATO];
	};
}
else
{
	if (gameMode == 4) then
	{
		_mrkCSAT = markersX - ["Synd_HQ"];
		_controlsCSAT = controlsX;
	}
	else
	{
		_mrkNATO = markersX - ["Synd_HQ"];
		_controlsNATO = controlsX;
	};
};

{sidesX setVariable [_x, Occupants, true]} forEach _controlsNATO;
{sidesX setVariable [_x, Invaders, true]} forEach _controlsCSAT;

[_mrkCSAT, airportsX, flagCSATmrk, "%1 Airbase", true] call _fnc_initMarker;
[_mrkCSAT, resourcesX, "loc_rock", "Resources"] call _fnc_initMarker;
[_mrkCSAT, factories, "u_installation", "Factory"] call _fnc_initMarker;
[_mrkCSAT, outposts, "loc_bunker", "%1 Outpost", true] call _fnc_initMarker;
[_mrkCSAT, seaports, "b_naval", "Sea Port"] call _fnc_initMarker;

if (!(isNil "loadLastSave") && {loadLastSave}) exitWith {};

[3, "Setting up airbase garrisons", _fileName] call A3A_fnc_log;
[airportsX, "Airport", [0,0,0]] call A3A_fnc_createGarrison;
//Set carrier markers to the same as airbases below.
if (isServer) then {"NATO_carrier" setMarkertype flagNATOmrk};
if (isServer) then {"CSAT_carrier" setMarkertype flagCSATmrk};

[3, "Setting up resource garrisons", _fileName] call A3A_fnc_log;
[resourcesX, "Other", [0,0,0]] call A3A_fnc_createGarrison;

[3, "Setting up factory garrisons", _fileName] call A3A_fnc_log;
[factories, "Other", [0,0,0]] call A3A_fnc_createGarrison;

[3, "Setting up outpost garrisons", _fileName] call A3A_fnc_log;
[outposts, "Outpost", [1,1,0]] call A3A_fnc_createGarrison;

[3, "Setting up seaport garrisons", _fileName] call A3A_fnc_log;
[seaports, "Other", [1,0,0]] call A3A_fnc_createGarrison;

[3, "Setting up city garrisons", _fileName] call A3A_fnc_log;
[citiesX, "City", [0,0,0]] call A3A_fnc_createGarrison;

[2,"InitGarrisons completed",_fileName] call A3A_fnc_log;
