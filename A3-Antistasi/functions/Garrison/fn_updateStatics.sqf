params ["_marker", "_type"];

/*  Updates the max amount of statics available to the marker
*   Params:
*       _marker : STRING : The name of the marker
*       _type : STRING : The type of the marker, one of Airport, Outpost, City or Other
*
*   Returns:
*       Nothing
*/

private _staticPerc = garrison getVariable [format ["%1_statics", _type], 1];

//Blame spoffy for this construct here
while {isNil {spawner getVariable (format ["%1_current", _marker])}} do {sleep 1; diag_log "a";};
private _currentPlaces = spawner getVariable (format ["%1_current", _marker]);
while {isNil {spawner getVariable (format ["%1_available", _marker])}} do {sleep 1; diag_log "b";};
private _availablePlaces = spawner getVariable (format ["%1_available", _marker]);

private _staticCount = ceil ((_availablePlaces select 4) * _staticPerc);

[
    3,
    format ["Setting static count for %1 to %2", _marker, _staticCount],
    _fileName
] call A3A_fnc_log;

_currentPlaces set [4, _staticCount];
