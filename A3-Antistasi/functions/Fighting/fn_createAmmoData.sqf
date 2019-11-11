params ["_unit"];

_magazines = getArray (configFile >> "CfgVehicles" >> (typeOf _unit) >> "magazines");
/*  cfgWeapon magazines [] - magazines a weapon can handle
*   cfgWeapon initSpeed - a speed modifier if > 0 a number 1050 if < 0 a factor 1.1
*   cfgVehicle weapons [] - list of weapons the unit is carrying
*   cfgWeapon reloadTime - the time between two shots 1/reloadTime = rof
*   cfgWeapon dispersion - the dispersion of shots in radians
*   cfgWeapon burst - burst fire weapon, how many rounds per trigger pull
*   cfgWeapon burstRangeMax - maximum amount of bullets in a burst
*/


{
  private _magPath = configFile >> "CfgMagazines" >> (typeOf _x);
    private _ammo = getText (_magPath >> "ammo");
    private _count = parseNumber (getText (_magPath >> "count"));
    private _path = configFile >> "CfgAmmo" >> _ammo;
    private _damage = getText (_path >> "hit");
    private _initialVelocity = getText (_path >> "initialVelocity");
    private _typicalVelocity = getText (_path >> "typicalSpeed");
    private _airFriction = getText (_path >> "airFriction");          //Name is checked
    //TODO there is a maxRange variable, set damage to 0 after that?
    //There is also weaponType determining the type of the used weapon, can be used to calculate hit chances
    //Creates code based on the magazines values, the code is hopefully faster than calculating it by looking up the data
    private _damageString = format
    [
    "{
      private _velocity = %1 / (2 + exp (_this * %2));
      private _result = (_velocity / %3) * %4;
      _result;
    }",
    _initialVelocity,
    _airFriction,
    _typicalVelocity,
    _hit
    ];
    private _damageCode = compile _damageString;
} forEach _magazines;
