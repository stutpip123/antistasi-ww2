params ["_object"];

/*  Object got destroyed, handle destruction progress
*   Params:
*     _object : OBJECT : The object that got destroyed
*
*   Returns:
*     Nothing
*/

_object allowDamage false;

//Remove all eventHandler
_object removeAllEventHandlers "Hit";
_object removeAllEventHandlers "Explosion";

private _destructPoints = _object getVariable ["destructPoints", 0];
private _destructMarker = _object getVariable ["destructMarker", ""];

if(_destructMarker == "") exitWith
{
  diag_log "ObjectDestroyed: destructMarker on object is not set!";
};

private _canExplode = _object getVariable ["canExplode", false];
if(_canExplode) then
{
  //Object will go BOOM!

  //Sleep as a fuse
  sleep (random 5);

  private _explosion = createVehicle ["APERSMine_Range_Ammo", (getPos _object), [], 0, "CAN_COLLIDE"];
  _explosion setDamage 1;

  diag_log "Barrel exploded";

  private _barrels = (getPos _object) nearObjects ["Land_MetalBarrel_F", 10];
  diag_log format ["Found %1 barrels!", count _barrels];

  {
    if(_x != _object) then
    {
      _canMove = _x getVariable ["canMove", false];
      if(_canMove) then
      {
        //Calculate explosion force and vector
        _distance = _x distance _object;
        _initialForce = 10;
        _direction = (getPos _object) vectorFromTo (getPos _x);
        //Add a bit to the z coordinate to have it flying around
        _direction set [2, (_direction select 2) + 0.5];
        _velocity = (velocity _object) vectorAdd (_direction vectorMultiply (_initialForce * (2/_distance)));
        diag_log format ["Explosion velocity is %1", (str _velocity)];

        //Add explosion velocity
        _x setVelocity _velocity;
      };
    };
  } forEach _barrels;
};

//Adding destruct points to the site
[_destructMarker, _destructPoints] call A3A_fnc_addDestructPoints;

//Just replace the model by a destroyed model
[_object] call A3A_fnc_setDestroyedModel;
