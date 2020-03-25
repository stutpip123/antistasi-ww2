private _allMarker = allMapMarkers;
private _placementMarker = [];

airportsX = [];
spawnPoints = [];
resourcesX = [];
factories = [];
outposts = [];
seaports = [];
controlsX = [];
seaMarkers = [];
seaSpawn = [];
seaAttackSpawn = [];
detectionAreas = [];
islands = [];
roadsMrk = [];

_fn_sortPlacementMarker =
{
    params ["_array", "_split"];

    //Calculating linked main marker
    private _mainMarkerName = "";
    switch (_split select 0) do
    {
        case ("airp"): {_mainMarkerName = "airport";};
        case ("outp"): {_mainMarkerName = "outpost";};
        case ("reso"): {_mainMarkerName = "resource";};
        case ("fact"): {_mainMarkerName = "factory";};
        case ("seap"): {_mainMarkerName = "seaport";};
    };

    private _number = parseNumber (_split select 1);
    private _start = 1;
    if(_number != 0) then
    {
        //There is no outpost_0 or something
        _start = 2;
        _mainMarkerName = format ["%1_%2", _mainMarkerName, _number];
    };

    //Build name
    private _name = _split select _start;
    for "_i" from (_start + 1) to ((count _split) - 1) do
    {
        _name = format ["%1_%2", _name, _split select _i];
    };

    //Seting connection
    private _index = _array findIf {(_x select 0) == _mainMarkerName};
    if(_index == -1) then
    {
        _array pushBack [_mainMarkerName, [_name]];
    }
    else
    {
        ((_array select _index) select 1) pushBack _name;
    };
};

_fn_addMarkerToList =
{
    params ["_array", "_marker"];
    private _index = _array findIf {(_x select 0) == _marker};
    if(_index == -1) then
    {
        _array pushBack [_marker, []];
    };
};

{
    _split = _x splitString "_";
    _start = _split select 0;
    switch (toLower _start) do
    {
        //Detect main marker
        case ("airport"): {airportsX pushBack _x; [_placementMarker, _x] call _fn_addMarkerToList;};
        case ("spawnpoint"): {spawnPoints pushBack _x;};
        case ("resource"): {resourcesX pushBack _x; [_placementMarker, _x] call _fn_addMarkerToList;};
        case ("factory"): {factories pushBack _x; [_placementMarker, _x] call _fn_addMarkerToList;};
        case ("outpost"): {outposts pushBack _x; [_placementMarker, _x] call _fn_addMarkerToList;};
        case ("seaport"): {seaports pushBack _x; [_placementMarker, _x] call _fn_addMarkerToList;};
        case ("control"): {controlsX pushBack _x;};
        case ("seapatrol"): {seaMarkers pushBack _x;};
        case ("seaspawn"): {seaSpawn pushBack _x;};
        case ("seaattackspawn"): {seaAttackSpawn pushBack _x;};
        case ("detectplayer"): {detectionAreas pushBack _x;};
        case ("island"): {islands pushBack _x;};
        case ("road"):
        {
            _x setMarkerAlpha 0;
            roadsMrk pushBack _x;
        };

        //Following marker are handled elsewhere
        case ("respawn");
        case ("dummyupsmonmarker");
        case ("nato");
        case ("csat");
        case ("synd"): {};

        //Detect placement marker
        case ("airp");
        case ("reso");
        case ("fact");
        case ("outp");
        case ("seap"): {[_placementMarker, _split] call _fn_sortPlacementMarker;};

        default
        {
            [1, format ["Could not resolve marker %1", _x], "prepareMarkerArrays"] call A3A_fnc_log;
        };
    };
} forEach _allMarker;

//diag_log "Marker setup done, placement marker are";
//[_placementMarker, "Placements"] call A3A_fnc_logArray;

{
    [_x select 0, _x select 1] call A3A_fnc_initSpawnPlaces;
} forEach _placementMarker;

//TEMPORARY FIX TO DETECT SPAWN MARKERS
{
  _nearestMarker = [spawnPoints, getMarkerPos _x] call BIS_fnc_nearestPosition;
  server setVariable [format ["spawn_%1", _x], _nearestMarker, true];
} forEach airportsX;
