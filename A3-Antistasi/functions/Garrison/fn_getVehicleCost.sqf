params ["_vehicleType"];

/*  Gets the point cost of a vehicle

    Execution on: All

    Scope: External

    Params:
        _vehicleType : STRING : The name of the vehicle

    Returns:
        _cost : NUMBER : The cost of the vehicle
*/

private _cost = 2;

if(_vehicleType in ([vehNATOTank, vehNATOAA, vehCSATTank, vehCSATAA] + vehNATOAttackHelis + vehCSATAttackHelis)) then
{
    _cost = 10;
}
else
{
    if(_vehicleType in [vehNATOPlane, vehNATOPlaneAA, vehCSATPlane, vehCSATPlaneAA]) then
    {
        _cost = 7;
    }
    else
    {
        if(_vehicleType in (vehNATOAPC + vehCSATAPC)) then
        {
            _cost = 5;
        };
    };
};

_cost;
