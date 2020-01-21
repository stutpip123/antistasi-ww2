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

            //TODO convert to switch and add statics and mortars
            if(_vehicleType isKindOf "LandVehicle") then
            {
                _spawnParameter = [_marker, "Vehicle"] call A3A_fnc_findSpawnPosition;
            }
            else
            {
                if(_vehicleType isKindOf "Helicopter" && {(_vehicleType != vehNATOUAVSmall) && (_vehicleType != vehCSATUAVSmall)}) then
                {
                    _spawnParameter = [_marker, "Heli"] call A3A_fnc_findSpawnPosition;
                }
                else
                {
                    if(_vehicleType isKindOf "Plane" || {(_vehicleType == vehNATOUAVSmall) || (_vehicleType == vehCSATUAVSmall)}) then
                    {
                        _spawnParameter = [_marker, "Plane"] call A3A_fnc_findSpawnPosition;
                    };
                };
            };


            if(_spawnParameter isEqualType []) then
            {
                _vehicle = createVehicle [_vehicleType, _spawnParameter select 0, [], 0 , "CAN_COLLIDE"];
                _allVehicles pushBack _vehicle;
                _vehicle allowDamage false;
                [_vehicle] spawn
                {
                    sleep 3;
                    (_this select 0) allowDamage true;
                };
                _vehicle setDir (_spawnParameter select 1);
                _vehicleGroup addVehicle _vehicle;

                //Should work as a local variable needs testing
                _vehicle setVariable ["UnitIndex", (_lineIndex * 10 + 0)];
                _vehicle setVariable ["UnitMarker", _marker];

                //On vehicle death, remove it from garrison
                _vehicle addEventHandler
                [
                    "Killed",
                    {
                        _vehicle = _this select 0;
                        _id = _vehicle getVariable "UnitIndex";
                        _marker = _vehicle getVariable "UnitMarker";
                        [_marker, typeOf _vehicle, _id] call A3A_fnc_addToRequested;
                    }
                ];

                //Lock the vehicle based on a chance and war level
                if(random 10 < tierWar) then
                {
                    _vehicle lock 2;
                };
                sleep 0.25;
            }
            else
            {
                [
                    1,
                    format ["Unlocked vehicle has no place, vehicle: %1, marker: %2", _vehicleType, _marker],
                    _fileName
                ] call A3A_fnc_log;
            };
        };

        //Spawn in crew
        if(_vehicle == objNull) then
        {
            //Spawn near the marker, no vehicle for you to use
            _spawnParameter = [getMarkerPos _marker, 0];
        }
        else
        {
            _spawnParameter = [getPos _vehicle, 0];
        };

        //TODO write a function which can select a suitable spawn position, (buildings, vehicles and so on)
        //_spawnParameter = [_marker, NATOCrew] call A3A_fnc_findSpawnPosition;

        {
            if(_x != "") then
            {
                private _unitX = _vehicleGroup createUnit [_x, (_spawnParameter select 0), [], 5, "NONE"];
                //Should work as a local variable needs testing
                _unitX setVariable ["UnitIndex", (_lineIndex * 10 + 1)];
                _unitX setVariable ["UnitMarker", _marker];

                //On vehicle death, remove it from garrison
                _unitX addEventHandler
                [
                    "Killed",
                    {
                        _unitX = _this select 0;
                        _id = _unitX getVariable "UnitIndex";
                        _marker = _unitX getVariable "UnitMarker";
                        [_marker, typeOf _unitX, _id] call A3A_fnc_addRequested;
                    }
                ];
                sleep 0.25;
            };
        } forEach _crewArray;

        //No sure about the parameters, however this must not be merged before the vcom upgrade!!!
        //[leader _groupX, _marker, "SAFE", "RANDOMUP", "SPAWNED", "NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
    };

    private _groupSoldier = createGroup _side;
    _allGroups pushBack _groupSoldier;
    _spawnParameter = [getMarkerPos _marker, 0];
    {
        if(_x != "") then
        {
            private _unitX = _groupSoldier createUnit [_x, (_spawnParameter select 0), [], 5, "NONE"];

            //Should work as a local variable needs testing
            _unitX setVariable ["UnitIndex", (_lineIndex * 10 + 2)];
            _unitX setVariable ["UnitMarker", _marker];

            //On unit death, remove it from garrison
            _unitX addEventHandler
            [
                "Killed",
                {
                    _unitX = _this select 0;
                    _id = _unitX getVariable "UnitIndex";
                    _marker = _unitX getVariable "UnitMarker";
                    [_marker, typeOf _unitX, _id] call A3A_fnc_addRequested;
                }
            ];
            sleep 0.25;
        };
    } forEach _cargoArray;
    [leader _groupSoldier, _marker, "SAFE", "SPAWNED", "RANDOM", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
    _lineIndex = _lineIndex + 1;
} forEach _garrison;

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
