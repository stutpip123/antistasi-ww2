/*
Function:
    Col_fnc_serialiseAllVehicles

Description:
    Converts Object of type AllVehicles into primitive array.

Environment:
    <SCHEDULED> Recommended, not required. Serialisation process is resource heavy.

Parameters:
    <OBJECT> Object of type AllVehicles.
    <ARRAY> Serialisation reference meta.

Returns:
    <ARRAY> Serialisation of Object of type AllVehicles;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_object",objNull,[objNull]],
    ["_meta",[],[ [] ]]
];
private _filename = "fn_serialiseAllVehicles";

private _serialisation = [];
try {
    private _metaSearch = +_meta;
    private _positionWorldRef   = [_metaSearch,"positionWorldRef",  [0,0,0]             ] call Col_fnc_remKeyPair;  // Meta idea is WIP
    private _vectorDirAndUpRef  = [_metaSearch,"vectorDirAndUpRef", [[0,0,0],[0,0,0]]   ] call Col_fnc_remKeyPair;  // Currently only azimuth is factored in.

    private _type = typeOf _object;
    // PhysX
    private _mass = getMass _object;
    private _positionWorld = (getPosWorld _object) vectorDiff _positionWorldRef;  // Because other position systems XY rely on an incorrect boundingBox/Model centre calculations.
    Private _positionAGLZ = ASLToAGL (getPosASL _object)#2;  // Not transformed by new XY pos of flat rotation because it represents the object on a flat plane, therefore a flat rotation makes no height difference.
    private _modelHeight = (getPosWorld _object)#2 - (getPosASL _object)#2;
    private _vectorDirAndUp = [vectorDir _object, vectorUp _object];
    call {  // Limit scope of rotation variables, might move to a transformation function later.
        // Adjust Position
        private _rotDeg = (_vectorDirAndUpRef#0#0) atan2 (_vectorDirAndUpRef#0#1);  // This will be converted to absolute deg in deserialisation.
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
    private _velocity = velocity _object; _object setPosWorld
    // Details
    private _vehicleCustomization = [_object] call BIS_fnc_getVehicleCustomization;
    private _damage = damage _object;
    private _allHitPointsDamage = getAllHitPointsDamage _object;
    private _fuel = fuel _object;
    private _fuelCargo = getFuelCargo _object;
    private _ammoCargo = getAmmoCargo _object;
    private _repairCargo = getRepairCargo _object;
    private _pylonMagazines = getPylonMagazines _object;
    private _allPylonMagazines = [];  //<ARRAY<magazineName, turretPath, ammoCount>>
    private _turretsWeapons = [];
    {
        if (_x#0 in _pylonMagazines) then {
            private _turretPath = [_x#1,[]] select (_x#1 isEqualTo [-1]);
            _allPylonMagazines pushBack [([_pylonMagazines, _x#0] call Col_fnc_remElement) +1,_x#0,_turretPath,_x#2];   // index needed, ID and creator not. Pylon index 1-based. <ARRAY<pylon, magazine, turret, ammo count>>. Luckily, magazinesAllTurrets returns pylons in the correct order.
        };
    } forEach magazinesAllTurrets _object;

    _pylonMagazines = getPylonMagazines _object;
    {
        private _turretPath = _x;
        private _weapons =  _object weaponsTurret _turretPath;  // <ARRAY<weapons>>
        private _magazines = ((magazinesAllTurrets _object) select {_x#1 isEqualTo _turretPath && {!(_x#0 in _pylonMagazines)}}) apply {[_x#0,_x#2]};  // <ARRAY<magazineName, ammoCount>>
        _turretsWeapons pushBack [_turretPath,_weapons,_magazines];  //<ARRAY<turretPath,ARRAY<weapons>,<ARRAY<magazineName, ammoCount>>>>
    } forEach [[-1]] + (allTurrets _object);
    private _forcedFlagTexture = getForcedFlagTexture _object;
    private _flagTexture = flagTexture _object;
    private _engineOn = isEngineOn _object;
    private _collisionLightOn = isCollisionLightOn _object;
    private _damageAllowed = isDamageAllowed _object;
    private _simulationEnable = simulationEnabled _object;
    private _objectHidden = isObjectHidden  _object;

    _meta = [
        ["positionWorldRef",_positionWorldRef],
        ["vectorDirAndUpRef",_vectorDirAndUpRef]
    ];

    _attributes = [
        ["type",_type],
        ["mass",_mass],
        ["positionWorld",_positionWorld],
        ["positionAGLZ",_positionAGLZ],
        ["modelHeight",_modelHeight],
        ["vectorDirAndUp",_vectorDirAndUp],
        ["velocity",_velocity],
        ["vehicleCustomization",_vehicleCustomization],
        ["damage",_damage],
        ["allHitPointsDamage",_allHitPointsDamage],
        ["fuel",_fuel],
        ["fuelCargo",_fuelCargo],
        ["ammoCargo",_ammoCargo],
        ["repairCargo",_repairCargo],
        ["allPylonMagazines",_allPylonMagazines],
        ["turretsWeapons",_turretsWeapons],
        ["forcedFlagTexture",_forcedFlagTexture],
        ["flagTexture",_flagTexture],
        ["engineOn",_engineOn],
        ["collisionLightOn",_collisionLightOn],
        ["damageAllowed",_damageAllowed],
        ["simulationEnable",_simulationEnable],
        ["objectHidden",_objectHidden],
        []
    ];
    _serialisation = [_meta,_attributes];
} catch {
    [1, _exception joinString " | ", _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _serialisation = [];
};
_serialisation;
