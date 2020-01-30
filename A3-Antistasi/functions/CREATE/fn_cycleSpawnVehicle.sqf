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
        if(_vehicleType isKindOf "Plane" || {(_vehicleType == vehNATOUAVSmall) || (_vehicleType == vehCSATUAVSmall)}) then
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

    //Should work as a local variable needs testing
    _vehicle setVariable ["UnitIndex", (_lineIndex * 10 + 0)];
    _vehicle setVariable ["UnitMarker", _marker];
    _vehicle setVariable ["IsOver", _isOver];

    //On vehicle death, remove it from garrison
    _vehicle addEventHandler
    [
        "Killed",
        {
            private _vehicle = _this select 0;
            private _id = _vehicle getVariable "UnitIndex";
            private _marker = _vehicle getVariable "UnitMarker";
            private _isOver = _vehicle getVariable "IsOver";
            if(_isOver) then
            {
                [_marker, typeOf _vehicle, _id] call A3A_fnc_removeFromOver;
            }
            else
            {
                [_marker, typeOf _vehicle, _id] call A3A_fnc_addToRequested;
            };
        }
    ];
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
