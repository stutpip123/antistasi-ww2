private ["_markerX","_threat","_positionX","_analyzed","_sideX"];

_threat = 0;

//if (("launch_I_Titan_short_F" in unlockedWeapons) or ("launch_NLAW_F" in unlockedWeapons)) then {_threat = 3};

_markerX = _this select 0;
_sideX = _this select 1;
if (_markerX isEqualType []) then {_positionX = _markerX} else {_positionX = getMarkerPos _markerX};
_threat = _threat + 2 * ({(isOnRoad getMarkerPos _x) and (getMarkerPos _x distance _positionX < distanceSPWN)} count outpostsFIA);

{
if (getMarkerPos _x distance _positionX < distanceSPWN) then
	{
	_analyzed = _x;
    private _garrison = [_analyzed] call A3A_fnc_getGarrison;
    private _over = [_analyzed] call A3A_fnc_getOver;
    _threat = _threat + ([_garrison + _over, true] call A3A_fnc_countGarrison);
	_staticsX = staticsToSave select {_x inArea _analyzed};
	if (count _staticsX > 0) then
		{
		_threat = _threat + ({typeOf _x == SDKMortar} count _staticsX) + (2*({typeOf _x == staticATteamPlayer} count _staticsX))
		};
	};
} forEach (markersX - citiesX - controlsX - outpostsFIA) select {sidesX getVariable [_x,sideUnknown] != _sideX};

_threat
