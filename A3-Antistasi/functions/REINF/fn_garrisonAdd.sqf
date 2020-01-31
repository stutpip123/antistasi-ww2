params ["_unitType"];

private _hr = server getVariable "hr";
if (_hr < 1) exitWith {hint "You lack of HR to make a new recruitment"};

private _resourcesFIA = server getVariable "resourcesFIA";
private _costs = 0;

if (_unitType isEqualType "") then
{
	_costs = server getVariable _unitType;
	_costs = _costs + ([SDKMortar] call A3A_fnc_vehiclePrice);
}
else
{
	_unitType = if (random 20 <= skillFIA) then {_unitType select 1} else {_unitType select 0};
	_costs = server getVariable _unitType;
};

if (_costs > _resourcesFIA) exitWith
{
    hint format ["You do not have enough money for this kind of unit (%1 € needed)",_costs]
};

private _marker = garrisonMarker;
private _position = getMarkerPos _marker;

if ((_unitType == staticCrewTeamPlayer) and (_marker in outpostsFIA)) exitWith
{
    hint "You cannot add mortars to a Roadblock garrison"
};

if ([_position,500] call A3A_fnc_enemyNearCheck) exitWith
{
    Hint "You cannot Recruit Garrison Units with enemies near the zone"
};

[-1, -_costs] remoteExec ["A3A_fnc_resourcesFIA",2];
[_marker, [_unitType]] remoteExec ["A3A_fnc_addToOver",2];

sleep 0.25;
[_marker] call A3A_fnc_mrkUpdate;
hint format ["Soldier recruited.%1",[_marker] call A3A_fnc_garrisonInfo];
