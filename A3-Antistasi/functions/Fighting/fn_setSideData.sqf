params ["_mainArray", "_side", "_data"];

private _index = 0;
switch (_side) do
{
  case (teamPlayer):
  {
    _index = 1;
  };
  case (Occupants):
  {
    _index = 3;
  };
  case (Invaders):
  {
    _index = 5;
  };
};

(_mainArray select _index) append _data;
