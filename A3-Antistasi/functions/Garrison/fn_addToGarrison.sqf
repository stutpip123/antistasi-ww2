params ["_marker", "_units"];

/*  Adds units to a garrison, removes them from the reinforcements
*   Params:
*     _marker: STRING: The name of the marker
*     _units: ARRAY: The new units, formated as garrisons are
*
*   Returns:
*     Nothing
*/
private _fileName = "addToGarrison";

if (isNil "_marker") exitWith
{
    [1, "No marker given, check all calls!", _fileName] call A3A_fnc_log;
};
if (isNil "_units") exitWith
{
    [1, "No units given, check all calls!", _fileName] call A3A_fnc_log;
};

private _garrison = [_marker] call A3A_fnc_getGarrison;
private _requested = [_marker] call A3A_fnc_getRequested;

//Sorting all new units into one array, formating [name, amount]
private _sortingUnits = [];
{
    private _toAdd = [];
    private _line = _x;

    //Add the vehicle
    if(_line select 0 != "") then
    {
        _toAdd pushBack (_line select 0);
    };

    //Add the crew
    {
        if(_x != "") then
        {
            _toAdd pushBack _x;
        };
    } forEach (_line select 1);

    //Add the cargo
    {
        if(_x != "") then
        {
            _toAdd pushBack _x;
        };
    } forEach (_line select 2);

    //Line sorted, now add units to the array
    {
        private _unitName = _x;
        private _unitIndex = _sortingUnits findIf {(_x select 0) == _unitName};
        if(_unitIndex == -1) then
        {
            //Unit is new in the array, add it
            _sortingUnits pushBack [_unitName, 1];
        }
        else
        {
            //Unit is already in the array, increase number
            private _number = ((_sortingUnits select _unitIndex) select 1) + 1;
            (_sortingUnits select _unitIndex) set [1, _number];
        };
    } forEach _toAdd;
} forEach _units;

//Sorting all requested units, format [name , [[element, type, index], ...]]
private _sortingReqs = [];
for "_element" from 0 to ((count _requested) - 1) do
{
    private _line = _requested select _element;
    private _toAdd = [];

    //Add the vehicle
    if(_line select 0 != "") then
    {
        _toAdd pushBack [_line select 0, [_element, 0, -1]];
    };

    //Add the crew
    for "_crewIndex" from 0 to ((count (_line select 1)) - 1) do
    {
        private _unit = (_line select 1) select _crewIndex;
        if(_unit != "") then
        {
            _toAdd pushBack [_unit, [_element, 1, _crewIndex]];
        };
    };

    //Add the cargo
    for "_cargoIndex" from 0 to ((count (_line select 2)) - 1) do
    {
        private _unit = (_line select 2) select _cargoIndex;
        if(_unit != "") then
        {
            _toAdd pushBack [_unit, [_element, 2, _cargoIndex]];
        };
    };

    //Line sorted, now add units to the array
    {
        private _unitName = _x select 0;
        private _path = _x select 1;

        private _unitIndex = _sortingReqs findIf {(_x select 0) == _unitName};
        if(_unitIndex == -1) then
        {
            //Unit is new in the array, add it
            _sortingReqs pushBack [_unitName, [_path]];
        }
        else
        {
            //Unit is already in the array, add path
            ((_sortingReqs select _unitIndex) select 1) pushBack _path;
        };
    } forEach _toAdd;
};

private _overUnits = [];
{
    private _unit = _x select 0;
    private _amount = _x select 1;

    //Sort units in
    private _unitIndex = _sortingReqs findIf {(_x select 0) == _unit};
    if (_unitIndex != -1) then
    {
        while {_amount > 0} do
        {
            if(((_sortingReqs select _unitIndex) select 1) isEqualTo []) exitWith
            {
                //No more units needed, exiting
            };

            private _path = ((_sortingReqs select _unitIndex) select 1) deleteAt 0;
            [
                4,
                format ["Path is %1, unit data is %2", _path, (_sortingReqs select _unitIndex)],
                _fileName
            ] call A3A_fnc_log;
            private _garElement = _garrison select (_path select 0);
            private _reqElement = _requested select (_path select 0);
            if((_path select 1) == 0) then
            {
                _garElement set [0, _unit];
                _reqElement set [0, ""];
            }
            else
            {
                private _garSubElement = _garElement select (_path select 1);
                private _reqSubElement = _reqElement select (_path select 1);
                _garSubElement set [(_path select 2), _unit];
                _reqSubElement set [(_path select 2), ""];
            };
            _amount = _amount - 1;
        };
    };

    //Over units are saved here
    for "_over" from 1 to _amount do
    {
        _overUnits pushBack _unit;
    };
} forEach _sortingUnits;

garrison setVariable [format ["%1_garrison", _marker], _garrison, true];
garrison setVariable [format ["%1_requested", _marker], _requested, true];

[_marker, _overUnits] call A3A_fnc_addToOver;

[_marker] call A3A_fnc_updateReinfState;
