params ["_marker", "_units"];

//Parsing unit objects into their classnames to add them to the garrison system
_fn_addUnitToList =
{
    params ["_list", "_key", "_value"];
    private _index = _list findIf {(_x select 0) == _key};
    if(_index == -1) then
    {
        _list pushBack [_key, [_value]];
    }
    else
    {
        ((_list select _index) select 1) pushBack _value;
    };
};

_fn_parseTypeNames =
{
    params ["_unitArray", "_sortedList"];
    private _result = _unitArray apply
    {
        if (_x != "") then
        {
            private _type = typeName _x;
            [_sortedList, _type, _x] call _fn_addUnitToList;
            _type;
        }
        else
        {
            "";
        }
    };
    _result;
};

private _sortedList = [];
private _unitNames = [];

{
    _x params ["_vehicle", "_crewArray", "_unitArray"];
    private _line = [];
    if(_vehicle != "") then
    {
        private _type = typeName _vehicle;
        [_sortedList, _type, _vehicle] call _fn_addUnitToList;
        _line pushBack _type;
    }
    else
    {
        _line pushBack "";
    };
    _line pushBack ([_crewIndex, _sortedList] call _fn_parseTypeNames);
    _line pushBack ([_unitArray, _sortedList] call _fn_parseTypeNames);
} forEach _units;

private _insertIndex = [_marker, _units] call A3A_fnc_addToGarrison;

//Units added to the garrisons, got the indeces back for every unit that was added, reparsing that into the actual objects
private _garrisonInserts = _insertIndex select 0;
private _overInserts = _insertIndex select 1;
