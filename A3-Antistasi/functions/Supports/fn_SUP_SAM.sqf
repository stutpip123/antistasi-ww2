params ["_side", "_timerIndex", "_supportPos", "_supportName"];

/*  Prepares the SAM launcher and marker

    Execution on: Server

    Scope: Internal

    Params:
        _side: SIDE : The side for which the support should be called in
        _timerIndex: NUMBER
        _supportPos: POS
        _supportName: STRING : The call name of the support

    Returns:
        The name of the marker, covering the whole support area
*/

private _fileName = "SUP_SAM";

private _spawnPos = [];
private _availableAirports = airportsX select
{
    (getMarkerPos _x distance2D _supportPos <= 8000) &&
    (sidesX getVariable [_x, sideUnknown] == _side) &&
    (spawner getVariable _x == 2)
};

if(count _availableAirports == 0) exitWith
{
    [2, "No airport suitable to place SAM on it", _fileName] call A3A_fnc_log;
    "";
};
//Check which airports are able to fire at the given position
private _finalAirports = [];
{
    private _airportPos = getMarkerPos _x;
    private _dir = _airportPos getDir _supportPos;
    private _intercectPoint = _airportPos getPos [250, _dir];
    _intercectPoint = _intercectPoint vectorAdd [0, 0, 300];
    if !(terrainIntersect [_checkPoint, _supportPos]) then
    {
        _finalAirports pushBack _x;
    };
} forEach _availableAirports;

private _spawnMarker = "";

if(count _finalAirports == 0) then
{
    _spawnMarker = [_availableAirports, _supportPos] call BIS_fnc_nearestPosition;
}
else
{
    if(count _finalAirports == 1) then
    {
        _spawnMarker = _finalAirports select 0;
    }
    else
    {
        _spawnMarker = [_finalAirports, _supportPos] call BIS_fnc_nearestPosition;
    };
};

private _coverageMarker = createMarker [format ["%1_coverage", _supportName], _supportPos];
_coverageMarker setMarkerShape "ELLIPSE";
_coverageMarker setMarkerBrush "Grid";
if(_side == Occupants) then
{
    _coverageMarker setMarkerColor colorOccupants;
}
else
{
    _coverageMarker setMarkerColor colorInvaders;
};
_coverageMarker setMarkerSize [8000, 8000];
_coverageMarker setMarkerAlpha 0;

if(_side == Occupants) then
{
    occupantsSAMTimer set [0, time + (3600 * 2)];
}
else
{
    invadersSAMTimer set [0, time + (3600 * 2)];
};

private _spawnPos = getMarkerPos _spawnMarker;

//TODO spawn launcher here

[_launcher, _side, _supportName] spawn A3A_fnc_SUP_cruiseMissileRoutine;
_coverageMarker;
