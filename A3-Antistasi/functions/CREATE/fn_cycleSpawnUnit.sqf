params ["_marker", "_type", "_lineIndex", "_group", "_position", "_isOver"];

private _fileName = "cycleSpawnUnit";
[
    4,
    format ["Spawning in %1 on %2 in line %3 on position %4, is over %5", _type, _marker, _lineIndex, _position, _isOver],
    _fileName
] call A3A_fnc_log;

private _unit = _group createUnit [_type, _position, [], 5, "NONE"];

//Should work as a local variable needs testing
_unit setVariable ["UnitIndex", (_lineIndex * 10 + 2)];
_unit setVariable ["UnitMarker", _marker];
_unit setVariable ["IsOver", _isOver];

//On unit death, remove it from garrison
_unit addEventHandler
[
    "Killed",
    {
        private _unit = _this select 0;
        private _id = _unit getVariable "UnitIndex";
        private _marker = _unit getVariable "UnitMarker";
        private _isOver = _unit getVariable "IsOver";
        if(_isOver) then
        {
            [_marker, typeOf _unit, _id] call A3A_fnc_removeFromOver;
        }
        else
        {
            [_marker, typeOf _unit, _id] call A3A_fnc_addToRequested;
        };
    }
];

_unit;
