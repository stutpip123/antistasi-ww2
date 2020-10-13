private _target = target;
private _plane = plane;

private _targetPos = getPos _target;

private _targetVector = [200, 0];
private _dir = _plane getDir _target;

_targetVector = [_targetVector, _dir] call BIS_fnc_rotateVector2D;

_targetVector pushBack 50;

private _exitRunPos = _targetPos vectorAdd _targetVector;
private _enterRunPos = _targetPos vectorAdd (_targetVector vectorMultiply 5);
