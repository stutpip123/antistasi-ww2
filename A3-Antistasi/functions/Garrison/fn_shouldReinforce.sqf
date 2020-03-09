params ["_base", "_target"];

/*  Checks if and how the given base should reinforce the given target
*   Params:
*       _base : STRING : Name of the marker that should send units
*       _target : STRING : Name of the market that should recieve units
*
*   Returns:
*       _types : ARRAY : Array containing the possible reinforcements ways "Air" and/or "Land" or empty
*/

private _fileName = "shouldReinforce";
[
    4,
    format ["Checking if %1 should reinforce %2", _base, _target],
    _fileName
] call A3A_fnc_log;

private _types = [];

//Bases cannot reinforce themselves
if(_base isEqualTo _target) exitWith {_types};

//Carrier can only reinforce with air convoys (maybe later amphibious attacks?)
if(_base in ["NATO_carrier", "CSAT_carrier"]) exitWith {["Air"]};


private _isAirport = _base in airportsX;
private _side = sidesX getVariable [_base, sideUnknown];

//Spawned airports are not yet ready to send reinforcements
if (spawner getVariable _base != 2 || {_base in forcedSpawn}) exitWith {_types};

//Airport and in range of air support
if(_isAirport && {(getMarkerPos _base) distance2D (getMarkerPos _target) < distanceForAirAttack}) then
{
    _types pushBack "Air"
};

//To far away for land convoy or not the same island
if(([_base, _target] call A3A_fnc_isTheSameIsland) && {(getMarkerPos _base) distance2D (getMarkerPos _target) < distanceForLandAttack}) then
{
    _types pushBack "Land"
};

_types;
/* deactivated as it needs a better system
_targetIsBase = _target in outposts;
_reinfMarker = if(_side == Occupants) then {reinforceMarkerOccupants} else {reinforceMarkerInvader};

_targetReinforcements = [_target] call A3A_fnc_getRequested;
_reinfCount = [_targetReinforcements, true] call A3A_fnc_countGarrison;

_maxSend = garrison getVariable [format ["%1_recruit", _base], 0];

//Can't send enough troups
if((_reinfCount < 18) && {_maxSend < (_reinfCount * 2/3)}) exitWith {false};

//Bases should not send more than 8 troops at a time
if((_reinfCount > 8) && {!_isAirport}) exitWith {false};

//Airports only support bases with less than 4 troups //Currently deactivated
//if((_reinfCount < 4) && {_isAirport && {!_targetIsBase}}) exitWith {false};

true;
*/
