params ["_type", "_marker", "_index", "_timeout", "_side"];

/*  Sets the data for the given unit to time it out for the given time
*
*   Scope: Internal
*
*   Params:
*       _type : STRING : Type of the unit, either Patrol or Static
*       _marker : STRING : The name of the marker the unit belonged to
*       _index : NUMBER : The index of the given unit
*       _timeout : NUMBER : The time in minutes the unit should not spawn
        _side : SIDE : The side of the unit which died for safety reasons
*
*   Returns:
*       Nothing
*/

private _fileName = "addTimeoutForUnit";

private _unitList = [];
private _unit = "";
private _checkFuture = false;

//Unit died after marker flipped, ignore it
if(sidesX getVariable _marker != _side) exitWith {};

switch (_type) do
{
    case ("Static"):
    {
        _unitList = garrison getVariable (format ["%1_statics", _marker]);
        _unit = (_unitList select _index);
        _checkFuture = true;
    };
    case ("Patrol"):
    {
        _unitList = garrison getVariable (format ["%1_patrols", _marker]);
        _unit = (_unitList select (floor (_index / 10))) select (_index % 10);
    };
};

[
    3,
    format ["Setting %1 on %2 on a %3 minutes timeout", _unit, _marker, _timeout],
    _fileName
] call A3A_fnc_log;

private _date = dateToNumber date;
private _unitDate = _unit select 1;

if(_checkFuture && {!([_unitDate] call A3A_fnc_unitAvailable)}) then
{
    //Unit is a static and already on a timeout, add the time
    private _newDate = 0;
    diag_log str _unitDate;
    _newDate = numberToDate _unitDate;
    _newDate = _newDate set [4, (_newDate select 4) + _timeout];
    diag_log str _newDate;
    _unit set [1, [_newDate select 0, _newDate]];
}
else
{
    _unit set [1, [date select 0, _date + (dateToNumber [0,1,1,0,30])]];
};


switch (_type) do
{
    case ("Static"):
    {
        garrison setVariable [(format ["%1_statics", _marker]), _unitList, true];
    };
    case ("Patrol"):
    {
        garrison setVariable [(format ["%1_patrols", _marker]), _unitList, true];
    };
};
