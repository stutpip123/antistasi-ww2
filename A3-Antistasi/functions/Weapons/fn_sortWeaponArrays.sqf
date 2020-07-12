params
[
    ["_weaponsArrayName", "", [""]],
    ["_weaponsType", "", [""]]
];

/*  Sorts the weapon arrays from worst to best weapon

    Execution on: Server

    Call by: Any

    Params:
        _weaponsArrayName : STRING : The name of the array, how it is called in the missionNamespace
        _weaponsType : STRING : The classname of the weapon (e.g. "Rifle")

    Returns:
        Nothing
*/

private _fileName = "sortWeaponArrays";
private _weaponsData = [];

{
    private _weaponName = _x;

    //Get the weapon config file
    private _weaponConfig = configFile >> "CfgWeapons" >> _weaponName;

    //Get the needed variables for calculation
    private _timeBetweenShots = getNumber (_weaponConfig >> "reloadTime");
    private _initSpeed = getNumber (_weaponConfig >> "initSpeed");
    private _dispersion = getNumber (_weaponConfig >> "dispersion");
    private _maxRange = getNumber (_weaponConfig >> "maxRange");

    //Get the used magazine and the related config
    private _weaponMag = (getArray (_weaponConfig >> "magazines")) select 0;
    private _magConfig = configFile >> "CfgMagazines" >> _weaponMag;

    //Get the needed variables for calculation
    private _initSpeedMag = getNumber (_magConfig >> "initSpeed");
    private _ammoCount = getNumber (_magConfig >> "count");

    //Get the used ammo and the related config
    private _weaponAmmo = getText (_magConfig >> "ammo");
    private _ammoConfig = configFile >> "CfgAmmo" >> _weaponAmmo;

    //Get the needed variables for calculation
    private _caliber = getNumber (_ammoConfig >> "caliber");
    private _hit = getNumber (_ammoConfig >> "hit");
    private _airFriction = (-1) * (getNumber (_ammoConfig >> "airFriction"));

    //Calculating damage per second
    private _DPS = _caliber * _hit * (_ammoCount / (_timeBetweenShots * _ammoCount + 2));

    //Get the initial velocity (thanks for that one arma)
    if(_initSpeed < 0) then
    {
        _initSpeed = _initSpeedMag * (-1) * _initSpeed;
    };

    //Calculates the time a bullet needs to reach 100 meters distance
    private _timeTo100Meters = 0;
    if(_initSpeed != 0) then
    {
        _timeTo100Meters = ((exp (100 * _airFriction)) + 1)/(_airFriction * _initSpeed);
    };

    [3, format ["Weapon data: %1", [_weaponName, _DPS, _timeTo100Meters, _dispersion, _maxRange]], _fileName] call A3A_fnc_log;
    _weaponsData pushBack [_weaponName, _DPS, _timeTo100Meters, _dispersion, _maxRange];
} forEach (missionNamespace getVariable _weaponsArrayName);

private _fnc_calculateWeaponScore =
{
    params ["_weaponsArray", "_DPSFactor", "_velocityFactor", "_dispersionFactor", "_rangeFactor"];

    private _score = (_weaponsArray select 1) * _DPSFactor +
                     (_weaponsArray select 2) * _velocityFactor +
                     (_weaponsArray select 3) * _dispersionFactor +
                     (_weaponsArray select 4) * _rangeFactor;

    [_score, _weaponsArray select 0];
};

private _weaponsScore = [];
["Rifles", "Handguns", "MachineGuns", "MissileLaunchers", "Mortars", "RocketLaunchers", "Shotguns", "SMGs", "SniperRifles"];
switch (_weaponsType) do
{
    switch ("Rifles") do
    {
        _weaponsScore = _weaponsData apply {[_x, 1, 1, 1, 1] call _fnc_calculateWeaponScore;};
    };
    switch ("Handguns") do
    {
        _weaponsScore = _weaponsData apply {[_x, 3, 0.5, 0.5, 1] call _fnc_calculateWeaponScore;};
    };
    switch ("MachineGuns") do
    {
        _weaponsScore = _weaponsData apply {[_x, 5, 2, 0.5, 2] call _fnc_calculateWeaponScore;};
    };
    switch ("MissileLaunchers") do
    {
        _weaponsScore = _weaponsData apply {[_x, 5, 0, 0.5, 2] call _fnc_calculateWeaponScore;};
    };
    //What is this for a case?
    switch ("Mortars") do
    {
        _weaponsScore = _weaponsData apply {[_x, 1, 1, 1, 1] call _fnc_calculateWeaponScore;};
    };
    switch ("RocketLaunchers") do
    {
        _weaponsScore = _weaponsData apply {[_x, 5, 1, 2, 0.5] call _fnc_calculateWeaponScore;};
    };
    switch ("Shotguns") do
    {
        _weaponsScore = _weaponsData apply {[_x, 1, 1, 1, 0.5] call _fnc_calculateWeaponScore;};
    };
    switch ("SMGs") do
    {
        _weaponsScore = _weaponsData apply {[_x, 3, 5, 1, 0.5] call _fnc_calculateWeaponScore;};
    };
    switch ("SniperRifles") do
    {
        _weaponsScore = _weaponsData apply {[_x, 3, 1, 3, 5] call _fnc_calculateWeaponScore;};
    };
};

//Sort weapons and rewrite the array
_weaponsScore sort true;
private _sortedArray = [];
{
    _sortedArray pushBack (_x select 1);
    [3, format ["%1 array index %2: %3", _weaponsArrayName, _forEachIndex, _x select 1], _fileName] call A3A_fnc_log;
} forEach _weaponsScore;

missionNamespace setVariable [_weaponsArrayName, _sortedArray];
