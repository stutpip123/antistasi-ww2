params ["_groupParam"];

if (!visibleMap) then {openMap true};
positionTel = [];

onMapSingleClick "positionTel = _pos";

hint "Select the zone on which sending the selected troops as garrison";

waitUntil {sleep 0.5; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

private _positionTel = positionTel;
private _marker = [markersX,_positionTel] call BIS_fnc_nearestPosition;

//Different checks for different garrison adds? Well fine
if (!(_positionTel inArea _marker)) exitWith
{
    hint "You must click near a marked zone";
};
if (!(sidesX getVariable [_marker,sideUnknown] == teamPlayer)) exitWith
{
    hint format ["That zone does not belong to %1",nameTeamPlayer];
};
if ((_marker in outpostsFIA) && {!(isOnRoad getMarkerPos _marker)}) exitWith
{
    hint "You cannot manage garrisons on this kind of zone!";
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
    hint "Players, Prisoners, refugees or dead units cannot be added to any garrison";
};

if ((!(isNull _group)) && {(groupID _group == "MineF") || (groupID _group == "Watch") || (isPlayer(leader _group))}) exitWith
{
    hint "You cannot garrison player led, Watchpost, Roadblocks or Minefield building squads";
};


if (isNull _group) then
{
	_group = createGroup teamPlayer;
	_units joinSilent _group;
	hint "Sending units to garrison";
	if !(hasIFA) then
    {
        {
            arrayids pushBackUnique (name _x)
        } forEach _units;
    };
}
else
{
	hint format ["Sending %1 squad to garrison", groupID _group];
	theBoss hcRemoveGroup _group;
};

[_marker, group (_units select 0)] remoteExec ["A3A_fnc_sendGroupToGarrison", 2];
