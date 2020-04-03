private _plane = plane;
private _target = target;

private _targetPos = AGLToASL getPos _target;

//Creating base curve
private _heightLevel = _targetPos vectorAdd [0, 0, 10];
private _length = [0, 50];
private _dir = _plane getDir _targetPos;

private _basePos = [];

diag_log format ["Height %1", _heightLevel];

private _distanceVector = [_length, _dir] call BIS_fnc_rotateVector2D;
_distanceVector pushBack 0;
diag_log format ["DistanceVector %1", _distanceVector];

private _posTwo = _heightLevel vectorAdd (_distanceVector vectorMultiply -1);
private _posThree = _heightLevel vectorAdd _distanceVector;

diag_log format ["Pos2 %1 Pos3 %2", _posTwo, _posThree];

_basePos set [1, _posTwo];
_basePos set [2, _posThree];

private _posOne = _posTwo vectorAdd ((_posTwo vectorDiff _targetPos) vectorMultiply 0.5);
private _posFour = _posThree vectorAdd ((_posThree vectorDiff _targetPos) vectorMultiply 0.5);

_basePos set [0, _posOne];
_basePos set [3, _posFour];

{
    private _arrow = "Sign_Arrow_F" createVehicle [0,0,0];
    _arrow setPosASL _x;
    private _marker = createMarker [format ["Pos %1", _forEachIndex], _x];
    _marker setMarkerType "mil_dot";
    _marker setMarkerText format ["Pos %1", _forEachIndex];
} forEach _basePos;
