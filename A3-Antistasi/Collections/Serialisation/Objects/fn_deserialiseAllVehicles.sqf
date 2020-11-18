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

    private _positionWorldRef   = [_metaSearch,"positionWorldRef",  [_metaSerSearch,"positionWorldRef", [0,0,0] ] call Col_fnc_remKeyPair] call Col_fnc_remKeyPair;  // Meta idea is WIP
    private _vectorDirAndUpRef  = [_metaSearch,"vectorDirAndUpRef", [_metaSerSearch,"vectorDirAndUpRef",[[0,0,0],[0,0,0]] ] call Col_fnc_remKeyPair] call Col_fnc_remKeyPair;  // Currently only azimuth is factored in.
    private _usePositionAGL     = [_metaSearch,"usePositionAGL",    [_metaSerSearch,"usePositionAGL",   false   ] call Col_fnc_remKeyPair] call Col_fnc_remKeyPair;
    private _noVelocity         = [_metaSearch,"noVelocity",        [_metaSerSearch,"noVelocity",       false   ] call Col_fnc_remKeyPair] call Col_fnc_remKeyPair;
    private _flatDirection      = [_metaSearch,"flatDirection",     [_metaSerSearch,"flatDirection",    false   ] call Col_fnc_remKeyPair] call Col_fnc_remKeyPair;

    private _attributes = +(_serialisation#1);
    private _type               = [_attributes,"type",""                            ] call Col_fnc_remKeyPair;
    private _mass               = [_attributes,"mass",nil                           ] call Col_fnc_remKeyPair;
    private _positionWorld      = [_attributes,"positionWorld",[0,0,0]              ] call Col_fnc_remKeyPair;
    private _positionAGLZ       = [_attributes,"positionAGLZ",0                     ] call Col_fnc_remKeyPair;
    private _modelHeight        = [_attributes,"modelHeight",10                     ] call Col_fnc_remKeyPair;  // Safe number so that model does not clip into ground if problem with loading value.
    private _vectorDirAndUp     = [_attributes,"vectorDirAndUp",[[0,0,0],[0,0,0]]   ] call Col_fnc_remKeyPair;
    private _velocity           = [_attributes,"velocity",[0,0,0]                   ] call Col_fnc_remKeyPair;
    private _vehicleCustomization=[_attributes,"vehicleCustomization",[]            ] call Col_fnc_remKeyPair;
    private _damage             = [_attributes,"damage",0                           ] call Col_fnc_remKeyPair;
    private _allHitPointsDamage = [_attributes,"allHitPointsDamage",[]              ] call Col_fnc_remKeyPair;
    private _fuel               = [_attributes,"fuel",1                             ] call Col_fnc_remKeyPair;
    private _fuelCargo          = [_attributes,"fuelCargo",1                        ] call Col_fnc_remKeyPair;
    private _ammoCargo          = [_attributes,"ammoCargo",1                        ] call Col_fnc_remKeyPair;
    private _repairCargo        = [_attributes,"repairCargo",1                      ] call Col_fnc_remKeyPair;
    private _allPylonMagazines  = [_attributes,"allPylonMagazines",[]               ] call Col_fnc_remKeyPair;
    private _turretsWeapons     = [_attributes,"turretsWeapons",[]                  ] call Col_fnc_remKeyPair;
    private _forcedFlagTexture  = [_attributes,"forcedFlagTexture",""               ] call Col_fnc_remKeyPair;
    private _flagTexture        = [_attributes,"flagTexture",""                     ] call Col_fnc_remKeyPair;
    private _engineOn           = [_attributes,"engineOn",""                        ] call Col_fnc_remKeyPair;
    private _collisionLightOn   = [_attributes,"collisionLightOn",""                ] call Col_fnc_remKeyPair;
    private _damageAllowed      = [_attributes,"damageAllowed",""                   ] call Col_fnc_remKeyPair;
    private _simulationEnable   = [_attributes,"simulationEnable",""                ] call Col_fnc_remKeyPair;
    private _objectHidden       = [_attributes,"objectHidden",""                    ] call Col_fnc_remKeyPair;

    call {  // Limit scope of rotation, might move to a transformation function later.
        // Adjust Position
        private _rotDeg = -(_vectorDirAndUpRef#0#0) atan2 (_vectorDirAndUpRef#0#1);  // This was be converted to relative deg in deserialisation.
        private _rotationMatrix = [
            [cos _rotDeg, -sin _rotDeg],
            [sin _rotDeg, cos _rotDeg]
        ];
        private _pos2D = [
            [_positionWorld#0],  // _positionWorld reference was already subtracted.
            [_positionWorld#1]
        ];
        _pos2D = _rotationMatrix matrixMultiply _pos2D;     // Floating point errors are introduced here, of ~size 8e-008.
        _positionWorld = [_pos2D#0#0,_pos2D#1#0,_positionWorld#2];
        // Adjust Rotation
        private _dir = -(_vectorDirAndUp#0#0) atan2 (_vectorDirAndUp#0#1);
        _dir = _dir + _rotDeg;    // rotDeg is already negated
        _vectorDirAndUp set [0, [-sin _dir, cos _dir, _vectorDirAndUp#0#2]];
    };
    _positionWorld = _positionWorld vectorAdd _positionWorldRef;
    private _position = [];
    if (_usePositionAGL) then {
        _position = [_positionWorld#0,_positionWorld#1,_positionAGLZ]
    } else {
        _position = ASLToAGL [_positionWorld#0,_positionWorld#1,_positionWorld#2 - _modelHeight]
    };
    _object = createVehicle [_type, _position, [], 0, "CAN_COLLIDE"];
    if (isNull _object) then {throw ["InvalidObjectClassName",["""",_type,""" does not exit or failed creation."] joinString ""]};
    _object setVariable ["BIS_enableRandomization", false];
    // PhysX
    _object setMass _mass;
    if (_flatDirection) then {
        _vectorDirAndUp = [[_vectorDirAndUp#0,_vectorDirAndUp#1,0],[0,0,0]];
    };
    _object setVectorDirAndUp _vectorDirAndUp;
    if (!_noVelocity) then {
        _object setVelocity [_velocity];
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
