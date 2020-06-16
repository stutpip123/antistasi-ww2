params ["_side", "_posDestination", "_supportName"];

/*  Sends a QRF force towards the given position

    Execution on: Server

    Scope: External

    Params:
        _posDestination: POSITION : The target position where the QRF will be send to
        _side: SIDE : The side of the QRF

    Returns:
        _coverageMarker : STRING : The name of the marker covering the support area, "" if not possible
*/

private _filename = "SUP_QRF";

private _typeOfAttack = [_posDestination, _side, _supportName] call A3A_fnc_chooseAttackType;
//If no type specified, exit here
if(_typeOfAttack == "") exitWith
{
    ""
};

private _markerOrigin = [_posDestination, _side] call A3A_fnc_findBaseForQRF;
if (_markerOrigin == "") exitWith
{
    [2, format ["QRF to %1 cancelled because no usable bases in vicinity",_posDestination], _filename] call A3A_fnc_log;
    ""
};
private _posOrigin = getMarkerPos _markerOrigin;

[
    3,
    format ["%1 will be send from %2", _supportName, _markerOrigin],
    _fileName
] call A3A_fnc_log;

private _targetMarker = createMarker [format ["%1_coverage", _supportName], _posDestination];

_targetMarker setMarkerShape "ELLIPSE";
_targetMarker setMarkerBrush "Grid";
_targetMarker setMarkerSize [300, 300];
if(_side == Occupants) then
{
    _targetMarker setMarkerColor colorOccupants;
};
if(_side == Invaders) then
{
    _targetMarker setMarkerColor colorInvaders;
};
_targetMarker setMarkerAlpha 0;

//Base selected, select units now
private _vehicles = [];
private _groups = [];
private _landPosBlacklist = [];
private _vehicleCount = if(_side == Occupants) then
{
    (aggressionOccupants/16)
    + ([-0.5, 0, 0.5] select (skillMult - 1))
}
else
{
    (aggressionInvaders/16)
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
        [_markerOrigin, 20] call A3A_fnc_addTimeForIdle;
    }
    else
    {
        [_markerOrigin, 10] call A3A_fnc_addTimeForIdle;
        _index = airportsX find _markerOrigin;
    };

	private _spawnPoint = [];
	private _dir = 0;

	if (_index > -1) then
	{
		_spawnPoint = server getVariable (format ["spawn_%1", _markerOrigin]);
		_spawnPoint = getMarkerPos _spawnPoint;
		_dir = markerDir _spawnPoint;
	}
	else
	{
		_spawnPoint = [_posOrigin] call A3A_fnc_findNearestGoodRoad;
		_spawnPoint = position _spawnPoint;
	};

	private _vehPool = [_side] call A3A_fnc_getVehiclePoolForQRFs;
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
        private _vehicleData = [_vehicleType, _spawnPoint, _dir, _typeOfAttack, _landPosBlacklist, _side] call A3A_fnc_createAttackVehicle;
        _vehicles pushBack (_vehicleData select 0);
        _groups pushBack (_vehicleData select 1);
        if !(isNull (_vehicleData select 2)) then
        {
            _groups pushBack (_vehicleData select 2);
        };
        _landPosBlacklist = (_vehicleData select 3);
	};
	[2, format ["%1 QRF sent with %2 vehicles, callsign %3", _typeOfAttack, count _vehicles, _supportName], _filename] call A3A_fnc_log;
}
else
{
    //The attack will be carried out by air vehicles only
	[_markerOrigin, 10] call A3A_fnc_addTimeForIdle;
	private _vehPool = [_side, ["LandVehicle"]] call A3A_fnc_getVehiclePoolForQRFs;
    if(_vehPool isEqualTo []) then
    {
        if(_side == Occupants) then
        {
            {_vehPool append [_x, 1]} forEach vehNATOTransportHelis;
        }
        else
        {
            {_vehPool append [_x, 1]} forEach vehCSATTransportHelis;
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

        private _vehicleData = [_vehicleType, _pos, _ang, _typeOfAttack, _landPosBlacklist, _side] call A3A_fnc_createAttackVehicle;
        _vehicles pushBack (_vehicleData select 0);
        _groups pushBack (_vehicleData select 1);
        if !(isNull (_vehicleData select 2)) then
        {
            _groups pushBack (_vehicleData select 2);
        };
        _landPosBlacklist = (_vehicleData select 3);
		sleep 20;
	};
	[2, format ["%1 QRF sent with %2 vehicles, callsign %3", _typeOfAttack, count _vehicles, _supportName], _filename] call A3A_fnc_log;
};

[_side, _vehicles, _groups, _posDestination, _supportName] spawn A3A_fnc_SUP_QRFRoutine;
_targetMarker;
