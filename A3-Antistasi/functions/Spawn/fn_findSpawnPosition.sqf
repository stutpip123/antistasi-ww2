#define VEH                 0
#define HELI                1
#define PLANE               2
#define MORTAR              3
#define STATIC              4
#define BUILDING            5

params ["_marker", "_type", ["_distance", -1]];

private _fileName = "findSpawnPosition";
private _result = -1;
private _markerPos = getMarkerPos _marker;

[3, format ["Searching spawn position on %1 for %2", _marker, _type], _fileName] call A3A_fnc_log;
_spawns = spawner getVariable [format ["%1_spawns", _marker], -1];
if(_spawns isEqualType -1) exitWith
{
    [
        1,
        format ["%1 does not have any spawn positions set!", _marker],
        _fileName
    ] call A3A_fnc_log;
    _result;
};

private _selection = -1;
private _unitCount = -1;
switch (_type) do
{
    case ("Squad") :
    {
        _selection = BUILDING;
        _unitCount = 8;
    };
    case ("Group"):
    {
        _selection = BUILDING;
        _unitCount = 4;
    };
    case ("Vehicle"):
    {
        _selection = VEH;
    };
    case ("Heli"):
    {
        _selection = HELI;
    };
    case ("Plane"):
    {
        _selection = PLANE;
    };
    case ("Mortar"):
    {
        _selection = MORTAR;
    };
    case ("Static"):
    {
        _selection = STATIC;
    };
};

if (_selection == -1) exitWith
{
    [
        1,
        format ["Bad parameter recieved, was %1", _type],
        _fileName
    ] call A3A_fnc_log;
    _result;
};

private _possible = [];
if(_selection != BUILDING) then
{
    _possible = (_spawns select _selection) select {!(_x select 1)};
}
else
{
    _possible = (_spawns select _selection) select {(!(_x select 1)) && {((_x select 0) select 1) >= _unitCount}};
};

if(_distance != -1) then
{
    _possible = _possible select {((_x select 0 select 0) distance2D _markerPos) <= _distance};
};

if(count _possible > 0) then
{
  _result = selectRandom _possible;
  _index = (_spawns select _selection) findIf {_x isEqualTo _result};
  //diag_log format ["Result is %1, Index is %2", _result, _index];
  ((_spawns select _selection) select _index) set [1, true];

  _result = _result select 0;
};

[
    3,
    format ["Search for %1 place on %2 resulted in %3place found",_type, _marker, if(_result isEqualType 1) then {"no "} else {""}],
    _fileName
] call A3A_fnc_log;
_result;
