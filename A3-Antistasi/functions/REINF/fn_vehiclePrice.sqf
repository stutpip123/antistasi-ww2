params ["_vehicleType"];

/*  Returns the price of the given vehicle
*   Params:
*       _vehicleType : STRING : Config name of the vehicle
*
*   Returns:
*       _costs : NUMBER : The price of the vehicle, 0 if no price set
*/

private _costs = server getVariable _vehicleType;
if (isNil "_costs") then
{
    [
        1,
        format ["Vehicle type has no price set, type was %1" ,_vehicleType],
        "vehiclePrice"
    ] call A3A_fnc_log;
	_costs = 0;
}
else
{
	_costs = round (_costs - (_costs * (0.1 * ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count seaports))));
};
_costs;
