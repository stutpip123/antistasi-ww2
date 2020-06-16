params ["_markerDestination", "_side", "_super"];

/*  Sends an attack force towards the given marker

    Execution on: Server

    Scope: External

    Params:
        _markerDestination: MARKER : The target position where the attack will be send to
        _side: SIDE or MARKER : The start parameter of the attack
        _super: BOOLEAN : Determine if the attack should be super strong

    Returns:
        Nothing
*/

private _filename = "singleAttack";

[2, format ["Starting single attack with parameters %1", _this], _fileName] call A3A_fnc_log;


private _markerOrigin = "";
private _posOrigin = [];

private _posDestination = getMarkerPos _markerDestination;

//Parameter is the starting base
if(_side isEqualType "") then
{
    _markerOrigin = _side;
    _posOrigin = getMarkerPos _markerOrigin;
    _side = sidesX getVariable [_markerOrigin, sideUnknown];
    [2, format ["Adapting attack params, side is %1, start base is %2", _side, _markerOrigin], _fileName] call A3A_fnc_log;
};

if(_side == sideUnknown) exitWith
{
    [1, format ["Could not retrieve side for %1", _markerOrigin], _fileName] call A3A_fnc_log;
};

private _typeOfAttack = [_posDestination, _side] call A3A_fnc_chooseAttackType;
if(_typeOfAttack == "") exitWith {};

//No start based selected by now
if(_markerOrigin == "") then
{
    _markerOrigin = [_posDestination, _side] call A3A_fnc_findBaseForQRF;
    _posOrigin = getMarkerPos _markerOrigin;
};

if (_markerOrigin == "") exitWith
{
    [2, format ["Small attack to %1 cancelled because no usable bases in vicinity",_markerDestination], _filename] call A3A_fnc_log
};

//Base selected, select units now
private _vehicles = [];
private _groups = [];
private _landPosBlacklist = [];
private _vehicleCount = if(_side == Occupants) then
{
    2
    + (aggressionOccupants/16)
    + ([0, 2] select _super)
    + ([-0.5, 0, 0.5] select (skillMult - 1))
}
else
{
    2
    + (aggressionInvaders/16)
    + ([0, 3] select _super)
    + ([0, 0.5, 1.5] select (skillMult - 1))
};
_vehicleCount = (round (_vehicleCount)) max 1;

[
    3,
    format ["Due to %1 aggression, sending %2 vehicles", (if(_side == Occupants) then {aggressionOccupants} else {aggressionInvaders}), _vehicleCount],
    _fileName
] call A3A_fnc_log;

