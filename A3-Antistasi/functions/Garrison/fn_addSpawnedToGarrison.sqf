params ["_marker", "_units", "_side"];

/*  Adds !!!SPAWNED!!! units to garrisons, for simulated units use addToGarrison

    Execution on: Server or HC

    Scope: External

    Params:
        _marker : STRING : The name of the marker where the units get added to
        _units : ARRAY : The objects of the spawned units in the garrison system

    Returns:
        Nothing
*/

private _fileName = "addSpawnedToGarrison";

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
        if !(_x isEqualTo "") then
        {
            private _type = typeOf _x;
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

[
    3,
    format ["Units to add are %1", _units],
    _fileName
] call A3A_fnc_log;

//Parsing unit objects into their classnames to add them to the garrison system
private _sortedList = [];
private _unitNames = [];

{
    _x params ["_vehicle", "_crewArray", "_unitArray"];
    private _line = [];
    if !(_vehicle isEqualTo "") then
    {
        private _type = typeOf _vehicle;
        [_sortedList, _type, _vehicle] call _fn_addUnitToList;
        _line pushBack _type;
    }
    else
    {
        _line pushBack "";
    };
    _line pushBack ([_crewArray, _sortedList] call _fn_parseTypeNames);
    _line pushBack ([_unitArray, _sortedList] call _fn_parseTypeNames);
    _unitNames pushBack _line;
} forEach _units;

[
    3,
    format ["Unit names are %1", _unitNames],
    _fileName
] call A3A_fnc_log;

[
    3,
    format ["Sorted units are %1", _sortedList],
    _fileName
] call A3A_fnc_log;

//Add the data (ONLY DATA) to the garrison data
private _insertIndex = [_marker, _unitNames, _side] call A3A_fnc_addToGarrison;

//Units added to the garrisons, got the indeces back for every unit that was added, reparsing that into the actual objects
private _garrisonInserts = _insertIndex select 0;
private _overInserts = _insertIndex select 1;

[
    3,
    format ["Insertion indeces of garrison are %1", _garrisonInserts],
    _fileName
] call A3A_fnc_log;

[
    3,
    format ["Insertion indeces of over are %1", _overInserts],
    _fileName
] call A3A_fnc_log;

//Merge insertion arrays into one
private _allInserts = [];
{
    private _newElement = +(_x);
    private _key = _newElement select 0;
    private _overIndex = _overInserts findIf {(_x select 0) == _key};
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
    _x set [0, _sortedList select _index select 1];
} forEach _allInserts;

[
    3,
    format ["Final result is %1", _allInserts],
    _fileName
] call A3A_fnc_log;

//Now add the units to the groups
[_marker, _allInserts] call A3A_fnc_addToSpawnedArrays;
[_marker] call A3A_fnc_mrkUpdate;
