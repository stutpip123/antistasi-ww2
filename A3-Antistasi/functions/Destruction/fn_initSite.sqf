params ["_markerArray"];

private _fileName = "initSite";
private _debugTime = time;

{
    [_x] call A3A_fnc_initMarkerBuildings;
} forEach resourcesX + factories;

private _timeDiff = time - _debugTime;
[2, format ["Destruction buildings done in %1", _timeDiff], _fileName] call A3A_fnc_log;
