params ["_object"];

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
