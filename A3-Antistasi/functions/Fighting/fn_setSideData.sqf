params ["_mainArray", "_side", "_data"];

private _index = 0;
switch (_side) do
{
  case (teamPlayer):
  {
    _index = 0;
  };
  case (Occupants):
  {
    _index = 1;
  };
  case (Invaders):
  {
    _index = 2;
  };
};

for "_i" from 0 to 2 do
{
    ((_mainArray select _index) select _i) append (_data select _i);
};
