params ["_type", "_marker"];

/*  Updates the max amount of statics available to the marker
*   Params:
*       _type : STRING : The type of the marker, one of Airport, Outpost, City or Other
*       _marker : STRING : The name of the marker
*
*   Returns:
*       Nothing
*/

private _fileName = "updateStatics";

private _staticPerc = garrison getVariable [format ["%1_staticPerc", _type], 1];

//Blame spoffy for this construct here
while {isNil {spawner getVariable (format ["%1_current", _marker])}} do {sleep 1; diag_log "sta";};
private _currentPlaces = spawner getVariable (format ["%1_current", _marker]);
while {isNil {spawner getVariable (format ["%1_available", _marker])}} do {sleep 1; diag_log "b";};
private _availablePlaces = spawner getVariable (format ["%1_available", _marker]);

private _staticCount = ceil ((_availablePlaces select 4) * _staticPerc);
private _statics = garrison getVariable [format ["%1_statics", _marker], []];
for "_i" from (count _statics) to (_staticCount - 1) do
{
    private _spawnParams = [_marker, "Static"] call A3A_fnc_findSpawnPosition;
    _statics pushBack [_spawnParams, -1];
};
garrison setVariable [format ["%1_statics", _marker], _statics, true];
_currentPlaces set [4, _staticCount];

private _mortarCount = ceil ((_availablePlaces select 3) * _staticPerc);
private _mortars = garrison getVariable [format ["%1_mortars", _marker], []];
for "_i" from (count _statics) to (_mortarCount - 1) do
{
    private _spawnParams = [_marker, "Mortar"] call A3A_fnc_findSpawnPosition;
    _mortars pushBack [_spawnParams, -1];
};
garrison setVariable [format ["%1_mortars", _marker], _mortars, true];
_currentPlaces set [3, _mortarCount];
