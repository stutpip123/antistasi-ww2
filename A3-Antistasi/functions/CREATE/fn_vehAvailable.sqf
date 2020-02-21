params ["_type"];

/*  Checks if the given vehicle type is currently available
*   Params:
*       _type : STRING : Configname of the vehicle
*
*   Returns:
*       true if vehicle is available, false otherwise
*/

//No vehicle give, return false
if (_type == "") exitWith {false};
//Vehicle always free
if ((_type in [vehCSATPatrolHeli,vehNATOPatrolHeli,vehCSATRBoat,vehNATORBoat]) or (_type in vehCSATTrucks) or (_type in vehNATOTrucks) or (_type in vehNATOCargoTrucks)) exitWith {true};
//Checking server for the available amount
private _availableAmount = timer getVariable _type;
//None set, always free
if (isNil "_availableAmount") exitWith {true};
//None available, return false
if (_availableAmount <= 1) exitWith {false};
//Check if the max amount is already in use
if ({typeOf _x == _type} count vehicles >= (floor _availableAmount)) exitWith {false};
//Nothing to block it, return true
true;
