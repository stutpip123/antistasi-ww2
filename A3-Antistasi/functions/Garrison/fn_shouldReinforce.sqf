#define AIR         0
#define LAND_CONVOY 1   //LAND is an internal command and can't be used
#define FAST_ROPE   2
#define AMPHIBIOUS  3
#define LAND_REQ    4
#define AIR_REQ     5

params ["_base", "_target"];

/*  Checks if and how the given base should reinforce the given target
*   Params:
*       _base : STRING : Name of the marker that should send units
*       _target : STRING : Name of the market that should recieve units
*
*   Returns:
*       _types : ARRAY : Array containing the possible reinforcements ways
*/

private _fileName = "shouldReinforce";
[3, format ["Checking if %1 should reinforce %2", _base, _target], _fileName] call A3A_fnc_log;

private _types = [];

//Bases cannot reinforce themselves
if(_base isEqualTo _target) exitWith
{
    [
        3,
        "Target and origin base are the same, bases cannot reinforce themselves",
        _fileName
    ] call A3A_fnc_log;
    _types
};

/* More more problems than it is worth
private _targetReinforcements = [_target] call A3A_fnc_getRequested;
private _reinfCount = [_targetReinforcements, true] call A3A_fnc_countGarrison;
private _maxSend = garrison getVariable [format ["%1_recruit", _base], 0];

if(_maxSend < 15 && (((2/3) * _reinfCount) > _maxSend)) exitWith
{
    [
        3,
        format ["%1 can send less then 15 units, but %2 requires %3. There might be better bases", _base, _target, _reinfCount],
        _fileName
    ] call A3A_fnc_log;
    _types
};
*/

/*  The logic should take care of it without it being a special case
//Carrier can only reinforce with air convoys and in ongoing versions with amphibious ones (maybe)
if(_base in ["NATO_carrier", "CSAT_carrier"]) exitWith
{
    [
        3,
        format ["%1 is carrier marker, it can only send air and amphibious attacks", _base],
        _fileName
    ] call A3A_fnc_log;
    [AIR, AMPHIBIOUS]
};
*/

private _side = sidesX getVariable [_base, sideUnknown];

//Spawned airports are not yet ready to send reinforcements
if (spawner getVariable _base != 2 || {_base in forcedSpawn}) exitWith
{
    [
        3,
        format ["%1 is currently spawned in, therefor not allowed to send units", _base],
        _fileName
    ] call A3A_fnc_log;
    _types
};

private _isAirport = _base in (airportsX + ["NATO_carrier", "CSAT_carrier"]);

//Airport and in range of air support
private _canBeAir = false;
if(_isAirport && {(getMarkerPos _base) distance2D (getMarkerPos _target) < distanceForAirAttack}) then
{
    _canBeAir = true;
};

//Check if in range for a land convoy
private _canBeLand = false;
if((getMarkerPos _base) distance2D (getMarkerPos _target) < distanceForLandAttack) then
{
    _canBeLand = true;
};

private _hasFreeSpaceForType = [_target] call A3A_fnc_checkForFreeSpaces;
if(_canBeAir) then
{
    _types pushBack AIR_REQ;
    if (_hasFreeSpaceForType select 1) then
    {
        _types pushBack AIR
    }
    else
    {
        _types pushBack FAST_ROPE;
    };
};

if(_canBeLand) then
{
    if ([_base, _target] call A3A_fnc_isTheSameIsland) then
    {
        _types pushBack LAND_REQ;
    };
    if (_hasFreeSpaceForType select 0) then
    {
        if ([_base, _target] call A3A_fnc_isTheSameIsland) then
        {
            _types pushBack LAND_CONVOY;
        }
        else
        {
            _types pushBack AMPHIBIOUS;
        };
    };
};

[
    3,
    format ["%1 can send units, possible ways are: %2", _base, _types],
    _fileName
] call A3A_fnc_log;

_types;
