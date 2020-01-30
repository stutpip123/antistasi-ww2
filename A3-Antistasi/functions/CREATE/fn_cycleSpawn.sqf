#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

params ["_marker", "_patrolMarker", "_flag", "_box"];

private _fileName = "cycleSpawn";
if(isNil "_marker") exitWith
{
    [2, "No marker given, cannot spawn site", _fileName] call A3A_fnc_log;
};

private _side = sidesX getVariable [_marker, sideUnknown];
if(_side == sideUnknown) exitWith
{
    [2, format ["Could not retrieve side for %1", _marker], _fileName] call A3A_fnc_log;
};

[3, format ["Starting cyclic spawn of %1", _marker], _fileName] call A3A_fnc_log;

private _garrison = [_marker] call A3A_fnc_getGarrison;
private _locked = garrison getVariable (format ["%1_locked", _marker]);
private _garCount = [_garrison, true] call A3A_fnc_countGarrison;
private _patrolSize = [_patrolMarker] call A3A_fnc_calculateMarkerArea;

[3, format ["Logging units of %1", _marker], _fileName] call A3A_fnc_log;
[_garrison, "Garrison"] call A3A_fnc_logArray;

private _allGroups = [];
private _allVehicles = [_flag, _box];
//TODO Search for buildings and safe the data

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
            _spawnParameter = getMarkerPos _marker;
        }
        else
        {
            _spawnParameter = getPos _vehicle;
        };

        {
            if(_x != "") then
            {
                [_marker, _x, _lineIndex, _vehicleGroup, _spawnParameter, false] call A3A_fnc_cycleSpawnUnit;
                sleep 0.25;
            };
        } forEach _crewArray;
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

/*
private _over = [_marker] call A3A_fnc_getOver;
_lineIndex = 0;
{
    _lineIndex = _lineIndex + 1;
} forEach _over;
*/

private _staticGroup = createGroup _side;
_allGroups pushBack _staticGroup;
private _statics = garrison getVariable (format ["%1_statics", _marker]);
[
    3,
    format ["Spawning in %1 statics on %2", (count _statics), _marker],
    _fileName
] call A3A_fnc_log;

{
    private _data = _x;
    private _spawnParameter = _data select 1;
    private _allowedAt = _data select 0;
    private _currentTime = dateToNumber date;

    //Check if static has been killed and is not replenished by now
    if(_currentTime > _allowedAt) then
    {
        if(_spawnParameter isEqualType -1) then
        {
            _spawnParameter = [_marker, "Static"] call A3A_fnc_findSpawnPosition;
        };

        private _spawnPos = _spawnParameter select 0;
        private _nearestBuilding = nearestObject [_spawnPos, "HouseBase"];

        [3, format ["nearestBuilding is %1", (typeOf _nearestBuilding)], _fileName] call A3A_fnc_log;

        if(!(_nearestBuilding isKindOf "Ruins")) then
        {
            private _staticType = _spawnParameter select 2;
            private _crew = if(_side == Occupants) then {staticCrewOccupants} else {staticCrewInvaders};
            private _static = "";
            switch (_staticType) do
            {
                case ("MG"):
                {
                    _static = if(_side == Occupants) then {NATOMG} else {CSATMG};
                };
                case ("AA"):
                {
                    _static = if(_side == Occupants) then {staticAAOccupants} else {staticAAInvaders};
                };
                case ("AT"):
                {
                    _static = if(_side == Occupants) then {staticATOccupants} else {staticATInvaders};
                };
            };
            private _staticObject = createVehicle [_static, _spawnPos, [], 0, "CAN_COLLIDE"];
            _staticObject setDir (_spawnParameter select 1);
            _allVehicles pushBack _staticObject;

            private _gunner =  _staticGroup createUnit [_crew, getMarkerPos _marker, [], 5, "NONE"];
            [_gunner, _marker] call A3A_fnc_NATOinit;
            _gunner moveInGunner _staticObject;
        };
    };
} forEach _statics;
_staticGroup deleteGroupWhenEmpty true;

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

[_marker, _allGroups] spawn A3A_fnc_markerAlert;

//Units fully spawned in, awaiting despawn
waitUntil
{
    sleep 10;
    private _spawners = allUnits select {_x getVariable ["spawner", false]};
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
} forEach _allGroups;

{
    deleteVehicle _x;
} forEach _allVehicles;
