params ["_marker", "_vehicleType", "_lineIndex", "_group", "_isOver"];

/*  Spawns in the vehicle with the given parameters
*   Params:
*       _marker : STRING : The name of the marker the vehicle belongs to
*       _vehicleType : STRING : The config name of the vehicle class
*       _lineIndex : NUMBER : The number of the line the vehicle belongs to
*       _group : GROUP : The groups, the vehicle should be assigned to
*       _isOver : BOOLEAN : Determines if the vehicle is a over unit
*
*   Returns:
*       _vehicle : OBJECT : The gameobject of the vehicle
*/

private _spawnParameter = [];
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
        if((_vehicleType in vehNATOAttackHelis) || (_vehicleType in vehCSATAttackHelis) || (_vehicleType isKindOf "Plane") || {(_vehicleType == vehNATOUAVSmall) || (_vehicleType == vehCSATUAVSmall)}) then
        {
            _spawnParameter = [_marker, "Plane"] call A3A_fnc_findSpawnPosition;
        };
    };
};

private _vehicle = objNull;
if(_spawnParameter isEqualType []) then
{
    _vehicle = createVehicle [_vehicleType, (_spawnParameter select 0), [], 0 , "CAN_COLLIDE"];
    _vehicle allowDamage false;
    [_vehicle] spawn
    {
        sleep 3;
        (_this select 0) allowDamage true;
    };
    _vehicle setDir (_spawnParameter select 1);

    //Init vehicle on marker
    [_vehicle, _marker, _isOver, _lineIndex] call A3A_fnc_markerVehicleInit;

    //Add vehicle to group
    _group addVehicle _vehicle;

    //Lock the vehicle based on a chance and war level
    if(random 10 < tierWar) then
    {
        _vehicle lock 2;
    };
}
else
{
    if(!_isOver) then
    {
        [
            1,
            format ["Unlocked vehicle has no place, vehicle: %1, marker: %2", _vehicleType, _marker],
            _fileName
        ] call A3A_fnc_log;
    };
};

_vehicle;
