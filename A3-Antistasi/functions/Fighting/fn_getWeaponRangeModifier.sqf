params ["_chancePoints", "_rangePoints", "_distance"];

private _currentChance = _chancePoints select 0;
private _currentRange = _rangePoints select 0;

//Catch close range case
if(_distance < _currentRange) exitWith {_currentChance};

private _index = 1;
private _arrayCount = count _rangePoints;
private _abort = false;

while {_distance > _currentRange} do
{
  if(_index < _arrayCount) then
  {
    _currentChance = _chancePoints select _index;
    _currentRange = _rangePoints select _index;
  }
  else
  {
    _abort = true;
  };
  if(_abort) exitWith {};
  _index = _index + 1;
};

//Distance is longer than hit chance chart, assuming last
if(_abort) exitWith {_currentChance};


private _lastRange = _rangePoints select (_index - 1);
private _lastChance = _chancePoints select (_index - 1);

//Linear interpolation
private _chance = _lastChance + ((_currentChance - _lastChance) / (_currentRange - _lastRange)) * (_distance - _lastRange);

_chance;
