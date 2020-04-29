//Defines for group types to allow runtime groups joining and so on
#define GARRISON    10
#define OVER        11
#define STATIC      12
#define MORTAR      13
#define PATROL      14
#define OTHER       15

#define IS_CREW     false
#define IS_CARGO    true

params ["_marker", "_patrolMarker", ["_allVehicles", []], ["_allGroups", []]];

/*  Handles the unit spawn progress of any marker

    Execution on: HC or Server

    Scope: Internal

    Params:
        _marker: STRING : Name of the marker that should be spawned in
        _patrolMarker: STRING : Name of the patrol marker around the main marker
        _allVehicles: ARRAY of OBJECTS: (Optional) List of already spawned vehicles on the marker
        _allGroups: ARRAY of GROUPS: (Optional) List of already spawned groups on the marker

    Returns:
        Nothing
*/

private _fileName = "cycleSpawn";

private _side = sidesX getVariable [_marker, sideUnknown];
if(_side == sideUnknown) exitWith
{
    [1, format ["Could not retrieve side for %1", _marker], _fileName] call A3A_fnc_log;
};
[2, format ["Starting cyclic spawn of %1, side is %2", _marker, _side], _fileName] call A3A_fnc_log;

private _garrison = [_marker] call A3A_fnc_getGarrison;
[_garrison, format ["%1_garrison",_marker]] call A3A_fnc_logArray;
private _over = [_marker] call A3A_fnc_getOver;
[_over, format ["%1_over",_marker]] call A3A_fnc_logArray;
private _locked = garrison getVariable (format ["%1_locked", _marker]);

//Calculate patrol marker size
private _garCount = [_garrison + _over, true] call A3A_fnc_countGarrison;
[_marker, _patrolMarker, _garCount] call A3A_fnc_adaptMarkerSizeToUnitCount;

//Calculate adjustment for player size
private _activeRebelPlayer = count (allPlayers select {side (group _x) == teamPlayer});
private _adjustment = 1;
if(_side != teamPlayer) then
{
    if(_activeRebelPlayer < 20) then
    {
        if(_activeRebelPlayer < 1) then
        {
            [1, "No player detected for adjustment, assuming 0.35", _fileName, true] call A3A_fnc_log;
            _adjustment = 0.35;
        }
        else
        {
            _adjustment = (round (100 * (((ln _activeRebelPlayer) / 4.6088) + 0.35))) / 100;
        };
    };
};


[
    2,
    format ["Player adjustment done, spawning in %1 percent of the garrison of %2", _adjustment * 100, _marker],
    _fileName,
    true
] call A3A_fnc_log;

_fn_calculateRowCount =
{
    params ["_array", "_adjustment"];
    private _originalCount = (count _array) - 1;
    if(_originalCount != -1) then
    {
        _originalCount = round (_adjustment * _originalCount);
    };
    _originalCount;
};

//Spawn in the garrison units
private _garrisonMax = [_garrison, _adjustment] call _fn_calculateRowCount;
[
    2,
    format ["Spawning in %1 lines of the garrison for %2", (_garrisonMax + 1), _marker],
    _fileName,
    true
] call A3A_fnc_log;
for "_counter" from 0 to _garrisonMax do
{
    (_garrison select _counter) params ["_vehicleType", "_crewArray", "_cargoArray"];

    //Check if this vehicle (if there) is locked
    if (!(_locked select _counter)) then
    {
        private _vehicleGroup = grpNull;
        private _vehicle = objNull;

        if (_vehicleType != "") then
        {
            //Array got a vehicle, spawn it in
            _vehicleGroup = createGroup _side;
            _vehicle = [_marker, _vehicleType, _counter, _vehicleGroup, false] call A3A_fnc_cycleSpawnVehicle;
            _allVehicles pushBack [_vehicle, [GARRISON, _counter]];
            sleep 0.25;
        };

        _vehicleGroup = [_marker, _side, _crewArray, _counter, _vehicleGroup, _vehicle, false] call A3A_fnc_cycleSpawnVehicleCrew;
        if !(isNull _vehicleGroup) then
        {
            _allGroups pushBack [_vehicleGroup, [GARRISON, _counter, IS_CREW]];
        };
    };

    private _groupSoldier = [_side, _marker, _cargoArray, _counter, false] call A3A_fnc_cycleSpawnSoldierGroup;
    if !(isNull _groupSoldier) then
    {
        _allGroups pushBack [_groupSoldier, [GARRISON, _counter, IS_CARGO]];
    };
};

