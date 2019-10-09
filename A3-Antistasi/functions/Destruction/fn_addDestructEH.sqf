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
  params ["_unit", "_selection", "_damage", "_source", "_projectile"];

  _addedDamage = (_damage - (damage _unit)) max 0;

  switch (true) do
  {
    //Improve damage by handguns
    case (_projectile isKindOf "BulletCore"):
    {
      _addedDamage = _addedDamage * 2;
    };
    //Slightly improve damage by grenades
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

  _damage = (damage _unit) + _addedDamage;

  if(_damage >= 1) then
  {
    //Objects destroyed, will handle this in another class
    [_object] spawn A3A_fnc_objectDestroyed;
  }

  hint format ["Hit damage occured for %1, overall %2\nProjectile was %3", _addedDamage, damage _unit, str _projectile];

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
