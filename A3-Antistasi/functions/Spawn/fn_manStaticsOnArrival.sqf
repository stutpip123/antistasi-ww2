#define GARRISON    10
#define OVER        11
#define STATIC      12
#define MORTAR      13
#define PATROL      14
#define OTHER       15

#define IS_CREW     false
#define IS_CARGO    true

params ["_marker", "_units"];

private _gunnerUnits = [];

//Sort out all units who are able to man statics
{
    if((typeOf _x) in SDKMil) then
    {
        _gunnerUnits pushBack _x;
    };
} forEach _units;

if (count _gunnerUnits == 0) exitWith {};

private _vehicles = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
private _statics = _vehicles select {(_x select 1 select 0) == STATIC};
_statics = _statics select {isNull (gunner (_x select 0))};

if (count _statics == 0) exitWith {};

//Search for static group on the marker
private _groups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
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

while {((count _statics) != 0) && {(count _gunnerUnits) != 0}} do
{
    private _gunner = _gunnerUnits deleteAt 0;
    private _static = (_statics deleteAt 0) select 0;

    [_gunner] joinSilent _staticGroup;
    _gunner assignAsGunner _static;
    [_gunner] orderGetIn true;
};
