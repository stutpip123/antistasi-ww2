[] spawn {
private _target = target;
private _plane = plane;
_plane flyInHeight 250;
private _group = group driver _plane;


//Create waypoint
private _targetPos = (getPos _target) vectorAdd [0, 0, 2];
private _targetVector = [400, 0];
private _dir = (_plane getDir _target) + 90;
_targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
_targetVector pushBack 50;
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
    _targetVector pushBack 50;
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
//_plane setVelocityModelSpace [0, _forwardSpeed, 0];
(driver _plane) disableAI "ALL";
private _timeForRun = 1620 / _forwardSpeed;
private _speedVector = (vectorNormalized _forward) vectorMultiply _forwardSpeed;

hint format ["Speed plane: %1\nTime for run: %2\nResulting speed: %3\nForward speed: %4", speed _plane/3.6, _timeForRun, (1620/_timeForRun), _forwardSpeed];

private _interval = 0;
private _realTime = 0;

private _testMarkerOut = createMarker ["testMarkerOut", _exitRunPos];
_testMarkerOut setMarkerShape "ICON";
_testMarkerOut setMarkerType "mil_dot";
_testMarkerOut setMarkerText "Exit point";
_testMarkerOut setMarkerAlpha 1;

private _testMarkerIn = createMarker ["testMarkerIn", _enterRunPos];
_testMarkerIn setMarkerShape "ICON";
_testMarkerIn setMarkerType "mil_dot";
_testMarkerIn setMarkerText "Enter point";
_testMarkerIn setMarkerAlpha 1;


while {_interval < 0.95 && alive _plane && {!(isNull (driver _plane))}} do
{
    if(_realTime > 0.5) then
    {
        _realTime = 0;

        _targetPos = (getPosASL _target) vectorAdd [0, 0, 2];
        _targetVector = [400, 0];
        _dir = (_plane getDir _target) + 90;

        _sideVector = [_targetVector, -_dir + 90] call BIS_fnc_rotateVector2D;
        _targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;

        _targetVector pushBack 50;
        _sideVector pushBack 0;

        _exitRunPos = _targetPos vectorAdd _targetVector;
        _testMarkerOut setMarkerPos _exitRunPos;

        private _planePos = getPosASL _plane;
        private _way = _planePos vectorDiff _exitRunPos;

        _enterRunPos = _exitRunPos vectorAdd (_way vectorMultiply (1/(1-_interval)));
        _testMarkerIn setMarkerPos _enterRunPos;
        //_enterRunPos set [2, 250];

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

    hint format ["Enterpos z: %1\nExitpos z: %2", _enterRunPos select 2, _exitRunPos select 2];
    sleep 0.05;
    _interval = _interval + (0.05 / _timeForRun);
    _realTime = _realTime + 0.05;

    //Fire main gun
    (driver _plane) forceWeaponFire ["Gatling_30mm_Plane_CAS_01_F", "close"];
};

(driver _plane) enableAI "ALL";
(driver _plane) disableAI "AUTOTARGET";

_plane flyInHeight 250;

//while {getPos _plane select 2 < 100} do
//{
//        private _velocity = velocity _plane;
//        _velocity set [2, (_velocity select 2) + 1];
//        _plane setVelocity _velocity;
//        sleep 0.1;
//};

hint "CAS run completed";
};
