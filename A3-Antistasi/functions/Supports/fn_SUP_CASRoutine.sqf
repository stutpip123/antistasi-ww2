params ["_strikePlane", "_strikeGroup", "_airport", "_supportName", "_setupPos"];

private _fileName = "SUP_CASRoutine";

private _side = side _strikeGroup;

//Sleep to simulate preparetion time
private _sleepTime = 15;//random (200 - ((tierWar - 1) * 20));
while {_sleepTime > 0} do
{
    sleep 1;
    _sleepTime = _sleepTime - 1;
    if((spawner getVariable _airport) != 2) exitWith {};
};

_strikePlane hideObjectGlobal false;
_strikePlane enableSimulation true;
_strikePlane flyInHeight 500;

//Decrease time if aggro is low
private _sideAggression = if(_side == Occupants) then {aggressionOccupants} else {aggressionInvaders};
private _timeAlive = 1200;
private _confirmedKills = 4;//[_strikePlane, 0] call A3A_fnc_countMissiles;

if(_sideAggression < (30 + (random 40))) then
{
    _timeAlive = 600;
    //Plane needs to have at least 6 missiles in all cases
    _confirmedKills = 2;
};

[_strikePlane, "CAS"] call A3A_fnc_setPlaneLoadout;

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

//REPEATING FIRE LOGIC
//Forcing the plane to fire is handled in this EH to avoid loops
_strikePlane addEventHandler
[
    "Fired",
    {
        params ["_plane", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
        private _target = _plane getVariable ["currentTarget", objNull];
        if(isNull _target) exitWith {};

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

//Creating the startpoint for the fire EH loop
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
//FIRE LOGIC END

_strikePlane setVariable ["InArea", false, true];
_strikePlane setVariable ["CurrentlyAttacking", false, true];

private _dir = (getPos _strikePlane) getDir _setupPos;

private _areaWP = _strikeGroup addWaypoint [_setupPos getPos [-2000, _dir], 1];
_areaWP setWaypointSpeed "FULL";
_areaWP setWaypointType "Move";
_areaWP setCombatMode "GREEN";
_areaWP setWaypointStatements ["true", "(vehicle this) setVariable ['InArea', true, true]; [3, 'CAS plane has arrived', 'CASRoutine'] call A3A_fnc_log"];

private _loiterWP = _strikeGroup addWaypoint [_setupPos, 2];
_loiterWP setWaypointSpeed "NORMAL";
_loiterWP setWaypointType "Loiter";
_loiterWP setWaypointLoiterRadius 2000;

private _time = time;

waitUntil {sleep 1; !(alive _strikePlane) || (_strikePlane getVariable ["InArea", false])};

if !(alive _strikePlane) exitWith
{
    [_supportName, _side] call A3A_fnc_endSupport;
};

_timeAlive = _timeAlive - (time - _time);

private _targetObj = objNull;
while {_timeAlive > 0} do
{
    if !(_strikePlane getVariable "CurrentlyAttacking") then
    {
        [3, format ["Searching new target for %1", _supportName], _fileName] call A3A_fnc_log;
        //Plane is currently not attacking a target, search for new order
        private _targetList = server getVariable [format ["%1_targets", _supportName], []];
        if (count _targetList > 0) then
        {
            //New target active, read in
            private _target = _targetList deleteAt 0;
            server setVariable [format ["%1_targets", _supportName], _targetList, true];

            [3, format ["Next target for %2 is %1", _target, _supportName], _fileName] call A3A_fnc_log;

            //Parse targets
            private _targetParams = _target select 0;
            private _reveal = _target select 1;

            _targetObj = _targetParams select 0;
            private _precision = _targetParams select 1;
            private _targetPos = getPos _targetObj;

            _strikeGroup reveal [_targetObj, _precision];
            _strikePlane flyInHeight 250;

            //Show target to players if change is high enough
            private _textMarker = createMarker [format ["%1_text", _supportName], getPos _targetObj];
            _textMarker setMarkerShape "ICON";
            _textMarker setMarkerType "mil_objective";
            _textMarker setMarkerText "CAS Target";

            if(_side == Occupants) then
            {
                _textMarker setMarkerColor colorOccupants;
            }
            else
            {
                _textMarker setMarkerColor colorInvaders;
            };
            _textMarker setMarkerAlpha 0;

            [_textMarker, _targetObj, _strikePlane] spawn
            {
                params ["_textMarker", "_targetObj", "_strikePlane"];
                while {!(isNull _targetObj) && (alive _targetObj)} do
                {
                    _textMarker setMarkerPos (getPos _targetObj);

                    if((isNull _strikePlane) || !(alive _strikePlane)) exitWith {};

                    sleep 0.5;
                };
                deleteMarker _textMarker;
            };

            [_reveal, getPos _targetObj, _side, "close air support", "", _textMarker] spawn A3A_fnc_showInterceptedSupportCall;
            _strikePlane setVariable ["CurrentlyAttacking", true, true];

            private _attackWP = _strikeGroup addWaypoint [_targetPos, 3];
            _attackWP setWaypointType "DESTROY";
            _attackWP waypointAttachObject _targetObj;
            _attackWP setWaypointSpeed "FULL";
            _strikeGroup setCurrentWaypoint _attackWP;

            _strikeGroup setBehaviour "COMBAT";
            _strikeGroup setCombatMode "RED";

            {
                _mode = (getArray (configFile >> "cfgweapons" >> _x >> "modes")) select 0;
                if (_mode == "this") then {_mode = _x;};
                (driver _strikePlane) fireAtTarget [_targetObj, _mode];
            } forEach (weapons _strikePlane);
        };
    }
    else
    {
        if(isNull _targetObj || {!(alive _targetObj)}) then
        {
            [3, format ["Target destroyed, %1 returns to cycle mode", _supportName], _fileName] call A3A_fnc_log;
            //Target destroyed
            _strikePlane setVariable ["CurrentlyAttacking", false, true];
            _strikeGroup setCurrentWaypoint [_strikeGroup, 2];

            _strikePlane flyInHeight 400;
        };
    };

    //Plane somehow destroyed
    if
    (
        !(alive _strikePlane) ||
        {({alive _x} count (units _strikeGroup)) == 0 ||
        {_strikePlane getVariable ["Stolen", false]}}
    ) exitWith
    {
        [2,format ["%1 has been destroyed or crew killed, aborting routine", _supportName],_fileName] call A3A_fnc_log;
        if(_side == Occupants) then
        {
            [[10, 45], [0, 0]] remoteExec ["A3A_fnc_prestige", 2];
        }
        else
        {
            [[0, 0], [10, 45]] remoteExec ["A3A_fnc_prestige", 2];
        };
    };

    //No missiles left
    if (!(_strikePlane getVariable "CurrentlyAttacking") && (_confirmedKills <= 0)) exitWith{[2,format ["%1 has no more missiles left to fire, aborting routine", _supportName],_fileName] call A3A_fnc_log;};

    //Retreating
    if(_strikePlane getVariable ["Retreat", false]) exitWith {[2,format ["%1 met heavy resistance, retreating", _supportName], _fileName] call A3A_fnc_log;};

    sleep 5;
    _timeAlive = _timeAlive - 5;
};

//Have the plane fly back home
if (alive _strikePlane && [driver _strikePlane] call A3A_fnc_canFight) then
{
    private _wpBase = _strikeGroup addWaypoint [getMarkerPos _airport, 0];
    _wpBase setWaypointType "MOVE";
    _wpBase setWaypointBehaviour "CARELESS";
    _wpBase setWaypointSpeed "FULL";
    _wpBase setWaypointStatements ["", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
    _strikeGroup setCurrentWaypoint _wpBase;
};

//Deleting all the support data here
[_supportName, _side] call A3A_fnc_endSupport;
