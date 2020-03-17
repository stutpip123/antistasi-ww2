params ["_marker"];

//This is the worst way to do this, find a better one
private _units = [_marker, _marker, [4,5]] call A3A_fnc_selectReinfUnits;
[_marker, _units] call A3A_fnc_addToGarrison;
