params ["_comp", "_buildingPos", "_buildingDir", "_marker"];

private _mainData = _comp select 0;

private _main = [_mainData select 0, _marker, _buildingPos, _buildingDir, _mainData select 1, _mainData select 3, _mainData select 2] call A3A_fnc_createDestructionObject;

private _worldPosMain = getPosWorld _main;
private _mainDir = getDir _main;

private _objects = [_main];
{
  //Structure of each is [type, [angle, distance, height, dir], points, canExplode, canMove]
  //Calculate pos and dir
  private _relData = _x select 1;
  private _subPos = _main getRelPos [_relData select 1, (_relData select 0) + _mainDir];
  _subPos set [2, (_worldPosMain select 2) + (_relData select 2)];

  //Creating the object
  private _subObj = [_x select 0, _marker, _subPos, _mainDir + (_relData select 3) , _x select 1, _x select 3, _x select 2] call A3A_fnc_createDestructionObject;
  _objects pushBack _subObj;
} forEach (_comp select 1);

_objects;
