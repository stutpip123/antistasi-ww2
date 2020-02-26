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

[2, format ["Starting cyclic spawn of %1", _marker], _fileName] call A3A_fnc_log;

private _garrison = [_marker] call A3A_fnc_getGarrison;
private _locked = garrison getVariable (format ["%1_locked", _marker]);
private _garCount = [_garrison, true] call A3A_fnc_countGarrison;
private _patrolSize = [_patrolMarker] call A3A_fnc_calculateMarkerArea;

[3, format ["Logging units of %1", _marker], _fileName] call A3A_fnc_log;
[_garrison, "Garrison"] call A3A_fnc_logArray;

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


private _over = [_marker] call A3A_fnc_getOver;
[_over, "OverUnits"] call A3A_fnc_logArray;
_garCount = _garCount + ([_over, true] call A3A_fnc_countGarrison);

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
    _garCount = _garCount + 1;
    _allVehicles pushBack _static;
    if (_side == teamPlayer) then
    {
        //Get one unit in here
    };
} forEach _statics;
_staticGroup deleteGroupWhenEmpty true;

private _patrols = garrison getVariable [format ["%1_patrols", _marker], []];
{
    private _patrolGroup = _x;
    private _patrolGroupIndex = _forEachIndex;
    private _unitIndex = 0;
    private _patrolUnitOne = _patrolGroup select 0;
    private _patrolUnitTwo = _patrolGroup select 1;
    private _group = grpNull;
    if([_patrolUnitOne select 1] call A3A_fnc_unitAvailable) then
    {
        _group = createGroup _side;
        _unitIndex = _patrolGroupIndex * 10;
        [_patrolUnitOne select 0, _group, _marker, _unitIndex] call A3A_fnc_cycleSpawnPatrolUnit;
    };
    if([_patrolUnitTwo select 1] call A3A_fnc_unitAvailable) then
    {
        if(isNull _group) then
        {
            _group = createGroup _side;
        };
        _unitIndex = _patrolGroupIndex * 10 + 1;
        [_patrolUnitTwo select 0, _group, _marker, _unitIndex] call A3A_fnc_cycleSpawnPatrolUnit;
    };
    if !(isNull _group) then
    {
        _group deleteGroupWhenEmpty true;
        _garCount = _garCount + (count (units _group));
        [leader _group, _patrolMarker, "SAFE", "SPAWNED", "RANDOM", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
        sleep 0.25;
    };
} forEach _patrols;

//Units spawned, fixing marker size

private _sizePerUnit = 0;
if(_garCount != 0) then
{
  _sizePerUnit = _patrolSize / _garCount;
};

[
    3,
    format ["The size is %1, Unit count is %2, Per Unit is %3", _patrolSize, _garCount, _sizePerUnit],
    _fileName
] call A3A_fnc_log;

//Every unit can search a area of 12500 m^2, if the area is bigger, reduce patrol area
private _patrolMarkerSize = getMarkerSize _patrolMarker;
if(_sizePerUnit > 12500) then
{
    [3, "Patrol area is to large, make it smaller", _fileName] call A3A_fnc_log;
    _patrolMarkerSize set [0, (_patrolMarkerSize select 0) * (12500/_sizePerUnit)];
    _patrolMarkerSize set [1, (_patrolMarkerSize select 1) * (12500/_sizePerUnit)];
};

private _mainMarkerSize = getMarkerSize _marker;
if(((_patrolMarkerSize select 0) < (_mainMarkerSize select 0)) || {(_patrolMarkerSize select 1) < (_mainMarkerSize select 1)}) then
{
  [3, "Resizing to marker size", _fileName] call A3A_fnc_log;
  _patrolMarkerSize = _mainMarkerSize;
};
_patrolMarker setMarkerSizeLocal _patrolMarkerSize;

garrison setVariable [format ["%1_groups", _marker], _allGroups, true];
garrison setVariable [format ["%1_vehicles", _marker], _allVehicles, true];

[_marker] spawn A3A_fnc_markerAlert;

//Units fully spawned in, awaiting despawn
waitUntil
{
    sleep 10;
    private _spawners = allPlayers;
    private _blufor = [];
    private _redfor = [];
    private _greenfor = [];
    {
        switch (side (group _x)) do
        {
            case (Occupants):
            {
                _blufor pushBack _x;
            };
            case (Invaders):
            {
                _redfor pushBack _x;
            };
            case (teamPlayer):
            {
                _greenfor pushBack _x;
            };
        };
    } forEach _spawners;
    private _needsSpawn = [_marker, _blufor, _redfor, _greenfor, true] call A3A_fnc_needsSpawn;
    private _markerState = spawner getVariable _marker;
    if(_markerState != _needsSpawn) then
    {
        if((_markerState == SPAWNED) && (_needsSpawn == ON_STANDBY)) then
        {
            //Enemy to far away, disable AI for now
            {
                {
                    _x enableSimulationGlobal false;
                } forEach (units _x);
            } forEach _allGroups;
        };
        if((_markerState == ON_STANDBY) && (_needsSpawn == SPAWNED)) then
        {
            //Enemy is closing in activate AI for now
            {
                {
                    _x enableSimulationGlobal true;
                } forEach (units _x);
            } forEach _allGroups;
        };
        spawner setVariable [_marker, _needsSpawn, true];
    };
    (_needsSpawn == DESPAWNED)
};

[_marker] call A3A_fnc_freeSpawnPositions;

deleteMarker _patrolMarker;

{
	[_x] spawn A3A_fnc_groupDespawner;
} forEach (garrison getVariable (format ["%1_groups", _marker]));

private _playerStatics = [];
//Might have changed during runtime
_side = sidesX getVariable [_marker, sideUnknown];
private _vehicles = garrison getVariable (format ["%1_vehicles", _marker]);
if(_side == teamPlayer) then
{
    {
        if(_x isKindOf "StaticWeapon" && {alive _x && {(getPos _x) in _marker}) then
        {
            _vehicles pushBackUnique _x;
            _playerStatics pushBack [[getPosATL _x, getDir _x, typeOf _x], -1];
        };
    } forEach vehicles;
};
{
    if(!(_x getVariable ["Stolen", false])) then
    {
        deleteVehicle _x;
    };
} forEach _vehicles;
if(_side == teamPlayer) then
{
    garrison setVariable [format ["%1_statics", _marker], _playerStatics, true];
};
