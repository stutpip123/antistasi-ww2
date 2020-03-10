params ["_operation"];

if (_operation == "add") then
{
    ["Garrison", "Select a zone to add garrisoned troops"] call A3A_fnc_customHint;
}
else
{
    ["Garrison", "Select a zone to remove it's Garrison"] call A3A_fnc_customHint;
};

if (!visibleMap) then {openMap true};
positionTel = [];

onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

private _positionTel = positionTel;
garrisonMarker = "";

private _marker = [markersX, _positionTel] call BIS_fnc_nearestPosition;
private _position = getMarkerPos _marker;

if (getMarkerPos _marker distance _positionTel > 40) exitWith
{
    ["Garrison", "You must click near a marked zone"] call A3A_fnc_customHint;
    CreateDialog "build_menu";
};

if (!(sidesX getVariable [_marker, sideUnknown] == teamPlayer)) exitWith
{
    ["Garrison", format ["That zone does not belong to %1",nameTeamPlayer]] call A3A_fnc_customHint;
    CreateDialog "build_menu";
};

if ([_position,500] call A3A_fnc_enemyNearCheck) exitWith
{
    ["Garrison", "You cannot manage this garrison while there are enemies nearby"] call A3A_fnc_customHint;
    CreateDialog "build_menu";
};


private _isFIAOutpost = if (_marker in outpostsFIA) then {true} else {false};
private _isWatchpost = if (_isFIAOutpost and !(isOnRoad getMarkerPos _marker)) then {true} else {false};
private _garrison = if (!_isWatchpost) then {["_marker"] call A3A_fnc_getOver} else {SDKSniper};

if (_operation == "rem") then
{
    if ((([_garrison, true] call A3A_fnc_countGarrison) == 0) && {!(_marker in outpostsFIA)}) exitWith
    {
        ["Garrison", "The place has no garrisoned troops to remove"] call A3A_fnc_customHint;
        CreateDialog "build_menu";
    };
	private _costs = 0;
	private _hr = 0;
	{
        _x params ["_vehicle", "_crew", "_cargo"];
        if(_vehicle != "") then
        {
            _costs = _costs + ([_vehicle] call A3A_fnc_vehiclePrice);
        };
        {
            if(_x != "") then
            {
                _hr = _hr + 1;
                _costs = _costs + (server getVariable [_x,0]);
            };
        } forEach (_crew + _cargo);
	} forEach _garrison;
	[_hr,_costs] remoteExec ["A3A_fnc_resourcesFIA",2];
    [_marker] call A3A_fnc_clearGarrison;
	if (_isFIAOutpost) then
	{
        //Deleting outpost
		outpostsFIA = outpostsFIA - [_marker]; publicVariable "outpostsFIA";
		markersX = markersX - [_marker]; publicVariable "markersX";
		deleteMarker _marker;
		sidesX setVariable [_marker,nil,true];
	}
	else
	{
		{
            if (_x getVariable ["markerX",""] == _marker) then
            {
                deleteVehicle _x
            }
        } forEach allUnits;
        private _markerPos = getMarkerPos _marker;
        {
            if((_x distance2D _markerPos) < 500) then
            {
                deleteVehicle _x;
            };
        } forEach vehicles;
	};
	[_marker] call A3A_fnc_mrkUpdate;
	["Garrison", format ["Garrison removed<br/><br/>Recovered Money: %1 €<br/>Recovered HR: %2",_costs,_hr]] call A3A_fnc_customHint;
	CreateDialog "build_menu";
}
else
{
	garrisonMarker = _marker;
	publicVariable "garrisonMarker";
	["Garrison", format ["Info%1",[_nearX] call A3A_fnc_garrisonInfo]] call A3A_fnc_customHint;
	closeDialog 0;
	CreateDialog "garrison_recruit";
	sleep 1;
	disableSerialization;

	private _display = findDisplay 100;

	if (str (_display) != "no display") then
	{
		_ChildControl = _display displayCtrl 104;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKMil select 0)];
		_ChildControl = _display displayCtrl 105;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKMG select 0)];
		_ChildControl = _display displayCtrl 126;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKMedic select 0)];
		_ChildControl = _display displayCtrl 107;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKSL select 0)];
		_ChildControl = _display displayCtrl 108;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",(server getVariable staticCrewTeamPlayer) + ([SDKMortar] call A3A_fnc_vehiclePrice)];
		_ChildControl = _display displayCtrl 109;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKGL select 0)];
		_ChildControl = _display displayCtrl 110;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKSniper select 0)];
		_ChildControl = _display displayCtrl 111;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKATman select 0)];
	};
};
