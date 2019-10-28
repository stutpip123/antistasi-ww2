params ["_building"];

_building addEventHandler
["HandleDamage",
  {
    params ["_object", "_selection", "_damage", "_source", "_projectile"];

    _currentDamage = damage _object;

    if(_currentDamage >= 1) exitWith
    {
      _currentDamage;
    };

    _addedDamage = (_damage - _currentDamage) max 0;

    switch (true) do
    {
      case (_projectile == ""):
      {
        //Indirect damage, used for explosions and fall damage and so on
        _addedDamage = _addedDamage * 0.25;
      };
      case (_projectile isKindOf "RocketCore");
      case (_projectile isKindOf "MissileCore"):
      {
        _addedDamage = _addedDamage * 4;
      };
      case (_projectile isKindOf "ShellCore"):
      {
        _addedDamage = _addedDamage * 10;
      };
      case (_projectile isKindOf "TimeBombCore"):
      {
        _addedDamage = _addedDamage * 0.25;
      };
      case (_projectile == ""):
      {
        _addedDamage = _addedDamage * 1.5;
      };
    };

    _damage = _currentDamage + _addedDamage;

    if(_damage >= 1) then
    {
      [_object] spawn A3A_fnc_objectDestroyed;
    };

    diag_log format ["Hit damage occured for %1 || Overall damage %2 || Was hit by %3", _addedDamage, _damage, str _projectile];

    _damage;
  }
];
