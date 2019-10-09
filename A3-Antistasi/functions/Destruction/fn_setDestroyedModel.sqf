params ["_object"];

//TEMP, should replace the model, currently just deletes it


//deleteVehicle _object;

switch (typeOf _object) do
{
  case ("Land_Device_assembled_F"):
  {
    //_smoke = "test_EmptyObjectForSmoke" createVehicle (getPosWorld _object);
    _smoke = createVehicle ["test_EmptyObjectForSmoke", (getPos _object), [], 0, "CAN_COLLIDE"];
    /*
      _ps1 = "#particlesource" createVehicleLocal (getPos _object);
      _ps1 setParticleParams
      [
        ["\ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 3, 1],
        "",
        "Billboard",
        1,
        3,
        [0,0,0],
        [0,0, 1.5],
        0,
        10,
        7.9,
        0.066,
        [2, 6, 12],
        [[0.5, 0.5, 0.5, 0.3], [0.75, 0.75, 0.75, 0.15], [1, 1, 1, 0]],
        [0.125],
        1,
        0,
        "",
        "",
        _this
      ];

      _ps1 setParticleRandom
      [
        1,
        [0.5, 0.5, 0.25],
        [0, 0, 0],
        1,
        0.02,
        [0, 0, 0, 0.1],
        0.01,
        0.03,
        10
      ];

      _ps1 setParticleCircle [0.5, [0, 0, 0]];
      _ps1 setDropInterval 0.1;
    */
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
