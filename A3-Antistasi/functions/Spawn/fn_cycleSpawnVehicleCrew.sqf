params ["_marker", "_side", "_crewArray", "_groupIndex", "_vehicleGroup", "_vehicle", "_isOver"];

private _crewCount = {_x != ""} count _crewArray;

if(_crewCount == 0) exitWith
{
    _vehicleGroup;
};

private _spawnParameter = [_marker, _crewCount, _vehicle] call A3A_fnc_createSpawnPlacementForGroup;

private _animType = "NONE";
private _placeInVehicle = false;
if((_spawnParameter select 0) isEqualType -1) then
{
    _placeInVehicle = [_vehicle] call A3A_fnc_isCombatVehicle;
    _spawnParameter = [];
    {
        _spawnParameter pushBack [getMarkerPos _marker, 0];
    } forEach _crewArray;
}
else
{
    _animType = _spawnParameter select 1;
    _spawnParameter = _spawnParameter select 0;
};

if(_vehicleGroup == grpNull) then
{
    _vehicleGroup = createGroup _side;
};

{
    private _unit = [_marker, _x, _groupIndex, _vehicleGroup, _spawnParameter select _forEachIndex, _isOver] call A3A_fnc_cycleSpawnUnit;
    if(_placeInVehicle && {!(isNull _vehicle) && {!(_marker in controlsX)}}) then
    {
        _vehicleGroup setVariable ["isInVehicle", true, true];
        _unit moveInAny _vehicle;
    };
    if(_marker in controlsX || {_marker in outpostsFIA}) then
    {
        _unit moveInGunner _vehicle;
    };
    sleep 0.25;
} forEach (_crewArray select {_x != ""});

//This parameter will avoid upsmon in case of wakeup, upsmon will be applied once they have entered the vehicle
_vehicleGroup setVariable ["isCrewGroup", true, true];

//Parameter to check if the crew should move into the vehicle (aka is vehicle fit for combat)
_vehicleGroup setVariable ["shouldCrewVehicle", [_vehicleGroup] call A3A_fnc_shouldVehicleBeManned, true];

if(_placeInVehicle && {(isNull _vehicle)}) then
{
    [leader _vehicleGroup, _marker, "SAFE", "SPAWNED", "RANDOM", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
}
else
{
    [_vehicleGroup, _animType] call A3A_fnc_startAmbientAnims;
};

_vehicleGroup;
