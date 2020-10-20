[] spawn {
private _target = target;
private _plane = plane;
_plane flyInHeight 500;
private _group = group driver _plane;
_plane setCombatMode "GREEN";
_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";
_plane reveal [_target, 4];
_plane setVariable ["loadout", getPylonMagazines _plane];
_plane setVariable ["mainGun", "Gatling_30mm_Plane_CAS_01_F"];
_plane setVariable ["rocketLauncher", ["Rocket_04_HE_Plane_CAS_01_F"]];
_plane setVariable ["missileLauncher", ["Missile_AGM_02_Plane_CAS_01_F", "missiles_SCALPEL"]];




//Get available ammo count of all allowed propelled weapons
private _ammoCount = [];
private _loadout = _plane getVariable "loadout";
private _weapons = (_plane getVariable "rocketLauncher") + (_plane getVariable "missileLauncher");
{
    private _weapon = _x;
    private _magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
    private _ammo = 0;
    {
        if(_x in _magazines) then
        {
            _ammo = _ammo + getNumber (configFile >> "CfgMagazines" >> _x >> "count");
        };
    } forEach _loadout;
    _ammoCount pushBack [_weapon, _ammo];
} forEach _weapons;


hint "Started CAS approach";

//Start CAS run logic
_plane setVariable ["currentTarget", _target, true];
_plane setVariable ["StartBombRun", false];

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

//Wait until run enter pos is reached
[_plane] spawn
{
    private _plane = _this select 0;
    waitUntil
    {
        sleep 0.1;
        private _enterPos = _plane getVariable ["enterPos", objNull];
        isNull _enterPos ||
        {_plane distance2D (_plane getVariable "enterPos")) < 25}
    };
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
    sleep 0.25;
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

            //Reduce available ammo
            private _index = _ammoCount findIf {_weapon == _x select 0};
            _ammoCount select _index set [1, (_ammoCount#_index#1) - 1];

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

            //Reduce the available ammo for internal logic
            private _index = _ammoCount findIf {_weapon == _x select 0};
            _ammoCount select _index set [1, (_ammoCount#_index#1) - 1];

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
        //Fire main gun with selected mode
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

        //Force weapon fire
        _plane setVariable ["mainGunShots", (_mainGunShots - 1)];
        (driver _plane) forceWeaponFire [_weapon, _mode];
    };
    if(_rocketShots > 0) then
    {
        //Select rocket weapon for use
        private _weapons = _plane getVariable ["rocketLauncher", []];
        private _selectedWeapon = objNull;
        if(count _weapons > 1) then
        {

            private _currentHighest = 0;
            {
                private _weapon = _x;
                private _index = _ammoCount findIf {_x select 0 == _weapon};
                if ((isNull _weapon) || {_ammoCount#_index#1 > _currentHighest}) then
                {
                    _selectedWeapon = _weapon;
                    _currentHighest = _ammoCount#_index#1;
                };
                //Weapon with more shots then needed found, using it
                if(_currentHighest >= _rocketShots) exitWith {};
            } forEach _weapons;
        }
        else
        {
            if(count _weapons == 1) then
            {
                _selectedWeapon = _weapons#0;
            };
        };

        //If weapon available fire it
        if(_selectedWeapon isEqualType "") then
        {
            //Select fire mode for weapon
            private _modes = (getArray (configFile >> "cfgweapons" >> _selectedWeapon >> "modes"));
            private _mode = _modes select 0;
            if (_mode == "this") then
            {
                _mode = _selectedWeapon;
            }
            else
            {
                if ("Close_AI" in _modes) then
                {
                    _mode = "Close_AI";
                };
            };

            //Force weapon fire
            _plane setVariable ["rocketShots", (_rocketShots - 1)];
            (driver _plane) forceWeaponFire [_selectedWeapon, _mode];
        };
    };
    if(_missileShots > 0) then
    {
        //Select missile weapon
        private _weapons = _plane getVariable ["missileLauncher", []];
        private _selectedWeapon = objNull;
        if(count _weapons > 1) then
        {
            private _currentHighest = 0;
            {
                private _weapon = _x;
                private _index = _ammoCount findIf {_x select 0 == _weapon};
                if ((isNull _weapon) || {_ammoCount#_index#1 > _currentHighest}) then
                {
                    _selectedWeapon = _weapon;
                    _currentHighest = _ammoCount#_index#1;
                };
                //Weapon with more shots then needed found, using it
                if(_currentHighest >= _missileShots) exitWith {};
            } forEach _weapons;
        }
        else
        {
            if(count _weapons == 1) then
            {
                _selectedWeapon = _weapons#0;
            };
        };

        //Fire weapon if one is selected (guided weapons only gets fired when they have a lockon possibility on the target)
        if(_selectedWeapon isEqualType "") then
        {
            _plane fireAtTarget [_plane getVariable "currentTarget", _selectedWeapon];
            _plane setVariable ["missileShots", (_missileShots - 1)];
        };
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
    if(!(alive _target) ) exitWith//|| target out of range check*/) exitWith
    {
        //[3, format ["%1 has eliminated its target, returning to loitering", _supportName], _fileName] call A3A_fnc_log;
    };

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
        [_plane, _fireParams#0] spawn _fnc_executeWeaponFire;
        (_fireParams#0) set [0, false];
    };
    //Second burst
    if(_interval > 0.5 && (_fireParams#1#0)) then
    {
        //Execute fire params
        [_plane, _fireParams#1] spawn _fnc_executeWeaponFire;
        (_fireParams#1) set [0, false];
    };
    //Third burst
    if(_interval > 0.75 && (_fireParams#2#0)) then
    {
        //Execute fire params
        [_plane, _fireParams#2] spawn _fnc_executeWeaponFire;
        (_fireParams#2) set [0, false];
    };
    //FIRE MECHANISM END
};
};
