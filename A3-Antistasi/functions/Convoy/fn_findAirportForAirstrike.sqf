params ["_destination", ["_side", sideUnknown]];

/*
*   Usage: Searches for a suitable Airport for an airstrike on given destination
*
*   params
*   _destination : MARKER or POS; the destination of the airstrike
*   _side : SIDE; the side of the airstrike, only needed if _destination is a POS
*
*   retuns
*   _airport : MARKER; the best suited airport, "" if none found
*/
private _airport = "";
private _fileName = "findAirportForAirstrike";

//Assuming _destination is a pos
private _destinationPos = _destination;

//Given destination is a marker, getting side by marker or given side
if(_destination isEqualType "") then
{
    //Side not given
    if(_side == sideUnknown) then
    {
        _side = sidesX getVariable [_destination, sideUnknown];
    };
    _destinationPos = getMarkerPos _destination;
};

//No side found
if(_side == sideUnknown) exitWith
{
    [
        1,
        format ["Could not resolve side for destination %1", _destination],
        _fileName
    ] call A3A_fnc_log;
    _airport
};

//Sort by side
private _possibleAirports = airportsX select {sidesX getVariable [_x, sideUnknown] == _side};

//Sort by max distance and vehicle available
private _suitableAirports = [];
{
    private _posbase = getMarkerPos _x;
    if ((_destinationPos distance _posbase < distanceForAirAttack) && {!(isNull ([_x, "AIR_ATTACK"] call A3A_fnc_searchGarrisonForVehicle))}) then
    {
        _suitableAirports pushBack _x;
    };
} forEach _possibleAirports;


//If some remain, choose the nearest one, else return nil
if (count _suitableAirports > 0) then
{
    _airport = [_suitableAirports,_destinationPos] call BIS_fnc_nearestPosition;
    [
        3,
        format ["Found %1 suitable airports, will return %2", count _suitableAirports, _airport],
        _fileName
    ] call A3A_fnc_log;
}
else
{
    _airport = "";
    [
        3,
        "No suitable position found, returning empty string",
        _fileName
    ] call A3A_fnc_log;
};

_airport
