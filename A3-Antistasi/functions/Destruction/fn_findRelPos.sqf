params ["_pos", "_forward", "_side", "_angle", "_distance", "_height"];

/*  Creates a relative position out of the given parameters (It is not the same as getRelPos! Name may be misleading)
*   Parameters:
*     _pos : ARRAY : The position to start with
*     _forward : ARRAY : The forward vector of position (or the object related to _pos)
*     _side : ARRAy : The sidewards vector of position (or the object related to _pos)
*     _angle : NUMBER : The angle in degree between the forward vector and the relative pos
*     _distance : NUMBER : The distance between pos and the relative pos
*     _height : NUMBER : The height difference between them (may not be the actual difference if z of forward or sidewards is not equal 0)
*
*   Returns:
*     _result : ARRAY : The relative pos
*/

/*
Test data, should return [6, 3, 1.5]
_pos = [0, 0, 0]; _forward = [0, 1, 0]; _side = [1, 0, 0]; _angle = 63.435; _distance = 6.7082; _height = 1.5;
*/

//Copy array to avoid overwritting data
private _result = +_pos;

//Calculate the forward and sidewards distance
private _frontFactor = cos (_angle) * _distance;
private _sideFactor = sin (_angle) * _distance;

//Adding the needed vectors to the position
_result = _result vectorAdd (_forward vectorMultiply _frontFactor);
_result = _result vectorAdd (_side vectorMultiply _sideFactor);

//Adding height to the position
_result set [2, (_result select 2) + _height];

//Hint for debug purposes
//hint (str _pos);

if(debug) then
{
  diag_log format ["Calculated pos from %1 with parameters [%2,%3,%4,%5,%6] (forward/side/angle/distance/height), result is %7", _pos, _forward, _side, _angle, _distance, _height, _result];
};

_result;
