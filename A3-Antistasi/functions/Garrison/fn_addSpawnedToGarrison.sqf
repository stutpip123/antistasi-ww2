params ["_marker", "_units"];

/*  Adds !!!SPAWNED!!! units to garrisons, for simulated units use addToGarrison

    Execution on: Server or HC

    Scope: External

    Params:
        _marker : STRING : The name of the marker where the units get added to
        _units : ARRAY : The objects of the spawned units in the garrison system

    Returns:
        Nothing
*/

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

//Parsing unit objects into their classnames to add them to the garrison system
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
    _unitName pushBack _line;
} forEach _units;

//Add the data (ONLY DATA) to the garrison data
private _insertIndex = [_marker, _unitNames] call A3A_fnc_addToGarrison;

//Units added to the garrisons, got the indeces back for every unit that was added, reparsing that into the actual objects
private _garrisonInserts = _insertIndex select 0;
private _overInserts = _insertIndex select 1;

//Merge insertion arrays into one
private _allInserts = [];
{
    private _newElement = +(_x);
    private _key = _newElement select 0;
    private _overIndex = _overIndeces findIf {(_x select 0) == _key};
    if(_overIndex != -1) then
    {
        (_newElement select 1) append (_overInserts select _overIndex select 1);
        _overInserts deleteAt _overIndex;
    };
    _allInserts pushBack _newElement;
} forEach _garrisonInserts;

_allInserts append _overInserts;

//Arrays merged, now merge in the actual units
{
    private _key = _x select 0;
    private _index = _sortedList findIf {(_x select 0) == _key};
    _x set [0, _sortedList select _index select 0];
} forEach _allInserts;

//Now add the units to the groups
[_marker, _allInserts] call A3A_fnc_addToSpawnedArrays;
