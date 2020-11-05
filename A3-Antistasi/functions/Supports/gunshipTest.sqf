[] spawn
{
private _plane = plane;
private _target = target;

_plane addEventHandler
[
    "Fired",
    {
        params ["_strikePlane", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];


        private _targetObj = _strikePlane getVariable ["currentTarget", objNull];
        if(isNull _targetObj) exitWith {};
        private _target = getPosASL _targetObj;

        if(_weapon == "RHS_weap_gau8") then
        {
            //Bullet, improve course and accuracy
            _target = _target apply {_x + (random 15) - 7.5};


            //Check if next shot needs to be fired
            private _remainingShots = _strikePlane getVariable ["mainGunShots", 0];
            //hint format ["Remaining shots: %1", _remainingShots];
            if(_remainingShots > 0) then
            {
                //Fire next shot
                [_strikePlane, _weapon, _mode] spawn
                {
                    params ["_strikePlane", "_weapon", "_mode"];
                    sleep 1;
                    (driver _strikePlane) forceWeaponFire [_weapon, _mode];
                };
                _strikePlane setVariable ["mainGunShots", _remainingShots - 1];
            };



            [_projectile, _target, _gunner] spawn
            {
                params ["_projectile", "_target", "_gunner"];
                _gunner globalChat (format ["%1", _projectile]);
                sleep 0.05;

                _gunner globalChat (format ["%1", _projectile]);

                private _speed = (speed _projectile)/3.6;
                private _dir = vectorNormalized (_target vectorDiff (getPosASL _projectile));
                _projectile setVelocity (_dir vectorMultiply (_speed));
                _projectile setVectorDir _dir;

                createVehicle ["Sign_Arrow_F", _target, [], 0, "CAN_COLLIDE"];
            };
        };
    }
];



hint "Engaging new target!";
[(driver _plane), 50] spawn BIS_fnc_traceBullets;
_plane setVariable ["currentTarget", _target];

_plane setVariable ["mainGunShots", 5];
(driver _plane) forceWeaponFire ["RHS_weap_gau8", "close"];

};
