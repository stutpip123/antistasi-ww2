params ["_building"];

_building addEventHandler
["Hit",
  {
    _building = _this select 0;
    _damage = _this select 2;
    _currentDamage = damage _building;

    //Damage by direct hit is reduced, don't waste ammo on it
    _damage = _damage * 0.2;

    if(_damage + _currentDamage > 1) then
    {
      //Building destroyed, will handle this in another class
      [_building] spawn A3A_fnc_objectDestroyed;
    };

    _damage
  }
];

_building addEventHandler
["Explosion",
  {
    params ["_building", "_damage"];

    _current = damage _object;

    //Explosion damage is doubled, to avoid wasting explosives on buildings
    _damage = _damage * 2;

    if(_damage + _current > 1) then
    {
      //Building destroyed, will handle this in another class
      [_building] spawn A3A_fnc_objectDestroyed;
    };

    _damage
  }
];
