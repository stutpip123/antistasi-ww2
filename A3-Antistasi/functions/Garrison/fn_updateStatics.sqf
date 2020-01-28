params ["_marker", "_type"];

private _staticPerc = garrison getVariable [format ["%1_statics", _type], 1];

//Blame spoffy for this construct here
while {isNil {spawner getVariable (format ["%1_current", _marker])}} do {sleep 1; diag_log "a";};
private _currentPlaces = spawner getVariable (format ["%1_current", _marker]);
while {isNil {spawner getVariable (format ["%1_available", _marker])}} do {sleep 1; diag_log "b";};
private _availablePlaces = spawner getVariable (format ["%1_available", _marker]);

private _staticCount = ceil ((_availablePlaces select 4) * _staticPerc);

_currentPlaces set [4, _staticCount];
