params ["_marker", "_patrolMarker", "_unitCount"];

/*  Adapts the size of the patrol marker (area) based on the amount of units running around

    Execution on: HC or Server

    Scope: Internal

    Params:
        _marker: STRING : The name of the main marker which is getting spawned in
        _patrolMarker : STRING : The name of the patrol marker which will be resized
        _unitCount : NUMBER : The amount of units running around at the marker

    Returns:
        Nothing
*/

private _fileName = "adaptMarkerSizeToUnitCount";

private _patrolSize = [_patrolMarker] call A3A_fnc_calculateMarkerArea;
//Ensure minimal marker if no garrison is there
private _sizePerUnit = 9999999;
if(_unitCount != 0) then
{
    _sizePerUnit = _patrolSize / _unitCount;
};

[
    3,
    format ["The size is %1, Unit count is %2, Per Unit is %3", _patrolSize, _unitCount, _sizePerUnit],
    _fileName,
    true
] call A3A_fnc_log;

//Every unit can search a area of 15000 m^2, if the area is bigger, reduce patrol area
private _patrolMarkerSize = getMarkerSize _patrolMarker;
if(_sizePerUnit > 15000) then
{
    [3, format ["Patrol area of %1 is too large, make it smaller", _marker], _fileName, true] call A3A_fnc_log;
    _patrolMarkerSize set [0, (_patrolMarkerSize select 0) * (15000/_sizePerUnit)];
    _patrolMarkerSize set [1, (_patrolMarkerSize select 1) * (15000/_sizePerUnit)];
};

private _mainMarkerSize = getMarkerSize _marker;
if(((_patrolMarkerSize select 0) < (_mainMarkerSize select 0)) || {(_patrolMarkerSize select 1) < (_mainMarkerSize select 1)}) then
{
    //Patrol marker is smaller than the original marker, have at least marker size
    [3, format ["Resizing %1 to marker %2 size", _patrolMarker, _marker], _fileName, true] call A3A_fnc_log;
    _patrolMarkerSize = _mainMarkerSize;
};

_patrolMarker setMarkerSize _patrolMarkerSize;
