params ["_marker", "_units"];

private _insertIndex = [_marker, _units] call A3A_fnc_addToGarrison;

private _garrisonInserts = _insertIndex select 0;
private _overInserts = _insertIndex select 1;
