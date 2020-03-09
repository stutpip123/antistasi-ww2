//Original Author: Barbolani
//Edited and updated by the Antistasi Community Development Team
scriptName "fn_initGarrisons";
private _fileName = "initGarrisons";
[2,"InitGarrisons started",_fileName] call A3A_fnc_log;

_fnc_initMarker =
{
	params ["_mrkCSAT", "_target", "_mrkType", "_mrkText", ["_useSideName", false]];
	private ["_pos", "_mrk", "_garrNum", "_garrison", "_groupsRandom"];

	{
		_pos = getMarkerPos _x;
		_mrk = createMarker [format ["Dum%1", _x], _pos];
		//TODO Multilanguage variable insted text
		_mrk setMarkerShape "ICON";

		if (_useSideName) then
		{
			killZones setVariable [_x, [], true];
			server setVariable [_x, 0, true];

			if (_x in _mrkCSAT) then
			{
				_mrkText = format [_mrkText, nameInvaders];
				if(_x in airportsX) then
				{
					_mrkType = flagCSATmrk;
				};
			}
			else
			{
				_mrkText = format [_mrkText, nameOccupants];
				if(_x in airportsX) then
				{
					_mrkType = flagNATOmrk;
				};
			};
		};

		if (_x in _mrkCSAT) then
		{
			_mrk setMarkerColor colorInvaders;
			sidesX setVariable [_x, Invaders, true];
		}
		else
		{
			_mrk setMarkerColor colorOccupants;
			sidesX setVariable [_x, Occupants, true];
		};

		_mrk setMarkerType _mrkType;
		_mrk setMarkerText _mrkText;

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

{
    private _side = sidesX getVariable _x;
    private _line = [([["EMPTY", 0, "AT"], _side] call A3A_fnc_createGarrisonLine)];
    garrison setVariable [format ["%1_over", _x], _line, true];
} forEach controlsX;

[2,"InitGarrisons completed",_fileName] call A3A_fnc_log;
