[] spawn {
private _target = target;
private _plane = plane;
_plane flyInHeight 250;
private _group = group driver _plane;

//Create waypoint
private _targetPos = getPos _target;
private _targetVector = [400, 0];
private _dir = (_plane getDir _target) + 90;
_targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
_targetVector pushBack 50;
private _enterRunPos = _targetPos vectorAdd (_targetVector vectorMultiply 5);

private _wp1 = _group addWaypoint [_enterRunPos, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointStatements ["true", "(vehicle this) setVariable ['StartBombRun', true, true]"];

//Update until reached
waitUntil
{
    _targetPos = getPos _target;
    _targetVector = [400, 0];
    _dir = (_plane getDir _target) + 90;
    _targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
    _targetVector pushBack 50;
    _enterRunPos = _targetPos vectorAdd (_targetVector vectorMultiply 5);
    _wp1 setWaypointPosition [_enterRunPos, 0];
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
_sideVector pushBack 0;

//Repeat









private _wp2 = _group addWaypoint [_exitRunPos, 0];
_wp2 setWaypointType "MOVE";
_wp1 setWaypointStatements ["true", "(vehicle this) flyInHeight 250"];


private _exitRunPos = _targetPos vectorAdd _targetVector;
private _forward = _exitRunPos vectorDiff _enterRunPos;
private _upVector = (_forward vectorCrossProduct _sideVector) vectorMultiply -1;
private _timeForRun = 1620 / (speed _plane);
private _speedVector = (vectorNormalized _forward) vectorMultiply (speed _plane);

private _interval = 0;
private _realTime = 0;

while {_interval < 1 && alive _plane && {!(isNull (driver _plane))}} do
{
    if(_realTime > 0.5) then
    {
        _realTime = 0;

//        private _targetPos = getPos _target;
//        private _targetVector = [400, 0];
//        private _dir = (_plane getDir _target) + 90;

//        private _sideVector = [_targetVector, -_dir + 90] call BIS_fnc_rotateVector2D;
//        _targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;

//        _targetVector pushBack 50;
//        _sideVector pushBack 0;

//        private _planePos = getPos _plane;
//        private _way = _planePos - _exitRunPos;

//        _enterRunPos = _exitRunPos vectorAdd (_way vectorMultiply (1/(1-_interval)));

//        private _timeForRun = 1620 / (speed _plane);
//        _speedVector = (vectorNormalized _forward) vectorMultiply (speed _plane);

//        _forward = _exitRunPos vectorDiff _enterRunPos;
//        _upVector = (_forward vectorCrossProduct _sideVector) vectorMultiply -1;
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

    sleep 0.1;
    _interval = _interval + (0.1 / _timeForRun);
    _realTime = _realTime + 0.1;
};

_plane flyInHeight 250;

while {getPos _plane select 2 < 100} do
{
        private _velocity = velocity _plane;
        _velocity set [2, (_velocity select 2) + 1];
        _plane setVelocity _velocity;
        sleep 0.1;
};

hint "CAS run completed";
};
