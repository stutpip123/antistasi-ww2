/*
Function:
    A3A_fnc_serialiseAllVehicles

Description:
    Converts Object of type AllVehicles into primitive array.

Environment:
    <SCHEDULED> Recommended, not required. Serialisation process is resource heavy.

Parameters:
    <OBJECT> Object of type AllVehicles.
    <INTEGER> Max string chunk length. [DEFAULT=1 000 000]
    <INTEGER> Max chunks, will throw exception if this is exceeded. [DEFAULT=1 000 000]

Returns:
    <ARRAY> Serialisation of Object of type AllVehicles;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_object",objNull,[objNull]],
    ["_maxStringLength",1000000,[0]],
    ["_maxChunks",1000000,[0]]
];
private _filename = "fn_serialiseAllVehicles";

private _serialisation = [];
try {
    private _type = typeOf _object;
    // PhysX
    private _mass = getMass _object;
    private _positionAGL = ASLToAGL (getPosASL _object);
    private _vectorDirAndUp = [vectorDir _object, vectorUp _object];
    private _velocity = velocity _object;
    // Details
    private _vehicleCustomization = [_object] call BIS_fnc_getVehicleCustomization;
    private _allHitPointsDamage = getAllHitPointsDamage _object;
    private _fuel = fuel _object;
    private _fuelCargo = getFuelCargo _object;
    private _pylonMagazines = getPylonMagazines _object;
    private _allPylonMagazines = [];  //<ARRAY<magazineName, turretPath, ammoCount>>
    private _turretsWeapons = [];
    {
        if (_x#0 in _pylonMagazines) then {
            private _turretPath = [_x#1,[]] select (_x#1 isEqualTo [-1]);
            _allPylonMagazines pushBack [([_pylonMagazines, _x#0] call A3A_fnc_remElement) +1,_x#0,_turretPath,_x#2];   // index needed, ID and creator not. Pylon index 1-based. <ARRAY<pylon, magazine, turret, ammo count>>. Luckily, magazinesAllTurrets returns pylons in the correct order.
        };
    } forEach magazinesAllTurrets _object;

    _pylonMagazines = getPylonMagazines _object;
    {
        private _turretPath = _x;
        private _weapons =  _object weaponsTurret _turretPath;  // <ARRAY<weapons>>
        private _magazines = ((magazinesAllTurrets _object) select {_x#1 isEqualTo _turretPath && {!(_x#0 in _pylonMagazines)}}) apply {[_x#0,_x#2]};  // <ARRAY<magazineName, ammoCount>>
        _turretsWeapons pushBack [_turretPath,_weapons,_magazines];  //<ARRAY<turretPath,ARRAY<weapons>,<ARRAY<magazineName, ammoCount>>>>
    } forEach [[-1]] + (allTurrets _object);

    _serialisation = [
        ["type",_type],
        ["mass",_mass],
        ["positionAGL",_positionAGL],
        ["vectorDirAndUp",_vectorDirAndUp],
        ["velocity",_velocity],
        ["vehicleCustomization",_vehicleCustomization],
        ["allHitPointsDamage",_allHitPointsDamage],
        ["fuel",_fuel],
        ["fuelCargo",_fuelCargo],
        ["allPylonMagazines",_allPylonMagazines],
        ["turretsWeapons",_turretsWeapons]
    ];
} catch {
    [1, _exception joinString " | ", _filename] remoteExecCall ["A3A_fnc_log",2,false];
    _serialisation = [];
};
_serialisation;
