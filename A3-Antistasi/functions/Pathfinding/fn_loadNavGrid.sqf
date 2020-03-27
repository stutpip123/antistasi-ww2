private _deltaTime = time;
private _abort = false;
mainMarker = [];

private _worldName = worldName;
private _firstLetter = _worldName select [0,1];
private _remaining = _worldName select [1];
private _firstLetter = toUpper _firstLetter;
private _remaining = toLower _remaining;
private _worldName = format ["%1%2", _firstLetter, _remaining];

private _path = format ["Navigation\navGrid%1.sqf", _worldName];

try
{
    //Load in the nav grid array
    [] call compile preprocessFileLineNumbers _path;
}
catch
{
    //Stop launch of mission, road database is missing
    [1, format ["Road database could not be loaded, there is no file called %1!", _path], "loadNavGrid"] call A3A_fnc_log;
    _abort = true;
};

roadDataDone = true;
publicVariable "roadDataDone";

if(_abort) exitWith {};

private _worldSize = worldSize;
private _chunkSize = 1000; //1000 meters per marker
private _offset = _chunkSize / 2;

private _markerNeeded =  floor (_worldSize / _chunkSize) + 1;

{
    _x params ["_index", "_position"];
    private _mainMarkers = [_position] call A3A_fnc_getMainMarkers;
    {
        [_index, _x] call A3A_fnc_setNavOnMarker;
    } forEach _mainMarkers;
} forEach navGrid;

for "_i" from 0 to (_markerNeeded - 1) do
{
    for "_j" from 0 to (_markerNeeded - 1) do
    {
        private _markerPos = [_offset + _i * _chunkSize, _offset + _j * _chunkSize];
        private _marker = createMarker [format ["%1/%2", _i, _j], _markerPos];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "mil_circle";
        _marker setMarkerColor "ColorBlack";
        private _points = missionNamespace getVariable [(format ["%1/%2_data", _i, _j]), []];
        _marker setMarkerText (format ["%1/%2, NavPoints: %3", _i, _j, count _points]);
        _marker setMarkerAlpha 0;

        mainMarker pushBack _marker;
    };
};

_deltaTime = time - _deltaTime;
["Nav Grid", format ["Nav grid loaded in %1 seconds", _deltaTime]] call A3A_fnc_customHint;
