params ["_unit"];

_magazines = getArray (configFile >> "CfgVehicles" >> (typeOf _unit) >> "magazines");
/*  cfgWeapon magazines [] - magazines a weapon can handle
*   cfgWeapon initSpeed - a speed modifier if > 0 a number 1050 if < 0 a factor 1.1
*   cfgVehicle weapons [] - list of weapons the unit is carrying
*   cfgWeapon reloadTime - the time between two shots 1/reloadTime = rof
*   cfgWeapon dispersion - the dispersion of shots in radians
*   cfgWeapon burst - burst fire weapon, how many rounds per trigger pull
*   cfgWeapon burstRangeMax - maximum amount of bullets in a burst
*   cfgVehicle threat - array to determine threat against different targets
*/

private _allMags = [];
{
  private _mag = _x;
  private _index = _allMags findIf {(_x select 0) == _mag};
  if(_index == -1) then
  {
    private _magPath = configFile >> "CfgMagazines" >> (typeOf _mag);
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
      params ['_distance', ['_initVelFactor', -1]];
      private _initialVelocity = %1;
      //This is due to the shitty implementation of BIs velocity modification by weapons
      if(_initVelFactor < 0) then
      {
        _initialVelocity = _initialVelocity * _initVelFactor;
      }
      else
      {
        _initialVelocity = _initVelFactor;
      };
      private _velocity = _initialVelocity / (exp (_this * %2));
      private _result = (_velocity / %3) * %4;
      _result;
    }",
    _initialVelocity,
    (_airFriction * (-1)),  //Negating airFriction to ensure correct behavior
    _typicalVelocity,
    _hit
    ];
    private _damageCode = compile _damageString;
    private _data = [_mag, [0,0,0], 1, _count, _damageCode];
    _allMags pushBack _data;
  }
  else
  {
    _mag = _allMags select _index;
    _mag set [2, (_mag select 2) + 1];
  };
} forEach _magazines;
