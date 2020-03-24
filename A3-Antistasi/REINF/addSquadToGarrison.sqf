params ["_groupParam"];

if (!visibleMap) then {openMap true};
positionTel = [];

onMapSingleClick "positionTel = _pos";

["Garrison", "Select the zone on which sending the selected troops as garrison"] call A3A_fnc_customHint;

waitUntil {sleep 0.5; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

private _positionTel = positionTel;
private _marker = [markersX,_positionTel] call BIS_fnc_nearestPosition;

//Different checks for different garrison adds? Well fine
if (!(_positionTel inArea _marker)) exitWith
{
    ["Garrison", "You must click near a marked zone"] call A3A_fnc_customHint;
};
if (!(sidesX getVariable [_marker,sideUnknown] == teamPlayer)) exitWith
{
    ["Garrison", format ["That zone does not belong to %1",nameTeamPlayer]] call A3A_fnc_customHint;
};
if ((_marker in outpostsFIA) && {!(isOnRoad getMarkerPos _marker)}) exitWith
{
    ["Garrison", "You cannot manage garrisons on this kind of zone"] call A3A_fnc_customHint;
};

private _group = grpNull;
private _units = objNull;
if ((_groupParam select 0) isEqualType grpNull) then
{
    //Input was a HC group, get units from there
	_group = _groupParam select 0;
	_units = units _group;
}
else
{
    //Input was units from player squad, use the input directly
	_units = _groupParam;
};

private _index = _units findIf {(typeOf _x == SDKUnarmed) || {!(alive _x) || {(isPlayer _x) || {(typeOf _x) in arrayCivs}}}};
if (_index != -1) exitWith
{
    ["Garrison", "Static crewman, prisoners, refugees or dead units cannot be added to any garrison"] call A3A_fnc_customHint;
};

if ((!(isNull _group)) && {(groupID _group == "MineF") || (groupID _group == "Watch") || (isPlayer(leader _group))}) exitWith
{
    ["Garrison", "You cannot garrison player led, Watchpost, Roadblocks or Minefield building squads"] call A3A_fnc_customHint;
};

if (isNull _group) then
{
	_group = createGroup teamPlayer;
	_units joinSilent _group;
	["Garrison", "Sending units to garrison"] call A3A_fnc_customHint;
	if !(hasIFA) then
    {
        {
            arrayids pushBackUnique (name _x)
        } forEach _units;
    };
}
else
{
	["Garrison", format ["Sending %1 squad to garrison", groupID _group]] call A3A_fnc_customHint;
	theBoss hcRemoveGroup _group;
};

[_marker, group (_units select 0)] remoteExec ["A3A_fnc_sendGroupToGarrison", 2];
