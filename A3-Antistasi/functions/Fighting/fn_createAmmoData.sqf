#define USE_AGAINST_UNITS       3201
#define USE_AGAINST_VEHICLES    3202
#define USE_AGAINST_ARMOR       3203
#define USE_AGAINST_AIR         3204
#define USE_FOR_COVER           3101
#define USE_FOR_HEALING         3102
#define USE_FOR_REPAIR          3103

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
    private _initialVelocity = getText (_path >> "initSpeed");

    private _path = configFile >> "CfgAmmo" >> _ammo;
    private _usage = getText (_path >> "aiAmmoUsageFlags");
    private _damage = getText (_path >> "hit");
    private _typicalVelocity = getText (_path >> "typicalSpeed");
    private _airFriction = getText (_path >> "airFriction");

    private _flags = _usage splitString "+ ";
    private _ammoFlags = [];
    {
      private _flagNumber = parseNumber _x;
      if(_flagNumber != 0) then
      {
        switch (_flagNumber) do
        {
          case (4):
          {
            //Use smokes to cover unit
            _ammoFlags pushBack USE_FOR_COVER;
          };
          case (64):
          {
            //Use against units
            _ammoFlags pushBack USE_AGAINST_UNITS;
          };
          case (128):
          {
            //Use against unarmored vehicles
            _ammoFlags pushBack USE_AGAINST_VEHICLES;
          };
          case (256):
          {
            //Use against air vehicles
            _ammoFlags pushBack USE_AGAINST_AIR;
          };
          case (512):
          {
            //Use against armored vehicles
            _ammoFlags pushBack USE_AGAINST_ARMOR;
          };
        };
      };
    } forEach _flags;
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
