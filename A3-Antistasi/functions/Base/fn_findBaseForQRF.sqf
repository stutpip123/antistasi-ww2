params ["_posDestination", "_side"];

/*  Finds a base for QRF or small attacks

    Execution on: HC or Server

    Scope: Internal

    Parameters:
        _posDestination: POSITION : The position which should be attacked
        _side: SIDE : The attacking side

    Returns:
        STRING : The name of the marker to start the attack from, "" if none available
*/

private _threatEvalLand = [_posDestination,_side] call A3A_fnc_landThreatEval;;

//Start selecting the starting base
private _availableAirports = airportsX select
{
    (sidesX getVariable [_x,sideUnknown] == _side) &&
    {([_x,true] call A3A_fnc_airportCanAttack) &&
    {(getMarkerPos _x) distance2D _posDestination < distanceForAirAttack}}
};

if (hasIFA && (_threatEvalLand <= 15)) then
{
    _availableAirports = _availableAirports select {(getMarkerPos _x distance2D _posDestination < distanceForLandAttack)}
};

private _outposts = if (_threatEvalLand <= 15) then
{
    outposts select
    {
        (sidesX getVariable [_x,sideUnknown] == _side) &&
        {([_x,true] call A3A_fnc_airportCanAttack) &&
        {(getMarkerPos _x distance _posDestination < distanceForLandAttack) &&
        {[_posDestination, getMarkerPos _x] call A3A_fnc_isTheSameIsland}}}
    }
}
else
{
    []
};

_availableAirports = _availableAirports + _outposts;
private _nearestMarker = [(resourcesX + factories + airportsX + outposts + seaports),_posDestination] call BIS_fnc_nearestPosition;
private _markerOrigin = "";
_availableAirports = _availableAirports select
{
    ({_x == _nearestMarker} count (killZones getVariable [_x,[]])) < 3
};

if !(_availableAirports isEqualTo []) then
{
    _markerOrigin = [_availableAirports, _posDestination] call BIS_fnc_nearestPosition;
};

_markerOrigin;
