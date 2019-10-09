//Checking the main element
private _mainObject = main;
private _mainType = typeOf _mainObject;
private _mainPoints = _mainObject getVariable ["destructPoints", 0];
private _mainExplosive = _mainObject getVariable ["canExplode", false];
private _mainCanMove = _mainObject getVariable ["canMove", false];
private _mainArray = [_mainType, _mainPoints, _mainExplosive, _mainCanMove];

private _mainWorldPos = getPosWorld _mainObject;
private _mainDir = getDir _mainObject;
private _allObjects = (getPos _mainObject) nearObjects 50;

private _objects = [];
{
    if(_x != _mainObject && {!(_x isKindOf "Man")}) then
    {
      _xType = typeOf _x;
      _xRelPos = (getPosWorld _x) vectorDiff _mainWorldPos;
      _xRelDir = (getDir _x) - _mainDir;
      _points = _x getVariable ["destructPoints", 0];
      _canExplode = _x getVariable ["canExplode", false];
      _canMove = _x getVariable ["canMove", false];
      _objects pushBack [_xType, _xRelPos, _xRelDir, _points, _canExplode, _canMove];
    };
} forEach _allObjects;

_result = [_mainArray, _objects];
copyToClipboard (str _result);
