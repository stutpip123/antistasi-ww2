/*
Function:
    Col_fnc_deserialiseAllVehicles

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
    ["_serialisation",[],[ [] ]],
    ["_meta",objNull, [objNull]]
];
private _filename = "fn_deserialiseAllVehicles";

private _object = objNull;
try {
    private _metaSearch = +_meta;
    private _metaSerSearch = +(_serialisation#0);

    private _physXDataRef       = [_metaSearch,"physXDataRef",      [_metaSerSearch,"physXDataRef", [0,0,0] ] call Col_fnc_map_remGet] call Col_fnc_map_remGet;  // Meta idea is WIP
    private _usePositionAGL     = [_metaSearch,"usePositionAGL",    [_metaSerSearch,"usePositionAGL",   false   ] call Col_fnc_map_remGet] call Col_fnc_map_remGet;
    private _noVelocity         = [_metaSearch,"noVelocity",        [_metaSerSearch,"noVelocity",       false   ] call Col_fnc_map_remGet] call Col_fnc_map_remGet;
    private _flattenDirection   = [_metaSearch,"flattenDirection",  [_metaSerSearch,"flattenDirection",    false   ] call Col_fnc_map_remGet] call Col_fnc_map_remGet;

    private _attributes = +(_serialisation#1);
    private _type               = [_attributes,"type",""                            ] call Col_fnc_map_remGet;
    private _physXData          = [_attributes,"physXData",[]                       ] call Col_fnc_map_remGet;
    private _vehicleCustomization=[_attributes,"vehicleCustomization",[]            ] call Col_fnc_map_remGet;
    private _damage             = [_attributes,"damage",0                           ] call Col_fnc_map_remGet;
    private _allHitPointsDamage = [_attributes,"allHitPointsDamage",[]              ] call Col_fnc_map_remGet;
    private _fuel               = [_attributes,"fuel",1                             ] call Col_fnc_map_remGet;
    private _fuelCargo          = [_attributes,"fuelCargo",1                        ] call Col_fnc_map_remGet;
    private _ammoCargo          = [_attributes,"ammoCargo",1                        ] call Col_fnc_map_remGet;
    private _repairCargo        = [_attributes,"repairCargo",1                      ] call Col_fnc_map_remGet;
    private _allPylonMagazines  = [_attributes,"allPylonMagazines",[]               ] call Col_fnc_map_remGet;
    private _turretsWeapons     = [_attributes,"turretsWeapons",[]                  ] call Col_fnc_map_remGet;
    private _forcedFlagTexture  = [_attributes,"forcedFlagTexture",""               ] call Col_fnc_map_remGet;
    private _flagTexture        = [_attributes,"flagTexture",""                     ] call Col_fnc_map_remGet;
    private _engineOn           = [_attributes,"engineOn",""                        ] call Col_fnc_map_remGet;
    private _collisionLightOn   = [_attributes,"collisionLightOn",""                ] call Col_fnc_map_remGet;
    private _damageAllowed      = [_attributes,"damageAllowed",""                   ] call Col_fnc_map_remGet;
    private _simulationEnable   = [_attributes,"simulationEnable",""                ] call Col_fnc_map_remGet;
    private _objectHidden       = [_attributes,"objectHidden",""                    ] call Col_fnc_map_remGet;


    _object = createVehicle [_type, [0,0,1000], [], 0, "CAN_COLLIDE"];
    if (isNull _object) then {throw ["InvalidObjectClassName",["""",_type,""" does not exit or failed creation."] joinString ""]};
    _object setVariable ["BIS_enableRandomization", false];
    // PhysX
    [_object,_physXData,_physXDataRef] call Col_fnc_setObjPhysX;
    if (_flattenDirection) then {
        private _vectorDirAndUp = [vectorDir _object, vectorUp _object];
        _vectorDirAndUp = [[_vectorDirAndUp#0,_vectorDirAndUp#1,0],[0,0,0]];
        _object setVectorDirAndUp _vectorDirAndUp;
    };
    if (_noVelocity) then {
        _object setVelocity [0,0,0];
    };
    // Details
    [_object, _vehicleCustomization#0, _vehicleCustomization#1, false] call BIS_fnc_initVehicle;
    _object setDamage _damage;
    for "_i" from 0 to (count (_allHitPointsDamage#1)) -1 do {
        _object setHit [_allHitPointsDamage#1#_i, _allHitPointsDamage#2#_i, false];  // _allHitPointsDamage = <<ARRAY>hit classnames,<ARRAY>hit selection names,<ARRAY>damage>
    };
    _object setFuel _fuel;
    _object setFuelCargo _fuelCargo;
    _object setAmmoCargo _ammoCargo;
    _object setRepairCargo _repairCargo;
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
    _object forceFlagTexture _forcedFlagTexture;
    _object setFlagTexture _flagTexture;
    _object engineOn _engineOn;
    _object setCollisionLight _collisionLightOn;
    _object allowDamage _damageAllowed;
    _object enableSimulation _simulationEnable;
    _object hideObjectGlobal _objectHidden;
    // Inventory
    // Attached Objects
    // Sling Load
    // Crew
    // VehicleCargo


} catch {
    [1, _exception joinString " | ", _filename] remoteExecCall ["A3A_fnc_log",2,false];
    if !(isNull _object) then {
        deleteVehicle _object;
    };
    _object = objNull;
};
_object;
