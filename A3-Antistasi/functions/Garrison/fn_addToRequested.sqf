params ["_marker", "_unit", "_unitIndex"];

/*  Adds the given units to the list of troups that needs to be reinforced
*     Params:
*       _marker: STRING : The name of the marker
*       _units: STRING: The name of the unit
*       _unitIndex: NUMBER: A number determining where the unit has to be, format YYX, with YY are the group id and X is the position (0 = vehicle, 1 = crew, 2 = group)
*
*   Returns:
*     Nothing
*/

private _fileName = "addToRequested";

if (isNil "_marker") exitWith
{
    [1, "No marker given, check all calls!", _fileName] call A3A_fnc_log;
};
if (isNil "_unit") exitWith
{
    [1, "No units given, check all calls!", _fileName] call A3A_fnc_log;
};

[
    3,
    format ["%1 on marker %2 died, ID is %3", _unit, _marker, _unitIndex],
    _fileName
] call A3A_fnc_log;

//A unit has been KIA
private _unitType = _unitIndex % 10;
private _groupID = floor (_unitIndex / 10);

//Get needed data
private _requested = [_marker] call A3A_fnc_getRequested;
private _garrison = [_marker] call A3A_fnc_getGarrison;

//Adding unit to element
private _reqElement = _requested select _groupID;
private _garElement = _garrison select _groupID;

if(_unitType != 0) then
{
    //Searches for the unit in the data
    private _unitIndex = (_garElement select _unitType) findIf {_x == _unit};
    if(_unitIndex != -1) then
    {
        (_reqElement select _unitType) set [_unitIndex, _unit];
        (_garElement select _unitType) set [_unitIndex, ""];
    }
    else
    {
        [
            1,
            format ["The given unit on %1 cannot be found in the garrison, unit was %2", _marker, _unit],
            _fileName
        ] call A3A_fnc_log;
    };
}
else
{
    //Setting vehicle
    _element set [0, _unit];
    _garElement set [0, ""];
};

garrison setVariable [format ["%1_garrison", _marker], _garrison, true];
garrison setVariable [format ["%1_requested", _marker], _requested, true];
