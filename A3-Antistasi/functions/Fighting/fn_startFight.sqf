params ["_sideOne", "_posOne", "_unitsOne", "_sideTwo", "_posTwo", "_unitsTwo"];

private _fightPos = (_posOne vectorAdd _posTwo) vectorMultiply (1/2);
private _distance = (_posOne vectorDistance _posTwo) / 2;

private _fightID = random 10000;
private _fightMarker = createMarker [format ["fight_%1", _fightID], _fightPos];
_fightMarker setMarkerShape "ELLIPSE";
_fightMarker setMarkerSize [_distance, _distance];
_fightMarker setMarkerColor "ColorRed";
_fightMarker setMarkerBrush "GRID";

//Creating unit data
private _unitDataOne = [];
{
  private _vehicle = _x select 0;
  private _crew = _x select 1;
  private _cargo = _x select 2;
  if(_vehicle == "") then
  {
    {
      if(_x != "") then
      {
        _unitDataOne pushBack ([_x] call A3A_createUnitData);
      };
    } forEach _crew;
  }
  else
  {
    _unitDataOne pushBack ([_vehicle] call A3A_createUnitData);
  };
  {
    if(_x != "") then
    {
      _unitDataOne pushBack ([_x] call A3A_createUnitData);
    };
  } forEach _cargo;
} forEach _unitsOne;

private _unitDataTwo = [];
{
  private _vehicle = _x select 0;
  private _crew = _x select 1;
  private _cargo = _x select 2;
  if(_vehicle == "") then
  {
    {
      if(_x != "") then
      {
        _unitDataTwo pushBack ([_x] call A3A_createUnitData);
      };
    } forEach _crew;
  }
  else
  {
    _unitDataTwo pushBack ([_vehicle] call A3A_createUnitData);
  };
  {
    if(_x != "") then
    {
      _unitDataTwo pushBack ([_x] call A3A_createUnitData);
    };
  } forEach _cargo;
} forEach _unitsTwo;

//Next step is to sort the data into categories
//Then use this data to have a fight
