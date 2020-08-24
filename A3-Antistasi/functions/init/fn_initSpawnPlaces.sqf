params ["_marker", "_placementMarker"];

private _fileName = "initSpawnPlaces";

[3, format ["Initiating spawn places for %1 now", _marker], _fileName] call A3A_fnc_log;

private _vehicleMarker = [];
private _heliMarker = [];
private _hangarMarker = [];
private _mortarMarker = [];

//Calculating marker prefix
private _markerPrefix = "";
private _markerSplit = _marker splitString "_";
switch (_markerSplit select 0) do
{
    case ("airport"): {_markerPrefix = "airp_";};
    case ("outpost"): {_markerPrefix = "outp_";};
    case ("resource"): {_markerPrefix = "reso_";};
    case ("factory"): {_markerPrefix = "fact_";};
    case ("seaport"): {_markerPrefix = "seap_";};
};
//Fix marker name if it has a number after it
if(count _markerSplit > 1) then
{
    _markerPrefix = format ["%1%2_", _markerPrefix, _markerSplit select 1];
};

//Sort marker
private _mainMarkerPos = getMarkerPos _marker;
{
    private _first = (_x splitString "_") select 0;
    private _fullName = format ["%1%2", _markerPrefix, _x];
    if(_mainMarkerPos distance (getMarkerPos _fullName) > 500) then
    {
        [
            2,
            format ["Placementmarker %1 is more than 500 meter away from its mainMarker %2. You may want to check that!", _fullName, _marker],
            _fileName
        ] call A3A_fnc_log;
    };
    switch (_first) do
    {
        case ("vehicle"): {_vehicleMarker pushBack _fullName;};
        case ("helipad"): {_heliMarker pushBack _fullName;};
        case ("hangar"): {_hangarMarker pushBack _fullName;};
        case ("mortar"): {_mortarMarker pushBack _fullName;};
    };
    _fullName setMarkerAlpha 0;
} forEach _placementMarker;


private _markerSize = markerSize _marker;
private _distance = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));
private _buildings = nearestObjects [getMarkerPos _marker, listAllBuildings + ["Helipad_Base_F"], _distance, true];

//Sort helipads
private _heliSpawns = [_buildings, _marker, _heliMarker] call A3A_fnc_initSpawnPlacesHelipads;
_buildings = _heliSpawns select 0;
_heliSpawns = _heliSpawns select 1;

private _planeSpawns = [_buildings, _marker, _hangarMarker] call A3A_fnc_initSpawnPlacesHangars;
_buildings = _planeSpawns select 0;
_planeSpawns = _planeSpawns select 1;

private _staticSpawns = [_buildings, _marker, _mortarMarker] call A3A_fnc_initSpawnPlacesStatics;
private _mortarSpawns = _staticSpawns select 0;
_staticSpawns = _staticSpawns select 1;

private _vehicleSpawns = [_vehicleMarker] call A3A_fnc_initSpawnPlacesVehicles;

private _buildingSpawns = [_marker, _distance] call A3A_fnc_initSpawnPlacesBuildings;

private _spawns = [_vehicleSpawns, _heliSpawns, _planeSpawns, _mortarSpawns, _staticSpawns, _buildingSpawns];
private _spawnCounts = [count _vehicleSpawns, count _heliSpawns, count _planeSpawns, count _mortarSpawns, count _staticSpawns, count _buildingSpawns];

[
    3,
    format
    [
        "%1 can hold %2 ground vehicles, %3 helicopters, %4 airplanes, %5 mortars, %6 statics and %7 squads in buildings",
        _marker,
        _spawnCounts select 0,
        _spawnCounts select 1,
        _spawnCounts select 2,
        _spawnCounts select 3,
        _spawnCounts select 4,
        _spawnCounts select 5
    ],
     _fileName
] call A3A_fnc_log;

//Saving the spawn places
spawner setVariable [format ["%1_spawns", _marker], _spawns, true];

//Saving the amount of available places
spawner setVariable [format ["%1_available", _marker], _spawnCounts, true];

//Saving the currently stationed amount (init so 0 for all)
spawner setVariable [format ["%1_current", _marker], [0, 0, 0, 0, 0], true];
