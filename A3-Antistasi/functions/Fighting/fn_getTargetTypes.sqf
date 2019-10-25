params ["_enemyOneArray", "_enemyTwoArray"];

/*  Sorts the enemy arrays into one
****/

private _resultArray = [];
_resultArray resize ((count _enemyOneArray) - 1);
for "_i" from 0 to ((count _enemyOneArray) - 1) do
{
  if((_enemyOneArray select _i) || (_enemyTwoArray select _i)) then
  {
    //At least one array contains this type
    _resultArray set [_i, true];
  }
  else
  {
    //No enemy has this type
    _resultArray set [_i, false];
  };
};

_resultArray;
