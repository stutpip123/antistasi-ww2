params ["_marker"];

private _fileName = "createAISide";
[
    2,
    format ["Starting spawn of %1", _marker],
    _fileName,
    true
] call A3A_fnc_log;

//Not sure if that ever happens, but it reduces redundance (Deactivated for debug)
//if(spawner getVariable _marker == 2) exitWith {};

private _markerPos = getMarkerPos _marker;
private _markerDir = markerDir _marker;

//Calculating marker size and max length;
private _markerSize = markerSize _marker;
private _isFrontline = [_marker] call A3A_fnc_isFrontline;
private _side = sidesX getVariable [_marker, sideUnknown];

if(_side == sideUnknown) exitWith
{
    [2, format ["%1 has no side set, assuming destroyed roadblock, aborting spawn!", _marker], _fileName, true] call A3A_fnc_log;
};

private _patrolMarkerSize = [0,0];
if(_isFrontline) then
{
    //Cannot risk to spread to thin, stay close
    [3, "Small patrol radius choosen, as marker is frontline", _fileName, true] call A3A_fnc_log;
    _patrolMarkerSize = [(distanceSPWN/6), (distanceSPWN/6)];
}
else
{
    //Full patrol way, not so extrem like in the original
    [3, "Large patrol radius choosen, as marker is not frontline", _fileName, true] call A3A_fnc_log;
    _patrolMarkerSize = [(distanceSPWN/3), (distanceSPWN/3)];
};
if(_marker in controlsX && {isOnRoad (getMarkerPos _marker)}) then
{
    [3, "Marker is roadblock, keep units close to the position", _fileName, true] call A3A_fnc_log;
    _patrolMarkerSize = [50, 50];
};

private _patrolMarker = createMarkerLocal [format ["%1_patrol", _marker], _markerPos];
_patrolMarker setMarkerDirLocal _markerDir;
_patrolMarker setMarkerShapeLocal "ELLIPSE";
_patrolMarker setMarkerSizeLocal _patrolMarkerSize;
_patrolMarker setMarkerTypeLocal "hd_warning";
_patrolMarker setMarkerColorLocal "ColorRed";
_patrolMarker setMarkerBrushLocal "DiagGrid";
_patrolMarker setMarkerAlphaLocal 0;

if(_marker in controlsX || {_marker in outpostsFIA}) exitWith
{
    [_marker, _side] call A3A_fnc_createControlPoint;
    [2, format ["Successfully spawned control point %1", _marker], _fileName, true] call A3A_fnc_log;
};

private _flag = objNull;
private _box = objNull;

if(_marker != "Synd_HQ") then
{
    private _typeFlag = "";
    switch (_side) do
    {
        case (Occupants):
        {
            _typeFlag = NATOFlag;
        };
        case (Invaders):
        {
            _typeFlag = CSATFlag;
        };
        default
        {
            _typeFlag = SDKFlag;
        };
    };
    _flag = createVehicle [_typeFlag, _markerPos, [], 0, "NONE"];
    _flag allowDamage false;

    if(_side != teamPlayer) then
    {
        [_flag,"take"] remoteExec ["A3A_fnc_flagaction",[teamPlayer, civilian],_flag];

        //If someone is bored, think about a way to optimize the following code
        if(_marker in airportsX || {_marker in seaports || {_marker in outposts}}) then
        {
            if (_side == Occupants) then
            {
                _box = NATOAmmoBox createVehicle _markerPos;
                [_box] spawn A3A_fnc_fillLootCrate;
            }
            else
            {
                _box = CSATAmmoBox createVehicle _markerPos;
                [_box] spawn A3A_fnc_fillLootCrate;
            };
            _box setVariable ["CargoMarker", _marker, true];
            _box call jn_fnc_logistics_addAction;

            if (_marker in seaports) then
            {
                _box addItemCargo ["V_RebreatherIA", round (random 5)];
                _box addItemCargo ["G_I_Diving", round (random 5)];
            };
        };
        //End here
    }
    else
    {
        [_flag, "SDKFlag"] remoteExec ["A3A_fnc_flagaction",[teamPlayer, civilian],_flag];
    };
};

private _allVehicles = [];
_allVehicles pushBack [_flag, [15, 0]];
_allVehicles pushBack [_box, [15, 1]];

[_marker, _patrolMarker, _allVehicles] spawn A3A_fnc_cycleSpawn;

[2, format ["Successfully spawned in %1", _marker], _fileName, true] call A3A_fnc_log;
