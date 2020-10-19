[] spawn {
private _target = target;
private _plane = plane;
_plane flyInHeight 500;
private _group = group driver _plane;

_plane setVariable ["mainGun", "Gatling_30mm_Plane_CAS_01_F"];
_plane setVariable ["rocketLauncher", ["Rocket_04_HE_Plane_CAS_01_F"]];
_plane setVariable ["missileLauncher", ["Missile_AGM_02_Plane_CAS_01_F"]];

hint "Started CAS approach";

_plane setCombatMode "GREEN";
_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";
_plane reveal [_target, 4];

_plane setVariable ["currentTarget", _target, true];

//Create waypoint
private _targetPos = (getPos _target) vectorAdd [0, 0, 2];
private _targetVector = [400, 0];
private _dir = (_plane getDir _target) + 90;
_targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
_targetVector pushBack 100;
private _enterRunPos = _targetPos vectorAdd (_targetVector vectorMultiply 5);
_plane setVariable ["enterPos", _enterRunPos];

private _wp1 = _group addWaypoint [_enterRunPos, 0];
_wp1 setWaypointType "MOVE";
//_wp1 setWaypointStatements ["true", "(vehicle this) setVariable ['StartBombRun', true, true]"];

//Wait until run enter pos is reached
[_plane] spawn
{
    private _plane = _this select 0;
    waitUntil {sleep 0.1; (_plane distance2D (_plane getVariable "enterPos")) < 25};
    _plane setVariable ["StartBombRun", true];
};

//Update until reached
waitUntil
{
    _targetPos = (getPos _target) vectorAdd [0, 0, 2];
    _targetVector = [400, 0];
    _dir = (_plane getDir _target) + 90;
    _targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
    _targetVector pushBack 100;
    _enterRunPos = _targetPos vectorAdd (_targetVector vectorMultiply 5);
    _wp1 setWaypointPosition [_enterRunPos, 0];
    _plane setVariable ["enterPos", _enterRunPos];
    sleep 0.1;
    (_plane getVariable ["StartBombRun", false]) || {!(alive _plane) || {isNull (driver _plane)}}
};

if(!(alive _plane) || {isNull (driver _plane)}) exitWith
{
    hint "Bomb run aborted";
    _plane setVariable ["StartBombRun", false, true];
};

hint "Doing bomb run";

//When reached, update run path
private _sideVector = [_targetVector, -_dir + 90] call BIS_fnc_rotateVector2D;
_sideVector set [2, 0];

_enterRunPos = getPos _plane;
private _exitRunPos = _targetPos vectorAdd _targetVector;
private _forward = _exitRunPos vectorDiff _enterRunPos;
private _upVector = (_forward vectorCrossProduct _sideVector) vectorMultiply -1;
private _forwardSpeed = (velocityModelSpace _plane) select 1;
private _timeForRun = 1620 / _forwardSpeed;
private _speedVector = (vectorNormalized _forward) vectorMultiply _forwardSpeed;

private _interval = 0;
private _realTime = 0;

_plane addEventHandler
[
    "Fired",
    {
        params ["_plane", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
        private _target = _plane getVariable ["currentTarget", objNull];
        if(isNull _target) exitWith {};

        //diag_log str _this;

        if(_weapon == (_plane getVariable "mainGun")) then
        {
            //Bullet, improve course and accuracy
            private _speed = speed _projectile/3.6;
            private _targetPos = ((getPosASL _target) vectorAdd [0, 0, 3.5]) vectorAdd (vectorDir _target vectorMultiply ((speed _target)/4.5));
            _targetPos = _targetPos apply {_x + (random 15) - 7.5};
            _projectile setVelocity (vectorNormalized (_targetPos vectorDiff (getPosASL _projectile)) vectorMultiply (_speed));

            //Check if next shot needs to be fired
            private _remainingShots = _plane getVariable ["mainGunShots", 0];
            //diag_log str _remainingShots;
            //hint format ["Remaining shots: %1", _remainingShots];
            if(_remainingShots > 0) then
            {
                //Fire next shot
                [_plane, _weapon, _mode] spawn
                {
                    params ["_plane", "_weapon", "_mode"];
                    sleep 0.02;
                    (driver _plane) forceWeaponFire [_weapon, _mode];
                };
                _plane setVariable ["mainGunShots", _remainingShots - 1];
            };
        };
        if(_weapon in (_plane getVariable ["rocketLauncher", []])) then
        {
            //Unguided rocket, improve course and accuracy
            private _speed = speed _projectile/3.6;
            private _targetPos = ((getPosASL _target) vectorAdd [0, 0, 50]) vectorAdd (vectorDir _target vectorMultiply ((speed _target)));
            _targetPos = _targetPos apply {_x + (random 200) - 100};
            _projectile setVelocity (vectorNormalized (_targetPos vectorDiff (getPosASL _projectile)) vectorMultiply (_speed/1.5));

            //Check if next shot needs to be fired
            private _remainingShots = _plane getVariable ["rocketShots", 0];
            if(_remainingShots > 0) then
            {
                //Fire next shot
                [_plane, _weapon, _mode] spawn
                {
                    params ["_plane", "_weapon", "_mode"];
                    sleep 0.2;
                    (driver _plane) forceWeaponFire [_weapon, _mode];
                };
                _plane setVariable ["rocketShots", _remainingShots - 1];
            };
        };
        if(_weapon in (_plane getVariable ["missileLauncher", []])) then
        {
            //Guided missile, dont do anything
            //Check if next shot needs to be fired (Unlikely, but possible)
            private _remainingShots = _plane getVariable ["missileShots", 0];
            if(_remainingShots > 0) then
            {
                //Fire next shot
                [_plane, _weapon, _mode] spawn
                {
                    params ["_plane", "_weapon", "_mode"];
                    sleep 0.25;
                    _plane fireAtTarget [_target, _muzzle];
                };
                _plane setVariable ["missileShots", _remainingShots - 1];
            };
        };
    }
];

private _fnc_executeWeaponFire =
{
    params ["_plane", "_fireParams"];
    _fireParams params ["_armed", "_mainGunShots", "_rocketShots", "_missileShots"];

    if(_mainGunShots > 0) then
    {
        //Fire main gun
        //(driver _plane) forceWeaponFire ["Gatling_30mm_Plane_CAS_01_F", "close"];
        private _weapon = _plane getVariable ["mainGun", ""];
        private _modes = getArray (configFile >> "cfgweapons" >> _weapon >> "modes");
        private _mode =  _modes select 0;
        if (_mode == "this") then
        {
            _mode = _weapon;
        }
        else
        {
            if ("close" in _modes) then
            {
                _mode = "close";
            };
        };
        (driver _plane) forceWeaponFire [_weapon, _mode];
        _plane setVariable ["mainGunShots", (_mainGunShots - 1)];
    };
    if(_rocketShots > 0) then
    {
        //Select rocket weapon
        private _weapon = selectRandom (_plane getVariable ["rocketLauncher", []]);
        private _modes = (getArray (configFile >> "cfgweapons" >> _weapon >> "modes"));
        private _mode = _modes select 0;
        if (_mode == "this") then
        {
            _mode = _weapon;
        }
        else
        {
            if ("Close_AI" in _modes) then
            {
                _mode = "Close_AI";
            };
        };
        player sideChat format ["Rockets fired in mode: %1", _mode];
        (driver _plane) forceWeaponFire [_weapon, _mode];
        _plane setVariable ["rocketShots", (_rocketShots - 1)];
    };
    if(_missileShots > 0) then
    {
        //Select missile weapon
        private _weapon = selectRandom (_plane getVariable ["missileLauncher", []]);
        _plane fireAtTarget [_plane getVariable "currentTarget", _weapon];
        _plane setVariable ["missileShots", (_missileShots - 1)];
    };
};

private _fireParams =
[
    //[armed, main gun shots, rocket shots, missile shots]
    [true, 20, 3, 1],
    [true, 30, 5, 1],
    [true, 40, 7, 0]
];

while {_interval < 0.95 && alive _plane && {!(isNull (driver _plane))}} do
{
    if(_realTime > 0.5) then
    {
        //Update course of plane
        _realTime = 0;
        _targetPos = (getPosASL _target) vectorAdd [0, 0, 2];
        _targetVector = [400, 0];
        _dir = (_plane getDir _target) + 90;
        _sideVector = [_targetVector, -_dir + 90] call BIS_fnc_rotateVector2D;
        _targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
        _targetVector pushBack 100;
        _sideVector pushBack 0;
        _exitRunPos = _targetPos vectorAdd _targetVector;

        private _planePos = getPosASL _plane;
        private _way = _planePos vectorDiff _exitRunPos;

        _enterRunPos = _exitRunPos vectorAdd (_way vectorMultiply (1/(1-_interval)));
        _forward = _exitRunPos vectorDiff _enterRunPos;
        _speedVector = (vectorNormalized _forward) vectorMultiply _forwardSpeed;
        _upVector = (_forward vectorCrossProduct _sideVector) vectorMultiply -1;
    };

    _plane setVelocityTransformation
    [
		_enterRunPos,
		_exitRunPos,
		_speedVector,
		_speedVector,
		_forward,
		_forward,
		_upVector,
		_upVector,
		_interval
	];

    sleep 0.05;
    _interval = _interval + (0.05 / _timeForRun);
    _realTime = _realTime + 0.05;

    //FIRE MECHANISM

    //First burst
    if(_interval > 0.25 && (_fireParams#0#0)) then
    {
        //Execute fire params
        hint "First Burst";
        [_plane, _fireParams#0] spawn _fnc_executeWeaponFire;
        (_fireParams#0) set [0, false];
    };
    //Second burst
    if(_interval > 0.5 && (_fireParams#1#0)) then
    {
        //Execute fire params
        hint "Second Burst";
        [_plane, _fireParams#1] spawn _fnc_executeWeaponFire;
        (_fireParams#1) set [0, false];
    };
    //Third burst
    if(_interval > 0.75 && (_fireParams#2#0)) then
    {
        //Execute fire params
        hint "Third Burst";
        [_plane, _fireParams#2] spawn _fnc_executeWeaponFire;
        (_fireParams#2) set [0, false];
    };
};

//while {getPos _plane select 2 < 100} do
//{
//        private _velocity = velocity _plane;
//        _velocity set [2, (_velocity select 2) + 1];
//        _plane setVelocity _velocity;
//        sleep 0.1;
//};

hint "CAS run completed";
};
