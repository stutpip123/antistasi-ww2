params ["_objectType", "_marker", "_pos", "_dir", "_destructPoints", "_canMove", "_canExplode"];

/*  Creates a single object of a destruction composition
*   Params:
*     _objectType : STRING : The type of object that should be spawned
*     _marker : STRING : The marker of the site the destruction should be added to
*     _pos : ARRAY : The position the object should be spawned in
*     _dir : NUMBER : The direction of the object
*     _destructPoints : NUMBER : The amount of destruction points the object should add
*     _canMove : BOOLEAN : Indicates if the object should get a velocity from nearby explosions
*     _canExplode : BOOLEAN : Indicates if the object should explode on destruction
*
*   Returns:
*     Nothing
*/

//Spawn and set the objects pos and dir
private _surfaceNormal = surfaceNormal _pos;
private _object = createVehicle [_objectType, _pos, [], 0, "CAN_COLLIDE"];
_object setDir _dir;
//_object setVectorUp _surfaceNormal;
_object setPosWorld _pos;

//Set the important values
_object setVariable ["_destructPoints", _destructPoints];
_object setVariable ["_canMove", _canMove];
_object setVariable ["_canExplode", _canExplode];
_object setVariable ["_destructMarker", _marker];

//Add the EventHandlers
[_object] call A3A_fnc_addDestructEH;
