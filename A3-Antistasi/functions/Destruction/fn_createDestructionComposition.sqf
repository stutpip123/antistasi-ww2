params ["_comp", "_buildingPos", "_buildingDir", "_marker"];

private _mainData = _comp select 0;
private _main = [_mainData select 0, _marker, _buildingPos, _buildingDir, _mainData select 1, _mainData select 3, _mainData select 2, true] call A3A_fnc_createDestructionObject;

private _mainWorldPos = getPosWorld _main;
private _mainDir = getDir _main;
private _mainForward = vectorDir _main;
private _mainSide = _mainForward vectorCrossProduct (vectorUp _main);

private _objects = [_main];
{
  //Creates the variables
  _x params ["_type", "_posData", "_points", "_canExplode", "_canMove"];
  _posData params ["_angle", "_distance", "_height", "_dir"];

  //Calculate the pos and dir of the object
  private _spawnPos = [_mainWorldPos, _mainForward, _mainSide, _angle, _distance, _height] call A3A_fnc_findRelPos;
  private _spawnDir = _mainDir + _dir;

  //Creating the object
  private _subObj = [_type, _marker, _spawnPos, _spawnDir , _points, _canMove, _canExplode] call A3A_fnc_createDestructionObject;
  _objects pushBack _subObj;
} forEach (_comp select 1);

_objects;
