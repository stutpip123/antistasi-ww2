params ["_preference", "_side"];

/*  Selects a fitting vehicle type based on given preference and side
*   Params:
*     _preference : STRING : The preferred vehicle type
*     _side : SIDE : The side of the vehicle
*
*   Returns:
*     _result : STRING : The typename of the selected vehicle
*/

private _fileName = "SelectVehicleType";

[3, format ["Selecting vehicle now, preferred is %1, side is %2", _preference, _side], _fileName] call A3A_fnc_log;

if(_preference == "LAND_AIR") exitWith
{
    if(_side == Occupants) then {vehNATOAA} else {vehCSATAA};
};
if(_preference == "LAND_TANK") exitWith
{
    if(_side == Occupants) then {vehNATOTank} else {vehCSATTank};
};
if(_preference == "LAND_ROADBLOCK") exitWith
{
    if !(hasIFA) then {vehFIAArmedCar} else {vehFIACar};
};

private _possibleVehicles = [];
if(_preference in ["EMPTY", "LAND_TRUCK", "HELI_PATROL", "AIR_DRONE"]) then
{
    _possibleVehicles pushBack "";
};
if(_preference in ["LAND_TRUCK", "LAND_START", "LAND_LIGHT_UNARMED"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles append vehNATOTrucks;
    }
    else
    {
        _possibleVehicles append vehCSATTrucks;
    };
};
if(_preference in ["LAND_START", "LAND_LIGHT_UNARMED", "LAND_LIGHT"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles append vehNATOLightUnarmed;
    }
    else
    {
        _possibleVehicles append vehCSATLightUnarmed;
    };
};
if(_preference in ["LAND_LIGHT", "LAND_LIGHT_ARMED", "LAND_MEDIUM"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles append vehNATOLightArmed;
    }
    else
    {
        _possibleVehicles append vehCSATLightArmed;
    };
};
if(_preference in ["LAND_MEDIUM", "LAND_APC", "LAND_HEAVY"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles append vehNATOAPC;
    }
    else
    {
        _possibleVehicles append vehCSATAPC;
    };
};
if(_preference in ["LAND_HEAVY"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles pushBack vehNATOTank;
    }
    else
    {
        _possibleVehicles pushBack vehCSATTank;
    };
};
if(_preference in ["HELI_PATROL", "HELI_LIGHT"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles pushBack vehNATOPatrolHeli;
    }
    else
    {
        _possibleVehicles pushBack vehCSATPatrolHeli;
    };
};
if(_preference in ["HELI_TRANSPORT", "HELI_HEAVY"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles append vehNATOTransportHelis;
    }
    else
    {
        _possibleVehicles append vehCSATTransportHelis;
    };
};
if(_preference in ["HELI_HEAVY", "HELI_ATTACK"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles append vehNATOAttackHelis;
    }
    else
    {
        _possibleVehicles append vehCSATAttackHelis;
    };
};
if(_preference in ["AIR_DRONE", "AIR_GENERIC"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles pushBack vehNATOUAV;
    }
    else
    {
        _possibleVehicles pushBack vehCSATUAV;
    };
};
if(_preference in ["AIR_GENERIC", "AIR_ATTACK"]) then
{
    if(_side == Occupants) then
    {
        _possibleVehicles append [vehNATOPlane, vehNATOPlaneAA];
    }
    else
    {
        _possibleVehicles append [vehCSATPlane, vehCSATPlaneAA];
    };
};

if(count _possibleVehicles == 0) exitWith
{
    [1, format ["No result for %1, assuming bad parameter!", _preference], _fileName] call A3A_fnc_log;
    "";
};

[3, format ["Preselection done, possible vehicles are %1", str _possibleVehicles], _fileName] call A3A_fnc_log;

private _result = selectRandom _possibleVehicles;

[3, format ["Result is %1", _result], _fileName] call A3A_fnc_log;
_result;
