/*
Function:
    A3A_fnc_deserialiseAllVehicles

Description:
    Converts serialisation into Object of type AllVehicles.

Environment:
    <SCHEDULED> Recommended, not required. Deserialisation process is resource heavy.

Parameters:
    <ARRAY> Serialisation of Object of type AllVehicles.

Returns:
    <Object> Object from CreateVehicle.

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_serialisation",[],[ [] ]]
];
private _filename = "fn_deserialiseAllVehicles";

private _object = objNull;
try {
    private _attributes = +_serialisation;

    private _type               = [_attributes,"type","C_Offroad_01_F"] call A3A_fnc_remKeyPair;
    private _mass               = [_attributes,"mass",nil] call A3A_fnc_remKeyPair;
    private _positionAGL        = [_attributes,"positionAGL",[0,0,0]] call A3A_fnc_remKeyPair;
    private _vectorDirAndUp     = [_attributes,"vectorDirAndUp",[[0,0,0],[0,0,0]]] call A3A_fnc_remKeyPair;
    private _velocity           = [_attributes,"velocity",[0,0,0]] call A3A_fnc_remKeyPair;
    private _vehicleCustomization     = [_attributes,"vehicleCustomization",[]] call A3A_fnc_remKeyPair;
    private _allHitPointsDamage = [_attributes,"allHitPointsDamage",[]] call A3A_fnc_remKeyPair;
    private _fuel = [_attributes,"fuel",[]] call A3A_fnc_remKeyPair;
    private _fuelCargo = [_attributes,"fuelCargo",[]] call A3A_fnc_remKeyPair;
    private _allPylonMagazines = [_attributes,"allPylonMagazines",[]] call A3A_fnc_remKeyPair;
    private _turretsWeapons = [_attributes,"turretsWeapons",[]] call A3A_fnc_remKeyPair;

    _object = createVehicle [_type, _positionAGL, [], 0, "CAN_COLLIDE"];
    if (isNull _object) then {throw ["InvalidObjectClassName",["""",_type,""" does not exit or failed creation."] joinString ""]};
    _object setVariable ["BIS_enableRandomization", false];
    // PhysX
    _object setMass _mass;
    _object setVectorDirAndUp _vectorDirAndUp;
    _object setVelocity _velocity;
    // Details
    [_object, _vehicleCustomization#0, _vehicleCustomization#1, false] call BIS_fnc_initVehicle;
    for "_i" from 0 to (count (_allHitPointsDamage#1)) -1 do {
        _object setHit [_allHitPointsDamage#1#_i, _allHitPointsDamage#2#_i, false];  // _allHitPointsDamage = <<ARRAY>hit classnames,<ARRAY>hit selection names,<ARRAY>damage>
    };
    _object setFuel _fuel;
    _object setFuelCargo _fuelCargo;
    {
        _object removeMagazineTurret [_x#0, _x#1];
    } forEach magazinesAllTurrets _object;
    {
        private _turretPath = _x;
        {
            _object removeWeaponTurret [_x,_turretPath]
        } forEach (_object weaponsTurret _turretPath);
    } forEach [[-1]] + (allTurrets _object);
    {  // NEEDS TO BE AFTER removeWeaponTurret
        _object setPylonLoadOut [_x#0, _x#1, true, _x#2];
        _object setAmmoOnPylon [_x#0, _x#3];
    } forEach _allPylonMagazines;  // _allPylonMagazines = <ARRAY<pylon, magazine, turret, ammo count>>
    {  // NEEDS TO BE AFTER removeWeaponTurret
        private _turretPath = _x#0;
        private _weapons = _x#1;
        private _magazines =  _x#2;
        {
           _object addWeaponTurret [_x,_turretPath];
        } forEach _weapons;
        {
           _object addMagazineTurret [_x#0,_turretPath,_x#1];
        } forEach _magazines;  // <ARRAY<magazineName, ammoCount>>
    } forEach _turretsWeapons;  //<ARRAY<turretPath,ARRAY<weapons>,<ARRAY<magazineName, ammoCount>>>>

} catch {
    [1, _exception joinString " | ", _filename] remoteExecCall ["A3A_fnc_log",2,false];
    if !(isNull _object) then {
        deleteVehicle _object;
    };
    _object = objNull;
};
_object;
