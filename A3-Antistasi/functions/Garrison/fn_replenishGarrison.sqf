params ["_marker"];

//Airports of teamPlayer do not get replenished
if((sidesX getVariable _marker) == teamPlayer) exitWith {};
//Cannot replenish spawned airports
if((spawner getVariable _marker) != 2) exitWith {};

private _requested = [_marker] call A3A_fnc_getRequested;
private _pointsAvailable = garrison getVariable [format ["%1_recruit", _marker], 0];

private _reinforcements = [];
{
    _x params ["_vehicle", "_crewArray", "_cargoArray"];
    private _line = ["", [], []];

    if(_vehicle != "") then
    {
        private _cost = [_vehicle] call A3A_fnc_getVehicleCost;
        if(_cost <= _pointsAvailable) then
        {
            _line set [0, _vehicle];
            _pointsAvailable = _pointsAvailable - _cost;
        };
    };

    {
        if(_x != "") then
        {
            if(_pointsAvailable > 0) then
            {
                _pointsAvailable = _pointsAvailable - 1;
                (_line select 1) pushBack _x;
            };
        };
        if(_pointsAvailable == 0) exitWith {};
    } forEach _crewArray;

    {
        if(_x != "") then
        {
            if(_pointsAvailable > 0) then
            {
                _pointsAvailable = _pointsAvailable - 1;
                (_line select 2) pushBack _x;
            };
        };
        if(_pointsAvailable == 0) exitWith {};
    } forEach _cargoArray;

    _reinforcements pushBack _line;
    if(_pointsAvailable == 0) exitWith {};
} forEach _requested;

garrison setVariable [format ["%1_recruit", _marker], _pointsAvailable, true];
[_marker, _reinforcements, (sidesX getVariable _marker)] call A3A_fnc_addToGarrison;
