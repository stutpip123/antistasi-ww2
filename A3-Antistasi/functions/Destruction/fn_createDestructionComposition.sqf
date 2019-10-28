params ["_comp", "_buildingPos", "_buildingDir", "_marker"];

/*  Creates a complete composition with the given parameters
*   Parameters:
*     _comp : ARRAY : The composition you want to spawn (get it from initVar)
*     _buildingPos : ARRAY : The pos where to spawn the composition in
*     _buildingDir : NUMBER : The direction of the buildings where the composition will spawn
*     _marker : STRING : The marker the composition will add points to
*
*   Returns:
*     _objects : ARRAY : All spawned in objects
*/

//Create the main object
private _mainData = _comp select 0;
_mainData params ["_mainType", "_mainPoints", "_mainCanExplode", "_mainCanMove"];
private _main = [_mainType, _marker, _buildingPos, _buildingDir,_mainPoints, _mainCanMove, _mainCanExplode, true] call A3A_fnc_createDestructionObject;

//Get needed data from main object
private _mainWorldPos = getPosWorld _main;
private _mainDir = getDir _main;
private _mainForward = vectorDir _main;
private _mainSide = _mainForward vectorCrossProduct (vectorUp _main);

//Create and save subobject
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
