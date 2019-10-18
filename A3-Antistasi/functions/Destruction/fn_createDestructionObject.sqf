params ["_objectType", "_marker", "_pos", "_dir", "_destructPoints", "_canMove", "_canExplode", ["_isMain", false]];

/*  Creates a single object of a destruction composition
*   Params:
*     _objectType : STRING : The type of object that should be spawned
*     _marker : STRING : The marker of the site the destruction should be added to
*     _pos : ARRAY : The positionWorld the object should be spawned in
*     _dir : NUMBER : The direction of the object
*     _destructPoints : NUMBER : The amount of destruction points the object should add
*     _canMove : BOOLEAN : Indicates if the object should get a velocity from nearby explosions
*     _canExplode : BOOLEAN : Indicates if the object should explode on destruction
*     _isMain : BOOLEAN : The main object of a composition will be spawned differently
*
*   Returns:
*     _object : OBJECT : The object created by this parameters
*/

private _object = objNull;

if(_isMain) then
{
  //Find suitable position by script right now
  _object = createVehicle [_objectType, _pos, [], 0, "NONE"];
  _pos = getPosWorld _object;
}
else
{
  //Spawn in at [0,0,0], then set the objects pos and dir
  _object = createVehicle [_objectType, [0,0,0], [], 0, "CAN_COLLIDE"];
};

//Set object pos and dir
_object setDir _dir;
_object setPosWorld _pos;
_object allowDamage false;

if(debug) then
{
  diag_log format ["Create destruct object of type %1 at %2 with direction %3", _objectType, _pos, _dir];
};

//If destuct points are 0, the object is just a visual enhancement and features not gameplay effect
//Therefor it should not allow damage and cannot be destroyed
if(_destructPoints != 0) then
{
  //Set the important values
  _object setVariable ["destructPoints", _destructPoints];
  _object setVariable ["canMove", _canMove];
  _object setVariable ["canExplode", _canExplode];
  _object setVariable ["destructMarker", _marker];

  //Add the EventHandlers
  [_object] call A3A_fnc_addDestructEH;

  //Enable damage again
  _object spawn
  {
    sleep 5;
    _this allowDamage true;
  };
};

_object;
