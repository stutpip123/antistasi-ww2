#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

params ["_marker", "_patrolMarker", ["_allVehicles", []], ["_allGroups", []]];

private _fileName = "cycleSpawn";
if(isNil "_marker") exitWith
{
    [1, "No marker given, cannot spawn site", _fileName] call A3A_fnc_log;
};

private _side = sidesX getVariable [_marker, sideUnknown];
if(_side == sideUnknown) exitWith
{
    [1, format ["Could not retrieve side for %1", _marker], _fileName] call A3A_fnc_log;
};

[2, format ["Starting cyclic spawn of %1, side is %2", _marker, _side], _fileName] call A3A_fnc_log;

private _garrison = [_marker] call A3A_fnc_getGarrison;
private _over = [_marker] call A3A_fnc_getOver;
private _locked = garrison getVariable (format ["%1_locked", _marker]);

private _garCount = [_garrison + _over, true] call A3A_fnc_countGarrison;
[_marker, _patrolMarker, _garCount] call A3A_fnc_adaptMarkerSizeToUnitCount;



private _lineIndex = 0;
{
    private _vehicleType = _x select 0;
    private _crewArray = _x select 1;
    private _cargoArray = _x select 2;
    private _spawnParameter = [];

    //Check if this vehicle (if there) is locked
    if (!(_locked select _lineIndex)) then
    {
        private _vehicleGroup = createGroup _side;
        private _vehicle = objNull;
        _allGroups pushBack _vehicleGroup;

        if (_vehicleType != "") then
        {
            //Array got a vehicle, spawn it in
            _vehicle = [_marker, _vehicleType, _lineIndex, _vehicleGroup, false] call A3A_fnc_cycleSpawnVehicle;
            _allVehicles pushBack _vehicle;
            sleep 0.25;
        };

        //Spawn in crew
        if(_vehicle == objNull) then
        {
            //Spawn near the marker, no vehicle for you to use
            _spawnParameter = [getMarkerPos _marker, random 25, random 360] call BIS_fnc_relPos;
        }
        else
        {
            _spawnParameter = [getPos _vehicle, random 25, random 360] call BIS_fnc_relPos;
        };

        {
            if(_x != "") then
            {
                [_marker, _x, _lineIndex, _vehicleGroup, _spawnParameter, false] call A3A_fnc_cycleSpawnUnit;
                sleep 0.25;
            };
        } forEach _crewArray;

        if((random 100) < (7.5 * tierWar)) then
        {
            {
                _x moveInAny (assignedVehicle _x);
            } forEach (units _vehicleGroup);
        };
    }
    else
    {
        [
            3,
            format ["Cannot spawn in %1 as vehicle is locked!", _vehicleType],
            _fileName
        ] call A3A_fnc_log;
    };

    private _groupSoldier = createGroup _side;
    _allGroups pushBack _groupSoldier;
    _spawnParameter = getMarkerPos _marker;
    {
        if(_x != "") then
        {
            [_marker, _x, _lineIndex, _groupSoldier, _spawnParameter, false] call A3A_fnc_cycleSpawnUnit;
            sleep 0.25;
        };
    } forEach _cargoArray;
    _groupSoldier deleteGroupWhenEmpty true;
    [leader _groupSoldier, _marker, "SAFE", "SPAWNED", "RANDOM", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
    _lineIndex = _lineIndex + 1;
} forEach _garrison;

_lineIndex = 0;
{
    private _vehicleType = _x select 0;
    private _crewArray = _x select 1;
    private _cargoArray = _x select 2;
    private _spawnParameter = [];

    private _vehicleGroup = createGroup _side;
    private _vehicle = objNull;
    _allGroups pushBack _vehicleGroup;

    if (_vehicleType != "") then
    {
        //Array got a vehicle, spawn it in
        _vehicle = [_marker, _vehicleType, _lineIndex, _vehicleGroup, true] call A3A_fnc_cycleSpawnVehicle;
        _allVehicles pushBack _vehicle;
        sleep 0.25;
    };

    //Spawn in crew
    if(_vehicle == objNull) then
    {
        //Spawn near the marker, no vehicle for you to use
        _spawnParameter = getMarkerPos _marker;
    }
    else
    {
        _spawnParameter = getPos _vehicle;
    };

    {
        if(_x != "") then
        {
            [_marker, _x, _lineIndex, _vehicleGroup, _spawnParameter, true] call A3A_fnc_cycleSpawnUnit;
            sleep 0.25;
        };
    } forEach _crewArray;

    private _groupSoldier = createGroup _side;
    _allGroups pushBack _groupSoldier;
    _spawnParameter = getMarkerPos _marker;
    {
        if(_x != "") then
        {
            [_marker, _x, _lineIndex, _groupSoldier, _spawnParameter, true] call A3A_fnc_cycleSpawnUnit;
            sleep 0.25;
        };
    } forEach _cargoArray;
    _groupSoldier deleteGroupWhenEmpty true;
    [leader _groupSoldier, _marker, "SAFE", "SPAWNED", "RANDOM", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
    _lineIndex = _lineIndex + 1;
} forEach _over;


private _staticGroup = createGroup _side;
_allGroups pushBack _staticGroup;
private _statics = garrison getVariable [format ["%1_statics", _marker], []];
[
    3,
    format ["Spawning in %1 statics on %2, data is %3", (count _statics), _marker, _statics],
    _fileName
] call A3A_fnc_log;

{
    private _static = [_marker, _staticGroup, _x select 0, _x select 1, _forEachIndex] call A3A_fnc_cycleSpawnStatic;
    _allVehicles pushBack _static;
    if (_side == teamPlayer) then
    {
        //Get one unit in here
    };
} forEach _statics;
_staticGroup deleteGroupWhenEmpty true;

//Spawning in patrol units around the marker
private _patrols = [_marker] call A3A_fnc_getPatrols;
{
    private _group = [_side, _marker, _x, _forEachIndex, _patrolMarker] call A3A_fnc_cycleSpawnPatrol;
    if !(_group isEqualTo grpNull) then
    {
        _allGroups pushBack _group;
    };
} forEach _patrols;
//End of patrol spawning

//Saving all groups and vehicles to the spawnedArrays
spawner setVariable [format ["%1_groups", _marker], _allGroups, true];
spawner setVariable [format ["%1_vehicles", _marker], _allVehicles, true];

//Handling the alert state and the despawn
[_marker] spawn A3A_fnc_markerAlert;
[_marker, _patrolMarker] spawn A3A_fnc_markerDespawner;