//Spawn in the over units
private _overMax = [_over, _adjustment] call _fn_calculateRowCount;
[
    2,
    format ["Spawning in %1 lines of the over units for %2", (_overMax + 1), _marker],
    _fileName,
    true
] call A3A_fnc_log;

for "_counter" from 0 to _overMax do
{
    (_over select _counter) params ["_vehicleType", "_crewArray", "_cargoArray"];

    private _vehicleGroup = grpNull;
    private _vehicle = objNull;

    if (_vehicleType != "") then
    {
        //Array got a vehicle, spawn it in
        _vehicleGroup = createGroup _side;
        _vehicle = [_marker, _vehicleType, _counter, _vehicleGroup, true] call A3A_fnc_cycleSpawnVehicle;
        _allVehicles pushBack [_vehicle, [OVER, _counter]];
        sleep 0.25;
    };

    _vehicleGroup = [_marker, _side, _crewArray, _counter, _vehicleGroup, _vehicle, true] call A3A_fnc_cycleSpawnVehicleCrew;
    if !(isNull _vehicleGroup) then
    {
        _allGroups pushBack [_vehicleGroup, [OVER, _counter, IS_CREW]];
    };

    private _groupSoldier = [_side, _marker, _cargoArray, _counter, true] call A3A_fnc_cycleSpawnSoldierGroup;
    if !(isNull _groupSoldier) then
    {
        _allGroups pushBack [_groupSoldier, [OVER, _counter, IS_CARGO]];
    };
};

//Spawn in statics of the marker
private _statics = garrison getVariable [format ["%1_statics", _marker], []];
private _staticGroup = grpNull;
{
    if(isNull _staticGroup) then
    {
        _staticGroup = createGroup _side;
        _allGroups pushBack [_staticGroup, [STATIC, 0, IS_CREW]];
    };
    private _static = [_marker, _staticGroup, _x select 0, _x select 1, _forEachIndex] call A3A_fnc_cycleSpawnStatic;
    _allVehicles pushBack [_static, [STATIC, -1]];
} forEach _statics;

//Spawn in mortars of the marker
private _mortars = garrison getVariable [format ["%1_mortars", _marker], []];
private _mortarGroup = grpNull;
{
    if(isNull _mortarGroup) then
    {
        _mortarGroup = createGroup _side;
        _allGroups pushBack [_mortarGroup, [MORTAR, 0, IS_CREW]];
    };
    private _mortar = [_marker, _mortarGroup, _x select 0, _x select 1, _forEachIndex] call A3A_fnc_cycleSpawnStatic;
    _allVehicles pushBack [_mortar, [STATIC, -1]];
} forEach _mortars;

//Spawning in patrol units around the marker
private _patrols = [_marker] call A3A_fnc_getPatrols;
[_patrols, format ["%1_patrols",_marker]] call A3A_fnc_logArray;
{
    private _group = [_side, _marker, _x, _forEachIndex, _patrolMarker] call A3A_fnc_cycleSpawnPatrol;
    if !(isNull _group) then
    {
        _allGroups pushBack [_group, [PATROL, _forEachIndex, IS_CARGO]];
    };
} forEach _patrols;

//Saving all groups and vehicles to the spawnedArrays
spawner setVariable [format ["%1_groups", _marker], _allGroups, true];
spawner setVariable [format ["%1_vehicles", _marker], _allVehicles, true];

//Manning the statics of the marker if teamPlayer (otherwise they are already manned)
if (_side == teamPlayer) then
{
    [_marker] call A3A_fnc_manStaticsOnSpawn;
};

//Handling the alert state and the despawn
[_marker] spawn A3A_fnc_markerAlert;
[_marker, _patrolMarker] spawn A3A_fnc_markerDespawner;
