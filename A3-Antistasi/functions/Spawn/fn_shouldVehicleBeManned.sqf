params ["_crewGroup"];

private _vehicle = assignedVehicle (leader _crewGroup);

//If vehicle is no combat vehicle, don't man
if !([_vehicle] call A3A_fnc_isCombatVehicle) exitWith
{
    false
};

//If the crew is not large enough to operate the vehicle, don't man
if((count (units _crewGroup)) < ([typeOf _vehicle, false] call BIS_fnc_crewCount)) exitWith
{
    false
};

true;
