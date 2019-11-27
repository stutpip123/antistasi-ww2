#include "defineFighting.inc"

params ["_unit"];
private _fileName = "fn_createUnitData";

//Check if data was already calculated before, if so abort here
private _result = server getVariable [format ["data_%1", _unit], []];
if(!(_result isEqualTo [])) exitWith
{
  //Result already calculated before, loaded data from safe
  [3, format ["Unitdata for %1 loaded, data is %2", _unit, _result], _fileName] call A3A_fnc_log;
  _result;
};

private _unitType = NOT_DEFINED;
private _unitStrength = 1;
switch (true) do
{
    case (_unit isKindOf "Man"):
    {
        _unitType = INFANTRY;
        _unitStrength = 0.6;
    };
    case (_unit isKindOf "LandVehicle"):
    {
        _unitType = VEHICLE;
        _unitStrength = 2;
    };
    case (_unit isKindOf "Air"):
    {
        _unitType = AIR;
        _unitStrength = 1.4;
    };
};

if(_unitType == NOT_DEFINED) then
{
    [1, format ["Could not categorize %1!", _unit], _fileName] call A3A_fnc_log;
};

private _unitVehPath = configFile >> "CfgVehicles" >> _unit;
private _threat = getArray (_unitVehPath >> "threat");

_threat = _threat vectorMultiply _unitStrength;

//Exit here if simulation level is low
if(simulationLevel == 0) exitWith
{
  _result = [_unit, _unitType, _threat];
  [3, format ["Unitdata for %1 calculated, data is %2", _unit, _result], _fileName] call A3A_fnc_log;
  server setVariable [format ["data_%1", _unit], _result]; //Setting data locally, only server calculates fights
  _result;
};

////////////////////////////////////////////////////////////////////////////////
/////////////              TESTED UNTIL HERE                   /////////////////
////////////////////////////////////////////////////////////////////////////////

//Check weapons next and categorize deeper for simulationLevel == 1

private _backpack = getText (_unitVehPath >> "backpack");
private _items = getArray (_unitVehPath >> "Items");
private _linkedItems = getArray (_unitVehPath >> "linkedItems");
private _weapons = getArray (_unitVehPath >> "weapons");

_magazines = getArray (configFile >> "CfgVehicles" >> _unit >> "magazines");
//  cfgWeapon magazines [] - magazines a weapon can handle
//  cfgWeapon initSpeed - a speed modifier if > 0 a number 1050 if < 0 a factor 1.1
//  cfgVehicle weapons [] - list of weapons the unit is carrying
//  cfgWeapon reloadTime - the time between two shots 1/reloadTime = rof
//  cfgWeapon dispersion - the dispersion of shots in radians
//  cfgWeapon burst - burst fire weapon, how many rounds per trigger pull
//  cfgWeapon burstRangeMax - maximum amount of bullets in a burst
//  cfgVehicle threat - array to determine threat against different targets


private _allMags = [];
{
  private _mag = _x;
  private _index = _allMags findIf {(_x select 0) == _mag};
  if(_index == -1) then
  {
    private _magPath = configFile >> "CfgMagazines" >> _mag;
    private _ammo = getText (_magPath >> "ammo");
    private _count = getNumber (_magPath >> "count");
    private _initialVelocity = getNumber (_magPath >> "initSpeed");

    private _path = configFile >> "CfgAmmo" >> _ammo;
    private _usage = (_path >> "aiAmmoUsageFlags") call BIS_fnc_getCfgData;
    private _damage = getNumber (_path >> "hit");
    private _typicalVelocity = getNumber (_path >> "typicalSpeed");
    //Negating airFriction to ensure correct behavior
    private _airFriction = getNumber (_path >> "airFriction");
    private _airFriction = (-1) * _airFriction;

    diag_log format ["Usage is: %1", _usage];
    private _ammoFlags = [];
    if(_usage isEqualType 0) then
    {
      _ammoFlags pushBack _usage;
    }
    else
    {
      private _flags = _usage splitString "+ ";
      {
        private _flagNumber = parseNumber _x;
        if(_flagNumber != 0) then
        {
          switch (_flagNumber) do
          {
            case (4):
            {
              //Use smokes to cover unit
              _ammoFlags pushBack 3101;
            };
            case (64):
            {
              //Use against units
              _ammoFlags pushBack 3201;
            };
            case (128):
            {
              //Use against unarmored vehicles
              _ammoFlags pushBack 3202;
            };
            case (256):
            {
              //Use against air vehicles
              _ammoFlags pushBack 3204;
            };
            case (512):
            {
              //Use against armored vehicles
              _ammoFlags pushBack 3203;
            };
          };
        };
      } forEach _flags;
    };


    diag_log str [_mag, _ammo, _count, _initialVelocity, _damage, _typicalVelocity, _airFriction, _ammoFlags];

    //TODO there is a maxRange variable, set damage to 0 after that?
    //There is also weaponType determining the type of the used weapon, can be used to calculate hit chances
    //Creates code based on the magazines values, the code is hopefully faster than calculating it by looking up the data
    private _damageString = format
    [
    "{
      params ['_distance', ['_initVelFactor', -1]];
      private _initialVelocity = %1;
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
    _airFriction,
    _typicalVelocity,
    _hit
    ];
    //private _damageCode = compile _damageString;
    private _data = [_mag, [0,0,0], 1, _count]; //, _damageCode
    _allMags pushBack _data;
  }
  else
  {
    _mag = _allMags select _index;
    _mag set [2, (_mag select 2) + 1];
  };
} forEach _magazines;

private _result = "";
{
  _result = format ["%1%2\n",_result, _x];
} forEach _allMags;

hint _result;
