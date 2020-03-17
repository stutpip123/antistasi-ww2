params ["_vehicleType", "_crewType", ["_unitCount", -1]];

/*  Returns an array of the needed crew for the vehicle
*   Params:
*     _vehicleType : STRING : The classname of the vehicle
*     _crewType : STRING : The classname of the crewmember
        _unitCount: NUMBER : The maximum amount of units to spawn, -1 if complete crew
*
*   Returns:
*     _result : ARRAY of STRINGS : The needed amount of crewmember as an array
*/

if(_vehicleType == "" || _vehicleType == "Empty") exitWith {[]};

private _seatCount = [_vehicleType, false] call BIS_fnc_crewCount;
if(_unitCount != -1) then
{
    _seatCount = _unitCount;
};

private _result = [];
for "_i" from 1 to _seatCount do
{
    _result pushBack _crewType;
};
_result;
