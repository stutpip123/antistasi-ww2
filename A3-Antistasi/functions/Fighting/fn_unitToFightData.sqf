#include "defineFighting.inc"

params ["_unitData"];

private _infUnits = [];
private _groundVeh = [];
private _armorVeh = [];
private _airVeh = [];

{
  private _type = _x select 1;
  private _name = _x select 0;
  private _threatLevel = _x select 2;
  switch (_type) do
  {
    case (INFANTRY):
    {
      _infUnits pushBack [_name, _threatLevel];
    };
    case (VEHICLE):
    {
      _groundVeh pushBack [_name, _threatLevel];
    };
    case (AIR):
    {
      _airVeh pushBack [_name, _threatLevel];
    };
  };
} forEach _unitData;

private _result = [_infUnits, _groundVeh, _airVeh];
_result;
