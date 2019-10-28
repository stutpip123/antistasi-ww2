//Checking the main element
private _mainObject = main;
private _mainType = typeOf _mainObject;
private _mainPoints = _mainObject getVariable ["destructPoints", 0];
private _mainExplosive = _mainObject getVariable ["canExplode", false];
private _mainCanMove = _mainObject getVariable ["canMove", false];
private _mainArray = [_mainType, _mainPoints, _mainExplosive, _mainCanMove];

fnc_getRelPos =
{
  params ["_mainPos", "_mainForward", "_mainSide", "_object"];
  private _vectorDiff = (getPosWorld _object) vectorDiff _mainPos;

  //Saving the height offset
  private _heightDiff = _vectorDiff select 2;

  //Calculate the angle between the forward of the main object and the vector of the object
  _vectorDiff set [2, 0];
  private _cosAngle = _vectorDiff vectorCos _mainForward;
  private _angle = (acos _cosAngle);
  private _sign = if(_mainSide vectorDotProduct _vectorDiff > 0) then {1} else {-1};
  _angle = _angle * _sign;

  //Calculating the distance
  private _distance = vectorMagnitude _vectorDiff;

  //Returning the data
  private _result = [_angle, _distance, _heightDiff];
  _result;
};

//Calculating the direction vectors
private _mainWorldPos = getPosWorld _mainObject;
private _mainVectorDir = vectorDir _mainObject;
_mainVectorDir set [2, 0];
private _mainVectorSide = _mainVectorDir vectorCrossProduct (vectorUp _mainObject);
private _mainDir = getDir _mainObject;

//Processing the other objects
private _allObjects = (getPos _mainObject) nearObjects 20;
private _objects = [];
{
    if(_x != _mainObject && {!(_x isKindOf "Man")}) then
    {
      _xType = typeOf _x;
      _relData = [_mainWorldPos, _mainVectorDir, _mainVectorSide, _x] call fnc_getRelPos;
      _relData pushBack ((getDir _x) - _mainDir);
      _points = _x getVariable ["destructPoints", 0];
      _canExplode = _x getVariable ["canExplode", false];
      _canMove = _x getVariable ["canMove", false];
      _objects pushBack [_xType, _relData, _points, _canExplode, _canMove];
    };
} forEach _allObjects;

_result = [_mainArray, _objects];
copyToClipboard (str _result);
