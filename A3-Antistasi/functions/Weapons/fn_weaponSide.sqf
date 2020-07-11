params [["_weaponConfigName", "", [""]]];

/*  Returns the sides of the given weapon

    Execution on: Server

    Called by: call

    Params:
        _weaponConfigName : STRING : The configName of the weapon to get the sides from

    Returns:
        ARRAY of STRING : Sides this weapon belongs to, might be empty
*/

private _fileName = "weaponSide";

if(_weaponConfigName == "") exitWith
{
    [1, "Got empty string as input, aborting", _fileName] call A3A_fnc_log;
    [];
};

//Get the weapons magazine wells and match them with existing ones
private _mags = missionNamespace getVariable "weaponMags";
private _magazines = getArray (configFile >> "CfgWeapons" >> _weaponConfigName >> "magazines");
private _weaponWells = [(configFile >> "CfgWeapons" >> _weapon), "magazineWell", []] call BIS_fnc_returnConfigEntry;

{
    private _mag = _x;
    private _magIndex = _mags findIf {_mag in (_x select 1)};
    if(_magIndex != -1) then
    {
        //Magazine matched to a mag well, add it
        _weaponWells pushBackUnique ((_mags select _magIndex) select 0);
    }
    else
    {
        //The magazine has no matching magWell class, add as own class
        _weaponWells pushBackUnique _mag;
    };
} forEach _magazines;

//The ingame name, this is just for the logs!
private _weaponDisplayName = getText(configFile >> "CfgWeapons" >> _weaponConfigName >> "displayName");

//Search for a perfect match, the faction mag wells need to have all wells of the weapon for a match
[true, true, true] params ["_isRebel", "_isOccupant", "_isInvader"];
if(_weaponConfigName in rebelBlockedWeapons) then
{
    [3, format ["%1 is blocked for rebels, sorting out rebel side", _weaponDisplayName], _fileName] call A3A_fnc_log;
    _isRebel = false;
};
if(_weaponConfigName in occupantBlockedWeapons) then
{
    [3, format ["%1 is blocked for occupants, sorting out rebel side", _weaponDisplayName], _fileName] call A3A_fnc_log;
    _isOccupant = false;
};
if(_weaponConfigName in invaderBlockedWeapons) then
{
    [3, format ["%1 is blocked for invaders, sorting out rebel side", _weaponDisplayName], _fileName] call A3A_fnc_log;
    _isInvader = false;
};

{
    private _well = _x;
    if(_isRebel) then
    {
        if !(_well in rebelWeaponWells) then
        {
            _isRebel = false;
        };
    };
    if(_isOccupant) then
    {
        if !(_well in occupantWeaponWells) then
        {
            _isOccupant = false;
        };
    };
    if(_isInvader) then
    {
        if !(_well in invaderWeaponWells) then
        {
            _isInvader = false;
        };
    };
    //No match to any faction
    if(!(_isRebel) && !(_isOccupant) && !(_isInvader)) exitWith {};
} forEach _weaponWells;

private _sides = [];
if(_isRebel) then {_sides pushBack "rebel"};
if(_isOccupant) then {_sides pushBack "occupant"};
if(_isInvader) then {_sides pushBack "invader"};

[3, format ["Side check for %1 will return %2", _weaponDisplayName, _sides], _fileName] call A3A_fnc_log;

_sides;
