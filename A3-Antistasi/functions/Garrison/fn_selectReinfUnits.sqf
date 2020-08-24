params ["_base", "_target", "_types"];

/*  Selects the units to send, given on the targets reinf needs (and what the base has (not yet))

    Execution on: HC or Server

    Scope: Internal

    Params:
        _base : STRING : The name of the origin base
        _target : STRING : The name of the destination
        _types : ARRAY of NUMBERS : The possible types for the reinf units

    Returns:
        _unitsSend : ARRAY : The units in the correct format
*/

private _fileName = "fn_selectReinfUnits";

_fn_fillVehicle =
{
    params ["_vehicleType", "_crew", "_sortedUnits", "_sortedCrew"];

    private _noMoreUnits = false;
    private _cargoSeats = ([_vehicleType, true] call BIS_fnc_crewCount) - (count _crew);
    private _cargoIndex = 0;
    private _cargo = [];

    for "_seat" from 1 to _cargoSeats do
    {
        //Index is higher then array indeces go
        if (_cargoIndex >= (count _sortedUnits)) then
        {
            //Add crew unit if possible
            if((_sortedCrew select 0) > 0) then
            {
                _cargo pushBack (_sortedCrew select 1);
                _sortedCrew set [0, (_sortedCrew select 0) - 1];
                _cargoIndex = 0;
            }
            else
            {
                //No crew available, check if cargo units available
                if(_cargoIndex == 0) then
                {
                    //No crew and cargo units available, all units loaded
                    _noMoreUnits = true;
                }
                else
                {
                    _cargoIndex = 0;
                };
            };
        }
        else
        {
            private _entry = _sortedUnits select _cargoIndex;
            _cargo pushBack (_entry select 1);
            if((_entry select 0) <= 1) then
            {
                //Last one, delete entry
                _sortedUnits deleteAt _cargoIndex;
                _cargoIndex = _cargoIndex - 1;
            }
            else
            {
                //More to come, reduce numbers
                _entry set [0, (_entry select 0) - 1];
            };
            _cargoIndex = _cargoIndex + 1;
        };
        if(_noMoreUnits) exitWith {};
    };
    [_cargo, _noMoreUnits];
};

private _pointsAvailable = garrison getVariable [format ["%1_recruit", _base], 0];
if(_pointsAvailable < 3) exitWith
{
    [2, "Can't select units with less than 3 point, would be an vehicle only with crew!", _fileName, true] call A3A_fnc_log;
    [];
};

private _unitsSend = [];

//Hard copy, need to work on this (Or do we?)
private _reinf = +([_target] call A3A_fnc_getRequested);
private _side = sidesX getVariable [_base, sideUnknown];

private _maxRequested = [_reinf, false] call A3A_fnc_countGarrison;
private _maxVehiclesNeeded = _maxRequested select 0;
private _maxCargoSpaceNeeded = _maxRequested select 2;
private _currentUnitCount = 0;

[3, format ["Gathered data for unit selection, available are %1, %3 cargo units needed", _maxUnitSend, _maxCargoSpaceNeeded], _fileName] call A3A_fnc_log;
[3, format ["Reinforcments requested from %1 for: %2", _target, _reinf], _fileName] call A3A_fnc_log;


private _finishedSelection = false;

private _sortedVehicles = [];
private _sortedUnits = [];
private _sortedCrew = [];

{
    _x params ["_vehicle", "_crewArray", "_cargoArray"];
    //Add vehicles to sorted array
    private _vehicleIndex = _sortedVehicles findIf {(_x select 1) == _vehicle};
    if(_vehicleIndex == -1) then
    {
        //Check if the convoy is able to transport this kind of vehicle
        if([_vehicle, _types, true] call A3A_fnc_checkReinfTypeForVehicle) then
        {
            _sortedVehicles pushBack [([_vehicle] call A3A_fnc_getVehicleCost) + ([_vehicle , true] call BIS_fnc_crewCount), _vehicle, 1];
        };
    }
    else
    {
        private _entry = _sortedVehicles select _vehicleIndex;
        _entry set [2, (_entry select 2) + 1];
    };

    //Add crew to sorted array
    {
        if (_x != "") then
        {
            if(_sortedCrew isEqualTo []) then
            {
                _sortedCrew = [1, _x];
            }
            else
            {
                _sortedCrew set [0, (_sortedCrew select 0) + 1];
            };
        };
    } forEach _crewArray;

    //Add cargo to sorted array
    {
        if(_x != "") then
        {
            private _unit = _x;
            private _unitIndex = _sortedUnits findIf {(_x select 1) == _unit};
            if(_unitIndex == -1) then
            {
                _sortedUnits pushBack [1, _unit];
            }
            else
            {
                private _entry = _sortedUnits select _unitIndex;
                _entry set [0, (_entry select 0) + 1];
            };
        };
    } forEach _cargoArray;
} forEach _reinf;

