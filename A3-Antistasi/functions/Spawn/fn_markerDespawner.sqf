#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

params ["_marker", ["_patrolMarker", ""]];

/*  Handles the despawn of any marker

    Execution on: Server or HC

    Scope: Internal

    Params:
        _marker: STRING : The name of the marker which despawn should be handled
        _patrolMarker: STRING : The name of the marker which marks the patrol area around the _marker

    Returns:
        Nothing
*/

private _fileName = "markerDespawner";
private _allGroups = [];
private _allVehicles = [];

waitUntil
{
    sleep 10;
    _allGroups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
    _allVehicles = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
    private _needsSpawn = [_marker, true] call A3A_fnc_needsSpawn;
    private _markerState = spawner getVariable _marker;
    if(_markerState != _needsSpawn) then
    {
        if((_markerState == SPAWNED) && (_needsSpawn == ON_STANDBY)) then
        {
            //Enemy to far away, disable AI for now
            {
                {
                    _x enableSimulationGlobal false;
                } forEach (units (_x select 0));
            } forEach _allGroups;
        };
        if((_markerState == ON_STANDBY) && (_needsSpawn == SPAWNED)) then
        {
            //Enemy is closing in activate AI for now
            {
                {
                    _x enableSimulationGlobal true;
                } forEach (units (_x select 0));
            } forEach _allGroups;
        };
        spawner setVariable [_marker, _needsSpawn, true];
    };
    (_needsSpawn == DESPAWNED)
};

[2, format ["Starting despawn progress of %1", _marker], _fileName, true] call A3A_fnc_log;
[3, format ["All groups: %1", _allGroups], _fileName, true] call A3A_fnc_log;
[3, format ["All vehicles: %1", _allVehicles], _fileName, true] call A3A_fnc_log;

if(sidesX getVariable [_marker, sideUnknown] == sideUnknown) exitWith
{
    //Destroyed roadblock or minefield, don't check for stuff
    {
    	[(_x select 0)] spawn A3A_fnc_groupDespawner;
    } forEach _allGroups;
    {
        deleteVehicle (_x select 0);
    } forEach _allVehicles;
};

[_marker, sidesX getVariable [_marker, sideUnknown]] call A3A_fnc_zoneCheck;
[_marker] call A3A_fnc_freeSpawnPositions;

deleteMarker _patrolMarker;

{
	[(_x select 0)] spawn A3A_fnc_groupDespawner;
} forEach _allGroups;

private _side = sidesX getVariable _marker;
private _staticArray = [];
{
    if(_side == teamPlayer && {((_x select 1) select 0) == 12}) then
    {
        private _staticMarker = [(_x select 0)] call A3A_fnc_isStaticWeaponOnMarker;
        if(_staticMarker == _marker && {alive (_x select 0)}) then
        {
            //Update positions here
            _staticArray pushBack [[getPosATL (_x select 0), getDir (_x select 0), typeOf (_x select 0)], -1];
        };
    };
    deleteVehicle (_x select 0);
} forEach _allVehicles;

if(_side == teamPlayer) then
{
    garrison setVariable [format ["%1_statics", _marker], _staticArray, true];
};

//Delete spawnedArrays
spawner setVariable [format ["%1_groups", _marker], nil, true];
spawner setVariable [format ["%1_vehicles", _marker], nil, true];
