params ["_sideOne", "_posOne", "_unitsOne", "_sideTwo", "_posTwo", "_unitsTwo"];

private _fileName = "fn_startFight";

private _fightPos = (_posOne vectorAdd _posTwo) vectorMultiply (1/2);
private _distance = (_posOne vectorDistance _posTwo) / 2;

private _fightID = random 10000;
private _fightMarker = createMarker [format ["fight_%1", _fightID], _fightPos];
_fightMarker setMarkerShape "ELLIPSE";
_fightMarker setMarkerSize [_distance, _distance];
_fightMarker setMarkerColor "ColorRed";
_fightMarker setMarkerBrush "GRID";

[3, format ["Starting combat between %1 and %2 on pos %3 with radius %4", _sideOne, _sideTwo, _fightPos, _distance], _fileName] call A3A_fnc_log;

/////////////////////////////////////////////////
//TODO following part is extremly redundant, find a better way for this
////////////////////////////////////////////////

[3, format ["Starting parsing of units for side %1", _sideOne], _fileName] call A3A_fnc_log;
[_unitsOne, format ["%1 units", _sideOne]] call A3A_fnc_logArray;
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
        _unitDataOne pushBack ([_x] call A3A_fnc_createUnitData);
      };
    } forEach _crew;
  }
  else
  {
      _unitDataOne pushBack ([_vehicle] call A3A_fnc_createUnitData);
  };
  {
      //This if is sadly needed everywhere to avoid null objects
      if(_x != "") then
      {
          _unitDataOne pushBack ([_x] call A3A_fnc_createUnitData);
      };
  } forEach _cargo;
} forEach _unitsOne;

[3, format ["Parsing of units for side %1 finished", _sideOne], _fileName] call A3A_fnc_log;
[_unitDataOne, format ["%1 data", _sideOne]] call A3A_fnc_logArray;


[3, format ["Starting parsing of units for side %1", _sideTwo], _fileName] call A3A_fnc_log;
[_unitsTwo, format ["%1 units", _sideTwo]] call A3A_fnc_logArray;
//Creating unit data
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
        _unitDataTwo pushBack ([_x] call A3A_fnc_createUnitData);
      };
    } forEach _crew;
  }
  else
  {
      _unitDataTwo pushBack ([_vehicle] call A3A_fnc_createUnitData);
  };
  {
      //This if is sadly needed everywhere to avoid null objects
      if(_x != "") then
      {
          _unitDataTwo pushBack ([_x] call A3A_fnc_createUnitData);
      };
  } forEach _cargo;
} forEach _unitsTwo;

[3, format ["Parsing of units for side %1 finished", _sideTwo], _fileName] call A3A_fnc_log;
[_unitDataTwo, format ["%1 data", _sideTwo]] call A3A_fnc_logArray;
/*

private _fightData = [teamPlayer, [], Occupants, [], Invaders, []];

private _fightDataOne = [_unitDataOne] call A3A_fnc_unitToFightData;
private _fightDataTwo = [_unitDataTwo] call A3A_fnc_unitToFightData;

[_fightData, _sideOne, _fightDataOne] call A3A_fnc_setSideData;
[_fightData, _sideTwo, _fightDataTwo] call A3A_fnc_setSideData;

private _allFights = server getVariable ["fightArray", []];
_allFights pushBack [format ["fight_%1", _fightID] ,time + 15];
//Then use this data to have a fight
*/
