params
[
    ["_marker", "", [""]],
    ["_vehicle", "", [""]]
];

/*  Spawns the given vehicle at the given marker, only works if the marker as spawn places defined, not recommended for planes

    Execution on: HC or Server

    Called by: call

    Params:
        _marker : STRING : The name of the marker, where the vehicle should be spawned in
        _vehicle : STRING : The configname of the vehicle, which should be spawned in

    Returns:
        OBJECT : The vehicle object, objNull if spawn wasnt possible
*/

private _fileName = "spawnVehicleAtMarker";
private _vehicleType = "Vehicle";

if(_vehicle == "" || _marker == "") exitWith
{
    [1, format ["Function called with bad input, was %1", _this], _fileName] call A3A_fnc_log;
    objNull;
};

//Determine vehicle type (there are some glitches with UAVs considered helicopters or drones considered planes)
if(_vehicle isKindOf "Air") then
{
    if (_vehicle isKindOf "Helicopter") then
    {
        _vehicleType = "Heli";
    }
    else
    {
        _vehicleType = "Plane";
    };
};

//Get the spawn place of the marker
private _spawnParams = [_marker, _vehicleType] call A3A_fnc_findSpawnPosition;
private _vehicleObj = objNull;

if(_spawnParams != -1) then
{
    //Place found spawn in vehicle now
    _vehicleObj = createVehicle [_vehicle, (_spawnParams select 0), [], 0, "CAN_COLLIDE"];
    _vehicleObj setDir (_spawnParams select 1);
};

_vehicleObj;
