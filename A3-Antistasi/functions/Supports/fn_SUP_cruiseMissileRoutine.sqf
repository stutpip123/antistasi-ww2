

//Creates the laser target to mark the target
private _laser = createVehicle ["LaserTargetE", (getPos target), [], 0, "CAN_COLLIDE"];
_laser attachTo [target, [0,0,2]];

//Send the laser target to the launcher
west reportRemoteTarget [_laser, 300];
_laser confirmSensorTarget [west, true];
_launcher fireAtTarget [_laser, "weapon_vls_01"];
