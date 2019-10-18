params ["_pos", "_forward", "_side", "_angle", "_distance"];

/*
Test data, should return [6, 3, 0]
_pos = [0, 0, 0];
_forward = [0, 1, 0];
_side = [1, 0, 0];
_angle = 63.435;
_distance = 6.7082;
*/

//hint format ["Sin 90: %1, 60: %2, 45: %3, 30: %4, 0: %5", sin 90, sin 60, sin 45, sin 30, sin 0];

_frontFactor = cos (_angle) * _distance;
_sideFactor = sin (_angle) * _distance;

//hint format ["Front is %1, side is %2", _frontFactor, _sideFactor];

_pos = _pos vectorAdd (_forward vectorMultiply _frontFactor);
_pos = _pos vectorAdd (_side vectorMultiply _sideFactor);

//hint (str _pos);
