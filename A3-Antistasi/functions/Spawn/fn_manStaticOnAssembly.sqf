#define GARRISON    10
#define OVER        11
#define STATIC      12
#define MORTAR      13
#define PATROL      14
#define OTHER       15

#define IS_CREW     false
#define IS_CARGO    true

params ["_marker", "_static"];

//Search for unit groups on the marker
private _groups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
private _cargoGroups = _groups select {((_x select 1 select 0) == OVER) && {(_x select 1 select 2) isEqualTo IS_CARGO}};

private _staticGroup = _groups findIf {(_x select 1 select 0) == STATIC};
if(_staticGroup == -1) then
{
    //Create new static group and add it to the marker
    _staticGroup = createGroup teamPlayer;
    _groups pushBack [_staticGroup, [STATIC, -1]];
    spawner setVariable [format ["%1_groups", _marker], _groups, true];
}
else
{
    _staticGroup = _groups select _staticGroup select 0;
};

private _unit = objNull;
{
    private _group = _x select 0;
    private _units = (units _group);
    private _unitIndex = _units findIf {typeOf _x in SDKMil};
    _unit = _units select _unitIndex;
    if(isNull (objectParent _unit)) exitWith {};
    _unit = objNull;
} forEach _cargoGroups;

[_unit] joinSilent _staticGroup;
_unit assignAsGunner _static;
[_unit] orderGetIn true;
