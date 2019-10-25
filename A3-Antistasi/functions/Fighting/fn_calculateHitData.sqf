params ["_target", "_gunType", "_accSkill", "_distance", "_penetration"]; //Maybe some parameter are missing

private _hitDamage = 0.3; //Lookup the formula

private _hitChance = 0;
private _rangeModifier = 1;

switch (_gunType) do
{
  case ("AssualtRifle"):
  {
    _hitChance = 0.4;
    _rangeModifier = (abs (_distance - 300))
  };
  case ("MaschineGun"):
  {
    _hitChance = 0.3;
  };

};
