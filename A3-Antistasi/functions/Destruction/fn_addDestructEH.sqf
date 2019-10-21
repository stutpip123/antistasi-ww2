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

    if(_currentDamage >= 1) exitWith
    {
      _currentDamage;
    };

    _addedDamage = (_damage - _currentDamage) max 0;

    switch (true) do
    {
      //Improve damage by handguns
      case (_projectile isKindOf "BulletCore"):
      {
        //20 is just debug, change back to 2
        _addedDamage = _addedDamage * 2;
      };

      //Slightly improve damage by grenades
      case (_projectile isKindOf "GrenadeCore");
      case (_projectile isKindOf "Grenade"):
      {
        _addedDamage = _addedDamage * 1.5;
      };

      case (_projectile == ""):
      {
        //Indirect damage, used for explosions and fall damage and so on
        _addedDamage = _addedDamage * 1.25;
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

    diag_log format ["Hit damage occured for %1 || Overall damage %2 || Was hit by %3", _addedDamage, _damage, str _projectile];

    _damage;
  }
];
