params ["_vehicleType", "_pos", "_dir", "_typeOfAttack", "_landPosBlacklist", "_side"];

/*  Creates a vehicle for a QRF or small attack, including crew and cargo

    Execution on: HC or Server

    Scope: Internal

    Parameters:
        _vehicleType: STRING : The name of the vehicle to spawn
        _pos: POSITION : The position around which the vehicle should be spawned in
        _dir: NUMBER : Direction of the vehicle (NOT YET USED AS THE SAFE SPAWN DOES NOT HANDLES IT YET)
        _typeOfAttack: STRING : The type of the attack
        _landPosBlacklist: ARRAY : List of blacklisted position
        _side: SIDE : The side of the attacker

    Returns:
        _vehicleData: ARRAY : [_vehicle, _crewGroup, _cargoGroup, _landPosBlacklist]
*/

private _fileName = "createAttackVehicle";

private _vehicle = [_vehicleType, _pos, 100, 5, true] call A3A_fnc_safeVehicleSpawn;
private _crewGroup = createVehicleCrew _vehicle;

{
    [_x] call A3A_fnc_NATOinit
} forEach (units _crewGroup);
[_vehicle, _side] call A3A_fnc_AIVEHinit;

private _cargoGroup = grpNull;
if ((([_vehicleType, true] call BIS_fnc_crewCount) - ([_vehicleType, false] call BIS_fnc_crewCount)) > 0) then
{
    //Vehicle is able to transport units
    private _groupType = if (_typeOfAttack == "Normal") then
    {
        [_vehicleType, _side] call A3A_fnc_cargoSeats;
    }
    else
    {
        if (_typeOfAttack == "Air") then
        {
            if (_side == Occupants) then {groupsNATOAA} else {groupsCSATAA}
        }
        else
        {
            if (_side == Occupants) then {groupsNATOAT} else {groupsCSATAT}
        };
    };
    _cargoGroup = [_posOrigin, _side, _groupType] call A3A_fnc_spawnGroup;
    {
        _x assignAsCargo _vehicle;
        _x moveInCargo _vehicle;
        if !(isNull objectParent _x) then
        {
            [_x] call A3A_fnc_NATOinit;
            _x setVariable ["originX", _markerOrigin];
        }
        else
        {
            deleteVehicle _x;
        };
    } forEach units _cargoGroup;
};

_landPosBlacklist = [_vehicle, _crewGroup, _cargoGroup, _posDestination, _markerOrigin, _landPosBlacklist] call A3A_fnc_createVehicleQRFBehaviour;
[3, format ["Created vehicle %1 with %2 soldiers", typeof _vehicle, count crew _vehicle], _filename] call A3A_fnc_log;

private _vehicleData = [_vehicle, _crewGroup, _cargoGroup, _landPosBlacklist];
_vehicleData;
