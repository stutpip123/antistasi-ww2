
_resourcesFIA = server getVariable "resourcesFIA";

_destroyedSites = destroyedSites - citiesX;

if (!visibleMap) then {openMap true};
positionTel = [];
hint "Click on the zone you want to rebuild.";

onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

_siteX = [markersX,_positionTel] call BIS_fnc_nearestPosition;

if (getMarkerPos _siteX distance _positionTel > 50) exitWith {hint "You must click near a map marker"};

if ((not(_siteX in _destroyedSites)) and (!(_siteX in outposts))) exitWith {hint "You cannot rebuild that"};


_leave = false;
_antennaDead = [];
_textX = "That Outpost does not have a destroyed Radio Tower";
if (_siteX in outposts) then
{
	_antennasDead = antennasDead select {_x inArea _siteX};
	if (count _antennasDead > 0) then
	{
		if (sidesX getVariable [_siteX, sideUnknown] != teamPlayer) then
		{
			_leave = true;
			_textX = format ["You cannot rebuild a Radio Tower in an Outpost which does not belong to %1",nameTeamPlayer];
		}
		else
		{

			if (_resourcesFIA < 5000) then
			{
				_leave = true;
				_textX = "You do not have enough money to rebuild this Asset. You need 5.000 €";
			}
			else
			{
				_antennaDead = _antennasDead select 0;
			};
		};
	}
	else
	{
		_leave = true
	};
}
else
{
	//Marker in resource or factory
	private _currentDestruct = server getVariable [format ["%1_destruct", _siteX], 100];
	private _neededMoney = 2500 + round (((_currentDestruct - 100)/100) * 5000);

	if (_resourcesFIA < _neededMoney) then
	{
		_leave = true;
		_textX = format ["You do not have enough money to rebuild %1. You need %2 €", [_siteX] call A3A_fnc_localizar, _neededMoney];
	};
};


if (_leave) exitWith {hint format ["%1",_textX]};

if (count _antennaDead == 0) then
{
	_nameX = [_siteX] call A3A_fnc_localizar;

	hint format ["%1 Rebuilt"];

	server setVariable [format ["%1_locked", _siteX], true];
	[_siteX] spawn
	{
		_marker = _this select 0;
		//Wait until despawn
		waitUntil {sleep 1; (spawner getVariable _marker == 2)};
		[_marker] spawn A3A_fnc_rebuildSite;
	};

	[0,10,_positionTel] remoteExec ["A3A_fnc_citySupportChange",2];
	[5,0] remoteExec ["A3A_fnc_prestige",2];
	destroyedSites = destroyedSites - [_siteX];
	publicVariable "destroyedSites";
}
else
	{
	hint "Radio Tower rebuilt";
	antennasDead = antennasDead - [_antennaDead]; publicVariable "antennasDead";
	_antenna = nearestBuilding _antennaDead;
	if (isMultiplayer) then {[_antenna,true] remoteExec ["hideObjectGlobal",2]} else {_antenna hideObject true};
	_antenna = createVehicle ["Land_Communication_F", _antennaDead, [], 0, "NONE"];
	antennas pushBack _antenna; publicVariable "antennas";
	{if ([antennas,_x] call BIS_fnc_nearestPosition == _antenna) then {[_x,true] spawn A3A_fnc_blackout}} forEach citiesX;
	_mrkFinal = createMarker [format ["Ant%1", count antennas], _antennaDead];
	_mrkFinal setMarkerShape "ICON";
	_mrkFinal setMarkerType "loc_Transmitter";
	_mrkFinal setMarkerColor "ColorBlack";
	_mrkFinal setMarkerText "Radio Tower";
	mrkAntennas pushBack _mrkFinal;
	publicVariable "mrkAntennas";
	_antenna addEventHandler ["Killed",
		{
		_antenna = _this select 0;
		{if ([antennas,_x] call BIS_fnc_nearestPosition == _antenna) then {[_x,false] spawn A3A_fnc_blackout}} forEach citiesX;
		_mrk = [mrkAntennas, _antenna] call BIS_fnc_nearestPosition;
		antennas = antennas - [_antenna]; antennasDead = antennasDead + [getPos _antenna]; deleteMarker _mrk;
		["TaskSucceeded",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",teamPlayer];
		["TaskFailed",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",Occupants];
		publicVariable "antennas"; publicVariable "antennasDead";
		}
		];
	};
[0,-5000] remoteExec ["A3A_fnc_resourcesFIA",2];
