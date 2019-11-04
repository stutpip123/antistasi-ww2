#define   MISS        101
#define   HIT         102
#define   CRIT_HIT    103

params ["_target", "_gunType", "_accSkill", "_distance", "_numberOfRounds" "_penetration"]; //Maybe some parameter are missing

private _hitChance = 0;
private _rangeModifier = 1;

switch (_gunType) do
{
  case ("AssaultRifle"):
  {
    _hitChance = 0.4;
    //_rangeModifier = [[1], [1], 0] call A3A_fnc_getWeaponRangeModifier;
  };
  case ("MaschineGun"):
  {
    _hitChance = 0.3;
  };
  case ("MaskmanRifle"):
  {
    _hitChance = 0.5;
  };
  case ("Pistol"):
  {
    _hitChance = 0.25;
  };
  case ("SniperRifle"):
  {
    _hitChance = 0.6;
  };
};

_hitChance = _hitChance * _rangeModifier * _accSkill;

if(_hitChance > 1) then {_hitChance = 1};

private _missChance = 1 - _hitChance;
private _criticalChance = 0.2 * _hitChance;
private _hitChance = _hitChance - _criticalChance;

private _baseDamage = 0.2; //Calculate that based on distance and bullet

private _overallDamage = 0;
private _hitCount = 0;
private _critHitCount = 0;
for "_i" from 1 to _numberOfRounds do
{
  private _hitResult = [MISS, HIT, CRIT_HIT] selectRandomWeighted [_missChance, _hitChance, _criticalChance];
  private _hitDamage = 0;
  private _hitDebug = "Miss";
  switch (_hitResult) do
  {
    case (HIT):
    {
      _hitCount = _hitCount + 1;
      _hitDamage = (0.8 + random 0.4) * _baseDamage;
      _hitDebug = "Hit";
    };
    case (CRIT_HIT):
    {
      _critHitCount = _critHitCount + 1;
      _hitDamage = (1.5 + random 1) * _baseDamage;
      _hitDebug = "Crit Hit";
    };
  };
  diag_log format ["Result of %1. round: %2 with damage %3", _i, _hitDebug, _hitDamage];
  _overallDamage = _overallDamage + _hitDamage;
};

private _missCount = (_numberOfRounds - (_hitCount + _critHitCount));

diag_log format ["Result of salvo: %1 hits, %2 critical hits and %3 misses || %4 damage dealt", _hitCount, _critHitCount, _missCount, _overallDamage];

[((_hitCount + _critHitCount) > 0), _overallDamage, [_hitCount, _critHitCount, _missCount]];