//All units sorted, now search for the most valuable vehicles and send them
//Sort the array in descending order, vehicle with the highest points is first element
_sortedVehicles sort false;

private _newLine = ["", [], []];
private _allUnitsLoaded = false;
private _crewMember = if(_side == Occupants) then {NATOCrew} else {CSATCrew};
{
    _x params ["_costs", "_vehicleType", "_amountNeeded"];

    for "_counter" from 1 to _amountNeeded do
    {
        //Can buy vehicle
        _newLine = ["", [], []];
        if (_costs < _pointsAvailable) then
        {
            _pointsAvailable = _pointsAvailable - _costs;
            _newLine set [0, _vehicleType];

            private _crew = [_vehicleType, _crewMember] call A3A_fnc_getVehicleCrew;
            //Reducing amount of needed crew
            if ((_sortedCrew select 0) > 0) then
            {
                _sortedCrew set [0, (_sortedCrew select 0) - (count _crew)];
            };
            _newLine set [1, _crew];

            //Check if we still got units to load
            if (!_allUnitsLoaded) then
            {
                private _result = [_vehicleType, _crew, _sortedUnits, _sortedCrew] call _fn_fillVehicle;
                _newLine set [2, _result select 0];
                _allUnitsLoaded = _result select 1;
            };
            [
                3,
                format ["Selected %1 as vehicle, %2 as crew and %3 as cargo", _newLine select 0, _newLine select 1, _newLine select 2],
                _fileName,
                true
            ] call A3A_fnc_log;
            _unitsSend pushBack _newLine;
        };
    };
} forEach _sortedVehicles;

if (!_allUnitsLoaded) then
{
    //We still got units which we have to send
    //Check which vehicle we are able to send now
    private _possibleVehicles = [];
    if(_side == Occupants) then
    {
        _possibleVehicles = [vehNATOBike, vehNATOPatrolHeli] + vehNATOLight + vehNATOTrucks + vehNATOTransportHelis;
    }
    else
    {
        _possibleVehicles = [vehCSATBike, vehCSATPatrolHeli] + vehCSATLight + vehCSATTrucks + vehCSATTransportHelis;
    };
    _possibleVehicles = _possibleVehicles select {[_x, _types, false] call A3A_fnc_checkReinfTypeForVehicle};

    private _sortedVehicles = [];
    {
        private _cost = ([_x] call A3A_fnc_getVehicleCost) + ([_x, true] call BIS_fnc_crewCount);
        if(_cost < _pointsAvailable) then
        {
            _sortedVehicles pushBack [_cost, _x];
        };
    } forEach _possibleVehicles;

    if(count _sortedVehicles == 0) exitWith
    {
        [
            3,
            "No further vehicle available, as the marker has no points left",
            _fileName,
            true
        ] call A3A_fnc_log;
    };

    _sortedVehicles sort false;
    [3, format ["List of possible vehicles is: %1", _sortedVehicles], _fileName] call A3A_fnc_log;

    {
        _x params ["_cost", "_vehicleType"];
        while {!_allUnitsLoaded && {_cost < _pointsAvailable}} do
        {
            _newLine = ["", [], []];
            _pointsAvailable = _pointsAvailable - _cost;
            _newLine set [0, _vehicleType];

            private _crew = [_vehicleType, _crewMember] call A3A_fnc_getVehicleCrew;
            //Reducing amount of needed crew
            if ((_sortedCrew select 0) > 0) then
            {
                _sortedCrew set [0, (_sortedCrew select 0) - (count _crew)];
            };
            _newLine set [1, _crew];

            private _result = [_vehicleType, _crew, _sortedUnits, _sortedCrew] call _fn_fillVehicle;
            _allUnitsLoaded = _result select 1;
            _newLine set [2, _result select 0];

            [
                3,
                format ["Selected %1 as vehicle, %2 as crew and %3 as cargo", _newLine select 0, _newLine select 1, _newLine select 2],
                _fileName,
                true
            ] call A3A_fnc_log;
            _unitsSend pushBack _newLine;
        };
        if(_allUnitsLoaded) exitWith {};
    } forEach _sortedVehicles;
};

garrison setVariable [format ["%1_recruit", _base], _pointsAvailable, true];
_unitsSend;
