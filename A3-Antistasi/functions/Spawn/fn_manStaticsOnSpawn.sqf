params ["_marker"];

private _vehicles = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
private _statics = _vehicles select {(_x select 1 select 0) == STATIC};
_statics = _statics select {isNull (gunner _x)};

private _groups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
private _cargoGroups = _groups select {((_x select 1 select 0) == OVER) && {(_x select 1 select 2) == IS_CARGO}};

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

private _gunners = [];
{
    private _group = _x select 0;
    private _units = (units _group);
    private _unitIndex = _units findIf {typeOf _x in SDKMil};
    if(_unitIndex != -1) exitWith
    {
        _gunners pushBack _x;
    };
} forEach _cargoGroups;

while {((count _statics) != 0) && {(count _gunners) != 0}} do
{
    private _gunner = _gunners deleteAt 0;
    private _static = _statics deleteAt 0;

    [_gunner] joinSilent _staticGroup;
    _gunner assignAsGunner _static;
    _gunner orderGetIn true;
};
