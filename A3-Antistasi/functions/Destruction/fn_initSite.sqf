params ["_markerArray"];

private _debugTime = time;

{
  [_x] spawn A3A_fnc_initMarkerBuildings;
} forEach resourcesX + factories;

private _timeDiff = time - _debugTime;
hint format ["Execution time was %1 seconds", _timeDiff];
