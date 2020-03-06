params ["_marker", "_side", "_crewArray", "_groupIndex", "_vehicleGroup", "_vehicle", "_isOver"];

private _crewCount = {_x != ""} count _crewArray;

if(_crewCount == 0) exitWith
{
    _vehicleGroup;
};

private _spawnParameter = [_marker, _crewCount, _vehicle] call A3A_fnc_createSpawnPlacementForGroup;

private _placeInVehicle = false;
if(_spawnParameter isEqualType -1) then
{
    _placeInVehicle = true;
    _spawnParameter = [];
    {
        _spawnParameter pushBack [getMarkerPos _marker, 0];
    } forEach _crewArray;
};

if(_vehicleGroup == grpNull) then
{
    _vehicleGroup = createGroup _side;
};

{
    private _unit = [_marker, _x, _groupIndex, _vehicleGroup, _spawnParameter select _forEachIndex, _isOver] call A3A_fnc_cycleSpawnUnit;
    if(_placeInVehicle && {!(isNull _vehicle)}) then
    {
        _unit moveInAny _vehicle;
    };
    sleep 0.25;
} forEach (_crewArray select {_x != ""});

if(_placeInVehicle && {(isNull _vehicle)}) then
{
    [leader _vehicleGroup, _marker, "SAFE", "SPAWNED", "RANDOM", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
};

_vehicleGroup;
