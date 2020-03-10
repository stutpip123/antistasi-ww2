private _markerX = _this select 0;
if (!(_markerX in airportsX) and !(_markerX in outposts)) exitWith {false};
if !(dateToNumber date > server getVariable [_markerX,0]) exitWith {false};
private _isQRF = _this select 1;

private _garrison = [_markerX] call A3A_fnc_getGarrison;
private _over = [_markerX] call A3A_fnc_getOver;
private _garCount = [_garrison + _over, true] call A3A_fnc_countGarrison;
if (_isQRF && (_garCount <= 8)) exitWith {false};
if (!_isQRF && (_garCount < 16)) exitWith {false};
if ([distanceSPWN/2,1,getMarkerPos _markerX,teamPlayer] call A3A_fnc_distanceUnits) exitWith {false};
if (_markerX in forcedSpawn) exitWith {false};
true
