params ["_marker", "_vehicleType"];

/*  Searches the current garrison of a marker for a specific type of vehicle

    Execution on: HC or Server

    Scope: External

    Params:
        _marker: STRING : Name of the marker which vehicles will be searched
        _vehicleType: STRING : Vehicle type according to the possible vehicle types

    Returns:
        _result: ARRAY : [0 or 1 for garrison or over, line index]
*/

private _overUnits = [_marker] call A3A_fnc_getOver;
private _garrison = [_marker] call A3A_fnc_getGarrison;

private _vehicle = "";
private _found = false;
private _result = objNull;
private _searchArray = _overUnits + _garrison;

for "_counter" from 0 to ((count _searchArray) - 1) do
{
    _vehicle = _searchArray select _counter select 0;
    if(_vehicle != "") then
    {
        if([_vehicle, _vehicleType] call A3A_fnc_checkVehicleType) then
        {
            private _crewArray = _searchArray select _counter select 1;
            if(_crewArray findIf {_x == ""} == -1) then
            {
                //Needed vehicle found and it has enough crew, return the id
                private _overCount = count _overUnits;
                if(_counter < _overCount) then
                {
                    _result = [1, _counter];
                }
                else
                {
                    _result = [0, _counter - _overCount];
                };
                _found = true;
            };
        };
    };
    if(_found) exitWith {};
};

_result;
