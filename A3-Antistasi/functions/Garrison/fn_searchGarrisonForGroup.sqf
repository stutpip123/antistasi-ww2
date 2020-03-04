params ["_marker", "_unitMinCount", "_unitMaxCount"];

/*  Searches the current garrison of a marker for a group of a specific size

    Execution on: HC or Server

    Scope: External

    Params:
        _marker: STRING : Name of the marker which vehicles will be searched
        _unitMinCount: NUMBER : The minimum amount of units the group should have
        _unitMaxCount: NUMBER : The maximum amoung of units the group can have

    Returns:
        _result: ARRAY : [0 or 1 for garrison or over, line index]
*/

private _overUnits = [_marker] call A3A_fnc_getOver;
private _garrison = [_marker] call A3A_fnc_getGarrison;

private _group = "";
private _found = false;
private _result = objNull;
private _searchArray = _overUnits + _garrison;

for "_counter" from 0 to ((count _searchArray) - 1) do
{
    _group = _searchArray select _counter select 2;
    private _unitCount = {_x != ""} count _group;
    if(_unitCount >= _unitMinCount && _unitCount <= _unitMaxCount) then
    {
        //Needed group found, return the id
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
    if(_found) exitWith {};
};

_result;
