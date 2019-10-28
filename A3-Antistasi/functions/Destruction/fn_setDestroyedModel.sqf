params ["_object"];

/*  Updates the visuals to give a better player feedback when they destroyed something
*   Parameter:
*     _object : OBJECT : The object, that needs a visual update
*
*   Returns:
*     Nothing
*/

//TODO add more types
switch (typeOf _object) do
{
  case ("Land_Device_assembled_F"):
  {
    //Maybe use a smoke grenade for this?
    _smoke = createVehicle ["test_EmptyObjectForSmoke", (getPos _object), [], 0, "CAN_COLLIDE"];
    [_smoke, _object] spawn
    {
      private _smoke = _this select 0;
      private _marker = (_this select 1) getVariable ["destructMarker", ""];
      private _counter = 0;
      waitUntil
      {
        sleep 10;
        _counter = _counter + 1;
        (_counter > (15 * 6)) ||
        {spawner getVariable [_marker, 1] == 2}
      };  //Wait until either the marker despawns or 15 minutes past
      deleteVehicle _smoke;
    };
  };
  case ("Land_MetalBarrel_F"):
  {
    if(random 100 > 60) then
    {
      //TODO Replace barrels with new visuals
      deleteVehicle _object;
    }
    else
    {
      //Barrel got destroyed
      deleteVehicle _object;
    };
  };
};
