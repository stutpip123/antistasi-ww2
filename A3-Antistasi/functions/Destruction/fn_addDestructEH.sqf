params ["_object"];

/*  Adds the needed EH to the destruction object
*   Params:
*     _object : OBJECT : The object you want to add the EH to
*
*   Returns:
*     Nothing
*/



_object addEventHandler
[
  "HandleDamage",
  {
    params ["_object", "_selection", "_damage", "_source", "_projectile"];

    _currentDamage = damage _object;
    _addedDamage = (_damage - _currentDamage) max 0;

    switch (true) do
    {
      //Improve damage by handguns
      case (_projectile isKindOf "BulletCore"):
      {
        //20 is just debug, change back to 2
        _addedDamage = _addedDamage * 20;
      };

      //Slightly improve damage by grenades
      case (_projectile isKindOf "GrenadeCore");
      case (_projectile isKindOf "Grenade"):
      {
        _addedDamage = _addedDamage * 1.5;
      };

      //Reduce damage of all other sources
      default
      {
        _addedDamage = _addedDamage * 0.6;
      };
    };

    _damage = _currentDamage + _addedDamage;

    if(_damage >= 1) then
    {
      //Objects destroyed, will handle this in another class
      [_object] spawn A3A_fnc_objectDestroyed;
    };

    hint format ["Hit damage occured for %1\nOverall damage %2\nWas hit by %3", _addedDamage, _damage, str _projectile];

    _damage;
  }
];

/*
//Object hit by a bullet or any other projectile
_object addEventHandler
[
  "Hit",
  {
    _object = _this select 0;
    _damage = _this select 2;

    //Increasing damage to not waste as much ammo on things
    _damage = _damage * 1.2;
    _current = damage _object;
    if(_current + _damage >= 1) then
    {
      //Setting damage to 0 to avoid object destruction
      _damage = 0;

      //Objects destroyed, will handle this in another class
      [_object] spawn A3A_fnc_objectDestroyed;
    };

    //Returning the value
    _damage
  }
];

//Object hit by an explosion
_object addEventHandler
[
  "Explosion",
  {
    params ["_object", "_damage"];

    _current = damage _object;
    if(_current + _damage > = 1) then
    {
      //Setting damage to 0 to avoid object destruction
      _damage = 0;

      //Objects destroyed, will handle this in another class
      [_object] spawn A3A_fnc_objectDestroyed;
    };

    //Returning the value
    _damage
  }
];
*/