//The attack will be carried out by land and air vehicles
if ((_posOrigin distance2D _posDestination < distanceForLandAttack) && {[_posOrigin, _posDestination] call A3A_fnc_isTheSameIsland}) then
{
    private _index = -1;
	if (_markerOrigin in outposts) then
    {
        [_markerOrigin, 40] call A3A_fnc_addTimeForIdle;
    }
    else
    {
        [_markerOrigin, 20] call A3A_fnc_addTimeForIdle;
        _index = airportsX find _markerOrigin;
    };
	private _spawnPoint = objNull;
	private _pos = [];
	private _dir = 0;
	if (_index > -1) then
	{
		_spawnPoint = server getVariable (format ["spawn_%1", _markerOrigin]);
		_pos = getMarkerPos _spawnPoint;
		_dir = markerDir _spawnPoint;
	}
	else
	{
		_spawnPoint = [_posOrigin] call A3A_fnc_findNearestGoodRoad;
		_pos = position _spawnPoint;
        //Always returns 0 but fine
		_dir = getDir _spawnPoint;
	};
	private _vehPool = [_side] call A3A_fnc_getVehiclePoolForAttacks;
    if(_vehPool isEqualTo []) then
    {
        if(_side == Occupants) then
        {
            {_vehPool append [_x, 1]} forEach (vehNATOTransportHelis + vehNATOTrucks);
        }
        else
        {
            {_vehPool append [_x, 1]} forEach (vehCSATTransportHelis + vehCSATTrucks);
        };
    };

	for "_i" from 1 to _vehicleCount do
	{
        private _vehicleType = selectRandomWeighted _vehPool;
        private _vehicleData = [_vehicleType, _spawnPoint, _dir, _typeOfAttack, _landPosBlacklist] call A3A_fnc_createAttackVehicle;
        _vehicles pushBack (_vehicleData select 0);
        _groups pushBack (_vehicleData select 1);
        if !(isNull (_vehicleData select 2)) then
        {
            _groups pushBack (_vehicleData select 2);
        };
        _landPosBlacklist = (_vehicleData select 3);
    };
	[2, format ["Small %1 attack sent with %2 vehicles", _typeOfAttack, count _vehicles], _filename] call A3A_fnc_log;
}
else
{
    //The attack will be carried out by air vehicles only
	[_markerOrigin, 20] call A3A_fnc_addTimeForIdle;
	private _vehPool = [_side, ["LandVehicle"]] call A3A_fnc_getVehiclePoolForAttacks;
    if(_vehPool isEqualTo []) then
    {
        if(_side == Occupants) then
        {
            {_vehPool append [_x, 1]} forEach (vehNATOTransportHelis + vehNATOTrucks);
        }
        else
        {
            {_vehPool append [_x, 1]} forEach (vehCSATTransportHelis + vehCSATTrucks);
        };
    };
	for "_i" from 1 to _vehicleCount do
	{
        private _vehicleType = selectRandomWeighted _vehPool;

		private _pos = _posOrigin;
		private _ang = 0;
        //Search for runway
		private _size = [_markerOrigin] call A3A_fnc_sizeMarker;
		private _buildings = nearestObjects [_posOrigin, ["Land_LandMark_F","Land_runway_edgelight"], _size / 2];
		if (count _buildings > 1) then
		{
			private _pos1 = getPos (_buildings select 0);
			private _pos2 = getPos (_buildings select 1);
			_ang = [_pos1, _pos2] call BIS_fnc_DirTo;
			_pos = [_pos1, 5,_ang] call BIS_fnc_relPos;
		};
		if (count _pos == 0) then {_pos = _posOrigin};
        //Runway found or not found, position selected

        private _vehicleData = [_vehicleType, _pos, _dir, _typeOfAttack, _landPosBlacklist] call A3A_fnc_createAttackVehicle;
        _vehicles pushBack (_vehicleData select 0);
        _groups pushBack (_vehicleData select 1);
        if !(isNull (_vehicleData select 2)) then
        {
            _groups pushBack (_vehicleData select 2);
        };
        _landPosBlacklist = (_vehicleData select 3);
        sleep 10;
	};
	[2, format ["Small %1 attack sent with %2 vehicles", _typeOfAttack, count _vehicles], _filename] call A3A_fnc_log;
};

//Prepare despawn conditions
private _endTime = time + 2700;
private _qrfHasArrived = false;
private _qrfHasWon = false;

while {true} do
{
    private _markerSide = sidesX getVariable [_markerDestination, sideUnknown];

    if(_markerSide == _side) exitWith
    {
        [2, format ["Small attack to %1 captured the marker, starting despawn routines", _markerDestination], _fileName] call A3A_fnc_log;
    };

    //Trying to flip marker
    [_markerDestination, _markerSide] remoteExec ["A3A_fnc_zoneCheck", 2];

    private _groupAlive = false;
    {
        private _index = (units _x) findIf {[_x] call A3A_fnc_canFight};
        if(_index != -1) exitWith
        {
            _groupAlive = true;
        };
    } forEach _groups;

    if !(_groupAlive) exitWith
    {
        [2, format ["Small attack to %1 has been eliminated, starting despawn routines", _markerDestination], _fileName] call A3A_fnc_log;
    };

    sleep 60;
    if(_endTime < time) exitWith
    {
        [2, format ["Small attack to %1 timed out without winning or loosing, starting despawn routines", _markerDestination], _fileName] call A3A_fnc_log;
    };
};

{
    [_x] spawn A3A_fnc_VEHDespawner;
} forEach _vehicle;

{
    [_x] spawn A3A_fnc_groupDespawner;
} forEach _groups;
